--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyApplyItem=class(TouchLayer);

function FamilyApplyItem:ctor()
  self.class=FamilyApplyItem;
end

function FamilyApplyItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyApplyItem.superclass.dispose(self);

  BitmapCacher:removeUnused();
  self.armature4dispose:dispose();
end

--
function FamilyApplyItem:initialize(skeleton, familyProxy, parent_container, data, container)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  self.data=data;
  self.container=container;
  
  --骨骼
  local armature=skeleton:buildArmature("apply_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local text=self.data.UserName;
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  text=self.data.Level;
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  -- text=self:getVipLevel(self.data.Vip);
  -- text_data=armature:getBone("iniviter_descb").textData;
  -- self.iniviter_descb=createTextFieldWithTextData(text_data,text);
  -- self.armature:addChild(self.iniviter_descb);

  -- text='<content><font color="#00FF00" ref="1">同意</font></content>';
  -- text_data=armature:getBone("agree_descb").textData;
  -- self.agree_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- self.agree_descb:addEventListener(DisplayEvents.kTouchTap,self.onVerify,self,1);
  -- self.armature:addChild(self.agree_descb);

  -- text='<content><font color="#00FF00" ref="1">拒绝</font></content>';
  -- text_data=armature:getBone("reject_descb").textData;
  -- self.reject_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  -- self.reject_descb:addEventListener(DisplayEvents.kTouchTap,self.onVerify,self,0);
  -- self.armature:addChild(self.reject_descb);
  self.agree_descb=Button.new(armature:findChildArmature("agree_descb"),false);
  self.agree_descb.bone:initTextFieldWithString("common_small_blue_button","同意");
  self.agree_descb:addEventListener(Events.kStart,self.onAgreeTap,self);

  self.reject_descb=Button.new(armature:findChildArmature("reject_descb"),false);
  self.reject_descb.bone:initTextFieldWithString("common_small_orange_button","拒绝");
  self.reject_descb:addEventListener(Events.kStart,self.onRejectTap,self);
end

function FamilyApplyItem:onVerify(event, data)
  self.agree_descb:setString('<content><font color="#CCCCCC" ref="1">同意</font></content>');
  self.agree_descb:removeEventListener(DisplayEvents.kTouchTap,self.onVerify,self,1);
  self.reject_descb:setString('<content><font color="#CCCCCC" ref="1">拒绝</font></content>');
  self.reject_descb:removeEventListener(DisplayEvents.kTouchTap,self.onVerify,self,0);
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_VERIFY,{UserId=self.data.UserId,BooleanValue=data},self));
end

function FamilyApplyItem:onAgreeTap(event)
  self.container:removeItem(self);
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_VERIFY,{UserId=self.data.UserId,BooleanValue=1},self));
end

function FamilyApplyItem:onRejectTap(event)
  self.container:removeItem(self);
  self.parent_container:dispatchEvent(Event.new(FamilyNotifications.FAMILY_VERIFY,{UserId=self.data.UserId,BooleanValue=0},self));
end

function FamilyApplyItem:getVipLevel(vip)
  if 0==vip then
    return 0;
  end
  local vipTable=analysisTotalTable("Huiyuan_Huiyuandengji");
  table.remove(vipTable,1);
  local vipLevelMax=0;
  for k,v in pairs(vipTable) do
      vipLevelMax=1+vipLevelMax;
    end
  for k,v in pairs(vipTable) do
    if vip>=v.min and vip<v.max then
      return tonumber(string.sub(k,4));
    end
  end
  return vipLevelMax;
end