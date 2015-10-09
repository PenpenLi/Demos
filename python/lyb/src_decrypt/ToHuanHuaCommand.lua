
ToHuanHuaCommand=class(Command);

function ToHuanHuaCommand:ctor()
	self.class=ToHuanHuaCommand;
end

function ToHuanHuaCommand:execute()
require "main.view.huanHua.HuanHuaMediator";
require "main.controller.command.huanHua.ToRemoveHuanHuaCommand";
	log("function ToHuanHuaCommand:registerHuanHuanCommands()")
	local huanHuaMediator = self:retrieveMediator(HuanHuaMediator.name);
	if(huanHuaMediator == nil) then
	    huanHuaMediator = HuanHuaMediator.new()
	    self:registerMediator(huanHuaMediator:getMediatorName(),huanHuaMediator);
		self:registerCommand(MainSceneNotifications.TO_OPERATION_RECORD, ToOperationRecordCommand);
	end

	LayerManager:addLayerPopable(huanHuaMediator:getViewComponent());
	self:registerHuanHuanCommands()

    hecDC(3,29,1)

end
function ToHuanHuaCommand:registerHuanHuanCommands()
  self:registerCommand(MainSceneNotifications.CLOSE_HUANHUA_UI_COMMAND, ToRemoveHuanHuaCommand);
end