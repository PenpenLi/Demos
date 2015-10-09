-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-3-1

-- yanchuan.xie@happyelements.com
  
require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.skeleton.SkeletonFactory";

CommonPopupCloseButtonPram={};
CommonPopupCloseButtonPram.DEFAULT = 1;
CommonPopupCloseButtonPram.CONFIRM = 2;
CommonPopupCloseButtonPram.CANCLE = 3;

CommonPopup=class(LayerColor);

CommonPopup.commonPopupArr = {};

function CommonPopup:ctor()
  self.class=CommonPopup;
  table.insert(CommonPopup.commonPopupArr, self);
  self.isAutoClose = true
end

function CommonPopup:dispose()
  for k,v in pairs(CommonPopup.commonPopupArr) do
    if self == v then
      table.remove(CommonPopup.commonPopupArr,k);
      break;
    end
  end
  self:removeChildren();
	self:removeAllEventListeners();
	CommonPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function CommonPopup:initialize(text_string, context, onConfirm, confirmData, onCancel, cancelData, confirm_boolean, text_table, isColorLabel, allsceenMiddle, isJustClose, left_button_red, right_button_red)
  if not isJustClose then 
    isJustClose = CommonPopupCloseButtonPram.DEFAULT;
  end
  self.isJustClose = isJustClose
  self:initLayer();
  if nil==text_table then
    text_table={"确定","取消"};
  end
  
  local armature=CommonSkeleton:buildArmature("common_popup_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose = armature;
  
  local textData=armature:getBone("common_descb").textData;
  local confirmTextArm=armature:findChildArmature("common_blueround_button");
  local confirmTextData = confirmTextArm:getBone("common_blue_button").textData
 
  armature=armature.display;
  self:addChild(armature);
  
  -- armature:getChildByName("common_biShua1_1"):setScaleX(0.8);
  -- armature:getChildByName("common_biShua1_2"):setScaleX(0.8);
  -- armature:getChildByName("common_biShua2_10"):setScaleY(0.5);
  -- armature:getChildByName("common_biShua2_1"):setScaleY(0.5);
  
  --confirmButton
  local confirmButton=armature:getChildByName("common_blueround_button");
  local button_name = left_button_red and "commonButtons/common_red_button_normal" or "commonButtons/common_blue_button_normal";
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armature:removeChild(confirmButton);
  
  --cancelButton
  local cancelButton=armature:getChildByName("common_blueround_button_1");
  local button_name_1 = right_button_red and "commonButtons/common_red_button_normal" or "commonButtons/common_blue_button_normal";
  local cancelButton_pos=convertBone2LB4Button(cancelButton);
  armature:removeChild(cancelButton);
  
  -- closebutton
  -- local closeButton=armature:getChildByName("common_close_button");
  -- local closeButton_pos=convertBone2LB4Button(closeButton);
  -- armature:removeChild(closeButton);

  --common_descb
  local text=text_string;

  if isColorLabel then
    self.common_descb=createMultiColoredLabelWithTextData(textData,text);
    self.common_descb:setPositionY(self.common_descb:getPositionY() + 130)
  else
    self.common_descb=createTextFieldWithTextData(textData,text);
    self.common_descb:setPositionY(self.common_descb:getPositionY())
  end
  armature:addChild(self.common_descb);
    
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize(button_name,nil,CommonButtonTouchable.BUTTON);
  confirmButton:initializeBMText(text_table[1],"anniutuzi");
  -- confirmButton:initializeText(confirmTextData,text_table[1]);
  if confirm_boolean then
    confirmButton:setPositionXY(math.floor(confirmButton_pos.x/2+cancelButton_pos.x/2),math.floor(confirmButton_pos.y/2+cancelButton_pos.y/2));
  else
    confirmButton:setPosition(confirmButton_pos);
  end
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature:addChild(confirmButton);
  
  --cancelButton
  if confirm_boolean then
    
  else
    cancelButton=CommonButton.new();
    cancelButton:initialize(button_name_1,nil,CommonButtonTouchable.BUTTON);
    --cancelButton:initializeText(confirmTextData,text_table[2]);
    cancelButton:initializeBMText(text_table[2],"anniutuzi");
    cancelButton:setPosition(cancelButton_pos);
    cancelButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
    armature:addChild(cancelButton);
    self.cancelButton = cancelButton
  end
  
  -- closeButton=CommonButton.new();
  -- closeButton:initialize("commonButtons/common_close_button_normal","commonButtons/common_close_button_down",CommonButtonTouchable.BUTTON);
  -- -- cancelButton:initializeText(closeTextData,"");
  -- closeButton:setPosition(closeButton_pos);
  -- closeButton:addEventListener(DisplayEvents.kTouchTap,self.onSmallCloseButtonTap,self);
  -- armature:addChild(closeButton);

  self.closeButton =self.armature4dispose.display:getChildByName("common_close_button");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.onSmallCloseButtonTap, self);

  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);


  --armature:setPositionXY(450,300);
  local popupSize=armature:getChildByName("common_copy_panel_4"):getContentSize();

  if allsceenMiddle then
    armature:setPositionXY(math.floor((size.width-popupSize.width)/2),math.floor((size.height-popupSize.height)/2));
  else
    armature:setPositionXY(math.floor((GameConfig.STAGE_WIDTH-popupSize.width)/2),math.floor((GameConfig.STAGE_HEIGHT-popupSize.height)/2));
  end
  
  self:setColor(ccc3(0,0,0));
  self:setPositionXY(-GameData.uiOffsetX, -GameData.uiOffsetY)
  self:setOpacity(125);
  self.context=context;
  self.onConfirm=onConfirm;
  self.confirmData=confirmData;
  self.onCancel=onCancel;
  self.cancelData=cancelData;
	
