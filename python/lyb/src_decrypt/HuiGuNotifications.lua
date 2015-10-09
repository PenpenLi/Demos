HuiGuNotifications={
					TO_HUIGU_COMMAND = "TO_HUIGU_COMMAND",
					HUIGU_CLOSE_COMMAND = "HUIGU_CLOSE_COMMAND",
				   };
HuiGuNotification=class(Notification);

function HuiGuNotification:ctor(type_string,data)
	self.class = HuiGuNotification;
	self.type = type_string;
  self.data = data;
end

function HuiGuNotification:getData()
  return self.data;
end