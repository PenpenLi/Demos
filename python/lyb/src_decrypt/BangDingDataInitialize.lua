require "main.model.BangDingProxy";

BangDingDataInitialize=class(Command);

function BangDingDataInitialize:ctor()
	self.class=BangDingDataInitialize;
end

function BangDingDataInitialize:execute()
  local BangDingProxy=BangDingProxy.new();
  self:registerProxy(BangDingProxy:getProxyName(),BangDingProxy);
end