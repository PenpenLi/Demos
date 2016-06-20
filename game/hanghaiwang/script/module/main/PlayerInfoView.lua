-- FileName: PlayerInfoView.lua
-- Author: zhangqi
-- Date: 2014-12-25
-- Purpose: 角色信息详情的UI, 从PlayerPanel模块中单独分离出来
--[[TODO List]]

-- module("PlayerInfoView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local _tagAvatorNode = 111 -- 头像遮罩节点的tag
local dirScheduler = CCDirector:sharedDirector():getScheduler()


PlayerInfoView = class("PlayerInfoView")

function PlayerInfoView:ctor(fnCloseCallback)
	self.layMain = g_fnLoadUI("ui/home_info_frame.json")
	self.m_strInitTime = "00:00:00" -- 默认时间串
	self.m_nPowerSchedule = 0 -- 体力恢复定时器id
	self.m_nStaminaSchedule = 0 -- 耐力恢复定时器id
	self.onClose = fnCloseCallback
end

function PlayerInfoView:stopSchedulerById( nSid )
	if (nSid ~= 0) then
		dirScheduler:unscheduleScriptEntry(nSid)
	end
end

function PlayerInfoView:create( ... )
	self.tbUserInfo = UserModel.getUserInfo()
	local tbUserInfo = self.tbUserInfo

	local layRoot = self.layMain

	-- 给关闭和确定按钮添加事件
	local function addEventToBtn( strBtnName )
		local btnClose = m_fnGetWidget(layRoot, strBtnName)
		if (btnClose) then
			btnClose:addTouchEventListener(function ( sender, eventType )
				if (eventType == TOUCH_EVENT_ENDED) then
					if (strBtnName == "BTN_CLOSE") then
						AudioHelper.playCloseEffect()
					else
						AudioHelper.playCommonEffect()
					end

					self:stopSchedulerById(self.m_nPowerSchedule)
					self:stopSchedulerById(self.m_nStaminaSchedule)
					LayerManager.removeLayout()
				end
			end)
		end
	end
	addEventToBtn("BTN_CLOSE")
	addEventToBtn("BTN_CONFIRM")
	local btnOk = m_fnGetWidget(layRoot, "BTN_CONFIRM")
	UIHelper.titleShadow(btnOk, m_i18n[1029])

	-- 更名按钮事件
	local btnChgName = m_fnGetWidget(layRoot, "BTN_CHANGE_NAME")
	if (btnChgName) then
		btnChgName:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()

				local fnUpdateName = function ( ... )
					return self:updateName()
				end
				require "script/module/main/ChangeNameView"
				local ChangeName = ChangeNameView:new(fnUpdateName)
				ChangeName:create()
			end
		end)
	end

	local function eventChangeAvatar( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			local tbArgs = {}
			tbArgs.updateCallback = function ( ... )
				self:updateHeader() -- 更换头像后的回调刷新详情面板上的头像
			end
			require "script/module/main/MainChangeAvatar"
			MainChangeAvatar.create(tbArgs)
		end
	end

	-- 玩家头像和更换头像按钮
	local btnChange = m_fnGetWidget(layRoot, "BTN_CHANGE_PHOTO")
	UIHelper.titleShadow(btnChange, m_i18n[3222])
	btnChange:addTouchEventListener(eventChangeAvatar)

	-- 玩家头像
	self.m_imgHeader = m_fnGetWidget(layRoot, "IMG_HEAD_FRAME")
	self:loadHeader(self.m_imgHeader)
	local btnPhoto = m_fnGetWidget(layRoot, "BTN_PHOTO_FRAME")
	btnPhoto:addTouchEventListener(eventChangeAvatar)

	-- vip 等级
	local labnVip = m_fnGetWidget(layRoot, "LABN_VIP")
	labnVip:setStringValue(tbUserInfo.vip)

	-- 角色名称
	self.labName = m_fnGetWidget(layRoot, "TFD_NAME")
	self.labName:setText(tbUserInfo.uname)
	self:setNameStyle()

	-- 战斗力
	local labnFight = m_fnGetWidget(layRoot, "LABN_ZHANDOULI")
	labnFight:setStringValue(tostring(UserModel.getFightForceValue()))

	-- 提升战斗力按钮
	local btnFight = m_fnGetWidget(layRoot, "BTN_FIGHT_FORCE")
	btnFight:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playBtnEffect("zhujiemian_top.mp3") -- zhangqi, 2015-12-25
			require "script/module/main/MainRaiseFightCtrl"
			MainRaiseFightCtrl.create()
		end
	end)

	-- 角色等级
	local labnLevel = m_fnGetWidget(layRoot, "LABN_LVNUM")
	labnLevel:setStringValue(tbUserInfo.level)

	-- 经验条
	local barExp = m_fnGetWidget(layRoot, "LOAD_EXP")
	local labExp = m_fnGetWidget(layRoot, "TFD_EXP_NUM")
	self:setExpLabel(barExp, labExp)

	-- 上阵伙伴
	local i18nHero = m_fnGetWidget(layRoot, "tfd_partner")
	i18nHero:setText(m_i18n[3201])

	local labPartner = m_fnGetWidget(layRoot, "TFD_PARTNER_NUM")
	require "script/module/formation/FormationUtil"
	local hero, allHeros = FormationUtil.getOnFormationAndLimited()
	labPartner:setText(hero .. "/" .. allHeros)

	-- 金币
	local i18nGold = m_fnGetWidget(layRoot, "tfd_gold")
	i18nGold:setText(m_i18n[5438])
	self.labGold = m_fnGetWidget(layRoot, "TFD_GOLD_NUM")
	self.labGold:setText(tbUserInfo.gold_num)

	-- 贝里
	local i18nSilver = m_fnGetWidget(layRoot, "tfd_money")
	i18nSilver:setText(m_i18n[1521])
	local labSilver = m_fnGetWidget(layRoot, "TFD_MONEY_NUM")
	labSilver:setText(UserModel.getSilverNumber() or 0)

	-- 海魂
	local i18nHunyu = m_fnGetWidget(layRoot, "tfd_hunyu")
	i18nHunyu:setText(m_i18n[2061])
	local labJewel = m_fnGetWidget(layRoot, "TFD_HUNYU_NUM")
	labJewel:setText(UserModel.getJewelNum() or 0)

	-- 体力
	layRoot.tfd_power:setText(m_i18n[1304]) -- 2015-08-13
	self.labDescPowNum = m_fnGetWidget(layRoot, "TFD_POWER_NUM")
	-- 体力恢复时间
	local i18nPower = m_fnGetWidget(layRoot, "tfd_power_recover")
	i18nPower:setText(m_i18n[3203])
	self.labDescPowTime = m_fnGetWidget(layRoot, "TFD_POWER_RECOVER_NUM")
	-- 体力全部回满
	local i18nPowerFull = m_fnGetWidget(layRoot, "tfd_power_recover1")
	i18nPowerFull:setText(m_i18n[3204])
	self.labDescPowFull = m_fnGetWidget(layRoot, "TFD_POWER_RECOVER1_NUM")
	local fnUpdatePower = self:updateTimeFunc(true)
	if (not fnUpdatePower()) then
		self.m_nPowerSchedule = dirScheduler:scheduleScriptFunc(fnUpdatePower, 1, false)
	end

	-- 耐力
	layRoot.tfd_stamina:setText(m_i18n[1359])
	self.labDescStamNum = m_fnGetWidget(layRoot, "TFD_STAMINA_NUM")
	-- 耐力恢复时间
	local i18nStamina = m_fnGetWidget(layRoot, "tfd_stamina_recover")
	i18nStamina:setText(m_i18n[3205])
	self.labDescStamTime = m_fnGetWidget(layRoot, "TFD_STAMINA_RECOVER_NUM")
	-- 耐力全部回满
	local i18nStaminaFull = m_fnGetWidget(layRoot, "tfd_stamina_recover1")
	i18nStaminaFull:setText(m_i18n[3206])
	self.labDescStamFull = m_fnGetWidget(layRoot, "TFD_STAMINA_RECOVER1_NUM")
	local fnUpdateStamia = self:updateTimeFunc(false)
	if (not fnUpdateStamia()) then
		self.m_nStaminaSchedule = dirScheduler:scheduleScriptFunc(fnUpdateStamia, 1, false)
	end
	-- zhangqi, 2014-12-23, 优化需求：如果探索功能未开启则隐藏耐力显示
	local layStamina = m_fnGetWidget(layRoot, "LAY_STAMINA")
	layStamina:setEnabled(SwitchModel.getSwitchOpenState(ksSwitchExplore))

	-- + 号按钮，各种金币，贝里获取方式的引导
	-- BTN_GET_GOLD, BTN_GET_BELLY, BTN_GET_SOUL, BTN_GET_POWER, BTN_GET_STAMINA, 
	local plusBtns = { 	{name = "BTN_GET_GOLD", call = function ( ... )
							LayerManager.removeLayout()
							require "script/module/IAP/IAPCtrl"
							LayerManager.addLayout(IAPCtrl.create())
						end},

						{name = "BTN_GET_BELLY", call = function ( ... )
							if(not SwitchModel.getSwitchOpenState(ksSwitchBuyBox,true)) then
								return
							end
							require "script/module/wonderfulActivity/MainWonderfulActCtrl"
							local buyUI = MainWonderfulActCtrl.create(WonderfulActModel.tbShowType.kShowBuyMoney)
							LayerManager.changeModule(buyUI, MainWonderfulActCtrl.moduleName(), {1, 3}, true)
						end},

						{name = "BTN_GET_SOUL", call = function ( ... )

							if (SwitchModel.getSwitchOpenState( ksSwitchResolve,true)) then
								require "script/module/resolve/MainRecoveryCtrl"
								local layResolve = MainRecoveryCtrl.create()
								if (layResolve) then
									LayerManager.changeModule(layResolve, MainRecoveryCtrl.moduleName(), {1,3}, true)
									PlayerPanel.addForPublic()
								end
							end
						end},

						{name = "BTN_GET_POWER", call = function ( ... )
							if (not SwitchModel.getSwitchOpenState( ksSwitchBuyBox, true)) then
								return
							end
							
							require "script/module/copy/copyUsePills"
							local dlg = copyUsePills.create()
							copyUsePills.setUpdateCallback(function ( ... )
								self:updateValueFunc(true)
							end, function ( ... )
								self:updateGold()
							end)
							LayerManager.addLayout(dlg)
							copyUsePills.showLackTips(false) -- 隐藏不足提示
						end},

						{name = "BTN_GET_STAMINA", call = function ( ... )
							require "script/module/arena/ArenaBuyCtrl"
							local dlg = ArenaBuyCtrl.createForArena()
							ArenaBuyCtrl.setUpdateCallback(function ( ... )
								self:updateValueFunc(false)
							end, function ( ... )
								self:updateGold()
							end)
							LayerManager.addLayoutNoScale(dlg)
							require "script/module/arena/ArenaBuyView"
							ArenaBuyView.showLackTips(false) -- 隐藏不足提示
						end} 
					  }

	for i, btnItem in ipairs(plusBtns) do
		local btn = m_fnGetWidget(layRoot, btnItem.name)
		btn:addTouchEventListener(function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				AudioHelper.playCommonEffect()
				btnItem.call()
			end
		end)
	end

	-- 关闭UI后执行创建者指定的回调
	UIHelper.registExitAndEnterCall(tolua.cast(layRoot, "CCNode"), function ( ... )
		-- 关闭定时器
		self:stopSchedulerById(self.m_nPowerSchedule)
		self:stopSchedulerById(self.m_nStaminaSchedule)

		if (self.onClose) then
			self.onClose()
		end
	end)

	return layRoot
