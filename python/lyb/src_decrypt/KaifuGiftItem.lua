KaifuGiftItem = class(ListScrollViewLayerItem);

function KaifuGiftItem:ctor(  )
	self.class = KaifuGiftItem;
end

function KaifuGiftItem:dispose(  )

	self:removeAllEventListeners();
	KaifuGiftItem.superclass.dispose(self);
end

function KaifuGiftItem:initialize( context, data, id )
	self.context = context;
	self.id = id;
	self.skeleton = context.skeleton;
	self.huodongProxy = context.huodongProxy;
	self.data = data;
	self:initLayer();
	self.ItemIdArray = self.data.ItemIdArray;

end

function KaifuGiftItem:onInitialize(  )

	local armature = self.skeleton:buildArmature("render1");
	armature.animation:gotoAndPlay("f1");
	armature:updateBonesZ();
	armature:update();
	self.armature = armature;

	local armature_d = armature.display;
	self.armature_d = armature_d;
	self:addChild(armature_d);

	self:updateText();
	self:initButton();
	self:initItem();
end
function KaifuGiftItem:initItem(  )
	-- local function fixIndex( index)
	-- 	--优先填充中间item

	-- end 
	-- 初始化物品
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
	for k,v in pairs(self.ItemIdArray) do
		self.item[k].item:setVisible(true);
		local itemImage = BagItem.new();
		itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
		itemImage:setScale(0.9);
		itemImage:setPositionXY(self.item[k].item_pos.x + 6, self.item[k].item_pos.y + 8);
		self.armature_d:addChild(itemImage);
		itemImage.touchEnabled = true;
		itemImage.touchChildren = true;
		itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onItemTip, self);
		itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onItemTipEnd, self);
	end
end


function KaifuGiftItem:onItemTip(event)
  self.tapitembegin=event.globalPosition
end

function KaifuGiftItem:onItemTipEnd(event)
  if self.tapitembegin ~= nil  
  	and (math.abs(event.globalPosition.y-self.tapitembegin.y)<20) 
  	and (math.abs(event.globalPosition.x-self.tapitembegin.x)<20) then
  	
    self.context.context:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
  end
end


function KaifuGiftItem:updateText(  )
	local ConditionTextId = self.data.Type;
	local description = analysis("Huodong_Yunyinghuodongtiaojian", ConditionTextId, "miaoshu");
	description = StringUtils:stuff_string_replace(description, "@1", self.data.Param1, 2);

	local target = self.armature:getBone("target").textData;
	self.target = createMultiColoredLabelWithTextData(target, description);
	self.armature_d:addChild(self.target);

	local text = self.armature:getBone("text").textData;
	if self.data.BooleanValue == 0 then
		self.text = createTextFieldWithTextData(text, "今日剩余1次");
	else
		self.text = createTextFieldWithTextData(text, "今日剩余0次");
	end
	self.armature_d:addChild(self.text);
end

function KaifuGiftItem:initButton()

	local gotochargeData=self.armature:findChildArmature("gotocharge"):getBone("common_small_blue_button").textData;
	local gotocharge = self.armature_d:getChildByName("gotocharge");
	local gotocharge_pos = convertBone2LB4Button(gotocharge);
	self.armature_d:removeChild(gotocharge);
	self.gotocharge = CommonButton.new();
	self.gotocharge:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
	self.gotocharge:initializeText(gotochargeData, "充值", true);
	self.gotocharge:setPosition(gotocharge_pos);
	self.gotocharge:addEventListener(DisplayEvents.kTouchTap, self.onClickgotoCharge, self);
	self.armature_d:addChild(self.gotocharge);
	self:updateButton();
end

function KaifuGiftItem:updateButton(  )
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


function KaifuGiftItem:onClickgotoCharge()
	print("function KaifuGiftItem:onClickgotoCharge()");
	if self.data.Count ~= self.data.MaxCount then
		self.context.context:dispatchEvent(Event.new("huoDonggoToChongzhi",nil,self));
	else
		self:takeAward();
	end
end


function KaifuGiftItem:takeAward()
	local bagstate = self.context.context:getBagState(#self.data.ItemIdArray);
	if bagstate == false then
	    return;
	end
	self.huodongProxy:takeAward(self.id, self.data.ConditionID);
	sendMessage(29, 3, {ConditionID = self.data.ConditionID});  
	print("self.data.ConditionID = ", self.data.ConditionID);
	sharedTextAnimateReward():animateStartByString("领取成功");
	self.data.BooleanValue = 1;
	self:updateButton();
end
