require "main.view.hero.heroTeam.PeibingPopup";

HeroTeamSubMediator=class(Mediator);

function HeroTeamSubMediator:ctor()
  self.class=HeroTeamSubMediator;
	self.viewComponent=PeibingPopup.new();
end

rawset(HeroTeamSubMediator,"name","HeroTeamSubMediator");

function HeroTeamSubMediator:initializeUI(data)
  -- self.bagProxy = bagProxy;
 --  self:getViewComponent():initializeStrengthenUI();
	-- uninitializeSmallLoading()
  self.viewComponent:setNotificationData(data);
end


function HeroTeamSubMediator:setData()
  self:getViewComponent():setData();
end

function HeroTeamSubMediator:onRegister()
	-- self:getViewComponent():initialize();
	--监听消息执行
  -- self:getViewComponent():addEventListener("onDegrade",self.onDegrade,self);
  -- self:getViewComponent():addEventListener(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,self.toShop,self);
  self:getViewComponent():addEventListener("closeNotice", self.onClose, self);
  self:getViewComponent():addEventListener("jonWar", self.onJoinWar, self);
  self:getViewComponent():addEventListener("quitWar", self.onQuitWar, self);
end

function HeroTeamSubMediator:onClose(event)
  -- self:onRemove()
  self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROTEAMSUB_CLOSE));
end

function HeroTeamSubMediator:onJoinWar(event)
	self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROHOUSE_JOINWAR,event.data));
end

function HeroTeamSubMediator:onQuitWar(event)
	self:sendNotification(HeroHouseNotification.new(HeroHouseNotifications.HEROHOUSE_QUITWAR,event.data));
end


function HeroTeamSubMediator:onRemove()
  print("]]]]]]]]]]]]]]]]==============onRemove()");
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end