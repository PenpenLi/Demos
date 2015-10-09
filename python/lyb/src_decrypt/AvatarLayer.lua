require "main.view.bag.ui.bagPopup.BagItem";
require "main.view.bag.ui.bagPopup.FightingCapacity";
require "core.events.DisplayEvent";
require "core.controls.CommonButton";
require "main.common.CommonExcel";
require "core.utils.CommonUtil";
require "core.controls.ProgressBar";
require "main.common.transform.CompositeActionAllPart";
require "main.config.BattleConfig";
require "core.utils.StringUtils";

AvatarLayer=class(Layer);

function AvatarLayer:ctor()
  self.class=AvatarLayer;
end

function AvatarLayer:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	AvatarLayer.superclass.dispose(self);
  self.armature4dispose:dispose();
end

--intialize UI
function AvatarLayer:initialize(skeleton)
  self:initLayer();
  
  local armature=skeleton:buildArmature("bag_avatar");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;

  local armature_d=armature.display;
  self.armature_d=armature_d;
  
  --armature_d.touchEnabled=false;
  --armature_d.touchChildren=false;
  self:addChild(armature_d);
  --[[self.const_weapon_place_id=1;--武器
  self.const_helmet_place_id=2;--头盔
  self.const_armour_place_id=3;--盔甲
  self.const_boot_place_id=4;--靴子
  self.const_necklace_place_id=5;--项链
  self.const_ring_place_id=6;--戒指]]
  self.const_weapon_place_id=1;--武器
  self.const_helmet_place_id=2;--头盔
  self.const_necklace_place_id=3;--项链
  self.const_armour_place_id=4;--盔甲
  self.const_boot_place_id=5;--靴子
  self.const_ring_place_id=6;--戒指

  self.skeleton=skeleton;
  self.items={};
  self.item_poss={};
  self.textFields={};
  self.fightingCapacity=nil;

  local image = Image.new();
  image:loadByArtID(StaticArtsConfig.AVATAR);
  image:setPositionXY(42,144);
  self.armature_d:addChildAt(image,3);
  
  --bag_avatar_pos
  local bag_avatar_pos=armature_d:getChildByName("bag_avatar_pos");
  self.bag_avatar_pos=bag_avatar_pos:getPosition();
  armature_d:removeChild(bag_avatar_pos);
  
  --button_large
  local button_large=armature_d:getChildByName("common_copy_bluelonground_button");
  local button_large_pos=convertBone2LB4Button(button_large);--button_large:getPosition();
  armature_d:removeChild(button_large);

  local button=armature_d:getChildByName("common_copy_bluelonground_button_1");
  local button_pos_1=convertBone2LB4Button(button);--button:getPositionX(),button:getPositionY();
  armature_d:removeChild(button);

  self.popup_pos=convertBone2LB(self.armature_d:getChildByName("popup_pos"));
  self.popup_pos_1=convertBone2LB(self.armature_d:getChildByName("popup_pos_1"));

  -- local text_data=armature:getBone("bag_attack").textData;
  -- local text="    攻击               防御               生命";
  -- local bag_attack=createTextFieldWithTextData(text_data,text);
  -- armature_d:addChild(bag_attack);

  -- text_data=armature:getBone("bag_mental_wizardry").textData;
  -- text="    暴击               破击               命中";
  -- local bag_mental_wizardry=createTextFieldWithTextData(text_data,text);
  -- armature_d:addChild(bag_mental_wizardry);

  self.bag_peerage=armature_d:getChildByName("bag_font_img_5");
  self.bag_peerage_1=armature_d:getChildByName("bag_font_img_6");

  --bag_job_descb
  --[[local text_data=armature:getBone("bag_job_descb").textData;
  local text="";
  self.bag_job_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(self.bag_job_descb);]]
  
  --bag_avatar_name_descb
  text_data=armature:getBone("bag_avatar_name_descb").textData;
  text="";
  self.bag_avatar_name_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(self.bag_avatar_name_descb);
  
  --bag_avatar_level_descb
  text_data=armature:getBone("bag_avatar_level_descb").textData;
  text="";
  self.bag_avatar_level_descb=createStrokeTextFieldWithTextData(text_data,text,nil,1,ccc3(0,0,0));
  armature_d:addChild(self.bag_avatar_level_descb);
  
  self.fightingCapacity=FightingCapacity.new();
  self.fightingCapacity:initialize(0,armature_d:getChildByName("bag_fight_descb"):getPosition());
  armature_d:addChild(self.fightingCapacity);
  
  --bag_attack_descb
  text_data=armature:getBone("bag_attack_descb").textData;
  text="";
  local bag_attack_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_attack_descb);
  self.textFields[2]=bag_attack_descb;
  
  --bag_defence_descb
  text_data=armature:getBone("bag_defence_descb").textData;
  text="";
  local bag_defence_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_defence_descb);
  self.textFields[3]=bag_defence_descb;
  
  --bag_health_descb
  text_data=armature:getBone("bag_health_descb").textData;
  text="";
  local bag_health_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_health_descb);
  self.textFields[1]=bag_health_descb;
  
  --bag_mental_wizardry_descb
  text_data=armature:getBone("bag_mental_wizardry_descb").textData;
  text="";
  local bag_mental_wizardry_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(bag_mental_wizardry_descb);
  self.textFields[20]=bag_mental_wizardry_descb;
  
  -- --bag_skill_descb
  -- text_data=armature:getBone("bag_skill_descb").textData;
  -- text="";
  -- local bag_skill_descb=createTextFieldWithTextData(text_data,text);
  -- armature_d:addChild(bag_skill_descb);
  -- self.textFields[29]=bag_skill_descb;
  
  -- --bag_physique_descb
  -- text_data=armature:getBone("bag_physique_descb").textData;
  -- text="";
  -- local bag_physique_descb=createTextFieldWithTextData(text_data,text);
  -- armature_d:addChild(bag_physique_descb);
  -- self.textFields[6]=bag_physique_descb;

  --bag_prestige_descb
  text_data=armature:getBone("bag_prestige_descb").textData;
  text="";
  local bag_prestige_descb=createTextFieldWithTextData(text_data,text);
  bag_prestige_descb.touchEnabled=false;
  armature_d:addChild(bag_prestige_descb);
  self.bag_prestige_descb=bag_prestige_descb;

  -- self.bag_peerage=armature_d:getChildByName("bag_peerage");
  -- self.bag_peerage.touchEnabled=false;
  -- self.bag_prestige=armature_d:getChildByName("bag_prestige");
  -- self.bag_prestige.touchEnabled=false;
  
  --bag_experience_normal
  text_data=armature:getBone("exp_descb").textData;
  text="经验: 99/99";
  self.bag_experience_normal=createStrokeTextFieldWithTextData(text_data,text,nil,1,ccc3(0,0,0));
  armature_d:addChild(self.bag_experience_normal);

  --bag_juewei_descb
  text_data=armature:getBone("bag_juewei_descb").textData;
  text=" ";
  self.juewei_descb=createTextFieldWithTextData(text_data,text);
  armature_d:addChild(self.juewei_descb);

  -- self.peerage_button=Button.new(armature:findChildArmature("peerage_button"),false);
  -- self.peerage_button:addEventListener(Events.kStart,self.onPeerageButtonTap,self);
  
  --button_large
  button_large=CommonButton.new();
  button_large:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  button_large:initializeText(armature:findChildArmature("common_copy_bluelonground_button"):getBone("common_copy_bluelonground_button").textData,"详细属性");
  button_large:setPosition(button_large_pos);
  button_large:addEventListener(DisplayEvents.kTouchTap,self.onButtonLargeTap,self);
  self:addChild(button_large);
  self.button_large=button_large;
  self.button_large:setVisible(false);

  --详细属性
  button=CommonButton.new();
  button:initialize("common_bluelonground_button_normal","common_bluelonground_button_down",CommonButtonTouchable.BUTTON);
  button:initializeText(armature:findChildArmature("common_copy_bluelonground_button_1"):getBone("common_copy_bluelonground_button").textData,"详细属性");
  button:setPosition(button_pos_1);
  button:addEventListener(DisplayEvents.kTouchTap,self.onButtonLargeTap,self);
  self:addChild(button);
  self.prop_button=button;

  -- self.mark_button=Button.new(armature:findChildArmature("mark_button"),false);
  -- self.mark_button:addEventListener(Events.kStart,self.onMarkButtonTap,self);
  
  --grid
  local grid=armature_d:getChildByName("common_copy_grid");
  local grid_content_size=grid:getContentSize();
  self.grid_width,self.grid_height=grid_content_size.width,grid_content_size.height;
  self.item_poss[self.const_weapon_place_id]=convertBone2LB(grid);--grid:getPosition();

  grid=armature_d:getChildByName("common_copy_grid_1");
  self.item_poss[self.const_helmet_place_id]=convertBone2LB(grid);--grid:getPosition();
  
  grid=armature_d:getChildByName("common_copy_grid_2");
  self.item_poss[self.const_necklace_place_id]=convertBone2LB(grid);--grid:getPosition();
  
  grid=armature_d:getChildByName("common_copy_grid_3");
  self.item_poss[self.const_armour_place_id]=convertBone2LB(grid);--grid:getPosition();
  
  grid=armature_d:getChildByName("common_copy_grid_4");
  self.item_poss[self.const_boot_place_id]=convertBone2LB(grid);--grid:getPosition();
  
  grid=armature_d:getChildByName("common_copy_grid_5");
  self.item_poss[self.const_ring_place_id]=convertBone2LB(grid);--grid:getPosition();
  
  --touchLayer
  self.touchLayer=CommonLayer.new();
  self.touchLayer:initialize(self.grid_width+self.item_poss[self.const_armour_place_id].x-self.item_poss[self.const_weapon_place_id].x,
    self.grid_height+self.item_poss[self.const_weapon_place_id].y-self.item_poss[self.const_necklace_place_id].y,
    self,self.onTouchLayerBegin,
    self.onTouchLayerTap);
  self.touchLayer:setPosition(self.item_poss[self.const_necklace_place_id]);
  self:addChild(self.touchLayer);

  local button=Button.new(self.armature4dispose:findChildArmature("common_copy_change_name_button"),false);
  button:addEventListener(Events.kStart,self.onChangeNameButton,self);
  local common_copy_change_name_button=armature_d:getChildByName("common_copy_change_name_button");
  armature_d:removeChild(common_copy_change_name_button,false);
  self:addChild(common_copy_change_name_button);
  self.common_copy_change_name_button=common_copy_change_name_button;
  
  --progressBar
  self.pro=ProgressBar.new(armature:findChildArmature("bag_experience_bar"),"bag_experience_normal");
  self.pro:setProgress(0,"left");
  
  --figure
  self.figure=nil;

  --[[require "core.controls.FlexibleListScrollViewLayer";
  require "core.controls.RichLabelTTF";

  self.listScrollViewLayer=FlexibleListScrollViewLayer.new();
  self.listScrollViewLayer:initLayer();
  self.listScrollViewLayer:setViewSize(ccp(200,200));
  self.listScrollViewLayer:setItemSize(ccp(200,50));
  self:addChild(self.listScrollViewLayer);


  local function cb(sn,data)
    print(">>>>>",sn);
  end

  local s='<content><font color="#FF00FF" link="1">123</font><image link="2">resource/image/arts/6.jpg</image><font color="#FF00FF">321</font></content>';
  local ret = RichLabelTTF.new(s, FontConstConfig.OUR_FONT, 20,  CCSizeMake(200, 0), kCCTextAlignmentLeft);
  print(ret:getString());
  ret:setLinkFunctionHandle(cb);
  self:addChild(ret);self.ret=ret;

  local l=TouchLayer.new();
  l:initLayer();
  --l:changeWidthAndHeight(200,50);
  l:addChild(ret);

  self.listScrollViewLayer:addItem(l);

  local s='<content><font color="#FF00FF" link="1">123111111111111111111111111111</font><image link="2">resource/image/arts/6.jpg</image><font color="#FF00FF">321</font></content>';
  local ret = RichLabelTTF.new(s, FontConstConfig.OUR_FONT, 20,  CCSizeMake(200, 0), kCCTextAlignmentLeft);
  ret:setLinkFunctionHandle(cb);
  self:addChild(ret);

  local l=TouchLayer.new();
  l:initLayer();
  --l:changeWidthAndHeight(200,50);
  l:addChild(ret);

  self.listScrollViewLayer:addItem(l);
  --self:addChild(l);]]

  --[[function cb(a) 
    print(">>>>>>>>>>>triggered by richLabelTTF link");
  end

  function cb_1(event)
    print(">>>>>>>>>>>triggered by richLabelTTF");
  end

  local s='<content><font color="#FF00FF" link="1">这是一个链接文本</font><font>123123123</font></content>';
  local ret = RichLabelTTF.new(s, FontConstConfig.OUR_FONT, 20,  CCSizeMake(300, 0), kCCTextAlignmentLeft);
  ret:setLinkFunctionHandle(cb);
  ret:addEventListener(DisplayEvents.kTouchTap,cb_1);
  self:addChild(ret);

  local a=LayerColor.new();
  a:initLayer();
  a:changeWidthAndHeight(300,300);
  a:setColor(ccc3(100,0,0));
  a:addEventListener(DisplayEvents.kTouchTap,cb_2);
  self:addChild(a);
  button_large:setVisible(false);]]
