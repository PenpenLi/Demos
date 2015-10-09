require "main.model.MonthCardProxy";

MonthCardDataInitialize=class(Command);

function MonthCardDataInitialize:ctor()
	self.class=MonthCardDataInitialize;
end

function MonthCardDataInitialize:execute()
  local MonthCardProxy=MonthCardProxy.new();
  self:registerProxy(MonthCardProxy:getProxyName(),MonthCardProxy);
end