HalfPrice = class(TouchLayer)

function HalfPrice:ctor(  )
	self.class = HalfPrice;
end

function HalfPrice:dispose(  )
	self:removeAllEventListeners();
	self:removeChildren();
	HalfPrice.superclass.dispose(self);
end

function HalfPrice:initialize( context, day )
	self.context = context;
	self.day = day;
	self.skeleton = context.skeleton;
	self:initLayer();
	self.huodongProxy = context.huodongProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.userProxy = context.userProxy;
	self.bagProxy = context.bagProxy;
	
	self:getData();
	local armature = self.skeleton:buildArmature("halfprice_ui");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self.armature_d = armature.display;
	self:addChild(self.armature_d);
	self:initButton();
	self:initItem();
	self:initTargetText();
end
function HalfPrice:initTargetText(  )
	local textData = self.armature:getBone("target").textData;
	local text = analysis("Huodong_Yunyinghuodongtiaojian", self.data.Type, "miaoshu");
	local Param1 = self.data.Param1;
	local Param2 = self.data.Param2;
	local Param3 = self.data.Param3;
	local currentState = self.data.MaxCount;

	text = StringUtils:stuff_string_replace(text, "@1", Param1, 2);
	text = StringUtils:stuff_string_replace(text, "@2", Param2, 2);
	text = StringUtils:stuff_string_replace(text, "@3", Param3, 2);
	if self.text == nil then
		self.text = createMultiColoredLabelWithTextData(textData, text);
		self:addChild(self.text);
	else
		self.text:setString(text);
	end
end

function HalfPrice:initItem(  )

	if self.data.Param2 ~= nil then
		self.ItemId = analysis("Shangdian_Shangdianwupin", self.data.Param2, "itemid");
		self.ItemNum = analysis("Shangdian_Shangdianwupin", self.data.Param2, "count");

	else
		sharedTextAnimateReward():animateStartByString("获取道具失败~！");
		return;
	end

	local item = self.armature_d:getChildByName("item");
	local item_pos = convertBone2LB(item);
	self.itemImage = BagItem.new();
	self.itemImage:initialize({ItemId = self.ItemId, Count = self.ItemNum});
	self.itemImage:setPositionXY(item_pos.x + 8, item_pos.y + 8);
	self.armature_d:addChild(self.itemImage);
	self.itemImage.touchEnabled = true;
	self.itemImage.touchChildren = true;
	self.itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onClickItemBegin, self);
	self.itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onClickItemEnd, self);

	if self.data.Param2 ~= nil then
		local price = analysis("Shangdian_Shangdianwupin", self.data.Param2, "price");
		local discount = self.data.Param3;
		self.nowPrice = math.floor(price * discount / 100000);
		self:updateText(price, self.nowPrice);
	else
		sharedTextAnimateReward():animateStartByString("获取道具失败~！");
	end

end

function HalfPrice:onClickItemBegin( event )
	self.beginItemPosition = event.globalPosition;
end

function HalfPrice:onClickItemEnd( event )
	if self.beginItemPosition ~= nil then
		if math.abs( self.beginItemPosition.x - event.globalPosition.x ) < 20 
			and math.abs(self.beginItemPosition.y - event.globalPosition.y ) < 20 then
			self.context.context.context:dispatchEvent(Event.new("ON_ITEM_TIP",
																{item = event.target, nil ,nil, count = event.target.userItem.Count}
																, self));
		end
	end
end

function HalfPrice:getData()
	local dataTab = self.huodongProxy:getHuodongDataByID(self.day + 6);
	-- self.data = dataTab;
	if dataTab == nil then 
		return;
	end
	
	for k,v in pairs(dataTab) do
		if v.Group == 4 then
			self.data = v;
			print("----------------------------------------------------")
			for k,v in pairs(self.data.ItemIdArray) do
				print(k,v)
			end
			-- print("\n\n\n\n\n self.data------------- = ", self.data.ItemIdArray.ItemId, self.data.ItemIdArray.Count )
			break;
		end
	end
end

