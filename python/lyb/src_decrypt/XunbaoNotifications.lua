XunbaoNotifications={OPEN_XUNBAO="OPEN_XUNBAO",
                     CLOSE_XUNBAO="CLOSE_XUNBAO",
  };

XunbaoNotification=class(Notification);

function XunbaoNotification:ctor(type_string, data)
	self.class = XunbaoNotification;
	self.type = type_string;
	self.data = data;
end