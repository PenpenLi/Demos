
SnycTasksArrayCommand=class(Command);

function SnycTasksArrayCommand:ctor()
	self.class=SnycTasksArrayCommand;
end

function SnycTasksArrayCommand:execute(notification)
	require "main.view.task.TaskMediator";
require "main.model.UserProxy";
   local taskMediator=self:retrieveMediator(TaskMediator.name);
   local taskProxy=self:retrieveProxy(TaskProxy.name);
end