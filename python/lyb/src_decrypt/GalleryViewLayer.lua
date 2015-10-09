--=======================================
-- 翻页滑动视图层对象封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  GalleryView.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/02/19
-- descrip:   对Cocos2d-x中自定义的CCGalleryView类封装
--=======================================

require "core.display.Layer"

GalleryViewLayer = class(Layer);

-- 构造函数
function GalleryViewLayer:ctor()
	self.class = GalleryViewLayer;
	self.nodeType = DisplayNodeType.kOthers;
end

-- 初始化翻页滑动层
function GalleryViewLayer:initLayer()
	if not self.initialized then
		self.sprite = CCGalleryView:create();

		if self.sprite then
			self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

-- 销毁对象
function GalleryViewLayer:dispose()
	self.sprite:removeAllChildrenWithCleanup(true);
	GalleryViewLayer.superclass.dispose(self);
end

-- 添加翻页结束回调方法
-- int nHandler — 回调方法
function GalleryViewLayer:addFlipPageCompleteHandler(nHandler)
	self.sprite:addFlipPageCompleteScriptHandler(nHandler);
end

-- 获得当前页码
-- return int — 当前页码
function GalleryViewLayer:getCurrentPage()
	return self.sprite:getCurrentPage();
end

-- 翻到指定的页码
-- int nPage — 页码
-- bool animated — 是否以动画效果展示
function GalleryViewLayer:setPage(nPage, animated)
	self.sprite:setPage(nPage, animated);
end

-- 设置最大页数
-- int nMaxPage — 最大页数
function GalleryViewLayer:setMaxPage(nMaxPage)
	self.sprite:setMaxPage(nMaxPage)
end

-- 设置容器对象
function GalleryViewLayer:setContainer(pContainer)
	self.sprite:setContainer(pContainer);
end

-- 添加内容
function GalleryViewLayer:addContent(child)
	if child and child.sprite then
		self.sprite:addContent(child.sprite);

		local index = table.getn(self.list);
		self:addChildToDisplayList(child, index);
	end
end

-- 设置容器尺寸
-- CCSize containerSize — 容器尺寸数据
function GalleryViewLayer:setContainerSize(containerSize)
	self.sprite:setContainerSize(containerSize);
end

-- 设置滚动方向
-- enum CCScrollViewDirection — 滚动方向标识
function GalleryViewLayer:setDirection(eDirection)
	self.sprite:setDirection(eDirection);
end

-- 设置可视区域尺寸
-- CCSize size — 尺寸
function GalleryViewLayer:setViewSize(size)
	self.sprite:setViewSize(size);
end

-- 获取可视区域尺寸
-- return CCSize — 尺寸
function GalleryViewLayer:getViewSize()
	return self.sprite:getViewSize();
end

-- 获取容器对象
-- return *
function GalleryViewLayer:getContainer()
	return self.sprite:getContainer();
end

-- 获取屏幕可见区域矩形对象
-- return CCRect
function GalleryViewLayer:getScreenViewRect()
	return self.sprite:getScreenViewRect();
end

-- 设置是否裁剪显示区域
function GalleryViewLayer:setClippingToBounds(clippingToBounds)
	self.sprite:setClippingToBounds(clippingToBounds);
end

-- 判断触摸点是否在可视区域内
-- CCPoint point — 触摸点
-- return bool — 触摸点是否在可视区域内
function GalleryViewLayer:containsTouchPoint(point)
	local rect = self:getScreenViewRect();
	return rect:containsPoint(point);
end

-- 设置是否滑动翻页
function GalleryViewLayer:setMoveEnabled(b)
	self.sprite:setMoveEnabled(b)
end