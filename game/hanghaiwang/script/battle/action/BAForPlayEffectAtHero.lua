	
-- 在英雄身上播放特效

require (BATTLE_CLASS_NAME.class)
local BAForPlayEffectAtHero = class("BAForPlayEffectAtHero",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForPlayEffectAtHero.heroUI					= nil	-- 目标(BattleObjectDisplay)
	BAForPlayEffectAtHero.atPostion 				= nil   -- 人物身上的挂点
	BAForPlayEffectAtHero.animation 				= nil 	-- 动画实例
	BAForPlayEffectAtHero.animationName 			= nil 	-- 动画名称
	BAForPlayEffectAtHero.loop 						= nil	-- 循环
	BAForPlayEffectAtHero.total 					= 25
	BAForPlayEffectAtHero.current 					= 0
	BAForPlayEffectAtHero.rotation 					= nil
	BAForPlayEffectAtHero.downTarget				= nil
	BAForPlayEffectAtHero.soundName 				= nil 	-- 指定播放音效
	BAForPlayEffectAtHero.delay						= nil
	-- BAForPlayEffectAtHero.
	------------------ functions -----------------------
 

	function BAForPlayEffectAtHero:start(data)
	 	
		if(self.heroUI~= nil and 
		   self.animationName ~= nil and self.animationName ~= "" and self.animationName ~= "nil" and self.disposed ~= true) then
			-- print("BAForPlayEffectAtHero:start animation:",self.animationName)
			-- 
			if(self.animation ~= nil) then error("dub") end
		 
			-- Logger.debug("特效:" .. self.animationName)

			
			if(self.delay == nil or self.delay <= 0) then
				self.delay = BattleMainData.upCountEffectAndGetDelay(self.animationName)
				-- print("=== effect at hero delay:",self.animationName,self.delay )
			end
			if(self.delay == nil or self.delay < 1) then 
				-- if(self.animation ~= nil) then
	 		-- 		self.animation:setVisible(false)
	 		-- 		self.animation:getAnimation():gotoAndPause(1)
 			-- 	end
                -- print("BAForPlayEffectAtHero: delay=0")
 				self:ini()
 			end

 			self:addToRender()

        else
        	self:complete()
        	-- --print("BAForPlayEffectAtHero animation :%s is error",self.animationName)
		end
 	end

 	function BAForPlayEffectAtHero:ini( ... )
        if(self.animation == nil) then
            local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(self.animationName)
                if(filesExists == true) then 
                        
                        self.total 								= db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName) * 1/60
                        local postion  							= self.heroUI:globalCenterPoint()

                        self.animation = ObjectTool.getAnimation(self.animationName,false)
                        
                        self.current = 0
                        if(self.rotation ~= nil) then
                            self.animation:setRotation(self.rotation)
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
                
                local postion  
                if(self.atPostion == BATTLE_CONST.POS_FEET) then
                    postion = self.heroUI:globalFeetPoint()

                elseif (self.atPostion == BATTLE_CONST.POS_HEAD)then
                    postion = self.heroUI:globalHeadPoint()
                    self.animation:setPosition(postion.x,postion.y)
                elseif (self.atPostion == nil or self.atPostion == BATTLE_CONST.POS_MIDDLE)then

                    postion = self.heroUI:globalCenterPoint()

                end
                -- print("========== addEffect:",self.animationName," at:",  tostring(postion.x) .. ","  .. tostring(postion.y), " index:",self.atPostion)
                self.animation:setPosition(postion.x,postion.y)
            

                if(self.downTarget ~= true) then
                    BattleLayerManager.addNode(self.animationName,self.animation)
                    self.animation:getAnimation():playWithIndex(0,-1,-1,0)
                    -- BattleLayerManager.battleAnimationLayer:addChild(self.animation)
                else
                    BattleLayerManager.battleBackGroundLayer:addChild(self.animation)
                end
            end
 	end

 	function BAForPlayEffectAtHero:update( dt )
 		

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
 			-- --print(" BAForPlayEffectAtHero:update complete")
 			-- self.animation:getAnimation():stop()
 			
 			if(self.animation) then
 			 	ObjectSharePool.addObject(self.animation,self.animationName)
 			end
 			ObjectTool.removeObject(self.animation,false)
 			self.animation = nil
 			BattleSoundMananger.removeSound(self.animationName)
 			self:complete()
 			BattleLayerManager.checkBatchMap()
 			 
 		end
 	end
 	-- 释放函数
	function BAForPlayEffectAtHero:release(data)
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
		self.heroUI 					= nil

		self.disposed 	= true
 
		self.calllerBacker:clearAll()
		self.blockBoard	= nil
		BattleLayerManager.checkBatchMap()
	end 



return BAForPlayEffectAtHero