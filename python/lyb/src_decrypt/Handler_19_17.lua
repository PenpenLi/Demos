Handler_19_17 = class(Command);

function Handler_19_17:execute()
   local tenCountryProxy=self:retrieveProxy(TenCountryProxy.name);
   tenCountryProxy.placeId = recvTable["ID"]
end

Handler_19_17.new():execute();