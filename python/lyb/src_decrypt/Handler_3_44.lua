
Handler_3_44 = class(MacroCommand);

function Handler_3_44:execute()
	sharedTextAnimateReward():animateStartByString("幻化成功")
	if MainSceneMediator then
		local mainSceneMediator=self:retrieveMediator(MainSceneMediator.name);
		if nil~=mainSceneMediator then
			mainSceneMediator:refreshMainGeneral();
		end
	end
	if OperationMediator then
		local operationMediator=self:retrieveMediator(OperationMediator.name);
		if operationMediator then
			operationMediator:refreshMainRole();
		end
	end
	local userProxy = self:retrieveProxy(UserProxy.name)
	print("userProxy.transforId", userProxy.transforId)

end

Handler_3_44.new():execute();