function HalfPrice:initButton(  )

	local buybtn = self.armature_d:getChildByName("buybtn");
	local buybtn_pos = convertBone2LB4Button(buybtn);
	self.armature_d:removeChild(buybtn);

	buybtn = CommonButton.new();
	buybtn:initialize("commonButtons/common_red_button_normal", "commonButtons/common_red_button_down", CommonButtonTouchable.BUTTON);
	print("self.data.BooleanValue = ", self.data.BooleanValue);
	if self.data.BooleanValue == 0 then
		buybtn:initializeBMText("购买", "anniutuzi");
	else
		buybtn:initializeBMText("购买", "anniutuzi");
		buybtn:setGray(true);
	end
	buybtn:setPosition(buybtn_pos);
	buybtn:addEventListener(DisplayEvents.kTouchTap, self.onClickBuybtn, self);
	self:addChild(buybtn); 
	self.buybtn = buybtn;

end

function HalfPrice:onClickBuybtn(  )

	if self.userCurrencyProxy:getGold() < self.nowPrice then
		print("gotocharge");
		self.context.context.context:dispatchEvent(Event.new("gotocharge", nil, self));
		return;
	end

	if self.userProxy:getVipLevel() < self.data.Param1 then
		sharedTextAnimateReward():animateStartByString("亲,您VIP等级不够哦~！");
		return;
	end

	local bagstate = self:getBagState(1);
	if bagstate == false then
		return;
	end

	local popup = CommonPopup.new();
	popup:initialize("确认购买？", self, self.onConfirmBuybtn);
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(popup);

end

function HalfPrice:onConfirmBuybtn(  )
	self.buybtn:setGray(true);
	sendMessage(29, 3, {ConditionID = self.data.ConditionID});
end

function HalfPrice:updateText(oldPrice, currentPrice)
	if self.yuanjia == nil then
		local yuanjia = self.armature:getBone("yuanjia").textData;
	    self.yuanjia = createTextFieldWithTextData(yuanjia, "原价："..oldPrice);
	    self:addChild(self.yuanjia);
	    self.yuanjia.touchEnabled = false;
	else
		self.yuanjia:setString("原价："..oldPrice)
	end

	if self.xianjia == nil then
	    local xianjia = self.armature:getBone("xianjia").textData;
	    self.xianjia = createTextFieldWithTextData(xianjia, "现价："..currentPrice);
	    self:addChild(self.xianjia);
	    self.xianjia.touchEnabled = false;
	else
		self.xianjia:setString("现价："..currentPrice);
	end

	if self.yuanjiaLine == nil then
	    local yuanjiaLine = self.armature:getBone("yuanjialine").textData;
	    self.yuanjiaLine = createTextFieldWithTextData(yuanjiaLine, "—————");
	    self:addChild(self.yuanjiaLine);
	end
end 
function HalfPrice:updateHarfPrice(selectDay, btn_index)
	print("function HalfPrice:updateHarfPrice(selectDay, btn_index)", selectDay, btn_index)
	self:getData();
	self.armature_d:removeChild(self.itemImage);
	self:initItem();
	if self.data.BooleanValue == 0 then
		self.buybtn:setGray(false);
	else
		self.buybtn:setGray(true);
	end

	self:initTargetText();
end

function HalfPrice:checkTackAward(selectDay, btn_index, checkdata)
	-- body
	print("function HalfPrice:checkTackAward(selectDay, btn_index, checkdata)")
	local data = self.huodongProxy:getHuodongDataByID(selectDay + 6);

	for k,v in pairs(data) do
		if v.Group == 4 and v.ConditionID == checkdata[1].ConditionID then
			data[k] = checkdata[1];
		end
	end

end

function HalfPrice:getBagState(num)

  print("function HalfPrice:getBagState(num) ", num)
  local bagIsFull = self.bagProxy:getBagIsFull();
  if bagIsFull then 
    sharedTextAnimateReward():animateStartByString("亲，您的背包已满哦~！");
    return false;
  end
  local leftPlaceCount = self.bagProxy:getBagLeftPlaceCount();
  print("function HalfPrice:getBagState(num)", num,leftPlaceCount)

  if num > leftPlaceCount then
    sharedTextAnimateReward():animateStartByString("亲，您的背包空间不足哦~！");
    return false;
  end
  return true;
end