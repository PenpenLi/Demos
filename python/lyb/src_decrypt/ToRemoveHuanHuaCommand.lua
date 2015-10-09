
ToRemoveHuanHuaCommand=class(Command);

function ToRemoveHuanHuaCommand:ctor()
	self.class=ToRemoveHuanHuaCommand;
end

function ToRemoveHuanHuaCommand:execute()
	self:removeMediator(HuanHuaMediator.name);
	self:removeCommand(MainSceneNotifications.CLOSE_HUANHUA_UI_COMMAND,ToRemoveHuanHuaCommand);
end