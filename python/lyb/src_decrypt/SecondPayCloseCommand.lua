SecondPayCloseCommand=class(MacroCommand);

function SecondPayCloseCommand:ctor()
  self.class=SecondPayCloseCommand;
end

function SecondPayCloseCommand:execute(notification)
  self:removeMediator(SecondPayMediator.name);
  self:unobserve(SecondPayCloseCommand);
  self:removeCommand(SecondPayNotifications.SECONDPAY_UI_CLOSE,SecondPayCloseCommand);
end