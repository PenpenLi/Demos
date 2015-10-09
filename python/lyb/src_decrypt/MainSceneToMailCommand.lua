require "main.view.mail.MailPopupMediator";

MainSceneToMailCommand=class(Command);

function MainSceneToMailCommand:ctor()
	self.class=MainSceneToMailCommand;
end

function MainSceneToMailCommand:execute()
  self:require();
  --MailPopupMediator
  self.mailPopupMediator=self:retrieveMediator(MailPopupMediator.name);
  if self.mailPopupMediator then
    return;
  end
  if nil==self.mailPopupMediator then
    self.mailPopupMediator=MailPopupMediator.new();
    self:registerMediator(self.mailPopupMediator:getMediatorName(),self.mailPopupMediator);
    self:registerCommands();
  end
  LayerManager:addLayerPopable(self.mailPopupMediator:getViewComponent());
end

function MainSceneToMailCommand:registerCommands()
  self:registerCommand(MailNotifications.MAIL_CHECK,MailCheckCommand);
  self:registerCommand(MailNotifications.MAIL_READ,MailReadCommand);
  self:registerCommand(MailNotifications.MAIL_GET_BONUS,MailGetBonusCommand);
  self:registerCommand(MailNotifications.MAIL_CLOSE,MailCloseCommand);
end

function MainSceneToMailCommand:require()
  require "main.controller.command.mail.MailCheckCommand";
  require "main.controller.command.mail.MailGetBonusCommand";
  require "main.controller.command.mail.MailReadCommand";
  require "main.controller.command.mail.MailCloseCommand";
  require "main.controller.notification.MailNotification";
end