--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

PossessionMemberItem=class(TouchLayer);

function PossessionMemberItem:ctor()
  self.class=PossessionMemberItem;
end

function PossessionMemberItem:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	PossessionMemberItem.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionMemberItem:initializeUI(skeleton, parent_container, member_ui, num, mapID, id, data)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.member_ui=member_ui;
  self.num=num;
  self.mapID=mapID;
  self.id=id;
  self.data=data;

  --骨骼
  local armature=skeleton:buildArmature("member_item");
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

  text=not self.data.Zhanli and 0 or self.data.Zhanli;
  text_data=armature:getBone("zhanli_descb").textData;
  self.zhanli_descb=createTextFieldWithTextData(text_data,text);
  self.armature:addChild(self.zhanli_descb);

  local hasID=0~=self.data.MapId;
  text=hasID and "<content><font color='#FFAE00' link='1' ref='1'>下战</font></content>" or "<content><font color='#00FF00' link='1' ref='1'>派遣</font></content>";
  text_data=armature:getBone("operation_descb").textData;
  self.operation_descb=createAutosizeMultiColoredLabelWithTextData(text_data,text);
  self.operation_descb:addEventListener(DisplayEvents.kTouchTap,self.onTap,self,hasID);
  self.armature:addChild(self.operation_descb);
end

function PossessionMemberItem:onTap(event, data)
  local datas=self.member_ui.data;
  if data then
    for k,v in pairs(datas) do
      if self.data.UserId==v.UserId then
        --MapId,ID,UserId,UserName,Level,Zhanli
        v.MapId=0;
        v.ID=0;
        break;
      end
    end
  else
    for k,v in pairs(datas) do
      if self.mapID==v.MapId and self.id==v.ID then
        --MapId,ID,UserId,UserName,Level,Zhanli
        v.MapId=0;
        v.ID=0;
        break;
      end
    end
    self.data.MapId=self.mapID;
    self.data.ID=self.id;
  end
  
  self.parent_container.deployUI:refreshItems();
  self.member_ui:onCloseButtonTap(event);
end