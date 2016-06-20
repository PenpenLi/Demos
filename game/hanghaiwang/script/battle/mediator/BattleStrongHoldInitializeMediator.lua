-- storngHold据点初始化管理器
-- 1.黑幕动画播发
-- 2.黑幕暂停时: 发送请求进入据点,拉取阵型数据,拉取战斗数据,预加载工作
-- 3.播放背景音乐,初始化显示(背景,ui,人物角色)
-- 4.黑幕就行播发
-- 5.初始化完成
local BattleStrongHoldInitializeMediator = class("BattleStrongHoldInitializeMediator")
BattleStrongHoldInitializeMediator.name = "BattleStrongHoldInitializeMediator"
-- BattleStrongHoldInitializeMediator.battleCount = nil


function BattleStrongHoldInitializeMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					  NotificationNames.EVT_STRONGHOLD_START_INI,					      -- 初始化
					  NotificationNames.EVT_ENTER_LEVEL_SUCCESS, 				  -- 进入strongHold完成
			          NotificationNames.EVT_TEAM_SHOW_COMPLETE,           -- 出场动画完成
			          NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS,  -- 战斗录像数据完毕
			          NotificationNames.EVT_SC_FORMATION_DATA_COMPLETE,   -- 阵型获取成功
			          NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE,  -- 预加载完成
			          NotificationNames.EVT_CHANGE_SCENE_PAUSE,         -- 换场特效暂停,后续需要管理器加载相关资源
			          NotificationNames.EVT_CHANGE_SCENE_COMPLETE       -- 换场特效完成
				}
	end
	function BattleStrongHoldInitializeMediator:onRegest( ... )
      -- self:cacheStage()
      -- self.battleCount = 0
      -- print("== BattleStrongHoldInitializeMediator onRegest")
	end -- function end

	function BattleStrongHoldInitializeMediator:onRemove( ... )

	end -- function end

	function BattleStrongHoldInitializeMediator:getHandler()
		return self.handleNotifications
	end



	function BattleStrongHoldInitializeMediator:handleNotifications(eventName,data)
            	if eventName ~= nil then
            		 -- print(" == BattleStrongHoldInitializeMediator",eventName)
                  	-- 初始化 
         			if eventName == NotificationNames.EVT_STRONGHOLD_START_INI then
	                  	-- 开始切换场景
	                  	EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_START)

			        -- 处于黑幕中,我们开始干活啦,首先请求进入据点
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

			        	-- 请求战斗数据
                    BattleDataProxy.requestDoBattle()   	    	 	
                    -- 战斗数据拉取完毕
         			elseif eventName == NotificationNames.EVT_BATTLE_REQUEST_DATA_SUCCESS then

         				-- print(" ===  EVT_BATTLE_REQUEST_DATA_SUCCESS @ BattleStrongHoldInitializeMediator")

         				  -- 活动副本特殊逻辑:如果是最后一场那么我们需要调用指定api
                        if( BattleMainData.copyType == COPY_TYPE_EVENT  and
                           BattleMainData.strongholdData:hasNextBattle() == false) then
                            Logger.debug("---- 活动副本最后一场:" ..tostring(BattleMainData.strongholdData.index) .. "/" .. tostring(BattleMainData.strongholdData.total))
                            LoginHelper.reloginState(true)
                        else
                            Logger.debug("---- 多场信息:" ..tostring(BattleMainData.strongholdData.index) .. "/" .. tostring(BattleMainData.strongholdData.total) .. " copyType:" .. tostring(BattleMainData.copyType) .. "->活动副本类型值:" .. tostring(COPY_TYPE_EVENT))
                        end

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
             		   -- 链接战斗数据的display
                       BattleMainData.linkAndRefreshHeroesDisplay()
         				
                       
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


	                     -- 开始异步加载
                        EventBus.sendNotification(NotificationNames.EVT_LOAD_START_PRELOAD_START,BattleMainData.fightRecord.battleObject)
                        
                       
                        -- 初始化替补列表
                        EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_INI_FROM_BATTLE_STRING)

 					-- 战斗预加载完毕
         			elseif eventName == NotificationNames.EVT_LOAD_START_PRELOAD_COMPLETE then
         				-- BattleTeamDisplayModule.visibleAll()
         				-- 黑幕动画过度
                        EventBus.sendNotification(NotificationNames.EVT_CHANGE_SCENE_RESUME) 

                    -- 黑幕过度完成
         			elseif eventName == NotificationNames.EVT_CHANGE_SCENE_COMPLETE then   
                        EventBus.sendNotification(NotificationNames.EVT_STRONGHOLD_START_INI_COMPLETE) 
         			end

         		end
    end
return BattleStrongHoldInitializeMediator