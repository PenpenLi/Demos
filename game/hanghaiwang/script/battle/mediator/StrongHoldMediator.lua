local StrongHoldMediator = class("StrongHoldMediator")
 
	------------------ properties ----------------------
	
	StrongHoldMediator.name 									  = "StrongHoldMediator"
  StrongHoldMediator.teamShow                 = nil
  StrongHoldMediator.quitCallBack             = nil
  StrongHoldMediator.jumped                   = nil -- 是否跳过战斗
  StrongHoldMediator.battleCount              = nil -- 战斗次数
  StrongHoldMediator.battleResults            = nil
  StrongHoldMediator.hasIni                   = nil
  -- StrongHoldMediator.needConfigFormation      = nil
	------------------ functions -----------------------
	function StrongHoldMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
          NotificationNames.EVT_STRONGHOLD_INI,               -- 初始化
					-- NotificationNames.EVT_STRONGHOLD_START_INI_COMPLETE,					      -- 初始化
 					NotificationNames.EVT_FORMATION_COMPLETE_CONFIG,		-- 阵型配置完成
					-- NotificationNames.EVT_BACKGROUND_SCROLL_COMPLETE ,		-- 地图背景滚动完毕
					-- NotificationNames.EVT_BATTLE_REQUEST_COMPLETE,		-- 战斗数据请求完毕
					NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE, 	-- 战斗录像播放完毕
					NotificationNames.EVT_ENTER_LEVEL_SUCCESS, 				  -- 进入strongHold完成
					-- NotificationNames.EVT_PLAY_RECORD_COMPLETE, 				-- 单场战斗完成
          NotificationNames.EVT_TEAM_SHOW_COMPLETE,           -- 出场动画完成
          NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS,  -- 战斗录像数据完毕
          NotificationNames.EVT_CLOSE_RESULT_WINDOW,          -- 结束画面关闭
          NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,   -- 阵型获取成功
          NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE,  -- 预加载完成
          NotificationNames.EVT_BATTLE_AUTO_FIGHT,            -- 点击了托管
          NotificationNames.EVT_TEAM_ENDSHOW_COMPLETE,         -- 退场特效完毕
          NotificationNames.EVT_CHANGE_SCENE_PAUSE,         -- 换场特效暂停,后续需要管理器加载相关资源
          NotificationNames.EVT_CHANGE_SCENE_COMPLETE       -- 换场特效完成
				}
	end
	function StrongHoldMediator:onRegest( ... )
      -- self:cacheStage()
      self.battleCount = 0
      self.hasIni     = false
	end -- function end

	function StrongHoldMediator:onRemove( ... )
		    self.hasIni = false
        self.battleCount = 0
        BattleDataProxy.removeEvent()

        if(self.quitCallBack ~= nil) then
           self.quitCallBack = nil
        end
        
        Logger.debug("!!!! StrongHoldMediator:onRemove")
   

	end -- function end

	function StrongHoldMediator:getHandler()
		return self.handleNotifications
	end

   function StrongHoldMediator:cacheStage()


            ObjectTool.loadRoleAnimation()
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
  -- 播放开始对话
  function StrongHoldMediator:showTalk(callback,talkId)
      -- local talkId = BattleMainData.strongholdData:getCurrentArmyData().startTalkid
      if(talkId and talkId > 0) then
          -- require "script/module/talk/TalkCtrl"
          TalkCtrl.create(talkId)
          TalkCtrl.setCallbackFunction(callback)
      else
          callback()
      end
  end
 
  function StrongHoldMediator:startPlayRecord( ... )
    
                -- 显示调过战斗按钮
            -- if(BattleMainData.strongholdData.canJumpBattle) then
            EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SKIP_BT)
            -- end

            
            -- 设置录像用的战斗索引
            BattleState.setBattleIndex(BattleMainData.strongholdData.index)

            local armyData          = BattleMainData.strongholdData:getCurrentArmyData()
            local roundLogic        = nil
            if(armyData) then
              local has  = db_battlingShow_util.hasArmyLogic(armyData.id)
              if(has) then
                roundLogic = db_battlingShow_util.getItemByid(armyData.id)
              end
            end


            --  -- 开始播放录像
            EventBus.sendNotification(NotificationNames.EVT_PLAY_RECORD_START,
                                      roundLogic)
            -- -- 开启显示名字
            EventBus.sendNotification(NotificationNames.EVT_ENABLE_TOUCH_SHOW_NAME)
  end
	function StrongHoldMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		--print("StrongHoldMediator handleNotifications call:",eventName,"data:",data)
            	if eventName ~= nil then


                  -- 初始化 
         			if eventName == NotificationNames.EVT_STRONGHOLD_INI then
                     


                      if(type(data) == "function") then
                        self.quitCallBack = data 
                      else
                        error("StrongHoldMediator:ini error")
                      end


                      --print("############## StrongHoldMediator 初始化")
                    
                      EventBus.regestMediator(require("script/battle/mediator/BattleBackGroundMediator"))     
                      EventBus.regestMediator(require("script/battle/mediator/BattleRecordPlayMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleResultWindowMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleFormationMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/StrongHoldMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleTeamShowMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleInfoUIMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleTalkMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleLoadSourceMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleChangeSceneShowMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleTouchScreenShowNameMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleChestMediator"))
                      EventBus.regestMediator(require("script/battle/mediator/BattleBenchInfoMediator"))
                      -- EventBus.regestMediator(require("script/battle/mediator/BattleStrongHoldInitializeMediator"))
                      
                      if(BattleMainData.copyType == COPY_TYPE_EVENT_BELLT) then
                        EventBus.regestMediator(require("script/battle/mediator/BattleEventInfoMediator"))
                      end


                      self.hasIni = false

                      -- 初始化屏幕参数
                      BattleMainData.iniScreenParameter()
                      -- 重置复活次数
                      BattleMainData.resetRevived()
                      -- 动作渲染开始
                      BattleActionRender.start()
                      -- 暂时移除事件
                      -- EventBus.removeEventListener(NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE,self)
                      -- EventBus.removeEventListener(NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS,self)

                      -- -- 开始初始化
                      -- EventBus.sendNotification(NotificationNames.EVT_STRONGHOLD_START_INI)
                        -- 开始切换场景
                      EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_START)

                  elseif eventName == NotificationNames.EVT_CHANGE_SCENE_PAUSE then  
                        -- 请求进入stronghold
                        BattleDataProxy.requestEnterLevel()  
                  -- 进入成功后我们处理阵型数据(因为有时候阵型数据没有初始化,此时需要我们亲自拉)
                  elseif eventName == NotificationNames.EVT_ENTER_LEVEL_SUCCESS then
                        

                        -- 为了杜绝阵型数据不是最新的问题,我们这里拉取下阵型数据
                        -- local cacheData = FormationModel.getFormationInfo() 
                        -- print("-- FormationModel:",cacheData)
                        -- if(cacheData == nil) then
                          --直接申请当前阵型数据
                          BattleDataProxy.requestFormationInfo()
                        -- else
                          -- EventBus.sendNotification(NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE)
                        -- end     
                    -- 阵型数据拉完了,创建据点数据
                  elseif eventName == NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE then
                          -- 创建据点数据,必须要保证阵型数据已经拉到的前提下调用
                          BattleMainData.createStrongHoldData()

                            -- 初始化背景
                          EventBus.sendNotification(NotificationNames.EVT_BACKGROUND_INI,BattleMainData.getBackGroudName())

                          -- 播放背景音乐
                          BattleMainData.playBackGroundMusic()

                           -- 创建ui
                          EventBus.sendNotification(NotificationNames.EVT_UI_INI)
                          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_SPEED_BT)
                 


                 -- 创建队伍人员显示
                       BattleTeamDisplayModule.createHeroDisplayToMainData()
                       BattleTeamDisplayModule.unvisableAll()
                  


                        
                        -- 恢复场景切换动画
                        EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_RESUME) 

                  elseif eventName == NotificationNames.EVT_CHANGE_SCENE_COMPLETE then
                      


                        
                        --- 开始出场
                        EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_START)

                        -- local ship = require(BATTLE_CLASS_NAME.BattleShipDisplay).new()
                        -- BattleLayerManager.shipLayer:addChild(ship)
                        -- ship:reset(BattleURLManager.getShipBody("ship_body_0.png"),"cannon1",false)
                        -- -- ship:setPosition(310,-20)
                        -- ship:setPosition(310,-140)
                        -- ship.teamid = 1
                        -- BattleShipDisplayModule.setShip1(ship)

                       

                        --  local ship = BattleShipDisplayModule.getTeam1Ship()

                        -- local blackBoard = require(BATTLE_CLASS_NAME.BSShipAttackBBData).new()
                        -- blackBoard.shipUI = ship
                        -- blackBoard:reset()
                        
                        -- local logic = ShipAttackLogic.getLogicData()

                        -- local action    = require(BATTLE_CLASS_NAME.BAForBSAction).new()
                        -- action.blackBoard   = blackBoard
                        -- action.logicData  = logic
                        -- action:start()


                        -- self.sequeue:push(action)

                        -- local animation = ObjectTool.getAnimation("cannon_fire1",true)
                        -- BattleLayerManager.shipLayer:addChild(animation)
                        -- animation:setPosition(330,205)

                        -- local action = require(BATTLE_CLASS_NAME.BAForShipEnterScene).new()
                        -- action.shipUI = ship
                        -- action:start()


                        -- local start = BattleGridPostion.getEnemyPointByIndex(4)
                        -- local endPo = BattleGridPostion.getPlayerPointByIndex(5)

                        -- local ro = ObjectTool.getRotation(start.x,start.y,endPo.x,endPo.y,-1)

                        -- print("=== fire angle:",ro)
                        -- local action = require(BATTLE_CLASS_NAME.BAForShipRoatationGunForAimAction).new()
                        -- action.gunUI = ship.shipGun
                        -- action.rotationTo = ro
                        -- action:start()




                  -- elseif eventName == NotificationNames.EVT_STRONGHOLD_START_INI_COMPLETE then
                  --   -- print(" == EVT_STRONGHOLD_START_INI_COMPLETE")
                  --   if(self.hasIni == false) then
                  --       EventBus.removeMediator("BattleStrongHoldInitializeMediator")
                  --       self.hasIni = true
                  --       EventBus.addEventListener(NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE,self.handleNotifications,self)
                  --       EventBus.addEventListener(NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS,self.handleNotifications,self)
                  --       EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_START)
                  --   end
                  -- 请求战斗
                  elseif eventName == NotificationNames.EVT_TEAM_SHOW_COMPLETE then
                        -- 开始配置队伍
                       EventBus.sendNotification(NotificationNames.EVT_FORMATION_START_CONFIG)

                  elseif eventName == NotificationNames.EVT_FORMATION_COMPLETE_CONFIG then
                        -- print(" == EVT_TEAM_SHOW_COMPLETE")

                        -- local currentArmyId =nil
                        -- -- if(BattleMainData.strongholdData and BattleMainData.strongholdData:getCurrentArmyData() and BattleMainData.strongholdData:getCurrentArmyData().id ~= nil) then
                        --     -- currentArmyId = BattleMainData.strongholdData:getCurrentArmyData().id
                        --     -- 如果已经有了army的战斗数据
                        --     -- 第一场战斗是已经申请了得
                        -- -- print(" EVT_BATTLE_REQUEST_DATA_SUCCESS:",BattleMainData.strongholdData:getCurrentArmyData().id,BattleMainData.strongholdData:getCurrentArmyData().dataRequested)
                        -- if(self.hasIni and BattleMainData.strongholdData:getCurrentArmyData().dataRequested ~= true) then
                               
                            -- print("-- currentArmyId:",currentArmyId,BattleMainData.fightRecord.armyid)
                            -- if(self.battleCount == 0) then
                            --    self.battleCount = self.battleCount + 1
                            -- if(self.hasIni == true) then
                        BattleDataProxy.requestDoBattle()
                           
                            -- battleResultCache[currentArmyId] = dictData.ret.fightRet
                        -- else
                        --        self:startPlayRecord()
                        -- end
                        

                  -- 战斗数据完毕,开始恢复
                  elseif eventName == NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS then
                        -- print(" ===  EVT_BATTLE_REQUEST_DATA_SUCCESS @ StrongHoldMediator :",self.battleCount)
                        self.battleCount = self.battleCount + 1
                        -- print(" EVT_BATTLE_REQUEST_DATA_SUCCESS:",BattleMainData.strongholdData:getCurrentArmyData().id,BattleMainData.strongholdData:getCurrentArmyData().dataRequested)
                        -- if(self.hasIni) then
                        

                        
                        -- 活动副本特殊逻辑:如果是最后一场那么我们需要调用指定api
                        if( BattleMainData.copyType == COPY_TYPE_EVENT  and
                           BattleMainData.strongholdData:hasNextBattle() == false) then
                            Logger.debug("---- 活动副本最后一场:" ..tostring(BattleMainData.strongholdData.index) .. "/" .. tostring(BattleMainData.strongholdData.total))
                            LoginHelper.reloginState(true)
                        else
                            Logger.debug("---- 多场信息:" ..tostring(BattleMainData.strongholdData.index) .. "/" .. tostring(BattleMainData.strongholdData.total) .. " copyType:" .. tostring(BattleMainData.copyType) .. "->活动副本类型值:" .. tostring(COPY_TYPE_EVENT))
                        end
                        --print("############## StrongHoldMediator 数据请求完毕,开始播录像",BattleMainData.printState())
                        
                       --   -- 链接战斗数据的display
                       -- BattleMainData.linkAndRefreshHeroesDisplay()
                
                       
                        -- 显示自动战斗
                        if(BattleMainData.canConfigFormation()) then
                          EventBus.sendNotification(NotificationNames.EVT_UI_SHOW_AUTO_FIGHT)
                        end

                        -- 添加贝里活动战斗ui信息
                        if(BattleMainData.copyType == COPY_TYPE_EVENT_BELLT) then
                          EventBus.sendNotification(NotificationNames.EVT_BELLY_EVENT_INFO_ADD)
                        end
                         -- 显示替补ui
                      EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_ADD)
                      EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_DATACACHE)

                      -- 显示主船数据
                       BattleShipDisplayModule.iniShipDisplay()

                       -- -- 开始异步加载
                       --  EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_START,BattleMainData.fightRecord.battleObject)
                        
                       
                        -- 初始化替补列表
                        -- EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING)



                        -- 链接战斗数据的display
                        BattleMainData.linkAndRefreshHeroesDisplay()
                         -- 开始异步加载
                        EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_START,BattleMainData.fightRecord.battleObject)
                        -- 初始化替补列表
                        EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING)
                        -- end
                        
                  -- 预加载完毕
                  elseif eventName == NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE then
                        -- print(" ===  EVT_LOAD_START_PRELOAD_COMPLETE @ StrongHoldMediator :",self.battleCount)
                        -- if(self.hasIni) then
                            self:startPlayRecord()
                        -- end
                       
                  -- 战斗录像播放完毕
                  elseif eventName == NotificationNames.EVT_BATTLE_RECORD_PLAY_COMPLETE then
                              
                              
                              self.jumped = data or false
                              -- 停止触屏显示名字功能
                              EventBus.sendNotification(NotificationNames.EVT_DISABLE_TOUCH_SHOW_NAME)
                              -- 发送ui更新信息
                              if(BattleMainData.fightRecord.isWin == true and
                                 BattleMainData.strongholdData:hasNextBattle() == true ) then
                                  self:resetEffect(data)
                              else
                                  self:playEndShow()
                                  -- self:handleNextRecord()

                              end
                              -- Logger.debug("=== record complete %s",tostring(data))
                              

                            

                  elseif eventName == NotificationNames.NotificationNames.EVT_TEAM_ENDSHOW_COMPLETE then

                                           --print("############## StrongHoldMediator 显示结束面板")
                              self:handleNextRecord()


                  elseif eventName == NotificationNames.EVT_CLOSE_RESULT_WINDOW then
                     -- --print("结束退出战斗模块")
                      --print("############## StrongHoldMediator 结束退出战斗模块")
                     EventBus.removeMediator("BattleBackGroundMediator")
                     EventBus.removeMediator("BattleRecordPlayMediator")
                     EventBus.removeMediator("BattleResultWindowMediator")
                     EventBus.removeMediator("BattleFormationMediator")
                  
                     EventBus.removeMediator("BattleTeamShowMediator")
                     EventBus.removeMediator("BattleInfoUIMediator")
                     EventBus.removeMediator("BattleTalkMediator")
                     EventBus.removeMediator("BattleChangeSceneShowMediator")
                     EventBus.removeMediator("BattleStrongHoldInitializeMediator")
                      BattleTeamDisplayModule.removeAll()
                      BattleLayerManager.release()
                       BattleState.setPlaying(false)
                       BattleShipDisplayModule.release()
                       -- local callback = BattleMainData.callbackFunc
                      local request = BattleMainData.getCallBackRequest()
                     
                      if(self.quitCallBack ~= nil) then
                        self.quitCallBack()
                        self.quitCallBack = nil
                        
                      end
                     BattleState.setHasNextBattle(false)
                     -- 还原timescale
                     CCDirector:sharedDirector():getScheduler():setTimeScale(1)
                     EventBus.removeMediator("StrongHoldMediator")
                       -- BattleLayer.closeLayer() -- 移出战斗场景层, 老的战斗模块
                       require "script/module/switch/SwitchCtrl"
                        SwitchCtrl.postBattleNotification("END_BATTLE")
                     CCDirectorAnimationinterval:getInstance():resumeAnimationInterval()
                     EventBus.release()
                     
                     BattleActionRender.removeAll()
                     BattleMainData.releaseData()
                     -- AudioHelper.stopMusic()
                     BattleNodeFactory.release()
                     SpriteFramesManager.release()
                     
                     CCTextureCache:sharedTextureCache():removeUnusedTextures()
                     request()
                     BattleModule.destroy()
                     -- print("=================================================")
                     -- print("=================================================")
                     -- print("=================================================")
                     -- print("=================================================")
                     -- CCTextureCache:sharedTextureCache():dumpCachedTextureInfo()
                  end -- if end
		end-- if end
	end -- function end


  function StrongHoldMediator:handleNextRecord( ... )



         -- 刷新当前获得的英雄碎片和物品总量
         -- EventBus.sendNotification(NotificationNames.EVT_UI_SET_HERO_PART_TO,BattleMainData.getTotalRewardHeroPartNum())
         EventBus.sendNotification(NotificationNames.EVT_UI_SET_ITEM_TO,BattleMainData.getTotalRewardItemTypeNum() + BattleMainData.getTotalRewardHeroPartTypeNum())
         -- EventBus.sendNotification(NotificationNames.EVT_UI_SET_ITEM_TO,BattleMainData.getTotalRewardItemNum() + BattleMainData.getTotalRewardHeroPartNum())

        -- 设置录像用的战斗索引
        BattleState.setBattleIndex(BattleMainData.strongholdData.index)
       
        -- 当前战斗是胜利()
          if(BattleMainData.fightRecord.isWin == true and

             -- 如果strongHold还有下一场战斗
             BattleMainData.strongholdData:hasNextBattle()) then


                Logger.debug("== BattleMainData.fightRecord.isWin")
                --> 缓存上次死亡状态 todo:死亡记录用hid记录,复活也用hid删除
                --> 接下来设置ghost状态也用这个设置 
                -- BattleMainData.cacheBattleSelfState()


                --> 刷新据点到下一场战斗
                BattleMainData.strongholdData:nextBattle()



                --> 刷新maindata的显示数据到下一场战斗
                BattleMainData.refreshBattleTeamDisplayData()

                --> 删除对方ui
                BattleTeamDisplayModule.removeArmyTeam()
                --> 创建敌军显示
                BattleTeamDisplayModule.createArmyTeamDisplayData(BattleMainData.armyTeamDisplayData)
                
                -- 如果是npc队伍,我们立即刷新
                if(BattleMainData.strongholdData:getCurrentArmyData().isNpc == true) then
                   --> 立即生成当前
                   BattleTeamDisplayModule.removeSelfTeam()
                   BattleTeamDisplayModule.createSelfTeamDisplayData(BattleMainData.selfTeamDisplayData)
                else
                   -- 将己方所有没有死亡的人物状态回复
                  if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info) then
                      for k,data in pairs(BattleMainData.fightRecord.team1Info.list or {}) do

                          if(data:isDead() ~= true) then
                            data:toStartState()
                          end
                      end
                  end


                   --> 当前所有死亡单位设置为ghost状态()
                   --> 因为后端会将死亡英雄也传到队伍里,所以可以这样用
                   -- BattleTeamDisplayModule.removeSelfTeam()
                   -- BattleTeamDisplayModule.createSelfTeamDisplayData(BattleMainData.selfTeamDisplayData)
                   -- local deadPositions = BattleMainData.fightRecord.team1Info:getDeadList()
                   -- for k,index in pairs(deadPositions or {}) do
                   --   local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(index)
                   --   if(display) then
                   --      display:ghostState()
                   --   end
                   -- end
                   -- BattleMainData.fightRecord.team1Info:setDieToGhost()
                   -- 重生逻辑
                end
               
                -- 设置对话完成事件
                EventBus.sendNotification(NotificationNames.EVT_TALK_SET_TALK_BG,
                                          BattleMainData.strongholdData:getCurrentArmyData().afterTalkBackGround)

                EventBus.sendNotification(NotificationNames.EVT_TALK_SET_TALK_MUSIC,
                                          BattleMainData.strongholdData:getCurrentArmyData().afterTalkMusic)


                EventBus.sendNotification(NotificationNames.EVT_TEAM_SHOW_START)



                -- local inherit = BattleMainData.strongholdData:getCurrentArmyData().inheritLastFightState
                -- if(inherit == true) then
                --   BattleTeamDisplayModule.createHeroDisplayToMainData()
                -- else
                -- end

                -- --> 
                -- -- 如果当前战斗不是npc战斗 即不需要继承上一次的战斗死亡状态
                -- local inherit = BattleMainData.strongholdData:getCurrentArmyData().inheritLastFightState
                -- if(inherit ~= true) then
                --   Logger.debug("== not inherit ")
                --    --> 删除己方ui
                --    BattleTeamDisplayModule.removeSelfTeam()
                -- else
                -- -- 继承上一场npc英雄
                -- local army = BattleMainData.strongholdData:getCurrentArmyData()
                --     if(army:hasNPCHeroInSelf() ~= true) then
                --       BattleTeamDisplayModule.createSelfTeamDisplayData(BattleMainData.strongholdData.extraNPC,false)
                --       -- BattleTeamDisplayModule.createExtraNPCFromLastArmy()
                --     end
                -- end
                
               

               
                

                -- if(inherit) then
                --    Logger.debug("== inherit hero state")
                --    
                -- end
                
                -- -->  刷新 据点ui
                -- EventBus.sendNotification(NotificationNames.EVT_REFRESH_SH_RESULT)
                -- -->  开始配置队伍
                -- EventBus.sendNotification(NotificationNames.EVT_FORMATION_START_CONFIG)
                --print("############## StrongHoldMediator 开始转场特效:",BattleMainData.printState())
                -- 开始出场展示(移动,特效等)
                
          -- 如果没有--> 显示结束面板
          else
 



                    EventBus.sendNotification(NotificationNames.EVT_CHEST_UNUSE_ALL)


                    local combineResult = BattleMainData.getAllReawrdData()

                    local itemNum = BattleMainData.getTotalRewardItemNum()
                    local heroPartNum = BattleMainData.getTotalRewardHeroPartNum()
                    -- Logger.debug("---- itemNum:%d,heroPartNum:%d",itemNum,heroPartNum)
                   
                    

                    EventBus.sendNotification(NotificationNames.EVT_SHOW_RESULT_WINDOW)
                    
                    -- 结算面板出现时,删除调过按钮和加速按钮
                    EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SKIP_BT)  
                    EventBus.sendNotification(NotificationNames.EVT_UI_REMOVE_SPEED_BT) 

          end -- if end
  end
      


  function StrongHoldMediator:resetEffect(  )
    

    local deadOnFormation         = nil
    local alivebenchOnFormation   = nil
    local deadReviveAction        = nil
    local benOffAction            = nil
    local resetAction             = nil


    if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info) then
        -- 获取当前位置状态为死亡的英雄
        deadOnFormation       = BattleMainData.fightRecord.team1Info:getDeadDataList()
        
        -- 获取当前阵型中活着的替补
        alivebenchOnFormation = BattleMainData.fightRecord.team1Info:getAliveBenchList()
    end



    if( (deadOnFormation and #deadOnFormation > 0) or 
        (alivebenchOnFormation and #alivebenchOnFormation > 0)) then
        self.resetAction        = require(BATTLE_CLASS_NAME.BSSpawn).new()
       
         --- 如果当前阵上有活着的替补, 活着有处于死亡状态的人
        if(deadOnFormation and #deadOnFormation > 0) then
                deadReviveAction    = require(BATTLE_CLASS_NAME.BSSpawn).new()
                 Logger.debug("-- deadOnFormation 1")
              -- 1.当前位置玩家为死亡状态       -> 复活特效 + 原位置人物 alive状态出现
                for k,targetData in pairs(deadOnFormation or {}) do
                  
                  local actions = require(BATTLE_CLASS_NAME.BSSpawn).new()
                  -- 如果是替补,那么我们要获取一下最开始上阵的英雄
                  if(targetData.isBench == true) then
                     targetData =  BattleMainData.fightRecord.team1Info:getRawPositionData(targetData.positionIndex)
                  end
                  -- 添加要复活英雄UI
                  BattleTeamDisplayModule.activeNewPlayer(targetData:getCardDisplayData(),targetData.positionIndex,BATTLE_CONST.TEAM1)
                  
                  -- 复活特效
                  local display               = BattleTeamDisplayModule.getSelfTeamHeroByPostion(targetData.positionIndex)
                  local position              = display:globalCenterPoint()
                  local reviveEffect          = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
                  reviveEffect.postionX       = position.x
                  reviveEffect.postionY       = position.y
                  reviveEffect.animationName  = BATTLE_CONST.BENCH_REVIVE_EFFECT

                  actions:add(reviveEffect)
                  

                  -- 渐现
                  display:setOpacity(0)
                  local fadeIn  = require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
                  fadeIn.targets  = {display}
                  fadeIn.time     = 1
                  actions:add(fadeIn)
                  self.resetAction:add(actions)
                end
               
           
        end
         -- Logger.debug("-- alivebenchOnFormation 1")
        -- 2 当前阵上未死亡的替补逻辑
        if(alivebenchOnFormation and #alivebenchOnFormation > 0) then
                for k,benchData in pairs(alivebenchOnFormation or {}) do
                   Logger.debug("-- alivebenchOnFormation 2")
                   -- 获取最初上阵英雄数据
                   local rawData = BattleMainData.fightRecord.team1Info:getRawPositionData(benchData.positionIndex)
                   -- 激活最初上阵英雄UI
                   BattleTeamDisplayModule.activeNewPlayer(rawData:getCardDisplayData(),rawData.positionIndex,BATTLE_CONST.TEAM1)
                      

                   -- 因为英雄已经死了,所以是ghost状态
                   local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(rawData.positionIndex)
                    display:ghostState()
                    display:setOpacity(0)
                   
                   local benchoffActions = require(BATTLE_CLASS_NAME.BSSpawn).new()

                   local position           = display:globalCenterPoint()
                   -- 下阵特效
                   local offEffect          = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
                   offEffect.postionX       = position.x
                   offEffect.postionY       = position.y
                   offEffect.animationName  = BATTLE_CONST.BSE_EFFECT2

                   -- 渐隐出现
                   local fadeIn     = require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
                    fadeIn.targets  = {display}
                    fadeIn.time     = 1
                    
                    benchoffActions:add(offEffect)
                    benchoffActions:add(fadeIn)


                    local nomalShowActions = require(BATTLE_CLASS_NAME.BSSpawn).new()
                    -- UI状态变为normal
                    local toNormal = require(BATTLE_CLASS_NAME.BAForCallClosureFunction).new()
                    
                    toNormal.closureFunction = function ( ... )
                        -- 人物alive状态
                        display:normalState()
                        -- display:setOpacity(0)
                        BattleMainData.fightRecord:resetToStart()
                        EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM)
                    end

                    


                    nomalShowActions:add(toNormal)


                    -- 复活特效
                    local reviveEffect      = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
                    reviveEffect.postionX       = position.x
                    reviveEffect.postionY       = position.y
                    reviveEffect.animationName  = BATTLE_CONST.EFFECT_REVIVED_COMPLETE
                    
                    -- 渐隐出现
                    local fadeIn1  = require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
                    fadeIn1.targets  = {display}
                    fadeIn1.time     = 1

                    nomalShowActions:add(reviveEffect)
                    -- nomalShowActions:add(fadeIn1)

                    local benchOff = require(BATTLE_CLASS_NAME.BSSequence).new()
                    benchOff:reset()
                    benchOff:add(benchoffActions)
                    benchOff:add(nomalShowActions)
                    self.resetAction:add(benchOff)
              end
        end
                
                

        -- 如果没有死亡英雄或者替补英雄
        if(self.resetAction) then
              self.resetAction:addCallBacker(self,self.onResetEffectComplete)    
              self.resetAction:start()

        else
            -- print("-- EVT_BATTLE_RECORD_PLAY_COMPLETE",self.jumped)
            self:playEndShow()
        end
      
        -- if(alivebenchOnFormation and #alivebenchOnFormation > 0) then
        --     benOffAction    = require(BATTLE_CLASS_NAME.BSSpawn).new()
        -- end
    else
          self:playEndShow()
          -- self:handleNextRecord()
    end
 

  end

  function StrongHoldMediator:playEndShow( ... )
      -- print("-- EVT_BATTLE_RECORD_PLAY_COMPLETE",self.jumped)
      -- 跳过战斗不播退场逻辑
      if(self.jumped == true) then
          self:handleNextRecord()
      else
        -- print("-- EVT_BATTLE_RECORD_PLAY_COMPLETE1",self.jumped)
           EventBus.sendNotification(NotificationNames.EVT_TEAM_ENDSHOW_START)
      end
  end

  function StrongHoldMediator:onResetEffectComplete( data )
          

          BattleMainData.fightRecord:resetToStart()
          -- BattleMainData.refreshBattleTeamDisplayData()
          EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM)
          -- BattleMainData.fightRecord.team1Info:resetToRawFomation()
          BattleMainData.fightRecord.team1Info:linkAndRefreshHeroesDisplay()
          -- self:handleNextRecord()


          self:playEndShow()
       

  end
  --     -- 还原阵上的替补
  -- function StrongHoldMediator:revertBench( ... )
  --   -- 目前小时没有任何特效,直接删除,比较暴力
  --   -- 如果需要特效,那么先找出我方阵上需要还原的位置,然后替换成对应的显示即可
  --   Logger.debug("== revertBench 1")
  --   -- 重置上阵数据(上一场可能会有替补上场)
  --   if(BattleMainData.fightRecord and BattleMainData.fightRecord.team1Info) then
  --     Logger.debug("== revertBench 2")
      
  --     local hasBenchActive = BattleMainData.fightRecord.team1Info.benchActiveNum > 0
  --     if(hasBenchActive == true) then
  --       Logger.debug("== revertBench 3")
  --       -- 获取所有非替补死亡人物
  --       local deathPlayers  = BattleMainData.fightRecord.team1Info:getRawPlaysDeadList()
  --       local displays    = {}
  --       if(self.benchOffAction) then self.benchOffAction:release() end

  --       self.benchOffAction     = require(BATTLE_CLASS_NAME.BSSpawn).new()

  --       -- 生成已死亡人物显示
  --       for k,targetData in pairs(deathPlayers or {}) do
  --         -- local display              = require("script/battle/ui/BattlPlayerDisplay").new()
  --         -- display:reset(targetData:getCardDisplayData())
  --         -- display:setParent(BattleLayerManager.battlePlayerLayer)
  --         -- table.insert(displays,display)
          
  --         Logger.debug("== revertBench 4")
  --         -- 替补渐隐 + 特效 + 人物渐现
  --         -- local fadeOut = nil
  --         -- benchOffAction:add(fadeOut)
  --         -- 替换
  --         BattleTeamDisplayModule.activeNewPlayer(targetData:getCardDisplayData(),targetData.positionIndex,BATTLE_CONST.TEAM1)
  --         local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(targetData.positionIndex)
  --         -- -- 置为ghost
  --         display:ghostState()
  --         -- -- alpha设置为0
  --         display:setOpacity(0)

  --         local position        = display:globalCenterPoint()
  --         local playEffect      = require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
  --         playEffect.postionX     = position.x
  --         playEffect.postionY     = position.y
  --         playEffect.animationName  = BATTLE_CONST.BSE_EFFECT2
  --         self.benchOffAction:add(playEffect)

  --         local fadeIn  = require(BATTLE_CLASS_NAME.BAForTargetsFadeInOrOutAction).new()
  --         fadeIn.targets  = {display}
  --         fadeIn.time     = 2
  --         self.benchOffAction:add(fadeIn)
  --       end

  --       self.benchOffAction:addCallBacker(self,self.onBenchOffComplete)
  --       self.benchOffAction:start() 


  --     -- 如果木有
  --     else 
  --        Logger.debug("== revertBench none")
  --        -- 设置ghost state
  --        BattleTeamDisplayModule.removeSelfTeam()
  --            BattleTeamDisplayModule.createSelfTeamDisplayData(BattleMainData.selfTeamDisplayData)
  --            local deadPositions = BattleMainData.fightRecord.team1Info:getDeadList()
  --            for k,index in pairs(deadPositions or {}) do
  --              local display = BattleTeamDisplayModule.getSelfTeamHeroByPostion(index)
  --              if(display) then
  --                 display:ghostState()
  --              end
  --            end
  --            self:startConfigFormation()
  --     end
      
      
  --     -- 替补渐隐 + 特效 + 人物渐现


  --     BattleMainData.fightRecord.team1Info:resetToRawFomation()

  --     -- 将死亡人物添加到
  --     -- 获取最终替补上阵数据
  --     -- local benchOnFormation = BattleMainData.fightRecord:getBenchOnFormation()
  --     -- for pos,id in pairs(benchOnFormation or {}) do
  --     --  -- print("== revertBench revert pos:%d , id:%d",pos,id)
  --     --  local targetData = BattleMainData.fightRecord:getTargetData(tonumber(id))
  --     --  -- 替补上场位置替换为最初上阵人物
  --     --  target = BattleMainData.fightRecord:indexDataByIndexAndTeamid(pos,targetData.teamId)
  --     --  BattleTeamDisplayModule.activeNewPlayer(target:getCardDisplayData(),pos,target.teamId)
  --     --  target:linkDisplay()
  --     --  target:refreshDisplayState()
  --     -- end
  --   else
  --      self:startConfigFormation()
  --   end
  -- end

      function StrongHoldMediator:onTrang( ... )
            
      end
	return StrongHoldMediator