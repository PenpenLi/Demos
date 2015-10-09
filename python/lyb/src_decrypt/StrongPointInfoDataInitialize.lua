require "main.model.StrongPointInfoProxy";

StrongPointInfoDataInitialize=class(Command);

function StrongPointInfoDataInitialize:ctor()
	self.class=StrongPointInfoDataInitialize;
end

function StrongPointInfoDataInitialize:execute()
	--
  local strongPointInfoProxy=StrongPointInfoProxy.new();
  self:registerProxy(strongPointInfoProxy:getProxyName(),strongPointInfoProxy);
end