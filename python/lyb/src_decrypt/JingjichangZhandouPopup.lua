JingjichangZhandouPopup=class(ListScrollViewLayerItem);

function JingjichangZhandouPopup:ctor()
  self.class=JingjichangZhandouPopup;
end

function JingjichangZhandouPopup:dispose()
  removeSchedule(self,self.onSche);
  self:removeAllEventListeners();
  self:removeChildren();
  JingjichangZhandouPopup.superclass.dispose(self);

  self.armature4dispose:dispose();
end

function JingjichangZhandouPopup:initialize(context, userData, isTenCountry)
  self:initLayer();
  self.context=context;
  self.userData = userData;
  self.userID = self.userData.UserId;
  self.skeleton=self.context.skeleton;
  self.familyProxy=self.context.familyProxy;
  self.userProxy=self.context.userProxy;
  self.bagProxy=self.context.bagProxy;
  self.userCurrencyProxy=self.context.userCurrencyProxy;
  self.heroHouseProxy=self.context.heroHouseProxy;
  self.ids = {};
  self.left_items = {};
  self.right_items = {};
  self.isTenCountry = isTenCountry;

  self:onInitialize();
  if not isTenCountry then
    self.context.tab_panels[1].item_layer:setMoveEnabled(false);
  end
end

function JingjichangZhandouPopup:onInitialize()
  local winSize = Director:sharedDirector():getWinSize()
  local bg = Image.new();
  bg:loadByArtID(StaticArtsConfig.BACKGROUD_HERO_PRO);
  bg:setScale(1);
  bg.sprite:setAnchorPoint(CCPointMake(0.5, 0.5))
  bg:setPositionXY(winSize.width / 2 - GameData.uiOffsetX,winSize.height / 2 - GameData.uiOffsetY)
  self:addChild(bg);
  --骨骼
  local armature=self.skeleton:buildArmature("zhandui_ui");
  armature.animation:gotoAndPlay("f1");
  armature:updateBonesZ();
  armature:update();
  self.armature4dispose=armature;
  self.armature=armature.display;
  self:addChild(self.armature);

  local button = self.armature:getChildByName("common_copy_close_button");
  SingleButton:create(button);
  button:addEventListener(DisplayEvents.kTouchTap, self.onCloseBTNTap, self, i);

  local button=self.armature:getChildByName("btn_1");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeBMText("编辑战队","anniutuzi");
  button_pos.x = 130 + button_pos.x;
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onBianjiButtonTap,self);
  self.armature:addChild(button);

  local button=self.armature:getChildByName("btn_2");
  local button_pos=convertBone2LB4Button(button);
  self.armature:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeBMText("开始战斗","anniutuzi");
  button_pos.x = -130 + button_pos.x;
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onZhandouButtonTap,self);
  self.armature:addChild(button);

  local zhandui_bg_1 = self.skeleton:getBoneTextureDisplay("zhandui_bg");
  zhandui_bg_1:setPositionXY(1270,550);
  zhandui_bg_1:setRotation(180);
  self.armature:addChildAt(zhandui_bg_1,2);

  for i=1,2 do
    local zhanLi = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanLi");
    zhanLi:setScale(0.8);
    self.armature:addChild(zhanLi);

    self["zhanLi_" .. i] = CartoonNum.new();
    self["zhanLi_" .. i]:initLayer();
    self["zhanLi_" .. i]:setScale(0.8);
    self["zhanLi_" .. i]:setPositionX(140);
    self["zhanLi_" .. i]:setData(12345,"common_number",40);

    local zhanLiNode = DisplayNode:create();
    zhanLiNode:addChild(zhanLi);
    zhanLiNode:addChild(self["zhanLi_" .. i]);

    if 1 == i then
      zhanLiNode:setPositionXY(162,238);
    else
      zhanLiNode:setPositionXY(827,182);
    end
    self.armature:addChild(zhanLiNode);
  end

  for i=1,9 do
    local slot_r = self.armature:getChildByName("slot_r_" .. i);
    slot_r:setScaleX(-1);
    slot_r:setPositionX(138+slot_r:getPositionX());

    local slot_r_over = self.armature:getChildByName("slot_r_" .. i .. "_over");
    slot_r_over:setScaleX(-1);
    slot_r_over:setPositionX(138+slot_r_over:getPositionX());
  end
  local xg=self.armature:getChildByName("xg");
  if not self.isTenCountry then
    initializeSmallLoading();
    sendMessage(16,6,{UserId = self.userID});
    self.armature:removeChild(xg);
  else
    local text_data=armature:getBone("playerName").textData;
    local title_bg = CommonSkeleton:getBoneTextureDisplay("commonImages/common_huaWen2");
    self.armature:addChild(title_bg)
    title_bg:setPositionXY(text_data.x-23,text_data.y-25)
    self.rightPlayerName=createTextFieldWithTextData(text_data,"");
    self.armature:addChild(self.rightPlayerName);
    self.xgP=convertBone2LB(xg);
  end
