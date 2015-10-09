BangDingCloseCommand=class(MacroCommand);

function BangDingCloseCommand:ctor()
  self.class=BangDingCloseCommand;
end

function BangDingCloseCommand:execute(notification)
  self:removeMediator(BangDingMediator.name);
  self:unobserve(BangDingCloseCommand);
  self:removeCommand(BangDingNotifications.BangDing_UI_CLOSE,BangDingCloseCommand);

end