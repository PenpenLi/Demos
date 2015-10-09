

TenCountryCloseCommand=class(Command);

function TenCountryCloseCommand:ctor()
	self.class=TenCountryCloseCommand;
  
end

function TenCountryCloseCommand:execute(notification)
  
  self:removeMediator(TenCountryMediator.name);
  self:removeCommand(TenCountryNotifications.TEN_COUNTRY_CLOSE,TenCountryCloseCommand);
  self:unobserve(TenCountryCloseCommand);
  
  self:checkFactionCurrencyClose();
  
  if  GameVar.tutorStage == TutorConfig.STAGE_1026  then
    local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
    if tenCountryProxy.afterBattle then
    	openTutorUI({x=1198, y=641, width = 80, height = 80, alpha = 125});
    end
  end
end


function TenCountryCloseCommand:checkFactionCurrencyClose()
	require "main.controller.command.faction.CheckFactionCurrencyCloseCommand"
	CheckFactionCurrencyCloseCommand.new():execute();
end