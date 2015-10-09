

ToAddFunctionOpenCommand=class(Command);

function ToAddFunctionOpenCommand:ctor()
	self.class=ToAddFunctionOpenCommand;
end

function ToAddFunctionOpenCommand:execute(notification)
  
	if not notification.data.functionId then return end;
  	local functionPo = analysis("Gongnengkaiqi_Gongnengkaiqi", notification.data.functionId);

  	if functionPo.kaiqi == 0 then return end

	local pos = string.find(functionPo.interface, "_");
	local functionId
	if pos then
		local arr = StringUtils:lua_string_split(functionPo.interface, "_");
		functionId = tonumber(arr[1])
	else
		functionId = notification.data.functionId
	end

	local functionData = self:getTargetPosition(functionId);
	if not functionData or not functionData.x or not functionData.y then
		return;
	end


	require "main.view.mainScene.functionOpen.FunctionOpenMediator";
	require "main.controller.command.mainScene.ToRemoveFunctionOpenCommand"
	self.functionOpenMediator=self:retrieveMediator(FunctionOpenMediator.name);  
	if nil==self.functionOpenMediator then
	  self.functionOpenMediator=FunctionOpenMediator.new();

	  self:registerMediator(self.functionOpenMediator:getMediatorName(),self.functionOpenMediator);

	  local tutorData = self:getTutorTargetPosition()

  	  print("functionData.x, functionData.y", functionData.x, functionData.y)

	  self.functionOpenMediator:initializeUI(notification.data.functionId, functionData, tutorData);
	end

	self:observe(ToRemoveFunctionOpenCommand);
	self:registerCommand(MainSceneNotifications.TO_CLOSE_FUNCTION_OPEN_UI, ToRemoveFunctionOpenCommand);
	LayerManager:addLayerPopable(self.functionOpenMediator:getViewComponent());



end

function ToAddFunctionOpenCommand:getTutorTargetPosition()
	local data
	if GameVar.tutorStage == TutorConfig.STAGE_1025 then
		local bttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
		data = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_8)
		return data;
	elseif GameVar.tutorStage == TutorConfig.STAGE_1023 then
		data = {x=17 - GameData.uiOffsetX, y=610 - GameData.uiOffsetY, width = 97, height = 97}
		return data;
	elseif GameVar.tutorStage == TutorConfig.STAGE_2014 then
		data = {}
		data.x=981
		data.y=674+GameData.uiOffsetY
		data.width = 40
		data.height = 40
		return data;
	end
	return data;
end

function ToAddFunctionOpenCommand:getTargetPosition(functionId)

	local interface = analysis("Gongnengkaiqi_Gongnengkaiqi", functionId, "interface")
	if interface ~= "" then
		local iTables = StringUtils:lua_string_split(interface, "_")
		functionId = tonumber(iTables[1]);
	end
	local openFunctionProxy=self:retrieveProxy(OpenFunctionProxy.name); 
	local data
	if Utils:contain(FunctionConfig.menu_Hfunctions1,functionId) then
		local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
		data = hBttonGroupMediator:getTargetButtonPosition(functionId);
		data.x = data.x + 60
		data.y = data.y + 60
	elseif Utils:contain(FunctionConfig.menu_Hfunctions2,functionId) then
		local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name);
		data = mainSceneMediator:getTargetButtonPosition(functionId);
		data.x = data.x
		data.y = data.y + 60
	elseif Utils:contain(FunctionConfig.menu_Vfunctions,functionId) then
		local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
		data = buttonGroupMediator:getTargetButtonPosition(functionId)
		data.y = data.y + 60
	elseif Utils:contain(FunctionConfig.menu_Leftfunctions,functionId) then
		local leftButtonGroupMediator = self:retrieveMediator(LeftButtonGroupMediator.name);
		data = leftButtonGroupMediator:getTargetButtonPosition(functionId)
		-- data.x = data.x + 60
		data.y = data.y + 60
	end
	print("openFunctionProxy.openedFunctionTable[functionId] = functionId; = ", functionId);
	openFunctionProxy.openedFunctionTable[functionId] = functionId;
	openFunctionProxy.newOpenFunctionId = 0;
    -- print("data.x, data.y", data.x, data.y)
	return data;
end