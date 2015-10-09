require "core.display.Layer";
require "core.events.DisplayEvent";
require "core.controls.Image";
require "core.utils.CommonUtil";
require "core.utils.LayerColorBackGround";
require "core.display.LayerPopable";
require "main.view.hero.heroTeam.PeibingPopupItem";
require "main.view.hero.heroTeam.PeibingPopupZhenfaItem";
require "main.view.hero.heroTeam.PeibingKapaiPopup";
require "main.config.BattleConfig";

local TEAM_NOT_CHANGE = "teamNotChange";
local TEAM_YONG_BING_BEI_ZHAO_HUI = "teamYongbingBeizhaohui";
local TEAM_WU_BANG_PAI = "teamWuBangPai";
local TEAM_SUCCESS = "teamSuccess";
local TEAM_NONE_HERO = "teamNoneHero";

local TEAM_TYPE_JuQing = 1;
local TEAM_TYPE_TenCountry = 2;
local TEAM_TYPE_Treasury = 4;
local TEAM_TYPE_ArenaDefense = 5;
local TEAM_TYPE_ArenaAttack = 6;
local TEAM_TYPE_Shadow = 7;
local TEAM_TYPE_XunBao = 12;
local TEAM_TYPE_Meeting = 9;

PeibingPopup=class(LayerPopableDirect);

function PeibingPopup:ctor()
  self.class=PeibingPopup;
  self.dataTb = {};
  self.carrerTb = {};
  self.gridTb = {};
end

function PeibingPopup:setNotificationData(data)
  self.notificationData = data;
end

function PeibingPopup:dispose()
  self.zhanLiNode:stopAllActions();
  self:removeChildren()
	PeibingPopup.superclass.dispose(self);

  self.armature:dispose();
end

function PeibingPopup:onDataInit()
  self.skeleton = getSkeletonByName("hero_team_ui");
  self.tab_btns = {};
  self.tab_num = nil;
  self.scrollViews = {};

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setPreUIData(875,nil,true,2);
  layerPopableData:setArmatureInitParam(self.skeleton,"peibing_ui");
  self:setLayerPopableData(layerPopableData);

  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.arenaProxy=self:retrieveProxy(ArenaProxy.name);
  self.tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
  self.shadowProxy=self:retrieveProxy(ShadowProxy.name);
  self.storyLineProxy=self:retrieveProxy(StoryLineProxy.name);
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.zhenFaProxy = self:retrieveProxy(ZhenFaProxy.name);

  if TEAM_TYPE_TenCountry == self:getTeamType() then
    -- self.datas = self.heroHouseProxy:getTenCountryLeftGeneral();
    self.bloodData = self.tenCountryProxy.generalStateArray
  end
    self.datas = self.heroHouseProxy:getGeneralArrayWithPlayer();
  -- end
  if TEAM_TYPE_TenCountry == self:getTeamType() then
    self.datas_yongbing = self.familyProxy:getYongbingData4BianduiOnShiguo();
  else
    self.datas_yongbing = self.familyProxy:getYongbingData4Biandui();
  end
  self.figures = {};
  self.figures_shadow = {};

  self.placeOpen4Juqing = 5;
  self.generalIDs = {};
end

