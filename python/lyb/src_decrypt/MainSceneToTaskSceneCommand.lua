
MainSceneToTaskSceneCommand=class(Command);

function MainSceneToTaskSceneCommand:ctor()
	self.class=MainSceneToTaskSceneCommand;
end

function MainSceneToTaskSceneCommand:execute(notification)
require "main.view.task.TaskMediator";
require "main.controller.command.task.TaskCloseCommand";
self.taskMed=self:retrieveMediator(TaskMediator.name);  
  if  self.taskMed==nil then
      self.taskMed=TaskMediator.new();
      self:registerMediator( self.taskMed:getMediatorName(), self.taskMed);

      self:registerTaskCommands();
  end
  
  self:observe(TaskCloseCommand);
  LayerManager:addLayerPopable(self.taskMed:getViewComponent());

  hecDC(3, 22, 1)
  if GameVar.tutorStage == TutorConfig.STAGE_1005 then
    openTutorUI({x=986, y=485, width = 150, height = 142, alpha = 125});
    self.taskMed:getViewComponent().muBiaoList:setMoveEnabled(false);
  elseif GameVar.tutorStage == TutorConfig.STAGE_1025 then
    openTutorUI({x=986, y=485, width = 150, height = 120, alpha = 125});
    self.taskMed:getViewComponent().muBiaoList:setMoveEnabled(false);
  elseif GameVar.tutorStage == TutorConfig.STAGE_1010 then
    openTutorUI({x=986, y=485, width = 150, height = 120, alpha = 125});
    self.taskMed:getViewComponent().muBiaoList:setMoveEnabled(false);  
  end


  -- if notification and notification.tabID then
  --   taskMediator:changeTab(notification.tabID)
  -- end

end

function MainSceneToTaskSceneCommand:registerTaskCommands()
  self:registerCommand(TaskNotifications.TASK_CLOSE_COMMOND, TaskCloseCommand);
end
