-- FileName: ExplorInfoBarNew.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

-- 模块局部变量 --
require "script/module/PlayerInfo/PlayerInfoBar"

ExplorInfoBarNew = class("ExplorInfoBarNew", PlayerInfoBar)

function ExplorInfoBarNew:destroy( ... )
	logger:debug("ExplorInfoBarNew:destroy")
end

function ExplorInfoBarNew:init( ... )
	self.layMain = g_fnLoadUI("ui/easy_info_exp_new.json")

	self:update()
end

function ExplorInfoBarNew:update( ... )
	local layMain = self.layMain

	local userInfo = self:updateInfo()

	layMain.TFD_INFORMATION_BELLY_NUM:setText(self:unitBelly(userInfo.silver_num))
	-- layMain.TFD_BELLY:setText(userInfo.silver_num)

	layMain.TFD_INFORMATION_GOLD_NUM:setText(userInfo.gold_num)
	-- layMain.TFD_TREASURE_NUM:setText(userInfo.rime_num)
	layMain.TFD_TREASURE_NUM:setText(ItemUtil.getCacheItemNumBy(60029))

	UIHelper.labelAddNewStroke(layMain.TFD_LEVEL, self.m_i18nString(4366, userInfo.level), self.m_cStroke)

	self:setExpTFD(layMain.LOAD_EXP, layMain.TFD_EXP_NUM, layMain.TFD_EXP_NUM3)

end
