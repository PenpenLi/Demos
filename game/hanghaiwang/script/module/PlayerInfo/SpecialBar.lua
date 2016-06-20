-- FileName: SpecialBar.lua
-- Author: huxiaozhou
-- Date: 2015-09-15
-- Purpose: 专属宝物信息条
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

-- 模块局部变量 --
require "script/module/PlayerInfo/PlayerInfoBar"

SpecialBar = class("SpecialBar", PlayerInfoBar)

function SpecialBar:destroy( ... )
	logger:debug("SpecialBar:destroy")
end

function SpecialBar:init( ... )
	self.layMain = g_fnLoadUI("ui/special_easy_info.json")
	self.layMain:setTouchEnabled(false)
	
	self:update()
end

function SpecialBar:update( ... )
	local layMain = self.layMain

	local userInfo = self:updateInfo()

	layMain.TFD_JIEJING_NUM:setText(userInfo.rime_num)

	layMain.TFD_SILVER_NUM:setText(self:unitBelly(userInfo.silver_num))

	layMain.TFD_GOLD_NUM:setText(userInfo.gold_num)
end