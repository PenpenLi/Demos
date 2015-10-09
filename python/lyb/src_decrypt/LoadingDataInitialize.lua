require "main.model.LoadingProxy";

LoadingDataInitialize=class(Command);

function LoadingDataInitialize:ctor()
	self.class=LoadingDataInitialize;
end

function LoadingDataInitialize:execute()
	--
  local LoadingProxy=LoadingProxy.new();
  self:registerProxy(LoadingProxy:getProxyName(),LoadingProxy);
end