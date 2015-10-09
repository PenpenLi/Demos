require "main.model.HuoDongProxy";

HuoDongDataInitialize=class(Command);

function HuoDongDataInitialize:ctor()
	self.class=HuoDongDataInitialize;
end

function HuoDongDataInitialize:execute()
  local huoDongProxy=HuoDongProxy.new();
  self:registerProxy(huoDongProxy:getProxyName(),huoDongProxy);
end