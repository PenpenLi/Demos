

local SingleBattleMediator = class("SingleBattleMediator")
SingleBattleMediator.name 			= "SingleBattleMediator"

 
	------------------ properties ----------------------
	

	------------------ functions -----------------------
	function SingleBattleMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_SINGLE_BATTLE_INI,					-- 初始化
					NotificationNames.EVT_PLAY_RECORD_COMPLETE, 				-- 单场战斗完成
		            NotificationNames.EVT_CLOSE_RESULT_WINDOW,
		            NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE,
                  -- NotificationNames.EVT_REPLAY_RECORD-- 重播
                NotificationNames.EVT_REPLAY_RECORD,-- 重播
                NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_COMPLETE,
                NotificationNames.EVT_CHANGE_SCENE_PAUSE,
                NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE
                
				}
	end
	function SingleBattleMediator:onRegest( ... )
		-- self:cacheStage()
	end -- function end

  function SingleBattleMediator:cacheStage()

           ObjectTool.loadRoleAnimation()
   
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
                if(childNode~=nil and childNode:isVisible()==true)then
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

	function SingleBattleMediator:onRemove( ... )
		-- local  instance 	= require("EventBus"):instance()
		-- local  eventNames	= self.getInterests()
		-- for i,eventName in ipairs(eventNames) do
		-- 	instance.removeEventListener(eventName,handleNotifications)
		-- end -- for end

      BattleDataProxy.removeEvent()
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
        Logger.debug("!!!! SingleBattleMediator:onRemove")
      
	end -- function end

	function SingleBattleMediator:getHandler()
		return self.handleNotifications
	end-- function end


   -- function SingleBattleMediator:cacheStage()
      
   --          local scene = CCDirector:sharedDirector():getRunningScene()
            
   --          ---[[
   --          self.visibleViews = CCArray:create()
   --          self.touchableViews = CCArray:create()

   --          self.visibleViews:retain()
   --          self.touchableViews:retain()

   --          local sceneChildArray = scene:getChildren()
   --          for idx=1,sceneChildArray:count() do
   --              ----print("childNode:",idx,sceneChildArray:count() )
   --              local childNode = tolua.cast(sceneChildArray:objectAtIndex(idx-1),"CCNode")
   --              if(childNode~=nil and childNode:isVisible()==true)then
   --                  childNode:setVisible(false)
   --                  -- childNode:setTouchEnabled(false)
   --                  self.visibleViews:addObject(childNode)
   --              end
               
   --             if(childNode and childNode.isTouchEnabled and childNode:isTouchEnabled()==true)then
   --                childNode:setTouchEnabled(false)
   --                self.touchableViews:addObject(childNode)
   --             end
   --          end
   -- end

	function SingleBattleMediator:handleNotifications(eventName,data)
		if eventName ~= nil then
			-- 初始化单场战斗
			if eventName == NotificationNames.EVT_SINGLE_BATTLE_INI then
				  
          EventBus.regestMediator(require("script/battle/mediator/BattleBackGroundMediator"))     
          EventBus.regestMediator(require("script/battle/mediator/BattleRecordPlayMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleResultWindowMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleLoadSourceMediator"))
          -- EventBus.regestMediator(require("script/battle/mediator/BattleFormationMediator"))
          -- EventBus.regestMediator(require("script/battle/mediator/StrongHoldMediator"))
          -- EventBus.regestMediator(require("script/battle/mediator/BattleTeamShowMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleInfoUIMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleChangeSceneShowMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleTouchScreenShowNameMediator"))
          EventBus.regestMediator(require("script/battle/mediator/BattleBenchInfoMediator"))
          
          -- EventBus.regestMediator(require("script/battle/mediator/BattleTalkMediator"))
          -- 初始化屏幕参数
          BattleMainData.iniScreenParameter()       
					-- 动作渲染开始
          BattleActionRender.start()
          print("--- EVT_SINGLE_BATTLE_INI")
          EventBus.sendNotification(NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_START)
     --     -- 创建战斗场景层
     --      BattleLayerManager.createLayers()
          


					-- -- 初始化背景
					-- EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())
					
					-- --刷新ui数据
					-- BattleMainData.refreshBattleTeamDisplayData()

					-- -- 初始化ui信息[todo]

     --      -- 创建队伍人员显示
     --      	BattleTeamDisplayModule.createHeroDisplayToMainData()

     --  	  -- 链接战斗数据的display
     --      BattleMainData.linkAndRefreshHeroesDisplay()

         
			  --   --初始化ui
     --      EventBus.sendNotification(NotificationNames.EVT_UI_INI)
     --      -- 显示变速按钮
     --      EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
     --      -- 显示调过战斗按钮
     --      EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
          
     --      -- 播放背景音乐
     --      BattleMainData.playBackGroundMusic()

     --      -- 开启显示名字
     --      EventBus.sendNotification(NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME)

        elseif eventName == NotificationNames.EVT_CHANGE_SCENE_PAUSE then
            -- 黑幕暂停 开始预加载
            -- 开始异步加载
            EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_START,BattleMainData.fightRecord.battleObject)
                        


        elseif eventName == NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE then

              EventBus.sendNotification(NotificationNames.EVT_SINGLE_CHANGE_SCENE_RESUME)

        elseif eventName == NotificationNames.EVT_SINGLE_BATTLE_CHANGE_SCENE_COMPLETE then

          -- 显示变速按钮
          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
          -- 显示调过战斗按钮
          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)

          -- 显示替补ui
          EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_ADD)
          EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING)
          -- 创建主船ui
          BattleShipDisplayModule.iniShipDisplay()

            -- 播放战斗录像
          EventBus.sendNotification(NotificationNames.EVT_PLAY_RECORD_START)
        -- 重播
        elseif eventName == NotificationNames.EVT_REPLAY_RECORD then
          -- BattleMainData.fightRecord:resetToStart()
          
          -- BattleTeamDisplayModule.createHeroDisplayToMainData()
          -- BattleMainData.fightRecord:linkAndRefreshHeroesDisplay()

          -- 貌似结束面板有音乐把背景音乐顶了,我们再播一遍
          -- 播放背景音乐
          BattleMainData.playBackGroundMusic()

          BattleMainData.fightRecord:resetToStart()
           
          BattleMainData.refreshBattleTeamDisplayData()

          BattleTeamDisplayModule.removeAll()

          -- 创建队伍人员显示
          BattleTeamDisplayModule.createHeroDisplayToMainData()

          -- 链接战斗数据的display
          BattleMainData.linkAndRefreshHeroesDisplay()

          BattleMainData.canJumpBattle = true



          -- 显示变速按钮
          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
          -- 显示调过战斗按钮
          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
 			    
          -- 开启显示名字
          EventBus.sendNotification(NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME)
          EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM)

        -- 战斗录像播放完毕
        elseif eventName == NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE then
				 	
           -- 停止触屏显示名字功能
           EventBus.sendNotification(NotificationNames.EVT_DISABLE_TOUCH_SHOW_NAME)

				 	EventBus.sendNotification(NotificationNames.EVT_SHOW_RESULT_WINDOW)
			   
          -- 结算面板出现时,删除调过按钮和加速按钮
          EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)  
          EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SPEED_BT) 

       -- elseif eventName == NotificationNames.EVT_REPLAY_RECORD then --重播
       --     EventBus.removeMediator("BattleResultWindowMediator")

			 elseif eventName == NotificationNames.EVT_CLOSE_RESULT_WINDOW then
					
					EventBus.removeMediator("BattleBackGroundMediator")
                	BattleTeamDisplayModule.removeAll()


                	  -- --print("结束退出战斗模块")
                      --print("############## StrongHoldMediator 结束退出战斗模块")
                     EventBus.removeMediator("BattleBackGroundMediator")
                     EventBus.removeMediator("BattleRecordPlayMediator")
                     EventBus.removeMediator("BattleResultWindowMediator")
                     EventBus.removeMediator("BattleFormationMediator")
                  
                     EventBus.removeMediator("BattleTeamShowMediator")
                     EventBus.removeMediator("BattleInfoUIMediator")
                     EventBus.removeMediator("BattleTalkMediator")
                      BattleTeamDisplayModule.removeAll()
                      BattleLayerManager.release()
                      SpriteFramesManager.release()
                      CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()
                      BattleShipDisplayModule.release()
                      -- BattleLayer.closeLayer() -- 移出战斗场景层, 老的战斗模块
                      BattleState.setPlaying(false)
                      -- BattleMainData.runCompleteCallBack()
                      local request = BattleMainData.getCallBackRequest()
                      require "script/module/switch/SwitchCtrl"
                      -- SwitchCtrl.postBattleNotification("END_BATTLE") -- 2014.11.24 应小周要求单场战斗不发
                      EventBus.removeMediator("SingleBattleMediator")
                 
                     EventBus.release()
                     BattleActionRender.removeAll()
                     BattleMainData.releaseData()
                     AudioHelper.stopMusic()
                     BattleNodeFactory.release()
                     request()
                     CCTextureCache:sharedTextureCache():removeUnusedTextures()
                     -- print("---------dump---------")
                     -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
                     BattleModule.destroy()
			end
		end
	end -- function EVT_CLOSE_RESULT_WINDOW
return SingleBattleMediator