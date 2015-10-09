--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.activity.ui.amassFortunes.AmassFortunesLayer";

AmassFortunesMediator=class(Mediator);

function AmassFortunesMediator:ctor()
  self.class=AmassFortunesMediator;
  self.viewComponent=AmassFortunesLayer.new();
end

rawset(AmassFortunesMediator,"name","AmassFortunesMediator");

function AmassFortunesMediator:intializeUI(skeleton,activityProxy, userCurrencyProxy, userDataAccumulateProxy)
  self:getViewComponent():initializeUI(skeleton,activityProxy, userCurrencyProxy, userDataAccumulateProxy);
  self:getViewComponent():addEventListener(ActivityNotifications.AMASS_FORTUNES_CLOSE,self.onClose,self);
  self:getViewComponent():addEventListener(ActivityNotifications.AMASS_FORTUNES_REQUEST_DATA, self.onAmassFortuneRequestData, self);
  self:getViewComponent():addEventListener(MainSceneNotifications.MAIN_SCENE_TO_ICON_REFRESH, self.onMainIconRefresh, self);
  self:getViewComponent():addEventListener("OPEN_RECHARGE_UI", self.onOpenRechargeUI, self);
end

function AmassFortunesMediator:onClose(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.AMASS_FORTUNES_CLOSE));
end

function AmassFortunesMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
------------------------------------------------招财进宝--------------------------------------------------------------
function AmassFortunesMediator:onAmassFortuneRequestData(event)
  self:sendNotification(ActivityNotification.new(ActivityNotifications.AMASS_FORTUNES_REQUEST_DATA, event.data));
end
function AmassFortunesMediator:onMainIconRefresh(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.MAIN_SCENE_TO_ICON_REFRESH));
end
function AmassFortunesMediator:refreshAmassFortuneData(gold)
  self:getViewComponent():refreshData(gold)
end
function AmassFortunesMediator:refreshAmassFortunesCount(count)
  self:getViewComponent():refreshAmassFortunesCount(count)
end

-- function AmassFortunesMediator:refreshOtherAmassFortune(gold)
--   self:getViewComponent():refreshOtherPlayer(gold);
-- end


function AmassFortunesMediator:onOpenRechargeUI(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND));
end