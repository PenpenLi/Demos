

Handler_19_3 = class(MacroCommand);

function Handler_19_3:execute()
 	local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
  local heroHouseProxy=self:retrieveProxy(HeroHouseProxy.name);
 	tenCountryProxy.placeId = recvTable["ID"]
 	tenCountryProxy.generalStateArray = recvTable["GeneralStateArray"]

 	require "main.view.tenCountry.TenCountryMediator";
 	tenCountryProxy.placeState = recvTable["State"]
 	local tenCountryMediator=self:retrieveMediator(TenCountryMediator.name);
 	if tenCountryMediator then
 		tenCountryMediator:refreshTenCountryMapData()
 	end
end

Handler_19_3.new():execute();