TreasuryNotifications = {
				   TREASURY_CLOSE_COMMAND="TREASURY_CLOSE_COMMAND"
				   };

TreasuryNotification=class(Notification);

function TreasuryNotification:ctor(type_string,data)
	self.class = TreasuryNotification;
	self.type = type_string;
  self.data = data;
end

function TreasuryNotification:getData()
  return self.data;
end