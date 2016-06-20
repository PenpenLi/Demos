-- FileName: ExplorMapInfoBarNew.lua
-- Author: 
-- Date: 2014-04-00
-- Purpose: function description of module
--[[TODO List]]

-- 模块局部变量 --
require "script/module/PlayerInfo/PlayerInfoBar"

ExplorMapInfoBarNew = class("ExplorMapInfoBarNew", PlayerInfoBar)

function ExplorMapInfoBarNew:destroy( ... )
	logger:debug("ExplorMapInfoBarNew:destroy")
end

function ExplorMapInfoBarNew:init( ... )
	self.layMain = g_fnLoadUI("ui/explore_map_info_new.json")

	self:update()
end

function ExplorMapInfoBarNew:update( ... )
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