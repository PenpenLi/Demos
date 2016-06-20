-- FileName: CafeRewardView.lua
-- Author: menghao
-- Date: 2014-09-15
-- Purpose: 联盟人鱼咖啡厅奖励预览view


module("CafeRewardView", package.seeall)


-- UI控件引用变量 --
local m_UIMain

local m_imgBG
local m_btnClose
local m_imgTitle

local m_lsvTotal


-- 模块局部变量 --
local m_fnGetWidget = g_fnGetWidgetByName

local mi18n = gi18n


local function init(...)

end


function destroy(...)
	package.loaded["CafeRewardView"] = nil
end


function moduleName()
	return "CafeRewardView"
end


function create( tbRewards )
	logger:debug(tbRewards)

	m_UIMain = g_fnLoadUI("ui/union_cafe_reward.json")

	m_imgBG = m_fnGetWidget(m_UIMain, "img_bg")
	m_btnClose = m_fnGetWidget(m_UIMain, "BTN_CLOSE")
	m_imgTitle = m_fnGetWidget(m_UIMain, "img_title")
	m_lsvTotal = m_fnGetWidget(m_UIMain, "LSV_TOTAL")

	m_btnClose:addTouchEventListener(UIHelper.onClose)

	local btnClose2 = m_fnGetWidget(m_UIMain, "BTN_CLOSE2")
	UIHelper.titleShadow(btnClose2, mi18n[2821])
	btnClose2:addTouchEventListener(UIHelper.onClose)

	local defaultCell = m_lsvTotal:getItem(0)
	m_lsvTotal:setItemModel(defaultCell)
	m_lsvTotal:removeAllItems()

	for i=1,#tbRewards do
		m_lsvTotal:pushBackDefaultItem()
		local itemCell = m_lsvTotal:getItem(i - 1)

		local i18n_origin = m_fnGetWidget(itemCell, "TFD_ORIGIN")
		i18n_origin:setText(mi18n[3743])
		local labCellTitle = m_fnGetWidget(itemCell, "TFD_CELL_TITLE")

		local i18n_reward_lv = m_fnGetWidget(itemCell, "tfd_jijiangli")
		i18n_reward_lv:setText(mi18n[3822])

		local tfdPower = m_fnGetWidget(itemCell, "tfd_power")
		local labPowerNum = m_fnGetWidget(itemCell, "TFD_POWER_NUM")
		local lsvReward = m_fnGetWidget(itemCell, "LSV_REWARD")

		if (i == 1) then
			labCellTitle:setEnabled(false)
			i18n_reward_lv:setEnabled(false)
		else
			i18n_origin:setEnabled(false)
			labCellTitle:setText(tbRewards[i].id)
		end
		tfdPower:setText(mi18n[1922])
		labPowerNum:setText("+" .. tbRewards[i].execution)

		local defaultRewardItem = lsvReward:getItem(0)
		lsvReward:setItemModel(defaultRewardItem)
		lsvReward:removeAllItems()

		local itemNum = 0

		if (tbRewards[i].stamina > 0) then
			itemNum = itemNum + 1
			lsvReward:pushBackDefaultItem()
			local item = lsvReward:getItem(itemNum - 1)

			imgGoods = m_fnGetWidget(item, "IMG_GOODS")
			tfdGoodsName = m_fnGetWidget(item, "TFD_GOODS_NAME")

			local icon = ItemUtil.getStaminaIconByNum(tbRewards[i].stamina)
			imgGoods:addChild(icon)
			tfdGoodsName:setText(mi18n[1923])
		end

		if (tbRewards[i].prestige > 0) then
			itemNum = itemNum + 1
			lsvReward:pushBackDefaultItem()
			local item = lsvReward:getItem(itemNum - 1)

			imgGoods = m_fnGetWidget(item, "IMG_GOODS")
			tfdGoodsName = m_fnGetWidget(item, "TFD_GOODS_NAME")

			local icon = ItemUtil.getPrestigeIconByNum(tbRewards[i].prestige)
			imgGoods:addChild(icon)
			tfdGoodsName:setText(mi18n[1921])
		end

		if (tbRewards[i].silver > 0) then
			itemNum = itemNum + 1
			lsvReward:pushBackDefaultItem()
			local item = lsvReward:getItem(itemNum - 1)

			imgGoods = m_fnGetWidget(item, "IMG_GOODS")
			tfdGoodsName = m_fnGetWidget(item, "TFD_GOODS_NAME")

			local icon = ItemUtil.getSiliverIconByNum(tbRewards[i].silver)
			imgGoods:addChild(icon)
			tfdGoodsName:setText(mi18n[1520])
		end

		if (tbRewards[i].gold > 0) then
			itemNum = itemNum + 1
			lsvReward:pushBackDefaultItem()
			local item = lsvReward:getItem(itemNum - 1)

			imgGoods = m_fnGetWidget(item, "IMG_GOODS")
			tfdGoodsName = m_fnGetWidget(item, "TFD_GOODS_NAME")

			local icon = ItemUtil.getGoldIconByNum(tbRewards[i].gold)
			imgGoods:addChild(icon)
			tfdGoodsName:setText(mi18n[2220])
		end
	end

	return m_UIMain
end


function adjustLsv( tbRewards )
	local level = GuildDataModel.getGuanyuTempleLevel()
	local height = m_lsvTotal:getItemsMargin() + m_lsvTotal:getItem(0):getSize().height
	local lsvHeight = m_lsvTotal:getSize().height
	performWithDelay(m_UIMain, function ( ... )
		m_lsvTotal:setContentOffset(ccp(0, level * height + lsvHeight - m_lsvTotal:getInnerContainerSize().height))
	end, 0.001)
end