end

function JingjichangZhandouPopup:onCloseBTNTap(event)
  if not self.isTenCountry then
    self.parent:removeChild(self);
    self.context.jingjichangZhandouPopup = nil;
    self.context.tab_panels[1].item_layer:setMoveEnabled(true);
  else
    self.context:removeChildBossView()
  end
end

function JingjichangZhandouPopup:onBianjiButtonTap(event)
  if not self.isTenCountry then
    local bg = analysis("Zhandoupeizhi_Zhanchangpeizhi",100000,"map");
    bg = analysis("Zhandoupeizhi_Zhandouditu",bg,"front1");
    self.context:dispatchEvent(Event.new("to_Attack_Team",{context = self, onEnter = self.enterBattle,funcType = "ArenaAttack",ZhanChangWuXing = nil, ZhanChangBG = bg},self));
  else
    self.context:dispatchEvent(Event.new("to_Attack_Team",{context = self, onEnter = self.enterBattle,funcType = "TenCountry"},self));
  end
end

function JingjichangZhandouPopup:onZhandouButtonTap(event)
  self:enterBattle();
end

function JingjichangZhandouPopup:enterBattle()
  local peizhi =  not self.isTenCountry and 6 or 2--论剑和十国
  local generalIDs_peizhi = self.context.heroHouseProxy:getPeibingPeizhi(peizhi);
  local left_count = 0;
  for k,v in pairs(generalIDs_peizhi.GeneralIdArray) do
    if 0 ~= v.GeneralId and 0 ~= v.Place then
      left_count = 1 + left_count;
    end
  end
  if 0 ~= generalIDs_peizhi.GeneralId and 0 ~= generalIDs_peizhi.Place then
    left_count = 1 + left_count;
  end
  if left_count == 0 then
    sharedTextAnimateReward():animateStartByString("最少有一个英雄才能挑战啦！");
    return;
  end
  -- if self.enterBattled then
  --   return;
  -- end
  -- self.enterBattled = true;
  if self.time_server and 3 > (getTimeServer() - self.time_server) then
    return;
  end
  self.time_server = getTimeServer();
  removeSchedule(self,self.onSche);
  if not self.isTenCountry then
    print("-->",self.userID,self.formationId);
    for k,v in pairs(self.placeIDArray) do
      print(v.ID,v.Place);
    end
    sendMessage(16,2,{UserId=self.userID,FormationId = self.formationId,PlaceIDArray = self.placeIDArray});
  else
    sendMessage(19,6)
  end
end

function JingjichangZhandouPopup:onSche()
  if 0 >= table.getn(self.ids) then removeSchedule(self,self.onSche); return; end
  local data = self.ids[1];
  table.remove(self.ids,1);
  if not self.armature4dispose.display then
    removeSchedule(self,self.onSche);
    return;
  end
  local pos_size = self.armature4dispose.display:getChildByName("slot_l_1"):getContentSize();
  local figure=CompositeActionAllPart.new();
  figure:initLayer();
  figure:transformPartCompose(self.context.bagProxy:getCompositeRoleTable4Player(analysis("Kapai_Kapaiku",data.ConfigId,"material_id")));
  local pos;
  if data.IsLeft then
    pos = self.armature4dispose.display:getChildByName("slot_l_" .. data.Place):getPosition();
  else
    pos = self.armature4dispose.display:getChildByName("slot_r_" .. data.Place):getPosition();
    pos.x = -138 + pos.x;
  end
  figure:changeFaceDirect(not data.IsLeft);
  figure:setPositionXY(pos_size.width/2+pos.x, -pos_size.height/2+pos.y);
  figure:setScale(0.8);
  self.armature4dispose.display:addChild(figure);

  local shadow = Image.new();
  shadow:loadByArtID(19);
  local shadow_size = shadow:getContentSize();
  shadow:setPositionXY(-shadow_size.width/2,-shadow_size.height/2);
  shadow:setScale(0.8);
  shadow.touchEnabled = false;
  figure:addChildAt(shadow,0);

  if data.IsLeft then
    table.insert(self.left_items,figure);
  else
    table.insert(self.right_items,figure);
  end
  if self.isTenCountry then 
    local stateArray = data.IsLeft and self.context.tenCountryProxy.generalStateArray or self.context.tenCountryProxy.targetStateArray
    local bloodItem,deadBool = self.context.tenCountryProxy:getBloodItem(stateArray,data)
    bloodItem:setPositionXY(-70,-45)
    figure:addChild(bloodItem);
  end
end

