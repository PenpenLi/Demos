Handler_27_4 = class(Command);

function Handler_27_4:execute()
	uninitializeSmallLoading();
	if BangpaiMediator then
		local bangpaiMediator=self:retrieveMediator(BangpaiMediator.name);
		  if bangpaiMediator then
		  	bangpaiMediator:onClose();
		  end
	end

	local userProxy = self:retrieveProxy(UserProxy.name)
    local mapSceneData = {}
    userProxy.sceneType = GameConfig.SCENE_TYPE_1
    mapSceneData["sceneType"] = userProxy.sceneType
    mapSceneData["from"] = GameConfig.SCENE_TYPE_4

    local data = {type = GameConfig.SCENE_TYPE_1, mapSceneData = mapSceneData};
    BeginLoadingSceneCommand.new():execute(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))

end

Handler_27_4.new():execute();