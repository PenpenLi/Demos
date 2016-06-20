-- FileName: UseMoreView.lua
-- Author: zhangqi
-- Date: 2014-12-23
-- Purpose: 批量使用道具的UI
--[[TODO List]]

-- module("UseMoreView", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName
local m_gColor = g_QulityColor

local m_tbYaoshuiId = { -- zhangqi, 2016-01-12, 存放所有体力药水和耐力药水的配置表id，用于使用按钮音效的播放
10031,10032,10033,10034,10035, -- 体力药水对应的配置表物品id
10041,10042,10043,10044,10045, -- 耐力药水对应的配置表物品id
}

local m_tbKeyId = {30012, 30013} -- 白银、黄金钥匙的配置表物品id

local function isCoin( tid )
	local nTid = tonumber(tid)
	local be, ed = 10011, 10030 -- 贝里和金币的配置表物品id
	for i = be, ed do
		if (nTid == i) then
			return true
		end
	end
	return false
end

UseMoreItemView = class("UseMoreItemView")

function UseMoreItemView:ctor()
	self.layMain = g_fnLoadUI("ui/shop_buy_item.json")
	self.USE_MAX = 50 -- 一次可使用的最多数量
end

function UseMoreItemView:create(tbData)
	logger:debug("UseMoreItemView")
	logger:debug(tbData)
	
	local layRoot = self.layMain

	local imgTitle = m_fnGetWidget(layRoot, "img_title") -- 标题
	imgTitle:loadTexture("images/common/title_use_item.png")

	local labTotalText = m_fnGetWidget(layRoot, "TFD_PLAYER_OWN_NUM") -- 可用总数
	labTotalText:setText(m_i18nString(1530, tbData.totalNum))
	self.m_remainNum = tbData.totalNum

	local i18n_tip1 = m_fnGetWidget(layRoot, "tfd_please_choose")
	i18n_tip1:setText(m_i18n[1531])

	local labItemName = m_fnGetWidget(layRoot, "TFD_PLAYER_CHOOSE_BUY_NUM") -- 物品名称
	labItemName:setText(tbData.name)
	labItemName:setColor(m_gColor[tonumber(tbData.quality)])

	local i18n_tip2 = m_fnGetWidget(layRoot, "tfd_choose_num")
	i18n_tip2:setText(m_i18n[1424])

	self.labShowNum = m_fnGetWidget(layRoot, "TFD_PLAYER_BUY_NUM") -- 显示当前的预使用数量
	self.m_UseNum = 1
	self.labShowNum:setText(self.m_UseNum)
	self.m_remainNum = self.m_remainNum - self.m_UseNum -- 计算剩余可用数

	layRoot.lay_price_num:removeFromParentAndCleanup(true)
	layRoot.lay_price:removeFromParentAndCleanup(true)
	local i18n_tip3 = m_fnGetWidget(layRoot, "tfd_item_max_num")
	i18n_tip3:setText(m_i18nString(1532, self.USE_MAX))

	local btnClose = m_fnGetWidget(layRoot, "BTN_SHOP_BUY_ITEM_CLOSE")
	btnClose:addTouchEventListener(UIHelper.onClose)
	local btnCancel = m_fnGetWidget(layRoot, "BTN_SHOP_ITEM_BUY_CANCEL") -- 取消按钮
	UIHelper.titleShadow(btnCancel, m_i18n[1325])
	btnCancel:addTouchEventListener(UIHelper.onClose)

	local btnOk = m_fnGetWidget(layRoot, "BTN_SHOP_ITEM_BUY_SURE") -- 确定按钮
	UIHelper.titleShadow(btnOk, m_i18n[1324])
	btnOk:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			if (table.include(m_tbYaoshuiId, tbData.tid)) then
				AudioHelper.playBtnEffect("shiyong_yaoshui.mp3") -- 修改为使用药水音效
			elseif (isCoin(tbData.tid)) then
				AudioHelper.playBuyGoods() -- 使用贝里和金币的音效
			end

			LayerManager.removeLayout() -- 关闭批量使用对话框

			LayerManager.addUILoading() -- 添加触摸事件屏蔽
			tbData.useCallback(self:getUseNum())
		end
	end)

	local btnReduce = m_fnGetWidget(layRoot, "BTN_PLAYER_BUY_ADDITION") -- 递减按钮
	btnReduce:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (self.m_UseNum > 1) then
				self.m_UseNum = self.m_UseNum - 1
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum + 1
			end
		end
	end)

	local btnAdd = m_fnGetWidget(layRoot, "BTN_PLAYER_BUY_REDUCE") -- 递增按钮
	btnAdd:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (self.m_remainNum > 0 and self.m_UseNum < self.USE_MAX) then
				self.m_UseNum = self.m_UseNum + 1
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum - 1
			end
		end
	end)

	local btnRedcueTen = m_fnGetWidget(layRoot, "BTN_PLAYER_BUY_ADDITION_TEN") -- 递减10按钮
	btnRedcueTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()
			if (self.m_UseNum - 10 >= 1) then
				self.m_UseNum = self.m_UseNum - 10
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum + 10
			else
				local oldUse = self.m_UseNum
				self.m_UseNum = 1
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum + (oldUse - 1)
			end
		end
	end)

	local btnAddTen = m_fnGetWidget(layRoot, "BTN_PLAYER_BUY_REDUCE_TEN") -- 递增10按钮
	btnAddTen:addTouchEventListener(function ( sender, eventType )
		if (eventType == TOUCH_EVENT_ENDED) then
			AudioHelper.playCommonEffect()

			local addNum = self.m_remainNum
			if (self.m_remainNum >= 10) then
				addNum = 10
			end

			if (self.m_UseNum + addNum <= self.USE_MAX) then
				self.m_UseNum = self.m_UseNum + addNum
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum - addNum
			else
				if (self.m_UseNum == self.USE_MAX) then
					return
				end

				local oldUse = self.m_UseNum
				self.m_UseNum = self.USE_MAX
				self.labShowNum:setText(self.m_UseNum)
				self.m_remainNum = self.m_remainNum - (self.USE_MAX - oldUse)
			end
		end
	end)
	
	return self.layMain
end

function UseMoreItemView:getUseNum( ... )
	if (self.labShowNum) then
		local num = tonumber(self.labShowNum:getStringValue())
		return num
	end
end
