--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-4-15

  yanchuan.xie@happyelements.com
]]

require "core.controls.Button";
require "core.events.DisplayEvent";
require "core.utils.Scheduler";
require "core.controls.CommonPopup";
require "main.config.XiShuConfig";
require "main.view.chat.ui.chatPopup.BuddyFeedItem";
require "main.view.chat.ui.chatPopup.BuddyCommendLayer";

BuddyFeedLayer=class(Layer);

function BuddyFeedLayer:ctor()
  self.class=BuddyFeedLayer;
end

function BuddyFeedLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
  BuddyFeedLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:deleteTextureLua("resource/image/arts/P116.lua");
  BitmapCacher:deleteTextureLua("resource/image/arts/P2499.lua");
end

function BuddyFeedLayer:initialize(skeleton, container_parent)
  self:initLayer();
  self.skeleton=skeleton;
  self.container_parent=container_parent;
  self.chatListProxy=self.container_parent.chatListProxy;
  self.buddyListProxy=self.container_parent.buddyListProxy;
  self.generalListProxy=self.container_parent.generalListProxy;
  self.data_initialized=false;
  -- self.const_ids={"116_1001","116_1002","116_1003","116_1004","116_1005","116_1006","116_1007","116_1008"};
  self.const_ids={"116_1001"};
  self.const_num={0,15,30,45,60,75,90,100};
  self.select_num=nil;
  
  --骨骼
  local armature=skeleton:buildArmature("buddy_feed_panel");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text="当前累计经验 :";
  self.exp=createTextFieldWithTextData(armature:getBone("exp").textData,text);
  self.armature:addChild(self.exp);

  text="";
  self.exp_descb=createTextFieldWithTextData(armature:getBone("exp_descb").textData,text);
  self.armature:addChild(self.exp_descb);

  text="说明: 你的好友升级时将会为你的经验球中注入一些经验, 经验蓄满后, 可以点击经验球领取奖励.";
  self.descb=createTextFieldWithTextData(armature:getBone("descb").textData,text);
  self.armature:addChild(self.descb);

  self.commend_button=Button.new(armature:findChildArmature("common_copy_bluelonground_button"),false);
  self.commend_button.bone:initTextFieldWithString("common_copy_bluelonground_button","好友推荐");
  self.commend_button:addEventListener(Events.kStart,self.onCommendButtonTap,self);

  self.listScrollViewLayer=FlexibleListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setViewSize(makeSize(473,365));
  self.listScrollViewLayer:setPositionXY(216,42);
  self:addChild(self.listScrollViewLayer);

  self.get_exp_layer=LayerColor.new();
  self.get_exp_layer:initLayer();
  self.get_exp_layer:changeWidthAndHeight(135,110);
  self.get_exp_layer:setColor(ccc3(0,0,0));
  self.get_exp_layer:setOpacity(1);
  self.get_exp_layer:setPositionXY(43,310);
  self.get_exp_layer:addEventListener(DisplayEvents.kTouchTap,self.onGetEXPTap,self);
  self:addChild(self.get_exp_layer);
end

function BuddyFeedLayer:addFeed(data)
  local a=BuddyFeedItem.new();
  a:initialize(self.skeleton,self,data,makeSize(473,25));
  self.listScrollViewLayer:addItem(a,true);
  if ConstConfig.CHAT_MAX_FEED_ITEM<self.listScrollViewLayer:getItemCount() then
    self.listScrollViewLayer:removeItemAt(0);
    self.listScrollViewLayer:scrollToItemByIndex(-1+ConstConfig.CHAT_MAX_FEED_ITEM);
  end
end

function BuddyFeedLayer:onCommendButtonTap(event)
  if self.buddyCommendLayer then
    self:removeChild(self.buddyCommendLayer);
    self.buddyCommendLayer=nil;
  end
  if self.buddyListProxy:getBuddyNumFull() then
    sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_63));
    return;
  end
  self.buddyCommendLayer=BuddyCommendLayer.new();
  self.buddyCommendLayer:initialize(self.skeleton,self.container_parent);
  self:addChild(self.buddyCommendLayer);
end

function BuddyFeedLayer:onGetEXPTap(event)
  if table.getn(self.const_num)==self.select_num then
    self.container_parent:dispatchEvent(Event.new(ChatNotifications.CHAT_BUDDY_FEED_GET_EXP,nil,self));
    return;
  end
  sharedTextAnimateReward():animateStartByString("经验没有满,不能领取哦~");
end

function BuddyFeedLayer:initializeData()
  self:refreshFeedEXP();
  if self.data_initialized then
    return;
  end
  local friendLogArray=self.chatListProxy:getBuddyFeedArray();
  for k,v in pairs(friendLogArray) do
    self:addFeed(v);
  end
  self.data_initialized=true;
end

function BuddyFeedLayer:refreshFeedEXP()
  local expball=analysis("Wujiang_Wujiangshengji",self.generalListProxy:getLevel(),"expball");
  local exp_m=expball;
  local exp=self.chatListProxy:getBuddyFeedEXP();
  if exp>expball then
    exp=expball;
  end
  self.exp_descb:setString(exp .. "/" .. expball);
  expball=1+math.floor(7*exp/expball);
  if self.select_num==expball then
    return;
  end
  self.select_num=expball;
  if self.exp_img then
    self.armature:removeChild(self.exp_img);
    self.armature.removeChild(self.exp_img_mask);
    self.exp_img=nil;
    self.exp_img_mask=nil;
  end
  self.exp_img=cartoonPlayer(self.const_ids[self.select_num],109,365,0);
  self.exp_img.touchEnable=false;
  self.armature:addChild(self.exp_img);
  self.exp_img_mask=self.skeleton:getBoneTextureDisplay("exp_img");
  self.exp_img_mask.sprite:setAnchorPoint(CCPointMake(0.5,0.5));
  self.exp_img_mask:setPositionXY(109,365);
  self.armature:addChild(self.exp_img_mask);
  if not self.exp_effect then
    self.exp_effect=cartoonPlayer(EffectConstConfig.BUDDY_FEED_EXP,ccp(109,365),0);
    self.exp_effect.touchEnable=false;
    self.armature:addChild(self.exp_effect);
  end
  self.exp_effect:setVisible(exp>=exp_m);
end