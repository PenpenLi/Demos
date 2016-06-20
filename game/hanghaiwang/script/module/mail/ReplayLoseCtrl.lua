-- FileName: ReplayLoseCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-07-24
-- Purpose: 查看战报，失败结算界面
--[[TODO List]]

module("ReplayLoseCtrl", package.seeall)
require "script/module/mail/ReplayLoseView" 
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["ReplayLoseCtrl"] = nil
end

function moduleName()
	return "ReplayLoseCtrl"
end

function create(...)

end




-------------------------------------------------------
--查看战报失败面板
function createForMail(tbData , _tbDamageMap)
	logger:debug({tbData = tbData})
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			-- logger:debug("tbBtnEvent.onFormation")
			logger:debug("tbBtnEvent.onFormation".. sender:getTag())
			AudioHelper.playCommonEffect()
			-------------------add by zhaoqiangjun 201405241106--------------------
			require "script/module/formation/FormationCtrl"
			FormationCtrl.loadFormationWithUid(tbData.uid)
		end
	end
	-- 重播按钮
	tbBtnEvent.onRepaly = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onRepaly")
			AudioHelper.playCommonEffect()
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD) -- 重播
		end
	end

	-- 确定按钮按钮
	require ("script/battle/notification/EventBus")
	local function eventConfirm( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.resetAudioState()   
			if (sender and sender.isReport) then 
				AudioHelper.playInfoEffect()
			else 
				AudioHelper.playCommonEffect()
			end 
     
			
            EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
            GlobalNotify.postNotify("END_BATTLE")
            --如果是邮件查看战报的结算面板，重新把邮件的listview添加到layout上
			if(tbData.type  ==  MailData.ReplayType.KTypeMailBattle) then
				MainMailView.addListView()
			end

			AudioHelper.playMainMusic()
        end
    end
	tbBtnEvent.onConfirm = eventConfirm

	-- 战斗数据按钮
	tbBtnEvent.onBattleData = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug({tbData = tbData})
			require "script/module/arena/ArenaHighest"
			local tbForHigest = {}
			local mUid = UserModel.getUserUid()
			if (tbData.uid2 == mUid) then
				tbForHigest.attack_uid = tbData.uid2
				tbForHigest.defend_uid = tbData.uid
				tbForHigest.mInIt = true

				tbForHigest.attack_isplayer = tbData.isPlayer2   -- 2016.2.22 yangna 为了区分战报分享查看阵容的是否是npc
				tbForHigest.defend_isplayer = tbData.isPlayer1   -- 2016.2.22 yangna 为了区分战报分享查看阵容的是否是npc
			elseif (tbData.uid == mUid) then
				tbForHigest.attack_uid = tbData.uid
				tbForHigest.defend_uid = tbData.uid2
				tbForHigest.mInIt = true

				tbForHigest.attack_isplayer = tbData.isPlayer1 
				tbForHigest.defend_isplayer = tbData.isPlayer2   
			else
				tbForHigest.attack_uid = tbData.uid
				tbForHigest.defend_uid = tbData.uid2

				tbForHigest.attack_isplayer = tbData.isPlayer1 
				tbForHigest.defend_isplayer = tbData.isPlayer2 
			end
			tbForHigest.battleData = true

			if (tbData.attacker_server_id) then
				tbForHigest.attacker_server_id = tbData.attacker_server_id
   				tbForHigest.defender_server_id = tbData.defender_server_id
   				tbForHigest.attacker_pid = tbData.attacker_pid
   				tbForHigest.defender_pid = tbData.defender_pid
   			end

			-- 若本人在里面且本人不是team1，交换两个team
			if (tbForHigest.mInIt) then
				if (_tbDamageMap.selfTeam == 2) then
					local tbTemp = _tbDamageMap.team1
					_tbDamageMap.team1 = _tbDamageMap.team2
					_tbDamageMap.team2 = tbTemp
				end
			else   --modify  yangna 2016.2.23 分享战报，查看其他人战报，失败结算面板的战斗数据，两方阵容反了
				if (not _tbDamageMap.isNeedChange) then 
					local tbTemp = _tbDamageMap.team1
					_tbDamageMap.team1 = _tbDamageMap.team2
					_tbDamageMap.team2 = tbTemp
					_tbDamageMap.isNeedChange = true    --防止多次点按钮时多次交换数据
				end 
				tbForHigest.attack_uid,tbForHigest.defend_uid = tbForHigest.defend_uid ,tbForHigest.attack_uid
				tbForHigest.attack_isplayer,tbForHigest.defend_isplayer = tbForHigest.defend_isplayer,tbForHigest.attack_isplayer
			end

			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end

	-- 发送战报按钮
	tbBtnEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onReport")
			sender.isReport = true
			eventConfirm(sender, TOUCH_EVENT_ENDED)

			local fnSendReportCallback = function ( cbFlag, dictData, bRet )
				if(bRet) then
					ShowNotice.showShellInfo( m_i18nString(2166,m_i18n[2801])) --m_i18n[2166]) 2801
				end
			end
			local userName = UserModel.getUserName()

			local text = "<table>" .. userName.. "," .. tbData.playerName .. "," ..
         	tbData.brid .. "," .. ChatCellType.playerReport .. "<table/>"

			--local text = m_i18nString(2168, tbData.playerName, userName)
			RequestCenter.chat_sendWorld(fnSendReportCallback, Network.argsHandler(text, 2,2))
		end
	end
	-- 武将强化
	tbBtnEvent.onPartner = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onPartner")

			eventConfirm(nil, TOUCH_EVENT_ENDED)
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
			eventConfirm(nil, TOUCH_EVENT_ENDED)
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

	-- 2014-08-06, zhangqi, 查看阵容
	tbBtnEvent.onTrainstar = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			eventConfirm(nil, TOUCH_EVENT_ENDED)
    		require "script/module/main/MainScene"
    		sender.isNoAudio = true
            MainScene.onFormation(sender, TOUCH_EVENT_ENDED)
		end
	end


	local loseView = ReplayLoseView.create(tbBtnEvent,tbData)
	return loseView
end
