-- FileName: MineWinCtrl.lua
-- Author: huxiaozhou
-- Date: 2015-06-01
-- Purpose: 资源矿抢矿胜利面板控制
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /


module("MineWinCtrl", package.seeall)
require "script/module/mine/MineWinView"
require "script/module/public/GlobalNotify"
require "script/module/mail/MailData"
-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString = gi18nString
local function init(...)

end

function destroy(...)
	package.loaded["MineWinCtrl"] = nil
end

function moduleName()
    return "MineWinCtrl"
end

function create(tbData , _tbDamageMap)
	-- 对方阵容按钮
	local tbEvent = tbData or {}
	logger:debug({tbData=tbData})
	tbEvent.onFormation = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			require "script/module/formation/FormationCtrl"
			AudioHelper.playCommonEffect()
			FormationCtrl.loadFormationWithUid(tbData.uid)
		end
	end
	-- 重播按钮
	tbEvent.onRepaly = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD) -- 重播
		end
	end

	-- 确定按钮按钮
	tbEvent.onConfirm = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("zhujiemian.mp3")
			require "script/module/mine/MineMailData"
			require "script/module/mine/MineMailView"
			require "script/module/mail/MailData"
			AudioHelper.resetAudioState()  
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			if(tbData.type  ==  MineMailData.ReplayType.KTypeMineMail) then  -- 回到邮件列表  add by sunyunpeng
				MineMailView.addListView()
				-- AudioHelper.playMainMusic()
			elseif(tbData.type == MailData.ReplayType.KTypeMailBattle) then
				MainMailView.addListView()
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
			else
				-- ShowNotice.showShellInfo(m_i18n[5636]) --"占领资源岛成功",
				GlobalNotify.postNotify(MineConst.MineBattleEvt.MINE_END_BATTLE) 
				LayerManager.addLayout(UIHelper.createCommonDlgNew({strText = m_i18n[5636], nBtn=1, fnConfirmEvent = function ( sender, eventType )
					if (eventType == TOUCH_EVENT_ENDED) then
						AudioHelper.playCommonEffect()
						LayerManager.removeLayout()
					end
				end}))
				
				-- AudioHelper.playSceneMusic("fight_easy.mp3")
			end
			AudioHelper.playMainMusic()
		end
	end
	-- 发送战报按钮
	tbEvent.onReport = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			tbEvent.onConfirm(nil, TOUCH_EVENT_ENDED)

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
	tbEvent.onReport1 = function ( sender, eventType)
		if (eventType == TOUCH_EVENT_ENDED) then
			logger:debug("tbEvent.onReport")
			-- tbEvent.onConfirm(nil, TOUCH_EVENT_ENDED)

			AudioHelper.playSendReport()
			local brid =  BattleState.getBattleBrid()
			UIHelper.sendBattleReport(brid,batttleName,tbData.uname)
		end
	end

	-- 战斗数据按钮
	tbEvent.onBattleData = function ( sender, eventType )
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
			LayerManager.addLayout(ArenaHighest.create(_tbDamageMap,tbForHigest))
		end
	end
	
	local instanceView = MineWinView:new()
	local layView = instanceView:create(tbEvent)

	return layView
end
