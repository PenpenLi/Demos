--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroTeam.ui.HeroTeamMainPopup";

HeroTeamMainMediator=class(Mediator);

function HeroTeamMainMediator:ctor()
  self.class=HeroTeamMainMediator;
	self.viewComponent=HeroTeamMainPopup.new();
	print("=============================ctor");
end

rawset(HeroTeamMainMediator,"name","HeroTeamMainMediator");

function HeroTeamMainMediator:initializeUI()
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
end


-- function HeroTeamMainMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end

function HeroTeamMainMediator:onRegister()
	print("=============================register");
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
  self:getViewComponent():addEventListener("openSubNotice", self.openSubNotice, self);
end
function HeroTeamMainMediator:openSubNotice(event)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB));
	self:onClose();
end
function HeroTeamMainMediator:onClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROTEAMMAIN_CLOSE));
end

function HeroTeamMainMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end