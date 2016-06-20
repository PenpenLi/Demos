-- FileName: ArenaWinCtrl.lua
-- Author: huxiaozhou
-- Date: 2014-05-12
-- Purpose: 竞技场,比武，夺宝 胜利控制面板
--[[TODO List]]

module("ArenaWinCtrl", package.seeall)


require "script/module/arena/ArenaWinView"

-- UI控件引用变量 --

-- 模块局部变量 --

local createWinType = createWinType or {
	kTypeArena = 1, -- 竞技场
	kTypeFrag  = 2				-- 夺宝
					-- 比武
}	

local function init(...)

end

function destroy(...)
	package.loaded["ArenaWinCtrl"] = nil
end

function moduleName()
    return "ArenaWinCtrl"
end

function createForArena(_tbData , _tbDamageMap) --竞技场胜利结算面板
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

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
			AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			require "script/module/switch/SwitchCtrl"
			SwitchCtrl.postBattleNotification("END_BATTLE")

			AudioHelper.playSceneMusic("fight_easy_02.mp3")
		end
	end

	-- 战斗数据按钮
	tbBtnEvent.onBattleData = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/arena/ArenaHighest"
			logger:debug({_tbData = _tbData})
			local tbForHigest = {}
			tbForHigest.attack_uid = UserModel.getUserUid()
			tbForHigest.defend_armyId = _tbData.enemyData.armyId
			tbForHigest.defend_uid = _tbData.enemyData.uid
			tbForHigest.battleData = true
			tbForHigest.mInIt = true
			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end

			-- 发送战报按钮
	tbBtnEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			AudioHelper.playSendReport()
			UIHelper.sendBattleReport(BattleState.getBattleBrid(),batttleName,_tbData.enemyData.uname)
		end
	end

	local winView = ArenaWinView.create(createWinType.kTypeArena,tbBtnEvent,_tbData)
	return winView
end

-- 创建夺宝胜利面板
function createForGrabTrea( _tbData )
	logger:debug(_tbData.fragmentName)
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			-------------------add by zhaoqiangjun 201405241106--------------------
			require "script/module/formation/FormationCtrl"
			AudioHelper.playCommonEffect()

			FormationCtrl.loadFormationWithUid(sender:getTag())
		end
	end
	-- 再抢一次按钮
	tbBtnEvent.onRobAgain= function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			-- AudioHelper.playCommonEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			AudioHelper.playCommonEffect()


			RobTreasureCtrl.grabTreasureAgain()
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
			AudioHelper.playCommonEffect()
			 --如果抢到碎片了，返回合成碎片界面
			 if(_tbData.fragmentName and not BTUtil:getGuideState())then
			 	logger:debug(_tbData.fragmentName)

				require "script/module/grabTreasure/MainGrabTreasureCtrl"
				LayerManager.addUILoading()
				MainGrabTreasureCtrl.create()
			else
			--没有抢到碎片，则继续在抢夺界面
			 	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			 	require "script/module/switch/SwitchCtrl"
            	SwitchCtrl.postBattleNotification("END_BATTLE")	
			end
			AudioHelper.playMainMusic()
			-- AudioHelper.playSceneMusic("fight_easy.mp3")
		end
	end
	
	local winView = ArenaWinView.create(createWinType.kTypeFrag,tbBtnEvent,_tbData)
	return winView
end

-- 获取竞技场胜利面板是否存在的方法
function winViewExist(  )
	local bExist = false
	if ArenaWinView.getViewExist() then
		bExist = true
	end
	return bExist
end
