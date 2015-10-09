HuoDongCloseCommand=class(MacroCommand);

function HuoDongCloseCommand:ctor()
  self.class=HuoDongCloseCommand;
end

function HuoDongCloseCommand:execute(notification)
  self:removeMediator(HuoDongMediator.name);
  self:unobserve(HuoDongCloseCommand);
  self:removeCommand(HuoDongNotifications.HUODONG_UI_CLOSE,HuoDongCloseCommand);

  -- if  GameVar.tutorStage ~= TutorConfig.STAGE_99999 then
  -- 	closeTutorUI();
  --   sendServerTutorMsg({})
  -- end


end