end

--高亮
function AvatarLayer:addGridOver(dragItem)
  local a;
  if dragItem:isArmour() then
    a=self.const_armour_place_id;
  elseif dragItem:isBoot() then
    a=self.const_boot_place_id;
  elseif dragItem:isHelmet() then
    a=self.const_helmet_place_id;
  elseif dragItem:isNecklace() then
    a=self.const_necklace_place_id;
  elseif dragItem:isRing() then
    a=self.const_ring_place_id;
  elseif dragItem:isWeapon() then
    a=self.const_weapon_place_id;
  end
  
  if nil==a then
    return;
  end
  self.grid_over=self.skeleton:getCommonBoneTextureDisplay("common_grid_over");
  self.grid_over:setPosition(self:getPositionByPlace(a));
  print(self:getPositionByPlace(a).x,self:getPositionByPlace(a).y);
  self:addChild(self.grid_over);
end

function AvatarLayer:isEqual(dragItem, place)
  local a;
  if dragItem:isArmour() then
    a=self.const_armour_place_id;
  elseif dragItem:isBoot() then
    a=self.const_boot_place_id;
  elseif dragItem:isHelmet() then
    a=self.const_helmet_place_id;
  elseif dragItem:isNecklace() then
    a=self.const_necklace_place_id;
  elseif dragItem:isRing() then
    a=self.const_ring_place_id;
  elseif dragItem:isWeapon() then
    a=self.const_weapon_place_id;
  end
  
  if nil==a or nil==place or place~=a then
    return false;
  end
  return true;
