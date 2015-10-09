--=======================================
-- 自由伸缩项的滚动列表图层对象封装
-- by zhiyong.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  FlexibleListScrollViewLayer.lua
-- author:    zhiyong.li
-- e-mail:      zhiyong.li@happyelements.com
-- created:   2013/9/22
-- descrip:   对Cocos2d-x中自定义的CCFlexibleListScrollView类封装
--=======================================

require "core.display.Layer"

FlexibleListScrollViewLayer = class(Layer);

-- 构造函数
function FlexibleListScrollViewLayer:ctor()
	self.class = FlexibleListScrollViewLayer;
	self.nodeType = DisplayNodeType.kOthers;
end

-- 初始化层对象
function FlexibleListScrollViewLayer:initLayer()
	if not self.initialized then
		self.sprite = CCFlexibleListScrollView:create();

		if self.sprite then
			self.sprite:retain();
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

-- 销毁对象
function FlexibleListScrollViewLayer:dispose()
	FlexibleListScrollViewLayer.superclass.dispose(self);
end

-- 获取可视区域尺寸
-- return CCSize — 尺寸
function FlexibleListScrollViewLayer:getViewSize()
	return self.sprite:getViewSize();
end

-- 设置可视区域尺寸
-- CCSize size — 尺寸
function FlexibleListScrollViewLayer:setViewSize(size)
	self.sprite:setViewSize(size);
end

-- 设置滚动方向
-- CCScrollViewDirection direction — 滚动方向枚举对象
function FlexibleListScrollViewLayer:setDirection(direction)
	self.sprite:setDirection(direction);
end

-- 获取内部容器位移值
-- return CCPoint — 内部容器位移值
function FlexibleListScrollViewLayer:getContentOffset()
	return self.sprite:getContentOffset();
end

-- 获取列表项数目
-- return unsigned int — 列表项数目
function FlexibleListScrollViewLayer:getItemCount()
	return self.sprite:getItemCount();
end

-- 设置列表项尺寸
-- CCSize size — 尺寸
function FlexibleListScrollViewLayer:setItemSize(size)
	self.sprite:setItemSize(size);
end

-- 获取列表可视区域矩形对象
-- return CCRect — 列表可视区域矩形对象
function FlexibleListScrollViewLayer:getListViewRect()
	return self.sprite:getListViewRect();
end

-- 判断点是否在列表可视区域
-- CCPoint — 点
-- return bool — 点是否在可视区域
function FlexibleListScrollViewLayer:pointInListView(point)
	return self:getListViewRect():containsPoint(point);
end

-- 添加列表项
-- display.DisplayNode — 列表项
-- bool follow — 是否定位到添加项
function FlexibleListScrollViewLayer:addItem(item , follow)
	self:addItemAt(item, self:getItemCount(), follow);
end

-- 插入列表项
-- display.DisplayNode item — 列表项
-- unsigned int index — 插入的索引
-- bool follow — 是否定位到添加项
function FlexibleListScrollViewLayer:addItemAt(item, index, follow)
	local addedItem = nil;
	local exist = false;
	local existIndex = -1;

	if item:is(MovieClip) then
		addedItem = item.layer;
	else
		addedItem = item;
	end

	exist = self.sprite:addItemAt(addedItem.sprite, index, follow);

	if exist == false then
		for i, v in ipairs(self.list) do
			if v == addedItem then
				existIndex = i;
				self:removeChildFromDisplayList(i, false);
				break;
			end
		end
	end

	if existIndex ~= -1 then
		if index > existIndex then
			index = index - 1;
		elseif index < existIndex then
			index = index + 1;
		end
	end

	self:addChildToDisplayList(addedItem, index);
end

-- 移除列表项
-- unsigned int index — 列表项索引
-- bool cleanup — 销毁对象
function FlexibleListScrollViewLayer:removeItemAt(index, cleanup)
	if index > self:getItemCount() - 1 then
		return;
	end

	self.sprite:removeItemAt(index, cleanup);
	self:removeChildFromDisplayList(index + 1, cleanup);
end

-- 移除列表最后一项
-- bool cleanup — 销毁对象
function FlexibleListScrollViewLayer:removeLastItem(cleanup)
	-- 从显示列表中移除对象
	local index = table.getn(self.list);
	self.sprite:removeLastItem(cleanup);
	self:removeChildFromDisplayList(index, cleanup);
end

-- 移除所有列表项
-- bool cleanup — 销毁对象
function FlexibleListScrollViewLayer:removeAllItems(cleanup)
	if cleanup then
		for i, v in ipairs(self.list) do
			v:dispose();
		end
	end

	self.list = {};

	self.sprite:removeAllItems(cleanup);
end

-- 滚动到指定列表项
-- unsigned int index — 列表项索引
-- bool animated — 缓动标识
function FlexibleListScrollViewLayer:scrollToItemByIndex(index, animated)
	if animated == nil  then
		animated = false;
	end

	self.sprite:scrollToItemByIndex(index, animated);
end

-- 更新列表
function FlexibleListScrollViewLayer:updateList()
	self.sprite:updateList();
end

-- 设置是否裁剪显示区域
function FlexibleListScrollViewLayer:setClippingToBounds(clippingToBounds)
	self.sprite:setClippingToBounds(clippingToBounds);
end

-- 点击判断
-- 
function FlexibleListScrollViewLayer:hitTestPoint(worldPosition, useCacheBounds, useGroupTest)
	if self:pointInListView(worldPosition) then
		return FlexibleListScrollViewLayer.superclass.hitTestPoint(self, worldPosition, useCacheBounds, useGroupTest);
	else
		return false;
	end
end

-- 设置是否滑动翻页
function FlexibleListScrollViewLayer:setMoveEnabled(b)
	self.sprite:setMoveEnabled(b)
end