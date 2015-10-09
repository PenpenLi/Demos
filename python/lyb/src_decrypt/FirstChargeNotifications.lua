--[[

  ]]
FirstChargeNotifications={
                       FIRST_CHARGE_UI_CLOSE="FIRST_CHARGE_UI_CLOSE",
					   PLATFORM_CHARGE_UI_CLOSE="PLATFORM_CHARGE_UI_CLOSE",
					   SEND_PLATFORM_PAY="SEND_PLATFORM_PAY",
  };

FirstChargeNotification=class(Notification);

function FirstChargeNotification:ctor(type_string,m_data)
	self.class = FirstChargeNotification;
	self.type = type_string;
	self.data = m_data;
end