end

function PlayerInfoView:updateName( ... )
	if (self.labName) then
		self.labName:setText(UserModel.getUserName())
	end
	if (package.loaded["PlayerPanel"]) then
		updateInfoBar() -- 新信息条统一更新方法
	end
end

function PlayerInfoView:setNameStyle( ... )
	if (self.labName) then
		self.labName:setColor(UserModel.getPotentialColor({bright = true})) -- zhangqi, 2015-07-28
		-- UIHelper.labelNewStroke(self.labName, ccc3(0x36, 0x01, 0x63)) -- 2016-3-11描边又注掉了
	end
end

function PlayerInfoView:updateGold( ... )
	if (self.labGold) then
		self.labGold:setText(UserModel.getGoldNumber())
	end
end

function PlayerInfoView:updateValueFunc( bExec )
	local nCurVal = bExec and tonumber(self.tbUserInfo.execution) or tonumber(self.tbUserInfo.stamina)
	local nMax = bExec and g_maxEnergyNum or UserModel.getMaxStaminaNumber()
	local labNum = bExec and self.labDescPowNum or self.labDescStamNum
	labNum:setText((nCurVal or 0) .. "/" .. nMax) -- 设置比值
end

--[[desc: 返回刷新体力或耐力恢复时间的函数
    bExec: true, 刷新体力；false, 刷新耐力
    return: 一个function  
—]]
function PlayerInfoView:updateTimeFunc( bExec )
	return function ( ... )
		local nNow = TimeUtil.getSvrTimeByOffset() -- 当前服务器时间戳

		local nCurVal = bExec and tonumber(self.tbUserInfo.execution) or tonumber(self.tbUserInfo.stamina)
		logger:debug("PlayerInfoView-updateTimeFunc-nCurVal = " .. nCurVal)
		local nLastTime = bExec and self.tbUserInfo.execution_time or self.tbUserInfo.stamina_time -- 服务器端上次恢复的时间
		local nSPP = bExec and g_energyTime or g_stainTime -- 恢复 1 点的秒数, seconds per point
		local nMax = bExec and g_maxEnergyNum or UserModel.getMaxStaminaNumber()
		local nFullRemain = (nMax - nCurVal) * nSPP -- 恢复满的剩余时间

		local labTime = bExec and self.labDescPowTime or self.labDescStamTime
		local labFull = bExec and self.labDescPowFull or self.labDescStamFull
		local labNum = bExec and self.labDescPowNum or self.labDescStamNum

		local function stopPower( ... )
			self:stopSchedulerById(self.m_nPowerSchedule)
		end
		local function stopStamina( ... )
			self:stopSchedulerById(self.m_nStaminaSchedule)
		end
		local fnStop = bExec and stopPower or stopStamina

		local strFullRemain, bExpire = TimeUtil.expireTimeString(nLastTime, nFullRemain)
		labFull:setText(strFullRemain) -- 设置恢复满时间
		labNum:setText((nCurVal or 0) .. "/" .. nMax) -- 设置比值

		local function updateValue( ... )
			local passTime = nNow - nLastTime
			local addVal = math.floor(passTime/nSPP)
			logger:debug("PlayerInfoView:updateTimeFunc:updateValue: nCurVal = " .. nCurVal .. " addVal = " .. addVal)
			if (nCurVal < nMax) then
				labNum:setText((nCurVal or 0) + addVal .. "/" .. nMax) -- 设置比值
			end
		end
		updateValue()

		if (bExpire) then -- 到期取消定时器
			labTime:setText(self.m_strInitTime)
			fnStop()
			return bExpire
		else
			local nLeftTime = (nNow - nLastTime)%nSPP
			local strTime = TimeUtil.expireTimeString(nSPP - nLeftTime + nNow)
			labTime:setText(strTime)
		end

		return bExpire
	end
