

CreateSceneNotifications={
                      CREATE_CLOSE="createClose",
                      ROLENAME_CLOSE = "ROLENAME_CLOSE"
                      };

CreateSceneNotification=class(Notification);

function CreateSceneNotification:ctor(type_string, data)
	self.class = CreateSceneNotification;
	self.type = type_string;
  self.data=data;
end

function CreateSceneNotification:getData()
  return self.data;
end