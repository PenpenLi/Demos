
-- initialize
Animation = class(Object);

function Animation:ctor(armature)
    self.armature = armature; -- of <Armature>

	self.movementID = nil; -- of <String>
	self.movementList = nil; -- of {String}
	
	self.animationData = nil; -- of <AnimationData>
	self.movementData = nil; -- of <MovementData>

	self.isComplete = true; --Indicates whether the animation is completed
	self.isPause = false; --Indicates whether the animation is paused
	
	self.class = Animation;
end

function Animation:toString()
	return "Animation";
end

function Animation:dispose()
	self.movementID = nil;
	self.movementList = nil;
	
	self.animationData = nil;
	self.movementData = nil;
	
	self.armature = nil;
	self:removeSelf();
end

function Animation:setData(animationData)
	if animationData then
		self:stop();
		self.animationData = animationData;
		self.movementList = animationData.movementList;
	end
end

function Animation:stop()
	self.isPause = true;
	
	--pause children
	local list = self.armature.boneDepthList;
	for k, v in pairs(list) do
		v.tween:stop();
	end
end

function Animation:play()
	if not self.animationData then return end;
	if not self.movementID then self:gotoAndPlay(self.movementList[1]) end;

	if self.isPause then
		if self.isComplete then
			self.isComplete = false;
		end
		self.isPause = false;

		local list = self.armature.boneDepthList;
		for k, v in pairs(list) do
			v.tween:play();
		end
	else
		if self.isComplete then self:gotoAndPlay(self.movementID) end;
	end
end

function Animation:gotoAndPlay(movementID, loop)
	if (not self.animationData) then return end;
	if type(movementID) ~= "string" then return end;

	local movData = self.animationData:getMovementData(movementID);
	if not movData then return end;

	self.movementData = movData;
	self.movementID = movementID;

	self.isComplete = false;
	self.isPause = false;
	
	local isLoop = true;
	if loop ~= nil then isLoop = loop end;
	
	local list = self.armature.boneDepthList;
	for k, v in pairs(list) do
		local movementBoneData = movData:getMovementBoneData(v.name);
		if movementBoneData then
			v.tween:gotoAndPlay(movementBoneData, isLoop, movData.durationTween);
			
			local childArmature = v:getChildArmature();
			if childArmature then childArmature.animation:gotoAndPlay(movementID) end;
		else
		    --movementBoneData not found
			if v.origin.name then
				v:changeDisplay(-1);
				v.tween:stop();
			end
		end
	end
end

--[[
function Animation:update()
	if self.isComplete or self.isPause then return end;
	self.isComplete = true;
end
]]