end

--详细属性
function AvatarLayer:onButtonLargeTap(event)
  self.parent:onPropDetailTap();
end

function AvatarLayer:onPeerageButtonTap(event)
  self.parent:onPeerageTap();
end

--onLocalTap
function AvatarLayer:onLocalTap(tg, x_number, y_number)
  return self.parent.bagLayer.onLocalTap(self.parent.bagLayer,tg,x_number,y_number);
end

--onTouchLayerBegin
function AvatarLayer:onTouchLayerBegin(x, y)
  --[[拖动取消
  self.parent:addEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  self.parent:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  local place=self:getPlaceByPosition(self:onLocalTap(self,x,y));
  print("avatarPlace...",place);
  self.dragItem=self.items[place];
  if self.dragItem then
    self.dragItem=self.dragItem:clone();
    self.dragItem:setPositionXY(self:onLocalTap(self.parent,x,y));
    self.parent:addChild(self.dragItem);
    self.parent:addEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
    self.parent:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
    
    self:addGridOver(self.dragItem);
  end]]
end

--onTouchLayerTap
function AvatarLayer:onTouchLayerTap(x, y)
  local a=self:getPlaceByPosition(self:onLocalTap(self,x,y));
  print("avatarPlace..",a);
  if nil==self.items[a] then
    return;
  end
  self.parent:onItemTap(self.items[a]:clone(),false,self.items[a]);
