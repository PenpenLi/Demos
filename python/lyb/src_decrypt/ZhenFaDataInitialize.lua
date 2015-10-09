require "main.model.ZhenFaProxy";

ZhenFaDataInitialize=class(Command);

function ZhenFaDataInitialize:ctor()
	self.class=ZhenFaDataInitialize;
end

function ZhenFaDataInitialize:execute()
  local ZhenFaProxy=ZhenFaProxy.new();
  self:registerProxy(ZhenFaProxy:getProxyName(),ZhenFaProxy);
end