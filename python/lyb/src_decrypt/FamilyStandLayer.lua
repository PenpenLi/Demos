--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyStandLayer=class(TouchLayer);

function FamilyStandLayer:ctor()
  self.class=FamilyStandLayer;
end

function FamilyStandLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyStandLayer.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyStandLayer:initialize(skeleton, familyProxy, parent_container, data)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  self.data=data;
  self.tab_buttons={};
  
  --骨骼
  local armature=skeleton:buildArmature("stand_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local a={"",""};
  local b=0;
  while #a>b do
    b=1+b;

    --common_copy_tab_button
    local common_copy_tab_button=self.armature:getChildByName("stand_" .. b .. "_button");
    local common_copy_tab_button_pos=convertBone2LB4Button(common_copy_tab_button);
    self.armature:removeChild(common_copy_tab_button);

    common_copy_tab_button=CommonButton.new();
    common_copy_tab_button:initialize("stand_" .. b .. "_normal","stand_" .. b .. "_down",CommonButtonTouchable.CUSTOM,self.skeleton);
    common_copy_tab_button:setPosition(common_copy_tab_button_pos);
    common_copy_tab_button:addEventListener(DisplayEvents.kTouchTap,self.onTabButtonTap,self,b);
    self.armature:addChild(common_copy_tab_button);

    table.insert(self.tab_buttons,common_copy_tab_button);
  end

  local button=Button.new(armature:findChildArmature("common_copy_greenroundbutton"),false);
  button.bone:initTextFieldWithString("common_copy_greenroundbutton","取消");
  button:addEventListener(Events.kStart,self.onCancelTap,self);

  button=Button.new(armature:findChildArmature("common_copy_blueround_button"),false);
  button.bone:initTextFieldWithString("common_copy_blueround_button","确定");
  button:addEventListener(Events.kStart,self.onConfirmTap,self);

  self:onTabButtonTap(nil,1);
end

function FamilyStandLayer:onCancelTap(event)
  self.parent:removeChild(self);
end

function FamilyStandLayer:onConfirmTap(event)
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_STAND_SELECT,{StandID=self.tab_id},self));
  self:onCancelTap();
end

function FamilyStandLayer:onTabButtonTap(event, data)
  if self.tab_button_tap then
    self.tab_button_tap:select(false);
    self.tab_panel_select=nil;
  end
  self.tab_id=data;
  self.tab_button_tap=self.tab_buttons[self.tab_id];
  self.tab_button_tap:select(true);
end