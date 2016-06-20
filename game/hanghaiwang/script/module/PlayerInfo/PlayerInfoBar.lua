-- FileName: PlayerInfoBar.lua
-- Author: zhangqi
-- Date: 2015-04-14
-- Purpose: 各种信息条的基类
--[[TODO List]]

local currentBar = nil -- 保存当前信息条对象的引用
local infoBarStack = {}  --liweidong 非主信息条集合
function pushInfoBarStack(bar)
	table.insert(infoBarStack,bar)
end
function popInfoBarStack()
	table.remove(infoBarStack)
end

-- 调用当前信息条对象的update方法刷新UI显示，主要用于 UserModel 里
function updateInfoBar( ... )
	local updateArg =  { ... } 
	if (currentBar) then
		currentBar:update(updateArg[1])
	end
	for _,v in pairs(infoBarStack) do
		v:update(updateArg[1])
	end
	if (LayerManager.curModuleName()=="MainCopy") then --liweidong 这里是为了进入游戏后不必要的require 所以module名字直接用字符串
		require "script/module/copy/itemCopy"
		itemCopy.updateInfoBar()
	end
	if (LayerManager.curModuleName()=="GuildCopyMapView") then --liweidong 这里是为了进入游戏后不必要的require 所以module名字直接用字符串
		require "script/module/guildCopy/GCItemView"
		GCItemView.updateInfoBar()
	end
	copyAwakeBaseView.updateInfoBar()
end

-- zhangqi, 2015-10-08, 删除信息条的全局方法，PlayerPanel模块调用
function removeInfoBar( ... )
	if (currentBar) then
		currentBar:remove()
	end
end

-- ***************************  信息条基类  ***************************

PlayerInfoBar = class("PlayerInfoBar")

function PlayerInfoBar:ctor( ... )
	self.m_nPowerMax = g_maxEnergyNum -- 体力值上限
	self.m_nStaminaMax = UserModel.getMaxStaminaNumber() -- 耐力上限

	self.m_i18n = gi18n
	self.m_i18nString = gi18nString
	self.m_fnGetWidget = g_fnGetWidgetByName

	self.m_cStrok = ccc3(0x28, 0x00, 0x00)
end

function PlayerInfoBar:updateInfo()
	self.m_tbUserInfo = UserModel.getUserInfo()
	return self.m_tbUserInfo
end

function PlayerInfoBar:updateFightNum( ... )
	local updataInfo = { ... }
	-- UserModel.updateFightValue(updataInfo[1]) -- 刷新战斗力
	return UserModel.getFightForceValue()
end

function PlayerInfoBar:create( ... )
	self:init()

	currentBar = self
	local function onExit()
		currentBar = nil
		self:destroy()
		PlayerPanel.resetInfobar()
	end
	UIHelper.registExitAndEnterCall(tolua.cast(self.layMain, "CCNode"), onExit)

	-- return self.layMain
	-- 将topbar添加到module上
--	layRoot = LayerManager.getRootLayout()
	layRoot = LayerManager.getModuleRootLayout()
	layRoot:addChild(self.layMain, 2, 2)
end

-- zhangqi, 2015-10-08, 移除信息条UI节点
function PlayerInfoBar:remove( ... )
	if (self.layMain) then
		self.layMain:removeFromParentAndCleanup(true)
	end
end

function PlayerInfoBar:setExp( loadExp, labnMem, labnDomi, isLab )
	local imgMax = self.m_fnGetWidget(self.layMain, "IMG_MAX")
	if (UserModel.hasReachedMaxLevel()) then -- 经验达到满级
		labnMem:setEnabled(false)
		labnDomi:setEnabled(false)
		loadExp:setPercent(100)
		imgMax:setEnabled(true)
		return
	else
		imgMax:setEnabled(false)
	end

	local nExpNum, nLevelUpExp = UserModel.getExpAndNextExp()

	if (isLab) then -- 是 Label
		labnMem:setText(nExpNum)
		labnDomi:setText(nLevelUpExp)
	else
		labnMem:setStringValue(nExpNum)
		labnDomi:setStringValue(nLevelUpExp)
	end

	local nPercent = intPercent(nExpNum, nLevelUpExp)
	loadExp:setPercent((nPercent > 100) and 100 or nPercent)
end

function PlayerInfoBar:setExpLabel( loadExp, labExp )
	if (labExp and loadExp) then
		local imgMax = self.m_fnGetWidget(self.layMain, "IMG_MAX")
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
		UIHelper.labelNewStroke(labExp)

		local nPercent = intPercent(nExpNum, nLevelUpExp)
		loadExp:setPercent((nPercent > 100) and 100 or nPercent)
	end
end

function PlayerInfoBar:setExpTFD( loadExp, labMem, labDomi )
	self:setExp(loadExp, labMem, labDomi, true)
end

function PlayerInfoBar:unitBelly( belly )
	return UIHelper.getBellyStringAndUnit(belly)
end

-- *************************** 必须实现方法 ***************************

function PlayerInfoBar:destroy( ... )
	logger:debug("PlayerInfoBar:destroy")
end

-- 其他子类需要保留Init
function PlayerInfoBar:init( ... )

end

function PlayerInfoBar:update( ... )

end