function JingjichangZhandouPopup:refreshLeftDetailData()
  for k,v in pairs(self.left_items) do
    self.armature4dispose.display:removeChild(v);
  end
  self.left_items = {};
  local peizhi =  not self.isTenCountry and 6 or 2--论剑和十国
  local generalIDs_peizhi = self.context.heroHouseProxy:getPeibingPeizhi(peizhi);
  local zhanli = 0;
  self.left_count = 0;

  for k,v in pairs(generalIDs_peizhi.GeneralIdArray) do
    if 0 ~= v.GeneralId and 0 ~= v.Place then
      local data = self.context.heroHouseProxy:getGeneralData(v.GeneralId);
      table.insert(self.ids,{ConfigId=data.ConfigId,Place=v.Place,IsLeft = true,GeneralId=data.GeneralId});
      zhanli = self.heroHouseProxy:getZongZhanli(data.GeneralId) + zhanli;

      self.left_count = 1 + self.left_count;
    end
  end
  if 0 ~= generalIDs_peizhi.GeneralId and 0 ~= generalIDs_peizhi.Place then
    local data = self.context.familyProxy:getYongbingDataByGeneralID(generalIDs_peizhi.GeneralId);
    table.insert(self.ids,{ConfigId=data.ConfigId,Place=generalIDs_peizhi.Place,IsLeft = true,GeneralId=generalIDs_peizhi.GeneralId});
    zhanli = data.Zhanli + zhanli;

    self.left_count = 1 + self.left_count;
  end
  local sortdata = {1,4,7,2,5,8,3,6,9};
  local function sortfunc(data_a, data_b)
    return sortdata[data_a.Place] < sortdata[data_b.Place];
  end
  table.sort(self.ids,sortfunc);

  if 0 ~= generalIDs_peizhi.FormationId then
    local places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",generalIDs_peizhi.FormationId,"position"),",");
    local place_table = {};
    for k,v in pairs(places) do
      place_table[tonumber(v)] = true;
    end
    for i=1,9 do
      self.armature4dispose.display:getChildByName("slot_l_" .. i .. "_over"):setVisible(place_table[i]);
    end
  end
  self["zhanLi_" .. 1]:setData(math.floor(zhanli),"common_number",40);
  if not self.isTenCountry then
    self.context.zhandui_descb:setString("战队战力：" .. math.floor(zhanli));
  end
  addSchedule(self,self.onSche);
end

function JingjichangZhandouPopup:refreshRightDetailData(userId, formationId, placeIDArray)
  self.formationId = formationId;
  self.placeIDArray = placeIDArray;
  for k,v in pairs(self.right_items) do
    self.armature4dispose.display:removeChild(v);
  end
  self.right_items = {};
  for k,v in pairs(placeIDArray) do
    local id = v.ID or v.ConfigId;
    if analysisHas("Kapai_Kapaiku",id) then

    else
      id = 2;
    end
    table.insert(self.ids,{ConfigId=id,Place=v.Place});
  end
  local sortdata = {1,4,7,2,5,8,3,6,9};
  local function sortfunc(data_a, data_b)
    return sortdata[data_a.Place] < sortdata[data_b.Place];
  end
  table.sort(self.ids,sortfunc);
  if 0 ~= formationId then
    places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",formationId,"position"),",");
    place_table = {};
    for k,v in pairs(places) do
      place_table[tonumber(v)] = true;
    end
    for i=1,9 do
      self.armature4dispose.display:getChildByName("slot_r_" .. i .. "_over"):setVisible(place_table[i]);
    end
  end
end

function JingjichangZhandouPopup:refreshNewRightDetailData(userId, formationId, placeIDArray)
  self:refreshRightDetailData(userId, formationId, placeIDArray);
  removeSchedule(self,self.onSche);
  addSchedule(self,self.onSche);
end

function JingjichangZhandouPopup:refreshHeroDetailData(userId, formationId, placeIDArray, userName, level, guan, targetStateArray)
  self:refreshRightDetailData(userId, formationId, placeIDArray);
  self:refreshLeftDetailData();

  self["zhanLi_" .. 2]:setData(math.floor(self.userData.Zhanli),"common_number",40);
  if self.isTenCountry then
    self.rightPlayerName:setString(userName.." Lv"..level)
    self:refreshCheckpoint(guan)
  end
end

function JingjichangZhandouPopup:refreshCheckpoint(tempString)
  local numberText
  if tempString >= 10 then
    for i=1,2 do
      local str = string.sub(tempString, i, i);
      numberText = CommonSkeleton:getBoneTextureDisplay("n"..str);
      numberText:setPositionXY(self.xgP.x + 30*(i-2),self.xgP.y)
      self.armature:addChild(numberText);
    end
  else
    numberText = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_number"..tempString);
    numberText:setPositionXY(self.xgP.x-30,self.xgP.y)
    self.armature:addChild(numberText);
  end
  numberText = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_number"..1);
  numberText:setPositionXY(self.xgP.x+25,self.xgP.y)
  self.armature:addChild(numberText);
  numberText = CommonSkeleton:getBoneTextureDisplay("commonNumbers/common_number"..0);
  numberText:setPositionXY(self.xgP.x+50,self.xgP.y)
  self.armature:addChild(numberText);
end