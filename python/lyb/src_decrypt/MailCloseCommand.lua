MailCloseCommand=class(Command);

function MailCloseCommand:ctor()
	self.class=MailCloseCommand;
end

function MailCloseCommand:execute(notification)
  self:removeMediator(MailPopupMediator.name);
  self:removeCommand(MailNotifications.MAIL_CHECK,MailCheckCommand);
  self:removeCommand(MailNotifications.MAIL_READ,MailGetBonusCommand);
  self:removeCommand(MailNotifications.MAIL_GET_BONUS,MailReadCommand);
  self:removeCommand(MailNotifications.MAIL_CLOSE,MailCloseCommand);
end