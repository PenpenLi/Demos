MailCheckCommand=class(Command);

function MailCheckCommand:ctor()
	self.class=MailCheckCommand;
end

function MailCheckCommand:execute(notification)
  local data=notification:getData();
  if(connectBoo) then
    sendMessage(23,10);
  end
end