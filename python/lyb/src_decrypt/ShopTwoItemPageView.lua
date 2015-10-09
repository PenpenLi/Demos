require "core.controls.page.CommonPageView";
require "main.view.shopTwo.ui.ShopTwoItemSlot";

ShopTwoItemPageView = class(CommonPageView);

-- 初始化
function ShopTwoItemPageView:initialize(context)
	self.context = context;
	self.slot=ShopTwoItemSlot.new()
	local curIndex = 1;
	local function createSlotCallback()
        log("ShopTwoItemPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = ShopTwoItemSlot.new();
        item:initialize(self.context);
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(context.render_width,context.render_height), 2, 3, context.render_space_left2right, context.render_space_top2bottom);
end

-- 更新界面显示
function ShopTwoItemPageView:update(list,pageindex)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list,pageindex);
end

function ShopTwoItemPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(700-self.pageViewControl:getGroupBounds().size.width/2,25);
	end
end