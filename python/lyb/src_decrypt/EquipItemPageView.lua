--=====================================================
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  EquipItemPageView.lua
--=====================================================
require "core.controls.page.CommonPageView"
require "main.view.hero.heroPro.ui.EquipItemSlot"
-- require "main.view.bag.ui.bagPopup.BagItemSlot";

EquipItemPageView = class(CommonPageView);

-- 初始化
function EquipItemPageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, hideNilSlot,pageFreshCallBack)
	CommonPageView.initialize(self, createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, nil, hideNilSlot,pageFreshCallBack);
	self:update();
end

-- 更新界面显示
function EquipItemPageView:update(list)
	if not list then
		return;
	end
	self:updateData(list);
end

-- 初始化翻页控制指示器
function EquipItemPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);

	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(position.x + 30, position.y);
	end
end

function EquipItemPageView:pageFreshCallBack()
	local currentPage = self:getCurrentPage();
	self.pageTF:setString("<"..currentPage.."/"..self.maxPageNum..">")
	-- -- print("fresh");
end;

function EquipItemPageView:create(context,items,pageTF,onCardTap)
	self.pageTF = pageTF;
	-- local use_type = useType or 1;
	local heroHouseSprite = CCPageView:create();
	local pageView = EquipItemPageView.new(heroHouseSprite);
	local slotSize = CCSizeMake(106, 106); --slot尺寸
	local rowNum = 4;
	local colNum = 2;
	local marginH = 20;
	local marginV = 20;
	
    local curIndex = 1;
	local function createSlotCallback()
		if items[curIndex] then
			print("curIndex"..curIndex);
	        curIndex = curIndex + 1;
	        local item = EquipItemSlot:create(context,items[curIndex],onCardTap);
	        return item;
		end;

	end
	pageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, true, true,nil,self.pageFreshCallBack);

	pageView:update(items);
	return pageView;
end