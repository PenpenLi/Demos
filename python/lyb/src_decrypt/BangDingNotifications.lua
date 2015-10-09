BangDingNotifications={BANG_DING="Bang_Ding",
                   BANG_DING_CLOSE="Bang_Ding_CLOSE",
 
      
  };

BangDingNotification=class(Notification);

function BangDingNotification:ctor(type_string, data)
	self.class = BangDingNotification;
	self.type = type_string;
	self.data = data;
end