
ToTenCountryCommand=class(MacroCommand);

function ToTenCountryCommand:ctor()
	self.class=ToTenCountryCommand;
end

function ToTenCountryCommand:execute(notification)
  require "main.view.tenCountry.TenCountryMediator";
  require "main.controller.command.tenCountry.TenCountryCloseCommand"
  require "main.controller.notification.TenCountryNotification";
  
  local tenCountryMediator=self:retrieveMediator(TenCountryMediator.name);
  if nil==tenCountryMediator then
    tenCountryMediator=TenCountryMediator.new();
    self:registerMediator(tenCountryMediator:getMediatorName(),tenCountryMediator);
    tenCountryMediator:intializeUI();
  end 
  print("ToTenCountryCommand")
  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(tenCountryMediator:getViewComponent());
  LayerManager:addLayerPopable(tenCountryMediator:getViewComponent());
  self:registerTenCountryCommands();
  self:observe(TenCountryCloseCommand);

  if GameVar.tutorStage == TutorConfig.STAGE_1026 then
    local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
    if tenCountryProxy.afterBattle then
      GameVar.tutorSmallStep = 102604
      openTutorUI({x=154, y=246, width = 73, height = 77, alpha = 125});
    else
      openTutorUI({x=68, y=392, width = 136, height = 171, alpha = 125});
    end
  end
  

end

function ToTenCountryCommand:registerTenCountryCommands()
  self:registerCommand(TenCountryNotifications.TEN_COUNTRY_CLOSE,TenCountryCloseCommand);
end