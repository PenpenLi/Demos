--[[

]]

require "main.view.strongPointInfo.StrongPointInfoMediator";

OpenStrongPointInfoUICommand=class(Command);

function OpenStrongPointInfoUICommand:ctor()
	self.class=OpenStrongPointInfoUICommand;
end

function OpenStrongPointInfoUICommand:execute(notification)
  self:require();

    self.strongPointInfoMediator=self:retrieveMediator(StrongPointInfoMediator.name);
    if nil==self.strongPointInfoMediator then
      self.strongPointInfoMediator=StrongPointInfoMediator.new();

      self:registerMediator(self.strongPointInfoMediator:getMediatorName(),self.strongPointInfoMediator);

      self.strongPointInfoMediator:initializeUI();

      self:registerStrongPointInfoUI();
    end
    log("notification.data.strongPointId:" .. notification.data.strongPointId)
    -- sendMessage(4, 3, {StrongPointId=notification.data.strongPointId})
    self.strongPointInfoMediator:refreshStrongPointInfo(notification.data.strongPointId);
    self:observe(StrongPointInfoCloseCommand);
    LayerManager:addLayerPopable(self.strongPointInfoMediator:getViewComponent());
    if GameVar.tutorStage ~= TutorConfig.STAGE_99999 and  GameVar.tutorStage ~= TutorConfig.STAGE_1027 then
      openTutorUI({x=1070, y=20, width = 130, height = 144, alpha = 125});
    end
   self:refreshMediator();
end

function OpenStrongPointInfoUICommand:refreshMediator()
  if HeroHousePopupMediator then
    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(false);
    end
  end
  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(false);
    end
  end
end

function OpenStrongPointInfoUICommand:registerStrongPointInfoUI()
  self:registerCommand(ShadowNotifications.CLOSE_STORYLINE_INFO_UI_COMMAND, StrongPointInfoCloseCommand);
end

function OpenStrongPointInfoUICommand:require()

  require "main.model.UserProxy";
  require "main.controller.command.shadow.StrongPointInfoCloseCommand";
end