end

function CommonPopup:initializeTitle(title_str)

  local title_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_huaWen2");
  title_bg:setScale(0.7);
  title_bg:setScaleY(0.9);
  title_bg:setPositionXY(120,290);
  self.armature4dispose.display:addChild(title_bg);

  local textField = TextField.new(CCLabelTTF:create(title_str,FontConstConfig.OUR_FONT,30));
  local size = title_bg:getContentSize();
  size.width = 0.7 * size.width;
  size.height = 0.9 * size.height;
  local text_size = textField:getContentSize();
  textField.sprite:setColor(ccc3(255,245,215));
  textField:setPositionXY(120+(size.width-text_size.width)/2, 293+(size.height-text_size.height)/2);
  self.armature4dispose.display:addChild(textField);
end

function CommonPopup:setDescbXY(x, y)
  self.common_descb:setPositionXY(x, y)
end

function CommonPopup:onCloseButtonTap(event)
  if self.isAutoClose then
    self:removePopup();
  end 
  if self.onCancel then
    self.onCancel(self.context,self.cancelData);
  end
end

function CommonPopup:onSmallCloseButtonTap(event)
  if CommonPopupCloseButtonPram.DEFAULT == self.isJustClose then

  elseif CommonPopupCloseButtonPram.CONFIRM == self.isJustClose then
    if self.onConfirm then
      self.onConfirm(self.context,self.confirmData);
    end
  elseif CommonPopupCloseButtonPram.CANCLE == self.isJustClose then
    if self.onCancel then
      self.onCancel(self.context,self.cancelData);
    end
  end
  self:removePopup();
end

function CommonPopup:onConfirmButtonTap(event)
  if self.isAutoClose then
    self:removePopup();
  end  
  if self.onConfirm then
    self.onConfirm(self.context,self.confirmData);
  end
end

function CommonPopup:removePopup()
  self.parent:removeChild(self);
end

function CommonPopup:isAutoCloseUI(value)
  self.isAutoClose = value
end

function CommonPopup:closeButtonVisible(value)
  self.closeButton:setVisible(value)
end

-- 背景是否模态
function CommonPopup:isBackModal(value)
  self.touchEnabled = value

  if value then
    self:setOpacity(125);
  else
    self:setOpacity(0);
  end
end