YongbingNotifications={YONGBING_CLOSE="yongbingClose"};

YongbingNotification=class(Notification);

function YongbingNotification:ctor(type_string, data)
	self.class = YongbingNotification;
	self.type = type_string;
  	self.data=data;
end

function YongbingNotification:getData()
  return self.data;
end