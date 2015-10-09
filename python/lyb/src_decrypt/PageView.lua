--=====================================================
-- 翻页视图组件
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  PageView.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/07/02
-- descrip:   翻页视图组件
--=====================================================

PageView = class(DisplayNode);

local function touchBeginEvent( event )
	-- print("pageView touchBeginEvent");
	local tableObject = event.target;
	local position = event.globalPosition;

	if tableObject then
		local refCocosObj = tableObject.sprite;

		refCocosObj:luaTouchBegan(position);
	end
end

local function touchMoveEvent( event )
	-- print("pageView touchMoveEvent");
	local tableObject = event.target;
	local position = event.globalPosition;
	if tableObject then
		local refCocosObj = tableObject.sprite;
		refCocosObj:luaTouchMove(position);
	end
end

local function touchEndEvent( event )
		 print("pageView touchEndEvent");
		local tableObject = event.target;
		local position = event.globalPosition;
	if tableObject then
		local refCocosObj = tableObject.sprite;
		refCocosObj:luaTouchEnd(position);
	end
end

-- 构造函数
function PageView:ctor(refCocosObj)
	self.pages = {};

	self.viewType = 1;

	-- self:addEventListener(DisplayEvents.kTouchBegin, touchBeginEvent, self)
 --    self:addEventListener(DisplayEvents.kTouchEnd, touchEndEvent, self)
	-- self:addEventListener(DisplayEvents.kTouchMove, touchMoveEvent, self)

end

-- 初始化分页控制器
function PageView:initializePageViewControl()
	if self.pageViewControl then
		self.pageViewControl:setPageView(self);
		self.pageViewControl:initialize();
	end
end

-- 获取翻页前页码
function PageView:getLastPage()
	return self.sprite:getLastPage();
end

-- 获取当前页码
function PageView:getCurrentPage()
	return self.sprite:getCurrentPage();
end

-- 获取最大页码
function PageView:getMaxPage()
	return self.sprite:getMaxPage();
end

-- 设置最大页码
function PageView:setMaxPageCount(count)
	self.sprite:setMaxPageCount(count);
end

-- 设置容器尺寸
function PageView:setContainerSize(size)
	self.sprite:setContainerSize(size);
end

-- 设置触摸区域尺寸
function PageView:setHitAreaSize(size)
	if self.hitArea then
		self.hitArea:setContentSize(size);
	end
end

-- 注册滚动停止回调方法
function PageView:registerScrollStopedScriptHandler(handler)
	self.sprite:registerScrollStopedScriptHandler(handler);
end

function PageView:unregisterScrollStopedScriptHandler()
	self.sprite:unregisterScrollStopedScriptHandler();
end

function PageView:setBounceable(v) 
	self.sprite:setBounceable(v) 
end

-- 设置是否隐藏不可见页面
function PageView:setHideInvisiblePages(value)
	self.sprite:setHideInvisiblePages(value);
end

function PageView:getPageIsMoved( )
	-- body
	return self.sprite:getPageIsMove();
end
--跳转到某一页
function PageView:setCurrentPage(pageNum)
	-- body
	self.sprite:setCurrentPage(pageNum);
end
function PageView:setMoveEnabled(bool)
	self.sprite:setMoveEnabled(bool)
end
-- 销毁组件
function PageView:dispose()
	self.pages = nil;

	DisplayNode.dispose(self);
end
