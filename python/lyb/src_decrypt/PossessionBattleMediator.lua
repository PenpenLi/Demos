--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-5-2

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.ui.PossessionBattlePopup";

PossessionBattleMediator=class(Mediator);

function PossessionBattleMediator:ctor()
  self.class=PossessionBattleMediator;
	self.viewComponent=PossessionBattlePopup.new();
end

rawset(PossessionBattleMediator,"name","PossessionBattleMediator");

function PossessionBattleMediator:intializeUI(skeleton, possessionBattleProxy, familyProxy, userProxy, effectProxy, battleProxy, resumeData)
  self:getViewComponent():initializeUI(skeleton,possessionBattleProxy,familyProxy,userProxy,effectProxy,battleProxy,resumeData);
end

function PossessionBattleMediator:onUIRegister(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_REGISTER,event.data));
end

function PossessionBattleMediator:onRequestPosData(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_POS_DATA,event.data));
end

function PossessionBattleMediator:onSetPos(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_SET_POS,event.data));
end

function PossessionBattleMediator:onRequestDeployData(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_DEPLOY_DATA,event.data));
end

function PossessionBattleMediator:onDeployConfirm(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_DEPLOY_CONFIRM,event.data));
end

function PossessionBattleMediator:onRequestLast(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_LAST,event.data));
end

function PossessionBattleMediator:onView(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_VIEW,event.data));
end

function PossessionBattleMediator:onClose(event)
  self:sendNotification(PossessionBattleNotification.new(PossessionBattleNotifications.POSSESSION_BATTLE_CLOSE));
end

function PossessionBattleMediator:refreshStage(data)
  self:getViewComponent():refreshStage(data);
end

function PossessionBattleMediator:refreshPosData(data)
  self:getViewComponent():refreshPosData(data);
end

function PossessionBattleMediator:refreshDeploy(data)
  self:getViewComponent():refreshDeploy(data);
end

function PossessionBattleMediator:refreshDeployConfirmed(mapID)
  self:getViewComponent():refreshDeployConfirmed(mapID);
end

function PossessionBattleMediator:refreshProgress()
  self:getViewComponent():refreshProgress();
end

function PossessionBattleMediator:refreshViewData()
  self:getViewComponent():refreshViewData();
end

function PossessionBattleMediator:refreshFamilyNewInfo()
  self:getViewComponent():refreshFamilyNewInfo();
end

function PossessionBattleMediator:refreshSignCount(data)
  self:getViewComponent():refreshSignCount(data);
end

function PossessionBattleMediator:onRegister()
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_REGISTER,self.onUIRegister,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_POS_DATA,self.onRequestPosData,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_SET_POS,self.onSetPos,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_DEPLOY_DATA,self.onRequestDeployData,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_DEPLOY_CONFIRM,self.onDeployConfirm,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_REQUEST_LAST,self.onRequestLast,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_CLOSE,self.onClose,self);
  self:getViewComponent():addEventListener(PossessionBattleNotifications.POSSESSION_BATTLE_VIEW,self.onView,self);
end

function PossessionBattleMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end