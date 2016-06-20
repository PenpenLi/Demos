-- FileName: WARecordCtrl.lua
-- Author: Xufei
-- Date: 2015-2-22
-- Purpose: 海盗激斗 对战记录
--[[TODO List]]

module("WARecordCtrl", package.seeall)

-- UI控件引用变量 --
local _WARecordViewIns
-- 模块局部变量 --

function getBtnFunByName( funName )
	local btnEvent = {}
	btnEvent.onChooseTab = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playTabEffect()
			local tabTag = sender:getTag()
			WARecordModel.setTabName("TAB_"..tabTag)
			_WARecordViewIns:showRecord()
		end
	end

	btnEvent.onClose = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end

	btnEvent.onConfirm = function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			LayerManager.removeLayout()
		end
	end	

	btnEvent.onRecord = function ( recordInfo )
		local brid = recordInfo.brid
		local funCallback = function ( fightRet )
			local amf3_obj = Base64.decodeWithZip(fightRet)
			local lua_obj = amf3.decode(amf3_obj)
			local tbData = {}

   			tbData.playerName2 = "S."..recordInfo.defender_server_id.." "..lua_obj.team2.name
   			tbData.fightForce2 = lua_obj.team2.fightForce
   			tbData.uid2 = lua_obj.team2.uid
   			tbData.isPlayer2 = lua_obj.team2.isPlayer

   			tbData.playerName = "S."..recordInfo.attacker_server_id.." "..lua_obj.team1.name
   			tbData.fightForce = lua_obj.team1.fightForce
   			tbData.uid = lua_obj.team1.uid
   			tbData.isPlayer1 = lua_obj.team1.isPlayer

   			tbData.attacker_server_id = recordInfo.attacker_server_id
   			tbData.defender_server_id = recordInfo.defender_server_id
   			tbData.attacker_pid = recordInfo.attacker_pid
   			tbData.defender_pid = recordInfo.defender_pid

   			tbData.brid = brid
   			tbData.type = 2
			BattleModule.PlayNormalRecord(fightRet, function ( ... ) end, tbData, true)
		end
		MailService.getRecord(brid, funCallback)
	end

	return btnEvent[funName]
end

local function init(...)

end

function destroy(...)
	package.loaded["WARecordCtrl"] = nil
end

function moduleName()
    return "WARecordCtrl"
end

function create( recordInfo )
	logger:debug({record_info = recordInfo})
	WARecordModel.create( recordInfo )

	_WARecordViewIns = WARecordView:new()
	local recordView = _WARecordViewIns:create()
	LayerManager.addLayout(recordView) 	
end
