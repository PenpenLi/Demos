

FirstPayCommand=class(Command);
 
function FirstPayCommand:ctor()
	self.class=FirstPayCommand;
end

function FirstPayCommand:execute(notification)
	require "main.view.firstPay.FirstPayMediator";
	require "main.controller.command.firstPay.FirstPayCloseCommand";

  self.notification = notification;
  
  self.firstPayMed=self:retrieveMediator(FirstPayMediator.name);  
  if nil==self.firstPayMed then
    self.firstPayMed=FirstPayMediator.new();

    self:registerMediator(self.firstPayMed:getMediatorName(),self.firstPayMed);

    self:registerCommand(FirstPayNotifications.FIRST_PAY_CLOSE, FirstPayCloseCommand);
  end
  sendMessage(29, 2, {ID = 4})
   self:observe(FirstPayCloseCommand);
   LayerManager:addLayerPopable(self.firstPayMed:getViewComponent());
  
end
