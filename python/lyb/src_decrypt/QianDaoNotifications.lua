QianDaoNotifications={OPEN_QIANDAO_UI="OPEN_QIANDAO_UI",
                   QIANDAO_UI_CLOSE="QIANDAOUI_CLOSE",
 
      
  };

QianDaoNotification=class(Notification);

function QianDaoNotification:ctor(type_string, data)
	self.class = QianDaoNotification;
	self.type = type_string;
	self.data = data;
end