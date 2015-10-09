
TenCountryNotifications={
                          TEN_COUNTRY_CLOSE="TEN_COUNTRY_CLOSE",
                          };

TenCountryNotification=class(Notification);

function TenCountryNotification:ctor(type_string,data)
	self.class = TenCountryNotification;
	self.type = type_string;
  self.data = data;
end