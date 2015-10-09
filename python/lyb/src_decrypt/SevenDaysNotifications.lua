SevenDaysNotifications = {
	OPEN_SEVENDAYS_UI = "OPEN_SEVENDAYS_UI",
	CLOSE_SEVENDAYS_UI = "CLOSE_SEVENDAYS_UI"
};
SevenDaysNotification = class(Notification);

function SevenDaysNotifications:ctor( type_string, data )
	self.class = SevenDaysNotification;
	self.type = type_string;
	self.data = data;
end