YongbingCloseCommand=class(Command);

function YongbingCloseCommand:ctor()
	self.class=YongbingCloseCommand;
end

function YongbingCloseCommand:execute(notification)
  self:removeMediator(YongbingMediator.name);
  self:removeCommand(YongbingNotifications.YONGBING_CLOSE,YongbingCloseCommand);
  -- self:checkFactionCurrencyClose();
end

function YongbingCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end