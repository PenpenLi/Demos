require "main.model.SecondPayProxy";

SecondPayDataInitialize=class(Command);

function SecondPayDataInitialize:ctor()
	self.class=SecondPayDataInitialize;
end

function SecondPayDataInitialize:execute()
  local SecondPayProxy=SecondPayProxy.new();
  self:registerProxy(SecondPayProxy:getProxyName(),SecondPayProxy);
end