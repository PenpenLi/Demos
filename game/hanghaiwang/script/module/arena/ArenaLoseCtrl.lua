-- FileName: ArenaLoseCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-12
-- Purpose: 竞技场,比武，夺宝 失败控制模块
--[[TODO List]]

module("ArenaLoseCtrl", package.seeall)
require "script/module/arena/ArenaLoseView"
require "script/module/main/MainScene"
-- UI控件引用变量 --

-- 模块局部变量 --

local createWinType = createWinType or {
	kTypeArena = 1, -- 竞技场
	kTypeFrag = 2   -- 夺宝
					-- 比武
}	

local heroId

----------add by zhaoqiangjun 201405241106 ------------
local function solveOtherUserData( cbFlag, dictData, bRet )
    if bRet then
        local externHeroInfo = dictData.ret[heroId ..""]

		require "script/module/formation/MainFormation"
		local formationLayer = MainFormation.createWithOtherUserInfo(heroId,externHeroInfo)
		LayerManager.addLayout(formationLayer)
    end
end
-------------------------------------------------------

local function init(...)

end

function destroy(...)
	package.loaded["ArenaLoseCtrl"] = nil
end

function moduleName()
    return "ArenaLoseCtrl"
end

--竞技场失败面板
function createForArena(tbData , _tbDamageMap)

	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			logger:debug("tbBtnEvent.onFormation".. sender:getTag())
			-------------------add by zhaoqiangjun 201405241106--------------------
			require "script/module/formation/FormationCtrl"
			FormationCtrl.loadFormationWithUid(sender:getTag())
		end
	end
	-- 重播按钮
	tbBtnEvent.onRepaly = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD) -- 重播
		end
	end

	-- 确定按钮按钮
	tbBtnEvent.onConfirm = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState() --还原战斗前音乐状态
			AudioHelper.playCommonEffect()

			 EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			 require "script/module/switch/SwitchCtrl"
             SwitchCtrl.postBattleNotification("END_BATTLE")

			 -- AudioHelper.playMainMusic()
			 AudioHelper.playSceneMusic("fight_easy_02.mp3")
		end
	end

	-- 战斗数据按钮
	tbBtnEvent.onBattleData = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/arena/ArenaHighest"
			local tbForHigest = {}
			logger:debug({tbData = tbData})
			tbForHigest.attack_uid = UserModel.getUserUid()
			tbForHigest.defend_armyId = tbData.enemyData.armyId
			tbForHigest.defend_uid = tbData.enemyData.uid
			tbForHigest.battleData = true
			tbForHigest.mInIt = true
			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end

	-- 武将强化
	tbBtnEvent.onPartner = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
            require "script/module/partner/MainPartner"
        	local layPartner = MainPartner.create()
        	if (layPartner) then
         		 LayerManager.changeModule(layPartner, MainPartner.moduleName(),{1,3},true)
         		 PlayerPanel.addForPartnerStrength()
         		 require "script/module/main/MainScene"
				 MainScene.changeMenuCircle(1)
			end
		end
	end
	-- 装备强化
	tbBtnEvent.onEquip = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
        	require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
            
			 require "script/module/equipment/MainEquipmentCtrl"
			local layEquipment = MainEquipmentCtrl.create()
			if layEquipment then
				LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3})
				PlayerPanel.addForPartnerStrength()
				require "script/module/main/MainScene"
				MainScene.changeMenuCircle(1)
			else
				logger:error("layEquipment  nil")
			end
        	
		end
	end

	--  去阵容
	tbBtnEvent.onGoToFormation = function ( sender, eventType )
		if (eventType ==  TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
			LayerManager.addUILoading()
			MainScene.onFormation(sender,eventType)
		end
	end


				-- 发送战报按钮
	tbBtnEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			AudioHelper.playSendReport()
			UIHelper.sendBattleReport(BattleState.getBattleBrid(),batttleName,tbData.enemyData.uname)
		end
	end
	-- -- 培养名将
	-- tbBtnEvent.onTrainstar = function ( sender, eventType)
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		logger:debug("tbBtnEvent.onTrainstar")
	--   		ShowNotice.showShellInfo("功能暂未开放")
	-- 	end
	-- end

	-- -- 宠物喂养
	-- tbBtnEvent.onTrainPet = function ( sender, eventType)
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		logger:debug("tbBtnEvent.onTrainPet")
	-- 		ShowNotice.showShellInfo("功能暂未开放")
	-- 	end
	-- end


	local loseView = ArenaLoseView.create(createWinType.kTypeArena,tbData ,tbBtnEvent)
	return loseView
end

-- 夺宝失败面板
function createForGrabTrea( tbData )
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onFormation".. sender:getTag())
			-------------------add by zhaoqiangjun 201405241106--------------------
			require "script/module/formation/FormationCtrl"
			AudioHelper.playCommonEffect()
			FormationCtrl.loadFormationWithUid(sender:getTag())
			 EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		end
	end
	-- 重播按钮
	tbBtnEvent.onRepaly = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD) -- 重播
		end
	end

	-- 确定按钮
	tbBtnEvent.onConfirm = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
			SwitchCtrl.postBattleNotification("END_BATTLE")
			AudioHelper.playMainMusic()
			-- AudioHelper.playSceneMusic("fight_easy.mp3")
		end
	end

		-- 再抢一次按钮， TODO
	tbBtnEvent.onRobAgain = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			RobTreasureCtrl.grabTreasureAgain()
		end
	end

	-- 武将强化
	tbBtnEvent.onPartner = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			require "script/module/partner/MainPartner"
        	local layPartner = MainPartner.create()
        	if (layPartner) then
         		LayerManager.changeModule(layPartner, MainPartner.moduleName(),{1,3},true)
         		PlayerPanel.addForPartnerStrength()
         		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
         		require "script/module/switch/SwitchCtrl"
            	SwitchCtrl.postBattleNotification("END_BATTLE")
			end
		end
	end
	-- 装备强化
	tbBtnEvent.onEquip = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			 AudioHelper.playCommonEffect()
			 LayerManager.addUILoading()

			 require "script/module/equipment/MainEquipmentCtrl"
        	local layEquipment = MainEquipmentCtrl.create()
        	if layEquipment then
           		 LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3})
           		 PlayerPanel.addForPartnerStrength()
        	end
        	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
        	require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
		end
	end

		--  去阵容
	tbBtnEvent.onGoToFormation = function ( sender, eventType )
		if (eventType ==  TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.addUILoading()
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
            SwitchCtrl.postBattleNotification("END_BATTLE")
			MainScene.onFormation(sender,eventType)
		end
	end

	-- -- 培养名将
	-- tbBtnEvent.onTrainstar = function ( sender, eventType)
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		logger:debug("tbBtnEvent.onTrainstar")
	--         ShowNotice.showShellInfo("功能暂未开放")
	-- 	end
	-- end

	-- -- 宠物喂养
	-- tbBtnEvent.onTrainPet = function ( sender, eventType)
	-- 	if (eventType == TOUCH_EVENT_ENDED) then
	-- 		logger:debug("tbBtnEvent.onTrainPet")
	--         ShowNotice.showShellInfo("功能暂未开放")
	-- 	end
	-- end

	local loseView = ArenaLoseView.create(createWinType.kTypeFrag,tbData ,tbBtnEvent)
	return loseView
end