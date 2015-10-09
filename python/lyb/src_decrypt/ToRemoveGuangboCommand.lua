
ToRemoveGuangboCommand=class(Command);

function ToRemoveGuangboCommand:ctor()
	self.class=ToRemoveGuangboCommand;
end

function ToRemoveGuangboCommand:execute()
	self:removeMediator(GuangboMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_GUANGBO,ToRemoveGuangboCommand);
end