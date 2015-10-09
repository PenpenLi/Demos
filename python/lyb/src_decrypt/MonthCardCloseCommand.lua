MonthCardCloseCommand=class(MacroCommand);

function MonthCardCloseCommand:ctor()
  self.class=MonthCardCloseCommand;
end

function MonthCardCloseCommand:execute(notification)
  self:removeMediator(MonthCardMediator.name);
  self:unobserve(MonthCardCloseCommand);
  self:removeCommand(MonthCardNotifications.MonthCard_UI_CLOSE,MonthCardCloseCommand);

end