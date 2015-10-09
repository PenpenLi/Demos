
require "main.model.ArenaProxy";

ArenaDataInitialize=class(Command);

function ArenaDataInitialize:ctor()
	self.class=ArenaDataInitialize;
end

function ArenaDataInitialize:execute()
	--
  local arenaProxy=ArenaProxy.new();
  self:registerProxy(arenaProxy:getProxyName(),arenaProxy);
end