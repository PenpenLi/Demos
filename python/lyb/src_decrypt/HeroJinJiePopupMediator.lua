--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroJinJie.ui.HeroJinJiePopup";

HeroJinJiePopupMediator=class(Mediator);

function HeroJinJiePopupMediator:ctor()
  self.class=HeroJinJiePopupMediator;
	self.viewComponent=HeroJinJiePopup.new();
	print("=============================ctor");
end

rawset(HeroJinJiePopupMediator,"name","HeroJinJiePopupMediator");

function HeroJinJiePopupMediator:initializeUI()
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
end


-- function HeroJinJiePopupMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end

function HeroJinJiePopupMediator:onRegister()
	print("=============================register");
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
end

function HeroJinJiePopupMediator:onClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROJINJIE_CLOSE));
end

function HeroJinJiePopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end