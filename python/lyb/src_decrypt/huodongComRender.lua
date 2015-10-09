
huodongComRender=class(TouchLayer);

function huodongComRender:ctor()
	self.class=huodongComRender;
end

function huodongComRender:dispose()
  	self:removeAllEventListeners();
 	huodongComRender.superclass.dispose(self);
end

function huodongComRender:initialize(context,data)
	self.data=data
	self.context=context
	self:initLayer();
	self.skeleton = context.skeleton
	local armature= self.skeleton:buildArmature("huodongComItem");

	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	local armature_d=armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);

	local textContent = analysis("Huodong_Yunyinghuodongtiaojian", data.Type, "miaoshu");
	textContent = StringUtils:stuff_string_replace(textContent, "@1", data.Param1, 2);

	self.target=createMultiColoredLabelWithTextData(armature:getBone("text1").textData, textContent);
	armature_d:addChild(self.target)
		
	-- self:initItemList();
	self:initItem();
	self:initButton();

end
function huodongComRender:initButton(  )
	self.award1 = self.armature_d:getChildByName("award1");
	local btnData=self.armature:findChildArmature("btn"):getBone("common_small_blue_button").textData;
	-- print("btnData = ", btnData);
	local btn = self.armature_d:getChildByName("btn");
	local btn_pos = convertBone2LB4Button(btn);
	self.armature_d:removeChild(btn);
	self.btn = CommonButton.new();
	self.btn:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
	self.btn:initializeText(btnData, "领取", true);
	self.btn:setPosition(btn_pos);
	self.btn:addEventListener(DisplayEvents.kTouchTap, self.onClickBtn, self);

	-- print(" data = ", self.data.BooleanValue, self.data.Count, self.data.MaxCount, self.data.ConditionID);
	if self.data.BooleanValue == 1 then
		self.award1:setVisible(false);
		self.btn:setGray(true);
		self.btn:refreshText("已领取")
	elseif self.data.Count >= self.data.MaxCount then
		self.btn:setGray(false);
		self.btn:refreshText("领取")
		self.award1:setVisible(false);
	elseif self.data.Count < self.data.MaxCount then
		self.award1:setVisible(true);
		self.btn:setVisible(false);
	end
	self.armature_d:addChild(self.btn); 
end

function huodongComRender:initItemList(  )
	if self.ItemList == nil then
		self.ItemList = ListScrollViewLayer.new();
		self.ItemList:initLayer();
		self.ItemList:setItemSize(makeSize(96, 96));
		self.ItemList:setViewSize(makeSize(390, 96));
		self.ItemList:setPositionXY(295, 12);
		self.ItemList:setDirection(kCCScrollViewDirectionHorizontal)
		self.ItemList:setMoveEnabled(false);
		-- self.armature_d:addChild(self.ItemList);

	end

end

function huodongComRender:initItem()
  self.item = {};
  for i=1,3 do
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
  	-- print(" itemID = ", v.ItemId);
  	-- local  index = (k + 3) % 3 + 1;
  	-- print(" ItemId = ", v.ItemId)
  	local index = k;
    self.item[index].item:setVisible(true);
    local itemImage = BagItem.new();
    itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
    itemImage:setScale(0.9);
    itemImage:setPositionXY(self.item[index].item_pos.x + 6, self.item[index].item_pos.y + 8);
    self.armature_d:addChild(itemImage);
    -- self.ItemList:addItem(itemImage);
    itemImage.touchEnabled = true;
    itemImage.touchChildren = true;
    itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);
    itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTipEnd, self);
  end
  -- self.armature_d:addChild(self.ItemList);
end



function huodongComRender:onClickBtn(event)

	local bagstate = self.context.context:getBagState(#self.data.ItemIdArray);
	if bagstate == false then
	    return;
	end
    self.context:takeAward(self.data.ConditionID);
    sendMessage(29,3,{ConditionID=self.data.ConditionID})

  
end

function huodongComRender:onItemTip(event)
  self.tapitembegin=event.globalPosition
end

function huodongComRender:onItemTipEnd(event)
  if self.tapitembegin and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
    self.context.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
  end
end