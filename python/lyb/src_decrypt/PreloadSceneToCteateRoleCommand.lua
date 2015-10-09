

PreloadSceneToCteateRoleCommand=class(Command);

function PreloadSceneToCteateRoleCommand:ctor()
	self.class=PreloadSceneToCteateRoleCommand;
end

function PreloadSceneToCteateRoleCommand:execute()
  require "main.view.createScene.CreateRoleMediator";
  require "main.controller.notification.CreateSceneNotification";
  require "main.controller.command.data.CreateRoleDataInitialize"
  
  CreateRoleDataInitialize.new():execute();

  local createRoleMediator=self:retrieveMediator(CreateRoleMediator.name);
  local createRoleProxy=self:retrieveProxy(CreateRoleProxy.name);
  if nil==createRoleMediator then
    createRoleMediator=CreateRoleMediator.new();
    self:registerMediator(createRoleMediator:getMediatorName(),createRoleMediator);
    createRoleMediator:intializeHeroCreateUI(createRoleProxy:getSkeleton());
  else
    createRoleMediator:initialize();
  end
  
  sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_PARTICLE_SYSTEM_UI):addChild(createRoleMediator:getViewComponent());  
end
