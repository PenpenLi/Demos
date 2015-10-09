--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-18

]]

require "main.view.hero.heroHouse.ui.HeroHousePopup";

HeroHousePopupMediator=class(Mediator);

function HeroHousePopupMediator:ctor()
  self.class=HeroHousePopupMediator;
	self.viewComponent=HeroHousePopup.new();
	print("=============================ctor");
end

rawset(HeroHousePopupMediator,"name","HeroHousePopupMediator");

function HeroHousePopupMediator:initializeUI()
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()\

  -- self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROHOUSE_INIT));
end

function HeroHousePopupMediator:setData()
  
  self:getViewComponent():setData();
end;

-- function HeroHousePopupMediator:refreshStuffByBags()
--   self:getViewComponent():refreshStuffByBags();
-- end

function HeroHousePopupMediator:onRegister()
	print("=============================register");
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
  self:getViewComponent():addEventListener("openProNotice", self.onOpenPro, self);
  self:getViewComponent():addEventListener(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND, self.onTrack, self);
end

function HeroHousePopupMediator:onClose(event)
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROHOUSE_CLOSE));
end
function HeroHousePopupMediator:onOpenPro(event)
	local items = event.data;
	self:sendNotification(HeroHouseNotification.new(MainSceneNotifications.TO_HEROPRO,items));
	--self:onClose();
	-- print("??????????????");
end

function HeroHousePopupMediator:onTrack(event)
	   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_TRACK_ITEM_UI_COMMAND,event.data));
end

function HeroHousePopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());

  end
end

function HeroHousePopupMediator:setCurrentPage(page)
  self:getViewComponent():setCurrentPage(page);
end