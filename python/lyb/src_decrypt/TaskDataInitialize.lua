require "main.model.TaskProxy";

TaskDataInitialize=class(Command);

function TaskDataInitialize:ctor()
	self.class=TaskDataInitialize;
end

function TaskDataInitialize:execute()
	--
  local taskProxy=TaskProxy.new();
  self:registerProxy(taskProxy:getProxyName(),taskProxy);
end