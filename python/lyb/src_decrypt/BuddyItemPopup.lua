--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-15

	yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";

BuddyItemPopup=class(Layer);

function BuddyItemPopup:ctor()
  self.class=BuddyItemPopup;
end

function BuddyItemPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	BuddyItemPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyItemPopup:initialize(skeleton, data, context, onViewTap, onChallenge, onPrivateTap, onAddTap, onInviteTap, position, isBuddy, hasFamily, cbfunction, isInBuddy, onDelete, hasReport, onReport)
  self:initLayer();
  local bg=LayerColorBackGround:getTransBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(bg);
  self.skeleton=skeleton;
  self.data=data;

  self.context=context;
  self.onFunc={onViewTap,onChallenge,onPrivateTap,onAddTap,onInviteTap,onDelete,onReport};
  self.isBuddy=isBuddy;
  self.cbfunction=cbfunction;
  self.isInBuddy=isInBuddy;
  self.onDelete=onDelete;
  self.hasReport=hasFamily;
  self.onReport=onReport;

  --骨骼
  local button_table={"查看","切磋"};
  if not isInBuddy then
    table.insert(button_table,isBuddy and "聊天" or "私聊");
  end
  if not isBuddy then
    table.insert(button_table,"加好友");
  end
  if isInBuddy then
    table.insert(button_table,"删除");
  end
  if hasFamily then
    table.insert(button_table,"邀家族");
  end
  if hasReport then
    table.insert(button_table,"举报");
  end
  local armature_name={"buddy_item_popup_pannel_new","buddy_item_popup_pannel","buddy_item_popup_pannel_5","buddy_item_popup_pannel_6"};
  armature_name=armature_name[-2+table.getn(button_table)];

  local armature=skeleton:buildArmature(armature_name);
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  for k,v in pairs(button_table) do
    local button=self.armature:getChildByName("common_copy_blueround_button_" .. k);print("common_copy_blueround_button_" .. k);
    local button_pos=convertBone2LB4Button(button);
    self.armature:removeChild(button);
    button=CommonButton.new();
    button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
    button:initializeText(armature:findChildArmature("common_copy_blueround_button_" .. k):getBone("common_copy_blueround_button").textData,v);
    button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,v);
    button:setPosition(button_pos);
    self.armature:addChild(button);
  end

  if position then
    self:setPos(position);
  end
end

function BuddyItemPopup:onButtonTap(event, data)
  local k=1;
  if "查看"==data then
    k=1;
  elseif "切磋"==data then
    k=2;
  elseif "私聊"==data or "聊天"==data then
    k=3;
  elseif "加好友"==data then
    k=4;
  elseif "邀家族"==data then
    k=5;
  elseif "删除"==data then
    k=6;
  elseif "举报"==data then
    k=7;
  end
  self.onFunc[k](self.context,self.data);
  self:closeTip();
end

function BuddyItemPopup:setPos(position)
  self.armature:setPosition(getTipPosition(self.armature,position));
end

function BuddyItemPopup:closeTip(event)
  if self.parent then
    if self.cbfunction then
      self.cbfunction(self.context);
    end
    self.parent:removeChild(self);
  end
end