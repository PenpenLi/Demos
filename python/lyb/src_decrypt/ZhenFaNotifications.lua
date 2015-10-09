ZhenFaNotifications={ZHEN_FA="ZhenFa",
                     ZHEN_FA_CLOSE="ZhenFa_close",
  };

ZhenFaNotification=class(Notification);

function ZhenFaNotification:ctor(type_string, data)
	self.class = ZhenFaNotification;
	self.type = type_string;
	self.data = data;
end