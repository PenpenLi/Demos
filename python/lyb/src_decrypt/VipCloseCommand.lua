

VipCloseCommand=class(Command);

function VipCloseCommand:ctor()
	self.class=VipCloseCommand;
end

function VipCloseCommand:execute(notification)
  self:removeMediator(VipMediator.name);
  self:unobserve(VipCloseCommand);
  if FactionMediator then
  	local factionMediator = self:retrieveMediator(FactionMediator.name);
  	if factionMediator then
  		setFactionCurrencyVisible(true)
  	end
  end

end