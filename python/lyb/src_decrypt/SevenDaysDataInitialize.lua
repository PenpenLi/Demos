require "main.model.SevenDaysProxy";

SevenDaysDataInitialize=class(Command);

function SevenDaysDataInitialize:ctor()
	self.class=SevenDaysDataInitialize;
end

function SevenDaysDataInitialize:execute()
  local SevenDaysProxy=SevenDaysProxy.new();
  self:registerProxy(SevenDaysProxy:getProxyName(),SevenDaysProxy);
end