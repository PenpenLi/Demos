-- FileName: ShipRebornView.lua
-- Author: Xufei
-- Date: 2015-10-22
-- Purpose: 主船重生 视图
--[[TODO List]]

ShipRebornView = class("ShipRebornView")

-- UI控件引用变量 --
local _layMain = nil
local m_fnGetWidget = g_fnGetWidgetByName
local SHIP_IMAGE_PATH = "images/ship/"
-- 模块局部变量 --

-- 显示奖励图标
function ShipRebornView:showRewards( ... )
	local numBelly, strReward = ShipRebornModel.getStrengthenCost()
	local listView = _layMain.LSV_REWARD_BIG
	UIHelper.initListView(listView)
	require "script/module/public/RewardUtil"
	local tbReward = RewardUtil.parseRewards(strReward)
	-- 每一行奖励cell
	local cell
	local cellIndex = 0
	-- 在每一行中图标的序号
	local indexInOneCell = 1
	-- 循环所有奖励
	for i=1,#tbReward do
		-- 计算在每一行中的序号
		indexInOneCell = i%4
		if (indexInOneCell == 0) then
			indexInOneCell = 4
		end
		-- 每次遇到序号为1，则新起一行
		if (indexInOneCell == 1) then
			listView:pushBackDefaultItem()
			cell = listView:getItem(cellIndex)
			cellIndex = cellIndex + 1
		end
		local itemInfo = tbReward[i]
		local layItem = m_fnGetWidget(cell,"lay_reward_bg" .. indexInOneCell)
		layItem.TFD_NAME:setText(itemInfo.name)
		layItem.TFD_NAME:setColor(g_QulityColor[tonumber(itemInfo.quality)])
		itemInfo.icon:setPosition(ccp(layItem.lay_icon:getSize().width / 2,layItem.lay_icon:getSize().height / 2))
		layItem.lay_icon:addChild(itemInfo.icon)
	end
	-- 将最后一行中没有用到的图标隐藏
	if (indexInOneCell ~= 4) then
		cell = listView:getItem(cellIndex-1)
		for i = indexInOneCell + 1, 4 do
			local layItem = m_fnGetWidget(cell,"lay_reward_bg" .. i)
			layItem:setEnabled(false)
		end
	end
end

function ShipRebornView:ctor(...)
	self.layMain = g_fnLoadUI("ui/decompose_preview.json")
end

function ShipRebornView:destroy(...)
	package.loaded["ShipRebornView"] = nil
end

function ShipRebornView:moduleName()
    return "ShipRebornView"
end

function ShipRebornView:create(...)
	_layMain = self.layMain
	_layMain.img_title:loadTexture(SHIP_IMAGE_PATH.."ship_reborn/title_reborn_preview.png")
	_layMain.BTN_CLOSE:addTouchEventListener(ShipRebornCtrl.btnEventClose)
	_layMain.BTN_NO:addTouchEventListener(ShipRebornCtrl.btnEventClose)
	_layMain.BTN_YES:addTouchEventListener(ShipRebornCtrl.btnEventOk)
	_layMain.TFD_PROMPT:setVisible(false)
	self:showRewards()
	return _layMain
end
