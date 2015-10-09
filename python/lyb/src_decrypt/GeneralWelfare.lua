
require "main.view.huoDong.ui.render.GrowthFundItem"
GeneralWelfare = class(TouchLayer);

function GeneralWelfare:ctor()
	self.class = GeneralWelfare;
	self.Count = 0;
	self.refreshData = false;
end

function GeneralWelfare:dispose()
	self:removeAllEventListeners();
	self:removeChildren();
	GeneralWelfare.superclass.dispose(self);
	self.armature:dispose();
end

function GeneralWelfare:initialize( context, id)	
	
	self.context = context;
	self.id = id;
	self:initLayer();
	self.data = context.data;
	self.skeleton = context.skeleton;
	self.heroProxy = context.heroProxy;
	self.userProxy = context.userProxy;
	self.huodongProxy =  context.huodongProxy;

	local armature = self.skeleton:buildArmature("GeneralWelfare");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local armature_d = armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);
	--uninitializeSmallLoading


end

function GeneralWelfare:initScrollView()
	
	if nil == self.listScrollViewLayer then
		self.listScrollViewLayer =  ListScrollViewLayer.new();
		self.listScrollViewLayer:initLayer();
		self.listScrollViewLayer:setPositionX(15);
		self.listScrollViewLayer:setItemSize(makeSize(852, 120));
		self.listScrollViewLayer:setViewSize(makeSize(852, 365));
		self.armature_d:addChild(self.listScrollViewLayer);

		self.tab = self.data:getHuodongDataByID(self.id);		
		self.Count = self.tab[1].Count or 0;
		
		if self.tab ~= nil then 
			table.sort( self.tab, function(a,b) 
				if a.BooleanValue ==  b.BooleanValue then 
					return a.MaxCount < b.MaxCount
				end
				return  a.BooleanValue < b.BooleanValue  
				end);

			for k,v in pairs(self.tab) do
				local item = GrowthFundItem.new();
				item:initialize(self, v, self.id);
				self.listScrollViewLayer:addItem(item);
			end
		end
	end
end

function KaifuFund:replaceItem(newData, oldData)
	-- 替换领取的数据
	if oldData == nil or newData == nil or listview == nil then
		return;
	end
	local index = -1;
	for k,v in pairs(oldData) do
		if oldData.ConditionID == newData.ConditionID then
			index = k;
			oldData.BooleanValue =  1;
			break;
		end
	end

	if index == -1 then
		return;
	else
		self.listScrollViewLayer:removeItemAt(index - 1);
		local item = GrowthFundItem.new();
		item:initialize(self, newData, self.id);
		self.listScrollViewLayer:addItemAt(item, index - 1, true);
	end
end


function GeneralWelfare:initCount()

	if not self.refreshData then
		local count = self.Count;
		local div = 1000;
		for i=1,4 do
			local num = self.armature_d:getChildByName("num"..tostring(i));
			local num_pos = convertBone2LB(num);
			num.parent:removeChild(num,true);
			local bm = self.skeleton:getBoneTextureDisplay("num_".. tostring(math.floor(count/div)));
			bm:setPosition(num_pos);
			self.armature_d:addChild(bm);
			count = count%div;
			div = math.floor(div / 10);
		end
		self.refreshData = true;
	end
end

function GeneralWelfare:takeAward(conditionID)
  self.context.huodongProxy:takeAward(self.id, conditionID) 
end

function GeneralWelfare:refreshRaddot(  )
	print("function GeneralWelfare:refreshRaddot(  )")
	for k,v in pairs(self.tab) do
		print("v.BooleanValue", v.ConditionID, v.BooleanValue, v.Count, v.MaxCount);
		if v.BooleanValue == 0 and v.Count >= v.MaxCount then
			self.context.reddot2:setVisible(true);
			return;
		end
	end
	self.context.reddot2:setVisible(false);
end