


-- 播放怒气头像
   -- 怒气头像: 1.人物头像action类动画 2.effect类动画 3.CCClippingNode(头像的) 4.技能名称动画

require (BATTLE_CLASS_NAME.class)
local BAForPlayRageSkilBar = class("BAForPlayRageSkilBar",require(BATTLE_CLASS_NAME.BaseAction))
	 
		------------------ properties ----------------------
		BAForPlayRageSkilBar.backBarAni 			= nil
		BAForPlayRageSkilBar.skillNameAni			= nil
		BAForPlayRageSkilBar.heroHeadAnimation 		= nil
	 	BAForPlayRageSkilBar.hasRageSkillBar 		= true

	 	BAForPlayRageSkilBar.imgURL 				= nil
	 	BAForPlayRageSkilBar.iconURL 				= nil
	 	
	 	BAForPlayRageSkilBar.completeCount 			= nil
	 	BAForPlayRageSkilBar.count 					= nil
	 	BAForPlayRageSkilBar.rageBarMusic 			= nil -- 怒气头像声音

	 	BAForPlayRageSkilBar.downAnimation			= nil
	 	BAForPlayRageSkilBar.upAnimation			= nil
	 	BAForPlayRageSkilBar.mask					= nil
	 	BAForPlayRageSkilBar.clipper 				= nil
		------------------ functions -----------------------
		function BAForPlayRageSkilBar:start(data)
			-- Logger.debug("BAForPlayRageSkilBar1")
			-- 根据技能找到
			if(self.hasRageSkillBar == true) then
					-- Logger.debug("BAForPlayRageSkilBar2")
			 
				-- 背景动画
 					
 					self.count = 0
 					if(self.rageBarMusic ~= nil and self.rageBarMusic ~= "") then
 						-- Logger.debug("-- rage bar play sound:" .. self.rageBarMusic)
 						BattleSoundMananger.removeSound(self.rageBarMusic)
 						BattleSoundMananger.playEffectSound(self.rageBarMusic,false)
 					else
 						BattleSoundMananger.removeSound(BATTLE_CONST.RAGE_SKILL_SOUND)
 						BattleSoundMananger.playEffectSound(BATTLE_CONST.RAGE_SKILL_SOUND)
 					end
 					
 					-- self.heroHeadAnimation.animation:getAnimation():setMovementEventCallFunc(fnMovementCall)
					-- self.heroHeadAnimation:getAnimation():playWithIndex(0,-1,-1,0)


					
					-- self.skillNameAni:addCallBacker(self,self.onAllComplete)
   		 
					self.clipper = CCClippingNode:create();
 					-- self.skillNameAni.animation:getAnimation():setMovementEventCallFunc(fnMovementCall1)
					-- self.skillNameAni:getAnimation():playWithIndex(0,-1,-1,0)
					self.downAnimation 	=  self:getAnimationByName("ragebar_2",1000,self.clipper)
					self.upAnimation 	=  self:getAnimationByName("ragebar",1000)
					
					local bone = self.downAnimation:getBone("nuqiji_50")
 					local ccskin = CCSkin:create()
 					ccskin:initWithFile(self.imgURL)
 					bone:addDisplay(ccskin,0)

					local bone1 = self.upAnimation:getBone("nuqiji_49")
 					local ccskin1 = CCSkin:create()
 					ccskin1:initWithFile(self.iconURL)
 					bone1:addDisplay(ccskin1,0)

 					self.mask = CCSprite:create("images/battle/icon/rageSkillBarMask.png")
 					BattleNodeFactory.regeistTextureURL("images/battle/icon/rageSkillBarMask.png")
 					-- self.mask:setScaleY(g_fScaleX)
            		-- self.mask:setScaleY(math.min(g_fScaleX))
            		self.mask:setScaleX(g_fScaleX)
            		self.mask:setScaleY(g_fScaleX)
            		self.mask:setPositionY(10)

 					
 					self.clipper:setAnchorPoint( ccp(0.5, 0.5) )
                    self.clipper:setPosition( BattleGridPostion.getCenterScreenPostion() )
                      -- clipper:setInverted(true)
                    self.clipper:setAlphaThreshold(0.5)
                    self.clipper:setStencil(self.mask)
                    -- self.clipper:setScale(g_fScaleX)
                      -- replaceXmlSprite:addChild(clipper)
                     BattleLayerManager.battleUILayer:addChild(self.clipper,0)

					-- self.skillNameAni = self:getAnimationByName("nuqiji_1",1000)
   		-- 	 		self.heroHeadAnimation = self:getAnimationByName("nuqiji",950)
   		-- 	 		self.backBarAni = self:getAnimationByName("nuqiji_2",900)
   			 		
   		-- 	 		local bone = self.heroHeadAnimation:getBone("nuqiji_12")
 				-- 	local ccskin = CCSkin:create()
 				-- 	-- self.imgURL = "images/battle/rage_head/nuqi_beibo.png"
 				-- 	ccskin:initWithFile(self.imgURL)
 				-- 	bone:addDisplay(ccskin,0)

					-- local bone1 = self.skillNameAni:getBone("nuqiji_1")
 				-- 	local ccskin1 = CCSkin:create()
 				-- 	-- self.iconURL = "images/battle/rage_head/ji_aisi.png"
 				-- 	ccskin1:initWithFile(self.iconURL)
 				-- 	bone1:addDisplay(ccskin1,0)
 					
 					
 					-- self.backBarAni.animation:getAnimation():setMovementEventCallFunc(fnMovementCall2)
					-- self.backBarAni:getAnimation():playWithIndex(0,-1,-1,0)
 
					 
			else
				self:complete()
			end

		end
		function BAForPlayRageSkilBar:onOneComplete( target )
			if(self.disposed ~= true) then
				if(target and target:retainCount() > 0 and target:getParent() ~= nil) then
					target:removeFromParentAndCleanup(true)
				end
	 

				 self.count = self.count + 1
				  Logger.debug("BAForPlayRageSkilBar:onAllComplete:" .. self.count)
				 if(self.count >= 2) then
				 	self:complete()
				 	self:release()
				 end

			else
				self:release()
			end
		end

		function BAForPlayRageSkilBar:getAnimationByName( name ,z ,parent)
			local filesExists,imageURL,plistURL,url = ObjectTool.checkAnimation(name)
 			
 			if(filesExists == true) then 
 			 
		 			local animation = ObjectTool.getAnimation(name,false)
		 			if(parent == nil) then 
		 				parent = BattleLayerManager.battleUILayer 
		 				animation:setPosition(BattleGridPostion.getCenterScreenPostion())
		 			end 
		 			parent:addChild(animation,z)
 					
 					-- animation:setScale(g_fScaleX)
      --       		animation:setScaleY(g_fScaleX)
            		
		 			-- animation:setPosition(BattleGridPostion.getCenterScreenPostion())
 
 					fnMovementCall = function ( sender, MovementEventType )
 											 
 											-- Logger.debug("BAForPlayRageSkilBar evt:" .. MovementEventType .." self.disposed:" .. tostring(self.disposed))
									 		if (MovementEventType == EVT_COMPLETE or MovementEventType == EVT_LOOP_COMPLETE) then 
													if(self.disposed ~= true) then
														self:onOneComplete()
													else
														self:release()
													end
											end
 
									 end

			 
		  			animation:getAnimation():setMovementEventCallFunc(fnMovementCall)

 					animation:getAnimation():playWithIndex(0,0,-1,0)
 					return animation
 			else
 				error("怒气技资源不存在:"..name)
 			end

			 
				
			

			-- return result
		end

		function BAForPlayRageSkilBar:release( ... )
			-- print("=== BAForPlayRageSkilBar release")
			if(self.heroHeadAnimation) then
				self.heroHeadAnimation:removeFromParentAndCleanup(true)
				self.heroHeadAnimation = nil
			end

			if(self.backBarAni) then
				self.backBarAni:removeFromParentAndCleanup(true)
				self.backBarAni = nil
			end
			
			if(self.skillNameAni) then
				self.skillNameAni:removeFromParentAndCleanup(true)
				self.skillNameAni = nil
			end

			ObjectTool.removeObject(self.upAnimation)
			ObjectTool.removeObject(self.downAnimation)
			ObjectTool.removeObject(self.mask)
			ObjectTool.removeObject(self.clipper)
			self.super.release(self)

		end
return BAForPlayRageSkilBar

 