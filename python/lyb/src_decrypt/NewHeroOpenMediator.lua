require "main.view.shadow.ui.NewHeroOpen";

NewHeroOpenMediator=class(Mediator);

function NewHeroOpenMediator:ctor()
  self.class = NewHeroOpenMediator;
	self.viewComponent = NewHeroOpen.new();
end

rawset(NewHeroOpenMediator,"name","NewHeroOpenMediator");

function NewHeroOpenMediator:initializeUI(strongPointId)
  self:getViewComponent():initializeUI(strongPointId);
end

function NewHeroOpenMediator:onRegister()
  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("ON_GOTO_HERO", self.onGotoHero, self);
  self:getViewComponent():addEventListener("ON_CLOSE_UI", self.onCloseUI, self);
end

function NewHeroOpenMediator:onCloseUI()
  self:sendNotification(ShadowNotification.new(ShadowNotifications.CLOSE_NEW_HERO_OPEN_COMMAND));
end

function NewHeroOpenMediator:onGotoHero(event)
  self:getViewComponent():closeUI()
  OpenHeroImageUICommand.new():execute(ShadowNotification.new(ShadowNotifications.OPEN_HEROIMAGE_UI_COMMAND, {strongPointId = event.data.strongPointId,unvisibleMenu = true,showNewHeroEffect=true}))
end

function NewHeroOpenMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
