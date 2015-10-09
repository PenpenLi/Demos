--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyNoticeLayer=class(LayerColor);

function FamilyNoticeLayer:ctor()
  self.class=FamilyNoticeLayer;
end

function FamilyNoticeLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyNoticeLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyNoticeLayer:initialize(skeleton, familyProxy, parent_container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  
  --骨骼
  local armature=skeleton:buildArmature("notice_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self.armature:getChildByName("common_biShua1_1"):setScaleX(0.8);
  self.armature:getChildByName("common_biShua1_2"):setScaleX(0.8);
  self.armature:getChildByName("common_biShua2_10"):setScaleY(0.5);
  self.armature:getChildByName("common_biShua2_1"):setScaleY(0.5);

  local text='修改公告';
  local text_data=armature:getBone("common_descb").textData;
  self.descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.descb);

  self.send_text_data=armature:getBone("text_input_bg").textData;
  text="请输入...";
  self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));
  self.textInput:initialize();
  self.textInput:setMaxChars(30);
  self.textInput:setSingleline(true);
  self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y);
  self.armature:addChild(self.textInput);


  -- self.send_text_data=armature:getBone("text_input_bg").textData;
  -- local text="请输入...";
  -- self.textInput=RichTextLineInput.new(text,self.send_text_data.size,makeSize(self.send_text_data.width,self.send_text_data.height));

  -- --local contentSize = self.textInput:getContentSize();
  -- self.textInput:initialize();
  -- self.textInput:setMaxChars(250);
  -- self.textInput:setSingleline(false);
  -- self.textInput:setPositionXY(self.send_text_data.x,self.send_text_data.y + 105);
  -- self.armature:addChild(self.textInput);

  --common_copy_greenroundbutton
  -- local trimButtonData=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData; 
  -- local common_copy_bluelonground_button=self.armature:getChildByName("common_copy_greenroundbutton");
  -- local common_copy_bluelonground_button_pos = convertBone2LB4Button(common_copy_bluelonground_button);
  -- self.armature:removeChild(common_copy_bluelonground_button);
  -- self.common_copy_bluelonground_button=CommonButton.new();
  -- self.common_copy_bluelonground_button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  -- self.common_copy_bluelonground_button:initializeText(trimButtonData,"取消");
  -- self.common_copy_bluelonground_button:setPosition(common_copy_bluelonground_button_pos);
  -- self.common_copy_bluelonground_button:addEventListener(DisplayEvents.kTouchTap,self.onCancelTap,self);
  -- self:addChild(self.common_copy_bluelonground_button);

  --common_copy_blueround_button1
  local common_blueround_button=self.armature:getChildByName("common_blueround_button");
  local common_blueround_button_pos = convertBone2LB4Button(common_blueround_button);
  self.armature:removeChild(common_blueround_button);
  self.common_blueround_button=CommonButton.new();
  self.common_blueround_button:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  --self.common_blueround_button:initializeText(trimButtonData,"确定");
  self.common_blueround_button:initializeBMText("修改公告","anniutuzi");
  self.common_blueround_button:setPosition(common_blueround_button_pos);
  self.common_blueround_button:addEventListener(DisplayEvents.kTouchTap,self.onConfirmTap,self);
  self:addChild(self.common_blueround_button);

  local closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(closeButton);
  closeButton:addEventListener(DisplayEvents.kTouchTap, self.onCancelTap, self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  local popupSize=self.armature:getChildByName("common_background_1"):getContentSize();
  self:setPositionXY(math.floor((size.width-popupSize.width)/2),-1.2 * popupSize.height + math.floor((size.height-popupSize.height)/2));


  --self:setColor(ccc3(0,0,0));
  self:setOpacity(1);
end

function FamilyNoticeLayer:onCancelTap(event)
  self.parent:removeChild(self);
end

function FamilyNoticeLayer:onConfirmTap(event)
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
    sharedTextAnimateReward():animateStartByString("输入公告吧~");
    return;
  end
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_CHANGE_NOTICE,{ParamStr1=a},self));
  self:onCancelTap();
end