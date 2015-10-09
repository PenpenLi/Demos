
require "main.model.TenCountryProxy";

TenCountryDataInitialize=class(Command);

function TenCountryDataInitialize:ctor()
	self.class=TenCountryDataInitialize;
end

function TenCountryDataInitialize:execute()
	--
  local tenCountryProxy=TenCountryProxy.new();
  self:registerProxy(tenCountryProxy:getProxyName(),tenCountryProxy);
end