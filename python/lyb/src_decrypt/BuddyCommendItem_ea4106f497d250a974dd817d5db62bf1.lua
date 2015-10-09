--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

BuddyCommendItem=class(Layer);

function BuddyCommendItem:ctor()
  self.class=BuddyCommendItem;
end

function BuddyCommendItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyCommendItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyCommendItem:initialize(skeleton, container_parent, data, container)
  self:initLayer();
  self.skeleton=skeleton;
  self.container_parent=container_parent;
  self.data=data;
  self.container=container;
  self.requested=false;

  --骨骼
  local armature=skeleton:buildArmature("commend_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='<content><font color="#E1D2A0">' .. self.data.UserName .. '</font></content>';
  self.name_descb=createRichMultiColoredLabelWithTextData(armature:getBone("name_descb").textData,text);
  self.name_descb:addEventListener(DisplayEvents.kTouchTap,self.onNameTap,self);
  self.armature:addChild(self.name_descb);

  text='<content><font color="#E1D2A0">Lv' .. self.data.Level .. '</font></content>';
  self.level_descb=createRichMultiColoredLabelWithTextData(armature:getBone("level_descb").textData,text);
  self.armature:addChild(self.level_descb);

  text='<content><font color="#FFF600" ref="1">加为好友</font></content>';
  self.operate_descb=createRichMultiColoredLabelWithTextData(armature:getBone("operate_descb").textData,text);
  self.operate_descb:addEventListener(DisplayEvents.kTouchTap,self.onOperateTap,self);
  self.armature:addChild(self.operate_descb);
end

function BuddyCommendItem:onNameTap(event)
  
end

function BuddyCommendItem:onOperateTap(event)
  if self.requested then
    return;
  end
  self.requested=true;
  self.operate_descb:removeEventListener(DisplayEvents.kTouchTap,self.onOperateTap,self);
  self.operate_descb:setString('<content><font color="#CCCCCC" ref="1">已申请</font></content>');
  self.container_parent:dispatchEvent(Event.new("chatAddBuddy",{UserName=self.data.UserName,UserId=self.data.UserId},self));
  self.container:onItemTap();
end