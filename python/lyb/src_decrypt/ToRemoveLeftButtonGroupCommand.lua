
ToRemoveLeftButtonGroupCommand=class(Command);

function ToRemoveLeftButtonGroupCommand:ctor()
	self.class=ToRemoveLeftButtonGroupCommand;
end

function ToRemoveLeftButtonGroupCommand:execute()
	local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name)
	if leftButtonGroupMediator then
		leftButtonGroupMediator:onRemove()
	end	
	self:removeMediator(LeftButtonGroupMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_LEFT_BUTTON_GROUP_COMMAND,ToRemoveLeftButtonGroupCommand);
end