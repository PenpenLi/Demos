require "main.view.trackItem.ui.TrackItemUI";

TrackItemMediator = class(Mediator)

function TrackItemMediator:ctor()
	self.class = TrackItemMediator
end

rawset(TrackItemMediator,"name","TrackItemMediator")

function TrackItemMediator:onRegister()
	self.viewComponent = TrackItemUI.new()
	self.viewComponent:initialize();
	self.viewComponent:addEventListener("CLOSE_TRACK_ITEM", self.onClose, self)
	self.viewComponent:addEventListener("ON_STRONGPOINT_TAP", self.onStrongPointTap, self)
	self.viewComponent:addEventListener("ON_SHADOW_TAP", self.onShadowTap, self)
	self.viewComponent:addEventListener("ON_SHOP_TAP", self.onShopTap, self)
  self.viewComponent:addEventListener("ON_XUNBAO_TAP", self.onXunBaoTap, self)
  self.viewComponent:addEventListener("ON_ZHAOHUAN_TAP", self.onZhuanHuaTap, self)
  self.viewComponent:addEventListener("ON_TENCOUNTRY_TAP", self.onTenCountryTap, self)
  self.viewComponent:addEventListener("ON_SHILIAN_TAP", self.onShiLianTap,self);
  self.viewComponent:addEventListener("ON_RICHANG_TAP", self.onRiChangTap,self);

end
function TrackItemMediator:refreshData(data)
  self.viewComponent:refreshData(data);
end

function TrackItemMediator:setBaojiEffect(type)
	self.viewComponent:setBaojiEffect(type)
end

function TrackItemMediator:onStrongPointTap(event)
  local curItemCount = self.viewComponent.bagProxy:getItemNum(1015003);
  print("onStrongPointTap");
  self.viewComponent:closeUI()
  local strongPointState = self.viewComponent.storyLineProxy.lastStrongPointState
  if event.data.strongPointId == self.viewComponent.storyLineProxy.lastStrongPointId and (GameConfig.STRONG_POINT_STATE_3 == strongPointState or GameConfig.STRONG_POINT_STATE_4 == strongPointState) then
    if (GameConfig.STRONG_POINT_STATE_4 == strongPointState) then
      local msg = {StrongPointId = event.data.strongPointId};
      sendMessage(4,2,msg); 
    end
    self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_STRONGPOINT_INFO_UI_COMMAND, event.data));
  elseif event.data.quickBattle and curItemCount > 0 then
    local Count = self.viewComponent.storyLineProxy:getStrongPointFinishCount(event.data.strongPointId)
    self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, {StrongPointId =event.data.strongPointId, Count = Count}));
  else
    self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_STRONGPOINT_INFO_UI_COMMAND, event.data));
  end
  self:onJumpClose();
end

function TrackItemMediator:onShadowTap(event)
  self.viewComponent:closeUI()
  
  local curItemCount = self.viewComponent.bagProxy:getItemNum(1015003);
  local strongPointId = event.data.strongPointId
  local heroId = analysis("Juqing_Yingxiongzhi",strongPointId, "heroId")
  print("onShadowTap, heroId", heroId);

  if event.data.quickBattle and curItemCount > 0 then
    local Count = self.viewComponent.storyLineProxy:getStrongPointFinishCount(event.data.strongPointId)
    self:sendNotification(StrongPointInfoNotification.new(StrongPointInfoNotifications.OPEN_QUICK_BATTLE_UI_COMMOND, {StrongPointId =event.data.strongPointId, Count = Count}));
  else
    self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, {heroId = heroId}));
  end
  self:onJumpClose();
end
function TrackItemMediator:onXunBaoTap(event)
  if self.viewComponent.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_44) then
    self.viewComponent:closeUI()
    sendMessage(8,6);
    self:onJumpClose();
  else
    sharedTextAnimateReward():animateStartByString("此功能尚未开启~");
  end
end
function TrackItemMediator:onZhuanHuaTap(event)
  self.viewComponent:closeUI()
  self:sendNotification(LangyalingNotification.new(LangyalingNotifications.POPUP_UI_LANGYALING, event.data));
  self:onJumpClose();
end
function TrackItemMediator:onTenCountryTap(event)
  print("onTenCountryTap")
  self.viewComponent:closeUI()
  setFactionCurrencyVisible(true)
  self:sendNotification(FactionNotification.new(FactionNotifications.TO_TEN_COUNTRY));
  self:onJumpClose();
end
function TrackItemMediator:onShiLianTap(event)
  self.viewComponent:closeUI()
  self:sendNotification(FactionNotification.new(FactionNotifications.TO_TREASURY_COMMAND));
  self:onJumpClose();
end
function TrackItemMediator:onRiChangTap(event)
  self.viewComponent:closeUI()
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TASK));    
  self:onJumpClose();
end


function TrackItemMediator:onShopTap(event)
  self.viewComponent:closeUI()
  local data = event.data;
  if data.type == 5 then--论剑商城
    print("to buy itemId is data.value", data.value)
    if self.viewComponent.openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_26) then
      self:sendNotification(ShopTwoNotification.new(ShopTwoNotifications.OPEN_SHOPTWO_UI, {shopType = 4, itemId = data.value}));
        self.currencyGroupMediator=Facade.getInstance():retrieveMediator(CurrencyGroupMediator.name);
    else
      sharedTextAnimateReward():animateStartByString("此功能尚未开启~");
    end
  elseif data.type == 6 then--帮派商店
    if self.viewComponent.userProxy.familyId ~= 0 then--todo
      self:sendNotification(FactionNotification.new(FactionNotifications.TO_SHOP_COMMAND, {Type = 2, itemId = data.value}));
    else
      sharedTextAnimateReward():animateStartByString("暂无帮派~");
    end
  elseif data.type == 7 then--皇城宝库
    print("to buy itemId is data.value", data.value)
  	self:sendNotification(FactionNotification.new(FactionNotifications.TO_SHOP_COMMAND, {Type = 1, itemId = data.value}));
  end
  print("data.type", data.type);
  self:onJumpClose();
end
function TrackItemMediator:onJumpClose()
  self:onClose();
end

function TrackItemMediator:onClose(event)
  if self.currencyGroupMediator then
    self.currencyGroupMediator:refreshAreaRongYu()
    self.currencyGroupMediator.viewComponent:setVisible(true)
    print("self.currencyGroupMediator:refreshAreaRongYu()")
  end
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.CLOSE_TRACK_ITEM_UI_COMMAND));
end

function TrackItemMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
