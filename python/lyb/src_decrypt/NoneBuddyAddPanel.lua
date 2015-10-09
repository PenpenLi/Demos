--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-1

	yanchuan.xie@happyelements.com
]]

require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.controls.TextInput";

NoneBuddyAddPanel=class(LayerColor);

function NoneBuddyAddPanel:ctor()
  self.class=NoneBuddyAddPanel;
end

function NoneBuddyAddPanel:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	NoneBuddyAddPanel.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function NoneBuddyAddPanel:initialize(skeleton, context, onConfirm, onCancel)
  self:initLayer();
  
  local armature=skeleton:buildArmature("none_buddy_add_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;

  local text="还没有好友哦，输入好友的名字吧~";
  local none_buddy_add_panel_text=createRichMultiColoredLabelWithTextData(armature:getBone("none_buddy_add_panel_text").textData,text);
  armature.display:addChild(none_buddy_add_panel_text);
  
  local textData=armature:getBone("text_input_bg").textData;
  local confirmTextData=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  local cancelTextData=armature:findChildArmature("common_copy_greenroundbutton"):getBone("common_copy_blueround_button").textData;
  armature=armature.display;
  self:addChild(armature);
  
  --confirmButton
  local confirmButton=armature:getChildByName("common_copy_blueround_button");
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armature:removeChild(confirmButton);
  
  --cancelButton
  local cancelButton=armature:getChildByName("common_copy_greenroundbutton");
  local cancelButton_pos=convertBone2LB4Button(cancelButton);
  armature:removeChild(cancelButton);
  
  
  --common_descb
  self.textInput=TextInput.new("请输入...",textData.size,makeSize(textData.width,textData.height));
  self.textInput:setPositionXY(textData.x,textData.y);
  armature:addChild(self.textInput);
  
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  confirmButton:initializeText(confirmTextData,"确定");
  confirmButton:setPosition(confirmButton_pos);
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature:addChild(confirmButton);
  
  cancelButton=CommonButton.new();
  cancelButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  cancelButton:initializeText(cancelTextData,"取消");
  cancelButton:setPosition(cancelButton_pos);
  cancelButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  armature:addChild(cancelButton);
  
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  local popupSize=armature:getChildAt(1):getContentSize();
  armature:setPositionXY((size.width-popupSize.width)/2,(size.height-popupSize.height)/2);
  
  self:setColor(ccc3(0,0,0));
  self:setOpacity(125);
  self.context=context;
  self.onConfirm=onConfirm;
  self.confirmData=confirmData;
  self.onCancel=onCancel;
  self.cancelData=cancelData;
end

function NoneBuddyAddPanel:onCloseButtonTap(event)
  if self.onCancel then
    self.onCancel(self.context);
  end
  self:removePopup();
end

function NoneBuddyAddPanel:onConfirmButtonTap(event)
  if self.onConfirm then
    local a=self.textInput:getInputText();
    self.onConfirm(self.context,a);
  end
  self:removePopup();
end

function NoneBuddyAddPanel:removePopup()
  self.parent:removeChild(self);
end