require "main.view.family.bangPai.NoneBangPaiItemLayer";
require "main.view.family.bangPai.BangPaiFoundLayer";

NoneBangPaiLayer=class(TouchLayer);

function NoneBangPaiLayer:ctor()
  self.class=NoneBangPaiLayer;
end

function NoneBangPaiLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	NoneBangPaiLayer.superclass.dispose(self);

  self.armature4dispose:dispose();
end

--
function NoneBangPaiLayer:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.items = {};

  -- local bg=LayerColorBackGround:getBackGround();
  -- self:addChild(bg);
  
  --骨骼
  local armature=self.skeleton:buildArmature("bangpai_none_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);


  --title_1
  local text_data=armature:getBone("title_1").textData;
  self.title_1=createTextFieldWithTextData(text_data,"排行");
  self.armature:addChild(self.title_1);

  text_data=armature:getBone("title_2").textData;
  self.title_2=createTextFieldWithTextData(text_data,"帮派名称");
  self.armature:addChild(self.title_2);

  text_data=armature:getBone("title_3").textData;
  self.title_3=createTextFieldWithTextData(text_data,"帮主");
  self.armature:addChild(self.title_3);

  text_data=armature:getBone("title_4").textData;
  self.title_4=createTextFieldWithTextData(text_data,"帮派等级");
  self.armature:addChild(self.title_4);

  text_data=armature:getBone("title_5").textData;
  self.title_5=createTextFieldWithTextData(text_data,"人数");
  self.armature:addChild(self.title_5);

  text_data=armature:getBone("title_6").textData;
  self.title_6=createTextFieldWithTextData(text_data,"操作");
  self.armature:addChild(self.title_6);


  -- local button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_bluelonground_button","创建家族");
  -- button:addEventListener(Events.kStart,self.onFoundButtonTap,self);
  -- button:getDisplay():setVisible(not self.isLookInto);

  --查找家族
  local button=self.armature:getChildByName("find_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("查找","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onFindButtonTap,self);
  self:addChild(button);

  --创建家族
  local button=self.armature:getChildByName("found_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("创建","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onFoundButtonTap,self);
  self:addChild(button);

  local askButton =self.armature4dispose.display:getChildByName("ask");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onAskTap, self);
  self.askBtn = askButton;
  
  local closeButton =self.armature4dispose.display:getChildByName("close_btn");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.context.closeUI, self.context);

  self.send_text_data=armature:getBone("input").textData;
  text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(10);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);  

  initializeSmallLoading();
  sendMessage(27,7);
  hecDC(3,23,1);
  -- self.parent_container:dispatchEvent(Event.new(FamilyNotifications.REQUEST_NONE_FAMILY_LAYER_DATA,{Page=1},self));
end

function NoneBangPaiLayer:onAskTap(event)
  local text=analysis("Tishi_Guizemiaoshu",13,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function NoneBangPaiLayer:onFoundButtonTap(event)
  local needGold = analysis("Xishuhuizong_Xishubiao",1019,"constant");
  local needSilver = analysis("Xishuhuizong_Xishubiao",1020,"constant");
  self.isGoldEnough = needGold <= self.userCurrencyProxy:getGold();
  self.isSilverEnough =needSilver <= self.userCurrencyProxy:getSilver();
  local colorGold = self.isGoldEnough and "#00AB14" or "#FF00000";
  local colorSilver = self.isSilverEnough and "#00AB14" or "#FF00000";

  local str = "<content><font color='#67190E'>亲可以花费</font>";
  str = str .. "<font color='" .. colorGold .. "'>" .. needGold .. "元宝</font>";
  str = str .. "<font color='#67190E'>,或者</font>";
  str = str .. "<font color='" .. colorSilver .. "'>" .. needSilver/10000 .. "万银两</font>";
  str = str .. "<font color='#67190E'>创建属于自己的帮派,努力瑟!</font></content>";

  local popup=CommonPopup.new();
  popup:initialize(str,self,self.onGoldFound,nil,self.onSilverFound,nil,nil,{"元宝创建","银两创建"},true,true,true);
  self.context:addChild(popup);

  hecDC(3,23,2);
end

function NoneBangPaiLayer:onSilverFound(event)
  if not self.isSilverEnough then
    sharedTextAnimateReward():animateStartByString("银两不足呢");
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
    return;
  end
  self:onConfirmFound(false);
  hecDC(3,23,3);
end

function NoneBangPaiLayer:onGoldFound(event)
  if not self.isGoldEnough then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
    Facade:getInstance():sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
    return;
  end
  self:onConfirmFound(true);
  hecDC(3,23,4);
end

function NoneBangPaiLayer:onConfirmFound(isGold)
  local bangPaiFoundLayer=BangPaiFoundLayer.new();
  bangPaiFoundLayer:initialize(self.context, isGold);
  self.context:addChild(bangPaiFoundLayer);
end

function NoneBangPaiLayer:refreshFamilyApply(familyId, bool)
  for k,v in pairs(self.items) do
    if familyId==v.data.FamilyId then
      v:refreshFamilyApply(bool);
      break;
    end
  end
end

function NoneBangPaiLayer:onFindButtonTap(event)
  local a=self.textInput:getInputText();
  a=string.sub(a,10,-11);
  local defaultContent = '<font color="#808080">请输入...</font>';
  if defaultContent==a or ''==a then
    a='';
  else
    a=string.sub(a,23,-8);
  end
  if ''==a then
    sharedTextAnimateReward():animateStartByString("请输入查找的帮派名称~");
    return;
  end
  
  local data;
  local idx;
  for k,v in pairs(self.items) do
    if a == v.data.FamilyName then
      data = v.data;
      idx = k;
      table.remove(self.items,k);
      break;
    end
  end
  if idx then
    self.item_layer:removeItemAt(-1+idx, true);
    local item=NoneBangPaiItemLayer.new();
    item:initialize(self.context,data);
    self.item_layer:addItemAt(item,0,true);
    table.insert(self.items,1,item);

    for k,v in pairs(self.items) do
      v:setSearch(1 == k);
    end
  else
    sharedTextAnimateReward():animateStartByString("没有找到这个名字的帮派呢~");
  end
end

function NoneBangPaiLayer:refreshFamilyList(familyInfoArray)
  self.familyInfoArray = familyInfoArray;

  self.item_layer=ListScrollViewLayer.new();
  self.item_layer:initLayer();
  self.item_layer:setPositionXY(115,145);
  self.item_layer:setViewSize(makeSize(1050,435));
  self.item_layer:setItemSize(makeSize(1050,90));
  self.armature:addChild(self.item_layer);

  -- local function cbfunc(a,b,c)
  --   print(self.item_layer:getContentOffset().y);
  -- end

  -- self.item_layer:setAnimateScrollFunction(cbfunc);

  self.items={};
  local function sf(a, b)
    return a.Ranking<b.Ranking;
  end
  table.sort(self.familyInfoArray,sf);
  for k,v in pairs(self.familyInfoArray) do
    local item=NoneBangPaiItemLayer.new();
    item:initialize(self.context,v);
    self.item_layer:addItem(item);
    table.insert(self.items,item);
  end
end

function NoneBangPaiLayer:refreshFamilyApply(familyId, booleanValue)
  for k,v in pairs(self.items) do
    if familyId == v.data.FamilyId then
      v:refreshIsApplied(booleanValue);
      break;
    end
  end
end