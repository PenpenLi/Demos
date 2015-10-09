require "main.view.faction.ui.FactionPopup";

FactionMediator=class(Mediator);

function FactionMediator:ctor()
  self.class = FactionMediator;
	self.viewComponent=FactionPopup.new();
end

rawset(FactionMediator,"name","FactionMediator");

function FactionMediator:initializeUI()
  self:getViewComponent():initializeUI();
end

function FactionMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_FACTION_UI", self.onFactionClose, self);
  self:getViewComponent():addEventListener("Open_Ten_Country", self.openTenCountry, self);
  self:getViewComponent():addEventListener("Open_Treasury", self.openTreasury, self);
  self:getViewComponent():addEventListener("Open_Meeting", self.openMeeting, self);
  self:getViewComponent():addEventListener("Open_Shop", self.openShop, self);


  local proxyRetriever  = ProxyRetriever.new();

  self.openFunctionProxy=proxyRetriever:retrieveProxy(OpenFunctionProxy.name);

end

function FactionMediator:openTreasury()

  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_33) then
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_GUANZHI));
  else
    sharedTextAnimateReward():animateStartByString("功能尚未开启");
  end
     
  if self:getViewComponent().redDot3:isVisible() then
    GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] = true
    self:getViewComponent().redDot3:setVisible(false)
  end  


  -- if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_36) then
  --   self:sendNotification(FactionNotification.new(FactionNotifications.TO_TREASURY_COMMAND));

  --   if self:getViewComponent().redDot3:isVisible() then
  --     GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_36] = true
  --     self:getViewComponent().redDot3:setVisible(false)
  --     self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_36}));    
  --   end
  -- else
  --   sharedTextAnimateReward():animateStartByString("功能尚未开启");
  -- end 
end
function FactionMediator:openShop()
  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_37) then
    self:sendNotification(FactionNotification.new(FactionNotifications.TO_SHOP_COMMAND, {Type = 1}));
  else
    sharedTextAnimateReward():animateStartByString("功能尚未开启");
  end
end
function FactionMediator:openMeeting()
  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_35) then
    self:sendNotification(FactionNotification.new(FactionNotifications.TO_MEETING_COMMAND));

    if self:getViewComponent().redDot2:isVisible() then
      GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_35] = true
      self:getViewComponent().redDot2:setVisible(false)
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_35}));    
    end 
  else
    sharedTextAnimateReward():animateStartByString("功能尚未开启");
  end 
end

function FactionMediator:openTenCountry()
  if self.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_34) then
  	self:sendNotification(FactionNotification.new(FactionNotifications.TO_TEN_COUNTRY));
    if self:getViewComponent().redDot1:isVisible() then
      GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_34] = true
      self:getViewComponent().redDot1:setVisible(false)
      self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REFRESH_REDDOT,{type=FunctionConfig.FUNCTION_ID_34}));    
    end  
  else
    sharedTextAnimateReward():animateStartByString("功能尚未开启");
  end
end

function FactionMediator:onFactionClose(event)
  self:sendNotification(FactionNotification.new(FactionNotifications.FACTION_UI_CLOSE));
end

function FactionMediator:onRemove()
	self:getViewComponent().parent:removeChild(self:getViewComponent());
end

