require "core.controls.page.CommonPageView";
require "main.view.bag.ui.bagPopup.BagItemSlot";

BagItemPageView = class(CommonPageView);

-- 初始化
function BagItemPageView:initialize(context, tab_num)
	self.context = context;
	self.tab_num = tab_num;

	local curIndex = 1;
	local function createSlotCallback()
        log("BagItemPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = BagItemSlot.new();
        item:initialize(self.context, self.tab_num);
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(106,106), 4, 4, 10, 10);
end

-- 更新界面显示
function BagItemPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end

function BagItemPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(310-self.pageViewControl:getGroupBounds().size.width/2,100);
	end
end