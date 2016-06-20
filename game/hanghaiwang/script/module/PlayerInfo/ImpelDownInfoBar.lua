-- FileName: ImpelDownInfoBar.lua
-- Author: Xufei
-- Date: 2015-09-09
-- Purpose: 深海监狱模块玩家信息条UI
--[[TODO List]]

-- 模块局部变量 --
local _i18n = gi18n

require "script/module/PlayerInfo/PlayerInfoBar"

ImpelDownInfoBar = class("ImpelDownInfoBar", PlayerInfoBar)

function ImpelDownInfoBar:destroy( ... )
	logger:debug("ImpelDownInfoBar:destroy")
end

function ImpelDownInfoBar:init( ... )
	self.layMain = g_fnLoadUI("ui/impel_down_info.json")

	self:update()
end

function ImpelDownInfoBar:update( ... )
	local layMain = self.layMain

	local userInfo = self:updateInfo()

	UIHelper.labelNewStroke( layMain.tfd_prison_txt, ccc3(0x28,0x00,0x00), 2 )

	layMain.tfd_prison_txt:setText(_i18n[7032])

	layMain.TFD_ZHANDOULI_NUM:setText(self:updateFightNum())

	layMain.TFD_SILVER_NUM:setText(self:unitBelly(userInfo.silver_num))

	layMain.TFD_GOLD_NUM:setText(userInfo.gold_num)

	layMain.TFD_PRISON_NUM:setText(UserModel.getImpelDownNum())

end
