ToTreasuryCommand=class(Command);

function ToTreasuryCommand:ctor()
	self.class=ToTreasuryCommand;
end

function ToTreasuryCommand:execute()
  require "main.view.treasury.TreasuryMediator";
  require "main.controller.command.treasury.TreasuryCloseCommand";
  require "main.controller.notification.TreasuryNotification";
  
  local treasuryMediator=self:retrieveMediator(TreasuryMediator.name);

  if nil==treasuryMediator then
    treasuryMediator=TreasuryMediator.new();
    self:registerMediator(treasuryMediator:getMediatorName(),treasuryMediator);
    treasuryMediator:intializeUI();
  end

  self:registerCommands();
  LayerManager:addLayerPopable(treasuryMediator:getViewComponent());
  
  if GameVar.tutorStage == TutorConfig.STAGE_1028 then
    treasuryMediator:getViewComponent():onTutorShow(2)
    openTutorUI({x=588, y=68, width = 127, height = 127});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1024 then
    treasuryMediator:getViewComponent():onTutorShow(1)
    openTutorUI({x=230, y=324, width = 308, height = 233});

  end

  self:observe(TreasuryCloseCommand);
end

function ToTreasuryCommand:registerCommands()
  self:registerCommand(TreasuryNotifications.TREASURY_CLOSE_COMMAND,TreasuryCloseCommand);
 
end