FactionCurrencyCloseCommand=class(MacroCommand);

function FactionCurrencyCloseCommand:ctor()
	self.class=FactionCurrencyCloseCommand;
end

function FactionCurrencyCloseCommand:execute(notification)
  if FactionCurrencyMediator then
  	self:removeMediator(FactionCurrencyMediator.name);
  end
  
  self:unobserve(FactionCurrencyCloseCommand);

end