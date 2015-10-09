ZhenFaCloseCommand=class(MacroCommand);

function ZhenFaCloseCommand:ctor()
  self.class=ZhenFaCloseCommand;
end

function ZhenFaCloseCommand:execute(notification)
  self:removeMediator(ZhenFaMediator.name);
  self:unobserve(ZhenFaCloseCommand);
  self:removeCommand(ZhenFaNotifications.ZhenFa_UI_CLOSE,ZhenFaCloseCommand);

end