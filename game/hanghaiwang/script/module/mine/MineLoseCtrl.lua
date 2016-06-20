-- FileName: MineLoseCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-06-08
-- Purpose: 查看战报，失败结算界面

module("MineLoseCtrl", package.seeall)
require "script/module/mine/MineLoseView"
require "script/module/mail/MailData"
-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString

local function init(...)

end

function destroy(...)
	package.loaded["MineLoseCtrl"] = nil
end

function moduleName()
	return "MineLoseCtrl"
end

function create(tbData , _tbDamageMap)
	local tbBtnEvent = {}
	-- 对方阵容按钮
	tbBtnEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
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
	local function eventConfirm( sender, eventType )
        if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/mine/MineMailData"
			require "script/module/mine/MineMailView"
			require "script/module/mail/MailData"
			AudioHelper.resetAudioState()
        	AudioHelper.playCommonEffect()
				-- LayerManager.removeLayout()
	        EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW)
			if(tbData.type  ==  MineMailData.ReplayType.KTypeMineMail) then  -- 回到邮件列表  add by sunyunpeng
				MineMailView.addListView()
				-- AudioHelper.playMainMusic()
			elseif(tbData.type == MailData.ReplayType.KTypeMailBattle) then
				MainMailView.addListView()
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
			else
				GlobalNotify.postNotify(MineConst.MineBattleEvt.MINE_END_BATTLE) 
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
	        end
            AudioHelper.playMainMusic()
        end
    end
	-- 发送战报按钮
	tbBtnEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbBtnEvent.onReport")
			eventConfirm(nil, TOUCH_EVENT_ENDED)

			AudioHelper.playCommonEffect()
			
			local fnSendReportCallback = function ( cbFlag, dictData, bRet )
				if(bRet) then
					ShowNotice.showShellInfo( m_i18nString(2166,m_i18n[2801])) --m_i18n[2166]) 2801
				end
			end
			local userName = UserModel.getUserName()

			local text = "<table>" .. userName.. "," .. tbData.uname .. "," ..
         	tbData.brid .. "," .. ChatCellType.playerReport .. "<table/>"

			--local text = m_i18nString(2168, tbData.playerName, userName)
			RequestCenter.chat_sendWorld(fnSendReportCallback, Network.argsHandler(text, 2,2))
		end
	end

		-- 发送战报按钮
	tbBtnEvent.onReport1 = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			AudioHelper.playSendReport()
			UIHelper.sendBattleReport(BattleState.getBattleBrid(),batttleName,tbData.uname)
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
			tbForHigest.defend_uid = tbData.uid
			tbForHigest.battleData = true
			-- 判断自己的队伍如果是2，需要将自己的队伍换到1来
			if (_tbDamageMap.selfTeam == 2) then
				local tbTemp = _tbDamageMap.team1
				_tbDamageMap.team1 = _tbDamageMap.team2
				_tbDamageMap.team2 = tbTemp
			end
			tbForHigest.mInIt = true
			logger:debug({_tbDamageMap = _tbDamageMap})
			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end
    
	tbBtnEvent.onConfirm = eventConfirm

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
			end

		end
	end

	tbBtnEvent.onTrainstar = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			
			eventConfirm(nil, TOUCH_EVENT_ENDED)
    		require "script/module/main/MainScene"
            MainScene.onFormation(nil, TOUCH_EVENT_ENDED)
		end
	end
	local instanceView = MineLoseView:new()
	local loseView = instanceView:create(tbBtnEvent, tbData)

	return loseView
end