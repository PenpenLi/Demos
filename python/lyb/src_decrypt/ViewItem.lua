ViewItem = class(ListScrollViewLayerItem);

function ViewItem:ctor(  )
	self.class = ViewItem;
	self.itemCount = 0;--多少个item
	self.item = {};
	self.itemImage = {};
end

function ViewItem:dispose(  )
	self:removeAllEventListeners();
	ViewItem.superclass.dispose(self);
end

function ViewItem:initialize(context,  ID, day, data)
	self.context = context;
	self:initLayer();
	self.ID = ID;
	self.day = day;
	self.skeleton = context.skeleton;
	self.huodongProxy = context.huodongProxy;
	self.userCurrencyProxy = context.userCurrencyProxy;
	self.data = data;
	-- self.bagProxy = self:retrieveProxy(BagProxy.name);
	self.bagProxy = context.bagProxy;

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

function ViewItem:initText(  )
	local textData = self.armature:getBone("target").textData;
	local text = analysis("Huodong_Yunyinghuodongtiaojian", self.data.Type, "miaoshu");
	local Param1 = self.data.Param1;
	local Param2 = self.data.Param2;
	local Param3 = self.data.Param3;
	local currentState = self.data.MaxCount;

	if self.data.Type == 10 then
		-- analysis("Juqing_Guanka", self.data.Param1, "scenarioName");
		local juqingTab =  analysis("Juqing_Guanka", self.data.Param1);
		local juqingID = juqingTab.storyId;
		local zhangjie = analysis("Juqing_Juqing", juqingID, "zhangjie");
		-- Param1 = analysis("Juqing_Guanka", self.data.Param1, "scenarioName");
		Param1 = "第"..zhangjie.."章".." \""..juqingTab.scenarioName.."\" ";
	elseif self.data.Type == 14 then
		Param1 = analysis("Kapai_Kapaiyanse", self.data.Param1, "yanse");
	elseif self.data.Type == 25 then
		Param1 = analysis("Zhujiao_Tianxiangshouhudian", self.data.Param1, "name");
	elseif self.data.Type == 30 or self.data.Type == 27 then
		local colorTable = {[1] = "白色", [2] = "绿色", [3] = "蓝色", [4] = "紫色", [5] = "橙色", [6] = "红色"}
		Param1 = colorTable[self.data.Param1];
	end

	text = StringUtils:stuff_string_replace(text, "@1", Param1, 2);
	text = StringUtils:stuff_string_replace(text, "@2", Param2, 2);
	text = StringUtils:stuff_string_replace(text, "@3", Param3, 2);
	self.text = createMultiColoredLabelWithTextData(textData, text);
	self:addChild(self.text);
end

