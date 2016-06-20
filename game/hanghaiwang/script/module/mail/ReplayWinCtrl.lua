-- FileName: ReplayWinCtrl.lua
-- Author: zhangjunwu
-- Date: 2014-07-24
-- Purpose:邮件查看战报 胜利控制面板
--[[TODO List]]

module("ReplayWinCtrl", package.seeall)
require "script/module/mail/ReplayWinView"
-- UI控件引用变量 --
local m_i18nString = gi18nString
-- 模块局部变量 --

local function init(...)

end

function destroy(...)
	package.loaded["ReplayWinCtrl"] = nil
end

function moduleName()
	return "ReplayWinCtrl"
end

function create(...)

end


--[[desc:--邮件查看战报胜利结算面板
    arg1: 参数说明
    return: 是否有返回值，返回值说明  
—]]
function createForMail( tbData , _tbDamageMap ) 
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onFormation")
			require "script/module/formation/FormationCtrl"
			
			AudioHelper.playCommonEffect()

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
	tbBtnEvent.onConfirm = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onConfirm")
			-- AudioHelper.resetAudioState() --还原战斗前音乐状态
			-- -- require "script/battle/BattleLayer"
			-- AudioHelper.playBtnEffect("zhujiemian.mp3")
			-- AudioHelper.playMainMusic()
			
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			GlobalNotify.postNotify("END_BATTLE")
			--如果是邮件查看战报的结算面板，重新把邮件的listview添加到layout上
			if(tbData.type  ==  MailData.ReplayType.KTypeMailBattle) then

				MainMailView.addListView()
			end

			AudioHelper.resetAudioState() --还原战斗前音乐状态
			-- require "script/battle/BattleLayer"
			AudioHelper.playBtnEffect("zhujiemian.mp3")
			AudioHelper.playMainMusic()
			
		end
	end

	-- 战斗数据按钮
	tbBtnEvent.onBattleData = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			require "script/module/arena/ArenaHighest"
			logger:debug({tbData = tbData})
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
			end

			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end

	-- 发送战报按钮按钮
	tbBtnEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onReport")
			-- require "script/battle/BattleLayer"
			AudioHelper.playInfoEffect()

			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			if(tbData.type  ==  MailData.ReplayType.KTypeMailBattle) then

				MainMailView.addListView()
			end
			local fnSendReportCallback = function ( cbFlag, dictData, bRet )
				if(bRet) then

					--ShowNotice.showShellInfo( "战报已发送到世界聊天")
					ShowNotice.showShellInfo( m_i18nString(2166,gi18n[2801]))
				end
			end
			local userName = UserModel.getUserName()
			--local text = "【" .. tbData.playerName .. "vs" ..  userName .. "】" .. "查看战报"
			local text = "<table>" .. userName.. "," .. tbData.playerName .. "," ..
         				tbData.brid .. "," .. ChatCellType.playerReport .. "<table/>"
			RequestCenter.chat_sendWorld(fnSendReportCallback, Network.argsHandler(text, 2,2))
		end
	end


	local winView = ReplayWinView.create(tbBtnEvent,tbData)
	return winView
end
