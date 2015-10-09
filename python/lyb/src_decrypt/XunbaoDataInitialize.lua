require "main.model.XunbaoProxy";

XunbaoDataInitialize=class(Command);

function XunbaoDataInitialize:ctor()
	self.class=XunbaoDataInitialize;
end

function XunbaoDataInitialize:execute()
  local xunbaoProxy=XunbaoProxy.new();
  self:registerProxy(xunbaoProxy:getProxyName(),xunbaoProxy);
end