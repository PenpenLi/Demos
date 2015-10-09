
CloseSevenDaysUICommand = class(MacroCommand);

function CloseSevenDaysUICommand:ctor(  )
	self.class = CloseSevenDaysUICommand;
end

function CloseSevenDaysUICommand:execute(notification)
	self:removeMediator(SevenDaysMediator.name);
	self:unobserve(CloseSevenDaysUICommand);
	self:removeCommand(SevenDaysNotifications.CLOSE_SEVENDAYS_UI, CloseSevenDaysUICommand);

	  -- self:removeMediator(HuoDongMediator.name);

end
