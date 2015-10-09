BagPropSyntheticCommand=class(Command);

function BagPropSyntheticCommand:ctor()
	self.class=BagPropSyntheticCommand;
end

function BagPropSyntheticCommand:execute(notification)
	require "core.utils.StringUtils";
	require "main.config.FunctionConfig";
	require "main.config.PopupMessageConstConfig";
	print("bagPropSynthetic");
	-- local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name)
	-- if not openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_145) then
	-- 	sharedTextAnimateReward():animateStartByString("功能未开启..");
	-- 	return;
	-- end
	if(connectBoo) then
		initializeSmallLoading();
		sendMessage(9,11,notification:getData());
	end
end