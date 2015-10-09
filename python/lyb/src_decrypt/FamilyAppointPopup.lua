--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";

FamilyAppointPopup=class(Layer);

function FamilyAppointPopup:ctor()
  self.class=FamilyAppointPopup;
end

function FamilyAppointPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FamilyAppointPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function FamilyAppointPopup:initialize(skeleton, familyProxy, userProxy, parent_container, data, position)
  self:initLayer();
  local bg=LayerColorBackGround:getTransBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(bg);
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.parent_container=parent_container;
  self.data=data;
  self.const_skew_y=62;
  self.buttons={0,0,0,0,0};
  self.button_texts={"族长","副族长","元老","精英","族员"};

  --骨骼
  local armature=skeleton:buildArmature("item_popup");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self:setButton();
  local text_data=armature:findChildArmature("common_copy_blueround_button"):getBone("common_copy_blueround_button").textData;
  self.armature:removeChild(self.armature:getChildByName("common_copy_blueround_button"));
  local max=0;
  local tab={};
  for k,v in pairs(self.buttons) do
    if 0~=v then
      table.insert(tab,v);
      max=1+max;
    end
  end
  self.buttons=tab;
  for k,v in pairs(self.buttons) do
    if 0~=v then
      local button=CommonButton.new();
      button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
      button:initializeText(text_data,self.button_texts[v]);
      button:setPositionXY(10,5+self.const_skew_y*(max-k));
      button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,v);
      self.armature:addChild(button);
      self.buttons[k]=button;
    end
  end
  
  local bgs={SizeDefine4Sprite9ridConfig.button1Size,
             SizeDefine4Sprite9ridConfig.button2Size,
             SizeDefine4Sprite9ridConfig.button3Size,
             SizeDefine4Sprite9ridConfig.button4Size,
             SizeDefine4Sprite9ridConfig.button5Size,
             SizeDefine4Sprite9ridConfig.button6Size};
 
  self.frame_bg=CommonSkeleton:getCommonBoneTexture9DisplayBySize("common_background_inner_2",false,bgs[max]);
  self.armature:addChildAt(self.frame_bg,0);

  if position then
    self:setPos(position);
  end
end

function FamilyAppointPopup:onButtonTap(event, data)
  if 1==data then
    local commonPopup=CommonPopup.new();
    commonPopup:initialize(StringUtils:getString4Popup(PopupMessageConstConfig.ID_142,{self.data.UserName}),self,self.onAppointLeaderTap,data,nil,nil,false,StringUtils:getButtonString4Popup(PopupMessageConstConfig.ID_142));
    self:addChild(commonPopup);
    return;
  end
  self:onAppointLeaderTap(data);
end

function FamilyAppointPopup:onAppointLeaderTap(data)
  self.parent_container:onAppointPopupTap(self.data,data);
  self:closeTip();
end

function FamilyAppointPopup:setButton()
  local authority={{{},{1,3,4,5},{2,4,5},{2,3,5},{2,3,4}},
                   {{},{},{4,5},{3,5},{3,4}},
                   {{},{},{},{5},{4}},
                   {{},{},{},{},{4}},
                   {{},{},{},{},{}}};
  local positionID=self.userProxy:getFamilyPositionID();
  local memberPositionID=self.data.FamilyPositionId;
  for k,v in pairs(authority[positionID][memberPositionID]) do
    self.buttons[v]=v;
  end
end

function FamilyAppointPopup:setPos(position)
  self.armature:setPosition(getTipPosition4Family(self.armature,position));
end

function FamilyAppointPopup:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end