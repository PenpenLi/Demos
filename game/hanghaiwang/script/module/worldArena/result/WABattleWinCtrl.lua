-- FileName: WABattleWinCtrl.lua
-- Author: Xufei
-- Date: 2015-02-19
-- Purpose: 海盗激斗 胜利结算
--[[TODO List]]

module("WABattleWinCtrl", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _callback 
local _tbArgs
local _damageMap


function getBtnFunByName( funName )
	local btnEvent = {}
	btnEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("Win_WA_Battle_onClose")
			LayerManager.removeLayout()
			EventBus.sendNotification(NotificationNames.EVT_CLOSE_RESULT_WINDOW) -- 确定
			GlobalNotify.postNotify("END_BATTLE")
			if (_callback) then
				_callback()
			end
		end
	end

	btnEvent.onFormation = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("Win_WA_Battle_onFormation")
			WAService.getFighterDetail(_tbArgs.oppoPlayer.server_id, _tbArgs.oppoPlayer.pid, FormationCtrl.loadDiffServerFormation)
		end
	end

	btnEvent.onReplay = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("Win_WA_Battle_onReplay")
			EventBus.sendNotification(NotificationNames.EVT_REPLAY_RECORD) -- 确定

		end
	end

	btnEvent.onSeeData = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			logger:debug("Win_WA_Battle_onSeeData")

			local tbForHigest = {}

			tbForHigest.attack_uid = ""
			tbForHigest.defend_uid = ""
			tbForHigest.mInIt = true
			tbForHigest.attack_isplayer = true
			tbForHigest.defend_isplayer = true
			tbForHigest.battleData = true

			tbForHigest.attacker_server_id = _tbArgs.myPlayer.server_id
   			tbForHigest.defender_server_id = _tbArgs.oppoPlayer.server_id
   			tbForHigest.attacker_pid = _tbArgs.myPlayer.pid
   			tbForHigest.defender_pid = _tbArgs.oppoPlayer.pid
			
			LayerManager.addLayout(ArenaHighest.create(_damageMap,tbForHigest))

		end
	end

	return btnEvent[funName]
end

local function init(...)

end

function destroy(...)
	package.loaded["WABattleWinCtrl"] = nil
end

function moduleName()
    return "WABattleWinCtrl"
end

-- tbArgs = {reward,contiKill,preContiKill,oppoPlayer,myPlayer,callBack}
function create( tbArgs, damageMap, isPassFight )
	_callback = tbArgs.callBack
	_tbArgs = tbArgs

	logger:debug({wabattleWin_damagemap = damageMap})

	_damageMap = damageMap


	local instanceView = WABattleWinView:new()
	return instanceView:create(tbArgs, isPassFight)
end
