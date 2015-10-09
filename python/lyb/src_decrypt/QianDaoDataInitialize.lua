require "main.model.QianDaoProxy";

QianDaoDataInitialize=class(Command);

function QianDaoDataInitialize:ctor()
	self.class=QianDaoDataInitialize;
end

function QianDaoDataInitialize:execute()
  local qianDaoProxy=QianDaoProxy.new();
  self:registerProxy(qianDaoProxy:getProxyName(),qianDaoProxy);
end