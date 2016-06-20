-- 替补ui中的头像


require (BATTLE_CLASS_NAME.class)
-- local BattleBenchInfoIcon = class("BattleBenchInfoIcon",function () return CCNodeRGBA:create() end)
-- local BattleBenchInfoIcon = class("BattleBenchInfoIcon",function () return CCLayerRGBA:create() end)
local BattleBenchInfoIcon = class("BattleBenchInfoIcon",function () return CCSprite:create() end)
  
 	------------------ properties ----------------------
 	BattleBenchInfoIcon.displayData				= nil
 	BattleBenchInfoIcon.headURL					= nil
 	BattleBenchInfoIcon.backURL					= nil
 	BattleBenchInfoIcon.backUI					= nil
 	BattleBenchInfoIcon.headUI					= nil
 	BattleBenchInfoIcon.id						= nil
 	BattleBenchInfoIcon.isDead					= nil
 	BattleBenchInfoIcon.reviveEffect			= nil -- 复活特效
 	------------------ functions -----------------------
 	
 	function BattleBenchInfoIcon:reset( data )
 		self:setAnchorPoint(ccp(0,1))
 		self.displayData = data
 		if(self.displayData) then
 			self:setCascadeOpacityEnabled(true)
        	self:setCascadeColorEnabled(true)
 			-- local displayData = BattleDataUtil.getBenchDisplayData(self.displayData)
 			self.id			= self.displayData.id
 			self.headURL	= self.displayData.headURL
 			self.backURL	= self.displayData.bgURL
 			self:createUI()
 			self:setVisible(true)
 			self:refreshDeadState()
 		else
 			self:removeUI()
 			self:setVisible(false)
 		end
 	end


 	function BattleBenchInfoIcon:getAABBBox( ... )
	    local boundingBox = require(BATTLE_CLASS_NAME.BaseBoundingBox).new()

	    if(self.backUI) then
		    local world = self.backUI:convertToWorldSpace(CCP_ZERO)
		    local size  = self.backUI:getContentSize()
		    local p 	= self.backUI:getAnchorPoint()
		    local scale = self:getScale()
		    -- print("--- icon scale:",scale)
		    -- boundingBox:iniWithData(world.x - p.x * size.width * scale,world.y - p.y * size.height * scale
		    -- 						,size.width * scale ,size.height * scale)
			boundingBox:iniWithData(world.x ,world.y 
		    						,size.width * scale ,size.height * scale)
		end
	    return boundingBox  
 	end

 	-- local position hit test
 	function BattleBenchInfoIcon:hitTest( position )
 		if(position and self.backUI) then
 			local w = self.backUI:getContentSize().width
 			local h = self.backUI:getContentSize().height
 			-- 碰撞检测
 				local minX = self.backUI:getPositionX() - w/2
 				local maxX = self.backUI:getPositionX() + w/2

 				local minY = self.backUI:getPositionY() - h
 				local maxY = self.backUI:getPositionY()

	             if(position.x >= minX and
	                position.y >= minY and
	                position.x <= maxX and
	                position.y <= maxY
	                ) then

	             	return true
	         	 end
	         return false
 		end
 		return false
 	end
 	function BattleBenchInfoIcon:refreshDeadState( ... )
 		if(self.displayData) then
 			if(BattleMainData.fightRecord) then
 				local targetData = BattleMainData.fightRecord:getTargetData(tonumber(self.displayData.id))
	 			if(targetData) then
	 				local oldState  = self.isDead

		 			self.isDead		= targetData:isDead()
		 			
		 			if(self.isDead == false and oldState == true) then
		 				self:showReviveEffect()
		 			end

		 			if(self.backUI) then
		 				self.backUI:setGray(self.isDead)
		 				-- self.backUI:setGray(true)
		 			end

		 			if(self.headUI) then
		 				self.headUI:setGray(self.isDead)
		 				-- self.headUI:setGray(true)
		 			end
		 		else
		 			error("未发现替补:" .. tostring(self.displayData.id))
		 		end

	 		end
 			
 		end -- if
 	end -- function
 	function BattleBenchInfoIcon:showReviveEffect( ... )


 		local globalPosition = self.backUI:convertToWorldSpace(ccp(self.backUI:getContentSize().width/2,self.backUI:getContentSize().height/2))
 		-- local globalPosition = self.backUI:convertToWorldSpace(CCP_ZERO)
 			

 		if(self.reviveEffect) then self.reviveEffect:release() end
 			
		self.reviveEffect 					= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
		self.reviveEffect.animationName  	= BATTLE_CONST.BENCH_UI_REVIVE_EFFECT
		self.reviveEffect.postionX	   		= globalPosition.x
		self.reviveEffect.postionY 	   		= globalPosition.y
		self.reviveEffect.container 		= BattleLayerManager.battleUILayer
		-- self.reviveEffect.container 		= self
		-- self.reviveEffect:setAnchorPoint(ccp(0.5,1))

		BattleActionRender.addAutoReleaseAction(self.reviveEffect)
 	end
 	function BattleBenchInfoIcon:createUI( ... )
 		-- self:removeUI()
 		if(self.backUI == nil) then
 			self.backUI = CCSprite:create(self.backURL)
 			self.backUI:setGray(false)
 			self.backUI:setAnchorPoint(ccp(0.5,1))
 			BattleNodeFactory.regeistTextureURL(self.backURL)
 		end

 		if(self.headUI == nil) then
 			self.headUI = CCSprite:create(self.headURL)
 			self.headUI:setGray(false)
 			self.headUI:setAnchorPoint(ccp(0.5,1))
 			BattleNodeFactory.regeistTextureURL(self.headURL)
 		end

 		if(self.backUI:getParent() == nil) then
 			self:addChild(self.backUI)
 		end

 		if(self.headUI:getParent() == nil) then
 			self:addChild(self.headUI)
 		end

 		self:setScale(0.8)
 		self.headUI:setPosition(ccp(0,(self.headUI:getContentSize().height - self.backUI:getContentSize().height)/2))


 	end

 	function BattleBenchInfoIcon:getSize( )
 		if(self.backUI) then
 			return self.backUI:getContentSize()
 		end
 	end

 	function BattleBenchInfoIcon:removeUI( ... )
 		ObjectTool.removeObject(self.backUI)
 		ObjectTool.removeObject(self.headUI)
 		self.backUI = nil
 		self.headUI = nil
 	end

 	function BattleBenchInfoIcon:dispose( ... )
 		self:removeUI()
 		self.displayData = nil
 	end


 return BattleBenchInfoIcon