end

--onSelfEnd
function AvatarLayer:onSelfEnd(event)
  self.parent:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  self.parent:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  local place=self.parent.bagLayer:mouse2Grid(self:onLocalTap(self.parent.bagLayer.touchLayer,event.globalPosition.x,event.globalPosition.y));
  if 0==place then
    
  elseif self.parent.bagLayer.placeOpened<place then
    
  elseif place==self.dragItem:getItemData().Place then
    
  else
    local data={GeneralId=self.parent.userProxy:getUserID(),
              UserEquipmentId=self.dragItem:getItemData().UserItemId,
              Place=avatarPlace,
              BooleanValue=1==self.dragItem:getItemData().IsUsing and 0 or 1};
    self.parent:dispatchEvent(Event.new("avatarEquipOnOff",data,self.parent));
  end
  self.parent:removeChild(self.dragItem);
  self.dragItem=nil;
  
  self:removeGridOver();
end

--onSelfMove
function AvatarLayer:onSelfMove(event)
  self.dragItem:setPositionXY(self:onLocalTap(self.parent,event.globalPosition.x,event.globalPosition.y));
end

--更新角色装备
function AvatarLayer:refreshAvatarFigure(generalListProxy, bagProxy)
  local usingEquipmentArray=generalListProxy:getUsingEquipmentData();
  local bagData=bagProxy:getData();
  if nil==usingEquipmentArray or nil==bagData then
    return;
  end
  
  print("usingEquipment----------------");
  for k,v in pairs(usingEquipmentArray) do
    print("usingEquipment",v.EquipmentPlaceId,v.UserEquipmentId);
  end
  
  for k,v in pairs(usingEquipmentArray) do
    if self.items[v.EquipmentPlaceId] then
      self:removeChild(self.items[v.EquipmentPlaceId]);
      self.items[v.EquipmentPlaceId]=nil;
    end
    if 0~=v.UserEquipmentId then
      self.items[v.EquipmentPlaceId]=BagItem.new();
      self.items[v.EquipmentPlaceId]:initialize(self:getItemData(v.UserEquipmentId,bagData));
      local pos_x,pos_y=ConstConfig.CONST_GRID_ITEM_SKEW_X+self.item_poss[v.EquipmentPlaceId].x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+self.item_poss[v.EquipmentPlaceId].y;
      self.items[v.EquipmentPlaceId]:setPositionXY(pos_x,pos_y);
      self:addChild(self.items[v.EquipmentPlaceId]);
    end
  end
  
  if nil==self.figure then
    self.figure=CompositeActionAllPart.new();
    self.figure:initLayer();
    self.figure:transformPartCompose(bagProxy:getCompositeRoleTable(self.career));
    self.figure:setPosition(self.bag_avatar_pos);
    self.figure:changeFaceDirect(false);
    self.armature_d:addChild(self.figure);
  else
    local reloadTable=bagProxy:getCompositeRoleTableReload(self.career);
    for k,v in pairs(reloadTable) do
      self.figure:reloading(k,v,GameConfig.ROLE_STAND);
    end
  end

  --角色经验
  local level=generalListProxy:getLevel();
  local experience=generalListProxy:getExperience();
  self:refreshLevelExpNew(level,experience);
