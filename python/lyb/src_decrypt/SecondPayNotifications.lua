SecondPayNotifications={SECOND_PAY="SecondPay",
                   		SECOND_PAY_CLOSE="SecondPay_CLOSE",
};

SecondPayNotification=class(Notification);

function SecondPayNotification:ctor(type_string, data)
	self.class = SecondPayNotification;
	self.type = type_string;
	self.data = data;
end