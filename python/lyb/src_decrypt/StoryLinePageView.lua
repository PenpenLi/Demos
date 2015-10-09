require "core.controls.page.CommonPageView";
require "main.view.storyLine.ui.StoryLineItemSlot";

StoryLinePageView = class(CommonPageView);

-- 初始化
function StoryLinePageView:initialize(context)
	self.context = context;
	
	local curIndex = 1;
	local function createSlotCallback()
        log("!!!!!!!!!!!!!!!!!createSlotCallback StoryLinePageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = StoryLineItemSlot.new();
        item:initialize(self.context);
		return item;
	end

	CommonPageView.initialize(self, createSlotCallback, self.context.mainSize, 1, 1, 0, 0);
end

-- 更新界面显示
function StoryLinePageView:update(list, index)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list, index);
end

function StoryLinePageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(640-self.pageViewControl:getGroupBounds().size.width/2,10);
	end
end