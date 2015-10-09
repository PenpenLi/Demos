
-- 改名成功

Handler_3_41 = class(MacroCommand);

function Handler_3_41:execute()
	local userName = recvTable["UserName"]
	local userProxy = self:retrieveProxy(UserProxy.name)
	userProxy.userName = userName
	
	sharedTextAnimateReward():animateStartByString("改名成功!")
	
	-- refresh name place
	local mainMediator = self:retrieveMediator(MainSceneMediator.name)
	if mainMediator then
		mainMediator:refreshUserName()
	end

	if OperationMediator then
		local operationMediator = self:retrieveMediator(OperationMediator.name)
		if operationMediator then
			operationMediator:refreshName()
		end	
	end
end

Handler_3_41.new():execute();