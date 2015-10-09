require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "main.model.FirstPayProxy";

FirstPayPopup=class(LayerPopableDirect);

function FirstPayPopup:ctor()
  self.class=FirstPayPopup;
end

function FirstPayPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FirstPayPopup.superclass.dispose(self);
  self.armature:dispose()
end

function FirstPayPopup:onDataInit()
  self.firstPayProxy=self:retrieveProxy(FirstPayProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.huodongProxy = self:retrieveProxy(HuoDongProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.skeleton = self.firstPayProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"shouchong_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
  sendMessage(29,2, {ID = 4});

end


function FirstPayPopup:initialize(context)
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
  self.context = context;

end

function FirstPayPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;


  self.bg=Image.new();
  self.bg:loadByArtID(1110);
  self.bg:setPositionXY(110, 70);
  self.bg:setScale(0.85);
  self.armature_d:addChild(self.bg);

  local redButton =armature_d:getChildByName("red_button");
  local redButton_pos=convertBone2LB4Button(redButton);

  self.armature_d:removeChild(redButton)
  
  self.redButton=CommonButton.new();
  self.redButton:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  self.redButton:initializeBMText("充值","anniutuzi");
  self.redButton:setPosition(redButton_pos);
  self.redButton.touchEnabled=true
  self.armature_d:addChild(self.redButton);
  self.redButton:setVisible(false);
  self.redButton:addEventListener(DisplayEvents.kTouchTap,self.redButtonTouched,self);
  if not self.cartoon1 then
    self.cartoon1 = cartoonPlayer("137", redButton_pos.x + 93, redButton_pos.y + 62, 0,nil, 1, nil, 1);
    self:addChild(self.cartoon1)
    self.cartoon1.touchEnabled = false;
  end

  local youxia_touming_pos = armature_d:getChildByName("youxia_touming"):getPosition();
  local youxia_touming_size = armature_d:getChildByName("youxia_touming"):getContentSize();


  local logo = armature_d:getChildByName("logo");
  self.armature_d:swapChildren(logo, self.bg);


  if MainSceneMediator then
      local med=Facade.getInstance():retrieveMediator(MainSceneMediator.name);
      if med then
        med:refreshFirstPayLogin(0);
      end
      self.med = med;
  end

end

function FirstPayPopup:redButtonTouched( )
  print("data ", self.data.Count, self.data.MaxCount, self.data.BooleanValue);
  if self.data.Count < self.data.MaxCount then 
    self:dispatchEvent(Event.new("FirstPayToChongZhi",nil,self));
  else
    local bagstate = self:getBagState(#self.ItemIdArray);
    if bagstate == false then
      return;
    end

    sendMessage(29, 3, {ConditionID =  self.conditionID});
    self.med:refreshFirstPayToSecondPay(false);
    self.huodongProxy.IsFirstPay = false;
    self.huodongProxy:setReddotDataByID(4, 0);
  end
end
function FirstPayPopup:refreshData(data)
  print("function FirstPayPopup:refreshData(data)")

  for k,v in pairs(data) do
    print(k,v)
  end
  self.data = data;
  self.conditionID = data.ConditionID;
  self.ItemIdArray = data["ItemIdArray"];
  self:initItem();
  print(" data.Count1 = ", data.Count, data.MaxCount, data.Count >= data.MaxCount);

  if data.Count >= data.MaxCount then
    print(" data.Count2 = ", data.Count, data.MaxCount, data.Count >= data.MaxCount);

    if data.BooleanValue == 0 then
      print(" data.Count3 = ", data.Count, data.MaxCount, data.Count >= data.MaxCount);
      self.redButton:setGray(false);
      self.redButton:refreshText("领取");
      self.redButton:setVisible(true);
      self.med:refreshFirstPayLogin(1);
      self.huodongProxy:setReddotDataByID(4, 1);
    else
      self.redButton:refreshText("领取");
      self.redButton:setVisible(true);
      self.redButton:setGray(true);
      self.cartoon1:setVisible(false);
      self.med:refreshFirstPayLogin(0);
      self.med:refreshFirstPayToSecondPay(false);
      self.huodongProxy.IsFirstPay = false;
    end
  else
      self.redButton:refreshText("充值");
      self.redButton:setVisible(true);
      self.redButton:setGray(false);
      self.cartoon1:setVisible(true);
      self.med:refreshFirstPayLogin(0);
  end
  
  
end

function FirstPayPopup:initItem(  )
  -- 初始化物品
  print("function FirstPayPopup:initItem(  )")
  self.item = {};
  for i=1,3 do
    print("begin1 item"..i)
    local item = self.armature_d:getChildByName("item"..i);
    local item_pos = convertBone2LB(item);
    self.item[i] = {item =  item, item_pos = item_pos};
    -- self.armature_d:removeChild(self.item[i], false);
    -- self:addChild(self.item[i]);

  end

  self.itemImage = {};
  for k,v in pairs(self.ItemIdArray) do
    -- self.item[k].item:setVisible(true);
    local itemImage = BagItem.new();
    itemImage:initialize({ItemId = v.ItemId, Count = v.Count});
    itemImage:setPositionXY(self.item[k].item_pos.x + 6, self.item[k].item_pos.y + 8);
    self.armature_d:addChild(itemImage);
    itemImage.touchEnabled = true;
    itemImage.touchChildren = true;
    itemImage:addEventListener(DisplayEvents.kTouchBegin, self.onClickItemBegin, self);
    itemImage:addEventListener(DisplayEvents.kTouchEnd, self.onClickItemEnd, self);
  end
end

function FirstPayPopup:onClickItemBegin( event)
  print(" begin")
  self.tapItemBeginPos = event.globalPosition;
end

function FirstPayPopup:onClickItemEnd( event )
  print("end")
  if self.tapItemBeginPos ~= nil then
    if math.abs(event.globalPosition.x - self.tapItemBeginPos.x) < 20 and 
       math.abs(event.globalPosition.y - self.tapItemBeginPos.y) < 20 then
    self:dispatchEvent(Event.new("ON_ITEM_TIP", {item = event.target,nil,nil,count=event.target.userItem.Count},self))
    end
  end
end

function FirstPayPopup:onUIClose( )
  self:dispatchEvent(Event.new("FirstPayClose",nil,self));
  -- setCurrencyGroupVisible(true);
end

function FirstPayPopup:getBagState(num)

  print("function FirstPayPopup:getBagState(num) ", num)
  local bagIsFull = self.bagProxy:getBagIsFull();
  if bagIsFull then 
    sharedTextAnimateReward():animateStartByString("亲，您的背包已满哦~！");
    return false;
  end
  local leftPlaceCount = self.bagProxy:getBagLeftPlaceCount();
  print("function FirstPayPopup:getBagState(num)", num,leftPlaceCount)

  if num > leftPlaceCount then
    sharedTextAnimateReward():animateStartByString("亲，您的背包空间不足哦~！");
    return false;
  end
  return true;
end