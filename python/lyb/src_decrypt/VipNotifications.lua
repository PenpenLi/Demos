

VipNotifications={
				   VIP_CLOSE_COMMAND = "VIP_CLOSE_COMMAND",
				   TO_PLATFORM_PAY = "TO_PLATFORM_PAY",
				   };

VipNotification=class(Notification);

function VipNotification:ctor(type_string,data)
	self.class = VipNotification;
	self.type = type_string;
  self.data = data;
end

function VipNotification:getData()
  return self.data;
end