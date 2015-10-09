

require "main.view.activity.ui.fund.FundPopUp";
require "main.controller.notification.ActivityNotification";

FundMediator=class(Mediator);

function FundMediator:ctor()
  self.class=FundMediator;
  self.viewComponent=FundPopUp.new();
end

rawset(FundMediator,"name","FundMediator");

function FundMediator:initializeUI(skeleton,activityProxy, userCurrencyProxy, userDataAccumulateProxy,userProxy)
  activityProxy.fundMediatorInitCount = activityProxy.fundMediatorInitCount+1;
  self:getViewComponent():initializeUI(skeleton,activityProxy, userCurrencyProxy, userDataAccumulateProxy,userProxy);
  self:getViewComponent():addEventListener(ActivityNotifications.FUND_CLOSE,self.onClose,self);
  self:getViewComponent():addEventListener("OPEN_VIP_UI", self.onOpenVIPUI, self);
  self:getViewComponent():addEventListener("OPEN_RECHARGE_UI", self.onOpenRechargeUI, self);
end

function FundMediator:onClose(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.FUND_CLOSE));
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_ICON_REFRESH));
end

function FundMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function FundMediator:onOpenVIPUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function FundMediator:refresh()
  self:getViewComponent():refresh();
end

function FundMediator:onOpenRechargeUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end