

local BattleRecordShowSecondMediator = class("BattleRecordShowSecondMediator")
 
	------------------ properties ----------------------
		BattleRecordShowSecondMediator.name 			= "BattleRecordShowSecondMediator"

	 	-- 主角位置索引
	 	BattleRecordShowSecondMediator.playerPosition 			= 1

		BattleRecordShowSecondMediator.maskAnimation 			= "heimu"
		-- 战斗中对话
		BattleRecordShowSecondMediator.recordTalks  			= {}
		-- BattleRecordShowSecondMediator.recordTalks["2"] = 212
		BattleRecordShowSecondMediator.recordTalks["3"] 		= 212
 
		-- 上场显示目标
		BattleRecordShowSecondMediator.selfShowTargets 			= {0,1,2}

		-- 隐藏目标
		BattleRecordShowSecondMediator.selfHides				= {3,4,5}    -- 己方上场隐藏人物
		BattleRecordShowSecondMediator.armyHides				= {0,2,3,4,5}    -- 敌方上场隐藏人物

		-- BattleRecordShowSecondMediator.talk0 					= 206

		-- 青雉入场
		-- BattleRecordShowSecondMediator.FadeInArmyHero1Postion 	= 0
		-- BattleRecordShowSecondMediator.FadeInArmyHero1Effect    = ""
		-- BattleRecordShowSecondMediator.talk1 					= 206

		--黄猿
		BattleRecordShowSecondMediator.FadeInArmyHero2Postion 	= 0
		BattleRecordShowSecondMediator.FadeInArmyHero2Effect    = {"meffect_35","meffect_35_1","meffect_35_2"}
		BattleRecordShowSecondMediator.talk2 					= 207

		-- 克罗克达尔
		BattleRecordShowSecondMediator.FadeInSelfHero1Postion 	= 4
		BattleRecordShowSecondMediator.FadeInSelfHero1Effect    = {"meffect_39","meffect_39_1","meffect_39_2"}
	 	BattleRecordShowSecondMediator.talk3 					= 208

	 	
 

	 	-- 敌方剩余人物移动入场
	 	BattleRecordShowSecondMediator.armyMoveInByPositions 	= {2,3,4,5}
	 	BattleRecordShowSecondMediator.talk4 					= 209
	 	-- 赤犬所在位置
	 	BattleRecordShowSecondMediator.chiquanPosition 			= 2
	 	-- 赤犬移动特效
		BattleRecordShowSecondMediator.walkEffect 				= "meffect_38"
		BattleRecordShowSecondMediator.walkEffectInstance 		= nil
	 	-- 罗
	 	BattleRecordShowSecondMediator.FadeInSelfHero2Postion 	= 3
		BattleRecordShowSecondMediator.FadeInSelfHero2Effect    = "meffect_cx"
		BattleRecordShowSecondMediator.talk5 					= 210
	 	-- 女帝
	 	BattleRecordShowSecondMediator.FadeInSelfHero3Postion 	= 5
		BattleRecordShowSecondMediator.FadeInSelfHero3Effect    = {"meffect_37","meffect_37_1"}
		BattleRecordShowSecondMediator.talk6 					= 211

		-- 大招前对话
		BattleRecordShowSecondMediator.skillShowTalk1 			= 212
		-- 战斗中大招人物索引
		BattleRecordShowSecondMediator.skillShowPositionIndex 	= 2
		-- 技能特效
		BattleRecordShowSecondMediator.skillShowEffect		 	= "meffect_6"
		-- 技能展示背景增加特效
		BattleRecordShowSecondMediator.skillShowBGEffect 		= "meffect_6"
		-- 技能展示回合
		BattleRecordShowSecondMediator.skillShowRound 			= 2

		-- 大招后对话
		BattleRecordShowSecondMediator.skillShowTalk2			= 213
		

		--背景
		BattleRecordShowSecondMediator.bgName 					= BATTLE_CONST.TUTORIAL2_BACKGROUND
		-- 音乐
		BattleRecordShowSecondMediator.music 					= "1.mp3"

		BattleRecordShowSecondMediator.mask 					= nil -- 转场

		BattleRecordShowSecondMediator.shakeAction 				= nil -- 震屏
		------------------ functions -----------------------
		function BattleRecordShowSecondMediator:onRegest( ... )
			-- 注册回调
			logger:debug("BattleRecordShowSecondMediator onRegest")
 			
			-- EventBus.addEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete,self)
		end -- function end

		function BattleRecordShowSecondMediator:onRemove( ... )

			self.afterTalkRun = self.AFTER_TALK_NONE
			EventBus.removeEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete)
	 
		end -- function end

		function BattleRecordShowSecondMediator:getHandler()
			return self.handleNotifications
		end

		function BattleRecordShowSecondMediator:getInterests( ... )
			-- local  ins = require("script/notification/NotificationNames")
			return {	
						NotificationNames.EVT_SINGLE_BATTLE_INI ,-- 初始化
	 					NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE, -- 战斗录像播放完成
	 					NotificationNames.NotificationNames.EVT_RECORD_PAUSED
					}
		end

 
		-- 隐藏目标
		function BattleRecordShowSecondMediator:hideTargets( ... )
			for k,postion in pairs(self.selfHides) do
			 	local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(postion)
			 	display:setVisible(false)
			end

			for k,postion in pairs(self.armyHides) do
			 	local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(postion)
			 	display:setVisible(false)
			end

		end

		-- 显示目标
		function BattleRecordShowSecondMediator:fadeInTargets(  )
			for k,postion in pairs(self.selfShowTargets) do
				local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(postion)
				display:setOpacity(0)
				local actionArray = CCArray:create()
         		actionArray:addObject(CCFadeIn:create(0.1))
 
         		display.container:runAction(CCSequence:create(actionArray))

			end
		end

		-- 剩余敌军引动入场
		function BattleRecordShowSecondMediator:moveArmy( ... )
			local  targets = {}
			for k,postion in pairs(self.armyMoveInByPositions) do
              	 local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(postion)
              	  display:setVisible(true)
              	 table.insert(targets,display)
            end
			local moveAction = require("script/battle/action/BAForMoveTargetsTo").new()
			moveAction.targets = targets
			logger:debug("BattleRecordShowSecondMediator moveDistence:" .. BattleMainData.moveDistence)
			moveAction.moveDistence = BattleMainData.moveDistence
			moveAction:addCallBacker(self,self.onMoveArmyComplete)
			moveAction:start()

			-- 添加赤犬移动特效
			local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.chiquanPosition)
			self.walkEffectInstance = ObjectTool.getAnimation(self.walkEffect,true,nil,true)
 

 			self.walkEffectInstance:setPosition(display.cacheHeart.x,display.cacheHeart.y)
 			-- cacheHeart
			display.boneBinder:addChild(self.walkEffectInstance)
		end

		function BattleRecordShowSecondMediator:playTalk( talkid,callback )
			-- require "script/module/talk/TalkCtrl"
			assert(callback,"对话回调是nil:".. talkid)
			Logger.debug("============= 创建对话:" .. talkid)
			 TalkCtrl.create(talkid)
		     TalkCtrl.setCallbackFunction(callback)


		end
		-- 移动完毕
		function BattleRecordShowSecondMediator:onMoveArmyComplete( ... )
			if(self.walkEffectInstance) then
				ObjectTool.removeObject(self.walkEffectInstance)
				self.walkEffectInstance = nil
				AudioHelper.stopAllEffects()
			end

			--  对话1
		 	
			self:playTalk(self.talk4,
				function( ... )
		        	 local display1 = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeInSelfHero2Postion)
			 	 	  -- 罗
				 	 self:showHero(display1,self.FadeInSelfHero2Effect,
				 	 	function ( ... )
				 	 		self:playTalk(self.talk5, 
													function( ... )
														 local display1 = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeInSelfHero3Postion)
												 	 	  -- 女帝

												 	 	  self:showND(
												 	 	  			   self.FadeInSelfHero3Effect[1],
												 	 	  			   self.FadeInSelfHero3Effect[2],
												 	 	  			   display1,
													 	 -- self:showHero(display1,self.FadeInSelfHero3Effect,

												 	 	 function ( ... )
												 	 	 		 self:playTalk(self.talk6,
												 	 	 		 	function( ... )
															        	self:startRecord()
															        end)
												 	 	 end)
													end)
				 	 	end)
		        end)

 
			 
		end



	function BattleRecordShowSecondMediator:addAnimationToTargetPostion(target,animation,downTarget)
			
			local postion = target:globalCenterPoint()
         
            animation:setPosition(postion.x,postion.y)
           	Logger.debug("setPosition:"..postion.x.. " ," .. postion.y)

          	-- if(downTarget ~= true) then
			BattleLayerManager.battleAnimationLayer:addChild(animation)
			-- else
			-- 	BattleLayerManager.battleBackGroundLayer:addChild(self.animation)
			-- end
	end

		-- 女帝出场特效
	function BattleRecordShowSecondMediator:showND( first,second, target,callback)
		 -- 生成第一个动画
 			local animation1 = ObjectTool.getAnimation(first,false)
 			BattleSoundMananger.playEffectSound(first)
 			-- self:addAnimationToTargetPostion(target,animation1)
 			-- animation1:setAnchorPoint(ccp())

 			animation1:setPosition(g_winSize.width/2,g_winSize.height/2)
 			BattleLayerManager.battleAnimationLayer:addChild(animation1)
 			animation1:setZOrder(999)
 			local excuted = false
 		-- 第1个动画的关键帧触发第二个动画播放
			local fnFrameCall1 = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					if(excuted == false) then
						excuted = true
						local animation2 = ObjectTool.getAnimation(second,false)
						self:addAnimationToTargetPostion(target,animation2)
						BattleSoundMananger.playEffectSound(second)
						-- 第二个动画完成回调
				  			local fnMovementCall2 = function ( sender, MovementEventType )
					  			-- 删除第二个动画
						  			if (MovementEventType == EVT_COMPLETE) then 
											-- ObjectTool.removeObject(animation2)
											ObjectTool.removeAnimationByName(second,animation2,true)
											-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
											target:setVisible(true)
											BattleNodeFactory.release()
		   									CCTextureCache:sharedTextureCache():removeUnusedTextures()

											if(callback ~= nil) then
												callback()
											end
									end

					  		end -- f end
				  		animation2:getAnimation():setMovementEventCallFunc(fnMovementCall2)
				  else
				  	Logger.debug("======= double call")
				  end
			end

			-- 第一个动画的结束回调
 			local fnMovementCall1 = function ( sender, MovementEventType )
 					if (MovementEventType == EVT_COMPLETE) then 

 						-- 删除动画
 						ObjectTool.removeObject(animation1)
 						-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
 						ObjectTool.removeAnimationByName(first,animation1,true)
 					end

 			end
			animation1:getAnimation():setFrameEventCallFunc(fnFrameCall1)
	 		animation1:getAnimation():setMovementEventCallFunc(fnMovementCall1)
	end

	-- 播放三个组合的动画 第1个关键帧触发第二个,第二个
	 function BattleRecordShowSecondMediator:playThreeAsOne1( first,second,third ,target,callback)
 			
 			-- 生成第一个动画
 			local animation1 = ObjectTool.getAnimation(first,false)
 			self:addAnimationToTargetPostion(target,animation1)
 			BattleSoundMananger.playEffectSound(first)
 			animation1:setZOrder(999)

 			-- 第1个动画的关键帧触发第二个动画播放
			local fnFrameCall1 = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					local animation2 = ObjectTool.getAnimation(second,false)
					self:addAnimationToTargetPostion(target,animation2)
					BattleSoundMananger.playEffectSound(second)
					-- 第二个动画完成回调
			  			local fnMovementCall2 = function ( sender, MovementEventType )
				  			-- 删除第二个动画
					  			if (MovementEventType == EVT_COMPLETE) then 
										-- ObjectTool.removeObject(animation2)
										 ObjectTool.removeAnimationByName(second,animation2,true)
										-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
								end

							-- 生成第三个
								local animation3 = ObjectTool.getAnimation(third,false)
								self:addAnimationToTargetPostion(target,animation3)
								BattleSoundMananger.playEffectSound(third)
								-- 第二个动画完成回调
						  		local fnMovementCall3 = function ( sender, MovementEventType )
						  			-- 删除第二个动画
						  			if (MovementEventType == EVT_COMPLETE) then 
											ObjectTool.removeObject(animation3)
											 ObjectTool.removeAnimationByName(third,animation3,true)
											-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
									end
 									target:setVisible(true)

 									if(callback ~= nil) then
										callback()
									end

						  		end -- f end
						  		animation3:getAnimation():setMovementEventCallFunc(fnMovementCall3)


			  		end -- f end
			  		animation2:getAnimation():setMovementEventCallFunc(fnMovementCall2)
			end

			-- 第一个动画的结束回调
 			local fnMovementCall1 = function ( sender, MovementEventType )
 					if (MovementEventType == EVT_COMPLETE) then 

 						-- 删除动画
 						-- ObjectTool.removeObject(animation1)
						ObjectTool.removeAnimationByName(first,animation1,true)
 						-- CCTextureCache:sharedTextureCache():removeUnusedTextures()

 					end

 			end
			animation1:getAnimation():setFrameEventCallFunc(fnFrameCall1)
	 		animation1:getAnimation():setMovementEventCallFunc(fnMovementCall1)
	 		

 	end -- f end

 	-- 播放三个组合的动画()
 	function BattleRecordShowSecondMediator:playThreeAsOne( first,second,third ,target,callback)


 			local animation1 = ObjectTool.getAnimation(first,false)
 			self:addAnimationToTargetPostion(target,animation1)
 			BattleSoundMananger.playEffectSound(first)
 			-- 第一个动画的结束回调
 			local fnMovementCall1 = function ( sender, MovementEventType )
						 
					 	
					-- 如果是第一个动画播放完毕,我们继续播放第二个
			 		if (MovementEventType == EVT_COMPLETE) then 
			 				Logger.debug("animation1 complete")
			 				-- 删除前一个动画
							-- if(animation1 ~= nil and animation1:getParent() ~= nil and animation1:retainCount() > 0) then
							-- 	animation1:removeFromParentAndCleanup(true)
							-- end
							-- 因为后面技能还会用到这个,所以不删除
							ObjectTool.removeObject(animation1)
							--
							-- ObjectTool.removeAnimationByName(first,animation1,true)
							-- 播放第二个
							local animation2 = ObjectTool.getAnimation(second,false)
							self:addAnimationToTargetPostion(target,animation2)
							BattleSoundMananger.playEffectSound(second)
							-- 第二个的回调
							local fnMovementCall2 = function ( sender, MovementEventType )
								 
							 
								 		if (MovementEventType == EVT_COMPLETE) then 
												-- if(animation2 ~= nil and animation2:getParent() ~= nil and animation2:retainCount() > 0) then
												-- 	animation2:removeFromParentAndCleanup(true)
												-- end
												ObjectTool.removeAnimationByName(second,animation2,true)
										end
										target:setVisible(true)

					 		end
					 		-- 第二个动画的关键帧
					 		local fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					 							 		 Logger.debug("fnFrameCall:" .. frameEventName)
							 							local animation3 = ObjectTool.getAnimation(third,false)
							 							self:addAnimationToTargetPostion(target,animation3)
							 							BattleSoundMananger.playEffectSound(third)
												  		local fnMovementCall3 = function ( sender, MovementEventType )

												  			if (MovementEventType == EVT_COMPLETE) then 
																	-- if(animation3 ~= nil and animation3:getParent() ~= nil and animation3:retainCount() > 0) then
																	-- 	animation3:removeFromParentAndCleanup(true)
																	-- end
																	ObjectTool.removeAnimationByName(third,animation3,true)
																	-- local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(postion)
			 														if(callback ~= nil) then
			 															callback()
			 														end
			 														-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
															end

												  		end -- f end
												  		animation3:getAnimation():setMovementEventCallFunc(fnMovementCall3)
												end -- f end
					 		animation2:getAnimation():setMovementEventCallFunc(fnMovementCall2)
					 		animation2:getAnimation():setFrameEventCallFunc(fnFrameCall)
					end -- if end




			end -- f end
 
	 		animation1:getAnimation():setMovementEventCallFunc(fnMovementCall1)

 	end -- f end
		 

		
		-- 转场特效
		 function BattleRecordShowSecondMediator:moveMaskIn( ... )
 
		 	local gWinSize = CCDirector:sharedDirector():getWinSize()
		 	local size = CCSizeMake(gWinSize.width,gWinSize.height)
		 	local scene = CCDirector:sharedDirector():getRunningScene()
		  
			self.changeAction = require("script/battle/action/BAForShowChangeSceneEffect").new()
			-- self.changeAction:addCallBacker(self,self.showEffectHeroes)
			
			
			self.changeAction:renderScreen()
			
			self:cacheStage()
			
			-- -- self.changeAction:start()
 			

    		
   --  		  -- 初始化屏幕参数
	          BattleMainData.iniScreenParameter()       
			--   -- 动作渲染开始
	          BattleActionRender.start()
	       	  
	  --      	  -- 创建战斗场景层
			  BattleLayerManager.createLayers()
          	 
          	 self.changeAction.screen:setVisible(true)
	           
	          	
	  --         -- end,BATTLE_CONST.ARENA_BACKGROUND)


		       

		        self.moveInEffectAction 				= require(BATTLE_CLASS_NAME.BAForPlayAnimationByFrame).new()
				self.moveInEffectAction.animationName 	= self.maskAnimation
				self.moveInEffectAction.container 		= CCDirector:sharedDirector():getRunningScene()
				self.moveInEffectAction.zOder 			= 99999

				 
				  			local fnMovementCall2 = function ( sender, MovementEventType )
					  		 
						  			-- if (MovementEventType == EVT_COMPLETE) then 
											-- ObjectTool.removeObject(animation)
											self.moveInEffectAction:release()
											-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
											self:showEffectHeroes()
											
									-- end

					  		end -- f end
					  		local hasIni = false
					  		-- 第二个动画的关键帧
					 		-- local fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					 		local fnFrameCall = function ( )
					 							 		 Logger.debug("fnFrameCall:")
					 							 		 -- 
					 							 		 if(hasIni == false) then
					 							 		 		 hasIni = true
							 									  -- 删除前景
							 									  self.changeAction:release()
																  self.changeAction = nil
																  
													          	  -- self.moveInEffectAction:stop()
														       
														          -- animation:getAnimation():gotoAndPause(30)	
														          -- ObjectTool.removeObject(animation)
														          -- end,BATTLE_CONST.ARENA_BACKGROUND)
																  
																      		  -- 初始化背景
																  EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,self.bgName)

																  EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_SET_POSTION,4)

																  --  -- 同步主角htid
																  -- local playerdata = BattleMainData.fightRecord:indexTeam1PlayerDataByPosition(self.playerPosition)
																		
																  --刷新英雄ui数据
																  BattleMainData.refreshBattleTeamDisplayData()

																  --初始化ui
															      EventBus.sendNotification(NotificationNames.EVT_UI_INI)

													              -- 创建队伍人员显示
													          	  BattleTeamDisplayModule.createHeroDisplayToMainData()

													      	   	  -- 链接战斗数据的display
													              BattleMainData.linkAndRefreshHeroesDisplay()

													              -- 隐藏不需要显示直接显示的英雄
													              self:hideTargets()
              

													              -- animation:getAnimation():resume()
											            end
					 		end
					 		-- resume

			self.moveInEffectAction.evtFrameCallBack = fnFrameCall
			self.moveInEffectAction.completeCallBack = fnMovementCall2
		 	self.moveInEffectAction:start()

 			
        
           
		 end

		 function BattleRecordShowSecondMediator:renderScreen( ... )
		 		local scene = CCDirector:sharedDirector():getRunningScene()
		 		local gWinSize = CCDirector:sharedDirector():getWinSize()
		 		self.screen = CCRenderTexture:create(gWinSize.width,gWinSize.height,kCCTexture2DPixelFormat_RGBA8888)

		 		-- self.screen:getSprite():setAnchorPoint( CCP_HALF )
			  --   self.screen:setPosition( ccp(gWinSize.width/2, gWinSize.height/2) )
			  --   self.screen:setAnchorPoint( CCP_HALF )


		 		self.screen:begin()
		 		scene:visit()
		 		self.screen:endToLua()


		 end

		 function BattleRecordShowSecondMediator:showHero(display,animationName,callback)
		 	assert(display)
		 	assert(animationName)
 
		 	local showEffect = require("script/battle/action/BAForSingleHeroShow").new()
		 	showEffect.targetUI = display
		 	showEffect.animationName = animationName
		 	local callbacker  = {}
		 	callbacker.callback = callback
		 	showEffect:addCallBacker(callbacker,callbacker.callback)
		 	showEffect:start()

		 end

		 -- -- 播放对话
		 -- function BattleRecordShowSecondMediator:showTalk( talkid , callback )
		 -- 	self:playTalk(self.talk0,function( ... ) 
		 -- 											callback()
		 -- 							 end)
		 -- end
		 -- 当切屏特效完成后 开始展示英雄
		 function BattleRecordShowSecondMediator:showEffectHeroes( ... )
		  	 
	
	    	-- self:playTalk(self.talk0,function( ... ) 
			-- local display1 = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.FadeInArmyHero1Postion)
			-- self:showHero(display1,self.FadeInArmyHero1Effect,
			-- 	function ( ... )
								-- self:playTalk(self.talk1, 
								-- 	function( ... )
										 	 local display2 = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.FadeInArmyHero2Postion)
										 	 -- 黄猿
										 	 -- self:showHero(display2,self.FadeInArmyHero2Effect,
										 	 	self:playThreeAsOne1(
										 	 		self.FadeInArmyHero2Effect[1],
										 	 		self.FadeInArmyHero2Effect[2],
										 	 		self.FadeInArmyHero2Effect[3],
										 	 		display2,
										 	 	function ( ... )
										 	 		self:playTalk(self.talk2, 
											 	 			function( ... )
											 	 				 local display3 = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeInSelfHero1Postion)
																  Logger.debug("克罗克达尔 show start")
																  -- 克罗克达尔
																  -- self:playThreeAsOne("meffect_39","meffect_39_1","meffect_39_2",display3,
																  self:playThreeAsOne(
																  					  self.FadeInSelfHero1Effect[1],
																  					  self.FadeInSelfHero1Effect[2],
																  					  self.FadeInSelfHero1Effect[3],
																  					  display3,
																  -- self:showHero(display3,self.FadeInSelfHero1Effect,
																	  	function ( ... )
																	  			self:playTalk(self.talk3, 
																	  				function( ... )
																	  							self:moveArmy()
																	  				end)
																	  	end)
											 	 			end)
										 	 	end)
												

									-- end)
				-- end)
									 -- end )
	    						
 
    			 
		 end


		 -- -- 场景切换特效播放完毕
		 -- function BattleRecordShowSecondMediator:moveMaskOut( ... )
		 -- 		local onMaskMoveOutComplete = function ( ... )
    				 
   --  				 local display1 = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.FadeInArmyHero1Postion)
					 
   --  				 -- 显示青雉
   --  				 self:showHero(display1,self.FadeInArmyHero1Effect,function ( ... )
   --  				 	 local display2 = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.FadeInArmyHero2Postion)
   --  				 	 -- 黄猿
   --  				 	 self:showHero(display2,self.FadeInArmyHero2Effect,function ( ... )

   --  				 	 	 local display3 = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeInSelfHero1Postion)
   --  				 	 	  -- 克罗克达尔
	  --   				 	 self:showHero(display3,self.FadeInSelfHero1Effect,function ( ... )
	  --   				 	 	  	self:playTalk(self.talk1,function( ... )
			-- 										        	self:onTalk1Complete(talkId)
			-- 										        end)
	  --   				 	 end)

   --  				 	 end)
   --  				 end)
   --  			end
   --  			local gWinSize = CCDirector:sharedDirector():getWinSize()
		 -- 	 	local actionArray = CCArray:create()
    			 
			-- 	actionArray:addObject(CCMoveTo:create(0.5, ccp(-gWinSize.width,0)))
			-- 	actionArray:addObject(CCCallFuncN:create(onMaskMoveOutComplete))
			-- 	self.mask:stopAllActions()
			-- 	self.mask:runAction(CCSequence:create(actionArray))
		 -- end
 
		 function BattleRecordShowSecondMediator:startRecord( ... )
		 	local talk = {}
		    talk.fightingTalks = ObjectTool.deepcopy(self.recordTalks)
		    -- talk.pauseRounds   = {} --设置暂停回合
		    -- talk.pauseRounds[3]= true
		    
		 	EventBus.sendNotification(NotificationNames.EVT_PLAY_RECORD_START,talk)
		 		  -- 显示调过战斗按钮
          	 -- EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
		 end

		function BattleRecordShowSecondMediator:handleNotifications(eventName,data)
			if eventName ~= nil then
				-- 开始播放战报
				if eventName == NotificationNames.EVT_SINGLE_BATTLE_INI then

					  CCTextureCache:sharedTextureCache():removeUnusedTextures()
					 
					  EventBus.regestMediator(require("script/battle/mediator/BattleBackGroundMediator"))     
			          EventBus.regestMediator(require("script/battle/mediator/BattleRecordPlayMediator"))
			          EventBus.regestMediator(require("script/battle/mediator/BattleResultWindowMediator"))
		          	  EventBus.regestMediator(require("script/battle/mediator/BattleInfoUIMediator"))
		          	  EventBus.regestMediator(require("script/battle/mediator/BattleTalkMediator"))

			         
			       
			          self:moveMaskIn()
			    -- 战斗暂停 -- 废弃
			    elseif eventName == NotificationNames.NotificationNames.EVT_RECORD_PAUSED then
			    	  -- Logger.debug("============== 暂停")
			   --  -- 对话1
			   --  self:playTalk(self.skillShowTalk1,
			   --  	function( ... )
			   --  		Logger.debug("============== 对话播放完毕")
						-- EventBus.sendNotification(NotificationNames.EVT_RECORD_CONTINUE_PLAY)
			   --  	end)
			    -- Logger.debug("============== 暂停")
			    -- -- 对话1
			    -- self:playTalk(self.skillShowTalk1,
			    -- 	function( ... )
			    --     	  -- 攻击动作
			    --     	 local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.skillShowPositionIndex)
			    --     	 local fakeTarget = {}
			    --     	 fakeTarget.callback = function ( ... )
													        	 							
							-- 					  	-- 播放特效
							-- 					 	local animation =  require("script/battle/action/BAForPlayEffectAtPostion").new()
												 
							-- 						animation.postionX = 200
							-- 						animation.postionY = 200
							-- 						animation.animationName = self.skillShowEffect
							-- 						-- self.animation.downTarget = true

							-- 						local call = {}
							-- 					 	call.back = function ( ... )
							-- 					 		 			-- 背景特效
							-- 					 		 			-- EventBus.sendNotification(NotificationNames.EVT_BATTLE_SHOW_BG_EFFECT,self.skillShowBGEffect)
							-- 					 		 			self:playTalk(self.skillShowTalk2,
							-- 					 		 				function ( ... )
							-- 					 		 					Logger.debug("============== 对话播放完毕")
							-- 					 		 					EventBus.sendNotification(NotificationNames.EVT_RECORD_CONTINUE_PLAY)
												 		 				 
							-- 					 		 				end)
							-- 					 				end	

							-- 					 	animation:addCallBacker(call,call.back)
							-- 					 	animation:start()

												 

			    --     	 						end
			    -- 		 display:playXMLAnimationWithCallBack("A001",fakeTarget,fakeTarget.callback)

			    --     end)

			    
			   
			    
			    
			    	-- 播放完毕后
			    	-- 对话2
			    	-- EventBus.sendNotification(NotificationNames.EVT_RECORD_CONTINUE_PLAY)

		   		elseif eventName == NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE then
		   			Logger.debug("EVT_BATTLE_RECORD_PLAY_COMPLETE")
		   			self:doShakeForAWhile()
		   			-- BattleNodeFactory.releaseArmatures()
		   			 Logger.debug("===================  dumpCachedTextureInfo")
					  CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
		   			BattleNodeFactory.release()
		   			CCTextureCache:sharedTextureCache():removeUnusedTextures()

		   			 -- self:playTalk(self.skillShowTalk1,
			    		-- 		   function( ... )
			    				   			
									-- end)
			 
				end
			end
		end -- function end
		function BattleRecordShowSecondMediator:doShakeForAWhile( ... )
			Logger.debug("doShakeForAWhile")
			self.shakeAction = require(BATTLE_CLASS_NAME.BAForShakeScreen).new()
			self.shakeAction.total = 1-- 我们这里赋值一个很大的数值当做无穷大
			-- self.shakeAction.root = CCDirector:sharedDirector():getRunningScene()
			self.shakeAction:addCallBacker(self,self.onShakeWhileComplete)
			self.shakeAction:start()
			Logger.debug("doShakeForAWhile1")
		end

		function BattleRecordShowSecondMediator:onShakeWhileComplete( ... )
				Logger.debug("shake complete")
 				
 				self.moveInEffectAction 				= require(BATTLE_CLASS_NAME.BAForPlayAnimationByFrame).new()
				self.moveInEffectAction.animationName 	= self.maskAnimation
				self.moveInEffectAction.container 		= CCDirector:sharedDirector():getRunningScene()
				self.moveInEffectAction.zOder 			= 99999

	 		-- 	Logger.debug("==> BattleRecordShowFirstMediator:handleNotifications EVT_BATTLE_RECORD_PLAY_COMPLETE")
				-- self.changeAction = require("script/battle/action/BAForShowChangeSceneEffect").new()
				-- self.changeAction:addCallBacker(self,self.onTranScreenComplete)
				-- self.changeAction:renderScreen()

				  			local fnMovementCall2 = function ( sender, MovementEventType )
					  		 
						  			-- if (MovementEventType == EVT_COMPLETE) then 
											-- ObjectTool.removeObject(animation)
											self.moveInEffectAction:release()
											-- CCTextureCache:sharedTextureCache():removeUnusedTextures()
											self.onTranScreenComplete()
											
									-- end

					  		end -- f end
					  		local hasIni = false
					  		-- 第二个动画的关键帧
					 		-- local fnFrameCall = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					 		local fnFrameCall = function ( )
					 							 		 Logger.debug("fnFrameCall:")
					 							 		 -- 
					 							 		 if(hasIni == false) then
					 							 		 		 hasIni = true
							 									  -- 删除前景
							 									 --  self.changeAction:release()
																  -- self.changeAction = nil
																 -- 
												  				 self.moveInEffectAction:stop()
																

												                self:showLabel()
													          	  -- self.moveInEffectAction:stop()
														       
														          -- animation:getAnimation():gotoAndPause(30)	
														          -- ObjectTool.removeObject(animation)
														          -- end,BATTLE_CONST.ARENA_BACKGROUND)


													              -- animation:getAnimation():resume()
											            end
					 		end
					 		-- resume

			self.moveInEffectAction.evtFrameCallBack = fnFrameCall
			self.moveInEffectAction.completeCallBack = fnMovementCall2
		 	self.moveInEffectAction:start()


				-- Logger.debug("==> BattleRecordShowFirstMediator:handleNotifications EVT_BATTLE_RECORD_PLAY_COMPLETE")
				-- self.changeAction = require("script/battle/action/BAForShowChangeSceneEffect").new()
				-- self.changeAction:addCallBacker(self,self.onTranScreenComplete)
				-- self.changeAction:renderScreen()
 

				--  EventBus.removeMediator("BattleBackGroundMediator")
    --              EventBus.removeMediator("BattleRecordPlayMediator")
    --              EventBus.removeMediator("BattleResultWindowMediator")
              
    --              EventBus.removeMediator("BattleInfoUIMediator")
    --              EventBus.removeMediator("BattleTalkMediator")
                  
             	
    --             BattleTeamDisplayModule.removeAll()
    --             BattleLayerManager.release()
    --          	self:resumeStage()

    --          	require "script/module/switch/SwitchCtrl"
    --             SwitchCtrl.postBattleNotification("END_BATTLE")
    --             EventBus.removeMediator("BattleRecordShowSecondMediator")

                

				-- self.changeAction:start()
		end

		function BattleRecordShowSecondMediator:showLabel( ... )

				self:createLabelAnimation(BATTLE_CONST.LABEL_1,
										  function ( ... )
										  			 
										  		self:createLabelAnimation(BATTLE_CONST.LABEL_2,

															  			function ( ... )
																				
																				self:createLabelAnimation(BATTLE_CONST.LABEL_4,
																										  function ( ... )
																										  		if(self.moveInEffectAction) then
																													self.moveInEffectAction:release()
																												end
				
																									  			self:onTranScreenComplete()
																										  end)


																			
																		 
				  														end)
										end)
				-- local label = CCLabelTTF:create(BATTLE_CONST.LABEL_1, g_FontInfo.name, 22)
				-- label:setColor(ccc3(255, 255, 255))
				-- label:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
				-- CCDirector:sharedDirector():getRunningScene():addChild(label,999991,999991)


				-- -- BattleActionRender.removeAll()
				-- local acitonArray = CCArray:create()
				-- -- acitonArray:addObject(CCFadeIn:create(1))
				-- acitonArray:addObject(CCDelayTime:create(1.5))
				-- acitonArray:addObject(CCFadeOut:create(1.5))
				-- acitonArray:addObject(CCCallFunc:create(function ( ... )

				-- 	 										ObjectTool.removeObject(label)
				-- 	 										local label2 = CCLabelTTF:create(BATTLE_CONST.LABEL_2, g_FontInfo.name, 22)
				-- 											label2:setColor(ccc3(255, 255, 255))
				-- 											label2:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
				-- 											CCDirector:sharedDirector():getRunningScene():addChild(label2,999991,999991)

				-- 											local acitonArray2 = CCArray:create()
				-- 											-- acitonArray2:addObject(CCFadeIn:create(1))
				-- 											acitonArray2:addObject(CCDelayTime:create(1.5))
				-- 											acitonArray2:addObject(CCFadeOut:create(1.5))
				-- 											acitonArray2:addObject(CCCallFunc:create(function ( ... )

				-- 																						if(self.moveInEffectAction) then
				-- 																							self.moveInEffectAction:release()
				-- 																						end
				-- 																						CCTextureCache:sharedTextureCache():removeUnusedTextures()
																										
				-- 																						self:onTranScreenComplete()
				-- 																						ObjectTool.removeObject(label2)
				-- 																					end))
				-- 											label2:runAction(CCSequence:create(acitonArray2))
				-- 										end))
				-- label:runAction(CCSequence:create(acitonArray))


		end

		function BattleRecordShowSecondMediator:createLabelAnimation( info , callback )
				
				local label = CCLabelTTF:create(info, g_FontInfo.name, 36)
				label:setColor(ccc3(255, 255, 255))
				label:setPosition(ccp(g_winSize.width * 0.5, g_winSize.height * 0.5))
				CCDirector:sharedDirector():getRunningScene():addChild(label,999991,999991)


				-- BattleActionRender.removeAll()
				local acitonArray = CCArray:create()
				-- acitonArray:addObject(CCFadeIn:create(1))
				acitonArray:addObject(CCDelayTime:create(1.5))
				acitonArray:addObject(CCFadeOut:create(1.5))
				acitonArray:addObject(CCCallFunc:create(callback))
				acitonArray:addObject(CCCallFunc:create(function( ... )
					ObjectTool.removeObject(label)
				end))
				label:runAction(CCSequence:create(acitonArray))
				return label
		end



		function BattleRecordShowSecondMediator:onTranScreenComplete( ... )
				
				BattleState.setPlaying(false)
               	CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()
                Logger.debug("BattleRecordShowSecondMediator:onTranScreenComplete")
                BattleActionRender.removeAll()
                
                EventBus.removeMediator("BattleBackGroundMediator")
                EventBus.removeMediator("BattleRecordPlayMediator")
                EventBus.removeMediator("BattleResultWindowMediator")
              
                EventBus.removeMediator("BattleInfoUIMediator")
                EventBus.removeMediator("BattleTalkMediator")
                  
             	
                BattleTeamDisplayModule.removeAll()
                BattleLayerManager.release()
             	

            
                EventBus.removeMediator("BattleRecordShowSecondMediator")
                EventBus.release()
                local callback = BattleMainData.callbackFunc
                -- BattleMainData.runCompleteCallBack()
                BattleMainData.releaseData()
             
                self:resumeStage()
                CCTextureCache:sharedTextureCache():removeUnusedTextures()
                callback()
                -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo();
                
 				-- require "script/module/switch/SwitchCtrl"
 				
                -- SwitchCtrl.postBattleNotification("END_BATTLE")
		end
		
		function BattleRecordShowSecondMediator:cacheStage()
		      CCArmatureDataManager:sharedArmatureDataManager():addArmatureFileInfo("images/battle/animation/kapian.ExportJson")
		            local scene = CCDirector:sharedDirector():getRunningScene()
		            
		            ---[[
		            self.visibleViews = CCArray:create()
		            self.touchableViews = CCArray:create()

		            self.visibleViews:retain()
		            self.touchableViews:retain()
		 
		          local scene = CCDirector:sharedDirector():getRunningScene()
		            
		            ---[[
		            self.visibleViews = CCArray:create()
		            self.touchableViews = CCArray:create()

		            self.visibleViews:retain()
		            self.touchableViews:retain()

		            local sceneChildArray = scene:getChildren()
		            for idx=1,sceneChildArray:count() do
		                ----print("childNode:",idx,sceneChildArray:count() )
		                local childNode = tolua.cast(sceneChildArray:objectAtIndex(idx-1),"CCNode")
		                if(childNode~=nil and childNode:isVisible()==true and childNode ~= self.mask)then
		                    childNode:setVisible(false)
		                    -- childNode:setTouchEnabled(false)
		                    self.visibleViews:addObject(childNode)
		                end
		               
		               if(childNode and childNode.isTouchEnabled and childNode:isTouchEnabled()==true)then
		                  childNode:setTouchEnabled(false)
		                  self.touchableViews:addObject(childNode)
		               end
		            end
		end

		function BattleRecordShowSecondMediator:setVisibles( ... )
			
		end

	   function BattleRecordShowSecondMediator:resumeStage( ... )
		   	 if(self.visibleViews~=nil)then
		           for idx=1,self.visibleViews:count() do
		               local childNode = tolua.cast(self.visibleViews:objectAtIndex(idx-1),"CCNode")
		               if(childNode~=nil)then
		                   childNode:setVisible(true)
		               end
		           end
		           self.visibleViews:removeAllObjects()
		           self.visibleViews:release()
		           self.visibleViews = nil
		      end


		      if(self.touchableViews~=nil)then
		           for idx=1,self.touchableViews:count() do
		               local childNode = tolua.cast(self.touchableViews:objectAtIndex(idx-1),"CCLayer")
		               if(childNode~=nil)then
		                   childNode:setTouchEnabled(true)
		               end
		           end
		           self.touchableViews:removeAllObjects()
		           self.touchableViews:release()
		           self.touchableViews = nil
		      end
	   end
return BattleRecordShowSecondMediator