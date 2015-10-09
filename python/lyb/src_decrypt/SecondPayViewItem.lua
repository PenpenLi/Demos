SecondPayViewItem = class(ListScrollViewLayerItem);

function SecondPayViewItem:ctor(  )
	self.class = SecondPayViewItem;
	self.itemCount = 0;--多少个item
	self.item = {};
	self.itemImage = {};
end

function SecondPayViewItem:dispose(  )
	self:removeAllEventListeners();
	SecondPayViewItem.superclass.dispose(self);
end

function SecondPayViewItem:initialize(context,  ID,  data)
	self.context = context;
	self:initLayer();
	self.id = ID;
	self.skeleton = context.skeleton;
	self.huodongProxy = context.huodongProxy;
	self.UserCurrencyProxy = context.UserCurrencyProxy;
	self.data = data	;

	local armature = self.skeleton:buildArmature("render");	
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;
	self.armature_d = armature.display;
	self:addChild(self.armature_d);	
	self:initButton();
	self:initText();
	self:initItem();
end

function SecondPayViewItem:initText(  )
	local textData = self.armature:getBone("target").textData;
	local text = analysis("Huodong_Yunyinghuodongtiaojian", self.data.Type, "miaoshu");
	local Param1 = self.data.Param1;
	local Param2 = self.data.Param2;
	local Param3 = self.data.Param3;
	local currentState = self.data.MaxCount;
	text = StringUtils:stuff_string_replace(text, "@1", Param1, 2);
	-- text = StringUtils:stuff_string_replace(text, "@2", Param2, 2);
	-- text = StringUtils:stuff_string_replace(text, "@3", Param3, 2);
	text = StringUtils:stuff_string_replace(text, "@4", " ( "..self.data.Count.." / "..self.data.MaxCount.." )", 2)
	self.text = createMultiColoredLabelWithTextData(textData, text);
	self:addChild(self.text);
end

function SecondPayViewItem:initItem(  )
	print("\n\n\nself.data.ItemIdArray = ", #self.data.ItemIdArray)
	self.itemCount = #self.data.ItemIdArray;
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
	for i=1, self.itemCount do
		self.item[i].item:setVisible(true);
		self.itemImage[i] = BagItem.new();
		self.itemImage[i]:initialize({ItemId = self.data.ItemIdArray[i].ItemId, Count = self.data.ItemIdArray[i].Count});
		self.itemImage[i]:setScale(0.9);
		self.itemImage[i]:setPositionXY(self.item[i].item_pos.x + 6, self.item[i].item_pos.y + 8);
		self.armature_d:addChild(self.itemImage[i]);
		self.itemImage[i].touchEnabled = true;
		self.itemImage[i].touchChildren = true;
		self.itemImage[i]:addEventListener(DisplayEvents.kTouchBegin, self.onItemBegin, self);
		self.itemImage[i]:addEventListener(DisplayEvents.kTouchEnd, self.onItemEnd, self);
	end

end

function SecondPayViewItem:onItemBegin( event )
	self.beginItemPosition = event.globalPosition;
end

function SecondPayViewItem:onItemEnd( event )
	if self.beginItemPosition ~= nil 
		and math.abs( self.beginItemPosition.x - event.globalPosition.x ) < 20 
		and math.abs( self.beginItemPosition.y - event.globalPosition.y ) < 20   then
		self.context:dispatchEvent(Event.new("ON_ITEM_TIP", 
													{item = event.target, nil, nil, count = event.target.userItem.Count},
													 self));
	end
end


function SecondPayViewItem:initButton()

	local gotochargeData=self.armature:findChildArmature("btn"):getBone("common_small_blue_button").textData;
	local gotocharge = self.armature_d:getChildByName("btn");
	local gotocharge_pos = convertBone2LB4Button(gotocharge);
	self.armature_d:removeChild(gotocharge);
	self.gotocharge = CommonButton.new();
	self.gotocharge:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
	self.gotocharge:initializeText(gotochargeData, "充值", true);
	self.gotocharge:setPosition(gotocharge_pos);
	self.gotocharge:addEventListener(DisplayEvents.kTouchTap, self.onClickBtn, self);
	self.armature_d:addChild(self.gotocharge);
	self:updateButton();
end

function SecondPayViewItem:updateButton(  )
	print("================-------------------self.data.Count = ", self.data.Count , self.data.MaxCount)
	if self.data.Count == self.data.MaxCount then 
		if self.data.BooleanValue == 0 then
			--可领取
			self.gotocharge:setGray(false);
			self.gotocharge:refreshText("领取");	
		else
			--已领取
			self.gotocharge:setGray(true);
			self.gotocharge:refreshText("已领取");
		end
	else
		-- --去充值
		self.gotocharge:setGray(false);
		self.gotocharge:refreshText("去充值");
		
	end
end

function SecondPayViewItem:onClickBtn()
	print("function KaifuGiftItem:onClickBtn()");
	if self.data.Count ~= self.data.MaxCount then
		self.context:dispatchEvent(Event.new("SecondPayToChongZhi",nil,self));
	else
		self:takeAward();
	end
end
function SecondPayViewItem:takeAward()
	local bagstate = self.context:getBagState(#self.data.ItemIdArray);
	if bagstate == false then
		return;
	end
	self.huodongProxy:takeAward(self.id, self.data.ConditionID);
	sendMessage(29, 3, {ConditionID = self.data.ConditionID});  
	print("self.data.ConditionID = ", self.data.ConditionID);
end