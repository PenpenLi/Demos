FirstPayCloseCommand=class(MacroCommand);

function FirstPayCloseCommand:ctor()
  self.class=FirstPayCloseCommand;
end

function FirstPayCloseCommand:execute(notification)
  self:removeMediator(FirstPayMediator.name);
  self:unobserve(FirstPayCloseCommand);
  self:removeCommand(FirstPayNotifications.FirstPay_UI_CLOSE,FirstPayCloseCommand);

end