
OpenObtainSilverUICommand=class(Command);

function OpenObtainSilverUICommand:ctor()
	self.class=OpenObtainSilverUICommand;
end

function OpenObtainSilverUICommand:execute(notification)
  require "main.model.ObtainSilverProxy";
  require "main.view.obtainSilver.ObtainSilverMediator";
  require "main.controller.command.obtainSilver.ObtainSilverCloseCommand";


  local obtainSilverProxy=self:retrieveProxy(ObtainSilverProxy.name);
  local userProxy=self:retrieveProxy(UserProxy.name);
  local bagProxy=self:retrieveProxy(BagProxy.name);
  local obtainSilverMediator=self:retrieveMediator(ObtainSilverMediator.name);  
  local userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
  if nil == obtainSilverMediator then
    obtainSilverMediator=ObtainSilverMediator.new();
    self:registerMediator(obtainSilverMediator:getMediatorName(), obtainSilverMediator);
    
   
    obtainSilverMediator:initializeUI(obtainSilverProxy:getSkeleton(), userCurrencyProxy, bagProxy, userProxy);
    self:registerObtainSilverCommands()
  end
  local countControlProxy= self:retrieveProxy(CountControlProxy.name);

  local generalListProxy = self:retrieveProxy(GeneralListProxy.name)

  obtainSilverMediator:refreshTimesData(countControlProxy, userProxy.vipLevel, generalListProxy:getLevel());
  
  sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(obtainSilverMediator:getViewComponent());
  sendMessage(7, 50);
  self:observe(ObtainSilverCloseCommand);

end


function OpenObtainSilverUICommand:registerObtainSilverCommands()
  self:registerCommand(ObtainSilverNotifications.OBTAIN_SILVER_CLOSE, ObtainSilverCloseCommand);
end
