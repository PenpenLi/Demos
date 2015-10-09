
OpenFunctionNotifications={
                          OPEN_UI_BY_FUNCTION_ID="OPEN_UI_BY_FUNCTION_ID"
                          };

OpenFunctionNotification=class(Notification);

function OpenFunctionNotification:ctor(type_string,data)
	self.class = OpenFunctionNotification;
	self.type = type_string;
  self.data = data;
end