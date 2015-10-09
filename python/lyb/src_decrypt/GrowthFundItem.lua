GrowthFundItem = class(ListScrollViewLayerItem);

function GrowthFundItem:ctor(  )
	self.class = GrowthFundItem;
end

function GrowthFundItem:dispose(  )
	-- body
	self:removeAllEventListeners();
	GrowthFundItem.superclass.dispose(self);
end

function GrowthFundItem:initialize( context, data, ID, IsBuyFund )
	self.context = context;
	self.data = data;
	self:initLayer();
	self.skeleton = context.skeleton;
	self.ID = ID;
	self.heroProxy = context.heroProxy;
	self.userProxy = context.userProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.huodongProxy = context.huodongProxy;
	self.IsBuyFund = IsBuyFund;
	-- print("\n\n\n\n \n self.ID = ", self.ID, self.data.ConditionID, self.data.BooleanValue);
end

function GrowthFundItem:onInitialize()

	print("function GrowthFundItem:onInitialize()")
	local armature = self.skeleton:buildArmature("fundItem_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local armature_d = armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);

	local description = analysis("Huodong_Yunyinghuodongtiaojian", self.data.Type, "miaoshu");
	description = StringUtils:stuff_string_replace(description, "@1", self.data.Param1, 2);

	local textData = self.armature:getBone("text1").textData;
	self.text = createMultiColoredLabelWithTextData(textData, description);
	self.armature_d:addChild(self.text);

	self:initItem();
	self:initButton();
end

function GrowthFundItem:initItem(  )
	self.item = {};
	for i=1,1 do
		local item = self.armature_d:getChildByName("item"..i);
		local item_pos = convertBone2LB(item);
		self.armature_d:removeChild(item);
		item =  CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid");
		item:setScale(0.9);
		item:setPosition(item_pos);
		self.armature_d:addChild(item);
		item:setVisible(false);
		self.item[i] = {item =  item, item_pos = item_pos};
	end

	self.itemImage = {};
	for k,v in pairs(self.data.ItemIdArray) do
		self.item[k].item:setVisible(true);
		local itemImage = BagItem.new();
		itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
		itemImage:setScale(0.9);
		itemImage:setPositionXY(self.item[k].item_pos.x + 8, self.item[k].item_pos.y + 8);
		self.armature_d:addChild(itemImage);
		itemImage.touchEnabled = true;
		itemImage.touchChildren = true;
		itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);
		itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemEnd, self);
	end

end

function GrowthFundItem:onItemTip( event )
	self.tipItemBegin = event.globalPosition;
end

function GrowthFundItem:onItemEnd( event )
	if self.tipItemBegin ~= nil 
		and math.abs(event.globalPosition.x - self.tipItemBegin.x) < 20 
		and math.abs(event.globalPosition.y - self.tipItemBegin.y) < 20 then

		self.context.context.context:dispatchEvent(Event.new("ON_ITEM_TIP", 
													{item = event.target, nil, nil, count = event.target.userItem.Count},
													 self));
	end

end

function GrowthFundItem:initButton(  )

	self.award1 = self.armature_d:getChildByName("award1");
	local btnData=self.armature:findChildArmature("btn"):getBone("common_small_blue_button").textData;
	print("btnData = ", btnData);
 	local btn = self.armature_d:getChildByName("btn");
 	local btn_pos = convertBone2LB4Button(btn);
 	self.armature_d:removeChild(btn);
 	self.btn = CommonButton.new();
 	self.btn:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
	self.btn:initializeText(btnData, "领取", true);
 	self.btn:setPosition(btn_pos);
 	
 	print(" data = ", self.data.BooleanValue, self.data.Count, self.data.MaxCount, self.data.ConditionID);
 	if self.data.BooleanValue == 1 then
 		self.award1:setVisible(false);
 		self.btn:setGray(true);
 		self.btn:refreshText("已领取")
 	elseif self.data.Count >= self.data.MaxCount then
 		self.btn:setGray(false);
 		self.btn:refreshText("领取")
 		self.award1:setVisible(false);
 		self.btn:addEventListener(DisplayEvents.kTouchTap, self.onClickBtn, self);
 	elseif self.data.Count < self.data.MaxCount then
 		self.award1:setVisible(true);
 		self.btn:setVisible(false);
 	end
	self.armature_d:addChild(self.btn);	
end


function GrowthFundItem:onClickBtn(event)

	if self.ID == 5 and self.context.data.IsBuyFund == 0 then
		sharedTextAnimateReward():animateStartByString("亲，购买了基金才能领取哦~！");
		return;
	end

	local bagstate = self.context.context.context:getBagState(#self.data.ItemIdArray);
  	if bagstate == false then
    	return;
  	end

	self.data.BooleanValue = 1;
	self.context:refreshRaddot();
	self.context.context:takeAward(self.data.ConditionID);
	sendMessage(29, 3, {ConditionID = self.data.ConditionID});
	self.award1:setVisible(false);
	sharedTextAnimateReward():animateStartByString("领取奖励成功~！");
	self.btn:setGray(true);
	self.btn:refreshText("已领取");
	-- self:removeChild(self.buttonEffect);

end