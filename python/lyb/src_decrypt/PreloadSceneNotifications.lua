--[[
  preload notificaiton 
  @zhangke
  ]]
PreloadSceneNotifications={INIT_COMMANDS="INIT_COMMANDS",
						   LOAD_COMMAND="LOAD_COMMAND",
						   SERVER_COMMAND="SERVER_COMMAND",
						   SCENE_CLOSE_COMMAND="SCENE_CLOSE_COMMAND",
                           };

PreloadSceneNotification=class(Notification);

function PreloadSceneNotification:ctor(type_string,data)
	self.class = PreloadSceneNotification;
	self.type = type_string;
	self.data = data
end