function PeibingPopup:onPrePop()
  local size=Director:sharedDirector():getWinSize();
  self:changeWidthAndHeight(size.width,size.height);
  self:setContentSize(makeSize(1280,720));  

  self.zhenfa_descb=createTextFieldWithTextData(self.armature:getBone("zhenfa_descb").textData,"");
  self.armature.display:addChild(self.zhenfa_descb);

  self.zhenfa_descb_1=createTextFieldWithTextData(self.armature:getBone("zhenfa_descb_1").textData,"");
  self.armature.display:addChild(self.zhenfa_descb_1);

  local titleText = BitmapTextField.new("英  雄","anniutuzi");
  titleText:setPositionXY(185,595)
  self.armature.display:addChild(titleText);

  local button=self.armature.display:getChildByName("btn_left");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_blue_button_normal",nil,CommonButtonTouchable.BUTTON);
  button:initializeBMText("返 回","anniutuzi");
  button:setPosition(button_pos);
  -- button:addEventListener(DisplayEvents.kTouchTap,self.onJinengButtonTap,self);
  button:addEventListener(DisplayEvents.kTouchTap,self.onBackButtonTap,self);
  self.armature.display:addChild(button);
  button:setVisible(false);

  -- local button=self.armature.display:getChildByName("btn_right");
  -- local button_pos=convertBone2LB4Button(button);
  -- self.armature.display:removeChild(button);

  -- button=CommonButton.new();
  -- button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  -- button:initializeBMText("战斗","anniutuzi");
  -- button:setPosition(button_pos);
  -- button:addEventListener(DisplayEvents.kTouchTap,self.onEnterBTNTap,self);
  -- self.armature.display:addChild(button);
  -- if TEAM_TYPE_ArenaDefense == self:getTeamType() then
  --     button:setVisible(false)
  -- end
  local button =self.armature.display:getChildByName("btn_right");
  SingleButton:create(button);
  button:addEventListener(DisplayEvents.kTouchTap, self.onEnterBTNTap, self);

  local zhanLi = CommonSkeleton:getBoneTextureDisplay("commonImages/common_zhanLi");
  zhanLi:setScale(0.8);
  zhanLi:setPositionXY(402,82);
  self.armature.display:addChild(zhanLi);

  self.zhanLi = CartoonNum.new();
  self.zhanLi:initLayer();
  self.zhanLi:setScale(0.8);
  self.zhanLi:setData(12345,"common_number",40);

  self.zhanLiNode = DisplayNode:create();
  self.zhanLiNode:addChild(self.zhanLi);
  local size = self.zhanLi:getGroupBounds().size;
  self.zhanLi:setPositionXY(-size.width/2,-size.height/2);
  self.zhanLiNode:setPositionXY(size.width/2+550,size.height/2+82);
  self.armature.display:addChild(self.zhanLiNode);

  local tab_btn_1=self.armature.display:getChildByName("tab_1");
  local tab_btn_2=self.armature.display:getChildByName("tab_2");
  local tab_btn_1_pos=convertBone2LB4Button(tab_btn_1);
  local tab_btn_1_text_data=self.armature:findChildArmature("tab_1"):getBone("common_tab_button").textData;
  local tab_btn_1_skew=tab_btn_2:getPositionY()-tab_btn_1:getPositionY();
  self.armature.display:removeChild(tab_btn_1);
  self.armature.display:removeChild(tab_btn_2);

  local a=1;
  local s={"雄\n英","兵\n佣"};
  while 3>a do
    local tab_btn=CommonButton.new();
    tab_btn:initialize("commonButtons/common_tab_button_normal","commonButtons/common_tab_button_down",CommonButtonTouchable.CUSTOM);
    --tab_btn:initializeText(tab_btn_1_text_data,s[a]);
    tab_btn:initializeBMText(s[a],"anniutuzi",_,_,makePoint(23,50));
    tab_btn:setPositionXY(tab_btn_1_pos.x,(-1+a)*tab_btn_1_skew+tab_btn_1_pos.y);
    tab_btn:addEventListener(DisplayEvents.kTouchTap,self.onTabBTNTap,self,a);
    self.armature.display:addChildAt(tab_btn,-a+self.armature.display:getNumOfChildren());
    -- tab_btn:setVisible(false);
    tab_btn:setVisible(1 == analysis("Zhandoupeizhi_Zhanchangleixing",self:getBattleType(),"mercenary"));
    table.insert(self.tab_btns,tab_btn);
    a=1+a;
  end
  self.tab_btns[2]:setVisible(self.tab_btns[2]:isVisible() and self.userProxy:getHasFamily());

  for i=1,9 do
    self.armature.display:getChildByName("slot_l_" .. i .. "_over").touchEnabled = false;
    -- self.armature.display:getChildByName("slot_l_" .. i):addEventListener(DisplayEvents.kTouchBegin,self.onCompositeBegin,self,i);
    -- self.armature.display:getChildByName("slot_l_" .. i):addEventListener(DisplayEvents.kTouchTap,self.onCompositeTap,self,i);
  end
  for i=1,9 do
    self["name_descb" .. i]=createTextFieldWithTextData(self.armature:getBone("slot_l_" .. i .. "_over").textData,"",true);
    self.armature.display:addChild(self["name_descb" .. i]);
    self["name_descb" .. i]:setPositionXY(-10+self["name_descb" .. i]:getPositionX(),-25+self["name_descb" .. i]:getPositionY());
  end
  self:addEventListener(DisplayEvents.kTouchBegin,self.kTouchBegin,self);
  self.closeButton =self.armature.display:getChildByName("close_btn");
  SingleButton:create(self.closeButton);
  self.closeButton:addEventListener(DisplayEvents.kTouchTap, self.onCloseButtonTap, self);

  self.askBtn =self.armature.display:getChildByName("ask");
  SingleButton:create(self.askBtn);
  self.askBtn:addEventListener(DisplayEvents.kTouchTap, self.onShowTip, self);

  self.descb=createTextFieldWithTextData(self.armature:getBone("descb").textData,"拖动英雄可以更换位置");
  self.armature.display:addChild(self.descb);
end

function PeibingPopup:onJinengButtonTap(event)
  local popup = PeibingKapaiPopup.new();
  popup:initialize(self);
  self:addChild(popup);
end

function PeibingPopup:kTouchBegin(event)
  log("kTouchBegin------------");
  log(event.globalPosition.x);
  log(event.globalPosition.y);
  log(GameData.uiOffsetX);
  log(GameData.uiOffsetY);
  log(GameData.gameMetaScaleRate);
  log(GameData.gameUIScaleRate);
end

function PeibingPopup:onCompositeBegin(event, data)
  log("offset" .. " " .. event.globalPosition.x .. " " .. event.globalPosition.y .. " " .. GameData.uiOffsetX .. " " .. GameData.uiOffsetY);
  event.globalPosition.x = event.globalPosition.x + GameData.uiOffsetX;
  event.globalPosition.y = event.globalPosition.y + GameData.uiOffsetY;
  self.beginX = event.globalPosition.x;
  self.begin_num = data;
  local generalID = self:getGeneralIDByPlaceOnGeneralIDs(data);
  if generalID then
    for k,v in pairs(self.figures) do
      if generalID == v.generalData.GeneralId then

        self.figure_on_begin = v;
        self.figure_on_begin_pos = v:getPosition();
        self.figure_on_begin_idx = self.armature.display:getChildIndex(v);

        v.parent:removeChild(v,false);
        self.armature.display:addChild(v);
        break;
      end
    end
    self:addEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
    self:addEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
  end
end

function PeibingPopup:onSelfMove(event)
  event.globalPosition.x = (event.globalPosition.x/GameData.gameUIScaleRate);-- + GameData.uiOffsetX);
  event.globalPosition.y = (event.globalPosition.y/GameData.gameUIScaleRate);-- + GameData.uiOffsetY);
  self.figure_on_begin:setPosition(event.globalPosition);
end

