require "core.display.LayerPopable";
require "main.view.arena.JingjichangDuishou";
require "main.view.arena.JingjichangPaihang";
require "main.view.arena.JingjichangRenwu";
require "main.view.arena.JingjichangJiangli";
require "main.view.arena.JingjichangZhandouPopup";

JingjichangPopup=class(LayerPopableDirect);

function JingjichangPopup:ctor()
  self.class=JingjichangPopup;
end

function JingjichangPopup:dispose()
  removeSchedule(self,self.onSche);
  self:removeAllEventListeners();
  self:removeChildren();
  self.armature:dispose();
  JingjichangPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
end

function JingjichangPopup:onDataInit()
  self.familyProxy=self:retrieveProxy(FamilyProxy.name);
  self.bagProxy = self:retrieveProxy(BagProxy.name);
  self.effectProxy = self:retrieveProxy(EffectProxy.name);
  self.countControlProxy = self:retrieveProxy(CountControlProxy.name);
  self.itemUseQueueProxy = self:retrieveProxy(ItemUseQueueProxy.name);
  self.openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
  self.userDataAccumulateProxy = self:retrieveProxy(UserDataAccumulateProxy.name);
  self.generalListProxy = self:retrieveProxy(GeneralListProxy.name);
  self.userProxy = self:retrieveProxy(UserProxy.name);
  self.equipmentInfo = self:retrieveProxy(EquipmentInfoProxy.name);
  self.userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  self.mailProxy = self:retrieveProxy(MailProxy.name);
  self.shopProxy = self:retrieveProxy(ShopProxy.name);
  self.heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  self.arenaProxy = self:retrieveProxy(ArenaProxy.name);
  self.skeleton = getSkeletonByName("arena_ui");

  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(true);
  layerPopableData:setShowCurrency(true);--self.userProxy:getHasFamily()
  layerPopableData:setPreUIData(StaticArtsConfig.BACKGROUD_HERO_PRO, nil, true, 2);
  layerPopableData:setArmatureInitParam(self.skeleton, "arena_ui");
  self:setLayerPopableData(layerPopableData);

  self.tab_panels={};
  self.shuaxin_duishou_yuanbao = analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1080,"constant");


end

function JingjichangPopup:onPrePop()
  self:changeWidthAndHeight(1280,720);
end

