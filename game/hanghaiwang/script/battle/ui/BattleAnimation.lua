

require (BATTLE_CLASS_NAME.class)
local BattleAnimation = class("BattleAnimation",function () return CCSprite:create() end)
 
	------------------ properties ----------------------
	BattleAnimation.animationName 			= nil
	BattleAnimation.animation 				= nil
	BattleAnimation.calllerBacker 			= nil
	BattleAnimation.isOldAnimation 			= nil
	BattleAnimation.calllerBacker 			= nil
	------------------ functions -----------------------
	function BattleAnimation:ctor( ... )
		 
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	

	end
	function BattleAnimation:createAnimation(animationName,loop,anchorPoint)

		anchorPoint = anchorPoint or 0.5
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	

		self.animationName = animationName
		if(loop == nil) then
			self.loop = false 
		else 
			self.loop = loop
		end
			
			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
 			if(filesExists == true) then 

 				 
	 			self.animation = ObjectTool.getAnimation(self.animationName,false)
	 			BattleSoundMananger.playEffectSound(self.animationName)
	 			 
 			
	 			fnMovementCall = function ( sender, MovementEventType )
										if (MovementEventType == COMPLETE) then
											 BattleSoundMananger.removeSound(self.animationName)
										 	self:runCompleteCall()
										end
										if(self.loop == false) then
											self:release()
										end
								end

	 			
	 			if(self.loop) then
	  				self.animation:getAnimation():playWithIndex(0,0,-1,1)
	  			else
	  				self.animation:getAnimation():playWithIndex(0,-1,-1,0)
	  			end
	  			self.animation:getAnimation():setMovementEventCallFunc(fnMovementCall)
	  			self:addChild(self.animation)
	  			self.isOldAnimation = false
  			
 			else
 				self:runCompleteCall()
	 			return 
 			end
 
	           
 	-- 	end
 		if(self.animation) then
 			self.animation:setAnchorPoint(ccp(anchorPoint,anchorPoint))
 		end
 		 

	end -- function end 
	function BattleAnimation:addCallBacker(target,callback)
		self.calllerBacker:addCallBacker(target,callback)
	end
	function BattleAnimation:runCompleteCall(data)
		-- --print("BaseAction:runCompleteCall：",data)
		self.calllerBacker:runCompleteCallBack(self,data)
	end

	function BattleAnimation:releaseAnimation( printState )
		Logger.debug("BattleAnimation: isOldAnimation ->" .. tostring(self.isOldAnimation))
		if(self.animation) then
			if(self.animation.getAnimation) then
				self.animation:getAnimation():stop()
				if(printState) then
					Logger.debug("self.animation:getAnimation():stop()")
				end
			end
			
			if(self.animation:getParent()) then

				self.animation:removeFromParentAndCleanup(true)
				if(printState) then
					Logger.debug("BattleAnimation:release ->" .. tostring(self.animation:getParent() ~=nil))
				end
			end
			self.animation = nil
		end
		if(self.calllerBacker) then
			self.calllerBacker:clearAll()
		end
		self.animationName = nil
	end


return BattleAnimation