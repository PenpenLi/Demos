--=======================================
-- 手风琴容器Tab标签
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=======================================
-- filename:  AccordionViewTab.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/04/19
-- descrip:   对Cocos2d-x中自定义的CCAccordionViewTab类封装
--=======================================

AccordionViewTab = class(Layer);

-- 构造函数
-- CCSize titleSize — 标题栏尺寸
-- CCSize contentSize — 内容尺寸
function AccordionViewTab:ctor(titleSize, contentSize)
	self.class = AccordionViewTab;
	self.titleSize = titleSize;
	self.contentSize = contentSize;
end

-- 初始化层
function AccordionViewTab:initLayer()
	if not self.initialized then
		self.sprite = CCAccordionViewTab:create(self.titleSize, self.contentSize);

		if self.sprite then
			self.sprite:retain(); -- 将素材加入计数器，以便内存清理时不会出现内存泄露
			self.sprite:setAnchorPoint(makePoint(0, 0));
		end
		
		self.initialized = true;
	end
end

-- 销毁对象
function AccordionViewTab:dispose()
	AccordionViewTab.superclass.dispose(self);
	self.titleSize = nil;
	self.contentSize = nil;
end

-- 添加标题显示对象
-- DisplayNode display — 显示对象
function AccordionViewTab:addTitleDisplay(display)
	local displayContent;

	if display:is(MovieClip) then
		displayContent = display.layer;
	else
		displayContent = display;
	end

	self.sprite:addTitleDisplay(displayContent.sprite);

	local index = table.getn(self.list);
	self:addChildToDisplayList(displayContent, index);
end

-- 添加内容显示对象
-- DisplayNode display — 显示对象
function AccordionViewTab:addContentDisplay(display)
	local displayContent;

	if display:is(MovieClip) then
		displayContent = display.layer;
	else
		displayContent = display;
	end

	self.sprite:addContentDisplay(displayContent.sprite);

	local index = table.getn(self.list);
	self:addChildToDisplayList(displayContent, index);
end

--
function AccordionViewTab:isOpen()
	if not self.sprite then return; end
	return self.sprite:isOpen();
end
--
function AccordionViewTab:expand(bOpen)
	if not self.sprite then return; end
	return self.sprite:expand(bOpen);
end