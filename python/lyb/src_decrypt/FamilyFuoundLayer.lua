--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyFuoundLayer=class(Layer);

function FamilyFuoundLayer:ctor()
  self.class=FamilyFuoundLayer;
end

function FamilyFuoundLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyFuoundLayer.superclass.dispose(self);

  if self.armature4dispose then
    self.armature4dispose:dispose();
  end
  BitmapCacher:removeUnused();
end

--
function FamilyFuoundLayer:initialize(parent_container, isGold)
  self:initLayer();
  self.parent_container=parent_container;
  self.isGold = isGold;
  self.skeleton=self.parent_container.skeleton;
  self.familyProxy=self.parent_container.familyProxy;
  self.bagProxy=self.parent_container.bagProxy;
  self.userCurrencyProxy=self.parent_container.userCurrencyProxy;
  -- self.const_item_id=1213001;
  self.const_price=analysis("Xishuhuizong_Xishubiao",1019,"constant");
  self.const_silver_price=analysis("Xishuhuizong_Xishubiao",1020,"constant");
  -- self.const_item_name=analysis("Daoju_Daojubiao",self.const_item_id,"name");
  -- self.hasItem=0~=self.bagProxy:getItemNum(self.const_item_id);
  self.hasGold=self.const_price<=self.userCurrencyProxy:getGold();
  self.hasSilver=self.const_silver_price<=self.userCurrencyProxy:getSilver();
  -- if self.hasItem then
  --   self:initializeWithCard();
  -- else
    -- self:initializeWithGold();
  -- end
  self:initializeWithFound();
end

function FamilyFuoundLayer:initializeWithCard()
  --骨骼
  local armature=self.skeleton:buildArmature("family_found_ui_card");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='<content><font color="#E1D2A0">创建家族需要消耗: </font><font color="#00FF00">' .. self.const_item_name .. 'x1</font></content>'
  local text_data=armature:getBone("descb").textData;
  self.descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  text='<content><font color="#E1D2A0">开始创建吧! 族长大淫!</font></content>';
  text_data=armature:getBone("descb_2").textData;
  self.descb_2=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.descb_2);

  -- local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  -- button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
 -- button:addEventListener(Events.kStart,self.onCancelTap,self);

  -- button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_blueround_button","创建");
  --button:addEventListener(Events.kStart,self.initializeWithFound,self);

  --common_copy_greenroundbutton
  local trimButtonData=armature:findChildArmature("common_copy_greenroundbutton"):getBone("common_copy_greenroundbutton").textData; 
  local common_copy_bluelonground_button=self.armature:getChildByName("common_copy_greenroundbutton");
  local common_copy_bluelonground_button_pos = convertBone2LB4Button(common_copy_bluelonground_button);
  self.armature:removeChild(common_copy_bluelonground_button);
  self.common_copy_bluelonground_button=CommonButton.new();
  self.common_copy_bluelonground_button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.common_copy_bluelonground_button:initializeText(trimButtonData,"取消");
  self.common_copy_bluelonground_button:setPosition(common_copy_bluelonground_button_pos);
  self.common_copy_bluelonground_button:addEventListener(DisplayEvents.kTouchTap,self.onCancelTap,self);
  self:addChild(self.common_copy_bluelonground_button);

  --common_copy_blueround_button1
  local common_copy_bluelonground_button1=self.armature:getChildByName("common_copy_blueround_button");
  local common_copy_bluelonground_button_pos1 = convertBone2LB4Button(common_copy_bluelonground_button1);
  self.armature:removeChild(common_copy_bluelonground_button1);
  self.common_copy_bluelonground_button1=CommonButton.new();
  self.common_copy_bluelonground_button1:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.common_copy_bluelonground_button1:initializeText(trimButtonData,"创建");
  self.common_copy_bluelonground_button1:setPosition(common_copy_bluelonground_button_pos1);
  self.common_copy_bluelonground_button1:addEventListener(DisplayEvents.kTouchTap,self.initializeWithFound,self);
  self:addChild(self.common_copy_bluelonground_button1);



  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  local popupSize=self.armature:getChildByName("common_copy_background_inner_1"):getContentSize();
  self:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(1);
end

