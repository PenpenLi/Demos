--=======================================
-- 滑动面板
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  ScrollPane.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/15
-- descrip:   对Cocos2d-x中自定义的CCScrollPane类封装
--=======================================

require "core.display.Layer"

ScrollPane = class(Layer);

-- 构造函数
function ScrollPane:ctor()
	self.class = ScrollPane;
	self.nodeType = DisplayNodeType.kOthers;
	self.items = {};
end

-- 初始化层
function ScrollPane:initLayer()
	if not self.initialized then
		self.sprite = CCScrollPane:create();

		if self.sprite then
			self.sprite:retain();
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

-- 销毁对象
function ScrollPane:dispose()
	ScrollPane.superclass.dispose(self);
	self.items = nil;
end

-- 设置内容位移
-- CCPoint offset — 位移值
-- bool animated — 动画显示
function ScrollPane:setContentOffset(offset, animated)
	if animated == nil then
		animated = false;
	end

	self.sprite:setContentOffset(offset, animated);
end

-- 获取内容位移值
-- return CCPoint — 内容位移值
function ScrollPane:getContentOffset()
	return self.sprite:getContentOffset();
end

-- 在指定时间内容对内容作位移操作
-- CCPoint offset — 位移值
-- float dt — 持续时间
function ScrollPane:setContentOffsetInDuration(offset, dt)
	self.sprite:setContentOffsetInDuration(offset, dt);
end

-- 设置缩放
-- float s — 缩放值
function ScrollPane:setZoomScale(s)
	self.sprite:setZoomScale(s);
end

-- 缓动缩放
-- float s — 缩放值
-- bool animated — 启用动画效果
function ScrollPane:setZoomScale(s, animated)
	if animated == nil then
		animated = false;
	end

	self.sprite:setZoomScale(s, animated);
end

-- 缩放值
-- return float — 缩放值
function ScrollPane:getZoomScale()
	return self.sprite:getZoomScale();
end

-- 在指定时间内对内容作缩放操作
-- float s — 缩放值
-- float dt — 缓动时间
function ScrollPane:setZoomScaleInDuration(s, dt)
	self.sprite:setZoomScaleInDuration(s, dt);
end

-- 获取容器最小位移值
-- return CCPoint — 位移值
function ScrollPane:minContainerOffset()
	return self.sprite:minContainerOffset();
end

-- 获取容器最大位移值
-- return CCPoint — 位移值
function ScrollPane:maxContainerOffset()
	return self.sprite:maxContainerOffset();
end

-- 暂停对象滚动
-- CCObject sender — 对象
function ScrollPane:pause(sender)
	self.sprite:pause(sender);
end

-- 恢复对象滚动
-- CCObject sender — 对象
function ScrollPane:resume(sender)
	self.sprite:resume(sender);
end

-- 是否处于拖拽状态
-- return bool — 拖拽状态
function ScrollPane:isDragging()
	return self.sprite:isDragging();
end

-- 触摸点移动
-- return bool — 触摸移动标识
function ScrollPane:isTouchMoved()
	return self.sprite:isTouchMoved();
end

-- 视图尺寸
-- return CCSize — 尺寸
function ScrollPane:getViewSize()
	return self.sprite:getViewSize();
end

-- 设置视图尺寸
-- CCSize size — 尺寸
function ScrollPane:setViewSize(size)
	self.sprite:setViewSize(size);
end

-- 容器对象
-- return CCNode* — 显示节点对象
function ScrollPane:getContainer()
	return self.sprite:getContainer();
end

-- 设置滚动方向
-- CCScrollViewDirection direction — 滚动方向
function ScrollPane:setDirection(direction)
	self.sprite:setDirection(direction);
end

-- 设置内容尺寸
-- CCSize size — 尺寸
function ScrollPane:setContentSize(size)
	self.sprite:setContentSize(size);
end

-- 设置是否显示遮罩
-- bool clippingToBounds — 遮罩标识
function ScrollPane:setClippingToBounds(clippingToBounds)
	self.sprite:setClippingToBounds(clippingToBounds);
end

-- 添加对象
function ScrollPane:addChildAt(child, index)
	if child:is(MovieClip) then
		Layer.superclass.addChildAt(self, child.layer, index);
	else
		Layer.superclass.addChildAt(self, child, index);
	end
end

function ScrollPane:resetPostiton()
	self.sprite:resetPostiton();
end