function JingjichangPopup:onUIInit()
  local askButton =self.armature.display:getChildByName("ask");
  SingleButton:create(askButton);
  askButton:addEventListener(DisplayEvents.kTouchTap, self.onAskTap, self);
  self.askBtn = askButton;

  local text_data=self.armature:getBone("saiji_descb").textData;
  self.saiji_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.saiji_descb);

  text_data=self.armature:getBone("shijian_descb").textData;
  self.shijian_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.shijian_descb);

  text_data=self.armature:getBone("xinxi_title_bg").textData;
  self.xinxi_title_bg=createTextFieldWithTextData(text_data,"我的信息");
  self.armature.display:addChild(self.xinxi_title_bg);

  text_data=self.armature:getBone("zhandui_descb").textData;
  self.zhandui_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.zhandui_descb);

  text_data=self.armature:getBone("jifen_descb").textData;
  self.jifen_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.jifen_descb);

  text_data=self.armature:getBone("paiming_descb").textData;
  self.paiming_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.paiming_descb);

  text_data=self.armature:getBone("changshu_descb").textData;
  self.changshu_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.changshu_descb);

  text_data=self.armature:getBone("rongyuzhi_descb").textData;
  self.rongyuzhi_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.rongyuzhi_descb);

  text_data=self.armature:getBone("cishu_descb").textData;
  self.cishu_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.cishu_descb);

  text_data=self.armature:getBone("shuaxin_shijian_descb").textData;
  self.shuaxin_shijian_descb=createTextFieldWithTextData(text_data,"");
  self.armature.display:addChild(self.shuaxin_shijian_descb);
  self.shuaxin_shijian_descb:setVisible(false);

  text_data=self.armature:getBone("shuaxin_yuanbao_descb").textData;
  self.shuaxin_yuanbao_descb=createTextFieldWithTextData(text_data,"刷新需要" .. self.shuaxin_duishou_yuanbao .. "元宝");
  self.armature.display:addChild(self.shuaxin_yuanbao_descb);
  self.shuaxin_yuanbao_descb:setVisible(false);

  local trimButtonData=self.armature:findChildArmature("shangdian_btn"):getBone("common_small_red_button").textData;

  local button=self.armature.display:getChildByName("shangdian_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"整理背包");
  button:initializeBMText("商店","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onShopButtonTap,self);
  self.armature.display:addChild(button);

  local button=self.armature.display:getChildByName("goumai_btn");
  local button_pos=convertBone2LB4Button(button);
  self.armature.display:removeChild(button);

  button=CommonButton.new();
  button:initialize("commonButtons/common_small_red_button_normal",nil,CommonButtonTouchable.BUTTON);
  --button:initializeText(trimButtonData,"购买");
  button:initializeBMText("增加","anniutuzi");
  button:setPosition(button_pos);
  button:addEventListener(DisplayEvents.kTouchTap,self.onGoumaiButtonTap,self,i);
  self.armature.display:addChild(button);

  for i=1,4 do
    local button = self.armature.display:getChildByName("tab_btn_" .. i);
    SingleButton:create(button);
    button:addEventListener(DisplayEvents.kTouchTap, self.onTabBTNTap, self, i);
  end
  self:onTabBTNTap(nil,1);

  local button = self.armature.display:getChildByName("shuaxin_btn");
  SingleButton:create(button);
  button:addEventListener(DisplayEvents.kTouchTap, self.onShuaxinBTNTap, self, i);

  initializeSmallLoading();
  if not self.heroHouseProxy:getPeibingPeizhi(6) then
    sendMessage(6,13,{Type=6});
  end
  sendMessage(16,1);
end

function JingjichangPopup:onRequestedData()

end

function JingjichangPopup:onUIClose()
  self:dispatchEvent(Event.new("closeNotice",nil,self));
end

function JingjichangPopup:onPreUIClose()
  
end

function JingjichangPopup:onTabBTNTap(event, data)
  self.select_tab = data;
  for i=1,4 do
    self.armature.display:getChildByName("tab_btn_bg_" .. i):setVisible(data == i);
  end
  self.armature.display:getChildByName("common_background_6_1"):setVisible(data == 1);
  self.armature.display:getChildByName("common_background_6_2"):setVisible(data ~= 1);
  self.armature.display:getChildByName("shuaxin_btn"):setVisible(data == 1);

  if not self.tab_panels[data] then
    if 1 == data then
      self.tab_panels[data] = JingjichangDuishou.new();
      self.tab_panels[data]:initialize(self);
      self.tab_panels[data]:setPositionXY(0,0);
      self.armature.display:addChild(self.tab_panels[data]);
    elseif 2 == data then
      self.tab_panels[data] = JingjichangPaihang.new();
      self.tab_panels[data]:initialize(self);
      self.tab_panels[data]:setPositionXY(0,0);
      self.armature.display:addChild(self.tab_panels[data]);
    elseif 3 == data then
      self.tab_panels[data] = JingjichangJiangli.new();
      self.tab_panels[data]:initialize(self);
      self.tab_panels[data]:setPositionXY(0,0);
      self.armature.display:addChild(self.tab_panels[data]);

      if GameVar.tutorStage == TutorConfig.STAGE_1016 then
        self.tutorLayer = Layer.new();
        self.tutorLayer:initLayer();
        self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
        self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
        self:addChild(self.tutorLayer)
        openTutorUI({x=632, y=233, width = 460, height = 320, fullScreenTouchable = true, hideTutorHand = true, blackBg = true});
      end

    elseif 4 == data then
      self.tab_panels[data] = JingjichangRenwu.new();
      self.tab_panels[data]:initialize(self);
      self.tab_panels[data]:setPositionXY(0,0);
      self.armature.display:addChild(self.tab_panels[data]);
    end
  end
  for k,v in pairs(self.tab_panels) do
    if v then v:setVisible(false); end
  end
  self.tab_panels[data]:setVisible(true);
  self.armature.display:addChild(self.tab_panels[data]);
end
function JingjichangPopup:onTutorTap(event)
  self:removeChild(self.tutorLayer)
  closeTutorUI();
  sendServerTutorMsg({})
end
function JingjichangPopup:onShuaxinBTNTap(event)
  local function onConfirm()
    sendMessage(16,4);
  end
  if self.arenaProxy:getTimeValue() and self.arenaProxy:getTimeValue() <= 0 then
    onConfirm();
  else
    local gold = self.userCurrencyProxy:getGold();
    local function onPopupConfirm()
      if self.shuaxin_duishou_yuanbao > gold then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        self:functionPanel();
        return;
      end
      onConfirm();
    end
    local commonPopup=CommonPopup.new();
    commonPopup:initialize("确定花费" .. self.shuaxin_duishou_yuanbao .. "元宝刷新对手吗?",nil,onPopupConfirm,nil,nil,nil,true);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
  end
end

function JingjichangPopup:onAskTap(event)
  local text=analysis("Tishi_Guizemiaoshu",4,"txt");
  TipsUtil:showTips(self.askBtn,text,800,nil,50);
end

function JingjichangPopup:onShopButtonTap(event)
  self:dispatchEvent(Event.new("TO_SHOP_TWO",nil,self));
end

function JingjichangPopup:functionPanel()
    self:dispatchEvent(Event.new("TO_MAINSCENE_VIP",nil,self));
end

function JingjichangPopup:onGoumaiButtonTap(event)
  local leftTimes = self.countControlProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
  local buyTimes = self.countControlProxy:getRemainLimitedCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1)
  local data = analysis("Huiyuan_Huiyuantequan",3);
  for i=0,15 do
    if data["vip" .. i] and 0 < data["vip" .. i] then
      if i > self.userProxy:getVipLevel() then
        sharedTextAnimateReward():animateStartByString("亲~VIP" .. i .. "才能购买次数哦！");
        self:functionPanel();
        return;
      end
      break;
    end
  end
  if buyTimes <= 0 then
    for i=1 + self.userProxy:getVipLevel(),15 do
      if data["vip" .. (-1 + i)] < data["vip" .. i] then
        sharedTextAnimateReward():animateStartByString("亲~提升VIP等级增加购买次数吧 ~");
        self:functionPanel();
        return;
      end
    end
    -- if self:isNeedVipPopUp() then
    --     local tips=CommonPopup.new();
    --     tips:initialize("VIP等级不足，不能购买次数",self,self.functionPanel,nil,nil,nil,nil,nil);
    --     commonAddToScene(tips,true);
    --     return
    -- end
    sharedTextAnimateReward():animateStartByString("亲~今天不能再购买次数了 ~");
    return;
  end

  local gold = self.countControlProxy:getAddCountNeedGold(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1,true);
  -- if not gold or 0 == gold then
  --     sharedTextAnimateReward():animateStartByString("亲~购买次数用完了哦！");
  --     return
  -- end
  local function onConfirm()
    if gold > self.userCurrencyProxy:getGold() then
        sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_514));
        self:functionPanel();
        return
    end
    sendMessage(3,9,{CountControlType=CountControlConfig.ARENA_COUNT,CountControlParam=CountControlConfig.Parameter_1})
  end
  
  local commonPopup=CommonPopup.new();
  commonPopup:initialize("确定花费" .. gold .. "元宝购买次数吗?",nil,onConfirm,nil,nil,nil,true,nil,nil,true);
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(commonPopup);
end