function FamilyFuoundLayer:initializeWithGold()
  --骨骼
  local armature=self.skeleton:buildArmature("family_found_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='<content><font color="#E1D2A0">创建家族需要消耗: </font><font color="#FF0000">' .. self.const_item_name .. 'x1</font></content>'
  local text_data=armature:getBone("descb").textData;
  self.descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.descb);
  text='<content><font color="#FFFFFF">Ps: 您可以花费</font>';
  text=text .. '<font color="#00FFFF">' .. math.floor(self.const_silver_price/10000) .. 'w银两</font>';
  text=text .. '<font color="#FFFFFF">在</font><font color="#00FFFF">商人西纳</font>';
  text=text .. '<font color="#FFFFFF">处购买, 或者花费</font>';
  text=text .. '<font color="#00FFFF">' .. self.const_price .. '元宝</font><font color="#FFFFFF">直接创建.</font></content>';
  text_data=armature:getBone("descb_2").textData;
  self.descb_2=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.armature:addChild(self.descb_2);

  -- local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  -- button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  -- button:addEventListener(Events.kStart,self.onCancelTap,self);

  -- button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_blueround_button","元宝创建");
  -- button:addEventListener(Events.kStart,self.initializeWithFound,self);

  --common_copy_greenroundbutton
  local trimButtonData=armature:findChildArmature("common_copy_greenroundbutton"):getBone("common_copy_greenroundbutton").textData; 
  local common_copy_bluelonground_button=self.armature:getChildByName("common_copy_greenroundbutton");
  local common_copy_bluelonground_button_pos = convertBone2LB4Button(common_copy_bluelonground_button);
  self.armature:removeChild(common_copy_bluelonground_button);
  self.common_copy_bluelonground_button=CommonButton.new();
  self.common_copy_bluelonground_button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.common_copy_bluelonground_button:initializeText(trimButtonData,"取消");
  self.common_copy_bluelonground_button:setPosition(common_copy_bluelonground_button_pos);
  self.common_copy_bluelonground_button:addEventListener(DisplayEvents.kTouchTap,self.onCancelTap,self);
  self:addChild(self.common_copy_bluelonground_button);

  --common_copy_blueround_button1
  local common_copy_bluelonground_button1=self.armature:getChildByName("common_copy_blueround_button");
  local common_copy_bluelonground_button_pos1 = convertBone2LB4Button(common_copy_bluelonground_button1);
  self.armature:removeChild(common_copy_bluelonground_button1);
  self.common_copy_bluelonground_button1=CommonButton.new();
  self.common_copy_bluelonground_button1:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  self.common_copy_bluelonground_button1:initializeText(trimButtonData,"元宝创建");
  self.common_copy_bluelonground_button1:setPosition(common_copy_bluelonground_button_pos1);
  self.common_copy_bluelonground_button1:addEventListener(DisplayEvents.kTouchTap,self.initializeWithFound,self);
  self:addChild(self.common_copy_bluelonground_button1);


  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  local popupSize=self.armature:getChildByName("common_copy_background_inner_1"):getContentSize();
  self:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(1);
end

function FamilyFuoundLayer:initializeWithFound()
  -- if not self.hasSilver and not self.hasGold then
  --   sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
  --   self.parent_container:dispatchEvent(Event.new("vip_recharge",nil,self));
  --   return;
  -- end
  -- self.removeChild(self.armature);
  -- self.armature=nil;
  --骨骼
  local armature=self.skeleton:buildArmature("invite_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  -- self.armature:getChildByName("common_biShua1_1"):setScaleX(0.8);
  -- self.armature:getChildByName("common_biShua1_2"):setScaleX(0.8);
  -- self.armature:getChildByName("common_biShua2_10"):setScaleY(0.5);
  -- self.armature:getChildByName("common_biShua2_1"):setScaleY(0.5);

  local text='输入家族名字';
  local text_data=armature:getBone("common_descb").textData;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  self.send_text_data=armature:getBone("text_input_bg").textData;
  text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(5);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);

  -- local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  -- button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  -- button:addEventListener(Events.kStart,self.onCancelTap,self);

  -- button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  -- button.bone:initTextFieldWithString("common_copy_blueround_button","确认");
  -- button:addEventListener(Events.kStart,self.onConfirmTap,self);

  --创建家族
  local button=self.armature:getChildByName("common_blueround_button");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("创建帮派","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onConfirmTap,self);
  self:addChild(button);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onCancelTap, self);

  local size=Director:sharedDirector():getWinSize();
  local popupSize=self.armature:getChildByName("common_background_1"):getContentSize();
  self:setPositionXY(math.floor((size.width-popupSize.width)/2), math.floor((size.height-popupSize.height)/2));
end

function FamilyFuoundLayer:onCancelTap(event)
  self.parent:removeChild(self);
end

function FamilyFuoundLayer:onConfirmTap(event)
  local a=self.textInput:getInputText();
  a=string.sub(a,10,-11);

  local defaultContent
  if GameData.platFormID == GameConfig.PLATFORM_CODE_GOOGLE then
    defaultContent = getLuaCodeTranslated('<font color="#808080">请输入...</font>')
  else
    defaultContent = '<font color="#808080">请输入...</font>'
  end

  if defaultContent==a or ''==a then
    a='';
  else
    a=string.sub(a,23,-8);
  end
  if ''==a then
    sharedTextAnimateReward():animateStartByString("取一个家族名字吧~");
    return;
  end
  --[[if not self.hasItem then
    sharedTextAnimateReward():animateStartByString("道具不足哦~");
    return;
  end
  if not self.hasItem and not self.hasGold then
    sharedTextAnimateReward():animateStartByString("亲~元宝不够了哦!");
    self.parent_container:dispatchEvent(Event.new("vip_recharge",nil,self));
    return;
  end]]
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_FOUND,{FamilyName=a},self));
  self:onCancelTap();
end