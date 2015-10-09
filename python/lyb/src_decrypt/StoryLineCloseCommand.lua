StoryLineCloseCommand=class(MacroCommand);

function StoryLineCloseCommand:ctor()
	self.class=StoryLineCloseCommand;
end

function StoryLineCloseCommand:execute(notification)
  self:removeMediator(StoryLineMediator.name);
  self:unobserve(StoryLineCloseCommand);
  if GameVar.tutorStage == TutorConfig.STAGE_1007 then
  	  if GameVar.hideCurrencyForTutor then
  	 	 GameVar.hideCurrencyForTutor = nil;
  	 	 setCurrencyGroupVisible(true)
  	  end

	  local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_22)--英雄志
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = 110, height = 110, alpha = 125});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1008 then
  	local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
    if hBttonGroupMediator then
    	local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_44)--44是五行幻境
    	openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
    end
  elseif GameVar.tutorStage == TutorConfig.STAGE_1006 then
    local bttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
    if bttonGroupMediator then
      local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
      openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
    end
  end



end