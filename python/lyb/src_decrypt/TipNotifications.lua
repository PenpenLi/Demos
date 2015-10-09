
TipNotifications={
				  OPEN_TIP_COMMOND="OPEN_TIP_COMMOND",
                  REMOVE_TIP_COMMOND="REMOVE_TIP_COMMOND"
                  };

TipNotification=class(Notification);

function TipNotification:ctor(type_string,data)
	self.class = TipNotification;
	self.type = type_string;
  self.data = data;
end