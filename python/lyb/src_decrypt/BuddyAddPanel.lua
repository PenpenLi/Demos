--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-1

	yanchuan.xie@happyelements.com
]]

require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.controls.TextInput";

BuddyAddPanel=class(Layer);

function BuddyAddPanel:ctor()
  self.class=BuddyAddPanel;
end

function BuddyAddPanel:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	BuddyAddPanel.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyAddPanel:initialize(context)
  self:initLayer();
  self.context=context;
  self.skeleton=self.context.skeleton;
  
  local armature=self.skeleton:buildArmature("add_buddy_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature=armature;
  self.armature4dispose=armature;

  local text="输入玩家名字";
  local buddy_add_panel_text=createRichMultiColoredLabelWithTextData(armature:getBone("descb").textData,text);
  self.armature.display:addChild(buddy_add_panel_text);
  
  local textData=armature:getBone("text_input_bg").textData;
  local confirmTextData=armature:findChildArmature("confirm_button"):getBone("common_small_blue_button").textData;
  self:addChild(armature.display);
  
  --confirmButton
  local confirmButton=armature.display:getChildByName("confirm_button");
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armature.display:removeChild(confirmButton);
  
  --common_descb
  self.textInput=TextInput.new("请输入...",textData.size,makeSize(textData.width,textData.height));
  self.textInput:setPositionXY(textData.x,textData.y);
  armature.display:addChild(self.textInput);
  
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("commonButtons/common_blue_button_normal","commonButtons/common_blue_button_down",CommonButtonTouchable.BUTTON);
  confirmButton:initializeText(confirmTextData,"加好友");
  confirmButton:setPosition(confirmButton_pos);
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature.display:addChild(confirmButton);
end

function BuddyAddPanel:onConfirmButtonTap(event)
  self.context:onAddBuddy(self.textInput:getInputText());
end