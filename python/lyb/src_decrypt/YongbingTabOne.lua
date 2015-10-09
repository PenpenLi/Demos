YongbingTabOne=class(Layer);

function YongbingTabOne:ctor()
  self.class=YongbingTabOne;
end

function YongbingTabOne:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	YongbingTabOne.superclass.dispose(self);
end

--intialize UI
function YongbingTabOne:initialize(context)
  self:initLayer();
  self.context = context;
  self.skeleton = self.context.skeleton;

  self.titleTF = BitmapTextField.new("琅琊佣兵","anniutuzi");
  self.titleTF:setPositionXY(560,615);
  self:addChild(self.titleTF);

  self:refresh();
end

function YongbingTabOne:refresh()
  if self.item1 then
    self.item1.parent:removeChild(self.item1);
    self.item1 = nil;
  end
  if self.item2 then
    self.item2.parent:removeChild(self.item2);
    self.item2 = nil;
  end

  local yongbingData = self.context.familyProxy:getUserYongbingData();
  print("======yongbingData=======");
for k,v in pairs(yongbingData) do
    print("..");
    for k_,v_ in pairs(v) do
      print(k_,v_);
    end
  end
  self.item1 = YongbingTabOneItem.new();
  self.item1:initialize(self.context,yongbingData[1]);
  self.item1:setPositionXY(150,368);
  self:addChild(self.item1);

  self.item2 = YongbingTabOneItem.new();
  self.item2:initialize(self.context,yongbingData[2]);
  self.item2:setPositionXY(150,136);
  self:addChild(self.item2);
end


YongbingTabOneItem=class(Layer);

function YongbingTabOneItem:ctor()
  self.class=YongbingTabOneItem;
end

function YongbingTabOneItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  YongbingTabOneItem.superclass.dispose(self);
  self.armature:dispose();

  removeSchedule(self,self.onSche);
end

--intialize UI
function YongbingTabOneItem:initialize(context, data)
  self:initLayer();
  self.context = context;
  self.data = data;
  self.skeleton = self.context.skeleton;

  local armature=self.skeleton:buildArmature("tab_ui_1_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  if self.data then
    self:refreshHasYongbing();
  else
    self:refreshNone();
  end
end

function YongbingTabOneItem:refreshHasYongbing()
  self.count = 0;
  local heroRoundPortrait = HeroRoundPortrait.new();
  heroRoundPortrait:initialize(self.data);
  -- heroRoundPortrait:setScale(0.75);
  heroRoundPortrait:setPositionXY(50,44);
  self:addChild(heroRoundPortrait);

  local text_data=self.armature:getBone("descb_1").textData;
  self.descb_1=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_1);
  
  text_data=self.armature:getBone("descb_2").textData;
  self.descb_2=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_2);

  text_data=self.armature:getBone("descb_3").textData;
  self.descb_3=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_3);

  text_data=self.armature:getBone("descb_11").textData;
  self.descb_11=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_11);
  
  text_data=self.armature:getBone("descb_22").textData;
  self.descb_22=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_22);

  text_data=self.armature:getBone("descb_33").textData;
  self.descb_33=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_33);

  local button=self.armature.display:getChildByName("btn",true);
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("召回","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onZhaohui,self);
  self.armature.display:addChild(button);

  self.armature.display:getChildByName("yongbing_circle"):setVisible(false);

  self:refreshHasYongbingData();
  addSchedule(self,self.onSche);
end

function YongbingTabOneItem:onSche()
  self.count = 1 + self.count;
  if 1800 == self.count then
    self.count = 0;
    self:refreshHasYongbingData();
  end
end

function YongbingTabOneItem:refreshHasYongbingData()
  local time=getTimeServer()-self.data.Time;
  local s = "";
  local temp = math.floor(time/86400);
  if 0 < temp then
    s = s .. temp .. "天";
    time = time%86400;
  end
  temp = math.floor(time/3600);
  if 0 < temp then
    s = s .. temp .. "小时";
    time = time%3600;
  end
  temp = math.floor(time/60);
  if 0 < temp then
    s = s .. temp .. "分钟";
    time = time%60;
  end
  if "" == s then
    s = "1分钟";
  end
  self.descb_1:setString("驻守时长：");
  self.descb_2:setString("累积收入：");
  self.descb_3:setString("今日被雇佣次数：");
  self.descb_11:setString(s);
  self.descb_22:setString(self.context.familyProxy:getFetchedSilverByGeneralID(self.data.GeneralId));
  self.descb_33:setString(self.data.Count);

  self.silver_img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
  self.silver_img:setScale(0.8);
  self.silver_img:setPositionXY(340,88);
  self.armature.display:addChild(self.silver_img);
end

function YongbingTabOneItem:refreshNone()
  local text_data=self.armature:getBone("descb_4").textData;
  self.descb_4=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_4);
  self.descb_4:setString("小殊讲规则：");
  
  text_data=self.armature:getBone("descb_5").textData;
  self.descb_5=createTextFieldWithTextData(text_data,"",true);
  self.armature.display:addChild(self.descb_5);
  self.descb_5:setString("军中佣兵根据驻守时长获得银两，被帮众雇佣也\n可获银两，派出强力英雄吧！");

  text_data=self.armature:getBone("yongbing_plus").textData;
  self.yongbing_plus=createTextFieldWithTextData(text_data,"派遣佣兵",true);
  self.armature.display:addChild(self.yongbing_plus);

  self.armature.display:getChildByName("btn"):setVisible(false);
  self.armature.display:getChildByName("yongbing_plus"):addEventListener(DisplayEvents.kTouchTap,self.onBTNTap,self);
