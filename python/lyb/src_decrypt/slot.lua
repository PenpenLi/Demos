--=====================================================
-- 通用分页插槽，实现pageView中某一项的具体功能
-- by xiaochun.gong
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================

local function onSlotTouchTap(evt)
	local slot = evt.context;
	slot:onSlotTouch(evt.globalPosition);
end

CommonSlot = class(ScaleLayer)

--构造
function CommonSlot:ctor(display)
	
end

--初始化
function CommonSlot:initialize()
	self:addEventListener(DisplayEvents.kTouchTap, onSlotTouchTap, self);
end

--初始化
function CommonSlot:removeTouchEvent()
	self:removeEventListener(DisplayEvents.kTouchTap, onSlotTouchTap);
end

-- 响应组件的点击事件
function CommonSlot:onSlotTouch(globalPos)
	if self.page then
		self.page:dispatchEvent(Event.new(InventoryEvents.kOnSlotSelected, self, self.page, globalPos));
	end
end

--设置slot的选中状态(子类重写该方法)
function CommonSlot:setSelected(bSelect)
	
end

-- 设置slot的enable状态(子类重写该方法)
function CommonSlot:setEnabled(bEnabled)
	
end

-- 设置slot的数据(子类重写该方法)
function CommonSlot:setSlotData(data)
	self.data = data;
end

--清除slot的数据(子类重写该方法)
function CommonSlot:removeSlotData()
	self.data = nil;
end

-- 获取slot数据
function CommonSlot:getSlotData()
	return self.data;
end

function CommonSlot:setPage(page)
	self.page = page;
end

function CommonSlot:getPageView()
	if not self.page then return nil end;
	return self.page.pageView;
end

