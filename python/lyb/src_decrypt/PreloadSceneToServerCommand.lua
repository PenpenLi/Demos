
--require "main.controller.command.preloadScene.PreloadSceneServerCloseCommand";

PreloadSceneToServerCommand=class(Command);

function PreloadSceneToServerCommand:ctor()
	self.class=PreloadSceneToServerCommand;
end

function PreloadSceneToServerCommand:execute()
  require "main.view.serverScene.ServerMediator";
  require "main.controller.notification.OfficialServerNotification";
  require "main.controller.command.officialServer.OpenOfficialServerCommand";
  require "main.controller.command.officialServer.CloseOfficialServerCommand";

  local serverMediator=self:retrieveMediator(ServerMediator.name);
  local serverProxy=self:retrieveProxy(ServerProxy.name);
  if nil==serverMediator then
    serverMediator=ServerMediator.new();
    self:registerMediator(serverMediator:getMediatorName(),serverMediator);
    serverMediator:intializeServerUI(serverProxy:getSkeleton());
  -- else
  --   serverMediator:initialize();
  end
  
  -- serverMediator:intializeServerUI(serverProxy:getSkeleton());

  sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(serverMediator:getViewComponent());  
  sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_SHIFT_UI):removeChildren()--防断线后有黑背景盖上
  self:registerServerCommands();
end

function PreloadSceneToServerCommand:registerServerCommands()
  self:registerCommand(PreloadSceneNotifications.SCENE_CLOSE_COMMAND,PreloadSceneCloseCommand);

  self:registerCommand(OfficialServerNotifications.OPEN_OFFICIAL_SERVER,OpenOfficialServerCommand);
  self:registerCommand(OfficialServerNotifications.CLOSE_OFFICIAL_SERVER,CloseOfficialServerCommand);
end