function PeibingPopup:onSelfEnd(event)
  print("onSelfEnd");
  event.globalPosition.x = event.globalPosition.x + GameData.uiOffsetX;
  event.globalPosition.y = event.globalPosition.y + GameData.uiOffsetY;
  self.endX = event.globalPosition.x;
  local generalID = self:getGeneralIDByPlaceOnGeneralIDs(self.begin_num);
  if math.abs(self.beginX - self.endX) < 5 then
      self:onCompositeTap(event,self.begin_num);
      self:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
      self:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
      return;
  end
  
  if not self.figure_on_begin then
    self:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
    self:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);
    return;
  end
  local size = self.armature.display:getChildByName("slot_l_1"):getContentSize();
  local id;
  for i=1,9 do
    if self.armature.display:getChildByName("slot_l_" .. i):hitTestPoint(event.globalPosition) then
      id=i;
      break;
    end
  end
  if id then
    local places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"position"),",");
    local valid = false;
    for k,v in pairs(places) do
      if id == tonumber(v) then
        valid = true;
        break;
      end
    end
    if valid then
      local generalID = self:getGeneralIDByPlaceOnGeneralIDs(id);
      if generalID then
        if generalID == self.figure_on_begin.generalData.GeneralId then
          self.figure_on_begin:setPosition(self.figure_on_begin_pos);
          -- self.armature.display:addChildAt(self.figure_on_begin,self.figure_on_begin_idx);
        else
          local place_1 = id;
          local place_2 = self:getPlaceByGeneralIDOnGeneralIDs(self.figure_on_begin.generalData.GeneralId);
          for k,v in pairs(self.generalIDs) do
            if self.figure_on_begin.generalData.GeneralId == v.GeneralId then
              v.Place = place_1;
            elseif generalID == v.GeneralId then
              v.Place = place_2;
            end
          end
          self:setData(true);
        end
      else
        for k,v in pairs(self.generalIDs) do
          if self.figure_on_begin.generalData.GeneralId == v.GeneralId then
            v.Place = id;
            self:setData(true);
            break;
          end
        end
      end
    else
      self.figure_on_begin:setPosition(self.figure_on_begin_pos);
      -- self.armature.display:addChildAt(self.figure_on_begin,self.figure_on_begin_idx);
    end
  else
    self.figure_on_begin:setPosition(self.figure_on_begin_pos);
    -- self.armature.display:addChildAt(self.figure_on_begin,self.figure_on_begin_idx);
  end
  self:removeEventListener(DisplayEvents.kTouchMove,self.onSelfMove,self);
  self:removeEventListener(DisplayEvents.kTouchEnd,self.onSelfEnd,self);

  for k,v in pairs(self.figures) do
    v.parent:removeChild(v,false);
  end
  for k,v in pairs(self.figures) do
    self.armature.display:addChild(v);
  end
end

function PeibingPopup:onCompositeTap(event, id)
  print(event,id);
  local generalID = self:getGeneralIDByPlaceOnGeneralIDs(id);
  if generalID then
    self:onCardTap({GeneralId=generalID,Place=id});
  end
end

