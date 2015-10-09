--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-1

	yanchuan.xie@happyelements.com
]]

require "core.display.Layer";
require "core.controls.CommonButton";
require "core.events.DisplayEvent";
require "core.skeleton.SkeletonFactory";

DegradePopup=class(LayerColor);

function DegradePopup:ctor()
  self.class=DegradePopup;
end

function DegradePopup:dispose()
  self:removeChildren();
	self:removeAllEventListeners();
	DegradePopup.superclass.dispose(self);
  self.removeArmature:dispose()
end

function DegradePopup:initialize(skeleton, item_select, context, onConfirm, confirmData, onCancel, cancelData)
  self:initLayer();
  self.vipLV=context.userProxy:getVipLevel();

  local armature=skeleton:buildArmature("degrade_popup");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  
  local equip_level_descb_text_data=armature:getBone("equip_level_descb").textData;
  local equip_degrade_descb_text_data=armature:getBone("equip_degrade_descb").textData;
  local back_fee_descb_text_data=armature:getBone("back_fee_descb").textData;
  local equip_level_text_data=armature:getBone("equip_level").textData;
  local equip_degrade_text_data=armature:getBone("equip_degrade").textData;
  local back_fee_text_data=armature:getBone("back_fee").textData;
  local confirmTextData=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  local cancelTextData=armature:findChildArmature("common_copy_blueround_button0"):getBone("common_copy_blueround_button").textData;
  armature=armature.display;
  self:addChild(armature);
  
  
  --confirmButton
  local confirmButton=armature:getChildByName("common_copy_blueround_button");
  local confirmButton_pos=convertBone2LB4Button(confirmButton);
  armature:removeChild(confirmButton);
  --cancelButton
  local cancelButton=armature:getChildByName("common_copy_blueround_button0");
  local cancelButton_pos=convertBone2LB4Button(cancelButton);
  armature:removeChild(cancelButton);
  
  
  --equip_level_descb
  local text=item_select:getStrengthLevel();
  local equip_level_descb=createTextFieldWithTextData(equip_level_descb_text_data,text);
  armature:addChild(equip_level_descb);
  
  --equip_degrade_descb
  text=self:getDegradeBound(item_select);
  local equip_degrade_descb=createTextFieldWithTextData(equip_degrade_descb_text_data,text);
  armature:addChild(equip_degrade_descb);
  
  --back_fee_descb
  text=StrengthenFormula:getDegradeSilver(item_select,self.vipLV);
  local back_fee_descb=createTextFieldWithTextData(back_fee_descb_text_data,text);
  armature:addChild(back_fee_descb);

  text="当前等级 :";
  local equip_level=createTextFieldWithTextData(equip_level_text_data,text);
  armature:addChild(equip_level);

  text="降级效果 :";
  local equip_degrade=createTextFieldWithTextData(equip_degrade_text_data,text);
  armature:addChild(equip_degrade);

  text="返回费用 :";
  local back_fee=createTextFieldWithTextData(back_fee_text_data,text);
  armature:addChild(back_fee);
  
  --confirmButton
  confirmButton=CommonButton.new();
  confirmButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  confirmButton:initializeText(confirmTextData,"降级");
  confirmButton:setPosition(confirmButton_pos);
  confirmButton:addEventListener(DisplayEvents.kTouchTap,self.onConfirmButtonTap,self);
  armature:addChild(confirmButton);
  --cancelButton
  cancelButton=CommonButton.new();
  cancelButton:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
  cancelButton:initializeText(cancelTextData,"取消");
  cancelButton:setPosition(cancelButton_pos);
  cancelButton:addEventListener(DisplayEvents.kTouchTap,self.onCloseButtonTap,self);
  armature:addChild(cancelButton);

  self.closeButton=Button.new(self.removeArmature:findChildArmature("common_copy_close_button"),false);
  self.closeButton:addEventListener(Events.kStart,self.onCloseButtonTap,self);
  
  local size=makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT);
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

function DegradePopup:onCloseButtonTap(event)
  if self.onCancel then
    self.onCancel(self.context,self.cancelData);
  end
  self:removePopup();
end

function DegradePopup:onConfirmButtonTap(event)
  if self.onConfirm then
    self.onConfirm(self.context,self.confirmData);
  end
  self:removePopup();
end

function DegradePopup:removePopup()
  self.parent:removeChild(self);
end

function DegradePopup:getDegradeBound(item_select)
  local type=analysis("Zhuangbei_Zhuangbeibiao",item_select:getBagItemData().ItemId,"attribute");
  type=analysis("Wujiang_Wujiangshuxing",type,"name");
  local value=item_select:getEquipmentInfo().PreStrengthenValue;
  return type .. " -" .. value;
end