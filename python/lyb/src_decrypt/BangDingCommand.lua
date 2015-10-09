

BangDingCommand=class(Command);

function BangDingCommand:ctor()
	self.class=BangDingCommand;
end

function BangDingCommand:execute(notification)
	require "main.view.huoDong.BangDingMediator";
	require "main.controller.command.huoDong.BangDingCloseCommand";


  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  self.notification = notification;
  
  self.BangDingMed=self:retrieveMediator(BangDingMediator.name);  
  if nil==self.BangDingMed then
    self.BangDingMed=BangDingMediator.new();

    self:registerMediator(self.BangDingMed:getMediatorName(),self.BangDingMed);

    self:registerCommand(BangDingNotifications.BANG_DING_CLOSE, BangDingCloseCommand);
  end

   self:observe(BangDingCloseCommand);
   LayerManager:addLayerPopable(self.BangDingMed:getViewComponent());
  
end
