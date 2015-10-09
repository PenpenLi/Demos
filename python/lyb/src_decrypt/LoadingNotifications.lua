--[[

  ]]
LoadingNotifications={LOAD_SCENE_COMPLETE="LOAD_SCENE_COMPLETE",
  BEGIN_LOADING_SCENE="BEGIN_LOADING_SCENE1"
  };

LoadingNotification=class(Notification);

function LoadingNotification:ctor(type_string)
	self.class = LoadingNotification;
	self.type = type_string;
end