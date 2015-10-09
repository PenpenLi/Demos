--[[
    家园
    @zhangke
]]

ToOperationCommand=class(Command);

function ToOperationCommand:ctor()
	self.class=ToOperationCommand;
end

function ToOperationCommand:execute()
require "main.view.mainScene.operation.OperationMediator";
require "main.controller.command.mainScene.ToOperationRecordCommand";
require "main.controller.command.mainScene.ToRemoveOperationCommand";
require "main.controller.command.huanHua.ToHuanHuaCommand";

	log("function ToOperationCommand:execute()")
  	-- local mainMediator = self:retrieveMediator(MainSceneMediator.name);
	local operaionProxy = self:retrieveProxy(OperationProxy.name);
	local userProxy=self:retrieveProxy(UserProxy.name);
	local operationMediator = self:retrieveMediator(OperationMediator.name);
	if(operationMediator == nil) then
	    operationMediator = OperationMediator.new()
	    self:registerMediator(operationMediator:getMediatorName(),operationMediator);
		self:registerCommand(MainSceneNotifications.TO_OPERATION_RECORD, ToOperationRecordCommand);
	end
	-- local data = operaionProxy.operationData
	-- operationMediator:setData(data);
	LayerManager:addLayerPopable(operationMediator:getViewComponent());
	self:registerOperationCommands()

    if GameVar.tutorStage == TutorConfig.STAGE_1023 then
  	  local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
      openTutorUI({x=1018, y=459, width = 132, height = 51});
	elseif GameVar.tutorStage == TutorConfig.STAGE_1026 then
	  local yPos = 345;
	  local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);
	  if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_68) then
		yPos = 459
	  end
  	  local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
      local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)--剧情
      openTutorUI({x=1018, y=yPos, width = 132, height = 51});
    end
end
function ToOperationCommand:registerOperationCommands()
  self:registerCommand(MainSceneNotifications.TO_REMOVE_OPERATION, ToRemoveOperationCommand);
  self:registerCommand(MainSceneNotifications.TO_HUANHUA_UI_COMMAND,ToHuanHuaCommand);
end