--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";

FamilyItemPopup=class(Layer);

function FamilyItemPopup:ctor()
  self.class=FamilyItemPopup;
end

function FamilyItemPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  FamilyItemPopup.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function FamilyItemPopup:initialize(skeleton, familyProxy, userProxy, buddyListProxy, parent_container, data, position, isLookInto)
  self:initLayer();
  local bg=LayerColorBackGround:getTransBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.closeTip,self);
  self:addChild(bg);
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.userProxy=userProxy;
  self.buddyListProxy=buddyListProxy;
  self.parent_container=parent_container;
  self.data=data;
  self.isLookInto=isLookInto;
  self.const_skew_y=62;--item_popup的每个render间隔
  self.buttons={1,2,3,4,0,0,0};
  self.button_texts={"查看","加好友","切磋",self.buddyListProxy:getBuddyData(self.data.UserName) and "聊天" or "私聊","任命","开除","弹劾"};

  --骨骼
  local armature=skeleton:buildArmature("item_popup");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  self:setButton();
  if 1==self.data.FamilyPositionId then
    self.buttons[7]=7;
  end
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
  local button_num=0;
  for k,v in pairs(self.buttons) do
    if 0~=v then button_num=1+button_num; end
  end
  for k,v in pairs(self.buttons) do
    if 0~=v then
      local button=CommonButton.new();
      button:initialize("common_blueround_button_normal","common_blueround_button_down",CommonButtonTouchable.BUTTON);
      button:initializeText(text_data,self.button_texts[v]);
      button:setPositionXY(10,(4==button_num and 20 or 5)+self.const_skew_y*(max-k));
      button:addEventListener(DisplayEvents.kTouchTap,self.onButtonTap,self,v);
      local gray=false;
      if 7==v then
        gray=not self.familyProxy:getImpeachable();
        button:setGray(gray);
      end
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

function FamilyItemPopup:onButtonTap(event, data)
  self.parent_container:onItemPopupTap(event,self.data,data);
  self:closeTip();
end

function FamilyItemPopup:setButton()
  local authority={{{},{5,6},{5,6},{5,6},{5,6}},
                   {{},{},{5,6},{5,6},{5,6}},
                   {{},{},{},{5,6},{5,6}},
                   {{},{},{},{},{}},
                   {{},{},{},{},{}}};
  local positionID=self.userProxy:getFamilyPositionID();
  local memberPositionID=self.data.FamilyPositionId;
  if self.buddyListProxy:getBuddyData(self.data.UserName) then
    self.buttons[2]=0;
  end
  if self.isLookInto then
    
  else
    for k,v in pairs(authority[positionID][memberPositionID]) do
      self.buttons[v]=v;
    end
  end
end

function FamilyItemPopup:setPos(position)
  self.armature:setPosition(getTipPosition4Family(self.armature,position));
end

function FamilyItemPopup:closeTip(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end