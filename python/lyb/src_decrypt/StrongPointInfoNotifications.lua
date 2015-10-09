
StrongPointInfoNotifications={
						  OPEN_STORYLINE_UI_COMMOND="OPEN_STORYLINE_UI_COMMOND",
						  CLOSE_STORYLINE_UI_COMMOND="CLOSE_STORYLINE_UI_COMMOND",
                          OPEN_QUICK_BATTLE_UI_COMMOND="OPEN_QUICK_BATTLE_UI_COMMOND",
                          CLOSE_QUICK_BATTLE_UI_COMMOND="CLOSE_QUICK_BATTLE_UI_COMMOND" 
                          };

StrongPointInfoNotification=class(Notification);

function StrongPointInfoNotification:ctor(type_string,data)
	self.class = StrongPointInfoNotification;
	self.type = type_string;
  self.data = data;
end