end

--更新角色属性
function AvatarLayer:refreshAvatarProperty(avatarPropertyProxy)
  avatarProperty=avatarPropertyProxy:getData();
  for k,v in pairs(avatarProperty) do
    if self.textFields[k] then
      self.textFields[k]:setString(v);
    end
  end

  self.fightingCapacity:setNum(avatarPropertyProxy:getZhanli());
end

function AvatarLayer:refreshCurrency(userCurrencyProxy)
  self.bag_prestige_descb:setString(userCurrencyProxy:getPrestige());
end

--更新爵位
function AvatarLayer:refreshNobility(userProxy)
  self.userProxy=userProxy;
  local peerageID=self.userProxy:getNobility();
  -- local a=Image.new();
  -- a:loadByArtID(analysis("Wujiang_Juewei",peerageID,"artid"));
  -- a.touchEnabled=false;
  -- a.touchChildren=false;
  -- a:setPositionXY(120,20);
  -- self:addChild(a);
  self.juewei_descb:setString(analysis("Wujiang_Juewei",peerageID,"title"));
end

--更新等级和经验
function AvatarLayer:refreshLevelExpNew(level, experience)
  self.bag_avatar_level_descb:setString(level);

  local exp_next;
  if analysisHas("Wujiang_Wujiangshengji",1+level) then
    exp_next=analysis("Wujiang_Wujiangshengji",1+level,"exp");
  else
    exp_next=analysis("Wujiang_Wujiangshengji",level,"exp");
  end

  self.bag_experience_normal:setString("经验: " .. experience .. "/" .. exp_next);

  self.pro:setProgress(experience/exp_next,"left");
end

--更新用户
function AvatarLayer:refreshUserInfo(userProxy)
  self.career=userProxy:getCareer();
  self.name=userProxy:getUserName();
  self:refreshNobility(userProxy);
  --self.bag_job_descb:setString(analysis("Wujiang_Wujiangzhiye",self.career,"occupation"));
  self.bag_avatar_name_descb:setString(StringUtils:substr(self.name));
