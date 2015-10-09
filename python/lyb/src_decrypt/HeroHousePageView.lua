--=====================================================
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  HeroHousePageView.lua
--=====================================================
require "core.controls.page.CommonPageView"
require "main.view.hero.heroHouse.ui.HeroHouseSlot"

HeroHousePageView = class(CommonPageView);

-- 初始化
function HeroHousePageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, hideNilSlot,pageFreshCallBack)
	CommonPageView.initialize(self, createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, nil, hideNilSlot,pageFreshCallBack);
	self:update();
end

-- 更新界面显示
function HeroHousePageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end

-- 初始化翻页控制指示器
function HeroHousePageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);

	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(position.x + 30, position.y);
	end
end

function HeroHousePageView:pageFreshCallBack()
	local currentPage = self:getCurrentPage();
	if self.pageTF then
		self.pageTF:setString(currentPage.."/"..self.maxPageNum)
	end
	-- print("fresh");
end;

function HeroHousePageView:create(context, items, pageTF, onCardTap, isLook)
	self.pageTF = pageTF;
	-- local use_type = useType or 1;
	local heroHouseSprite = CCPageView:create();
	local pageView = HeroHousePageView.new(heroHouseSprite);
	local slotSize = CCSizeMake(180, 591); --slot尺寸
	local rowNum = 1;
	local colNum = 6;
	local marginH = 2;
	local marginV = 0;
	
    local curIndex = 1;
	local function createSlotCallback()
		curIndex = curIndex + 1;
        local slot = HeroHouseSlot:create(context,onCardTap,isLook);
        table.insert(context.slots, slot);
		return slot;
	end
	pageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, true, true,nil,self.pageFreshCallBack);

	pageView:update(items);
	return pageView;
end