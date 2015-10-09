--[[
  Copyright @2009-2013 www.happyelements.com, all rights reserved.
  Create date: 2013-5-2

  yanchuan.xie@happyelements.com
]]

PossessionPosUI=class(TouchLayer);

function PossessionPosUI:ctor()
  self.class=PossessionPosUI;
end

function PossessionPosUI:dispose()
  self.parent_container.posUI=nil;
  self:removeAllEventListeners();
  self:removeChildren();
  PossessionPosUI.superclass.dispose(self);
  self.armature4dispose:dispose();
  BitmapCacher:removeUnused();
end

--
function PossessionPosUI:initializeUI(skeleton, parent_container, mapID)
  self:initLayer();
  self.skeleton=skeleton;
  self.parent_container=parent_container;
  self.possessionBattleProxy=self.parent_container.possessionBattleProxy;
  self.userProxy=self.parent_container.userProxy;
  self.mapID=mapID;
  self.texts={};
  self.buttons={};
  self.ing_imgs={};
  self.color_normal=15509510;
  self.color_me=65535;
  self.color_other=16711680;

  --骨骼
  local armature=skeleton:buildArmature("pos_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  AddUIBackGround(self,StaticArtsConfig.POSSESSION_BATTLE);

  local button=Button.new(armature:findChildArmature("common_copy_close_button"),false);
  button:addEventListener(Events.kStart,self.onCloseButtonTap,self);

  self.button_poss={convertBone2LB4Button(self.armature:getChildByName("common_copy_greenroundbutton"))};
  self.img_pos=self.armature:getChildByName("pos_img_1"):getPosition();
  self.text_datas={armature:getBone("pos_img_1").textData};
  self.button_text_data=armature:findChildArmature("common_copy_greenroundbutton"):getBone("common_copy_greenroundbutton").textData;
  self.armature:removeChild(self.armature:getChildByName("common_copy_greenroundbutton"));

  self.ing_poss={self.armature:getChildByName("ing_pos"):getPosition()};

  local a=1;
  while 8>a do
    a=1+a;
    local img_pos=self.armature:getChildByName("pos_img_" .. a):getPosition();
    local skew_x=self.img_pos.x-img_pos.x;
    local skew_y=self.img_pos.y-img_pos.y;
    table.insert(self.button_poss,makePoint(self.button_poss[1].x-skew_x,self.button_poss[1].y-skew_y));
    local data=copyTable(self.text_datas[1]);
    data.x=self.text_datas[1].x-skew_x;
    data.y=self.text_datas[1].y-skew_y;
    table.insert(self.text_datas,data);
    table.insert(self.ing_poss,makePoint(self.ing_poss[1].x-skew_x,self.ing_poss[1].y-skew_y));
  end

  a=0;
  while 8>a do
    a=1+a;
    text="无人占领";
    local text=createTextFieldWithTextData(self.text_datas[a],text);
    self.armature:addChild(text);
    table.insert(self.texts,text);
  end

  a=0;
  while 8>a do
    a=1+a;
    self:refreshPosItem(a);
  end
  self.parent_container:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_POS_DATA,{MapId=self.mapID},self));
end

--移除
function PossessionPosUI:onCloseButtonTap(event)
  self.parent_container:removeChild(self);
end

function PossessionPosUI:onOccupyButtonTap(event, data)
  local item_data=self:getItemData(data);
  if self:getHasPos() then
    sharedTextAnimateReward():animateStartByString("您已经报过名了哦~");
    return;
  end
  local function onConfirm()
    self.parent_container:dispatchEvent(Event.new(PossessionBattleNotifications.POSSESSION_BATTLE_SET_POS,{IsVacancy=not item_data or 0==item_data.FamilyId,MapId=self.mapID,Place=data},self));
  end
  local cost=analysis("Jiazu_Lingdizhanbaoming",self.mapID,"cost");
  local a=CommonPopup.new();
  a:initialize("确认花费" .. cost .. "家族资金吗?",nil,onConfirm);
  self:addChild(a);
end

function PossessionPosUI:refreshPosData(data)
  if self.mapID~=data.MapId then
    return;
  end
  if self.data then
    for k,v in pairs(data.ApplyFamilyWarInfoArray) do
      self:refreshPosItemData(v);
    end
  else
    self.data=data.ApplyFamilyWarInfoArray;
  end
  for k,v in pairs(data.ApplyFamilyWarInfoArray) do
    self:refreshPosItem(v.Place);
  end
  self:refreshIngImg();
end

function PossessionPosUI:refreshIngImg()
  for k,v in pairs(self.data) do
    if 1==v.State then
      if not self.ing_imgs[v.Place] then
        self.ing_imgs[v.Place]=cartoonPlayer(EffectConstConfig.TOWER_AVATAR,self.ing_poss[v.Place].x,self.ing_poss[v.Place].y,0,nil,0.8);
      end
      self.armature:addChild(self.ing_imgs[v.Place]);
    else
      if self.ing_imgs[v.Place] then
        self.armature:removeChild(self.ing_imgs[v.Place]);
        self.ing_imgs[v.Place]=nil;
      end
    end
  end
end

function PossessionPosUI:refreshPosItem(id)
  local item_data=self:getItemData(id);
  if not item_data then
    item_data={Place=id,FamilyId=0,FamilyName="无人占领",State=0};
  end
  self.texts[id]:setString(item_data.FamilyName);
  self.texts[id]:setColor(CommonUtils:ccc3FromUInt(0==item_data.FamilyId and self.color_normal or (self.userProxy:getFamilyID()==item_data.FamilyId and self.color_me or self.color_other)));
  if self.buttons[id] then
    self.armature:removeChild(self.buttons[id]);
  end
  local isOurFamily=0~=self.userProxy:getFamilyID() and item_data.FamilyId==self.userProxy:getFamilyID();
  local name=0==item_data.FamilyId and "common_blueround_button" or "common_greenroundbutton";
  local text=isOurFamily and "已占领" or (0==item_data.FamilyId and "占领" or "争夺");
  local button=CommonButton.new();
  button:initialize(name .. "_normal",name .. "_down",CommonButtonTouchable.BUTTON);
  button:initializeText(self.button_text_data,text);
  button:setGray(isOurFamily);
  button:setPosition(self.button_poss[id]);
  button:addEventListener(DisplayEvents.kTouchTap,self.onOccupyButtonTap,self,id);
  self.armature:addChild(button);
  self.buttons[id]=button;
end

function PossessionPosUI:refreshPosItemData(data)
  for k,v in pairs(self.data) do
    if data.Place==v.Place then
      for k_,v_ in pairs(data) do
        v[k_]=v_;
      end
      return;
    end
  end
  table.insert(self.data,data);
end

function PossessionPosUI:getItemData(id)
  if not self.data then
    return;
  end
  for k,v in pairs(self.data) do
    if id==v.Place then
      return v;
    end
  end
end

function PossessionPosUI:getHasPos()
  if not self.data then
    return false;
  end
  for k,v in pairs(self.data) do
    if self.userProxy:getFamilyID()==v.FamilyId then
      return true;
    end
  end
  return false;
end