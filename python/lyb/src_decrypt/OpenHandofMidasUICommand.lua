OpenHandofMidasUICommand=class(Command);

function OpenHandofMidasUICommand:ctor()
	self.class=OpenHandofMidasUICommand;
end

function OpenHandofMidasUICommand:execute(notification)
  print("OpenHandofMidasUICommand:execute()")
	require "main.view.handofMidas.HandofMidasMediator";
	require "main.controller.command.handofMidas.HandofMidasUICloseCommand";

  sendMessage(24, 47)
  self.handofMidasMed=self:retrieveMediator(HandofMidasMediator.name);  
  if nil==self.handofMidasMed then
    self.handofMidasMed=HandofMidasMediator.new();

    self:registerMediator(self.handofMidasMed:getMediatorName(),self.handofMidasMed);

    self:registerHandofMidasCommands();
  end

   if notification and notification.data then
      self.handofMidasMed:setShowCurrency(notification.data.showCurrency);
   end
   self:observe(HandofMidasUICloseCommand);
   LayerManager:addLayerPopable(self.handofMidasMed:getViewComponent());

   hecDC(3,15,1)
end

function OpenHandofMidasUICommand:registerHandofMidasCommands()
  self:registerCommand(MainSceneNotifications.TO_CLOSE_HAND_OF_MIDAS_UI, HandofMidasUICloseCommand);

end
