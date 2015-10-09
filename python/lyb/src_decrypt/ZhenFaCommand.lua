

ZhenFaCommand=class(Command);
 
function ZhenFaCommand:ctor()
	self.class=ZhenFaCommand;
end

function ZhenFaCommand:execute(notification)
	require "main.view.zhenFa.ZhenFaMediator";
	require "main.controller.command.zhenFa.ZhenFaCloseCommand";

  self.notification = notification;
  
  self.zhenFaMed=self:retrieveMediator(ZhenFaMediator.name);  
  if nil==self.zhenFaMed then
    self.zhenFaMed=ZhenFaMediator.new();

    self:registerMediator(self.zhenFaMed:getMediatorName(),self.zhenFaMed);

    self:registerCommand(ZhenFaNotifications.ZHEN_FA_CLOSE, ZhenFaCloseCommand);
  end
  
   self:observe(ZhenFaCloseCommand);
   LayerManager:addLayerPopable(self.zhenFaMed:getViewComponent());

end
