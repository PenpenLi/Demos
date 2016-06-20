-- FileName: LevelRewardItem.lua
-- Author: menghao
-- Date: 2014-05-27
-- Purpose: 奖励物品cell


LevelRewardItem = class("LevelRewardItem")


require "script/module/public/PublicInfoCtrl"


function LevelRewardItem:ctor(...)
	self.tbMaskRect = {}
	self.tbBtnEvent = {}
end


function LevelRewardItem:clearAndRefresh( tbData )
	self:refresh(tbData)
end


function LevelRewardItem:init( tbData, cellCopy )
	if (cellCopy) then
		self.mlaycell = cellCopy -- cellCopy:clone()
	end
end



function LevelRewardItem:addMaskButton(btn, sName)
	if ( not self.tbMaskRect[sName]) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		-- 坐标和size都乘以满足屏宽的缩放比率

		self.tbMaskRect[sName] = fnRectAnchorCenter(x, y, size)
		self.tbBtnEvent[sName] = {sender = btn, event = self.eventIcon}
	end
end


-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function LevelRewardItem:touchMask(point)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end

	for name, rect in pairs(self.tbMaskRect) do
		if (rect:containsPoint(point)) then
			return self.tbBtnEvent[name]
		end
	end
end


function LevelRewardItem:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end


-- 通过奖励类型判断物品 1、贝里,2、将魂,3、金币,4、体力,5、耐力,6、物品,7、多个物品,8、等级*贝里,9、等级*将魂
-- 获取物品的Icon
function LevelRewardItem:getItemIcon(reward_type, reward_values)
	reward_type = tonumber(reward_type)
	local itemIcon
	if(reward_type == 1) then
		itemIcon = ItemUtil.getSiliverIconByNum(reward_values)
	elseif(reward_type == 2) then
		itemIcon = ItemUtil.getSoulIconByNum(reward_values)
	elseif(reward_type == 3) then
		itemIcon = ItemUtil.getGoldIconByNum(reward_values)

	elseif(reward_type == 10) then
		itemIcon = HeroUtil.createHeroIconBtnByHtid(reward_values)
		self.eventIcon = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createHeroInfoView(reward_values)
			end
		end
	else
		local tid = (string.split(reward_values, "|"))[1]
		local num = (string.split(reward_values, "|"))[2]
		itemIcon = ItemUtil.createBtnByTemplateIdAndNumber(tid, num)
		self.eventIcon = function ( sender, eventType )
			if (eventType == TOUCH_EVENT_ENDED) then
				PublicInfoCtrl.createItemInfoViewByTid(tid, num)
			end
		end
	end

	return itemIcon
end



function LevelRewardItem:refresh(tbData)
	if (self.mlaycell) then
		local button = self:getItemIcon(tbData.icon.reward_type, tbData.icon.reward_values)
		self:addMaskButton(button, tbData.name)

		local IMG_GOODS = g_fnGetWidgetByName(self.mlaycell,"IMG_GOODS") --物品背景
		IMG_GOODS:addChild(button)
		local TFD_GOODS_NAME = g_fnGetWidgetByName(self.mlaycell,"TFD_GOODS_NAME")
		UIHelper.labelEffect(TFD_GOODS_NAME, tbData.name)
	end
end

