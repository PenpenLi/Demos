--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

FamilyMemberItem=class(TouchLayer);

function FamilyMemberItem:ctor()
  self.class=FamilyMemberItem;
end

function FamilyMemberItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	FamilyMemberItem.superclass.dispose(self);

  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function FamilyMemberItem:initialize(skeleton, familyProxy, parent_container, data)
  self:initLayer();
  self.skeleton=skeleton;
  self.familyProxy=familyProxy;
  self.parent_container=parent_container;
  self.data=data;
  
  --骨骼
  local armature=skeleton:buildArmature("member_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  
  local text=StringUtils:substr(self.data.UserName);
  local color=0;
  if ConstConfig.USER_NAME==self.data.UserName then
    color=65280;
  elseif 1==self.data.BooleanValue then
    color=65280;
  else
    color=13421772;
  end
  local text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,text);
  self.name_descb:setColor(CommonUtils:ccc3FromUInt(color));
  self.armature:addChild(self.name_descb);

  text=self.data.Level;
  text_data=armature:getBone("level_descb").textData;
  self.level_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.level_descb);

  text=analysis("Jiazu_Zhiweidengjibiao",self.data.FamilyPositionId,"name");
  text_data=armature:getBone("position_descb").textData;
  self.position_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.position_descb);
  self:refreshPositionColor();

  text=self.data.Donate;
  text_data=armature:getBone("donate_descb").textData;
  self.donate_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.donate_descb);

  text=self.data.Zhanli;
  text_data=armature:getBone("mark_descb").textData;
  self.mark_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.mark_descb);

  local a=math.floor(self.data.Time/60/60/24);
  local b=math.floor(self.data.Time/60/60);
  local c=math.floor(self.data.Time/60);
  if 0<a then
    if a>3 then a=3; end
    text=a .. "天前";
  elseif 0<b then
    text=b .. "小时前";
  else
    text=c .. "分钟前";
  end
  text_data=armature:getBone("time_descb").textData;
  self.time_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.time_descb);

  self.name_descb:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function FamilyMemberItem:onSelfTap(event)
  if ConstConfig.USER_NAME==self.data.UserName then
    return;
  end
  self.parent_container:onMemberItemTap(event,self.data);
end

function FamilyMemberItem:refreshChangePositionID(familyPositionId)
  self.data.FamilyPositionId=familyPositionId;
  self.position_descb:setString(analysis("Jiazu_Zhiweidengjibiao",self.data.FamilyPositionId,"name"));
  self:refreshPositionColor();
end

function FamilyMemberItem:refreshFamilyKick(userID)
  self.name_descb:removeEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
  self.time_descb:setString("");
  self.time_descb:setString("已删除");
  self.time_descb:setColor(ccc3(150,150,150));
end

function FamilyMemberItem:refreshPositionColor()
  local c=16580578;
  if 1==self.data.FamilyPositionId then
    c=65535;
  elseif 2==self.data.FamilyPositionId then
    c=2883511;
  elseif 3==self.data.FamilyPositionId then
    c=6422399;
  elseif 4==self.data.FamilyPositionId then
    c=11533947;
  else
    c=16580578;
  end
  self.position_descb:setColor(CommonUtils:ccc3FromUInt(c));
end