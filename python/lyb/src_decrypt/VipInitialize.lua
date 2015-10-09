
require "main.model.VipProxy";

VipInitialize=class(Command);

function VipInitialize:ctor()
	self.class=VipInitialize;
end

function VipInitialize:execute()
	--
  local vipProxy=VipProxy.new();
  self:registerProxy(vipProxy:getProxyName(),vipProxy);
end