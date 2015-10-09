--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

RankListScrollItem=class(TouchLayer);

function RankListScrollItem:ctor()
  self.class=RankListScrollItem;
end

function RankListScrollItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	RankListScrollItem.superclass.dispose(self);
  self.removeArmature:dispose();
  BitmapCacher:removeUnused();
end

function RankListScrollItem:initialize(skeleton, rankListProxy, parent_container, rankData, self_size)
  self:initLayer();
  self.skeleton=skeleton;
  self.rankListProxy=rankListProxy;
  self.rankData=rankData;
  self.id=self.rankData.Ranking;
  self.typeID=self.rankData.Type;
  self.parent_container=parent_container;
  self.is_type_2=self.parent_container.const_type_5==self.typeID or self.parent_container.const_type_8==self.typeID or self.parent_container.const_type_9==self.typeID;
  
  --骨骼
  local armature=skeleton:buildArmature(self.is_type_2 and "scroll_item_type_2" or "scroll_item");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.removeArmature = armature;
  self.armature=armature.display;
  self:addChild(self.armature);
  self:changeWidthAndHeight(self_size.width,self_size.height);
  
  local rank_1_img=self.armature:getChildByName("rank_1_img");
  local rank_1_img_pos=convertBone2LB(rank_1_img);
  self.armature:removeChild(rank_1_img);
  if 3>=self.id then
    rank_1_img=self.skeleton:getBoneTextureDisplay("rank_" .. self.id .. "_img");
    rank_1_img:setPosition(rank_1_img_pos);
    self.armature:addChild(rank_1_img);
  end

  --rank_descb
  local text=self.id;
  local text_data=armature:getBone("rank_descb").textData;
  text_data=copyTable(text_data);
  text_data.color=self:getColor();
  self.rank_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.rank_descb);

  --name_descb
  text=self.rankData.ParamStr1;
  text_data=armature:getBone("name_descb").textData;
  self.name_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.name_descb);

  --name_descb_2
  if self.parent_container.const_type_5==self.typeID then
    text=analysis("Chongwu_Chongwu",self.rankData.ParamStr2,"name");
    text_data=armature:getBone("name_descb_2").textData;
    self.name_descb_2=createTextFieldWithTextData(text_data,text);
    self.name_descb_2:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(analysis("Chongwu_Chongwu",self.rankData.ParamStr2,"quality"))));
    self.armature:addChild(self.name_descb_2);
  elseif self.parent_container.const_type_8==self.typeID then
    text=analysis("Yinghun_Yinghunku",self.rankData.ParamStr2,"name");
    text_data=armature:getBone("name_descb_2").textData;
    self.name_descb_2=createTextFieldWithTextData(text_data,text);
    self.name_descb_2:setColor(CommonUtils:ccc3FromUInt(getColorByQuality(analysis("Yinghun_Yinghunku",self.rankData.ParamStr2,"quality"))));
    self.armature:addChild(self.name_descb_2);
  elseif self.parent_container.const_type_9==self.typeID then
    text=self.rankData.ParamStr2;
    text=text .. "/" .. analysis("Jiazu_Jiazushengjibiao",self.rankData.ParamStr3,"renshu");
    text_data=armature:getBone("name_descb_2").textData;
    self.name_descb_2=createTextFieldWithTextData(text_data,text);
    self.armature:addChild(self.name_descb_2);
  end

  --mark_descb
  text=self.is_type_2 and self.rankData.ParamStr3 or self.rankData.ParamStr2;
  text_data=armature:getBone("mark_descb").textData;
  self.mark_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.mark_descb);

  self:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap,self);
end

function RankListScrollItem:onCBFunc()
  self.name_descb:setColor(CommonUtils:ccc3FromUInt(16777215));
end

function RankListScrollItem:onSelfTap(event)
  if self.parent_container.const_type_9==self.typeID or (self.parent_container.const_type_9~=self.typeID and (ConstConfig.USER_NAME==self.rankData.ParamStr1 or ConstConfig.CONST_ROBOT_ID<self.rankData.ID)) then
    return;
  end
  self.name_descb:setColor(CommonUtils:ccc3FromUInt(65280));

  local buddyItemPopup=BuddyItemPopup.new();
  buddyItemPopup:initialize(self.parent_container.chatListProxy:getSkeleton(),self.rankData,self,self.onViewTap,
                                                                 self.onChallenge,
                                                                 self.onPrivateTap,
                                                                 self.onAddTap,
                                                                 self.onInviteTap,
                                                                 event.globalPosition,
                                                                 self.parent_container.buddyListProxy:getBuddyData(self.rankData.ParamStr1),
                                                                 0~=self.parent_container.userProxy:getFamilyID(),
                                                                 self.onCBFunc);
  self.parent_container:addChild(buddyItemPopup);
end

function RankListScrollItem:onViewTap()
  self.parent_container:dispatchEvent(Event.new("OPEN_MENU_COMMAND",{Name="查看",UserName=self.rankData.ParamStr1},self.parent_container));
end

function RankListScrollItem:onChallenge()
  self.parent_container:dispatchEvent(Event.new("OPEN_MENU_COMMAND",{Name="切磋",UserName=self.rankData.ParamStr1,UserId=self.rankData.ID},self.parent_container));
end

function RankListScrollItem:onPrivateTap()
  self.parent_container:dispatchEvent(Event.new("OPEN_MENU_COMMAND",{Name="私聊",UserName=self.rankData.ParamStr1},self.parent_container));
end

function RankListScrollItem:onAddTap()
  self.parent_container:dispatchEvent(Event.new("OPEN_MENU_COMMAND",{Name="加好友",UserName=self.rankData.ParamStr1},self.parent_container));
end

function RankListScrollItem:onInviteTap()
  self.parent_container:dispatchEvent(Event.new("OPEN_MENU_COMMAND",{Name="邀家族",UserName=self.rankData.ParamStr1},self.parent_container));
end

function RankListScrollItem:getColor()
  if ConstConfig.USER_NAME==self.rankData.ParamStr1 then
    return 65280;
  elseif 1==self.rankData.Ranking then
    return 16766977;
  elseif 2==self.rankData.Ranking then
    return 16747009;
  elseif 3==self.rankData.Ranking then
    return 16731905;
  end
  return 16777215;
end

function RankListScrollItem:getID()
  return self.id;
end