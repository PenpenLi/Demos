
ToRemoveCurrencyGroupCommand=class(Command);

function ToRemoveCurrencyGroupCommand:ctor()
	self.class=ToRemoveCurrencyGroupCommand;
end

function ToRemoveCurrencyGroupCommand:execute()
	self:removeMediator(CurrencyGroupMediator.name);
	self:removeCommand(MainSceneNotifications.TO_REMOVE_CURRENCY_GROUP_COMMAND, ToRemoveCurrencyGroupCommand);
end