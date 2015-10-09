ToHuiGuCommand=class(Command);

function ToHuiGuCommand:ctor()
	self.class=ToHuiGuCommand;
end

function ToHuiGuCommand:execute()
  require "main.view.huiGu.HuiGuMediator";
  require "main.controller.command.fiveElementsBattle.FiveEleBtleCloseCommand";
  require "main.controller.notification.HuiGuNotification";
  
  local mediator=self:retrieveMediator(HuiGuMediator.name);

  if nil==mediator then
    mediator=HuiGuMediator.new();
    self:registerMediator(mediator:getMediatorName(),mediator);
    mediator:intializeUI();
  end

  self:registerCommands();
  LayerManager:addLayerPopable(mediator:getViewComponent());


  self:observe(FiveEleBtleCloseCommand);

end

function ToHuiGuCommand:registerCommands()
  self:registerCommand(HuiGuNotifications.HUIGU_CLOSE_COMMAND,FiveEleBtleCloseCommand);
 
end