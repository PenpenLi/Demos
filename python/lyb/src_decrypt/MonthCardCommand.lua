

MonthCardCommand=class(Command);

function MonthCardCommand:ctor()
	self.class=MonthCardCommand;
end

function MonthCardCommand:execute(notification)
	require "main.view.monthCard.MonthCardMediator";
	require "main.controller.command.monthCard.MonthCardCloseCommand";


  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.notification = notification;
  
  self.MonthCardMed=self:retrieveMediator(MonthCardMediator.name);  
  if nil==self.MonthCardMed then
    self.MonthCardMed=MonthCardMediator.new();

    self:registerMediator(self.MonthCardMed:getMediatorName(),self.MonthCardMed);

    self:registerCommand(MonthCardNotifications.MONTH_CARD_CLOSE, MonthCardCloseCommand);
  end

   self:observe(MonthCardCloseCommand);
   LayerManager:addLayerPopable(self.MonthCardMed:getViewComponent());
  
end
