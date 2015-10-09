-- LangyalingNotification

LangyalingNotifications={POPUP_UI_LANGYALING = "POPUP_UI_LANGYALING",
                   		 CLOSE_UI_LANGYALING = "CLOSE_UI_LANGYALING"};

LangyalingNotification=class(Notification);

function LangyalingNotification:ctor(type_string, data)
	self.class = LangyalingNotification;
	self.type = type_string;
	self.data=data;
end

function LangyalingNotification:getData()
  return self.data;
end