function JingjichangPopup:isNeedVipPopUp()
  local vipLV=self.userProxy:getVipLevel();
  if vipLV >= 15 then
      return false
  else
      return true
  end
end

function JingjichangPopup:onSche()
  local time = getTimeServer() - self.server_time;
  time = math.max(0,self.data.RemainSeconds - time);

  local d = math.floor(time/86400);
  time = time%86400;
  local h = math.floor(time/3600);
  time = time%3600;
  local m = math.floor(time/60);
  time = time%60;
  local s = time;
  if h < 10 then h = "0" .. h; end
  if m < 10 then m = "0" .. m; end
  if s < 10 then s = "0" .. s; end
  self.shijian_descb:setString(d .. "天" .. h .. ":" .. m .. ":" .. s);

  -- self.data.RemainSeconds = -1 + self.data.RemainSeconds;
  time = self.arenaProxy:getTimeValue();
  self.shuaxin_shijian_descb:setVisible(self.select_tab == 1 and (0 < time));
  self.shuaxin_yuanbao_descb:setVisible(self.select_tab == 1 and (0 < time));
  m = math.floor(time/60);
  time = time%60;
  self.shuaxin_shijian_descb:setString("剩余" .. m .. "分" .. time .. "秒");
end

function JingjichangPopup:refreshData(data)
  uninitializeSmallLoading();

  local generalIDs_peizhi = self.heroHouseProxy:getPeibingPeizhi(6);
  local zhanli = 0;

  for k,v in pairs(generalIDs_peizhi.GeneralIdArray) do
    if 0 ~= v.GeneralId and 0 ~= v.Place then
      zhanli = self.heroHouseProxy:getZongZhanli(v.GeneralId) + zhanli;
    end
  end
  if 0 ~= generalIDs_peizhi.GeneralId and 0 ~= generalIDs_peizhi.Place then
    local data = self.familyProxy:getYongbingDataByGeneralID(generalIDs_peizhi.GeneralId);
    zhanli = data.Zhanli + zhanli;
  end

  self.data = data;
  self.saiji_descb:setString("当前赛季：" .. self.data.Season);
  -- self.shijian_descb:setString(self.data.RemainSeconds);
  self.zhandui_descb:setString("战队战力：" .. math.ceil(zhanli));
  self.jifen_descb:setString("积    分：" .. self.data.Score);
  self.paiming_descb:setString("积分排名：" .. (0 == self.data.Ranking and "未上榜" or self.data.Ranking));
  self.changshu_descb:setString("胜利场数：" .. self.data.Count);
  self:refreshRongyu();
  self:refreshCishu();

  self.server_time = getTimeServer();
  addSchedule(self,self.onSche);
  self:onSche();

  self.tab_panels[1]:refreshData(self.data.UserArenaArray);
