ShopTwoCloseCommand=class(MacroCommand);

function ShopTwoCloseCommand:ctor()
	self.class=ShopTwoCloseCommand;
end

function ShopTwoCloseCommand:execute(notification)
  self:removeMediator(ShopTwoMediator.name);
  self:unobserve(ShopTwoCloseCommand);
  self:removeCommand(ShopNotifications.ShopTwo_UI_CLOSE,ShopTwoCloseCommand);

  local refresh = true;
  if JingjichangMediator then
  	local jjcMediator = self:retrieveMediator(JingjichangMediator.name);
  	if jjcMediator then
  		refresh = false
  	end
  end	
  if refresh then
  	local currencyGroupMediator=self:retrieveMediator(CurrencyGroupMediator.name);
	  if currencyGroupMediator then
	    currencyGroupMediator:areaExitRongYu()
	  end
  end
end