function ViewItem:initItem(  )
	print("\n\n\nself.data.ItemIdArray = ", #self.data.ItemIdArray)
	self.itemCount = #self.data.ItemIdArray;

	for i=1, self.itemCount do
		self.item[i].item:setVisible(true);
		self.itemImage[i] = BagItem.new();
		self.itemImage[i]:initialize({ItemId = self.data.ItemIdArray[i].ItemId, Count = self.data.ItemIdArray[i].Count});
		self.itemImage[i]:setScale(0.75);
		self.itemImage[i]:setPositionXY(self.item[i].item_pos.x + 6, self.item[i].item_pos.y + 8);
		self.armature_d:addChild(self.itemImage[i]);
		self.itemImage[i].touchEnabled = true;
		self.itemImage[i].touchChildren = true;
		self.itemImage[i]:addEventListener(DisplayEvents.kTouchBegin, self.onItemBegin, self);
		self.itemImage[i]:addEventListener(DisplayEvents.kTouchEnd, self.onItemEnd, self);
	end

end

function ViewItem:onItemBegin( event )
	self.beginItemPosition = event.globalPosition;
end

function ViewItem:onItemEnd( event )
	if self.beginItemPosition ~= nil 
		and math.abs( self.beginItemPosition.x - event.globalPosition.x ) < 20 
		and math.abs( self.beginItemPosition.y - event.globalPosition.y ) < 20   then

		self.context.context.context:dispatchEvent(Event.new("ON_ITEM_TIP", 
													{item = event.target, nil, nil, count = event.target.userItem.Count},
													 self));
	end
end


function ViewItem:initButton(  )
	self.award1=self.armature_d:getChildByName("award1");
  	self.award2=self.armature_d:getChildByName("award2");
  	self.award3=self.armature_d:getChildByName("award3");


  	for i=1,3 do
  		local item = self.armature_d:getChildByName("item"..i);
  		local item_pos = convertBone2LB(item);
  		self.armature_d:removeChild(item);
  		local itemScale = CommonSkeleton:getBoneTextureDisplay("commonGrids/common_grid")
  		itemScale:setScale(0.75);
  		itemScale:setPosition(item_pos);
  		self.armature_d:addChild(itemScale);
  		self.item[i] = {item = itemScale, item_pos = item_pos};
  		itemScale:setVisible(false);
  	end

  	if self.data.BooleanValue == 1 then
  		self.award1:setVisible(false);
	  	self.award2:setVisible(false);
	  	self.award3:setVisible(true);
  	elseif self.data.Count < self.data.MaxCount  then
  		-- 排除论剑 论剑是反的。
  		self.award1:setVisible(true);
	  	self.award2:setVisible(false);
	  	self.award3:setVisible(false);
	else
		self.award1:setVisible(false);
  		self.award2:setVisible(true);
  		self.award3:setVisible(false);
  		self.award2:addEventListener(DisplayEvents.kTouchBegin, self.onClickAwardBegin, self);
  		local pos = convertBone2LB(self.award2);
		self.buttonEffect = cartoonPlayer("1387",pos.x + 60, pos.y + 40, 0);
    	self.buttonEffect.touchEnabled = false;
    	self:addChild(self.buttonEffect);
  	end

  	
end

function ViewItem:onClickAwardBegin(event)
	self.beginPosition = event.globalPosition;
	-- self:setScale(0.93);
	self.award2:addEventListener(DisplayEvents.kTouchMove, self.onClickAwardMove, self);
	self.award2:addEventListener(DisplayEvents.kTouchEnd, self.onClickAwardEnd, self);
end

function ViewItem:onClickAwardMove( event )
	if math.abs(event.globalPosition.y - self.beginPosition.y ) > 20 then
		-- self:setScale(1);
	end
end

function ViewItem:onClickAwardEnd( event )
	if math.abs(event.globalPosition.y - self.beginPosition.y ) < 20 then
		print("self.context.SelectConditionID  = ", self.context.SelectConditionID);
		if self.data.ConditionID ~= 2 and self.data.ConditionID ~= 3 then
			local bagstate = self:getBagState(#self.data.ItemIdArray);
			if bagstate == false then
				return;
			end
		end
		sendMessage(29, 3, {ConditionID = self.data.ConditionID});
		self.award2:setVisible(false);
		self.award3:setVisible(true);
		self:removeChild(self.buttonEffect);
	end
	-- self:setScale(1);
end


function ViewItem:onInitialize( )

end

function ViewItem:getBagState(num)

  print("function ViewItem:getBagState(num) ", num)
  local bagIsFull = self.bagProxy:getBagIsFull();
  if bagIsFull then 
    sharedTextAnimateReward():animateStartByString("亲，您的背包已满哦~！");
    return false;
  end
  local leftPlaceCount = self.bagProxy:getBagLeftPlaceCount();
  print("function ViewItem:getBagState(num)", num,leftPlaceCount)

  if num > leftPlaceCount then
    sharedTextAnimateReward():animateStartByString("亲，您的背包空间不足哦~！");
    return false;
  end
  return true;
end