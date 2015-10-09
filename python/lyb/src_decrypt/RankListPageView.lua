require "core.controls.page.CommonPageView";

RankListPageView = class(CommonPageView);

-- 初始化
function RankListPageView:initialize(context)
	self.context = context;
	
	local curIndex = 1;
	local function createSlotCallback()
        log("RankListPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = RankListSlot.new();
        item:initialize(self.context);
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(1100,600), 1, 1, 10, 10);
end

-- 更新界面显示
function RankListPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end