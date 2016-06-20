-- FileName: OnlineRewardView.lua
-- Author: menghao
-- Date: 2014-08-29
-- Purpose: 在线奖励view


module("OnlineRewardView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_btnGet
local m_lsv
local m_tfdTime
local m_tfdInfo
local m_tfdTitle
local m_btnClose


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName


local function init(...)

end


function destroy(...)
	package.loaded["OnlineRewardView"] = nil
end


function moduleName()
	return "OnlineRewardView"
end


function updateUI(bCanReceive, leftTime)
	if (not bCanReceive and m_btnGet:isTouchEnabled()) then
		m_btnGet:setGray(true)
		m_btnGet:setTouchEnabled(false)
	elseif (bCanReceive and not m_btnGet:isTouchEnabled()) then
		m_btnGet:setGray(false)
		m_btnGet:setTouchEnabled(true)
	end

	m_tfdTime:setEnabled(true)
	m_tfdTime:setText(TimeUtil.getTimeString(leftTime))
end


function upItems( tbReward, bCanReceive)
	m_lsv:removeAllItems()

	if (not bCanReceive) then
		m_btnGet:setGray(true)
		m_btnGet:setTouchEnabled(false)
	else
		m_btnGet:setGray(false)
		m_btnGet:setTouchEnabled(true)
	end

	for i=1,tbReward.reward_num do
		m_lsv:pushBackDefaultItem()
		local item = m_lsv:getItem(i - 1)

		local imgGoods = m_fnGetWidget(item, "IMG_GOODS")
		local tfdName = m_fnGetWidget(item, "TFD_GOODS_NAME")

		imgGoods:addChild(UIHelper.getItemIcon(tbReward["reward_type" .. i], tbReward["reward_values" .. i]))
		tfdName:setText(tbReward["reward_desc" .. i])
		tfdName:setColor(g_QulityColor[tbReward["reward_quality" .. i]])
	end
end


function create(onGet, bCanReceive, tbReward , nLeftTime)
	m_UIMain = g_fnLoadUI("ui/reward_online.json")

	m_btnGet = m_fnGetWidget(m_UIMain, "BTN_GET")
	m_lsv = m_fnGetWidget(m_UIMain, "LSV_REWARD")
	m_tfdTime = m_fnGetWidget(m_UIMain, "TFD_COUNT")
	m_tfdInfo = m_fnGetWidget(m_UIMain, "tfd_info")
	m_tfdTitle = m_fnGetWidget(m_UIMain, "TFD_TITLE")
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")

	UIHelper.titleShadow(m_btnGet, gi18n[2628])
	m_btnGet:addTouchEventListener(onGet)
	m_tfdTitle:setText(gi18n[1930])
	m_tfdInfo:setText(gi18n[1931])
	m_btnClose:addTouchEventListener(UIHelper.onClose)

	m_tfdTime:setText(TimeUtil.getTimeString(nLeftTime))

	local item = m_lsv:getItem(0)
	m_lsv:setItemModel(item)

	upItems(tbReward, bCanReceive)

	return m_UIMain
end

