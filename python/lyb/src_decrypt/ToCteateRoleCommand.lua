

ToCteateRoleCommand=class(Command);

function ToCteateRoleCommand:ctor()
	self.class=ToCteateRoleCommand;
end

function ToCteateRoleCommand:execute()

  hecDC(2,43)

  GameData.isConnecting = false
  
  require "main.view.createScene.CreateRoleMediator";
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
  
  -- 先 add到preload场景 回头改成main场景
  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_UI):addChild(createRoleMediator:getViewComponent());  
  sharedPreloadLayerManager():getLayer(GameConfig.PRELOAD_LAYER_UI):addChild(createRoleMediator:getViewComponent());  
  blackFadeOut(nil,1,nil,createRoleMediator:getViewComponent().parent,nil)
end
