-- FileName: WAIntro.lua
-- Author: Xufei
-- Date: 2015-03-00
-- Purpose: 海盗激斗 说明
--[[TODO List]]

WAIntro = class("WAIntro")

-- UI控件引用变量 --

-- 模块局部变量 --
local _i18n = gi18n

function WAIntro:destroy(...)
	package.loaded["WAIntro"] = nil
end

function WAIntro:moduleName()
    return "WAIntro"
end

function WAIntro:ctor( ... )
	self.layMain = g_fnLoadUI("ui/peak_help.json")
end

function WAIntro:create(...)
	local configData = WorldArenaModel.getworldArenaConfig()
	self.layMain.tfd_desc:setText(string.format(_i18n[8126],configData.level))
	self.layMain.BTN_CLOSE:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			-- audio
			AudioHelper.playCloseEffect()
			LayerManager.removeLayout()
		end
	end)

	return self.layMain
end
