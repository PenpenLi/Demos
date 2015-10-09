require "main.view.xunbao.ui.XunbaoPopup";
XunbaoMediator=class(Mediator);

function XunbaoMediator:ctor()
  self.class = XunbaoMediator;
  
end

rawset(XunbaoMediator,"name","XunbaoMediator");

function XunbaoMediator:initialize()
    self.viewComponent = XunbaoPopup.new();
    self:getViewComponent():initialize();
end

function XunbaoMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("CLOSE_XUNBAO", self.onXunbaoClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self)  
  self:getViewComponent():addEventListener("TO_STRONGPOINT", self.onToStrongPoint, self)
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.onToHeroTeam, self);
  self:getViewComponent():addEventListener("TO_VIP",self.onToVip,self);
  self:getViewComponent():addEventListener("TO_DIANJINSHOU",self.onToDianjinshou,self);  
end

function XunbaoMediator:onToDianjinshou(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI, {showCurrency = false}));
end

function XunbaoMediator:onToStrongPoint(event)
  self:sendNotification(ShadowNotification.new(ShadowNotifications.OPEN_STRONGPOINT_INFO_UI_COMMAND, {strongPointId=event.data.strongPointId}));
end

function XunbaoMediator:onToVip(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function XunbaoMediator:onToHeroTeam(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function XunbaoMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function XunbaoMediator:onXunbaoClose(event)
  require "main.controller.notification.XunbaoNotification";
  self:sendNotification(XunbaoNotification.new(XunbaoNotifications.CLOSE_XUNBAO));
end

function XunbaoMediator:refreshData()
  self:getViewComponent():refreshData()
end

function XunbaoMediator:refreshRoll(rollCount)
  self:getViewComponent():rollUI(rollCount)
end

function XunbaoMediator:stopRolling()
  self:getViewComponent():stopRolling()
end

function XunbaoMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
