

Handler_19_7 = class(Command);

function Handler_19_7:execute()
	local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
	tenCountryProxy:addNextPlace()
	local tenCountryMediator = self:retrieveMediator(TenCountryMediator.name)
	tenCountryMediator:refreshTenCountryMapData()
end

Handler_19_7.new():execute();