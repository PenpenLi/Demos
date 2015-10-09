
require "main.model.ServerProxy";

ServerDataInitialize=class(Command);

function ServerDataInitialize:ctor()
	self.class=ServerDataInitialize;
end

function ServerDataInitialize:execute()
	--
  local serverProxy=ServerProxy.new();
  self:registerProxy(serverProxy:getProxyName(),serverProxy);
end