end

function JingjichangPopup:refreshUserData(data)
  self.data.UserArenaArray = data;
  self.tab_panels[1]:refreshData(self.data.UserArenaArray);
end

function JingjichangPopup:refreshRongyu()
  self.rongyuzhi_descb:setString("荣 誉 值：" .. self.userCurrencyProxy.score .. "/" .. analysis("Xishuhuizong_Xishubiao",XiShuConfig.TYPE_1053,"constant"));
end

function JingjichangPopup:refreshCishu()
  local string = self.countControlProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1);
  local string1,string2 = self.countControlProxy:getCurrentCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1);
  local string3 = self.countControlProxy:getJibencishu(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1);
  self.cishu_descb:setString("今日次数：" .. string.."/"..string3);
end

function JingjichangPopup:refreshScore(score)
  self.data.Score = score;
  self.jifen_descb:setString("积    分：" .. self.data.Score);
end

function JingjichangPopup:refreshRankingData(data)
  self.tab_panels[2]:refreshData(data);
end

function JingjichangPopup:refreshRenwuData(data)
  self.tab_panels[4]:refreshData(data);
end

function JingjichangPopup:popZhandou(userData)
  local string = self.countControlProxy:getRemainCountByID(CountControlConfig.ARENA_COUNT,CountControlConfig.Parameter_1);
  if 0 == tonumber(string) then
    sharedTextAnimateReward():animateStartByString("战斗次数不足了哦 ~");
    return;
  end
  local pop = JingjichangZhandouPopup.new();
  pop:initialize(self,userData);
  self:addChild(pop);
  self.jingjichangZhandouPopup = pop;
end

function JingjichangPopup:refreshHeroDetailData(userId, formationId, placeIDArray)
  self.jingjichangZhandouPopup:refreshHeroDetailData(userId, formationId, placeIDArray);
end

function JingjichangPopup:refreshPeibingChange()
  self.jingjichangZhandouPopup:refreshLeftDetailData();
end

function JingjichangPopup:refreshNewRightDetailData(userId, formationId, placeIDArray)
  self.jingjichangZhandouPopup:refreshNewRightDetailData(userId, formationId, placeIDArray);
end

function JingjichangPopup:refreshIsUpdating()
  if 1 == self.arenaProxy:getIsUpdating() then
    sharedTextAnimateReward():animateStartByString("当前赛季结束,一分钟后开启新赛季哦 ~");
    self:closeUI();
  end
end