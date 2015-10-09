ToFiveEleBtleCommand=class(Command);

function ToFiveEleBtleCommand:ctor()
	self.class=ToFiveEleBtleCommand;
end

function ToFiveEleBtleCommand:execute()
  require "main.view.fiveElementsBattle.FiveEleBtleMediator";
  require "main.controller.command.fiveElementsBattle.FiveEleBtleCloseCommand";
  require "main.controller.notification.FiveEleBtleNotification";
  
  local mediator=self:retrieveMediator(FiveEleBtleMediator.name);

  if nil==mediator then
    mediator=FiveEleBtleMediator.new();
    self:registerMediator(mediator:getMediatorName(),mediator);
    mediator:intializeUI();
  end

  self:registerCommands();
  LayerManager:addLayerPopable(mediator:getViewComponent());


  self:observe(FiveEleBtleCloseCommand);

end

function ToFiveEleBtleCommand:registerCommands()
  self:registerCommand(FiveEleBtleNotifications.FIVEELEBTLE_CLOSE_COMMAND,FiveEleBtleCloseCommand);
 
end