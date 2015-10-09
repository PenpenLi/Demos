require "main.view.mail.ui.MailPopup";

MailPopupMediator=class(Mediator);

function MailPopupMediator:ctor()
  self.class=MailPopupMediator;
	self.viewComponent=MailPopup.new();
end

rawset(MailPopupMediator,"name","MailPopupMediator");

function MailPopupMediator:refreshMail()
  self:getViewComponent():refreshMail();
end

function MailPopupMediator:refreshMailDelete(idArray)
  self:getViewComponent():refreshMailDelete(idArray);
end

function MailPopupMediator:onMailCheck(event)
  self:sendNotification(MailNotification.new(MailNotifications.MAIL_CHECK, event.data));
end

function MailPopupMediator:onMailRead(event)
  self:sendNotification(MailNotification.new(MailNotifications.MAIL_READ, event.data));
end

function MailPopupMediator:onMailGetBonus(event)
  self:sendNotification(MailNotification.new(MailNotifications.MAIL_GET_BONUS, event.data));
end

function MailPopupMediator:onMailClose(event)
  self:sendNotification(MailNotification.new(MailNotifications.MAIL_CLOSE, event.data));
end

function MailPopupMediator:onRegister()
  self:getViewComponent():addEventListener(MailNotifications.MAIL_CHECK,self.onMailCheck,self);
  self:getViewComponent():addEventListener(MailNotifications.MAIL_READ,self.onMailRead,self);
  self:getViewComponent():addEventListener(MailNotifications.MAIL_GET_BONUS,self.onMailGetBonus,self);
  self:getViewComponent():addEventListener(MailNotifications.MAIL_CLOSE,self.onMailClose,self);

end

function MailPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end