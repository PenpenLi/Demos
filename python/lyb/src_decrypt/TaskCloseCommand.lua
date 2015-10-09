TaskCloseCommand=class(MacroCommand);

function TaskCloseCommand:ctor()
	self.class=TaskCloseCommand;
end

function TaskCloseCommand:execute(notification)
  self:removeMediator(TaskMediator.name);
  self:unobserve(TaskCloseCommand);
  self:removeCommand(TaskNotifications.TASK_CLOSE_COMMOND, TaskCloseCommand)
  
  if GameVar.tutorStage == TutorConfig.STAGE_1005 then
  	if HButtonGroupMediator then
	    local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
	    if hBttonGroupMediator then
		    local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--24是剧情
		    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
		end
	end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1010 then
  	if ButtonGroupMediator then
	    local bttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
	    if bttonGroupMediator then
	        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
	        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H}); 
		end
	end
  end
end
