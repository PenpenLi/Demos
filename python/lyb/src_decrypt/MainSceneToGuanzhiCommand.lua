require "main.view.guanzhi.GuanzhiPopupMediator";

MainSceneToGuanzhiCommand=class(Command);

function MainSceneToGuanzhiCommand:ctor()
	self.class=MainSceneToGuanzhiCommand;
end

function MainSceneToGuanzhiCommand:execute()
  self:require();
  --GuanzhiPopupMediator
  log("MainSceneToGuanzhiCommand:execute()")
  self.guanzhiPopupMediator=self:retrieveMediator(GuanzhiPopupMediator.name);
  if self.guanzhiPopupMediator then
    return;
  end
  if nil==self.guanzhiPopupMediator then
    self.guanzhiPopupMediator=GuanzhiPopupMediator.new();
    self:registerMediator(self.guanzhiPopupMediator:getMediatorName(),self.guanzhiPopupMediator);
    self:registerBagCommands();
  end

  LayerManager:addLayerPopable(self.guanzhiPopupMediator:getViewComponent());

  if not GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] and GameData.hasRedDotArr[FunctionConfig.FUNCTION_ID_33] then
    GameData.clickRedDotArr[FunctionConfig.FUNCTION_ID_33] = true
    self:addSubCommand(ToRefreshReddotCommand);
    self:complete({data={type=FunctionConfig.FUNCTION_ID_33}}); 
  end

  if GameVar.tutorStage == TutorConfig.STAGE_1012 then
    openTutorUI({x=173, y=117, width = 132, height = 50, alpha = 125});
  end
end

function MainSceneToGuanzhiCommand:registerBagCommands()
  self:registerCommand(GuanzhiNotifications.GUANZHI_CLOSE,GuanzhiCloseCommand);
end

function MainSceneToGuanzhiCommand:require()
  require "main.controller.notification.GuanzhiNotification";
  require "main.controller.command.guanzhi.GuanzhiCloseCommand";
end