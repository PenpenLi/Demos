MeetingCloseCommand=class(Command);

function MeetingCloseCommand:ctor()
	self.class=MeetingCloseCommand;
end

function MeetingCloseCommand:execute(notification)
	print("ssssssss")
  self:removeMediator(MeetingMediator.name);
  self:unobserve(MeetingCloseCommand);

  self:checkFactionCurrencyClose();

end
function MeetingCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end