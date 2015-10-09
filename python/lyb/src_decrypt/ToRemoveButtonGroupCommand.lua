
ToRemoveButtonGroupCommand=class(Command);

function ToRemoveButtonGroupCommand:ctor()
	self.class=ToRemoveButtonGroupCommand;
end

function ToRemoveButtonGroupCommand:execute()
	local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name)
	if buttonGroupMediator then
		buttonGroupMediator:onRemove()
	end
	
	self:removeMediator(ButtonGroupMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_BUTTON_GROUP_COMMAND,ToRemoveButtonGroupCommand);
end