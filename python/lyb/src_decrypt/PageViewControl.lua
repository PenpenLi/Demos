--=====================================================
-- 页码显示组件基类
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  PageViewControl.lua
-- author:    zhenyu.li
-- e-mail:    zhenyu.li@happyelements.com
-- created:   2013/08/09
-- descrip:   页码显示组件基类
--=====================================================

PageViewControl = class(Layer);

-- 构造函数
function PageViewControl:ctor()
	self.pageView = nil;
	self.dots = {};
	self.currentPage = 0;
	self.parentSize = nil;
end

-- 初始化层
function PageViewControl:initLayer(parentSize)
	self.parentSize = parentSize;
	Layer.initLayer(self);
end

-- 初始化
function PageViewControl:initialize()
	self:setLocation();
	self:update();
end

-- 设置翻页组件对象
function PageViewControl:setPageView(pageView)
	self.pageView = pageView;
end

-- 更新组件显示(继承)
function PageViewControl:update()
end

-- 设置坐标定位(继承)
function PageViewControl:setLocation()
end

-- 销毁组件
function PageViewControl:dispose()
	self.pageView = nil;
	self.dots = nil;
	self.currentPage = nil;
	self.parentSize = nil;
	self.uiBuilder = nil;

	Layer.dispose(self);
end




--=====================================================
-- 翻页视图控制器组件分页缩略对象
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- classname:  PageViewControlDot.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/08/09
-- descrip:   翻页视图控制器分页缩略对象
--=====================================================

PageViewControlDot = class(DisplayNode);

-- 构造函数
function PageViewControlDot:ctor(display)
   self.display = display
end

-- 初始化
function PageViewControlDot:initialize()
	self:setSelected(false);
end

-- 设置是否选中
function PageViewControlDot:setSelected(selected)
	self.display:select(selected)
end

-- 创建实例
function PageViewControlDot:create(display)
	local dot = PageViewControlDot.new(display);
	dot:initialize();
	return dot;
end

--=====================================================
-- 翻页视图控制器组件
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- classname:  PageIndexDotStyle.lua
-- author:    zhenyu.li
-- e-mail:    zhenyu.li@happyelements.com
-- created:   2013/08/09
-- descrip:   翻页视图控制器
--=====================================================

-- Style 1
PageIndexDotStyle = class(PageViewControl);

-- 构造函数
function PageIndexDotStyle:ctor()
	self.dotHeight = 20;
	self.dotXDelta = 0;
end

-- 初始化
function PageIndexDotStyle:initialize()
	-- 控制器点间距
	local kPageViewControllerDotMargin = 15;

	local maxPage = self.pageView.maxPageNum;

	for i, v in ipairs(self.dots) do
		self:removeChild(v.display);
	end

	self.dots = {};

	for i=1, maxPage do
		local commonButton = CommonButton.new();
		commonButton:initialize("commonButtons/common_page_button_normal","commonButtons/common_page_button_down",CommonButtonTouchable.BUTTON,nil,nil,true);
   
		local dot = PageViewControlDot:create(commonButton);
		local size = dot.display:getGroupBounds().size;
		dot.display:setPositionXY((i - 1) * (size.width + kPageViewControllerDotMargin), size.height);
		table.insert(self.dots, dot);
		self:addChild(dot.display);
	end

	-- 最后才能调调用父类
	PageViewControl.initialize(self);
end

-- 更新组件显示
function PageIndexDotStyle:update()
	local currentPage = self.pageView:getCurrentPage();

	if self.currentPage == currentPage then
		return;
	end

	for i, v in ipairs(self.dots) do
		if currentPage == i then
			v:setSelected(true);
		else
			v:setSelected(false);
		end
	end
end

--@param dotXDelta x方向的偏移量
function PageIndexDotStyle:setParentSizeAndDotHeight(parentSize, dotHeight ,dotXDelta)
	self.parentSize = CCSizeMake(parentSize.width, parentSize.height);
	self.dotHeight = dotHeight or 20;
	self.dotXDelta = dotXDelta or 0;

	self:setLocation();
end

-- 设置坐标定位
function PageIndexDotStyle:setLocation()
	local size = self:getGroupBounds().size;
	self:setPositionXY((self.parentSize.width - size.width) / 2 + self.dotXDelta, self.dotHeight);
end

-- 创建实例
function PageIndexDotStyle:create(parentSize)
	local control = PageIndexDotStyle.new();
	control:initLayer(parentSize);
	return control;
end

