--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "main.view.chat.ui.chatPopup.BuddyCommendItem";

BuddyCommendLayer=class(Layer);

function BuddyCommendLayer:ctor()
  self.class=BuddyCommendLayer;
end

function BuddyCommendLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyCommendLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

function BuddyCommendLayer:initialize(skeleton, container_parent)
  self:initLayer();
  self.skeleton=skeleton;
  self.container_parent=container_parent;
  self.const_item_num=4.3;
  self.items={};

  local bg=LayerColorBackGround:getTransBackGround();
  bg:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self:addChild(bg);

  --骨骼
  local armature=skeleton:buildArmature("commend_pannel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self.armature:setPositionXY(225,89);
  self:addChild(self.armature);

  local text='<content><font color="#E1D2A0">好友升级时，你可以获得</font><font color="#00FF00">经验</font><font color="#E1D2A0">奖励！</font></content>';
  self.descb=createRichMultiColoredLabelWithTextData(armature:getBone("descb").textData,text);
  self.armature:addChild(self.descb);

  self.commend_button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.commend_button.bone:initTextFieldWithString("common_copy_bluelonground_button","一键申请");
  self.commend_button:addEventListener(Events.kStart,self.onCommendButtonTap,self);

  self.listScrollViewLayer=FlexibleListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setViewSize(makeSize(304,250));
  self.listScrollViewLayer:setPositionXY(22,80);
  self.armature:addChild(self.listScrollViewLayer);

  local size=Director:sharedDirector():getWinSize();
  local popupSize=self.armature:getChildAt(1):getContentSize();
  self.armature:setPositionXY((size.width-popupSize.width)/2,(size.height-popupSize.height)/2);

  initializeSmallLoading();
  self.container_parent:dispatchEvent(Event.new(ChatNotifications.CHAT_REQUEST_BUDDY_COMMEND,nil,self));
end

function BuddyCommendLayer:onCommendButtonTap(event)
  for k,v in pairs(self.items) do
    v:onOperateTap();
  end
  self:onSelfTap();
end

function BuddyCommendLayer:onSelfTap(event)
  if self.parent then
    self.parent:removeChild(self);
  end
end

function BuddyCommendLayer:onItemTap()
  for k,v in pairs(self.items) do
    if not v.selected then
      return;
    end
  end
  self:onSelfTap();
end

function BuddyCommendLayer:initializeData(userRelationArray)
  uninitializeSmallLoading();
  for k,v in pairs(userRelationArray) do
    local a=BuddyCommendItem.new();
    a:initialize(self.skeleton,self.container_parent,v,self);
    self.listScrollViewLayer:addItem(a);
    table.insert(self.items,a);
  end
end