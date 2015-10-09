
require "core.controls.page.CommonPageView";
require "main.view.tianXiang.ui.TianXiangItemSlot";

TianXiangPageView = class(CommonPageView);

-- 初始化
function TianXiangPageView:initialize(context)
	self.context = context;
	
	local curIndex = 1;
	local function createSlotCallback()
        log("!!!!!!!!!!!!!!!!!createSlotCallback TianXiangPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = TianXiangItemSlot.new();
        item:initialize(self.context);
        table.insert(self.context.renders, item);

		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, CCSizeMake(1100, self.context.mainSize.height), 1, 1, 0, 0);
end

-- 更新界面显示
function TianXiangPageView:update(list, index)
	if not list or table.getn(list) == 0 then
		return;
	end
	print("updateData")
	self:updateData(list, index);
end

-- function TianXiangPageView:initializePageViewControl(dotHeight)
-- 	PageView.initializePageViewControl(self, dotHeight);
-- 	if self.pageViewControl then
-- 		local position = self.pageViewControl:getPosition();
-- 		self.pageViewControl:setPositionXY(700-self.pageViewControl:getGroupBounds().size.width/2,25);
-- 	end
-- end
