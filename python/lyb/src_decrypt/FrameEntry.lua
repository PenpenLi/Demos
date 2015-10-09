FrameEntry = class();
--技能动作
function FrameEntry:ctor(totalFrame,backFrame)
	self.class = FrameEntry;
	self.totalFrame = totalFrame;
	self.backFrame = backFrame;
end

function FrameEntry:removeSelf()
	self.class = nil;
end

function FrameEntry:dispose()
    self:removeSelf();
end

function FrameEntry:getTotalFrame()
	return self.totalFrame;
end

function FrameEntry:getBackFrame()
	return self.backFrame;
end


ArtsFrameConfigContext = class(Object);

function ArtsFrameConfigContext:ctor()
	self.class = ArtsFrameConfigContext;
end

rawset(ArtsFrameConfigContext,"instance",nil);
rawset(ArtsFrameConfigContext,"getInstance",
	function()
		if ArtsFrameConfigContext.instance then
	else
		rawset(ArtsFrameConfigContext,"instance",ArtsFrameConfigContext.new());
	end
	return ArtsFrameConfigContext.instance;
	end);

function ArtsFrameConfigContext:cleanSelf()
	self.class = nil;
end

function ArtsFrameConfigContext:dispose()
	self.cleanSelf();
end

function ArtsFrameConfigContext:getCartoonTotalTime(key)
	if not self.animationData then
		self:hasAnimationData()
	end
	local entry = self.map[key];
	if entry then
		return entry:getTotalFrame();
	else
		local totalFrame = self.animationData[key]
		if not totalFrame then return 0 end
		--log("================totalFrame========key===="..key)
		local backFrame = -1;
		--Math.round(1000 * totalFrame / ApplicationConstants.CLIENT_FRAME_TIME),
		--Math.round(1000 * backFrame / ApplicationConstants.CLIENT_FRAME_TIME)
		local entry = FrameEntry.new(math.ceil(1000 * totalFrame / BattleConstants.Animate_Fream),math.ceil(1000 * backFrame / BattleConstants.Animate_Fream));
		self.map[key] = entry;
		return entry:getTotalFrame();
	end
end

function ArtsFrameConfigContext:hasAnimationData()
	local luaFileName = "resource.image.arts.animationData"
    if GameData.connectType ~= 0 then
        package.loaded[luaFileName] = nil
    end
    require(luaFileName)
    self.animationData = animationData;
    self.map = {}
end