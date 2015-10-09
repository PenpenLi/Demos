--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

InviteByGantanhaoItem=class(Layer);

function InviteByGantanhaoItem:ctor()
  self.class=InviteByGantanhaoItem;
end

function InviteByGantanhaoItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  InviteByGantanhaoItem.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function InviteByGantanhaoItem:initialize(skeleton, container_parent, data, container)
  self:initLayer();
  self.skeleton=skeleton;
  self.container_parent=container_parent;
  self.data=data;
  self.container=container;
  self.buddyListProxy=self.container.buddyListProxy;

  --骨骼
  local armature=skeleton:buildArmature("gantanhao_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text='<content><font color="#E1D2A0" ref="1">' .. self.data.UserName .. '</font></content>';
  self.name_descb=createRichMultiColoredLabelWithTextData(armature:getBone("name_descb").textData,text);
  self.name_descb:addEventListener(DisplayEvents.kTouchTap,self.onNameTap,self);
  self.armature:addChild(self.name_descb);

  text='<content><font color="#E1D2A0">Lv' .. (self.data.Level and self.data.Level or "0") .. '</font></content>';
  self.level_descb=createRichMultiColoredLabelWithTextData(armature:getBone("level_descb").textData,text);
  self.armature:addChild(self.level_descb);

  text='<content><font color="#00FF00" ref="1">同意</font></content>';
  self.operate_descb_1=createRichMultiColoredLabelWithTextData(armature:getBone("operate_descb_1").textData,text);
  self.operate_descb_1:addEventListener(DisplayEvents.kTouchTap,self.onOperate_1Tap,self);
  self.armature:addChild(self.operate_descb_1);

  text='<content><font color="#FF0000" ref="1">拒绝</font></content>';
  self.operate_descb_2=createRichMultiColoredLabelWithTextData(armature:getBone("operate_descb_2").textData,text);
  self.operate_descb_2:addEventListener(DisplayEvents.kTouchTap,self.onOperate_2Tap,self);
  self.armature:addChild(self.operate_descb_2);
end

function InviteByGantanhaoItem:select()
  self.selected=true;
  self.container_parent.buddyListProxy:deleteGantanhao(self.data.UserName);
  self.operate_descb_1:removeEventListener(DisplayEvents.kTouchTap,self.onOperate_1Tap,self);
  self.operate_descb_2:removeEventListener(DisplayEvents.kTouchTap,self.onOperate_2Tap,self);
  self.operate_descb_1:setString('<content><font color="#CCCCCC" ref="1">同意</font></content>');
  self.operate_descb_2:setString('<content><font color="#CCCCCC" ref="1">拒绝</font></content>');
end

function InviteByGantanhaoItem:onNameTap(event)
  
end

function InviteByGantanhaoItem:onOperate_1Tap(event)
  if self.selected then
    return;
  end
  if self.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString("好友已满了额~");
    return;
  end
  sendMessage(21,2,{UserId=self.data.UserId,UserName=self.data.UserName});
  self:select();
  sharedTextAnimateReward():animateStartByString("你接受了" .. self.data.UserName .. "的好友申请~");
  self.container:onItemTap();
end

function InviteByGantanhaoItem:onOperate_2Tap(event)
  if self.selected then
    return;
  end
  self:select();
  sharedTextAnimateReward():animateStartByString("你拒绝了" .. self.data.UserName .. "的好友申请~");
  self.container:onItemTap();
end