end

function PlayerInfoView:setExpLabel( loadExp, labExp )
	if (labExp and loadExp) then
		local imgMax = m_fnGetWidget(self.layMain,"IMG_MAX")
		if (UserModel.hasReachedMaxLevel()) then -- 经验达到满级
			labExp:setEnabled(false)
			loadExp:setPercent(100)
			imgMax:setEnabled(true)
			return
		else
			imgMax:setEnabled(false)
		end

		local nExpNum, nLevelUpExp = UserModel.getExpAndNextExp()
		labExp:setText(nExpNum .. "/" .. nLevelUpExp)
		UIHelper.labelNewStroke(labExp, ccc3(0x8e, 0x46, 0x00))

		local nPercent = intPercent(nExpNum, nLevelUpExp)
		loadExp:setPercent((nPercent > 100) and 100 or nPercent)
	end
end

function PlayerInfoView:loadHeader( imgWidget )
	if (imgWidget) then
		require "db/DB_Heroes"
		require "script/model/utils/HeroUtil"
		local iconPath = HeroUtil.getHeroIconImgByHTID(UserModel.getAvatarHtid())
		local clipNode = HeroUtil.createCircleAvatar(iconPath, 1) -- 2015-08-31，从 1.19倍大小改为1倍
		if (clipNode) then
			imgWidget:removeNodeByTag(_tagAvatorNode)
			imgWidget:addNode(clipNode, _tagAvatorNode, _tagAvatorNode)
		end
	end
end

function PlayerInfoView:updateHeader( ... )
	self:loadHeader(self.m_imgHeader)
	self:setNameStyle()
end
