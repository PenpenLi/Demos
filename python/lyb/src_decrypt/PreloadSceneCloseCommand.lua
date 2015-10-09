

PreloadSceneCloseCommand=class(Command);

function PreloadSceneCloseCommand:ctor()
	self.class=PreloadSceneCloseCommand;
end

function PreloadSceneCloseCommand:execute(notification)
  local preloadSceneMediator=self:retrieveMediator(PreloadSceneMediator.name);
  if not preloadSceneMediator then return;end;
  if OfficialServerMediator then
    self:removeMediator(OfficialServerMediator.name);
  end
  self:removeMediator(PreloadSceneMediator.name);
  if CreateRoleMediator then
    self:removeMediator(CreateRoleMediator.name);
  end
  self:removeMediator(ServerMediator.name);

  --self:removeCommand(PreloadSceneNotifications.INIT_COMMANDS,PreloadSceneInitCommand);
  self:removeCommand(PreloadSceneNotifications.SERVER_COMMAND,PreloadSceneToServerCommand);
  self:removeCommand(PreloadSceneNotifications.SCENE_CLOSE_COMMAND,PreloadSceneCloseCommand);

  self:removeCommand(OfficialServerNotifications.OPEN_OFFICIAL_SERVER,OpenOfficialServerCommand);
  self:removeCommand(OfficialServerNotifications.CLOSE_OFFICIAL_SERVER,CloseOfficialServerCommand);
end