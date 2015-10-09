
require "main.model.CreateRoleProxy";

CreateRoleDataInitialize=class(Command);

function CreateRoleDataInitialize:ctor()
	self.class=CreateRoleDataInitialize;
end

function CreateRoleDataInitialize:execute()
	--
  local createRoleProxy=CreateRoleProxy.new();
  self:registerProxy(createRoleProxy:getProxyName(),createRoleProxy);
end