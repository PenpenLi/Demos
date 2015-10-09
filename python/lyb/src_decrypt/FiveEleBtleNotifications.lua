FiveEleBtleNotifications={
					TO_FIVEELEBTLE_COMMAND = "TO_FIVEELEBTLE_COMMAND",
					FIVEELEBTLE_CLOSE_COMMAND = "FIVEELEBTLE_CLOSE_COMMAND",
				   };
FiveEleBtleNotification=class(Notification);

function FiveEleBtleNotification:ctor(type_string,data)
	self.class = FiveEleBtleNotification;
	self.type = type_string;
  self.data = data;
end

function FiveEleBtleNotification:getData()
  return self.data;
end