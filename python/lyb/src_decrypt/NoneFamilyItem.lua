--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.chat.ui.chatPopup.BuddyItemPopup";

NoneFamilyItem=class(TouchLayer);

function NoneFamilyItem:ctor()
  self.class=NoneFamilyItem;
end

function NoneFamilyItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	NoneFamilyItem.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function NoneFamilyItem:initialize(parent_container, data)
  self:initLayer();
  self.parent_container=parent_container;
  self.skeleton=self.parent_container.skeleton;
  self.familyProxy=self.parent_container.familyProxy;
  self.userProxy=self.parent_container.userProxy;
  self.bagProxy=self.parent_container.bagProxy;
  self.buddyListProxy=self.parent_container.buddyListProxy;
  self.chatListProxy=self.parent_container.chatListProxy;
  self.data=data;
  self.data.MaxCount=analysis("Jiazu_Jiazushengjibiao",self.data.FamilyLevel,"renshu");
  self.isUserFamily=self.data.FamilyId==self.userProxy:getFamilyID();
  
  --骨骼
  local armature=self.skeleton:buildArmature("none_family_ui_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text=0==self.data.Ranking and "未上榜" or self.data.Ranking;
  local text_data=armature:getBone("rank_descb").textData;
  self.rank_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.rank_descb);

  text=self.data.FamilyName;
  text_data=armature:getBone("family_name_descb").textData;
  self.family_name_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.family_name_descb);

  -- text='<content><font color="#00FF00" ref="1">' .. StringUtils:substr(self.data.UserName) .. '</font></content>';
  -- text_data=armature:getBone("family_leader_descb").textData;
  -- self.family_leader_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- self.family_leader_descb:addEventListener(DisplayEvents.kTouchTap,self.onFamilyLeaderDescbTap,self);
  -- self.armature:addChild(self.family_leader_descb);
  text=StringUtils:substr(self.data.UserName);
  text_data=armature:getBone("family_leader_descb").textData;
  self.family_leader_descb=createTextFieldWithTextData(text_data,text);
  --self.family_leader_descb:addEventListener(DisplayEvents.kTouchTap,self.onFamilyLeaderDescbTap,self);
  self.armature:addChild(self.family_leader_descb);

  text=self.data.FamilyLevel;
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  text=self.data.Count .. "/" .. self.data.MaxCount;
  text_data=armature:getBone("population_descb").textData;
  self.population_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.population_descb);

  text="已满员";
  text_data=armature:getBone("manyuan_descb").textData;
  self.manyuan_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.manyuan_descb);

  -- text="";
  -- text_data=armature:getBone("operation_1").textData;
  -- self.operation_1=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- self.operation_1:addEventListener(DisplayEvents.kTouchTap,self.onApply,self);
  -- self.armature:addChild(self.operation_1);
  -- self:refreshFamilyApply(self.data.IsApplied);
  -- self.operation_1:setVisible(not self.container.isLookInto);
  local button=self.armature:getChildByName("operation");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal","commonButtons/common_small_orange_button_normal",CommonButtonTouchable.CUSTOM);
  button:initializeText(self.armature4dispose:findChildArmature("operation"):getBone("common_small_blue_button").textData,"申请");
  --button:initializeBMText("创建家族","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onApply,self);
  self.armature:addChild(button);
  self.button=button;
  -- self.button:setVisible(not self.container.isLookInto);

  --[[if self.isUserFamily then
    text='<content><font color="#CCCCCC" ref="1">查看</font></content>';
  else
    text='<content><font color="#00FF00" ref="1">查看</font></content>';
  end
  text_data=armature:getBone("operation_2").textData;
  self.operation_2=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  if not self.isUserFamily then
    self.operation_2:addEventListener(DisplayEvents.kTouchTap,self.onLookIntoFamily,self);
  end
  self.armature:addChild(self.operation_2);
  if self.container.isLookInto then
    self.operation_2:setPositionX(-39+self.operation_2:getPositionX());
  end]]
end

function NoneFamilyItem:onFamilyLeaderDescbTap(event)
  local buddyItemPopup=BuddyItemPopup.new();
  buddyItemPopup:initialize(self.chatListProxy:getSkeleton(),{},self,
                            self.onViewTap,self.onChallenge,self.onPrivateTap,
                            self.onAddTap,self.onInviteTap,event.globalPosition,self.buddyListProxy:getBuddyData(self.data.UserName),0~=self.userProxy:getFamilyID());
  self.parent_container:addChild(buddyItemPopup);
end

function NoneFamilyItem:onViewTap()
  self.parent_container:onItemPopupTap(nil,{UserName=self.data.UserName},1);
end

function NoneFamilyItem:onChallenge()
  self.parent_container:onItemPopupTap(nil,{UserId = self.data.UserId, UserName=self.data.UserName},3);
end

function NoneFamilyItem:onPrivateTap()
  self.parent_container:onItemPopupTap(nil,{UserName=self.data.UserName},4);
end

function NoneFamilyItem:onAddTap()
  self.parent_container:onItemPopupTap(nil,{UserName=self.data.UserName},2);
end

function NoneFamilyItem:onInviteTap()
  self.parent_container:dispatchEvent(Event.new("invite_family",{UserName=self.data.UserName},self));
end

function NoneFamilyItem:onLookIntoFamily(event)
  initializeSmallLoading();
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.LOOK_INTO_FAMILY,{FamilyId=self.data.FamilyId},self));
end

function NoneFamilyItem:onApply(event)
  if 0~=self.userProxy:getFamilyID() then
    sharedTextAnimateReward():animateStartByString("您已被同意加入家族了哦~");
    self.container:onCloseButtonTap();
    return;
  end
  --self.operation_1.touchEnabled=false;
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_APPLY,{FamilyId=self.data.FamilyId,FamilyName="",UserId=0,UserName="",BooleanValue=1==self.data.IsApplied and 0 or 1},self));
end

function NoneFamilyItem:refreshFamilyApply(bool)
  self.data.IsApplied=bool;
  if 1==self.data.IsApplied then
    -- text='<content><font color="#CCCCCC" ref="1">已申请</font></content>';
    -- self.operation_1.touchEnabled=false;
  elseif self.data.Count==self.data.MaxCount then
    -- text='<content><font color="#FF0000" ref="1">已满员</font></content>';
    -- self.operation_1.touchEnabled=true;
  else
    -- text='<content><font color="#00FF00" ref="1">申请</font></content>';
    -- self.operation_1.touchEnabled=true;
  end
  -- self.operation_1:setString(text);
end