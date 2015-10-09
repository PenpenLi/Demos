FunctionSceneLoadCompleteCommand = class(MacroCommand);

function FunctionSceneLoadCompleteCommand:ctor()
  self.class = FunctionSceneLoadCompleteCommand;
end

function FunctionSceneLoadCompleteCommand:execute(notification)
  --补充充值界面跳转
  self:registerCommand(MainSceneNotifications.OPEN_PLATFORM_CHARGE_UI_COMMAND, OpenPlatformChargeCommand);
  self:registerCommand(TutorNotifications.TUTOR_UI_CLOSE, TutorCloseCommand);
  require "main.view.functionScene.FunctionSceneMediator"
  local functionSceneMediator = self:retrieveMediator(FunctionSceneMediator.name);
  if nil == functionSceneMediator then
    functionSceneMediator = FunctionSceneMediator.new();
    self:registerMediator(FunctionSceneMediator.name, functionSceneMediator);
  end
  functionSceneMediator:initializeUI(notification.data.mediator);
  print("Mediator initializeUI done", notification.data.mediator, gameSceneIns);
  GameData.isPopQuitPanel = false
  Director:sharedDirector():replaceScene(functionSceneMediator:getViewComponent());   

end
