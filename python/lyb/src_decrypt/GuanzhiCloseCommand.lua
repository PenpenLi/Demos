GuanzhiCloseCommand=class(Command);

function GuanzhiCloseCommand:ctor()
	self.class=GuanzhiCloseCommand;
end

function GuanzhiCloseCommand:execute(notification)
  self:removeMediator(GuanzhiPopupMediator.name);
  self:removeCommand(GuanzhiNotifications.GUANZHI_CLOSE,GuanzhiCloseCommand);
  self:checkFactionCurrencyClose();
  if GameVar.tutorStage == TutorConfig.STAGE_1012 then
    sendServerTutorMsg({})
    closeTutorUI();
	 -- openTutorUI({x=1204, y=640, width = 80, height = 80, alpha = 84});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1026 then
  	 openTutorUI({x=180, y=420, width = 220, height = 200, alpha = 125});
  end
end

function GuanzhiCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end