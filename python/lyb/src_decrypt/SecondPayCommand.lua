

SecondPayCommand=class(Command);
 
function SecondPayCommand:ctor()
	self.class=SecondPayCommand;
end

function SecondPayCommand:execute(notification)
	require "main.view.secondPay.SecondPayMediator";
	require "main.controller.command.secondPay.SecondPayCloseCommand";

  self.notification = notification;
  
  self.secondPayMed=self:retrieveMediator(SecondPayMediator.name);  
  if nil==self.secondPayMed then
    self.secondPayMed=SecondPayMediator.new();

    self:registerMediator(self.secondPayMed:getMediatorName(), self.secondPayMed);

    self:registerCommand(SecondPayNotifications.SECOND_PAY_CLOSE, SecondPayCloseCommand);
  end
  sendMessage(29, 2, {ID = 17})
   self:observe(SecondPayCloseCommand);
   LayerManager:addLayerPopable(self.secondPayMed:getViewComponent());
  
end
