-- FileName: AwakeLoseCtrl.lua
-- Author: LvNanchun
-- Date: 2015-11-17
-- Purpose: function description of module
--[[TODO List]]

module("AwakeLoseCtrl", package.seeall)

-- UI variable --

-- module local variable --
local _tbBattleData

local function init(...)

end

function destroy(...)
    package.loaded["AwakeLoseCtrl"] = nil
end

function moduleName()
    return "AwakeLoseCtrl"
end

local fnBtnClose = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
		AudioHelper.playCommonEffect()
	end
end

-- 调整阵容
local fnBtnFormation = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
		AudioHelper.playCommonEffect()
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	    MainScene.onFormation(nil, TOUCH_EVENT_ENDED)
	end
end

-- 武将强化
local fnBtnStrength = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
		AudioHelper.playCommonEffect()
		local layPartner = MainPartner.create()
	    if (layPartner) then
	    	EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
	    	LayerManager.changeModule(layPartner, MainPartner.moduleName(),{1,3},true)
	    	PlayerPanel.addForPartnerStrength()
	    	require "script/module/main/MainScene"
	    	MainScene.changeMenuCircle(1)
		end
	end
end

-- 装备强化
local fnBtnEquip = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.resetAudioState()  --音乐状态恢复到战斗前
		AudioHelper.playCommonEffect()
		local layEquipment = MainEquipmentCtrl.create()
		if layEquipment then
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			LayerManager.changeModule(layEquipment, MainEquipmentCtrl.moduleName(), {1, 3})
			PlayerPanel.addForPartnerStrength()
			require "script/module/main/MainScene"
			MainScene.changeMenuCircle(1)
		end
	end
end

-- 发送战报
local fnSendReport = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.playSendReport()
		local modName,baseName
		local baseDb = DB_Stronghold.getDataById(_tbBattleData.strongholdId)
		local copyDb=DB_Disillusion_copy.getDataById(_tbBattleData.copyId)
		modName = copyDb.name --"日常副本"
		baseName = baseDb.name
		UIHelper.sendBattleReport(BattleState.getBattleBrid(),modName,baseName)
	end
end

-- 查看攻略
local fnOnStrategy = function ( sender, eventType )
	if (eventType == TOUCH_EVENT_ENDED) then
		AudioHelper.resetAudioState()
		AudioHelper.playStrategy()
		EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
		local baseDb = DB_Stronghold.getDataById(_tbBattleData.strongholdId)
		local baseName = baseDb.name
		StrategyCtrl.create({type=3,name=baseName,param1=_tbBattleData.copyId,param2=_tbBattleData.strongholdId})
	end
end

-- 进入界面的回调
local function onEnterCall( ... )
	
end

-- 退出界面的回调
local function onExitCall(  )
	
end

--[[desc:功能简介
    arg1: tbBattleData包含以下字段。strongholdId,copyId
    return: 是否有返回值，返回值说明  
—]]
function create( tbBattleData )
	-- 虚构战斗数据
--	local tbBattleData = {}
--	tbBattleData.strongholdId = 501001
	_tbBattleData = tbBattleData

	local viewInstance = AwakeLoseView:new()

	-- 构造按钮表
	local tbBtn = {}
	tbBtn.close = fnBtnClose
	tbBtn.formation = fnBtnFormation
	tbBtn.strength = fnBtnStrength
	tbBtn.equip = fnBtnEquip
	tbBtn.onExitCall = onExitCall
	tbBtn.onEnterCall = onEnterCall
	tbBtn.onSendReport = fnSendReport
	tbBtn.onStrategy = fnOnStrategy

	-- 构造界面信息表
	local tbInfo = {}
	tbInfo.starNum = copyAwakeModel.getHoldStarNumber(tbBattleData.copyId, tbBattleData.strongholdId)
	tbInfo.fightNum = UserModel.getFightForceValue()
	tbInfo.strongHoldName = DB_Stronghold.getDataById(tbBattleData.strongholdId).name

	local loseView = viewInstance:create( tbBtn, tbInfo )

	AudioHelper.playMusic("audio/bgm/bai.mp3",false)

	return loseView
end

