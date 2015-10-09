--	进入城区


EnterCityCommand=class(MacroCommand);

function EnterCityCommand:ctor()
	self.class=EnterCityCommand;
end

function EnterCityCommand:execute(notification)
    local userProxy = self:retrieveProxy(UserProxy.name)

    -- uninitializeSmallLoading();
    local mapSceneData = {}
    userProxy.sceneType = GameConfig.SCENE_TYPE_1
    mapSceneData["sceneType"] = userProxy.sceneType
    mapSceneData["coordinateX"] = userProxy.coordinateX
    mapSceneData["coordinateY"] = userProxy.coordinateY
    mapSceneData["from"] = GameConfig.SCENE_TYPE_3

    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
    self:addSubCommand(BeginLoadingSceneCommand)
    self:complete(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))


end