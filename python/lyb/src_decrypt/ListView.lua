require "main.view.SevenDays.ui.render.ViewItem"
ListView = class(TouchLayer);

function ListView:ctor(  )
	self.clss =  ListView;
	self.listScrollViewLayers = {};
end

function ListView:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	ListView.superclass.dispose(self);
	self.armature:dispose();
end

function ListView:initialize(context, day, btn)
	log("function ListView:initialize(context, day, btn)")
	self.context = context;
	self.day = day;
	self.btn = btn;
	self.skeleton = context.skeleton;
	self.render1_pos = context.render1_pos;--滑动列表位置
	self.render2_pos = context.render2_pos;
	self.rightbg_pos = context.rightbg_pos;
	self.armature = context.armature;
	self.armature_d = self.armature.display;
	self.huodongProxy = context.huodongProxy;
	self.bagProxy = context.bagProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.data = self.huodongProxy:getHuodongDataByID(self.day + 6);
	

	self:initLayer();
	--self:initScrollView();
	self:updateListView(self.day, 1);

end

function ListView:updateListView( day ,btn)
	log("function ListView:updateListView( day ,btn)".. day .. " ".. btn);
	local index = btn;
	self.day = day;

	local count = self.day + index ;
	
	print("\n\nday index = " , day, index )
	for i=1,3 do
		if self.listScrollViewLayers[i] ~= nil then
			if i ~= btn  then
				self.listScrollViewLayers[i]:setVisible(false);
			else
				self.listScrollViewLayers[i]:setVisible(true);
			end
		end
	end

	if nil == self.listScrollViewLayers[index] then
		self.listScrollViewLayers[index] = ListScrollViewLayer.new();
		self.listScrollViewLayers[index]:initLayer();
		self.listScrollViewLayers[index]:setPositionXY(self.rightbg_pos.x + 11, self.rightbg_pos.y);
		self.listScrollViewLayers[index]:setItemSize(makeSize(636, 132));
		self.listScrollViewLayers[index]:setViewSize(makeSize(658, 474));
		-- self.listScrollViewLayers[index]:setItemAnchorPoint(ccp(0.5, 0.5));
		self.armature_d:addChild(self.listScrollViewLayers[index]);
		
	else
		self.listScrollViewLayers[index]:removeAllItems(true);

	end

	listTable = self.huodongProxy:getHuodongDataByID(self.day + 6);
	self.listTable = listTable;

	if listTable == nil then
		sharedTextAnimateReward():animateStartByString("获取开服七天乐活动数据失败~！")
		return
	end

	local function sortListTab()
		--系统默认算法是不稳定排序。采用冒泡排序进行修改
		print("sortListTab----", #listTable)
		for i=#listTable-1, 1, -1 do
			for j=1,i do
				if listTable[j].BooleanValue > listTable[j+1].BooleanValue then
					-- 交换，已领取放后面
					listTable[j], listTable[j+1] = listTable[j+1], listTable[j]
				elseif listTable[j].BooleanValue == listTable[j+1].BooleanValue 
					and listTable[j].Count < listTable[j].MaxCount 
					and listTable[j+1].Count >= listTable[j+1].MaxCount then
					-- 未领取的放后面
					listTable[j], listTable[j+1] = listTable[j+1], listTable[j]
				end
			end
		end
	end
	sortListTab();

	for k,v in pairs(self.listTable) do
		-- print("listTable ", k, v,"v.ItemIdArray = ", v.ItemIdArray ,"v.Group = ",v.Group, v)
		print("listTable = ",v.Group, v.BooleanValue, v.Count, v.MaxCount);
		if btn == v.Group then
			local item = ViewItem.new();
			item:initialize(self, index, self.day, v);
			self.listScrollViewLayers[index]:addItem(item);
		end	
	end
end

function ListView:checkTackAward(day, btn, checkdata)

	print(" function ListView:checkTackAward(day, btn, checkdata)", day,btn, checkdata[1].ConditionID);
	local listTable2 = checkdata;

	if listTable2 == nil then
		sharedTextAnimateReward():animateStartByString("获取开服七天乐活动数据失败~！")
		return
	end

	local pindex;

	for k,v in pairs(self.listTable) do
		print("ConditionID = ", v.ConditionID, listTable2[1].ConditionID);
		if v.ConditionID == listTable2[1].ConditionID then
			pindex = i;
			self.listTable[k] = listTable2[1];
			break;
		end
	end
	if pindex == nil then
		return;
	end

	self.listScrollViewLayers[btn]:removeItemAt(pindex - 1);
	print(" pindex = ", pindex);
	local item =  ViewItem.new();
	item:initialize(self, btn, day, listTable2[1]);
	self.listScrollViewLayers[index]:addItemAt(item, pindex - 1, true);
end