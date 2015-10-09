FirstPayNotifications={FIRST_PAY="FirstPay",
                   FIRST_PAY_CLOSE="FirstPay_CLOSE",
 
      
  };

FirstPayNotification=class(Notification);

function FirstPayNotification:ctor(type_string, data)
	self.class = FirstPayNotification;
	self.type = type_string;
	self.data = data;
end