require "main.model.ShopProxy";

ShopDataInitialize=class(Command);

function ShopDataInitialize:ctor()
	self.class=ShopDataInitialize;
end

function ShopDataInitialize:execute()
  local shopProxy=ShopProxy.new();
  self:registerProxy(shopProxy:getProxyName(),shopProxy);
end