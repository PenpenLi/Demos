--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroSkill.ui.HeroSkillPopup";

HeroSkillPopupMediator=class(Mediator);

function HeroSkillPopupMediator:ctor()
  self.class=HeroSkillPopupMediator;
	self.viewComponent=HeroSkillPopup.new();
	print("=============================ctor");
end

rawset(HeroSkillPopupMediator,"name","HeroSkillPopupMediator");

function HeroSkillPopupMediator:initializeUI()
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
end


-- function HeroSkillPopupMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end

function HeroSkillPopupMediator:onRegister()
	print("=============================register");
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
end

function HeroSkillPopupMediator:onClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROSKILL_CLOSE));
end

function HeroSkillPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end