-- FileName: WorldBossRewardPreview.lua
-- Author: zhangqi
-- Date: 2015-01-22
-- Purpose: 世界Boss奖励预览UI
--[[TODO List]]

-- module("WorldBossRewardPreview", package.seeall)

-- UI控件引用变量 --

-- 模块局部变量 --
local m_i18n = gi18n
local m_i18nString 	= gi18nString
local m_fnGetWidget = g_fnGetWidgetByName

WorldBossRewardPreview = class("WorldBossRewardPreview")

function WorldBossRewardPreview:ctor()
	self.layMain = g_fnLoadUI("ui/world_reward_preview.json")
end

function WorldBossRewardPreview:create(...)
	local layRoot = self.layMain
	layRoot.BTN_CLOSE:addTouchEventListener(UIHelper.onClose)			-- 关闭按钮
	layRoot.BTN_CONFIRM:addTouchEventListener(UIHelper.onClose)	-- 确定按钮
	UIHelper.titleShadow(layRoot.BTN_CONFIRM, gi18n[1992])

	local labTextTitle = m_fnGetWidget(layRoot, "TFD_BOSS_NAME") -- 文字标题
	local pboss = WorldBossModel.getActvieBossDb()
	local pName = pboss and pboss.name or ""
	labTextTitle:setText(pName)

	-- 列表 LSV_TOTAL
	local lsvList = layRoot.LSV_TOTAL
	-- 初始化listview
	UIHelper.initListView(lsvList)
	-- 开启裁切
	lsvList:setClippingEnabled(true)
	lsvList:removeAllItems() -- 清除列表
	
	local tbReward = WorldBossModel.getRewardPreview()
	if (not table.isEmpty(tbReward)) then
		local nIdx, cell = -1, nil
		
		for i, item in ipairs(tbReward) do
			lsvList:pushBackDefaultItem()
			nIdx = nIdx + 1
			cell = lsvList:getItem(nIdx)  -- cell 索引从 0 开始
			
			local labDesc = m_fnGetWidget(cell, "TFD_RANK") -- 奖励描述
			labDesc:setText(item.desc)

			local i18n_drop = m_fnGetWidget(cell, "tfd_perhaps")
			i18n_drop:setText(m_i18n[6036])

			local labDropName = m_fnGetWidget(cell, "TFD_PERHAPS_ITEM") -- 几率掉落物品名称，品质颜色
			
			if (item.chance_drop) then
				local itemDrop = ItemUtil.getItemById(item.chance_drop)
				labDropName:setText(itemDrop.name)
				labDropName:setColor(g_QulityColor[itemDrop.quality])
			else
				i18n_drop:setEnabled(false)
				labDropName:setEnabled(false)
			end

			-- 创建奖励物品的列表
			local lsvItem = m_fnGetWidget(cell, "LSV_REWARD")
			UIHelper.initListView(lsvItem)
			lsvItem:removeAllItems() -- 清除列表

			require "script/module/public/RewardUtil"
			-- local tbItems = RewardUtil.parseRewards(item.reward)
			local tbItems = RewardUtil.getItemsDataByStr(item.reward)
			-- 获取当前的奖励倍率
			local rate = OutputMultiplyUtil.getMultiplyRateNum(5)
			for k, good in pairs(tbItems) do
				good.num = math.floor(good.num * rate / 10000)
			end
			tbItems = RewardUtil.parseRewardsByTb(tbItems)
			if (not table.isEmpty(tbItems)) then
				local nIdx, cell = -1, nil

				for k, good in ipairs(tbItems) do
					lsvItem:pushBackDefaultItem()
					nIdx = nIdx + 1
					cell = lsvItem:getItem(nIdx)  -- cell 索引从 0 开始

					local imgGood = m_fnGetWidget(cell, "IMG_GOODS")
					imgGood:addChild(good.icon)

					local labName = m_fnGetWidget(cell, "TFD_GOODS_NAME")
					labName:setText(good.name)
					labName:setColor(g_QulityColor[good.quality])
				end
			end
		end -- end of for i, item in ipairs(tbReward) do
	end

	return self.layMain
end
