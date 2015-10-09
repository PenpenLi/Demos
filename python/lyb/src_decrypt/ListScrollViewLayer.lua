--=======================================
-- 滚动列表图层对象封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  ListScrollView.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/02/26
-- descrip:   对Cocos2d-x中自定义的CCListScrollView类封装
--=======================================

require "core.display.Layer"
require "core.controls.ListScrollViewLayerItem"

ListScrollViewLayer = class(Layer);

-- 构造函数
function ListScrollViewLayer:ctor()
	self.class = ListScrollViewLayer;
	self.nodeType = DisplayNodeType.kOthers;
	self.itemSize = nil;
end

-- 初始化层对象
function ListScrollViewLayer:initLayer()
	if not self.initialized then
		self.sprite = CCListScrollView:create();

		if self.sprite then
			self.sprite:retain();
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;

		local function funcOnCall()
			self:onScrollFunc();
		end

		self:setAnimateScrollFunction(funcOnCall);
	end
end

function ListScrollViewLayer:onScrollFunc()
	local idx = math.ceil((self.itemSize.height*self:getItemCount()+self:getContentOffset().y)/self.itemSize.height);
	for k,v in pairs(self.list) do
		if idx < k then
			break;
		end
		if not v.isInitialized and v.onInitialize then
			v.isInitialized = true;
			v:onInitialize();
		end
	end
end

-- 销毁对象
function ListScrollViewLayer:dispose()
	ListScrollViewLayer.superclass.dispose(self);
end

-- 获取可视区域尺寸
-- return CCSize — 尺寸
function ListScrollViewLayer:getViewSize()
	return self.sprite:getViewSize();
end

-- 设置可视区域尺寸
-- CCSize size — 尺寸
function ListScrollViewLayer:setViewSize(size)
	self.sprite:setViewSize(size);
end

-- 设置滚动方向
-- CCScrollViewDirection direction — 滚动方向枚举对象
function ListScrollViewLayer:setDirection(direction)
	self.sprite:setDirection(direction);
end

-- 获取内部容器位移值
-- return CCPoint — 内部容器位移值
function ListScrollViewLayer:getContentOffset()
	return self.sprite:getContentOffset();
end

-- 设置内部容器位移值
-- CCPoint point
-- bool animated — 缓动标识
function ListScrollViewLayer:setContentOffset(point, animated)
	if point then
		self.sprite:setContentOffset(point, animated);
	end
	self:onScrollFunc();
end

-- 获取列表项数目
-- return unsigned int — 列表项数目
function ListScrollViewLayer:getItemCount()
	return self.sprite:getItemCount();
end

-- 设置列表项尺寸
-- CCSize size — 尺寸
function ListScrollViewLayer:setItemSize(size)
	self.sprite:setItemSize(size);
	self.itemSize = size;
end

-- 获取列表可视区域矩形对象
-- return CCRect — 列表可视区域矩形对象
function ListScrollViewLayer:getListViewRect()
	return self.sprite:getListViewRect();
end

-- 判断点是否在列表可视区域
-- CCPoint — 点
-- return bool — 点是否在可视区域
function ListScrollViewLayer:pointInListView(point)
	return self:getListViewRect():containsPoint(point);
end

-- 添加列表项
-- display.DisplayNode — 列表项
-- bool follow — 是否定位到添加项
function ListScrollViewLayer:addItem(item , follow)
	self:addItemAt(item, self:getItemCount(), follow);
	self:onScrollFunc();
end

-- 插入列表项
-- display.DisplayNode item — 列表项
-- unsigned int index — 插入的索引
-- bool follow — 是否定位到添加项
function ListScrollViewLayer:addItemAt(item, index, follow)
	local addedItem = nil;
	local exist = false;
	local existIndex = -1;
--log("ListScrollViewLayer---1")
	if item:is(MovieClip) then
		addedItem = item.layer;
		--log("ListScrollViewLayer---2")
	else
		addedItem = item;
	end
--log("ListScrollViewLayer---3")
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
	self:onScrollFunc();
end

-- 移除列表项
-- unsigned int index — 列表项索引
-- bool cleanup — 销毁对象
function ListScrollViewLayer:removeItemAt(index, cleanup)
	if index > self:getItemCount() - 1 then
		return;
	end

	self.sprite:removeItemAt(index, cleanup);
	self:removeChildFromDisplayList(index + 1, cleanup);
	self:onScrollFunc();
end

-- 移除列表最后一项
-- bool cleanup — 销毁对象
function ListScrollViewLayer:removeLastItem(cleanup)
	-- 从显示列表中移除对象
	local index = table.getn(self.list);
	self.sprite:removeLastItem(cleanup);
	self:removeChildFromDisplayList(index, cleanup);
	self:onScrollFunc();
end

-- 移除所有列表项
-- bool cleanup — 销毁对象
function ListScrollViewLayer:removeAllItems(cleanup)
	if cleanup then
		for i, v in ipairs(self.list) do
			v:dispose();
		end
	end

	self.list = {};

	self.sprite:removeAllItems(cleanup);
	self:onScrollFunc();
end

-- 滚动到指定列表项
-- unsigned int index — 列表项索引
-- bool animated — 缓动标识
function ListScrollViewLayer:scrollToItemByIndex(index, animated)
	if animated == nil  then
		animated = false;
	end

	self.sprite:scrollToItemByIndex(index, animated);
	self:onScrollFunc();
end

-- 更新列表
function ListScrollViewLayer:updateList()
	self.sprite:updateList();
end

-- 设置是否裁剪显示区域
function ListScrollViewLayer:setClippingToBounds(clippingToBounds)
	self.sprite:setClippingToBounds(clippingToBounds);
end

-- 点击判断
-- 
function ListScrollViewLayer:hitTestPoint(worldPosition, useCacheBounds, useGroupTest)
	if self:pointInListView(worldPosition) then
		return ListScrollViewLayer.superclass.hitTestPoint(self, worldPosition, useCacheBounds, useGroupTest);
	else
		return false;
	end
end

-- 设置是否滑动翻页
function ListScrollViewLayer:setMoveEnabled(b)
	self.sprite:setMoveEnabled(b)
end


-- 设置滑动回调方法
-- LUA_FUNCTION callFunc
function ListScrollViewLayer:setAnimateScrollFunction(callFunc)
	if self.sprite then
		self.sprite:setAnimateScrollFunction(callFunc);
	end
end

--启用焦点位置滚动模式
--bool是否使用
--xRate/yRate 焦点坐标(x,y)
function ListScrollViewLayer:enableScrollFocusLocation(bool, xRate, yRate)
	if self.sprite then
		self.sprite:enableScrollFocusLocation(bool, xRate, yRate)
	end
end

-- 设置是否滑动翻页
function ListScrollViewLayer:setItemAnchorPoint(point)
	self.sprite:setItemAnchorPoint(point)
end

function ListScrollViewLayer:setScrollViewScrollOut(bool)
	self.sprite:setScrollViewScrollOut(bool)
end
function ListScrollViewLayer:setScrollOutStopedHandler(handler)
	self.sprite:setScrollOutStopedHandler(handler)
end