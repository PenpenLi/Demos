-- 初始化功能开启

require "main.model.OpenFunctionProxy";

OpenFuncionInitialize=class(Command);

function OpenFuncionInitialize:ctor()
	self.class=OpenFuncionInitialize;
end

function OpenFuncionInitialize:execute()
	--
  local openFunctionProxy=OpenFunctionProxy.new();
  self:registerProxy(openFunctionProxy:getProxyName(),openFunctionProxy);
end