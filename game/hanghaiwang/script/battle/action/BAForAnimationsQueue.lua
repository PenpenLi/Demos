

-- 在英雄身上添加特效(播完不删除)

require (BATTLE_CLASS_NAME.class)
local BAForAnimationsQueue = class("BAForAnimationsQueue",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForAnimationsQueue.list 					= nil
 	BAForAnimationsQueue.total 					= nil
 	BAForAnimationsQueue.index 					= nil
 	BAForAnimationsQueue.position 				= nil
 	BAForAnimationsQueue.animation 				= nil
 	BAForAnimationsQueue.heroUI 				= nil
 	BAForAnimationsQueue.atPostion  			= nil
 	------------------ functions -----------------------
 	function BAForAnimationsQueue:start( )

 		if(self.list ~= nil and #self.list > 0 and self.heroUI) then
 			self.total = self.list
 			self.index = 1 	
 			self.total = #self.list
 			self:runNext()
 		else
 			self:complete()
 		end	
 	end

 	function BAForAnimationsQueue:runNext( ... )
 		Logger.debug("BAForAnimationsQueue runNext: " .. self.index .. " total:" .. self.total)
 		if(self.index <= self.total) then
	 		local nextAnimationName = self.list[self.index]
	 		self.index = self.index + 1

	 		local startTime = os.clock()


	 		self.animation = ObjectTool.getAnimation(nextAnimationName,false)

	 		local endTime = os.clock()
		 	Logger.debug("**** animation "..nextAnimationName .. " ini cost cpu time:"..endTime - startTime)
	 		self.animation:setAnchorPoint(ccp(0.5,0.1))
			local fnMovementCall = function ( sender, MovementEventType )
						 
					Logger.debug("BAForAnimationsQueue evt:" .. MovementEventType .." self.disposed:" .. tostring(self.disposed))
			 		if (MovementEventType == EVT_COMPLETE or MovementEventType == EVT_LOOP_COMPLETE) then 
							if(self.animation ~= nil and self.animation:getParent() ~= nil and self.animation:retainCount() > 0) then
								self.animation:removeFromParentAndCleanup(true)
							end

							if(self.disposed ~= true) then
								self:onOneAnimationEnd()
							end
					end

			 end
 
	 		self.animation:getAnimation():setMovementEventCallFunc(fnMovementCall)

	 		local postion  
            if(self.atPostion == BATTLE_CONST.POS_FEET) then
           		--self.animation:setAnchorPoint(CCP_ZERO)
           		postion = self.heroUI:globalFeetPoint()
           		-- local cc = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
           		-- BattleLayerManager.battleAnimationLayer:addChild(cc)
           		-- cc:setPosition(postion.x,postion.y)
           		----print("BAForPlayEffectAtHero is feet:",postion.x," ",postion.y)

            elseif (self.atPostion == BATTLE_CONST.POS_HEAD)then
            	postion = self.heroUI:globalHeadPoint()
            	self.animation:setPosition(postion.x,postion.y)
            elseif (self.atPostion == nil or self.atPostion == BATTLE_CONST.POS_MIDDLE)then

            	postion = self.heroUI:globalCenterPoint()
            end
            self.animation:setPosition(postion.x,postion.y)
          
 
			BattleLayerManager.battleAnimationLayer:addChild(self.animation)
		 

	 	else
	 		self:complete()
	 	end



 	end


 	function BAForAnimationsQueue:onOneAnimationEnd( )
 		if(self.disposed ~= true) then
 			self:runNext()
 		end
 	end


 	function BAForAnimationsQueue:setList(animationNames)
 		self.list = animationNames
 	end


 	function BAForAnimationsQueue:release( ... )
 		self.super.release(self)
 		 
		if(self.animation ~= nil and self.animation:getParent() ~= nil and self.animation:retainCount() > 0) then
			self.animation:removeFromParentAndCleanup(true)
		end
		self.animation = nil
 		 
 	end


 return BAForAnimationsQueue