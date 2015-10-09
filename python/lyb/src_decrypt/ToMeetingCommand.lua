ToMeetingCommand=class(Command);

function ToMeetingCommand:ctor()
	self.class=ToMeetingCommand;
end

function ToMeetingCommand:execute()
  require "main.view.meeting.MeetingMediator";
  require "main.controller.command.meeting.MeetingCloseCommand";
  require "main.controller.notification.MeetingNotification";
  
  local mediator=self:retrieveMediator(MeetingMediator.name);

  if nil==mediator then
    mediator=MeetingMediator.new();
    self:registerMediator(mediator:getMediatorName(),mediator);
    mediator:intializeUI();
    self:registerCommands();
    LayerManager:addLayerPopable(mediator:getViewComponent());
    self:observe(MeetingCloseCommand);
  end

  setFactionCurrencyVisible(true)

  if GameVar.tutorStage == TutorConfig.STAGE_1012 then
    openTutorUI({x=554, y=76, width = 178, height = 62, alpha = 125});
  end

end

function ToMeetingCommand:registerCommands()
  self:registerCommand(MeetingNotifications.MEETING_CLOSE_COMMAND,MeetingCloseCommand);
end