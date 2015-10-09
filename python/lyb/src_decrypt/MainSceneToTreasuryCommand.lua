MainSceneToTreasuryCommand=class(Command);

function MainSceneToTreasuryCommand:ctor()
	self.class=MainSceneToTreasuryCommand;
end

function MainSceneToTreasuryCommand:execute()
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

  self:observe(TreasuryCloseCommand);
end

function MainSceneToTreasuryCommand:registerCommands()
  self:registerCommand(TreasuryNotifications.TREASURY_CLOSE_COMMAND,TreasuryCloseCommand);
 
end