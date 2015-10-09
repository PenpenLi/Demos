
require "main.model.HeroHouseProxy";

HeroHouseDataInitialize=class(Command);

function HeroHouseDataInitialize:ctor()
	self.class=HeroHouseDataInitialize;
end

function HeroHouseDataInitialize:execute()
	--
  local heroHouseProxy=HeroHouseProxy.new();
  self:registerProxy(heroHouseProxy:getProxyName(),heroHouseProxy);
end