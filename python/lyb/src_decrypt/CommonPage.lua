--=====================================================
-- 通用分页，管理多个Slot
-- by xiaochun.gong
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================

-- slot点击回调函数
-- local function onPageSlotSelected(evt)
-- 	local page = evt.context;
-- 	local pageView = page.pageView;
-- 	local slot = evt.data;

-- 	if not pageView or pageView:getPageIsMoved() then
-- 		return;
-- 	end
-- 	if not slot.data then return end;

-- 	pageView:resetSlotsSelected();
-- 	slot:setSelected(true);

-- 	pageView:onSlotTouch(slot, page, evt.globalPosition);
-- end

CommonPage = class(DisplayNode)

--构造
function CommonPage:ctor()
	self.slots = {};		-- slot列表
	self.slotSize = nil;	--slot的大小
	self.rowNum = nil;		--行数
	self.colNum = nil;		--列数
	self.marginH = nil;		--slot间隙(横向)
	self.marginV = nil;		--slot间隙(纵向)
	self.pageView = nil;	--父pageView
end

--初始化
function CommonPage:initialize(slotSize, rowNum, colNum, marginH, marginV, pageView)
	self.slotSize = slotSize;
	self.rowNum = rowNum;
	self.colNum = colNum;
	self.marginH = marginH;
	self.marginV = marginV;
	self.pageView = pageView;

	-- 设置page大小
	local width = self.colNum * (self.slotSize.width + self.marginH);
	local height = self.rowNum * (self.slotSize.height + self.marginV);
	self:setContentSize(CCSizeMake(width, height));

	--创建slots
	for i = 1, self.rowNum do
		for j = 1, self.colNum do
			local slot = self.pageView.createSlotCallback();
			if slot then
				slot:setPage(self);
				slot.index = (i - 1) * self.rowNum + j;

				slot.sprite:setAnchorPoint(ccp(0,0));
				local posX = self.slotSize.width * (j-1) + self.marginH * (j-0.5);
				local posY = self.slotSize.height * (self.rowNum+1-i) + self.marginV * (self.rowNum-i+0.5) + self.pageView.offset;

				print("posX, posY", posX, posY)
				slot:setPositionXY(posX, posY);
				self:addChild(slot);

				table.insert(self.slots, slot);
			end
		end
	end

	--监控slot点击事件
	--self:addEventListener(InventoryEvents.kOnSlotSelected, onPageSlotSelected, self);

	--重置slot的状态
	self:resetSlots();
end

--重置slot状态
function CommonPage:resetSlots()
	for i, v in ipairs(self.slots) do
		v:removeSlotData();
		v:setEnabled(true);
	end
end

-- 重置所有道具栏的选中状态
-- function CommonPage:resetSlotsSelected()
-- 	for i, v in ipairs(self.slots) do
-- 		v:setSelected(false);
-- 	end
-- end

-- 设置slot数据
function CommonPage:setSlotData(data, index)
	local slot = self.slots[index];
	slot:setSlotData(data);

	if self.hideNilSlot then
		slot:setVisible(true);
	end
end

-- 清除slot的数据
function CommonPage:removeSlotData(index)
	print("removeSlotData index:", index)
	local slot = self.slots[index];
	if slot then
		if self.hideNilSlot then
			slot:setVisible(false);
		else
			slot:removeSlotData();
		end
	end
end

--创建
function CommonPage:create(slotSize, rowNum, colNum, marginH, marginV, pageView)
	local page = CommonPage.new(CCSprite:create());
	page:initialize(slotSize, rowNum, colNum, marginH, marginV, pageView);
	return page;
end