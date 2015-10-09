require "core.controls.page.CommonPageView";
require "main.view.guanzhi.ui.guanzhiPopup.GuanzhiItemSlot";

GuanzhiPageView = class(CommonPageView);

-- 初始化
function GuanzhiPageView:initialize(context)
	self.context = context;
	
	local curIndex = 1;
	local function createSlotCallback()
        log("GuanzhiPageView:create #items:" .. curIndex);
        curIndex = curIndex + 1;
        local item = GuanzhiItemSlot.new();
        item:initialize(self.context);
		return item;
	end

	local _tb = analysisTotalTable("Shili_Guanzhi");
	local _temp = {};
	local _count = 1;--0
	for k,v in pairs(_tb) do
		_count = 1 + _count;
		table.insert(_temp,_count);
	end
	table.remove(_temp,table.getn(_temp));
	CommonPageView.initialize(self, createSlotCallback, makeSize(190,486), 1, 5, 10, 20);
	self:update(_temp);
end

-- 更新界面显示
function GuanzhiPageView:update(list)
	if not list or table.getn(list) == 0 then
		return;
	end
	self:updateData(list);
end

function GuanzhiPageView:initializePageViewControl(dotHeight)
	PageView.initializePageViewControl(self, dotHeight);
	if self.pageViewControl then
		local position = self.pageViewControl:getPosition();
		self.pageViewControl:setPositionXY(640-self.pageViewControl:getGroupBounds().size.width/2,25);
	end
end