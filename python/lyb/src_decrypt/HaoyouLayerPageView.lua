require "core.controls.page.CommonPageView";

HaoyouLayerPageView = class(CommonPageView);

-- 初始化
function HaoyouLayerPageView:initialize(context, datas)
	self.context = context;
	self.datas = datas;

	local curIndex = 1;
	local function createSlotCallback()
        log("ShopTestSlot:create #items", #self.datas);
        local itemPo = self.datas[curIndex];
        curIndex = curIndex + 1;
        if itemPo then
        	local item = HaoyouLayerItemSlot.new();
        	item:initialize(self.context);
        	log("createSlotCallback " .. (-1 + curIndex));
			return item;
		else
			log("itemPo is nil;");
        end
	end

	CommonPageView.initialize(self, createSlotCallback, makeSize(259,253), 2, 4, 5, 10);
	self:update(self.datas);
end

-- 更新界面显示
function HaoyouLayerPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end