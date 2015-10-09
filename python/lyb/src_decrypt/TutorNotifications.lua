--[[

  ]]
TutorNotifications={TUTOR_UI_CLOSE="TUTOR_UI_CLOSE",
                     TUTOR_BATTLE="TUTOR_BATTLE",
                     REMOVE_TUTOR_UI="REMOVE_TUTOR_UI"
  };

TutorNotification=class(Notification);

function TutorNotification:ctor(type_string)
	self.class = TutorNotification;
	self.type = type_string;
end