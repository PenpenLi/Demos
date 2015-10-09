--每个proxy 单独用一个lua文件包装初始化其实是很浪费的。所以尽里放在一个文件里面。

require "main.model.ShadowProxy";

CommonDataInitialize=class(Command);

function CommonDataInitialize:ctor()
	self.class=CommonDataInitialize;
end

function CommonDataInitialize:execute()
	--ShadowProxy
  local shadowProxy=ShadowProxy.new();
  self:registerProxy(shadowProxy:getProxyName(),shadowProxy);
end