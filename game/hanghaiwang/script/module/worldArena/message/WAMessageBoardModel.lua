-- FileName: WAMessageBoardModel.lua
-- Author: 
-- Date: 2015-03-00
-- Purpose: function description of module
--[[TODO List]]

module("WAMessageBoardModel", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local _msgInfo
local _leavingMsg

local function init(...)
	_msgInfo = nil
	_leavingMsg = nil
end

function destroy(...)
	package.loaded["WAMessageBoardModel"] = nil
end

function moduleName()
    return "WAMessageBoardModel"
end

function create( msgInfo )
	init()
	_msgInfo = msgInfo


end

function getMsgInfo( ... )
	return _msgInfo.msg
end

function getMyMsgNum( ... )
	return tonumber(_msgInfo.my_msg_num)
end

function addMyMsgNum( msgNum )
	_msgInfo.my_msg_num = tonumber(_msgInfo.my_msg_num) + ( msgNum or 1 )
end

function setLeavingMsg( leavingMsg )
	_leavingMsg = leavingMsg
end

function getLeavingMsg( ... )
	return _leavingMsg
end

function getMsgLimit( ... )
	local configData = WorldArenaModel.getworldArenaConfig()
	local tbMsgLimit = lua_string_split(configData.message_num, "|")
	if (WorldArenaModel.getMySignUpTime() == 0) then			 -- 如果未报名
		return tonumber(tbMsgLimit[2])
	else
		return tonumber(tbMsgLimit[1])
	end
end

function getStillCanMsgNum( ... )
	local limitNum = getMsgLimit()
	local haveMsgNum = getMyMsgNum()
	if (limitNum>=haveMsgNum) then
		return limitNum-haveMsgNum
	else
		return 0
	end
end

