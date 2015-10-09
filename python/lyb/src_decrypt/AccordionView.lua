--=======================================
-- 手风琴容器
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  AccordionView.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/19
-- descrip:   对Cocos2d-x中自定义的CCAccordionView类封装
--=======================================
AccordionView = class(Layer);

-- 构造函数
function AccordionView:ctor()
	self.class = AccordionView;
	self.nodeType = DisplayNodeType.kOthers;
	self.tabs = nil;
end

-- 初始化层对象
function AccordionView:initLayer()
	if not self.initialized then
		self.sprite = CCAccordionView:create();

		if self.sprite then
			self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end

		self.tabs = { };
		
		self.initialized = true;
	end
end

-- 销毁对象
function AccordionView:dispose()
	AccordionView.superclass.dispose(self);
	self.tabs = nil;
end

-- 添加tab
function AccordionView:addTab(tab)
	table.insert(self.tabs, tab);
	self.sprite:addTab(tab.sprite);
	local index = table.getn(self.list);
	self:addChildToDisplayList(tab, index);
end