function PeibingPopup:onShowTip()
  -- MusicUtils:playEffect(7,false);
  local text=analysis("Tishi_Guizemiaoshu",19,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
end

function PeibingPopup:onUIInit()
  if not self.notificationData.ZhanChangBG then
    self.notificationData.ZhanChangBG=20;
  end
  self.notificationData.ZhanChangBG_POS=makePoint(0,0);--Battle_Pos_L[9];
  if self.notificationData.ZhanChangBG then
    local mask = CommonSkeleton:getBoneTexture9DisplayBySize("commonBackgroundScalables/common_background_6",nil,makeSize(570,430));
    local clipper = ClippingNodeMask.new(mask);
    clipper:setAlphaThreshold(0.0);
    clipper:setPositionXY(410,150);
    self.armature.display:addChildAt(clipper,5);

    local bg = Image.new();
    bg:loadByArtID(self.notificationData.ZhanChangBG);
    bg:setPosition(self.notificationData.ZhanChangBG_POS);
    clipper:addChild(bg);
  end

  self.right_item_layer=ListScrollViewLayer.new();
  self.right_item_layer:initLayer();
  self.right_item_layer:setPosition(makePoint(1005,155));
  self.right_item_layer:setViewSize(makeSize(132,463));
  self.right_item_layer:setItemSize(makeSize(137,140));
  self.armature.display:addChild(self.right_item_layer);
  self.right_item_layer.item_arr = {};

  local formations = self.zhenFaProxy:getData();
  local function sortfunc(data_a, data_b)
    return data_a.ID < data_b.ID;
  end

  for k,v in pairs(formations) do
    local item=PeibingPopupZhenfaItem.new();
    item:initialize(self,self.onFormationIDChange,v.ID);
    self.right_item_layer:addItem(item);
    table.insert(self.right_item_layer.item_arr,item);
  end
end

function PeibingPopup:refreshAllGenerals()

end

function PeibingPopup:onRequestedData()
  local type = self:getTeamType();
  local generalIDs_peizhi = self.heroHouseProxy:getPeibingPeizhi(type);
  if generalIDs_peizhi then
    self:refreshPeibingPeizhi();
  else
    initializeSmallLoading();
    sendMessage(6,13,{Type=type});
  end
end

function PeibingPopup:getIsValied(generalID)
  for k,v in pairs(self.datas) do
    if generalID == v.GeneralId then
      return true;
    end
  end
  for k,v in pairs(self.datas_yongbing) do
    if generalID == v.GeneralId then
      return true;
    end
  end
  return false;
end

function PeibingPopup:refreshPeibingPeizhi()
  local type = self:getTeamType();
  local generalIDs_peizhi = self.heroHouseProxy:getPeibingPeizhi(type);
  self.generalIDs = {};
  self.generalIDs_ori = {};
  self.generalIDs_formationId = generalIDs_peizhi.FormationId;
  self.generalIDs_formationId_ori = self.generalIDs_formationId;
  self.generalIDs_idArray = {};
  self.generalIDs_idArray_ori = {};
  print("-------------=================>",type,self.generalIDs_formationId);
  for k,v in pairs(generalIDs_peizhi.GeneralIdArray) do
    if 0 ~= v.GeneralId and 0 ~= v.Place and self:getIsValied(v.GeneralId) then
      table.insert(self.generalIDs,{GeneralId=v.GeneralId,Place=v.Place});
      table.insert(self.generalIDs_ori,{GeneralId=v.GeneralId,Place=v.Place});
      print("-------------=================>GeneralIdArray",v.GeneralId,v.Place);
    end
  end
  -- local guyong_id = nil;
  -- if self.notificationData.funcType == "TenCountry" then
  --   if 1 == self.familyProxy.shiguo_boolean then
  --     guyong_id = self.familyProxy.shiguo_general_id;
  --   end
  -- else
  --   --guyong_id = self.heroHouseProxy:getGuyongGeneralIDByType(self:getTeamType());
  -- end
  -- print("guyong_id",guyong_id);
  print("-------------=================>yongbing",generalIDs_peizhi.GeneralId,generalIDs_peizhi.Place);
  if 0 ~= generalIDs_peizhi.GeneralId and 0 ~= generalIDs_peizhi.Place and self:getIsValied(generalIDs_peizhi.GeneralId) then
    table.insert(self.generalIDs,{GeneralId=generalIDs_peizhi.GeneralId,Place=generalIDs_peizhi.Place});
    table.insert(self.generalIDs_ori,{GeneralId=generalIDs_peizhi.GeneralId,Place=generalIDs_peizhi.Place});
  end

  -- for k,v in pairs(generalIDs_peizhi.IDArray) do
  --   table.insert(self.generalIDs_idArray,v.ID);
  --   table.insert(self.generalIDs_idArray_ori,v.ID);
  -- end

  self:onTabBTNTap(nil,1);
  self:onFormationIDChange(self.generalIDs_formationId);
end

function PeibingPopup:onBackButtonTap(event)
  local data = self:sendDataToServer(TEAM_TYPE_TenCountry == self:getTeamType());
  if TEAM_NONE_HERO == data then
    sharedTextAnimateReward():animateStartByString("最少有一个英雄才能挑战啦！");
    return;
  elseif TEAM_SUCCESS == data then

  elseif TEAM_NOT_CHANGE == data then
  
  elseif TEAM_WU_BANG_PAI == data then
    sharedTextAnimateReward():animateStartByString("帮派已退出,先把佣兵下战哦 ~");
    return;
  elseif TEAM_YONG_BING_BEI_ZHAO_HUI == data then
    sharedTextAnimateReward():animateStartByString("佣兵已被召回,先把佣兵下战哦 ~");
    return;
  end
  self:closeUI();
end

function PeibingPopup:onCloseButtonTap(event)
  if TEAM_TYPE_TenCountry == self:getTeamType() then
    self:closeUI();
  else
    self:onBackButtonTap();
  end
end

function PeibingPopup:onUIClose()
  if self.notificationData and self.notificationData.context and self.notificationData.onClose then
    print("self.notificationData.onClose");
    self.notificationData.onClose(self.notificationData.context);
    print("self.notificationData.onClose");
    self.notificationData.context = nil;
    self.notificationData.onClose = nil;
  end
  self:dispatchEvent(Event.new("closeNotice",nil,self));
  -- sendMessage(6,20);
end

function PeibingPopup:onTabBTNTap(event, num)
  if event then
    MusicUtils:playEffect(7,false);
  end
  if num == self.tab_num then
    return;
  end
  -- if 2 == num then
  --   sharedTextAnimateReward():animateStartByString("佣兵暂未开启 ~");
  --   return;
  -- end
  if self.tab_btns[self.tab_num] then
    self.tab_btns[self.tab_num]:select(false);
  end
  if self.scrollViews[self.tab_num] then
    self.scrollViews[self.tab_num]:setVisible(false);
  end
  self.tab_num = num;
  self.tab_btns[self.tab_num]:select(true);
  for i=2,1,-1 do
    if self.tab_num == i then

    else
      self.armature.display:removeChild(self.tab_btns[i],false);
      self.armature.display:addChild(self.tab_btns[i]);
    end
  end
  self.armature.display:removeChild(self.tab_btns[self.tab_num],false);
  self.armature.display:addChild(self.tab_btns[self.tab_num]);

  self:getScrollView(self.tab_num):setVisible(true);
  -- self:getScrollView(self.tab_num).parent:removeChild(self:getScrollView(self.tab_num));
end

function PeibingPopup:getScrollView(num)
  if not self.scrollViews[num] then
    local left_item_layer=ListScrollViewLayer.new();
    left_item_layer:initLayer();
    left_item_layer:setPosition(makePoint(106,90));
    left_item_layer:setViewSize(makeSize(300,500));
    left_item_layer:setItemSize(makeSize(300,490));
    self.armature.display:addChildAt(left_item_layer,3);
    self.scrollViews[num] = left_item_layer;
    left_item_layer.items_arr = {};

    local cout = (1 == num and math.ceil(table.getn(self.datas)/6) or math.ceil(table.getn(self.datas_yongbing)/6));
    for i=1,cout do
      local item=PeibingPopupItem.new();
      item:initialize(self,self.onCardTap,num,i);
      left_item_layer:addItem(item);
      table.insert(left_item_layer.items_arr, item);
    end
  end
  return self.scrollViews[num];
end

function PeibingPopup:setData(not_need_zhanli_animation)
  uninitializeSmallLoading();

  for k,v in pairs(self.figures) do
    self.armature.display:removeChild(v);
    self.armature.display:removeChild(self.figures_shadow[k]);
  end

  local heroNumber = 5;
  self.figures = {};
  self.figures_shadow = {};
  local zhanli = 0;

  for i=1,heroNumber do
    if not self.generalIDs[i] then
      break;
    end
    local generalData = self.heroHouseProxy:getGeneralData(self.generalIDs[i].GeneralId);
    if not generalData then
      generalData = self.familyProxy:getYongbingDataByGeneralID(self.generalIDs[i].GeneralId);
      if not generalData then
        --sharedTextAnimateReward():animateStartByString("佣兵被召回,已自动下战哦 ~");
        local s = "佣兵被召回,已自动下战哦 ~";
        local popup=CommonPopup.new();
        popup:initialize(s,nil,nil,nil,nil,nil,true,nil,nil);
        self:addChild(popup);
        table.remove(self.generalIDs,i);
        break;
      end
    end
  end
  
  for i = 1 , 9 do
    self["name_descb" .. i]:setString(" ");
  end
  local pos_size = self.armature.display:getChildByName("slot_l_1"):getContentSize();
  for i=1,heroNumber do
    if not self.generalIDs[i] then
      break;
    end
    local generalData = self.heroHouseProxy:getGeneralData(self.generalIDs[i].GeneralId);
    if not generalData then
      generalData = self.familyProxy:getYongbingDataByGeneralID(self.generalIDs[i].GeneralId);
      generalData.IsYongBing = 1;
    end
    local configID = generalData.ConfigId;
    local figure=CompositeActionAllPart.new();
    figure:initLayer();
    figure:transformPartCompose(self.bagProxy:getCompositeRoleTable4Player(analysis("Kapai_Kapaiku",configID,"material_id")));
    local pos = self.armature.display:getChildByName("slot_l_" .. self.generalIDs[i].Place):getPosition();
    figure:setPositionXY(pos_size.width/2+pos.x, -pos_size.height/2+pos.y);
    figure:setScale(0.8);
    --self.figure:changeFaceDirect(false);
    figure.generalData = generalData;
    table.insert(self.figures, figure);

    self["name_descb" .. self.generalIDs[i].Place]:setString(analysis("Kapai_Kapaiku",generalData.ConfigId,"name"));

    local layer = Layer.new();
    layer:initLayer();
    layer:setContentSize(makeSize(100,150));
    layer:setPositionX(-50);
    layer:addEventListener(DisplayEvents.kTouchBegin,self.onCompositeBegin,self,self.generalIDs[i].Place);
    -- layer:addEventListener(DisplayEvents.kTouchTap,self.onCompositeTap,self,self.generalIDs[i].Place);
    figure:addChild(layer);

    local shadow = Image.new();
    shadow:loadByArtID(19);
    local shadow_size = shadow:getContentSize();
    shadow:setPositionXY(-shadow_size.width/2,-shadow_size.height/2);
    shadow:setScale(0.8);
    shadow.touchEnabled = false;
    figure:addChildAt(shadow,0);
    table.insert(self.figures_shadow, shadow);

    if TEAM_TYPE_TenCountry == self:getTeamType() then
      local bloodItem = self.tenCountryProxy:getBloodItem(self.bloodData,generalData)
      bloodItem:setPositionXY(-70,-45)
      figure:addChild(bloodItem)
    end

    if 1 == generalData.IsYongBing then
      zhanli = generalData.Zhanli + zhanli;
    else
      zhanli = self.heroHouseProxy:getZongZhanli(self.generalIDs[i].GeneralId) + zhanli;
    end
  end

  local function sortfunc(data_a, data_b)
    return data_a:getPositionY() > data_b:getPositionY();
  end
  table.sort(self.figures, sortfunc);
  for k,v in pairs(self.figures) do
    self.armature.display:addChild(v);
  end
  self.zhanLi:setData(math.floor(zhanli),"common_number",40);

  local size = self.zhanLi:getGroupBounds().size;
  self.zhanLi:setPositionXY(-size.width/2,-size.height/2);
  self.zhanLiNode:setPositionXY(size.width/2+550,size.height/2+82);
  if not not_need_zhanli_animation then
    if not self.actioned then

    else
      local array = CCArray:create();
      array:addObject(CCEaseSineOut:create(CCScaleTo:create(0.2,1.5),0.2));
      array:addObject(CCEaseSineOut:create(CCScaleTo:create(0.2,1),0.2));
      self.zhanLiNode:runAction(CCSequence:create(array));
    end
    self.actioned = true;
  end

  for k,v in pairs(self.scrollViews) do
    for k_,v_ in pairs(v.items_arr) do
      v_:setIsPlayImg();
    end
  end

  self.zhenfa_descb:setString(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"name"));
  self.zhenfa_descb_1:setString(analysis2key("Zhenfa_Zhenfashengji","formId",self.generalIDs_formationId,"level",self.zhenFaProxy:getLevelByID(self.generalIDs_formationId)).Info);

  local places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"position"),",");
  local place_table = {};
  for k,v in pairs(places) do
    place_table[tonumber(v)] = true;
  end
  for i=1,9 do
    self.armature.display:getChildByName("slot_l_" .. i .. "_over"):setVisible(place_table[i]);
  end
