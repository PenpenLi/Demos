require "main.view.huoDong.ui.render.GrowthFundItem"

KaifuFund = class(TouchLayer);

function KaifuFund:ctor()
	self.class = KaifuFund;
	self.ItemTable = {};
	self.count = 0;
	self.IsBuyFund = 0;
end

function KaifuFund:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	KaifuFund.superclass.dispose(self);
	self.armature:dispose();
end

function KaifuFund:initialize(context, id )
	-- body
	self.context = context;
	self.id = id;
	self:initLayer();
	self.data = context.data;
	
	self.skeleton = context.skeleton;
	self.heroProxy = context.heroProxy;
	self.userProxy = context.userProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	local armature = self.skeleton:buildArmature("KaifuFund");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local  armature_d = armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);

	self:initButton();
	self:initScrollView();


end

function KaifuFund:refreshData( )
	self.tab2 = self.context.huodongProxy:getData2();

	if(#self.tab[1].ActivityConditionArray ~= 1) then

	end
end

function KaifuFund:initButton()
	-- body
--购买按钮
	-- local buybuttonData=self.armature:findChildArmature("buybutton"):getBone("common_small_blue_button").textData;
	self.buybutton = self.armature_d:getChildByName("buybutton");
	self.buybutton_pos = convertBone2LB4Button(self.buybutton);
	self.armature_d:removeChild(self.buybutton);

	self.buybutton = CommonButton.new();
	self.buybutton:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);

	self.IsBuyFund = self.data.IsBuyFund;
	print("\n\n\n\nKaifuFund self.IsBuyFund = ", self.data.IsBuyFund);
	local text_data = self.armature:findChildArmature("buybutton"):getBone("common_small_red_button").textData;
	if self.IsBuyFund ~= 0 then
		self.buybutton:initializeBMText("已购买","anniutuzi");
		self.buybutton:setGray(true,false);
	else
		self.buybutton:initializeBMText("购买","anniutuzi");

	end
	self.buybutton:setPositionXY(self.buybutton_pos.x, self.buybutton_pos.y);
	self:addChild(self.buybutton);
	self.buybutton:addEventListener(DisplayEvents.kTouchTap, self.onClickBuybutton, self);

end

function KaifuFund:onClickBuybutton()	
	--请求购买基金
	if not self.userProxy:getIsVip() or self.userProxy:getVipLevel() < 2 then 
		sharedTextAnimateReward():animateStartByString("亲，VIP2等级以上才可以购买哦~！");
		return;
	end

  	local popup=CommonPopup.new();
  	popup:initialize("确认购买成长基金吗？参与成长计划可获得500%成长返利哦！", self, self.onConfirmBuyFund, nil, nil, nil, nil, nil,nil, true)
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(popup);

end

function KaifuFund:onConfirmBuyFund(  )

	local money = analysis("Xishuhuizong_Xishubiao",1084,"constant");
	local gold = self.userCurrencyProxy:getGold();
	if (gold < money) then
		local popup=CommonPopup.new();
	  	popup:initialize("元宝不足，请充值~！", self, self.onConfirmchongzhi, nil, nil, nil, nil, nil,nil, true)
		sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(popup);
	else
		sendMessage(29, 6);
		self.buybutton:setGray(true, false);
		self.listScrollViewLayer:removeAllItems();
		self.listScrollViewLayer = nil;
		sendMessage(29,2, {ID = 5});
	end
end

function KaifuFund:onConfirmchongzhi()
	-- self.context:dispatchEvent(Event.new("huoDonggoToChongzhi",nil,self));
	self.context.context:dispatchEvent(Event.new("huoDonggoToChongzhi",nil,self));
end

function KaifuFund:initScrollView()
	if nil == self.listScrollViewLayer then 
		self.listScrollViewLayer=ListScrollViewLayer.new();
		self.listScrollViewLayer:initLayer();
		self.listScrollViewLayer:setPositionX(15);
		self.listScrollViewLayer:setItemSize(makeSize(852,120));
		self.listScrollViewLayer:setViewSize(makeSize(852, 365));
		self.armature_d:addChild(self.listScrollViewLayer);
	end

	self.tab = self.data:getHuodongDataByID(self.id);
	print(" \n\nself.tab = self.data:getHuodongDataByID(5); count ", self.tab, self.tab.Count);
	if self.tab ~= nil then 
		-- table.sort( self.tab, function(a,b) return  a.MaxCount < b.MaxCount or a.BooleanValue < b.BooleanValue  end)
			table.sort( self.tab, function(a,b) 
				if a.BooleanValue ==  b.BooleanValue then 
					return a.MaxCount < b.MaxCount
				end
				return  a.BooleanValue < b.BooleanValue  end)
		for k,v in pairs(self.tab) do
			print("init GrowthFundItem")
			local item = GrowthFundItem.new();
			item:initialize(self, v, self.id, self.data.IsBuyFund);
			self.listScrollViewLayer:addItem(item);
			-- table.insert(self.ItemTable, item);
		end
	end
	-- self:refreshRaddot();
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
		item:initialize(self, newData, self.id, self.data.IsBuyFund);
		self.listScrollViewLayer:addItemAt(item, index - 1, true);
	end
end

function KaifuFund:refreshRaddot(  )
	print("function KaifuFund:refreshRaddot(  )")
	for k,v in pairs(self.tab) do
		print("v.BooleanValue", v.ConditionID, v.BooleanValue, v.Count, v.MaxCount);
		if v.BooleanValue == 0 and v.Count >= v.MaxCount then
			self.context.reddot1:setVisible(true);
			return;
		end
	end
	self.context.reddot1:setVisible(false);
end