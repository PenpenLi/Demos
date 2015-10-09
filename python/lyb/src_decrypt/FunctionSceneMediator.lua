require "main.view.functionScene.ui.FunctionSceneUI";
require "core.utils.SceneShift";
require "core.utils.TextAnimateReward"
require "main.common.transform.BitmapCacher"


FunctionSceneMediator = class(Mediator);

function FunctionSceneMediator:ctor()
  	self.class = FunctionSceneMediator;
	self.viewComponent = FunctionSceneUI.new();
end

rawset(FunctionSceneMediator,"name","FunctionSceneMediator");

function FunctionSceneMediator:onRegister()
  self:getViewComponent():initScene();
end

function FunctionSceneMediator:initializeUI(mediator)
	self:getViewComponent():initializeUI(mediator);
end