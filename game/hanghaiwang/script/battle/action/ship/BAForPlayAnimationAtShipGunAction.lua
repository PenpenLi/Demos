

	
-- 在英雄身上播放特效

require (BATTLE_CLASS_NAME.class)
local BAForPlayAnimationAtShipGunAction = class("BAForPlayAnimationAtShipGunAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForPlayAnimationAtShipGunAction.shipUI					= nil	-- 目标(BattleObjectDisplay)
	BAForPlayAnimationAtShipGunAction.animation 				= nil 	-- 动画实例
	BAForPlayAnimationAtShipGunAction.animationName 			= nil 	-- 动画名称
	BAForPlayAnimationAtShipGunAction.loop 						= nil	-- 循环
	BAForPlayAnimationAtShipGunAction.total 					= 25
	BAForPlayAnimationAtShipGunAction.current 					= 0
	BAForPlayAnimationAtShipGunAction.soundName 				= nil 	-- 指定播放音效
	BAForPlayAnimationAtShipGunAction.delay						= nil
	BAForPlayAnimationAtShipGunAction.rotation					= nil
	-- BAForPlayAnimationAtShipGunAction.
	------------------ functions -----------------------

	function BAForPlayAnimationAtShipGunAction:start(data)
	 	
	 	print("BAForPlayAnimationAtShipGunAction animation start: ",self.animationName,self.shipUI)
		if(self.shipUI~= nil and 
		   self.animationName ~= nil and self.animationName ~= "" and self.animationName ~= "nil" and self.disposed ~= true) then
 			
 			self:ini()
 			self:addToRender()

        else
        	self:complete()
        	print("BAForPlayAnimationAtShipGunAction animation :%s is error",self.animationName)
		end
 	end

 	function BAForPlayAnimationAtShipGunAction:ini( ... )
        if(self.animation == nil) then
            local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
                if(filesExists == true) then 
                        
                        self.total 								= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName) * 1/60
                        
                        self.animation = ObjectTool.getAnimation(self.animationName,false)
                        
                        self.current = 0
                        if(self.rotation ~= nil) then
                            self.animation:setRotation(self.rotation)
                        else
                        	self.animation:setRotation(0)
                        end
                        
                        if(self.soundName ~= nil and self.soundName ~= "") then
                            -- Logger.debug("-- rage bar play sound:" .. self.rageBarMusic)
                            BattleSoundMananger.removeSound(self.soundName)
                            BattleSoundMananger.playEffectSound(self.soundName,false)
                        else

                            BattleSoundMananger.playEffectSound(self.animationName)
                        end
                else
                        Logger.debug("未发现特效:" .. self.animationName)
                        self:complete()
                        return
                end
                
                local postion  							= self.shipUI:getGunLinkEffPos()
                self.animation:setPosition(postion.x,postion.y)
            		
            	BattleLayerManager.addNode(self.animationName,self.animation)
                self.animation:getAnimation():playWithIndex(0,-1,-1,0)
 
            end
 	end

 	function BAForPlayAnimationAtShipGunAction:update( dt )
 		

 		if(self.delay ~= nil and self.delay >= 0) then 
 			self.delay = self.delay - 1 
 			 
 			if(self.delay < 0) then
 				self:ini()
 				-- self.animation:setVisible(true)
 				self.animation:getAnimation():gotoAndPlay(2)
 			end
 			
 			return
 		 
 		end


 		self.current = self.current + dt
 		-- self.animation:getAnimation():stop()
 		-- self.animation:getAnimation():gotoAndPause(self.current)
 		if(self.current >= self.total + 0.1) then 
 			-- --print(" BAForPlayAnimationAtShipGunAction:update complete")
 			-- self.animation:getAnimation():stop()
 			
 			if(self.animation) then
 			 	ObjectSharePool.addObject(self.animation,self.animationName)
 			end
 			ObjectTool.removeObject(self.animation,false)
 			self.animation = nil
 			
 			if(self.soundName ~= nil and self.soundName ~= "") then
                BattleSoundMananger.removeSound(self.soundName)
            else
                BattleSoundMananger.removeSound(self.animationName)
            end

 			self:complete()
 			BattleLayerManager.checkBatchMap()
 			 
 		end
 	end
 	-- 释放函数
	function BAForPlayAnimationAtShipGunAction:release(data)
		self:removeFromRender()

		if(self.animation) then
			BattleMainData.downCountEffect(self.animationName)
			 -- --self.animation:setDelegate(nil)
			 -- local cn = tolua.cast(self.animation,"CCNode")
			 -- if(cn and cn:getParent()) then
			 -- 	cn:removeFromParentAndCleanup(true)
			 -- end
			 
			 if(self.animation) then
 			 	ObjectSharePool.addObject(self.animation,self.animationName)
 			end
 			ObjectTool.removeObject(self.animation,false)
			 	-- self.animation:removeFromParentAndCleanup(true)
	         -- local cn = tolua.cast(self.animation,"CCNode")
	         -- cn:removeAllChildrenWithCleanup(true)
	         self.animation 			= nil
			 -- self.animationName 		= nil
		end -- if end
		self.shipUI 					= nil

		self.disposed 	= true
 
		self.calllerBacker:clearAll()
		self.blockBoard	= nil
		BattleLayerManager.checkBatchMap()
	end 



return BAForPlayAnimationAtShipGunAction
