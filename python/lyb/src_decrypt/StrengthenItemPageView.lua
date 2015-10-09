require "core.controls.page.CommonPageView";
require "main.view.strengthen.ui.strengthenPopup.StrengthenItemSlot";

StrengthenItemPageView = class(CommonPageView);

-- 初始化
function StrengthenItemPageView:initialize(context, count, isHeroBag)
	self.context = context;
	self.datas = {};
	local _count =0;
	if isHeroBag and 6 > count then
		count = 6;
	end
	while count > _count do
		_count = 1 + _count;
		table.insert(self.datas, _count);
	end
	
	local curIndex = 1;
	local function createSlotCallback()
        log("StrengthenItemPageView:create #items", #self.datas);
        local itemPo = self.datas[curIndex];
        curIndex = curIndex + 1;
        if itemPo then
        	local item = StrengthenItemSlot.new();
        	item:initialize(self.context, isHeroBag);
        	log("createSlotCallback " .. (-1 + curIndex));
			return item;
		else
			log("itemPo is nil;");
        end
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(106,106), 3, 3, 35, 35);
	self:update(self.datas);
end

-- 更新界面显示
function StrengthenItemPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end