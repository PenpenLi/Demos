require "main.model.FirstPayProxy";

FirstPayDataInitialize=class(Command);

function FirstPayDataInitialize:ctor()
	self.class=FirstPayDataInitialize;
end

function FirstPayDataInitialize:execute()
  local FirstPayProxy=FirstPayProxy.new();
  self:registerProxy(FirstPayProxy:getProxyName(),FirstPayProxy);
end