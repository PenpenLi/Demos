require "core.controls.page.CommonPageView";
require "main.view.shop.ui.ShopItemSlot";

ShopItemPageView = class(CommonPageView);

-- 初始化
function ShopItemPageView:initialize(context)
	self.context = context;
	self.slot=ShopItemSlot.new()
	local curIndex = 1;
	local function createSlotCallback()
        -- log("ShopItemPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = ShopItemSlot.new();
        item:initialize(self.context);
        
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(context.render_width,context.render_height), 2, 3, context.render_space_left2right, context.render_space_top2bottom);
end

-- 更新界面显示
function ShopItemPageView:update(list, pageIndex)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list, pageIndex);
end

function ShopItemPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(700-self.pageViewControl:getGroupBounds().size.width/2,25);
	end
end