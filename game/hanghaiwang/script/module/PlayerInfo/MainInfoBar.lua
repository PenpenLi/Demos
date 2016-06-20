-- FileName: MainInfoBar.lua
-- Author: zhangqi
-- Date: 2015-04-14
-- Purpose: 主界面玩家信息面板UI
--[[TODO List]]

-- 模块局部变量 --
require "script/module/PlayerInfo/PlayerInfoBar"

MainInfoBar = class("MainInfoBar", PlayerInfoBar)

function MainInfoBar:destroy( ... )
	logger:debug("MainInfoBar:destroy")
end
function MainInfoBar:init( ... )
	self.tagAvatorNode = 111
	
	self.layMain = g_fnLoadUI("ui/home_information.json")

	local m_fnGetWidget = self.m_fnGetWidget
	local layMain = self.layMain

	-- 面板触摸事件，弹出详情面板
	local layInfo = m_fnGetWidget(layMain, "LAY_INFO")
	layInfo:setTouchEnabled(true)
	layInfo:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("zhujiemian_top.mp3")

			require "script/module/main/PlayerInfoView"
			local PlayerInfo = PlayerInfoView:new()
			local layPlayerInfo = PlayerInfo:create()
			if (layPlayerInfo) then
				LayerManager.addLayout(layPlayerInfo)
			end
		end
	end)

	-- 战斗力按钮
	local btnFight = m_fnGetWidget(layMain, "BTN_ZHANDOULI_ADD")
	btnFight:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			UserModel.recordUsrOperationByCondition("MainRaiseFightCtrl", 1) -- 打点记录  用户操作 2016-01-05
			AudioHelper.playBtnEffect("zhujiemian_top.mp3") -- zhangqi, 2015-12-28
			require "script/module/main/MainRaiseFightCtrl"
			MainRaiseFightCtrl.create()        
		end
	end)

	self:update()
end

function MainInfoBar:update( ... )
	local m_fnGetWidget = self.m_fnGetWidget
	local layMain = self.layMain

	local strokeColor = ccc3(0x2c, 0x00, 0x00)

	local userInfo = self:updateInfo()

	self:updateAvatarIcon() -- 刷新头像

	local labnLevel = m_fnGetWidget(layMain, "LABN_LVNUM") -- 等级
	labnLevel:setStringValue(userInfo.level)

	local labName = m_fnGetWidget(layMain, "TFD_NAME") -- 昵称
	labName:setText(userInfo.uname)
	labName:setColor(UserModel.getPotentialColor({bright = true})) -- zhangqi, 2015-07-28
	-- UIHelper.labelNewStroke(labName, strokeColor) -- 放开描边测试 -- 2016-3-11描边又注掉了

	local labnVip = m_fnGetWidget(layMain, "LABN_VIP_NUM") -- VIP
	labnVip:setStringValue(userInfo.vip)

	local loadExp = m_fnGetWidget(layMain, "LOAD_EXP") -- 经验进度条
	local labExp = m_fnGetWidget(layMain, "TFD_EXP_NUM") -- 经验数字
	self:setExpLabel(loadExp, labExp)

	local labBelly = m_fnGetWidget(layMain, "TFD_SILVER_NUM") -- 贝里
	labBelly:setText(UIHelper.getBellyStringAndUnit(userInfo.silver_num))
	UIHelper.labelNewStroke(labBelly, strokeColor)

	local labGold = m_fnGetWidget(layMain, "TFD_GOLD_NUM") -- 金币
	labGold:setText(userInfo.gold_num)
	UIHelper.labelNewStroke(labGold, strokeColor)

	local labPower = m_fnGetWidget(layMain, "TFD_POWER_NUM") -- 体力
	labPower:setText(userInfo.execution .. "/" .. self.m_nPowerMax)
	UIHelper.labelNewStroke(labPower, strokeColor)

	local labStamina = m_fnGetWidget(layMain, "TFD_STAMINA_NUM") -- 耐力
	labStamina:setText(userInfo.stamina .. "/" .. self.m_nStaminaMax)
	UIHelper.labelNewStroke(labStamina, strokeColor)

	local fightNum = UserModel.getFightForceValue()
	local labFightNum = m_fnGetWidget(layMain, "TFD_ZHANDOULI") -- 战斗力
	labFightNum:setText(fightNum)
	UIHelper.labelNewStroke(labFightNum, ccc3(0x19, 0x3b, 0x00))
end

function MainInfoBar:updateAvatarIcon( ... )
	require "db/DB_Heroes"
	require "script/model/utils/HeroUtil"
	local iconPath = HeroUtil.getHeroIconImgByHTID(UserModel.getAvatarHtid())
	local clipNode = HeroUtil.createCircleAvatar(iconPath)
	local imgAvatar = self.m_fnGetWidget(self.layMain, "IMG_PHOTO")
	if (clipNode) then
		imgAvatar:removeNodeByTag(self.tagAvatorNode)
		imgAvatar:addNode(clipNode, self.tagAvatorNode, self.tagAvatorNode)
	end
end
