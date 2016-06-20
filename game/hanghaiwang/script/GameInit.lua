-- FileName: GameInit.lua
-- Author: zhangqi
-- Date: 2014-09-10
-- Purpose: 游戏的真正入口
--[[TODO List]]
-- modified: zhangqi, 2015-11-24, 把autorequire的初始化从main.lua转移过来，避免出现修改不能更新

--auto require
function autoRequire()
	require "script/autoRequireFileTbl"
	package.loaded["script/autoRequireFileTbl"] = nil
	local m_autoRequireFileTbl = g_autoRequireFileTbl
    local m_requireModels = {}
    m_requireModels.__index=m_requireModels
    require "script/utils/LuaUtil"
 	local mt = {}
    mt.__index = function(_,k)
    	-- print("enter get require")
    	-- print(k)
        local filePath = m_autoRequireFileTbl[tostring(k)]
        -- print(filePath)
        if ( filePath ) then
        	-- print("enter get require2")
            require(filePath)
            local fileSplitArr = string.split(filePath, "/")
            local fileName = fileSplitArr[#fileSplitArr]
            -- print(string.format("filePath %s fileName %s" , filePath, fileName))
            rawset(m_requireModels , fileName , _G[fileName] and _G[fileName] or true)
         	rawset(_G , fileName , nil)
            rawset(package.loaded  , filePath , nil)
            return m_requireModels[fileName]
        else
            return nil
        end
    end
    setmetatable(_G, m_requireModels)
    setmetatable(m_requireModels, mt)
end

module("GameInit", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --

local function init(...)
	autoRequire() --liweidong 调用位置要在设置完成pakage.loaded.path之后

	require "db/i18n"
	require "script/GlobalVars"
    require "script/module/login/LoginHelper"
	LoginHelper.initGame()

	require "platform/ShowLogoUI"
	ShowLogoUI.showLogoUI()
end
init()

function destroy(...)
	package.loaded["GameInit"] = nil
end
