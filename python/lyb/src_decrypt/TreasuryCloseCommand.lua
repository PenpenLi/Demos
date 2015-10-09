TreasuryCloseCommand=class(Command);

function TreasuryCloseCommand:ctor()
	self.class=TreasuryCloseCommand;
end

function TreasuryCloseCommand:execute(notification)
  self:removeMediator(TreasuryMediator.name);
  self:unobserve(TreasuryCloseCommand);
  self:checkFactionCurrencyClose()

  -- if GameVar.tutorStage == TutorConfig.STAGE_1028 then
  --   sendServerTutorMsg({})
  --   closeTutorUI();
  -- end
end


function TreasuryCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end