end

function PeibingPopup:getPlaceByGeneralIDOnGeneralIDs(generalID)
  for k,v in pairs(self.generalIDs) do
    if generalID == v.GeneralId then
      return v.Place;
    end
  end
end

function PeibingPopup:getGeneralIDByPlaceOnGeneralIDs(place)
  for k,v in pairs(self.generalIDs) do
    if place == v.Place then
      return v.GeneralId;
    end
  end
end

function PeibingPopup:refreshGeneralIDs(generalID, place)
  if not generalID or not place then error(""); end

  for k,v in pairs(self.generalIDs) do
    if generalID == v.GeneralId then
      if place == v.Place then
        table.remove(self.generalIDs, k);
        self:setData();
      else
        v.Place = place;
        self:setData();
      end
      return;
    end
  end
  table.insert(self.generalIDs, {GeneralId=generalID,Place=place});
  self:setData();
end

--上阵
function PeibingPopup:onCardTap(items, place)
  MusicUtils:playEffect(504);
  if self:getIsPlayByGeneralID(items.GeneralId) then
    self:refreshGeneralIDs(items.GeneralId,self:getPlaceByGeneralIDOnGeneralIDs(items.GeneralId));
    return;
  else
    if not place then
      local places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"position"),",");
      local job = analysis("Kapai_Kapaiku",items.ConfigId,"job");
      if 1==job or 4==job then
        for i=1,table.getn(places) do
          if not self:getGeneralIDByPlaceOnGeneralIDs(tonumber(places[i])) then
            place = tonumber(places[i]);
            break;
          end
        end
      else
        for i=table.getn(places),1,-1 do
          if not self:getGeneralIDByPlaceOnGeneralIDs(tonumber(places[i])) then
            place = tonumber(places[i]);
            break;
          end
        end
      end
    end
  end

  if not place or self:getGeneralInPlayOverCount() then
    sharedTextAnimateReward():animateStartByString("上阵人数已满哦 ~");
    return;
  end
  
  --佣兵
  if items.silver_need_for_guyong then
    print("==========(((((((((",self.countControlProxy:getRemainCountByID(10,0));
    if items.silver_need_for_guyong > self.userCurrencyProxy:getSilver() then
      sharedTextAnimateReward():animateStartByString("银两不足哦 ~");
      return;
    end
    local configID = items.ConfigId;
    for k,v in pairs(self.generalIDs) do
      local data = self.heroHouseProxy:getGeneralData(v.GeneralId);
      if data then
        if configID == data.ConfigId then
          sharedTextAnimateReward():animateStartByString("同名英雄不能同时上阵哦 ~");
          return;
        end
      else
        data = self.familyProxy:getYongbingDataByGeneralID(v.GeneralId);
        if data then
          if configID == data.ConfigId then
            sharedTextAnimateReward():animateStartByString("同名英雄不能同时上阵哦 ~");
            return;
          else
            sharedTextAnimateReward():animateStartByString("只能同时上阵一名佣兵哦 ~");
            return;
          end
        else
          sharedTextAnimateReward():animateStartByString("佣兵已被召回哦 ~");
          return;
        end
      end
    end

    if TEAM_TYPE_TenCountry == self:getTeamType() and 0 ~= self.familyProxy.shiguo_general_id then

    else
      -- local count_total = tonumber(analysis("Huiyuan_Huiyuantequan",19,"vip" .. self.userProxy:getVipLevel()));
      -- local count = self.countControlProxy:getCurrentCountByID(10,0);
      -- count = tonumber(count);
      -- if count_total <= count then
      if 0 == tonumber(self.countControlProxy:getRemainCountByID(10,0)) then
        sharedTextAnimateReward():animateStartByString("今天的雇佣次数达到上限了哦 ~");
        return;
      end
    end

  else
    local configID = items.ConfigId;
    for k,v in pairs(self.generalIDs) do
      local data = self.familyProxy:getYongbingDataByGeneralID(v.GeneralId);
      if data then
        if configID == data.ConfigId then
          sharedTextAnimateReward():animateStartByString("同名英雄不能同时上阵哦 ~");
          return;
        end
      end
    end
  end

  self:refreshGeneralIDs(items.GeneralId, place);


  if GameVar.tutorStage == TutorConfig.STAGE_1002 then
      openTutorUI({x=1075, y=0, width = 130, height = 144, alpha = 125});
  elseif  GameVar.tutorStage == TutorConfig.STAGE_1003 then
      local xPos, yPos,width,height;
      local totalCount = #self.heroHouseProxy:getGeneralArray()
      local count = table.getn(self.generalIDs)
      if totalCount == count or count == self.placeOpen4Juqing then
        xPos, yPos = 1075,0
        width,height = 130, 144
      else
        local generalId = self:getUnPlayGeneralId();
        xPos, yPos = self:getGeneralPosByGeneralId(generalId)
        width,height = 120, 110
        local generalVO = self.heroHouseProxy:getGeneralData(generalId);
        table.insert(self.shadowProxy.generalIdArray,generalVO)
      end
      openTutorUI({x=xPos, y=yPos, width = width, height = height, alpha = 125});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
     local xPos, yPos= 1075,0;
     openTutorUI({x=xPos, y=yPos, width = 130, height = 144, alpha = 125});  
  elseif GameVar.tutorStage == TutorConfig.STAGE_1008 then
      local xPos, yPos;
      local totalCount = #self.heroHouseProxy:getGeneralArray()
      local count = table.getn(self.generalIDs)

      if totalCount == count or count == self.placeOpen4Juqing+1 then
          xPos, yPos = 1075,0
      else
          local generalId = self:getUnPlayGeneralId();
          xPos, yPos = self:getGeneralPosByGeneralId(generalId)
      end
      openTutorUI({x=xPos, y=yPos, width = 132, height = 144, alpha = 125});
  end
