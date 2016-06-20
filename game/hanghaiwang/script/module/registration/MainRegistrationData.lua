-- FileName: MainRegistrationData.lua
-- Author: lizy
-- Date: 2014-04-00
-- Purpose: 每日签到数据存储
--[[TODO List]]

module("MainRegistrationData", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local signInfo   -- 本月已经领取的奖励的id
local signNum    -- 
local signInNum
 
local function init(...)

end


function destroy(...)
	package.loaded["MainRegistrationData"] = nil
end

function moduleName()
    return "MainRegistrationData"
end

function setSignInfo( sign_info )
	signInfo = sign_info
end

function getSignInfo( ... )
	return signInfo
end

function setSignNum( num )
	signNum = num
end

function getSignNum( ... )
	return signNum
end

function create(...)

end

function getSignInNum( ... )
	return signInNum
end

function setSignInNum( signIn_Num )
	signInNum = signIn_Num
end
