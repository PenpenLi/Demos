

RoleNameCloseCommand=class(Command);

function RoleNameCloseCommand:ctor()
	self.class=RoleNameCloseCommand;
end

function RoleNameCloseCommand:execute(notification)
  self:removeMediator(RoleNameMediator.name);
  self:removeCommand(CreateSceneNotifications.ROLENAME_CLOSE,RoleNameCloseCommand);
  self:unobserve(RoleNameCloseCommand);
end