end

function YongbingTabOneItem:onBTNTap(event)
  local select_layer = YongbingSelectLayer.new();
  select_layer:initialize(self.context);
  self.context:addChild(select_layer);
end

function YongbingTabOneItem:onZhaohui(event)
  local function onConfirm()
    initializeSmallLoading();
    print("GeneralId,", self.data.GeneralId, self.data.ConfigId);
    sendMessage(27,41,{GeneralId = self.data.GeneralId});
    hecDC(3,24,2,{heroID = self.data.GeneralId});
  end
  if 30 > (os.time()-self.data.Time)/60 then
    local pop = CommonPopup.new();
    pop:initialize("将军有令：英雄至少需要守营30分钟才可召回 ~",nil,nil,nil,nil,nil,true,nil,nil,true);
    self.context:addChild(pop);
  else
    local pop = CommonPopup.new();
    pop:initialize("",nil,onConfirm,nil,nil,nil,true,nil,nil,true);
    self.context:addChild(pop);

    local textField = TextField.new(CCLabelTTF:create("守营收入：      ",FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(102,235);
    pop.armature4dispose.display:addChild(textField);

    textField = TextField.new(CCLabelTTF:create(self.context.familyProxy:getFetchedSilverByGeneralID(self.data.GeneralId),FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(310,235);
    pop.armature4dispose.display:addChild(textField);

    textField = TextField.new(CCLabelTTF:create("雇佣次数：" .. self.data.Count,FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(102,190);
    pop.armature4dispose.display:addChild(textField);

    textField = TextField.new(CCLabelTTF:create("雇佣收入：      ",FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(102,145);
    pop.armature4dispose.display:addChild(textField);

    textField = TextField.new(CCLabelTTF:create(self.context.familyProxy:getFetchedSilverByGeneralIDOnBeiGuyong(self.data.GeneralId),FontConstConfig.OUR_FONT,30));
    textField.sprite:setColor(ccc3(103,25,14));
    textField:setPositionXY(310,145);
    pop.armature4dispose.display:addChild(textField);

    local silver_img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
    silver_img:setScale(0.8);
    silver_img:setPositionXY(245,235);
    pop.armature4dispose.display:addChild(silver_img);

    silver_img = CommonSkeleton:getBoneTextureDisplay("commonCurrencyImages/common_silver_bg");
    silver_img:setScale(0.8);
    silver_img:setPositionXY(245,145);
    pop.armature4dispose.display:addChild(silver_img);
  end
end