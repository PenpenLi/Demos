
 

	-- 屏幕截图
 	
 	-- 出场人物: 主角 + 新手娘 
 	--          青雉

 	-- 切屏动画

 	-- 敌方剩余人物移动入场


	--  对话1
	-- 白胡子入场特效 + 白胡子显示
	-- 对话
	
	-- 艾斯入场特效 + 艾斯显示
	-- 对话

	-- 新手娘消失

	-- 开始播放战斗

	-- 对话

	-- 战斗结束

local BattleRecordShowFirstMediator = class("BattleRecordShowFirstMediator")
 
	------------------ properties ----------------------
		BattleRecordShowFirstMediator.name 			= "BattleRecordShowFirstMediator"

		-- 战斗中对话
		BattleRecordShowFirstMediator.recordTalks  = {}
		-- BattleRecordShowFirstMediator.recordTalks["2"] = 204
		-- BattleRecordShowFirstMediator.recordTalks["4"] = 201
		-- BattleRecordShowFirstMediator.recordTalks["2"] = 2
		
		
		-- BattleRecordShowFirstMediator.xinshouniangTeamid 	= 1 	-- 新手娘队伍id
		-- BattleRecordShowFirstMediator.xinshouniangIndex 	= 4 	-- 新手娘位置索引
		-- BattleRecordShowFirstMediator.xinshouniangHtid 		= 10010 -- 新手娘模板id
		-- BattleRecordShowFirstMediator.xinshouniangHid   	= 10000001 -- 新手娘hid
		-- BattleRecordShowFirstMediator.xinshouniangDisplay  	= nil   -- 新手娘显示实例
		
		-- 主角位置索引
		BattleRecordShowFirstMediator.playerPosition 		= 1
		BattleRecordShowFirstMediator.moveSelfTalk 			= 199


		BattleRecordShowFirstMediator.maskAnimation 		= "heimu"
		BattleRecordShowFirstMediator.selfPostion 			= 1


		-- 隐藏目标
		BattleRecordShowFirstMediator.selfHides				= {0,1,2}    -- 己方上场隐藏人物
		BattleRecordShowFirstMediator.armyHides				= {1,3,4,5}    -- 敌方上场隐藏人物

	 

	 	-- 黑块移出

	 	-- 敌方剩余人物移动入场
	 	BattleRecordShowFirstMediator.armyMoveInByPositions = {3,4,5}

 


		--  对话1
		BattleRecordShowFirstMediator.talk1  			 	= 201


		-- 青雉入场特效
		BattleRecordShowFirstMediator.FadeIn0Effect			= {"meffect_36","meffect_36_1","meffect_36_2"}

		-- 青雉索引
		BattleRecordShowFirstMediator.FadeIn0Postion        = 1
		-- 青雉对话
		BattleRecordShowFirstMediator.show_0_talk			= 200


		-- 白胡子入场特效 + 白胡子显示
		BattleRecordShowFirstMediator.FadeIn1Effect			= "meffect_6"
		-- 白胡子索引
		BattleRecordShowFirstMediator.FadeIn1Postion        = 0
		-- 对话
		BattleRecordShowFirstMediator.show_1_talk			= 202
		
		-- 艾斯入场特效 + 艾斯显示
		BattleRecordShowFirstMediator.FadeIn2Effect			= "meffect_34"
		-- 对话
		BattleRecordShowFirstMediator.show_2_talk			= 203
		-- 艾斯位置索引
		BattleRecordShowFirstMediator.FadeIn2Postion        = 2

		-- 战斗结束对话 
		BattleRecordShowFirstMediator.recordCompleteTalk 	= 205

		--背景
		BattleRecordShowFirstMediator.bgName 				= BATTLE_CONST.TUTORIAL1_BACKGROUND -- 背景名称
		BattleRecordShowFirstMediator.bgMusic				= nil -- 背景音乐
		-- 音乐
		BattleRecordShowFirstMediator.music 				= "1.mp3"

		BattleRecordShowFirstMediator.mask 					= nil -- 转场

		BattleRecordShowFirstMediator.progressCall 			= nil -- 战斗结束,播放转出场特效中途,需要外部模块显示,但是不进行逻辑的回调
		------------------ functions -----------------------
		function BattleRecordShowFirstMediator:getInterests( ... )
			-- local  ins = require("script/notification/NotificationNames")
			return {	
						NotificationNames.EVT_SINGLE_BATTLE_INI ,-- 初始化
	 					NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE -- 战斗录像播放完成
					}
		end

		-- -- 创建新手娘
		-- function BattleRecordShowFirstMediator:creatXinShowNiang( ... )
		-- 	local result = require("script/battle/data/BattleObjectCardUIData").new()
		-- 	result:reset(
		-- 					self.xinshouniangHid,  
		-- 					self.xinshouniangHtid,  
		-- 					self.xinshouniangIndex,
		-- 					self.xinshouniangTeamid
		--  				)

		-- 	self.xinshouniangDisplay 			= require("script/battle/ui/BattlPlayerDisplay").new()
		-- 	self.xinshouniangDisplay:reset(result)
	 --    	self.xinshouniangDisplay:setParent(BattleLayerManager.battlePlayerLayer)

		-- 	-- BattleObjectCardUIData
		-- end
		-- -- 删除新手娘
		-- function BattleRecordShowFirstMediator:removeXinShouNiang( ... )
		-- 	if(self.xinshouniangDisplay) then
		-- 		self.xinshouniangDisplay:release()
		-- 		self.xinshouniangDisplay = nil
		-- 	end
		-- end
		-- 隐藏目标
		function BattleRecordShowFirstMediator:hideTargets( ... )
			for k,postion in pairs(self.selfHides) do
			 	local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(postion)
			 	display:setVisible(false)
			end

			for k,postion in pairs(self.armyHides) do
			 	local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(postion)
			 	display:setVisible(false)
			end

		end
		-- 剩余敌军引动入场
		function BattleRecordShowFirstMediator:moveArmy( ... )
			local  targets = {}
			for k,postion in pairs(self.armyMoveInByPositions) do
              	 local display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(postion)
              	 display:setVisible(true)
              	 table.insert(targets,display)
            end
			local moveAction = require("script/battle/action/BAForMoveTargetsTo").new()
			moveAction.targets = targets
			--print("BattleRecordShowFirstMediator moveDistence:", BattleMainData.moveDistence)
			moveAction.moveDistence = BattleMainData.moveDistence
			moveAction:addCallBacker(self,self.onMoveArmyComplete)
			moveAction:start()
		end

		function BattleRecordShowFirstMediator:moveSelf( ... )

			local moveAction = require("script/battle/action/BAForMoveTargetsTo").new()
			local targets = {}
			local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.selfPostion)
			display:setVisible(true)
			 table.insert(targets,display)
			moveAction.targets = targets
			--print("BattleRecordShowFirstMediator moveDistence:", BattleMainData.moveDistence)
			moveAction.moveDistence = BattleMainData.moveDistence
			moveAction.direction	= BATTLE_CONST.DIR_DOWN
			moveAction:addCallBacker(self,self.onMoveSelfComplete)
			moveAction:start()
			 print("moveSelf start")
		end

		function BattleRecordShowFirstMediator:onMoveSelfComplete( ... )
			    -- 自己移动完毕
			    print("onMoveSelfComplete")
            
              	self:playTalk(self.moveSelfTalk,function( ... )
		        	self:showHero0()
		        end)

		end


		function BattleRecordShowFirstMediator:playTalk( talkid,callback )
			-- require "script/module/talk/TalkCtrl"
			 Logger.debug("============= 创建对话:" .. talkid)
			 TalkCtrl.create(talkid)
		     TalkCtrl.setCallbackFunction(callback)
		

		end
		-- 移动完毕
		function BattleRecordShowFirstMediator:onMoveArmyComplete( ... )
			--  对话1
		 	
			self:playTalk(self.talk1,function( ... )
		        	self:onTalk1Complete()
		        end)
			 
		end



		-- 显示青雉
		function BattleRecordShowFirstMediator:showHero0()
			display = BattleTeamDisplayModule.getArmyTeamHeroByPostion(self.FadeIn0Postion)
			--  -- 青雉入场特效 + 青雉显示
			-- local showEffect =  require("script/battle/action/BAForPlayEffectAtHero").new()
			-- showEffect.heroUI = display
			-- showEffect.atPostion = BATTLE_CONST.POS_MIDDLE
			-- showEffect.animationName = self.FadeIn0Effect
			-- showEffect.downTarget = false
		 -- 	showEffect:addCallBacker(self,self.play_show_0_talk)
		 -- 	showEffect:start()
					

			-- display.container:setVisible(true)
			-- display.container:setOpacity(0)
			-- local actionArray = CCArray:create()
   --       	actionArray:addObject(CCFadeIn:create(0.1))
 
   --       	display.container:runAction(CCSequence:create(actionArray))


         	self:playThreeAsOne1(
         						  self.FadeIn0Effect[1],
         						  self.FadeIn0Effect[2],
         						  self.FadeIn0Effect[3],
         						  display,
         						  function ( ... )
         						   self:play_show_0_talk()
         						  end,
         						  true)
         	
		end

	function BattleRecordShowFirstMediator:addAnimationToTargetPostion(target,animation,downTarget,addtoCenter)
			if(addtoCenter ~= true) then
				local postion = target:globalCenterPoint()
	         
	            animation:setPosition(postion.x,postion.y)
	           	Logger.debug("setPosition:"..postion.x.. " ," .. postion.y)

	          	-- if(downTarget ~= true) then
				BattleLayerManager.battleAnimationLayer:addChild(animation)
			else
				local postion = target:globalCenterPoint()
	         	
 
				BattleLayerManager.battleAnimationLayer:addChild(animation)
				animation:setPosition(g_winSize.width/2,g_winSize.height/2)
	           	Logger.debug("setPosition addtoCenter:"..postion.x.. " ," .. postion.y)
			end
			-- else
			-- 	BattleLayerManager.battleBackGroundLayer:addChild(self.animation)
			-- end
	end
	 -- 播放三个组合的动画 第1个关键帧触发第二个,第二个
	 function BattleRecordShowFirstMediator:playThreeAsOne1( first,second,third ,target,callback,addtoCenter)
 			
 			Logger.debug("playThreeAsOne1:".. first .. " 2:" ..second .. " 3:" .. third .. " addtoCenter:" .. tostring(addtoCenter))
 			-- 生成第一个动画
 			local animation1 = ObjectTool.getAnimation(first,false)
 			self:addAnimationToTargetPostion(target,animation1,false,addtoCenter)
 			BattleSoundMananger.playEffectSound(first)
 			animation1:setZOrder(999)
 			Logger.debug("playThreeAsOne11")
 			-- 第1个动画的关键帧触发第二个动画播放
			local fnFrameCall1 = function ( bone, frameEventName, originFrameIndex, currentFrameIndex )
					Logger.debug("playThreeAsOne13")
					local animation2 = ObjectTool.getAnimation(second,false)
					self:addAnimationToTargetPostion(target,animation2,false,addtoCenter)
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
								self:addAnimationToTargetPostion(target,animation3,false,false)
								BattleSoundMananger.playEffectSound(third)
								-- 第二个动画完成回调
						  		local fnMovementCall3 = function ( sender, MovementEventType )
						  			-- 删除第二个动画
						  			if (MovementEventType == EVT_COMPLETE) then 
											-- ObjectTool.removeObject(animation3)
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
 						ObjectTool.removeAnimationByName(first,animation1,true)
 						-- CCTextureCache:sharedTextureCache():removeUnusedTextures()

 					end

 			end
			animation1:getAnimation():setFrameEventCallFunc(fnFrameCall1)
	 		animation1:getAnimation():setMovementEventCallFunc(fnMovementCall1)

 	end -- f end


		--青雉对话
		function BattleRecordShowFirstMediator:play_show_0_talk( ... )
			self:playTalk(self.show_0_talk,function( ... )
		        	self:moveArmy()
		        end)
		end

		-- 对话1完毕
		function BattleRecordShowFirstMediator:onTalk1Complete( talkid )
			 
			 
			local  display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeIn1Postion)
			-- function showEffect( ... )
			display:setVisible(true)
			 	-- 白胡子入场特效 + 白胡子显示
				local showAnimation =  require("script/battle/action/BAForPlayEffectAtHero").new()
			 
				showAnimation.heroUI = display
				showAnimation.atPostion = BATTLE_CONST.POS_MIDDLE
				showAnimation.animationName = self.FadeIn1Effect
			 	-- showAnimation:addCallBacker(self,self.onFadeInFirstComplete)
			 	showAnimation.downTarget = true
			 	showAnimation:start()

			 	local shakeScreen = require("script/battle/action/BAForShakeScreen").new()
			 	shakeScreen.total = 0.4
			 	shakeScreen:start()

			-- end
			
			local onXMLComplete = function ( ... )
				self:onFadeInFirstComplete()
			end
			display:playXMLAnimationWithCallBack( "xialuo",self,onXMLComplete,false)

		 	-- local  display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeIn1Postion)
			-- display:setVisible(true)
			-- display:setOpacity(0)
			-- -- local actions  =  CCArray:create()

 			
			-- display.boneBinder:setScale(2)
 		-- 	local actionArray = CCArray:create()
   --       	actionArray:addObject(CCSpawn:createWithTwoActions(CCFadeIn:create(0.2),CCScaleTo:create(0.1,1)))
   --       	actionArray:addObject(CCCallFuncN:create(showEffect))
 
   --       	display.boneBinder:runAction(CCSequence:create(actionArray))
 

		end
		-- 白胡子显示完毕
		function BattleRecordShowFirstMediator:onFadeInFirstComplete()
			


		


			--白胡子出场对话
			self:playTalk(self.show_1_talk,function( ... )
		        	self:showSecondHero()
		        	end)


		end
		-- 显示艾斯(第二个英雄)
		function BattleRecordShowFirstMediator:showSecondHero( ... )

			display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeIn2Postion)
			 -- 白胡子入场特效 + 白胡子显示
			local showEffect =  require("script/battle/action/BAForPlayEffectAtHero").new()
			showEffect.heroUI = display
			showEffect.atPostion = BATTLE_CONST.POS_FEET
			showEffect.animationName = self.FadeIn2Effect
			showEffect.downTarget = false
		 	showEffect:addCallBacker(self,self.onFadeInSecondComplete)
		 	showEffect:start()
 			

 			display:setVisible(true)
			display:setOpacity(0)
		    local actionArray = CCArray:create()
         	actionArray:addObject(CCDelayTime:create(0.5))
         	actionArray:addObject(CCFadeIn:create(0.3))
 
         	display.boneBinder:runAction(CCSequence:create(actionArray))   
		 
		end

		-- 艾斯显示完毕
		function BattleRecordShowFirstMediator:onFadeInSecondComplete()
			local  display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(self.FadeIn2Postion)
			-- display:setVisible(true)
				-- display:setVisible(false)
			
			 
			-- display:setVisible(true)
			-- display:setOpacity(0)
			

			-- local actionArray = CCArray:create()
   --       	 actionArray:addObject(CCFadeOut:create(0.35))
 
   --       	 display.container:runAction(CCSequence:create(actionArray))
         	 
			-- 艾斯出场动画
				self:playTalk(self.show_2_talk,function( ... )
		        	-- self:removeXinShouNiang()
		        	-- 播放战斗
		        	  -- 播放战斗录像
		        	 local talk = {}
		        	  talk.fightingTalks = self.recordTalks
              		EventBus.sendNotification(NotificationNames.EVT_PLAY_RECORD_START,talk)
              		 -- 显示调过战斗按钮
          	 		-- EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
		        	end)
		end

		 

		function BattleRecordShowFirstMediator:onRegest( ... )
			-- 注册回调
			--print("BattleRecordShowFirstMediator onRegest")
 			
			-- EventBus.addEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete,self)
		end -- function end

		function BattleRecordShowFirstMediator:onRemove( ... )

			self.afterTalkRun = self.AFTER_TALK_NONE
			EventBus.removeEventListener(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,self.onFormationComplete)
	 
		end -- function end

		function BattleRecordShowFirstMediator:getHandler()
			return self.handleNotifications
		end

	 

		-- 转场特效
		 function BattleRecordShowFirstMediator:moveMaskIn( ... )
 
		 -- 	local scene = CCDirector:sharedDirector():getRunningScene()
 
    			self.changeAction = require("script/battle/action/BAForShowChangeSceneEffect").new()
			-- self.changeAction:addCallBacker(self,self.showEffectHeroes)
				self.changeAction:renderScreen()



		 	  self:cacheStage()
		 	  self.changeAction.screen:setVisible(true)
		 	  -- 初始化屏幕参数
	          BattleMainData.iniScreenParameter()       
			  -- 动作渲染开始
	          BattleActionRender.start()
	          -- 创建战斗场景层
	          BattleLayerManager.createLayers()
	          self.changeAction.screen:setVisible(true)


    		  -- 初始化背景
			  EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,self.bgName)
			  EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_SET_POSTION,4)
			
			  -- 同步主角htid
			  -- local playerdata = BattleMainData.fightRecord:indexTeam1PlayerDataByPosition(self.playerPosition)
			  -- playerdata.htid = UserModel.getUserInfo().htid
			  
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
													      
			self.moveInEffectAction 				= require(BATTLE_CLASS_NAME.BAForPlayAnimationByFrame).new()
			self.moveInEffectAction.animationName 	= self.maskAnimation
			self.moveInEffectAction.container 		= CCDirector:sharedDirector():getRunningScene()
			self.moveInEffectAction.zOder 			= 99999
 
 			 
				  			local fnMovementCall2 = function ( sender, MovementEventType )
					  		 
						  			-- if (MovementEventType == EVT_COMPLETE) then 
											-- ObjectTool.removeObject(animation)
											self.moveInEffectAction:release()
											CCTextureCache:sharedTextureCache():removeUnusedTextures()
											self:moveSelf()
											
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


													              -- animation:getAnimation():resume()
											            end
					 		end
					 		-- resume

			self.moveInEffectAction.evtFrameCallBack = fnFrameCall
			self.moveInEffectAction.completeCallBack = fnMovementCall2
		 	self.moveInEffectAction:start()
 
				
 
           
		 end

		 -- function BattleRecordShowFirstMediator:moveMaskOut( ... )
		 -- 		local onMaskMoveOutComplete = function ( ... )
   --  				 self:moveSelf()

   --  			end
   --  			local gWinSize = CCDirector:sharedDirector():getWinSize()
		 -- 	 	local actionArray = CCArray:create()
    			 
			-- 	actionArray:addObject(CCMoveTo:create(0.5, ccp(-gWinSize.width,0)))
			-- 	actionArray:addObject(CCCallFuncN:create(onMaskMoveOutComplete))
			-- 	self.mask:stopAllActions()
			-- 	self.mask:runAction(CCSequence:create(actionArray))
		 -- end

		function BattleRecordShowFirstMediator:handleNotifications(eventName,data)
			if eventName ~= nil then
				-- 开始播放战报
				if eventName == NotificationNames.EVT_SINGLE_BATTLE_INI then


				  EventBus.regestMediator(require("script/battle/mediator/BattleBackGroundMediator"))     
		          EventBus.regestMediator(require("script/battle/mediator/BattleRecordPlayMediator"))
		          EventBus.regestMediator(require("script/battle/mediator/BattleResultWindowMediator"))
	          	  EventBus.regestMediator(require("script/battle/mediator/BattleInfoUIMediator"))
	          	  EventBus.regestMediator(require("script/battle/mediator/BattleTalkMediator"))

		          self.progressCall = data
		       
		          self:moveMaskIn()
				
				elseif eventName == NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE then

					Logger.debug("==> BattleRecordShowFirstMediator:handleNotifications EVT_BATTLE_RECORD_PLAY_COMPLETE")
					BattleNodeFactory.release()
					CCTextureCache:sharedTextureCache():removeUnusedTextures()
					
					self:playTalk(
									self.recordCompleteTalk,
									function( ... )
		        	-- 						self.changeAction = require("script/battle/action/BAForShowChangeSceneEffect").new()
											-- self.changeAction:addCallBacker(self,self.onTranScreenComplete)
											-- self.changeAction:renderScreen()
											
											self.moveInEffectAction 				= require(BATTLE_CLASS_NAME.BAForPlayAnimationByFrame).new()
											self.moveInEffectAction.animationName 	= self.maskAnimation
											self.moveInEffectAction.container 		= CCDirector:sharedDirector():getRunningScene()
											self.moveInEffectAction.zOder 			= 99999

											
						                      
											-- self.changeAction:start()
											local evtIni = false
											local fnFrameCall 	 = function ( ... )
																	  if(evtIni == false) then
																	  		evtIni = true
																	  		--删除前景
																	  		-- self.changeAction:release()
																	  		-- self.changeAction = nil
																	  		EventBus.removeMediator("BattleBackGroundMediator")
														                    EventBus.removeMediator("BattleRecordPlayMediator")
														                    EventBus.removeMediator("BattleResultWindowMediator")
														                  
														                    EventBus.removeMediator("BattleInfoUIMediator")
														                    EventBus.removeMediator("BattleTalkMediator")
														                    
														                    
														                   
														                 	self:resumeStage()
														                 	BattleTeamDisplayModule.removeAll()
														                	BattleLayerManager.release()
														                	
														                	-- 
														                	Logger.debug("== fnFrameCall:" .. tostring(self.progressCall))
														                 	if(self.progressCall) then
														                    	self.progressCall()
														                    	self.progressCall = nil
														                    end
														                   
																	  end -- if end
																   end

											local fnMovementCall = function ( ... )

																		self:onTranScreenComplete()
																   end

											self.moveInEffectAction.evtFrameCallBack = fnFrameCall
											self.moveInEffectAction.completeCallBack = fnMovementCall
										 	self.moveInEffectAction:start()

											-- self:cacheStage()
		        					end

								 )

				end

			end
		end -- function end

		function BattleRecordShowFirstMediator:onTranScreenComplete( ... )
			
				EventBus.removeMediator("BattleRecordShowFirstMediator")
                -- self:resumeStage()
                EventBus.release()
                BattleActionRender.removeAll()
                local request = BattleMainData.getCallBackRequest()
                BattleMainData.releaseData()
                BattleState.setPlaying(false)
                -- BattleMainData.runCompleteCallBack()
               
                CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()
                request()
    --             require "script/module/switch/SwitchCtrl"
				-- SwitchCtrl.postBattleNotification("END_BATTLE")
		end

		function BattleRecordShowFirstMediator:cacheStage()
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

	   function BattleRecordShowFirstMediator:resumeStage( ... )
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
return BattleRecordShowFirstMediator