end

function PeibingPopup:getUnPlayGeneralId()
    local generalArr = self.heroHouseProxy:getGeneralArray()
    for k, v in pairs(generalArr)do
      if not self:isInGeneralIDs(v.GeneralId) then
        return v.GeneralId;
      end
    end
end
function PeibingPopup:isInGeneralIDs(generalId)
  for k,v in pairs(self.generalIDs)do
    if v.GeneralId == generalId then
      return true;
    end 
  end
  return false;
end

function PeibingPopup:getGeneralPosByGeneralId(generalId)
    local datas
    if TEAM_TYPE_TenCountry == self:getTeamType() then
       datas = self.heroHouseProxy:getTenCountryLeftGeneral(self.tenCountryProxy);
    else
       datas = self.heroHouseProxy:getGeneralArrayWithPlayer();
    end
    local index = 0;
    local xPos = 0
    local yPos = 0
    for k, v in ipairs(datas) do
      index = index + 1;
      if v.GeneralId == generalId then
        xPos = 2+(-1+index)%2*142
        yPos = 350-175*math.floor((-1+index)/2)
      end
    end
    print("==============================xPos, yPos", xPos, yPos)
    return xPos+110, yPos+130;
end
function PeibingPopup:getShadowPlayGeneralCount()
    local returnValue = 0;
    local generalIdArray = self.heroHouseProxy:getShadowGeneral(self.shadowProxy)
    for k,v in pairs(generalIdArray) do
      returnValue = returnValue + 1;
    end
    return returnValue;
