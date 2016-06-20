-- FileName: SkyPieaRankRewardCell.lua
-- Author: huxiaozhou
-- Date: 2015-02-09
-- Purpose: 奖励预览界面cell
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
--         		佛祖保佑  需求不变  
--		   		不怕出bug  最恨改需求
-- ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-- /

require "script/module/public/class"
require "script/module/public/Cell/Cell"
SkyPieaRankRewardCell = class("SkyPieaRankRewardCell", Cell)

local m_fnGetWidget = g_fnGetWidgetByName

function SkyPieaRankRewardCell:ctor(layCell)
	self.cell = layCell
end


function SkyPieaRankRewardCell:init( tbData )
	local widget = self.cell
	if (widget) then
		self.mCell = widget:clone()
		self.mCell:setPosition(ccp(0,0))
		self.mCell:setEnabled(true)
	end
end

--[[
	@desc: 创建修改每个cell上的头像
    @param 	 iconData type: table -- 物品的结构表 包括icon
    @param 	 iconCell type: imageView 物品背景位置
—]]
function SkyPieaRankRewardCell:initRowView( iconData, iconCell )
	local imgGood = g_fnGetWidgetByName(iconCell,"IMG_GOODS") --物品背景
	imgGood:addChild(iconData.icon)
	local labName = g_fnGetWidgetByName(iconCell,"TFD_GOODS_NAME")
	UIHelper.labelEffect(labName, iconData.name)
	labName:setColor(g_QulityColor[tonumber(iconData.quality)])
end


function SkyPieaRankRewardCell:refresh( tbData )
	local cell = self.mCell
	local i18ntfd_kaifu = m_fnGetWidget(cell, "tfd_kaifu") -- 第
	local i18ntfd_tian = m_fnGetWidget(cell, "tfd_tian") -- 天
	local tfdTitle = m_fnGetWidget(cell, "TFD_CELL_TITLE")
	tfdTitle:setText(tbData.desc)
	-- 创建每行的ListView
	local colLayout = m_fnGetWidget(cell, "LAY_FORTBV")
	local colCellCopy = m_fnGetWidget(cell, "LAY_CLONE") 
	colCellCopy:setEnabled(true)
	local oneItemPercent = (colCellCopy:getSize().width) / colLayout:getSize().width
	local rowData = RewardUtil.parseRewards(tbData.items)

	colLayout:removeAllChildren()
	for j, colData in ipairs(rowData) do
		local colCell = colCellCopy:clone()
		colCell:setPositionPercent(ccp(oneItemPercent * (j - 1), 0))
		colLayout:addChild(colCell)
		self:initRowView(colData, colCell)
	end
	colCellCopy:setEnabled(false)
end
