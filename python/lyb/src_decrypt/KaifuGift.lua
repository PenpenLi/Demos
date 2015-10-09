require "main.view.huoDong.ui.render.KaifuGiftItem"
require "main.view.huoDong.ui.render.printTab"

KaifuGift = class (TouchLayer);

function KaifuGift:ctor(  )
	self.class = KaifuGift;
end

function KaifuGift:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	KaifuGift.superclass.dispose(self);
end

function KaifuGift:initialize(context, id)
	self.context = context;
	self.id = id;
	self.skeleton = context.skeleton;
	self.huodongProxy = context.huodongProxy;
	self:initLayer();
	self.data = context.data;

	local armature = self.skeleton:buildArmature("KaifuGift");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();

	self.armature = armature;
	self.armature_d = armature.display;
	self:addChild(self.armature_d);
	-- self:initScrollView();
end

function KaifuGift:initScrollView(  )
	if self.listScrollViewLayer == nil then 
		self.listScrollViewLayer = ListScrollViewLayer.new();
		self.listScrollViewLayer:initLayer();
		self.listScrollViewLayer:setPositionX(15);
		self.listScrollViewLayer:setItemSize(makeSize(852, 120));
		self.listScrollViewLayer:setViewSize(makeSize(852, 386));
		self.armature_d:addChild(self.listScrollViewLayer);
	else
		self.listScrollViewLayer:removeAllItems();
	end

	self.tab = self.huodongProxy:getHuodongDataByID(self.id);

	printTab(self.tab);

	print(" \n\nself.tab = self.data:getHuodongDataByID(5); count ", self.tab, self.tab.Count);
	if self.tab ~= nil then 
		-- table.sort( self.tab, function(a,b) return  a.MaxCount < b.MaxCount or a.BooleanValue < b.BooleanValue  end)
			table.sort( self.tab, function(a,b) 
				if a.BooleanValue ==  b.BooleanValue then 
					return a.MaxCount < b.MaxCount
				end
				return  a.BooleanValue < b.BooleanValue  end)
		for k,v in pairs(self.tab) do
			
			local item = KaifuGiftItem.new();
			print("item = ", item);
			item:initialize(self, v, self.id);
			self.listScrollViewLayer:addItem(item);
			-- table.insert(self.ItemTable, item);
		end
	end
	
end

function KaifuGift:refreshData( tem )
	local tab2 = self.huodongProxy:getHuodongDataByID(14);
	if #tab2 == 1 then
		-- 刷新数据
		print(" 29-2 check data")
		local index;
		for k,v in pairs(self.tab) do
			if v.ConditionID == tab2[1].ConditionID then
				index = k;
				v.BooleanValue = 1;
				break;
			end
		end
		self.listScrollViewLayer:removeItemAt(index - 1);
		local item = KaifuGiftItem.new();
		item:initialize(self, tab2[1], self.id);
		self.listScrollViewLayer:addItemAt(item, index - 1, true);

		local booleanValue = 0;
		for k,v in pairs(self.tab) do
			if v.Count == v.MaxCount and v.BooleanValue == 0 then
				booleanValue = 1;
				break;
			end
		end
		if booleanValue == 1 then
			self.context:renderDotVisible(self.id, true);
		else
			self.context:renderDotVisible(self.id, false);
		end
		self.huodongProxy:setReddotDataByID(self.id, booleanValue);
		self.context:refreshMainHuoDongReddot();

	else
		self:initScrollView();
	end

	
end