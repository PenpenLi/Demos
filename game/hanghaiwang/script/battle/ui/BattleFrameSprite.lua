-- 基于spriteFrame的CCSprite
local BattleFrameSprite = class("BattleFrameSprite",function () return CCSprite:create() end)
 
	------------------ properties ----------------------
	BattleFrameSprite.frameName 		= nil -- 帧名

	------------------ functions -----------------------
	-- ax,ay 分别对应锚点 :setAnchorPoint(ccp(x,y))
	function BattleFrameSprite:reset(frameName,ax,ay)
		
		self:setFrameByName(frameName)
		ax = ax or 0.5
		ay = ay or 0.5

		self:setAnchorPoint(ccp(ax, ay))
		self:setCascadeOpacityEnabled(true)
	end

	function BattleFrameSprite:setFrameByName( frameName )
		if(self.frameName ~= frameName) then
			self.frameName 		= frameName
			local cache 	 	= CCSpriteFrameCache:sharedSpriteFrameCache()
			local frameData  	= cache:spriteFrameByName(frameName)
			if(frameData) then
	 		    self:setDisplayFrame(frameData)
	 		else
	 			 Logger.debug("can not find :" .. frameName)
			end
		end
	end
return BattleFrameSprite