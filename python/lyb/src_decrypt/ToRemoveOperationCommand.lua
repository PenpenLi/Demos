
ToRemoveOperationCommand=class(Command);

function ToRemoveOperationCommand:ctor()
	self.class=ToRemoveOperationCommand;
end

function ToRemoveOperationCommand:execute()
	self:removeMediator(OperationMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_OPERATION,ToRemoveOperationCommand);
end