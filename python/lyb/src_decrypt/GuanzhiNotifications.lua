GuanzhiNotifications={GUANZHI_CLOSE="guanzhiClose"};

GuanzhiNotification=class(Notification);

function GuanzhiNotification:ctor(type_string, data)
	self.class = GuanzhiNotification;
	self.type = type_string;
  	self.data=data;
end

function GuanzhiNotification:getData()
  return self.data;
end