end

--高亮移除
function AvatarLayer:removeGridOver()
  if self.grid_over then
    self:removeChild(self.grid_over);
  end
end

function AvatarLayer:getItemData(userItemID,bagData)
  for k,v in pairs(bagData) do
    if userItemID==v.UserItemId then
      return v;
    end
  end
end

function AvatarLayer:getPlaceByPosition(x_number, y_number)
  for k,v in pairs(self.item_poss) do
    if v.x<x_number and v.y<y_number and self.grid_width+v.x>x_number and self.grid_height+v.y>y_number then
      return k;
    end
  end
end

function AvatarLayer:getPositionByPlace(place)
  return self.item_poss[place];
end

--更新玩家
function AvatarLayer:refreshData4Player(bagProxy, playerName, level, experience, career, prestige, nobility, zhanli, equipmentZhanli, unitPropertyArray, lookUpEquipmentArray, myUserName)
  self.bagProxy=bagProxy;
  self.myUserName = myUserName;
  self:refreshUserInfo4Player(playerName,career);
  self:refreshLevelExpNew4Player(level,experience,nobility);
  self:refreshAvatarProperty4Player(unitPropertyArray,zhanli,equipmentZhanli);
  self:refreshAvatarFigure4Player(lookUpEquipmentArray);
  self:refreshLargeButton4Player();

  --[[local a=1;
  while analysisHas("Wujiang_Juewei",a) do
    if analysis("Wujiang_Juewei",a,"prestige")>prestige then
      break;
    end
    a=1+a;
  end
  local peerageID=-1+a;

  a=Image.new();
  a:loadByArtID(analysis("Wujiang_Juewei",peerageID,"artid"));
  a:setPositionXY(97,20);
  self.peerage_button:getDisplay().touchEnabled=false;
  self.peerage_button:getDisplay().touchChildren=false;
  self:addChild(a);]]

  self.parent:addEventListener(DisplayEvents.kTouchTap,self.onSelfTap4Player,self);
end

--更新玩家等级和经验
function AvatarLayer:refreshLevelExpNew4Player(level, experience, nobility)
  self.bag_avatar_level_descb:setString(level);
  --self.bag_avatar_level_descb:setPositionX(156);

  local exp_next;
  if analysisHas("Wujiang_Wujiangshengji",1+level) then
    exp_next=analysis("Wujiang_Wujiangshengji",1+level,"exp");
  else
    exp_next=analysis("Wujiang_Wujiangshengji",level,"exp");
  end
  self.bag_experience_normal:setString(" ");

  self.pro:setProgress(experience/exp_next,"left");

  self.juewei_descb:setString(analysis("Wujiang_Juewei",nobility,"title"));
end

--更新玩家
function AvatarLayer:refreshUserInfo4Player(playerName, career)
  self.career=career;
  self.name=playerName;
  
  --self.bag_job_descb:setString(analysis("Wujiang_Wujiangzhiye",self.career,"occupation"));
  self.bag_avatar_name_descb:setString(StringUtils:substr(self.name));
end

--更新玩家属性
function AvatarLayer:refreshAvatarProperty4Player(unitPropertyArray, zhanli, equipmentZhanli)
  for k,v in pairs(unitPropertyArray) do
    if self.textFields[v.PropertyKey] then
      self.textFields[v.PropertyKey]:setString(v.PropertyValue);
    end
  end

  self.fightingCapacity:setNum(zhanli);
end

--更新玩家装备
function AvatarLayer:refreshLargeButton4Player()
  self.button_large:removeEventListener(DisplayEvents.kTouchTap,self.onButtonLargeTap,self);
  self.button_large:addEventListener(DisplayEvents.kTouchTap,self.onButtonLargeTap4Player,self);
  self.button_large:refreshText("战力对比");
  if self.name ~= self.myUserName then
   self.button_large:setVisible(true);
  else
    self.button_large:setVisible(false)
  end

  self.prop_button:setVisible(false);
  -- self.peerage_button:getDisplay():setVisible(false);
  -- self.bag_peerage:setVisible(false);
  self.bag_peerage_1:setVisible(false);
  -- self.bag_prestige:setVisible(false);
  self.bag_prestige_descb:setVisible(false);
  -- self.mark_button:getDisplay().touchEnabled=false;
  -- self.mark_button:getDisplay().touchChildren=false;
  self.common_copy_change_name_button:setVisible(false);
  self.bag_avatar_name_descb:setPositionX(20+self.bag_avatar_name_descb:getPositionX());

  self.armature_d:getChildByName("bag_small_background_right"):setVisible(false);
