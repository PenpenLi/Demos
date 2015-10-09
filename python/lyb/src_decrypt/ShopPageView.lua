--=====================================================
-- 商店分页视图基类
-- by zhenyu.li
-- (c) copyright 2009 - 2013, www.happyelements.com
-- All Rights Reserved. 
--=====================================================
-- filename:  ShopPageView.lua
-- author:    zhenyu.li
-- e-mail:      zhenyu.li@happyelements.com
-- created:   2013/08/12
-- descrip:  商店分页视图基类
--=====================================================
require "core.controls.page.CommonPageView"


ShopPageView = class(CommonPageView);

-- 初始化
function ShopPageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, hideNilSlot)
	CommonPageView.initialize(self, createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, bPageControl, nil, hideNilSlot);
	self:update();
end

-- 更新界面显示
function ShopPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end

-- 初始化翻页控制指示器
function ShopPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);

	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(position.x + 30, position.y);
	end
end

function ShopPageView:create(items, context, onOpenChargeUI, onShopItemTap, onBuyItem, onOpenFunctionUI, useType)
	local use_type = useType or 1;
	local shopSprite = CCPageView:create();
	print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&shopViewSprite:", shopSprite)
	local pageView = ShopPageView.new(shopSprite);
	print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&pageView'sSprite:", pageView.sprite)
	local slotSize = CCSizeMake(233, 219); --slot尺寸
	local rowNum = 2;
	local colNum = 4;
	local marginH = 20;
	local marginV = 34;

	
    local curIndex = 1;
	local function createSlotCallback()
        print("ShopTestSlot:create #items", #items);
        local shopItemPo = items[curIndex];
        curIndex = curIndex + 1;
        if shopItemPo then
			return ShopSlot:create(shopItemPo, context, onOpenChargeUI, onShopItemTap, onBuyItem, onOpenFunctionUI, use_type);
		else
			print("shopItemPo is nil;");
        end

	end
	pageView:initialize(createSlotCallback, slotSize, rowNum, colNum, marginH, marginV, true, true);


	pageView:update(items);
	return pageView;
end