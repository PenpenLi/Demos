--
ShadowNotifications={
						 OPEN_HEROIMAGE_UI_COMMAND= "OPEN_HEROIMAGE_UI_COMMAND",
						 CLOSE_HEROIMAGE_UI_COMMAND= "CLOSE_HEROIMAGE_UI_COMMAND",
						 OPEN_STRONGPOINT_INFO_UI_COMMAND= "OPEN_STRONGPOINT_INFO_UI_COMMAND",
						 CLOSE_STORYLINE_INFO_UI_COMMAND= "CLOSE_STORYLINE_INFO_UI_COMMAND",
						 CLOSE_NEW_HERO_OPEN_COMMAND= "CLOSE_NEW_HERO_OPEN_COMMAND"
  };

ShadowNotification=class(Notification);

function ShadowNotification:ctor(type_string)
	self.class = ShadowNotification;
	self.type = type_string;
end