end

function AvatarLayer:refreshAvatarFigure4Player(lookUpEquipmentArray)
  print("lookUpEquipmentArray----------------");
  for k,v in pairs(lookUpEquipmentArray) do
    print("lookUpEquipmentData",v.EquipmentPlaceId,v.ItemId);
  end
  
  local itemIdBody;
  local itemIdWeapon;
  for k,v in pairs(lookUpEquipmentArray) do
    if 0~=v.ItemId then
      self.items[v.EquipmentPlaceId]=BagItem.new();
      self.items[v.EquipmentPlaceId]:initialize(self:getItemData4Player(v));
      local pos_x,pos_y=ConstConfig.CONST_GRID_ITEM_SKEW_X+self.item_poss[v.EquipmentPlaceId].x,ConstConfig.CONST_GRID_ITEM_SKEW_Y+self.item_poss[v.EquipmentPlaceId].y;
      self.items[v.EquipmentPlaceId]:setPositionXY(pos_x,pos_y);
      self.items[v.EquipmentPlaceId].touchEnabled=true;
      self.items[v.EquipmentPlaceId].touchChildren=true;
      self.items[v.EquipmentPlaceId]:addEventListener(DisplayEvents.kTouchTap,self.onItemTap4Player,self,v);
      self:addChild(self.items[v.EquipmentPlaceId]);

      if self.const_weapon_place_id==v.EquipmentPlaceId then
        itemIdWeapon=v.ItemId;
      elseif self.const_armour_place_id==v.EquipmentPlaceId then
        itemIdBody=v.ItemId;
      end
    end

    self:removeChild(self.touchLayer);
  end
  
  self.figure=CompositeActionAllPart.new();
  self.figure:initLayer();
  self.figure:transformPartCompose(self.bagProxy:getCompositeRoleTable4Player(itemIdBody,itemIdWeapon,self.career));
  self.figure:setPosition(self.bag_avatar_pos);
  self.figure:changeFaceDirect(false);
  self.armature_d:addChild(self.figure);
end

function AvatarLayer:getItemData4Player(usingEquipmentData)
  --EquipmentPlaceId,ItemId
  --UserItemId,ItemId,Count,IsBanding,IsUsing,Place
  local a={UserItemId=1,ItemId=usingEquipmentData.ItemId,Count=1,IsBanding=1,IsUsing=1,Place=usingEquipmentData.EquipmentPlaceId};
  return a;
end

function AvatarLayer:onButtonLargeTap4Player(event)
  self.parent:onButtonLargeTap4Player();
end

function AvatarLayer:onItemTap4Player(event, lookUpEquipmentData)
  self.parent.popup_boolean=true;
  if self.item_detail_4_player then
    if self.item_detail_4_player.item:equal(event.target) then
      self.parent:removeChild(self.item_detail_4_player);
      self.item_detail_4_player=nil;
      return;
    end
    self.parent:removeChild(self.item_detail_4_player);
    self.item_detail_4_player=nil;
  end
  self.item_detail_4_player=EquipDetailLayer.new();
  self.item_detail_4_player:initialize(self.skeleton,event.target:clone(),event.target,false,lookUpEquipmentData);
  self.item_detail_4_player:setPosition(self.parent.detailLayer:getPosition());
  self.parent:addChild(self.item_detail_4_player);
end

function AvatarLayer:onSelfTap4Player(event)
  if self.parent.popup_boolean then
    self.parent.popup_boolean=false;
    return;
  end
  if self.item_detail_4_player then
    self.parent:removeChild(self.item_detail_4_player);
    self.item_detail_4_player=nil;
  end
  self.parent.popup_boolean=false;
end

function AvatarLayer:onMarkButtonTap(event)
  self.parent:onMarkButtonTap();
end

function AvatarLayer:onChangeNameButton(event)
  self.parent:dispatchEvent(Event.new(MainSceneNotifications.MAIN_SCENE_TO_CHANGE_NAME,nil,self.parent));
end

function AvatarLayer:setNewName(userProxy)
  self.bag_avatar_name_descb:setString(StringUtils:substr(userProxy:getUserName()));
end