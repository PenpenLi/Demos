--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroHouseCloseCommand=class(Command);

function HeroHouseCloseCommand:ctor()
	self.class=HeroHouseCloseCommand;
end

function HeroHouseCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroHousePopupMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroHouseCloseCommand);
  if GameVar.tutorStage == TutorConfig.STAGE_1004 or GameVar.tutorStage == TutorConfig.STAGE_1006 then
    local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
    local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)
    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
  --   -- local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
  --   closeTutorUI(false);
  --   ToAddFunctionOpenCommand.new():execute(MainSceneNotification.new(MainSceneNotifications.TO_ADD_FUNCTION_OPEN_UI, {functionId = 36}));
  end
  if GameVar.tutorEndSendMsg then
    sendServerTutorMsg({Stage = TutorConfig.STAGE_99999, BooleanValue = 0,BooleanValue2 = 1})
    GameVar.tutorEndSendMsg = nil;
  end

end