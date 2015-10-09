MailNotifications={MAIL_CHECK="mailCheck",
				   MAIL_READ="mailRead",
				   MAIL_GET_BONUS="mailGetBonus",
                   MAIL_CLOSE="mailClose"};

MailNotification=class(Notification);

function MailNotification:ctor(type_string, data)
	self.class = MailNotification;
	self.type = type_string;
  self.data=data;
end

function MailNotification:getData()
  return self.data;
end