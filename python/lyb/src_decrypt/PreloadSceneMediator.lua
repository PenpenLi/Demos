require "main.view.preloadScene.ui.PreloadSceneUI";
require "main.controller.notification.PreloadSceneNotification";
require "core.utils.SceneShift";
require "core.utils.TextAnimateReward"
require "main.common.transform.BitmapCacher"


PreloadSceneMediator = class(Mediator);
AccountTable = {
	accountName = "";
	passWord = "";
};
function PreloadSceneMediator:ctor()
  	self.class = PreloadSceneMediator;
	self.viewComponent = PreloadSceneUI.new();
end

rawset(PreloadSceneMediator,"name","PreloadSceneMediator");

function PreloadSceneMediator:onRegister()
	self:getViewComponent():initScene();
end