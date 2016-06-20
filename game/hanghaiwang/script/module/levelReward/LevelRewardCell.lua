-- FileName: LevelRewardCell.lua
-- Author: menghao
-- Date: 2014-06-13
-- Purpose: 等级奖励cell


require "script/module/public/class"
require "script/module/levelReward/LevelRewardItem"


-- 局部变量
local m_fnGetWidget = g_fnGetWidgetByName

-- 类
LevelRewardCell = class("LevelRewardCell")


LevelRewardCell.tbSubListView = {}
LevelRewardCell.iconCell = nil -- 缓存每行cell上的tableView的icon的对象，关闭主UI时会调一次release释放


function LevelRewardCell:ctor(...)
	self.tbMaskRect = {}
	self.tbBtnEvent = {}
end


function LevelRewardCell:init( tbData, cellCopy, fnEventGet )
	if (cellCopy) then
		self.mlaycell = cellCopy:clone()
		self.mlaycell:setPosition(ccp(0, 0))
		self.image = m_fnGetWidget(self.mlaycell, "IMG_RECIEVED")
		self.button = m_fnGetWidget(self.mlaycell,"BTN_GET_REWARD")
		self.eventGet = fnEventGet

		local iconCell = m_fnGetWidget(self.mlaycell, "LAY_CLONE")
		if (not LevelRewardCell.iconCell) then
			LevelRewardCell.iconCell = iconCell:clone()
			LevelRewardCell.iconCell:retain() -- 关闭主UI时会调一次release释放
		end
		self.szIcon = LevelRewardCell.iconCell:getSize()
		iconCell:removeFromParentAndCleanup(true)

		self.layRow = m_fnGetWidget(self.mlaycell,"LAY_FORTBV") -- 一行的layout
	end
end

function LevelRewardCell:addMaskButton(btn, sName)
	if ( not self.tbMaskRect[sName] ) then
		local x, y = btn:getPosition()
		local size = btn:getSize()
		-- 坐标和size都乘以满足屏宽的缩放比率
		local szParent = tolua.cast(btn:getParent(), "Widget"):getSize()
		local xx, yy = szParent.width/2 + x, szParent.height/2

		self.tbMaskRect[sName] = fnRectAnchorCenter(xx, yy, size)
		self.tbBtnEvent[sName] = {sender = btn, event = self.eventGet}
	end
end

-- 删除需要屏蔽的按钮信息，
-- 用于避免类似影子cell上点击了招募按钮隐藏后，但点击该区域仍然会激发招募的按钮事件的问题
function LevelRewardCell:removeMaskButton( sName )
	if (self.tbMaskRect[sName]) then
		self.tbMaskRect[sName] = nil
		self.tbBtnEvent[sName] = nil
	end
end


-- 如果point在所有检测范围内，则是点在按钮上，返回true，用以屏蔽CellTouch事件
function LevelRewardCell:touchMask(point)
	if ((not self.tbMaskRect) or (point.x < 0.1 and point.y < 0.1)) then
		return nil
	end
	for name, rect in pairs(self.tbMaskRect) do
		if (rect:containsPoint(point)) then
			return self.tbBtnEvent[name]
		end
	end
end


function LevelRewardCell:getGroup()
	if (self.mlaycell) then
		return self.mlaycell
	end
	return nil
end

-- zhangqi, 2014-08-24, 创建行cell上的tableView, 由各种物品icon的cell构成
function LevelRewardCell:createSubView(tbData, idx )
	local layNextSubView = LevelRewardCell.tbSubListView[idx + 1]
	if (layNextSubView) then
		self.layRow:removeAllChildrenWithCleanup(true)

		if (layNextSubView:getParent()) then
			layNextSubView:removeFromParentAndCleanup(true)
		end

		self.layRow:addChild(layNextSubView)
	else
		local tbView = {}
		tbView.szView = CCSizeMake(self.layRow:getSize().width,self.layRow:getSize().height)
		tbView.szCell = CCSizeMake(self.szIcon.width + 12, self.szIcon.height)
		tbView.CellAtIndexCallback = function ( tbItemData ,subidx)
			local itemCell = LevelRewardItem:new()
			itemCell:init(tbItemData, LevelRewardCell.iconCell:clone())
			itemCell:refresh(tbItemData)
			return itemCell
		end

		tbView.tbDataSource = tbData.item
		listView = HZListView:new()
		if (listView:init(tbView)) then
			local view = listView:getView()
			local layView = TableViewLayout:create(view)
			layView:retain() 	--保持下引用计数, 主UI关闭前会被统一release
			LevelRewardCell.tbSubListView[idx + 1] = layView
			self.layRow:removeAllChildrenWithCleanup(true)
			self.layRow:addChild(layView)

			view:setDirection(kCCScrollViewDirectionHorizontal)
			view:setTouchEnabled(false)
			listView:refresh()
		end
	end
end

-- tbData = { title = "", rid = 0, status = 1, tbItem = {} }
function LevelRewardCell:refresh(tbData, idx)
	if (self.mlaycell) then
		local cell  = self.mlaycell

		local labnCellTitle = m_fnGetWidget(cell,"LABN_CELL_TITLE")
		local tfdJi = m_fnGetWidget(cell, "tfd_jijiangli")
		local imgRecieved = m_fnGetWidget(cell, "IMG_RECIEVED")
		local btnGetReward = m_fnGetWidget(cell,"BTN_GET_REWARD")

		labnCellTitle:setStringValue(tbData.title)
		UIHelper.labelEffect(tfdJi, gi18n[2503])
		UIHelper.titleShadow(btnGetReward, gi18n[2628])

		btnGetReward:setEnabled(true)
		btnGetReward:setBright(true)
		btnGetReward:setTouchEnabled(true)
		btnGetReward:setGray(false)

		imgRecieved:setEnabled(true)

		if (tbData.status == 2) then
			btnGetReward:setEnabled(false)
			self:removeMaskButton("BTN_GET_REWARD")
		else
			imgRecieved:setEnabled(false)
			btnGetReward:setTag(tbData.rid)
			self:addMaskButton(btnGetReward,"BTN_GET_REWARD")
			if (tbData.status == 0) then
				btnGetReward:setGray(true)
				btnGetReward:setTouchEnabled(false)
				self:removeMaskButton("BTN_GET_REWARD")
			end
		end

		self:createSubView(tbData, idx)
	end
end

