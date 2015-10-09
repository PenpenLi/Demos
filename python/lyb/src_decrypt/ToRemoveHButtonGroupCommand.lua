
ToRemoveHButtonGroupCommand=class(Command);

function ToRemoveHButtonGroupCommand:ctor()
	self.class=ToRemoveHButtonGroupCommand;
end

function ToRemoveHButtonGroupCommand:execute()
	self:removeMediator(HButtonGroupMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_HBUTTON_GROUP_COMMAND,ToRemoveHButtonGroupCommand);
end