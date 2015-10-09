require "core.controls.page.CommonPageView";
require "main.view.shadow.ui.heroImage.ShadowItemSlot";

ShadowItemPageView = class(CommonPageView);

-- 初始化
function ShadowItemPageView:initialize(context)
	self.context = context;
	self.slot=ShadowItemSlot.new()
	local curIndex = 1;
	local function createSlotCallback()
        log("ShadowItemPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = ShadowItemSlot.new();
        item:initialize(self.context);
        table.insert(self.context.renders, item);
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(205,100), 1, 5, 5, 0);
end

-- 更新界面显示
function ShadowItemPageView:update(list, pageIndex)
	self:updateData(list, pageIndex);
end

function ShadowItemPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(700-self.pageViewControl:getGroupBounds().size.width/2,25);
	end
end