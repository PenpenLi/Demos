--=======================================
-- 画图层对象封装
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- descrip:   对Cocos2d-x中自定义的GalleryView类封装
--=======================================

require "core.display.Layer"

DrawLayer = class(Layer);

-- 构造函数
function DrawLayer:ctor()
	self.class = DrawLayer;
	self.nodeType = DisplayNodeType.kOthers;
end

-- 初始化翻页滑动层
function DrawLayer:initLayer()
	if not self.initialized then
		self.sprite = CCDrawLayer:create();

		if self.sprite then
			--self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
		end
		
		self.initialized = true;
	end
end
--画线
function DrawLayer:drawLine(origin, destination)
	self.sprite:drawLine(origin, destination);
end
function DrawLayer:drawColor4B(r, g, b, a)
	self.sprite:drawColor4B(r, g, b, a);
end
function DrawLayer:drawLineWidth(width)
	self.sprite:drawLineWidth(width);
end
function DrawLayer:drawRect(origin, destination)
	self.sprite:drawRect(origin, destination);
end