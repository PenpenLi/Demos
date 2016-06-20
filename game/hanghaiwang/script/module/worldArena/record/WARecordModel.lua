-- FileName: WARecordModel.lua
-- Author: Xufei
-- Date: 2015-2-22
-- Purpose: 海盗激斗 对战记录
--[[TODO List]]

module("WARecordModel", package.seeall)

--[[
record_info = {
	conti = {
		}
		
	my = {
		1 = {
			brid = "WAN_11076"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "2"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20694"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "18"
			attacker_rank = "20"
			attack_time = "1456305957.000000"
			attacker_utid = "1"
			defender_uname = "mbg20694"
			}
			
		2 = {
			brid = "WAN_11075"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "1"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20702"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "20"
			attacker_rank = "23"
			attack_time = "1456305950.000000"
			attacker_utid = "1"
			defender_uname = "mbg20702"
			}
			
		3 = {
			brid = "WAN_11074"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "0"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "0"
			defender_utid = "1"
			defender_pid = "20686"
			defender_conti = "0"
			defender_terminal_conti = "2"
			defender_rank = "16"
			attacker_rank = "18"
			attack_time = "1456305944.000000"
			attacker_utid = "1"
			defender_uname = "mbg20686"
			}
			
		4 = {
			brid = "WAN_11073"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "2"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20209"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "18"
			attacker_rank = "20"
			attack_time = "1456305938.000000"
			attacker_utid = "1"
			defender_uname = "mbg20209"
			}
			
		5 = {
			brid = "WAN_11072"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "1"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20458"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "20"
			attacker_rank = "23"
			attack_time = "1456305793.000000"
			attacker_utid = "1"
			defender_uname = "mbg20458"
			}
			
		6 = {
			brid = "WAN_11071"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "0"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "0"
			defender_utid = "1"
			defender_pid = "20337"
			defender_conti = "0"
			defender_terminal_conti = "2"
			defender_rank = "3"
			attacker_rank = "4"
			attack_time = "1456305771.000000"
			attacker_utid = "1"
			defender_uname = "mbg20337"
			}
			
		7 = {
			brid = "WAN_11070"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "2"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20702"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "4"
			attacker_rank = "5"
			attack_time = "1456305767.000000"
			attacker_utid = "1"
			defender_uname = "mbg20702"
			}
			
		8 = {
			brid = "WAN_11069"
			defender_server_id = "110009"
			attacker_pid = "107"
			attacker_server_id = "110009"
			defender_server_name = "myserver"
			attacker_terminal_conti = "0"
			attacker_conti = "1"
			attacker_uname = "亨利哈维"
			attacker_server_name = "myserver"
			result = "1"
			defender_utid = "1"
			defender_pid = "20474"
			defender_conti = "0"
			defender_terminal_conti = "0"
			defender_rank = "5"
			attacker_rank = "6"
			attack_time = "1456305765.000000"
			attacker_utid = "1"
			defender_uname = "mbg20474"
			}
			
		}
		
	}
	
}
--]]

-- UI控件引用变量 --

-- 模块局部变量 --
local TAB_NAME = {
	TAB_1 = "1",
	TAB_2 = "2",
}

local _tabNum
local _WArecordInfo
local _WArecordDesc

function setTabName( tabName )
	_tabNum = TAB_NAME[tabName]
end

function getTabNum( ... )
	return _tabNum
end

local function setWARecordInfo( recordInfo )
	_WArecordInfo = recordInfo
end

local function getWARecordInfo( ... )
	return _WArecordInfo
end

local getFightRecordInfo = function()
	logger:debug("getFightRecordInfo")
	local recordInfo = getWARecordInfo()
	local myFightRecord = recordInfo.my
	local myServerId = UserModel.getServerId()
	local myPid = UserModel.getPid()
	
	for k,v in pairs(myFightRecord) do
		v.iImAttacker = (myServerId..myPid == v.attacker_server_id..v.attacker_pid)
	end
	return myFightRecord
end

local getContinuousInfo = function()
	logger:debug("getContinuousInfo")
	local recordInfo = getWARecordInfo()
	local continuousInfo = recordInfo.conti

	local tbRet = {}
	for k,v in ipairs ( continuousInfo ) do
		if (tonumber(v.result)==1) then
			if (tonumber(v.attacker_conti)~=0) then
				local temp = {}
				temp.state = "continuous"
				temp.data = v
				table.insert(tbRet, temp)
			end
			if (tonumber(v.attacker_terminal_conti)~=0) then
				local temp = {}
				temp.state = "terminal"
				temp.data = v
				table.insert(tbRet, temp)
			end
		else
			if (tonumber(v.defender_terminal_conti)~=0) then
				local temp = {}
				temp.state = "terminal"
				temp.data = v
				table.insert(tbRet, temp)
			end
		end
	end

	logger:debug({contiRecordData = tbRet})
	return tbRet
end

local TAB_FUNC = {
	["1"] = getContinuousInfo,
	["2"] = getFightRecordInfo,
}

-- 根据当前tab编号，返回对应的用于显示的数据
function getNowTabInfo( ... )
	local tabNum = getTabNum()
	logger:debug({tabNum_recordModel = tabNum})
	local fnGetRecordViewInfo = TAB_FUNC[tabNum]
	local recordViewInfo = fnGetRecordViewInfo()
	return recordViewInfo
end

local function init(...)
	_tabNum = TAB_NAME.TAB_1
	_WArecordDesc = preGetWARecordDes()
end

function destroy(...)
	package.loaded["WARecordModel"] = nil
end

function moduleName()
    return "WARecordModel"
end

function preGetWARecordDes()
	local DBEmail = DB_Email
	local tbWARecordDes = {
		OTHER_WIN_YOU = DBEmail.getDataById( 49 ),
		OTHER_LOS_YOU = DBEmail.getDataById( 50 ),
		YOU_WIN_OTHER = DBEmail.getDataById( 51 ),
		YOU_LOS_OTHER = DBEmail.getDataById( 52 ),
		CONTINUOUS_KO = DBEmail.getDataById( 53 ),
		TERMINATE_CON = DBEmail.getDataById( 54 ),
	}

	for k,v in pairs (tbWARecordDes) do
		v.descTable = lua_string_split(v.content, "|")
	end
	logger:debug({let_us_look_at_the_TBWARECORDDEC = tbWARecordDes})
	return tbWARecordDes
end

function getDesStr( ... )
	return _WArecordDesc
end

function create( recordInfo )
	init()
	setWARecordInfo( recordInfo )
end
