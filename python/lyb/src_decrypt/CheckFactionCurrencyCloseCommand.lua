CheckFactionCurrencyCloseCommand=class(MacroCommand);

function CheckFactionCurrencyCloseCommand:ctor()
	self.class=CheckFactionCurrencyCloseCommand;
end

function CheckFactionCurrencyCloseCommand:execute(notification)
  if FactionMediator then
	  self.factionMediator=self:retrieveMediator(FactionMediator.name);  
	  if nil == self.factionMediator then
	  	FactionCurrencyCloseCommand.new():execute();
	  end
  end
end