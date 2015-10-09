

require "main.view.activity.ui.limitedSummonHero.LimitedSummonHeroPopUp";
require "main.controller.notification.ActivityNotification";

LimitedSummonHeroMediator=class(Mediator);

function LimitedSummonHeroMediator:ctor()
  self.class=LimitedSummonHeroMediator;
  self.viewComponent=LimitedSummonHeroPopUp.new();
end

rawset(LimitedSummonHeroMediator,"name","LimitedSummonHeroMediator");

function LimitedSummonHeroMediator:initializeUI(skeleton,activityProxy,userCurrencyProxy,bagProxy,summonHeroProxy,heroBankProxy,userProxy)
  self.activityProxy = activityProxy;
  self:getViewComponent():initializeUI(skeleton,activityProxy,userCurrencyProxy,bagProxy,summonHeroProxy,heroBankProxy,userProxy);
  self:getViewComponent():addEventListener("LimitedSummonHero_CLOSE",self.onClose,self);
  self:getViewComponent():addEventListener("OPEN_VIP_UI", self.onOpenVIPUI, self);
  self:getViewComponent():addEventListener("OPEN_RECHARGE_UI", self.onOpenRechargeUI, self);
  self:getViewComponent():addEventListener("QUERY_HERO",self.queryHero,self);
  self:getViewComponent():addEventListener("JUMP_TO_HERO_BANK",self.onJumpToHeroBank,self);
end

function LimitedSummonHeroMediator:onClose(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.LIMITED_SUMMON_HERO_CLOSE));
end

function LimitedSummonHeroMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function LimitedSummonHeroMediator:onOpenVIPUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function LimitedSummonHeroMediator:refresh()
  self:getViewComponent():refresh();
end

function LimitedSummonHeroMediator:drawResult()
  self:getViewComponent():drawResult();
end


function LimitedSummonHeroMediator:onOpenRechargeUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end

function LimitedSummonHeroMediator:onJumpToHeroBank(event)
  local sendTable = {ID = FunctionConfig.FUNCTION_ID_29}
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,sendTable));
end

function LimitedSummonHeroMediator:queryHero()
  print("OK:",self.activityProxy.limitedSummonHeroData.GeneralEmployInfoArray[1].ConfigId)

  self:sendNotification(HeroBankNotification.new(HeroBankNotifications.HERO_TIPS_COMMAND,self.activityProxy.limitedSummonHeroData.GeneralEmployInfoArray[1].ConfigId));
end