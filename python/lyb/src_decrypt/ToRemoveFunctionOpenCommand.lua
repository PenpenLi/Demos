
ToRemoveFunctionOpenCommand=class(Command);

function ToRemoveFunctionOpenCommand:ctor()
	self.class=ToRemoveFunctionOpenCommand;
end

function ToRemoveFunctionOpenCommand:execute()
	self:removeMediator(FunctionOpenMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_BUTTON_GROUP_COMMAND,ToRemoveFunctionOpenCommand);
end