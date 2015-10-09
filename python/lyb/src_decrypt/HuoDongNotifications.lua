HuoDongNotifications={OPEN_HUODONG_UI="OPEN_HUODONG_UI",
                   HUODONG_UI_CLOSE="HUODONGUI_CLOSE",
 
      
  };

HuoDongNotification=class(Notification);

function HuoDongNotification:ctor(type_string, data)
	self.class = HuoDongNotification;
	self.type = type_string;
	self.data = data;
end