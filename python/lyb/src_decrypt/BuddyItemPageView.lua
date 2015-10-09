require "core.controls.page.CommonPageView";
require "main.view.buddy.ui.buddyPopup.BuddyItemSlot";

BuddyItemPageView = class(CommonPageView);

-- 初始化
function BuddyItemPageView:initialize(context, datas)
	self.context = context;
	self.datas = datas;

	local curIndex = 1;
	local function createSlotCallback()
        log("ShopTestSlot:create #items", #self.datas);
        local itemPo = self.datas[curIndex];
        curIndex = curIndex + 1;
        if itemPo then
        	local item = BuddyItemSlot.new();
        	item:initialize(self.context, itemPo);
        	log("createSlotCallback " .. (-1 + curIndex));
			return item;
		else
			log("itemPo is nil;");
        end
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(476,141), 3, 2, 20, 20);
	self:update(self.datas);
end

-- 更新界面显示
function BuddyItemPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end