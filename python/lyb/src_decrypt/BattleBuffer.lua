BattleBuffer = class(Layer);

function BattleBuffer:ctor()
	self.class = BattleBuffer;  
	self.effectImgArray = {}
end

function BattleBuffer:dispose()
    self:removeAllEventListeners();
    self:removeChildren();
    BattleBuffer.superclass.dispose(self);
end

function BattleBuffer:refreshBuffer(effectArray)
	self:removeAllEffect()
	local effectNum = 0;
	for key,effectID in pairs(effectArray) do
		local xiaoguoPO = analysis("Jineng_Jinengxiaoguo",effectID);
		if xiaoguoPO.pic ~= 0 then
			local picImg = Image.new();
			picImg:load(artData[xiaoguoPO.pic].source);
			local size = picImg:getContentSize()
			--picImg:setPositionXY(-size.width/2,effectNum*50);
			self:addChild(picImg);
			table.insert(self.effectImgArray,picImg)
		end
		-- if xiaoguoPO.arrow ~= 0 then
		-- 	local arrowImg = Image.new();
		-- 	arrowImg:load(artData[xiaoguoPO.arrow].source);
		-- 	local size = arrowImg:getContentSize()
		-- 	arrowImg:setPositionXY(-size.width/2 + 50,effectNum*50);
		-- 	self:addChild(arrowImg);
		-- 	table.insert(self.effectImgArray,arrowImg)
		-- end
		--effectNum = effectNum + 1
		local count = #self.effectImgArray*0.5+1;
		for i,v in ipairs(self.effectImgArray) do
			v:setPositionX((i-count)*25);
		end
	end
end

function BattleBuffer:removeAllEffect()
	for key,value in pairs(self.effectImgArray) do
		self:removeChild(value)
	end
	self.effectImgArray = {}
end