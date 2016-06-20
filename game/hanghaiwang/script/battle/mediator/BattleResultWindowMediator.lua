
-- 战斗结束面板


local BattleResultWindowMediator = class("BattleResultWindowMediator")
 BattleResultWindowMediator.name 			= "BattleResultWindowMediator"

 
	------------------ properties ----------------------
	BattleResultWindowMediator.window 					= nil -- 窗体实例
	BattleResultWindowMediator.addNoScale 				= nil -- 
	------------------ functions -----------------------
	function BattleResultWindowMediator:getInterests( ... )
		-- local  ins = require("script/notification/NotificationNames")
		return {	
					NotificationNames.EVT_SHOW_RESULT_WINDOW,					-- 初始化
					NotificationNames.EVT_REPLAY_RECORD,						-- 跳过战斗
					NotificationNames.EVT_CLOSE_RESULT_WINDOW					-- 关闭结束面板
				}
	end -- function end

	function BattleResultWindowMediator:onRegest( ... )
		self.addNoScale 	= false
	end -- function end

	function BattleResultWindowMediator:onRemove( ... )
		if(self.window) then
			-- if(self.window:getParent()) then
			-- self.window:removeFromParentAndCleanup(true)
			-- end
			LayerManager.removeLayout() -- zhangqi, 2014-07-21, 关闭结算面板 
			self.window = nil
		end
		self.addNoScale 	= false
		Logger.debug("!!!! BattleResultWindowMediator:onRemove")
		-- local  instance 	= require("EventBus"):instance()
		-- local  eventNames	= self.getInterests()
		-- for i,eventName in ipairs(eventNames) do
		-- 	instance.removeEventListener(eventName,handleNotifications)
		-- end -- for end
	end -- function end

	function BattleResultWindowMediator:getHandler()
		return self.handleNotifications
	end


	function BattleResultWindowMediator:handleNotifications(eventName,data)
		--local  ins = require("script/notification/NotificationNames")
		--print("StrongHoldMediator handleNotifications call:",eventName,"data:",data)
		if eventName ~= nil then
			-- 显示结束面板
			if eventName == NotificationNames.EVT_SHOW_RESULT_WINDOW then

				--结束面板需要回复速度
	    		CCDirector:sharedDirector():getScheduler():setTimeScale(1)

				if(self.window == nil) then
					-- self.window:setVisible(true)
					-- self.window:setEnabled(true)

				-- else
					 self.window,checkUpgrade = self:getResultWindow() 
					 --print("StrongHoldMediator isWin:",isWin)
					 -- BattleLayerManager.resultWindowLayer:addWidget(self.window)
					 -- LayerManager.addLayout(self.window) -- zhangqi, 2014-07-21, 将弹出结算面板纳入LayerManager管理，避免未知的屏蔽或穿透问题
					 if(checkUpgrade) then
					 	copyWin.checkUpgrade() -- zhangqi, 后检测升级，避免copyWin中先弹出升级面板反被结算面板盖住
				 	 end
				end

				if(self.addNoScale) then
					LayerManager.addLayoutNoScale(self.window)
				else
					LayerManager.addLayout(self.window)
				end
 
				 BattleLayerManager.resultWindowLayer:setTouchEnabled(true)
				 BattleLayerManager.resultWindowLayer:setTouchPriority(g_tbTouchPriority.battleLayer - 1)
			-- 重播
			elseif  eventName == NotificationNames.EVT_REPLAY_RECORD then 
					-- self.window:setVisible(false)
					-- self.window:setEnabled(false)
					EventBus.sendNotification(NotificationNames.EVT_CHEST_DISPOSE)
					
					--结束面板需要回复速度
					local speed = BattleMainData.getTimeSpeed()
	    			CCDirector:sharedDirector():getScheduler():setTimeScale(speed)

					self.window:retain()
					-- BattleLayerManager.resultWindowLayer:setTouchEnabled(false)
					LayerManager.removeLayout()
					-- self.window:removeFromParent()

			elseif	eventName == NotificationNames.EVT_CLOSE_RESULT_WINDOW 	then
					
					EventBus.sendNotification(NotificationNames.EVT_CHEST_DISPOSE)
					
					if(self.window) then
						LayerManager.removeLayout() -- zhangqi, 2014-07-21, 关闭结算面板 
						self.window = nil
					end
 		
			end
		end
	end

	local function removeTouchNode( ... )
		local run = CCDirector:sharedDirector():getRunningScene()
		if (run:getChildByTag(99999990)) then
			run:removeChildByTag(99999990,true)
			logger:debug("removeTouchNode 99999990")
		end
		if (run:getChildByTag(10009990)) then
			run:removeChildByTag(10009990,true)
			logger:debug("removeTouchNode 10009990")
		end
	end

	function BattleResultWindowMediator:getResultWindow()
		-- local copyType = BattleMainData.copyType
		local window  
		local isWin  = BattleMainData.fightRecord.isWin
		local checkUpgrade = false
		local playMusic = isWin
		self.addNoScale = false
		local damageMap = BattleMainData.fightRecord:getPlayersDamageMap()
		removeTouchNode()

		if( BattleMainData.winType == BATTLE_CONST.WINDOW_COPY) then

				checkUpgrade = isWin
				-- 失败
				if(not isWin) then
					require "script/module/copy/copyLose"
					window 		= copyLose.create(
													BattleMainData.strongholdId,
													BattleMainData.hardLevel,
													BattleMainData.newcopyorbaseRet,
													BattleMainData.fightRecord.appraisal
												 )
				--胜利
				else
					require "script/module/copy/copyWin"
					local combineResult = BattleMainData.getAllReawrdData()
					--print("BattleMainData.fightRecord.appraisal:",BattleMainData.fightRecord.appraisal)
					window 		= copyWin.showResult(

													 -- BattleMainData.copyId,
													 BattleMainData.strongholdId,
													 BattleMainData.hardLevel,
													 BattleMainData.getScore,
													 combineResult,
													 BattleMainData.newcopyorbaseRet.normal, -- zhangqi, 20140708, 加上.normal才能被正确解析
													 BattleMainData.fightRecord.appraisal
												 )
					-- playMusic = true

					-- logger:debug("===================copy win 1")
					-- window 		= copyWinNew.create(

					-- 								 -- BattleMainData.copyId,
					-- 								 BattleMainData.strongholdId,
					-- 								 BattleMainData.hardLevel,
					-- 								 BattleMainData.fightRecord.score,
					-- 								 BattleMainData.fightRecord.reward,
					-- 								 BattleMainData.fightRecord.copyCallBackData
						
					-- 							 )
				end -- if end

			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_ARENA) then

				 -- 失败
				if(isWin) then
					require "script/module/arena/ArenaWinCtrl"
					window 		= ArenaWinCtrl.createForArena(BattleMainData.singleBattleResultData,damageMap)
				else
					require "script/module/arena/ArenaLoseCtrl"
					window 		= ArenaLoseCtrl.createForArena(BattleMainData.singleBattleResultData,damageMap)
				end
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_ROB) then
				 -- 失败
				if(isWin) then
					require "script/module/arena/ArenaWinCtrl"
					window 		= ArenaWinCtrl.createForGrabTrea(BattleMainData.singleBattleResultData)
				else
					require "script/module/arena/ArenaLoseCtrl"
					window 		= ArenaLoseCtrl.createForGrabTrea(BattleMainData.singleBattleResultData)
				end
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_NORMAL) then
				 -- 失败
				if(isWin) then
					require "script/module/mail/ReplayWinCtrl"
					window 		= ReplayWinCtrl.createForMail(BattleMainData.singleBattleResultData,damageMap)
				else
					require "script/module/mail/ReplayLoseCtrl"
					window 		= ReplayLoseCtrl.createForMail(BattleMainData.singleBattleResultData,damageMap)
				end
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_ARENA_BILLBOARD) then
				
				-- BattleMainData.fightRecord:getPlayersDamageMap()
					           -- 失败
				-- if(isWin) then
				require "script/module/arena/ArenaHighest"
				window 	= ArenaHighest.create(damageMap,BattleMainData.singleBattleResultData)
				-- else
				-- 	require "script/module/mail/ReplayLoseCtrl"
				-- 	window 		= ReplayLoseCtrl.createForMail(BattleMainData.singleBattleResultData)
				-- end
			-- 活动副本
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_EVENT) then
				require "script/module/copyActivity/ChanglageMonster"

				if(isWin) then
					
					window 		= ChanglageMonster.battleWin(BattleMainData.newcopyorbaseRet,
															 BattleMainData.rewardRet,
															 BattleMainData.extra_rewardRet)
				else
					window 		= ChanglageMonster.battleLose()
				end
			-- 贝里活动
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_EVENT_BELLY) then
				require "script/module/copyActivity/BellyChanlage"

				local total,belly
				local adt = BattleMainData.fightRecord
				if(adt and adt.team2Info) then
					total = adt.team2Info:getHpLost()
					-- local belly = self:caculateDamgeGetTotalBelly(BattleMainData.copyId,total)
					belly = BattleDataUtil.caculateDamgeGetTotalBelly(BattleMainData.copyId,total)
				else
					 total = 0
					 belly = 0
				end

				window  		= BellyChanlage.battleWin(total,belly)    --hurt,belly ：总伤害值，获得贝利
			--神秘空岛
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_SEA_PIEA) then
				if(isWin) then
					require "script/module/SkyPiea/SkyPieaBattle/SkyPieaWinCtrl"
					window 		= SkyPieaWinCtrl.create(BattleMainData.singleBattleResultData)
				else
					require "script/module/SkyPiea/SkyPieaBattle/SkyPieaLoseCtrl"
					window 		= SkyPieaLoseCtrl.create()
				end
			-- boss战
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_BOSSS) then
				require "script/module/WorldBoss/WorldBossAtkView"
				playMusic = false
				self.addNoScale = true
				window = (WorldBossAtkView:new()):create(BattleMainData.singleBattleResultData)
			-- 冒险
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_ADVENTURE) then
				require "script/module/adventure/AdBatlleEventModel"
				window = AdBatlleEventModel.onBattleResult(BattleMainData.singleBattleResultData)
				assert(window,"ChanglageMonster:onBattleResult error")
			-- 如果是资源矿战斗
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_MINE) then
				
				if(isWin) then
					require "script/module/mine/MineWinCtrl"
					window 		= MineWinCtrl.create(BattleMainData.singleBattleResultData,damageMap)
					assert(window,"error: MineWinCtrl:create is nil. ")
				else
					require "script/module/mine/MineLoseCtrl"
					window 		= MineLoseCtrl.create(BattleMainData.singleBattleResultData,damageMap)
					assert(window,"error: MineLoseCtrl:create is nil. ")
				end
			-- 如果是公会副本
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_GUIDE) then
				require "script/module/guildCopy/GCBattleMonsterCtrl"
				window = GCBattleMonsterCtrl.onBattleResult(data)
				assert(window,"error: GCBattleMonsterCtrl:create is nil. ")

			-- pvp切磋
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_PVP) then
				
				if(isWin) then
					require "script/module/mail/ReplayWinCtrl"
					window 		= ReplayWinCtrl.createForMail(BattleMainData.singleBattleResultData,damageMap)
				else
					require "script/module/mail/ReplayLoseCtrl"
					window 		= ReplayLoseCtrl.createForMail(BattleMainData.singleBattleResultData,damageMap)
				end

			-- 深海监狱
			elseif (BattleMainData.winType == BATTLE_CONST.WINDOW_IMPEL) then
				if (isWin) then
					require "script/module/impelDown/ImpelResult/ImpelWinCtrl"
					window = ImpelWinCtrl.create(tonumber(BattleMainData.singleBattleResultData.towerLevel))
				else
					require "script/module/impelDown/ImpelResult/ImpelLoseCtrl"
					window = ImpelLoseCtrl.create(tonumber(BattleMainData.singleBattleResultData.towerLevel))
				end
			-- 觉醒
			elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_AWAKING) then
				local tbBattleData = {}
				tbBattleData.strongholdId = BattleMainData.strongholdId
				tbBattleData.copyId = BattleMainData.copyId
				if (isWin) then
					require "script/module/copyAwake/AwakeWinCtrl"
					tbBattleData.score = BattleMainData.getScore
					tbBattleData.newcopyorbase = BattleMainData.newcopyorbaseRet
					tbBattleData.combineResult = BattleMainData.getAllReawrdData()
					window = AwakeWinCtrl.create(tbBattleData)
					assert(window,"error: AwakeWinCtrl.create is nil. ")
				else
					require "script/module/copyAwake/AwakeLoseCtrl"
					window = AwakeLoseCtrl.create(tbBattleData)
					assert(window,"error: AwakeLoseCtrl.create is nil. ")
				end
            -- 巅峰对决
            elseif(BattleMainData.winType == BATTLE_CONST.WINDOW_WA) then
                if (isWin) then
					require  "script/module/worldArena/result/WABattleWinCtrl"
					window = WABattleWinCtrl.create(BattleMainData.singleBattleResultData,damageMap)
				else
					require "script/module/worldArena/result/WABattleLoseCtrl"
					window = WABattleLoseCtrl.create(BattleMainData.singleBattleResultData,damageMap)
				end
			else
				error("unknow windowType:",BattleMainData.winType)
			end -- if end

		if(playMusic == true) then
			BattleSoundMananger.playEffectSound("texiao_shengliwindow.mp3") 
		end


		return window , checkUpgrade
	end

	-- function showLosePanel( ... )
	--     require "script/module/copy/copyLose"
	--     local layReport = copyLose.create(m_base_id, m_level, m_newcopyorbase.normal)
	--     logger:debug("load copy_lose.json OK ")

	--     local uiLayer = TouchGroup:create()
	--     uiLayer:addWidget(layReport)
	--     uiLayer:setTouchEnabled(true)
	--     uiLayer:setTouchPriority(-50000) -- zhangqi, 被触摸优先级坑大发了

	--     local runningScene = CCDirector:sharedDirector():getRunningScene()
	--     battleBaseLayer:addChild(uiLayer, 999999)
	--     logger:debug("showLosePanel end")
	-- end

	-- function showWinPanel( ... )
	--     require "script/module/copy/copyWin"
	--     local layReport = copyWin.create(m_base_id, m_level, m_isScore, m_reward, m_newcopyorbase.normal)
	--     layReport:setSize(g_winSize)

	--     local uiLayer = TouchGroup:create()
	--     uiLayer:addWidget(layReport)
	--     uiLayer:setTouchEnabled(true)
	--     uiLayer:setTouchPriority(-50000) -- zhangqi, 被触摸优先级坑大发了

	--     local runningScene = CCDirector:sharedDirector():getRunningScene()
	--     runningScene:addChild(uiLayer, 999999)
	-- end


                                    

return BattleResultWindowMediator
