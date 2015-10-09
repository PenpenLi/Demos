
TenCountryPopup=class(LayerPopableDirect);

function TenCountryPopup:ctor()
  self.class=TenCountryPopup;
  self.skeletonTenCountry=nil;
  self.tenCountryProxy = nil;
  self.heroHouseProxy=nil
end

function TenCountryPopup:dispose()
  self:removeAllEventListeners();
  self:removeChildren();
	TenCountryPopup.superclass.dispose(self);
  BitmapCacher:removeUnused();
  
  self.tenCountryProxy:resertData()
end

function TenCountryPopup:initialize()

  self.tenCountryProxy=nil;
end

function TenCountryPopup:onDataInit()
  self.tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
  self.heroHouseProxy=self:retrieveProxy(HeroHouseProxy.name);
  self.countProxy=self:retrieveProxy(CountControlProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.skeletonTenCountry = getSkeletonByName("shiguo_ui");
  local layerPopableData = LayerPopableData.new();
  layerPopableData:setHasUIBackground(true);
  layerPopableData:setHasUIFrame(false);
  layerPopableData:setArmatureInitParam(self.skeletonTenCountry,"shiguo_ui");
  self:setLayerPopableData(layerPopableData);
  sendMessage(19,3)
  setFactionCurrencyVisible(true)
  MusicUtils:playEffect(7)
end

function TenCountryPopup:onPrePop()
  self:setContentSize(makeSize(GameConfig.STAGE_WIDTH,GameConfig.STAGE_HEIGHT));
  self.childLayer = LayerColor.new();
  self.childLayer:initLayer();
  local mainSize = Director:sharedDirector():getWinSize();
  self.childLayer:setContentSize(makeSize(mainSize.width, mainSize.height));
  self.childLayer:setPositionXY(-GameData.uiOffsetX,  -GameData.uiOffsetY);
end

function TenCountryPopup:oNclick()

end

function TenCountryPopup:onUIInit()

end

function TenCountryPopup:onRequestedData()

    local mapuiArmature=self.skeletonTenCountry:buildArmature("mapui_ui");
    mapuiArmature.animation:gotoAndPlay("f1");
    mapuiArmature:updateBonesZ();
    mapuiArmature:update();
    self.mapuiArmature = mapuiArmature;

    local mapuiArmature_d=mapuiArmature.display;
    self:addChild(mapuiArmature_d);

    self.ckbutton=Button.new(self.mapuiArmature:findChildArmature("reStartbutton"),false);
    self.ckbutton:addEventListener(Events.kStart,self.onFetchTap,self);

    local text_data = self.mapuiArmature:getBone("lefttimes_text").textData;
    self.lefttimesText = createTextFieldWithTextData(text_data,"今日剩余次数：");
    self:addChild(self.lefttimesText);
  self.askBtn = Button.new(self.mapuiArmature:findChildArmature("common_copy_ask_button"),false,"");
  self.askBtn:addEventListener(Events.kStart,self.onShowTip, self);
  self:initTenCountryMapData()
end

function TenCountryPopup:onShowTip()
  local text=analysis("Tishi_Guizemiaoshu",8,"txt");
  TipsUtil:showTips(self.askBtn,text,500,nil,50);
  MusicUtils:playEffect(7)
end

function TenCountryPopup:initBossView(placeId)
  self:initOtherProxy()
  initializeSmallLoading();
  sendMessage(19,18)
end

function TenCountryPopup:initOtherProxy()
  if not self.arenaProxy then
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
      self.arenaProxy = self:retrieveProxy(ArenaProxy.name);
      self.skeleton = getSkeletonByName("arena_ui");
  end
end

function TenCountryPopup:refreshPeibingChange()
    self.bossViewLayer:refreshLeftDetailData();
end

function TenCountryPopup:refreshHeroDetailData(zhanli,userName, formationId, placeIDArray, level)
  require "main.view.arena.JingjichangZhandouPopup";
  self.bossViewLayer = JingjichangZhandouPopup.new()
  local userData = {}
  userData.Zhanli = zhanli
  userData.UserId = 0
  local guan = self.tenCountryProxy.placeId
  self.bossViewLayer:initialize(self,userData,true)
  self:addChild(self.bossViewLayer)
  self.bossViewLayer:refreshHeroDetailData(0, formationId, placeIDArray, userName, level, guan)
  setFactionCurrencyVisible(false)
  -- require "main.controller.command.scriptCartoon.MainSceneScript"
  -- self.mainSceneScript = MainSceneScript.new()
  -- self.mainSceneScript:initScript(self)
  -- self.mainSceneScript:beginScript(1003)
end

-- function TenCountryPopup:endScriptData()
--   self.mainSceneScript:dispose()
--   self.mainSceneScript = nil
-- end

function TenCountryPopup:removeChildBossView()
    if self.bossViewLayer then
      self:removeChild(self.bossViewLayer)
      self.bossViewLayer = nil
      setFactionCurrencyVisible(true)
    end
end

function TenCountryPopup:onFetchTap()
    local leftTimes = self.countProxy:getRemainCountByID(CountControlConfig.TEN_COUNTRY,CountControlConfig.Parameter_0)
    local buyTimes = self.countProxy:getRemainLimitedCountByID(CountControlConfig.TEN_COUNTRY,CountControlConfig.Parameter_0)
    if leftTimes <= 0 then
      if buyTimes <= 0 then
          sharedTextAnimateReward():animateStartByString("亲~没有次数了哦！");
          return
      end
    end
    local tips=CommonPopup.new();
    tips:initialize("重开以后，将会重置所有的关卡、英雄哦~确定重置吗",self,self.onConfirm,nil,nil,nil,nil,nil);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(tips);
    self.resertSate = true
    MusicUtils:playEffect(7)
end

function TenCountryPopup:onConfirm()
  sendMessage(19,8)
end

function TenCountryPopup:onUIClose()
  self:dispatchEvent(Event.new("closeNotice",nil,self));
end


function TenCountryPopup:refreshTenCountryMapData()
    if self.resertSate then
        self:removeChild(self.tenCountryLayer)
        self.tenCountryLayer = nil
        self:initTenCountryMapData()
        self.resertSate = nil
    end
    self.tenCountryLayer:refreshTenCountryMapData(self.tenCountryProxy)
    self:refreshTimesData()
    -- self:removeChild(self.imageBgup)
    -- self:removeChild(self.imageBgup2)
end

function TenCountryPopup:initTenCountryMapData()
    if self.tenCountryLayer then return end
    require "main.view.tenCountry.ui.TenCountryLayer";
    self.tenCountryLayer = TenCountryLayer.new()
    self.tenCountryLayer:initLayer()
    self.tenCountryLayer:initialize(self,self.tenCountryProxy)
    self:addChildAt(self.tenCountryLayer,0)
    AddUIFrame(self);
end

function TenCountryPopup:refreshTimesData()
    local string = self.countProxy:getRemainCountByID(CountControlConfig.TEN_COUNTRY,CountControlConfig.Parameter_0)
    self.lefttimesText:setString("今日剩余次数："..string.."次");
    local twoColorNum = string == 0 and 6 or 2;
    local color = CommonUtils:ccc3FromUInt(getColorByQuality(twoColorNum));
    self.lefttimesText:setColor(color);
end

function TenCountryPopup:refreshTeamLayerData()
  if self.teamViewLayer then
    self.teamViewLayer:refreshTeamLayerData(self.upTeamPlace)
  end
end

function TenCountryPopup:setWillUpTeamPlace(place)
    self.upTeamPlace = place
end

function TenCountryPopup:getWillUpTeamPlace()
    return self.upTeamPlace
end