require "core.display.LayerPopable";
require "main.view.yongbing.YongbingTabOne";
require "main.view.yongbing.YongbingTabTwo";
require "main.view.yongbing.YongbingSelectLayer";

YongbingPopup=class(LayerPopableDirect);

function YongbingPopup:ctor()
  self.class=YongbingPopup;
end

function YongbingPopup:dispose()
  YongbingPopup.superclass.dispose(self);
  self.armature:dispose();
end

function YongbingPopup:onDataInit()
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.effectProxy = self:retrieveProxy(EffectProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.userDataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.equipmentInfo = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.skeleton = getSkeletonByName("yongbing_ui");
  self.channel_buttons = {};
  self.panels = {};

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_HOUSE, nil, true, 2);
  self:setLayerPopableData(layerPopableData);
end

function YongbingPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
end

function YongbingPopup:onUIInit()
  local armature=self.skeleton:buildArmature("yongbing_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature = armature;
  self:addChild(self.armature.display);

  local closeButton =self.armature.display:getChildByName("close_btn");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.closeUI, self);

  self.askBtn = Button.new(self.armature:findChildArmature("ask"),false,"");
  self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);

  local chat_channel_button=self.armature.display:getChildByName("tabBtn1");
  local chat_channel_button_1=self.armature.display:getChildByName("tabBtn2");
  local chat_channel_button_pos=convertBone2LB4Button(chat_channel_button);
  local chat_channel_button_text_data=self.armature:findChildArmature("tabBtn1"):getBone("channel_button").textData;
  local chat_channel_button_skew=chat_channel_button_1:getPositionY()-chat_channel_button:getPositionY();
  self.armature.display:removeChild(chat_channel_button);
  self.armature.display:removeChild(chat_channel_button_1);

  local a=1;
  local s={"遣\n派","营\n兵"};
  while 3>a do
    chat_channel_button=CommonButton.new();
    chat_channel_button:initialize("channel_button_normal","channel_button_down",CommonButtonTouchable.CUSTOM,self.skeleton);
    -- chat_channel_button:initializeText(chat_channel_button_text_data,s[a]);
    chat_channel_button:initializeBMText(s[a],"anniutuzi");
    chat_channel_button:setPositionXY(chat_channel_button_pos.x,(-1+a)*chat_channel_button_skew+chat_channel_button_pos.y);
    chat_channel_button:addEventListener(DisplayEvents.kTouchTap,self.onChannelButtonTap,self,a);
    self:addChild(chat_channel_button);
    table.insert(self.channel_buttons, chat_channel_button);
    a=1+a;
  end

  local text_data=self.armature:getBone("titleTF").textData;
  self.titleTF=createTextFieldWithTextData(text_data,"琅琊小贴士：将士也会累，每个英雄每天可被雇佣5次",true);
  self.armature.display:addChild(self.titleTF);

  self:onChannelButtonTap(nil,1);
end

function YongbingPopup:onShowTip()
  local text=analysis("Tishi_Guizemiaoshu",15,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function YongbingPopup:onRequestedData()
  -- initializeSmallLoading();
  -- sendMessage(19,13);
end

function YongbingPopup:onUIClose()
  -- setFactionCurrencyBTNVisible(true)
  self:dispatchEvent(Event.new(YongbingNotifications.YONGBING_CLOSE,nil,self));
end

function YongbingPopup:onPreUIClose()
  -- self.armature.display:removeChild(self.scrollView);
end

function YongbingPopup:onChannelButtonTap(event, num)
  if event then
    MusicUtils:playEffect(7,false);
  end
  if num == self.selected_button_num then
    return;
  end
  if self.channel_buttons[self.selected_button_num] then
    self.channel_buttons[self.selected_button_num]:select(false);
  end
  if self.panels[self.selected_button_num] then
    self.panels[self.selected_button_num]:setVisible(false);
  end
  self.selected_button_num=num;
  self.channel_buttons[self.selected_button_num]:select(true);
  self:removeChild(self.channel_buttons[self.selected_button_num],false);
  self:addChild(self.channel_buttons[self.selected_button_num]);
  if not self.panels[self.selected_button_num] then
    self.panels[self.selected_button_num] = self:getPannel(self.selected_button_num);
    self:addChild(self.panels[self.selected_button_num]);
  end
  self.panels[self.selected_button_num]:setVisible(true);
  if 2 == self.selected_button_num then
    self.panels[self.selected_button_num]:refreshOnTab();
  end
end

function YongbingPopup:getPannel(num)
  local layer;
  if 1 == num then
    layer = YongbingTabOne.new();
    layer:initialize(self);
  elseif 2 == num then
    layer = YongbingTabTwo.new();
    layer:initialize(self);
  end
  return layer;
end

function YongbingPopup:refreshChange()
  self.panels[1]:refresh();
  if self.panels[2] then
    self.panels[2]:refreshChange();
  end
end