end
function PeibingPopup:getArenaAtkPlayGeneralCount()
    local returnValue = 0;
    local generalIdArray = self.heroHouseProxy:getArenaAtkGeneral(self.arenaProxy)
    for k,v in pairs(generalIdArray) do
      returnValue = returnValue + 1;
    end
    return returnValue;
end
function PeibingPopup:getArenaDefPlayGeneralCount()
    local returnValue = 0;
    local generalIdArray = self.heroHouseProxy:getArenaDefGeneral(self.arenaProxy)
    for k,v in pairs(generalIdArray) do
      returnValue = returnValue + 1;
    end
    return returnValue;
end

function PeibingPopup:getTenCountryGeneralIDs(generalID)
  local copyTable = copyTable(self.generalIDs)
  for k,v in pairs(copyTable) do
    if generalID == v then
      table.remove(copyTable, k);
      return;
    end
  end
  table.insert(copyTable, generalID);
  return copyTable
end

function PeibingPopup:onEnterBTNTap(event)
  if #self.generalIDs == 0 then
    sharedTextAnimateReward():animateStartByString("最少有一个英雄才能挑战啦！");
    return;
  end
  local tips
  local function closeGame()
    tips.parent:removeChild(tips)
  end

  local function gotoBattle()
    local data = self:sendDataToServer(TEAM_TYPE_TenCountry == self:getTeamType());
    if TEAM_NONE_HERO == data then
      sharedTextAnimateReward():animateStartByString("最少有一个英雄才能挑战啦！");
      return;
    elseif TEAM_SUCCESS == data then

    elseif TEAM_NOT_CHANGE == data then
      self:onGotoBattleConfirm();
    elseif TEAM_WU_BANG_PAI == data then
      sharedTextAnimateReward():animateStartByString("帮派已退出,先把佣兵下战哦 ~");
      return;
    elseif TEAM_YONG_BING_BEI_ZHAO_HUI == data then
      sharedTextAnimateReward():animateStartByString("佣兵已被召回,先把佣兵下战哦 ~");
      return;
    end
  end  
  local strongPonitState = self.storyLineProxy:getStrongPointState(10002008)
  if #self.generalIDs < self.placeOpen4Juqing 
    and ((#self.datas + #self.datas_yongbing) >= self.placeOpen4Juqing)
    and GameVar.tutorStage == TutorConfig.STAGE_99999
    and strongPonitState == GameConfig.STRONG_POINT_STATE_1 then
    local text_table = {"战斗","编队"}
    tips = CommonPopup.new();
    tips:initialize("当前出战人数不足,会严重影响战斗力,确定继续战斗么?",self,gotoBattle,nil,nil,nil,nil,text_table,nil,true,nil,true);
    commonAddToScene(tips, true) 
  else
    gotoBattle()
  end
end

function PeibingPopup:onGotoBattleConfirm()
  for k,v in pairs(self.generalIDs) do
    if self.familyProxy:getYongbingDataByGeneralID(v.GeneralId) then
      print("============hecDC===========",self:getTeamType(),v.GeneralId);
      hecDC(3,24,3,{type = self:getTeamType(),heroID = v.GeneralId});
      break;
    end
  end
  print(self.notificationData , self.notificationData.context , self.notificationData.onEnter);
  if self.notificationData and self.notificationData.context and self.notificationData.onEnter then
    self.notificationData.onEnter(self.notificationData.context);
    self.notificationData.context = nil;
    self.notificationData.onEnter = nil;
  end
end

function PeibingPopup:getIsPlayByGeneralID(generalID)
  return self:getPlaceByGeneralIDOnGeneralIDs(generalID);
end

function PeibingPopup:getGeneralInPlayOverCount()
  return self.placeOpen4Juqing <= table.getn(self.generalIDs);
end

function PeibingPopup:sendDataToServer(not_beizhaohui_check_bool)
  print("pre---------------->");
  for k,v in pairs(self.generalIDs_ori) do
    print(k,v.GeneralId,v.Place);
  end
  print("sendDataToServer");
  for k,v in pairs(self.generalIDs) do
    print(k,v.GeneralId,v.Place);
  end

  if 0 == table.getn(self.generalIDs) then
    return TEAM_NONE_HERO;
  end
  
  if not not_beizhaohui_check_bool then
    for k,v in pairs(self.generalIDs) do
      local data = self.heroHouseProxy:getGeneralData(v.GeneralId);
      print(v.GeneralId,"getGeneralData",data);
      if not data then
        data = self.familyProxy:getYongbingDataByGeneralID(v.GeneralId);
        print(v.GeneralId,"getYongbingDataByGeneralID",data);
        if data then
          if not self.userProxy:getHasFamily() then
            return TEAM_WU_BANG_PAI;
          end
        else
          return TEAM_YONG_BING_BEI_ZHAO_HUI;
        end
      end
    end
  end

  if table.getn(self.generalIDs) == table.getn(self.generalIDs_ori) then
    local tmp_data = {};
    local sign = true;
    for k,v in pairs(self.generalIDs) do
      tmp_data[v.GeneralId] = v.Place;
    end
    for k,v in pairs(self.generalIDs_ori) do
      sign = sign and (tmp_data[v.GeneralId]==v.Place);
    end
    if sign then
      -- if table.getn(self.generalIDs_idArray) == table.getn(self.generalIDs_idArray_ori) then
      --   local tmp_data_idArray = {};
      --   local sign_idArray = true;
      --   for k,v in pairs(self.generalIDs_idArray) do
      --     tmp_data_idArray[v] = v;
      --   end
      --   for k,v in pairs(self.generalIDs_idArray_ori) do
      --     sign_idArray = sign_idArray and tmp_data_idArray[v];
      --   end
      --   if sign_idArray then
      --     return TEAM_NOT_CHANGE;
      --   end
      -- end
      if self.generalIDs_formationId == self.generalIDs_formationId_ori then
        return TEAM_NOT_CHANGE;
      end
    end
  end

  local team_type = self:getTeamType();
  if 5 == team_type then
    local generalIdString;
    for k,v in pairs(self.generalIDs) do
      local configID = self.heroHouseProxy:getGeneralData(v.GeneralId).ConfigId;
      if not generalIdString then
        generalIdString = configID
      else
        generalIdString = generalIdString.."^"..configID
      end
    end
    hecDC(3,16,6,{heroID = generalIdString})
  end
  local data = {};
  local generalID = nil;
  local place = nil;
  for k,v in pairs(self.generalIDs) do
    local bool = false;
    for k_,v_ in pairs(self.datas_yongbing) do
      if v.GeneralId == v_.GeneralId then
        generalID = v.GeneralId;
        place = v.Place;
        bool = true;
        break;
      end
    end
    if not bool then
      table.insert(data,{GeneralId = v.GeneralId, Place = v.Place});
    end
  end
  for k,v in pairs(data) do
    print("GeneralIdArray->",v.GeneralId,v.Place);
  end
  print("GeneralId->",generalID,place);
  print("Type->",team_type);
  print("formation->",self.generalIDs_formationId);

  local id_array = {};
  for k,v in pairs(self.generalIDs_idArray) do
    table.insert(id_array,{ID=v});
    print("id_array->",v);
  end

  initializeSmallLoading();
  sendMessage(6,12,{GeneralIdArray = data, Type = team_type, GeneralId = generalID, Place = place, FormationId = self.generalIDs_formationId, IDArray = id_array});
  return TEAM_SUCCESS;
end

function PeibingPopup:getTeamType()
  -- local team_type = 1;
  -- if self.notificationData.funcType == "Treasury" then
  --   team_type = 3
  -- elseif self.notificationData.funcType == "ArenaAttack" then
  --   team_type = 6
  -- elseif self.notificationData.funcType == "ArenaDefense" then
  --   team_type = 5
  -- elseif self.notificationData.funcType == "TenCountry" then 
  --   team_type = 2
  -- elseif self.notificationData.funcType == "Shadow" then 
  --   team_type = 7
  -- elseif self.notificationData.funcType == "FiveEleBattle" then
  --    team_type = 6+self.notificationData.FEType;
  -- elseif self.notificationData.funcType = "XunBao" then
  --   team_type = 12
  -- end
  local team_type = TEAM_TYPE_JuQing;
  if self.notificationData.funcType == "Treasury" then
    team_type = TEAM_TYPE_Treasury;
  elseif self.notificationData.funcType == "ArenaAttack" then
    team_type = TEAM_TYPE_ArenaAttack;
  elseif self.notificationData.funcType == "ArenaDefense" then
    team_type = TEAM_TYPE_ArenaDefense;
  elseif self.notificationData.funcType == "TenCountry" then 
    team_type = TEAM_TYPE_TenCountry;
  elseif self.notificationData.funcType == "Shadow" then 
    team_type = TEAM_TYPE_Shadow;
  elseif self.notificationData.funcType == "XunBao" then
    team_type = TEAM_TYPE_XunBao;
  elseif self.notificationData.funcType == "Meeting" then
    team_type = TEAM_TYPE_Meeting;
  end
  return team_type;
end

function PeibingPopup:getBattleType()
  local team_types = {TEAM_TYPE_JuQing,
                     TEAM_TYPE_Treasury,
                     TEAM_TYPE_ArenaAttack,
                     TEAM_TYPE_ArenaDefense,
                     TEAM_TYPE_TenCountry,
                     TEAM_TYPE_Shadow,
                     TEAM_TYPE_XunBao,
                     TEAM_TYPE_Meeting};
  local battle_types = {1,
                        5,
                        2,
                        7,
                        3,
                        10,
                        12,
                        9};
  for k,v in pairs(team_types) do
    if self:getTeamType() == v then
      return battle_types[k];
    end
  end
end

function PeibingPopup:onFormationIDChange(id, need_sort)
  self.generalIDs_formationId = id;
  self.zhenfa_descb:setString(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"name"));
  self.zhenfa_descb_1:setString(analysis2key("Zhenfa_Zhenfashengji","formId",self.generalIDs_formationId,"level",self.zhenFaProxy:getLevelByID(self.generalIDs_formationId)).Info);
  for k,v in pairs(self.right_item_layer.item_arr) do
    v:setIsPlayImg(self.generalIDs_formationId == v.id);
  end
  if self.generalIDs_formationId == self.generalIDs_formationId_ori and not self.formation_id_changed then
    need_sort = false;
  end
  if need_sort then
    self.formation_id_changed = true;
    local places = StringUtils:lua_string_split(analysis("Zhenfa_Zhenfa",self.generalIDs_formationId,"position"),",");
    local function sortfunc(data_a, data_b)
      return data_a.Place < data_b.Place;
    end
    for k,v in pairs(self.generalIDs) do
      v.Place = 0;
    end
    for k,v in pairs(self.generalIDs) do
      local job = 0;
      local data = self.heroHouseProxy:getGeneralData(v.GeneralId);
      if not data then
        data = self.familyProxy:getYongbingDataByGeneralID(v.GeneralId);
      end
      if data then
        job = analysis("Kapai_Kapaiku",data.ConfigId,"job");
      end
      if 1==job or 4==job then
        for i=1,table.getn(places) do
          if not self:getGeneralIDByPlaceOnGeneralIDs(tonumber(places[i])) then
            v.Place = tonumber(places[i]);
            break;
          end
        end
      else
        for i=table.getn(places),1,-1 do
          if not self:getGeneralIDByPlaceOnGeneralIDs(tonumber(places[i])) then
            v.Place = tonumber(places[i]);
            break;
          end
        end
      end
    end
    table.sort(self.generalIDs,sortfunc);
  end

  self:setData(true);
end