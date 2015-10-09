require "core.display.LayerPopable";
require "core.controls.CommonLayer";
require "main.model.MonthCardProxy";

MonthCardPopup=class(LayerPopableDirect);

function MonthCardPopup:ctor()
  self.class=MonthCardPopup;
end

function MonthCardPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  MonthCardPopup.superclass.dispose(self);
  self.armature:dispose()
end

function MonthCardPopup:onDataInit()
  self.monthCardProxy=self:retrieveProxy(MonthCardProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.huodongProxy = self:retrieveProxy(HuoDongProxy.name);
  self.skeleton = self.monthCardProxy:getSkeleton();
  local layerPopableData=LayerPopableData.new();
  layerPopableData:setHasUIBackground(true)
  layerPopableData:setHasUIFrame(true)
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton,"yueka_ui")
  layerPopableData:setShowCurrency(true);
  self:setLayerPopableData(layerPopableData)
  sendMessage(24, 6);

end


function MonthCardPopup:initialize()
  self:initLayer();
  self.sprite:setContentSize(CCSizeMake(1280, 720));
end

function MonthCardPopup:onPrePop()
  

  local armature=self.armature;
  local armature_d=armature.display;
  self.armature_d = armature_d;

  local huodongData = analysis("Huodong_Chongzhi", 1);
  local price = huodongData.rmb;
  local firstReturn = huodongData.recharge;
  local monthReturn = huodongData.monthrebate;
  
  -- local text_data = self.armature:getBone("des1_txt").textData;
  -- self.des1Text = createTextFieldWithTextData(text_data,"1、免费体验7日月卡福利。");
  -- self:addChild(self.des1Text);

  local text_data = self.armature:getBone("des1_txt").textData;
  self.des1Text = createTextFieldWithTextData(text_data,"1、只需"..tostring(price).."元即可购买月卡（30日）");
  self:addChild(self.des1Text);

  local text_data = self.armature:getBone("des2_txt").textData;
  self.des2Text = createTextFieldWithTextData(text_data,"2、购买月卡即送"..tostring(firstReturn).."元宝");
  self:addChild(self.des2Text);

  local text_data = self.armature:getBone("des4_txt").textData;
  self.des4Text = createTextFieldWithTextData(text_data,"3、拥有月卡每日登陆就可获取"..tostring(monthReturn).."元宝");
  self:addChild(self.des4Text);

  local text_data = self.armature:getBone("days_txt").textData;
  self.daysText = createTextFieldWithTextData(text_data,"剩余7天");
  self:addChild(self.daysText);

  local text_data = self.armature:getBone("huode_txt").textData;
  self.huodeText = createTextFieldWithTextData(text_data,"每日可获得");
  self:addChild(self.huodeText);

  local text_data = self.armature:getBone("num_txt").textData;
  self.numText = createTextFieldWithTextData(text_data,"100");
  self:addChild(self.numText);

  local gold_img = armature_d:getChildByName("gold_img");
  -- gold_img:setAnchorPoint(0.5, 0.5);
  gold_img:setScale(0.9)

  local blueButton =armature_d:getChildByName("blueButton");
  local selectButtonP = convertBone2LB4Button(blueButton);
  armature_d:removeChild(blueButton)

  self.blueButton = CommonButton.new();
  self.blueButton:initialize("commonButtons/common_small_blue_button_normal", nil, CommonButtonTouchable.BUTTON);
  
  self.blueButton:setPosition(selectButtonP);

  self.blueButton:addEventListener(DisplayEvents.kTouchBegin, self.blueButtonTouchBegin, self);
  self:addChild(self.blueButton);

  self.takeTxt = BitmapTextField.new("领取","anniutuzi");
  self.takeTxt.touchEnabled = true;
  self.takeTxt:setAnchorPoint(ccp(0.5, 0.5))
  self.takeTxt:setPosition(ccp(65, 27));
  self.blueButton:addChild(self.takeTxt);

  if not self.cartoon then
    self.cartoon = cartoonPlayer("133", 360, 205, 0,nil, 1, nil, 1);
    self.cartoon:setAnchorPoint(ccp(0.5, 0.5))
    self:addChild(self.cartoon)
    self.cartoon:setVisible(false);
    self.cartoon.touchEnabled = false;
  end

  
  self.redButton =armature_d:getChildByName("redButton");
  SingleButton:create(self.redButton);

  self.redButton:addEventListener(DisplayEvents.kTouchTap, self.redButtonTap, self);
  self.buyTxt = BitmapTextField.new("续费","anniutuzi");
  self.buyTxt.touchEnabled = true;
  self.buyTxt:setAnchorPoint(ccp(0.5, 0.5))
  self.buyTxt:setPosition(ccp(95, 30));
  self.redButton:addChild(self.buyTxt);


end

function MonthCardPopup:redButtonTap()
  sendMessage(100, 1, {BattleId = 1})
  self:closeUI();

  if self.huodongProxy.hasBindPhone == false then

    self.huodongProxy.havdCharged = true;

    --将huodongproxy的 data中id = 4的booleanvalue刷成1
    self.huodongProxy:toBindPhoneNum(4, 1);
    --主界面活动显示tab
    self.huodongProxy:setDotVisible(4, 1);
    
    Facade.getInstance():sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));

    if MainSceneMediator then
      local med=Facade.getInstance():retrieveMediator(MainSceneMediator.name);
      if med then
        med:refreshHuoDong();
      end
    end

  end

  
  
end

function MonthCardPopup:blueButtonTouchBegin()
  self.blueButton:addEventListener(DisplayEvents.kTouchEnd,self.blueButtonTouchEnd,self);
  
  self.takeTxt:setScale(0.9);
end

function MonthCardPopup:blueButtonTouchEnd()
  self.blueButton:setGray(true, false);
  self.cartoon:setVisible(false);
  self.takeTxt:setScale(1);
  self.count = self.count -1;
  self.daysText:setString("剩余"..tostring(self.count).."天");

  if self.count >=1 then
    self.buyTxt:setString("续费");
  else
    self.buyTxt:setString("购买");
  end
  sendMessage(24, 7);
  GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_53] = false;
  if MainSceneMediator then
    local med = Facade.getInstance():retrieveMediator(MainSceneMediator.name);
    if med then
      med:refreshMonthCard();
    end
  end

end




function MonthCardPopup:refreshData(count, booleanValue)
  print("MonthCardPopup count booleanValue",count, booleanValue);
  self.count = count;
  self.daysText:setString("剩余"..tostring(self.count).."天");
  if booleanValue == 1 or self.count == 0 then
    self.blueButton:setGray(true, false);
    self.cartoon:setVisible(false);
  else
    self.blueButton:setGray(false, true);
    self.cartoon:setVisible(true)
  end

  if self.count >=1 then
    self.buyTxt:setString("续费");
  else
    self.buyTxt:setString("购买");
  end
end

function MonthCardPopup:onUIClose()
  self:dispatchEvent(Event.new("MonthCardClose",nil,self));
end
