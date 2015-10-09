--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroChangeEquipe.ui.HeroChangeEquipePopup";

HeroChangeEquipeMediator=class(Mediator);

function HeroChangeEquipeMediator:ctor()
  self.class=HeroChangeEquipeMediator;
	self.viewComponent=HeroChangeEquipePopup.new();
	print("=============================ctor");
end

rawset(HeroChangeEquipeMediator,"name","HeroChangeEquipeMediator");

function HeroChangeEquipeMediator:initializeUI()
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
end


-- function HeroChangeEquipeMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end

function HeroChangeEquipeMediator:onRegister()
	print("=============================register");
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
end

function HeroChangeEquipeMediator:onClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROChangeEquipe_CLOSE));
end

function HeroChangeEquipeMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end