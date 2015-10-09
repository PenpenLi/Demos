--[[

  ]]
GameInitNotifications={GAME_INIT="GAME_INIT",
  };

GameInitNotification=class(Notification);

function GameInitNotification:ctor(type_string)
	self.class = GameInitNotification;
	self.type = type_string;
end