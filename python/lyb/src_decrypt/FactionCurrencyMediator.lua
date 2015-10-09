require "main.view.faction.ui.FactionCurrencyUI";

FactionCurrencyMediator=class(Mediator);

function FactionCurrencyMediator:ctor()
  self.class = FactionCurrencyMediator;
	self.viewComponent=FactionCurrencyUI.new();
end

rawset(FactionCurrencyMediator,"name","FactionCurrencyMediator");

function FactionCurrencyMediator:initializeUI()
  self:getViewComponent():initializeUI();
end

function FactionCurrencyMediator:onRegister()


  local proxyRetriever  = ProxyRetriever.new();

  self.userCurrencyProxy=proxyRetriever:retrieveProxy(UserCurrencyProxy.name);
  self.userProxy = proxyRetriever:retrieveProxy(UserProxy.name);
  self.bagProxy=proxyRetriever:retrieveProxy(BagProxy.name);
  self.countControlProxy=proxyRetriever:retrieveProxy(CountControlProxy.name);
  
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_FACTION_UI", self.onFactionClose, self);
  self:getViewComponent():addEventListener("Open_Ten_Country", self.openTenCountry, self);
  self:getViewComponent():addEventListener("Open_Treasury", self.openTreasury, self);
  self:getViewComponent():addEventListener("Open_Meeting", self.openMeeting, self);
  self:getViewComponent():addEventListener("Open_Shop", self.openShop, self);


  -- self:getViewComponent().shengguanDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self:getViewComponent().jia_tiliDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

  self:getViewComponent().jia_yingliangDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

  self:getViewComponent().yingliang_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self:getViewComponent().tili_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);
  self:getViewComponent().shengwang_bantouDO:addEventListener(DisplayEvents.kTouchBegin,self.onTipsBegin,self);

end
function FactionCurrencyMediator:onTipsBegin(event)
  local targetName = event.target.name
  if targetName ~= "tili_bantou" and targetName ~= "yingliang_bantou" and targetName ~= "shengwang_bantou"  and targetName ~= "shengguan" then
      event.target:setScale(0.88);
  end
  event.target:addEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);
end
function FactionCurrencyMediator:onTipsEnd(event)
  event.target:setScale(1);
  event.target:removeEventListener(DisplayEvents.kTouchEnd,self.onTipsEnd,self);

  local targetName = event.target.name
  print("MainSceneMediator:onTipsEnd",targetName)
  if targetName == "shengguan" then
      -- self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_GUANZHI));
      -- if self:getViewComponent().redDot:isVisible() then
      --   GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] = true
      --   self:getViewComponent().redDot:setVisible(false)
      -- end
  elseif targetName == "jia_yuanbao" then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_RANK_LIST));
  elseif targetName == "yuanbao_bantou" then
      self.smallTip = SmallTip.new();
      event.globalPosition.y = event.globalPosition.y / GameData.gameUIScaleRate
      self.smallTip:initialize("元宝：" .. self.userCurrencyProxy.gold, event.globalPosition);
      self:getViewComponent().parent:addChild(self.smallTip)
  elseif targetName == "jia_yingliang"  then
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI,{showCurrency = false}));
  elseif targetName == "yingliang_bantou" then
      self.smallTip = SmallTip.new();
      event.globalPosition.y = event.globalPosition.y/ GameData.gameUIScaleRate
      self.smallTip:initialize("银两：" .. self.userCurrencyProxy.silver, event.globalPosition);
      self:getViewComponent().parent:addChild(self.smallTip)
  elseif targetName == "jia_tili" then
      self:onAddTili();
  elseif targetName == "tili_bantou" then
      local addTiliUI = AddTiliUI.new();
      addTiliUI:initializeUI(self.userCurrencyProxy, self.countControlProxy);
      sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(addTiliUI);
  elseif targetName == "shengwang_bantou" then
      self.smallTip = SmallTip.new();
      event.globalPosition.y = event.globalPosition.y / GameData.gameUIScaleRate
      self.smallTip:initialize("声望：" .. self.userCurrencyProxy:getPrestige(), event.globalPosition);
      self:getViewComponent().parent:addChild(self.smallTip)
  end
  MusicUtils:playEffect(7,false)
end

function FactionCurrencyMediator:onAddTili()
   onHandleAddTili({type = 1})
end
-- function FactionCurrencyMediator:refreshRedDot()
--   self:getViewComponent():refreshRedDot()
-- end
function FactionCurrencyMediator:setHuobiText()
  self:getViewComponent():setHuobiText()
end
function FactionCurrencyMediator:onFactionClose(event)
  self:sendNotification(FactionNotification.new(FactionNotifications.FACTION_UI_CLOSE));
end

function FactionCurrencyMediator:onRemove()
	self:getViewComponent().parent:removeChild(self:getViewComponent());
end

