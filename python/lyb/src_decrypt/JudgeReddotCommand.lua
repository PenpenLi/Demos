
-- judge reddot visible
-- functionid 功能ID
JudgeReddotCommand=class(MacroCommand);

function JudgeReddotCommand:ctor()
	self.class=JudgeReddotCommand;
end

function JudgeReddotCommand:execute(notification)
	
	if notification == nil then
		return
	end
	
	-- 刷新指定的系统 常量不可变
	local functionId = notification.data.functionId
	local value = notification.data.value

	local result = false;
	local openFunctionProxy = self:retrieveProxy(OpenFunctionProxy.name);

	local isZhenFaOpen = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_61)
	local isTianXianOpen = openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_68) 

	-- print("isZhenFaOpen", isZhenFaOpen)
	-- print("isTianXianOpen", isTianXianOpen)
	if isZhenFaOpen and isTianXianOpen then
		local zhenfaRed = self:judgeZhenfa(value)
		local tianxiangRed = self:judgeTianxiang()
		if zhenfaRed or tianxiangRed then
			result = true;
		else
			result = false;
		end
	elseif isZhenFaOpen then
		result = self:judgeZhenfa(value)
	elseif isTianXianOpen then
		result = self:judgeTianxiang()
	end

	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! result", result)
	if MainSceneMediator then
		local mainMediator = self:retrieveMediator(MainSceneMediator.name)
		if mainMediator then
			mainMediator:refreshRedIcon(result)
		end 
	end

	-- if functionId == FunctionConfig.FUNCTION_ID_61 and openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_61) then  -- 阵法
	-- 	self:judgeZhenfa(value)
	-- elseif functionId == FunctionConfig.FUNCTION_ID_68 and openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_68) then -- 天相
	-- 	self:judgeTianxiang()
	-- end

end

function JudgeReddotCommand:judgeZhenfa(value)
	local operatonProxy = self:retrieveProxy(OperationProxy.name);
	local zhenfaProxy = self:retrieveProxy(ZhenFaProxy.name);
	local bagProxy = self:retrieveProxy(BagProxy.name);
	local userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);

	local iszhenfaRed = operatonProxy:isZhenfaRedIconVisible(zhenfaProxy,bagProxy,userCurrencyProxy,value)
	print("????????????????????????? iszhenfaRed", iszhenfaRed)
	-- error("iszhenfaRed", iszhenfaRed)
	return iszhenfaRed;
end

function JudgeReddotCommand:judgeTianxiang()
	local operatonProxy = self:retrieveProxy(OperationProxy.name);
	local userCurrencyProxy = self:retrieveProxy(UserCurrencyProxy.name);
	local userProxy = self:retrieveProxy(UserProxy.name);
	local isTianxiangRed = operatonProxy:isTianxiangRedIconVisible(userProxy, userCurrencyProxy)

	print("????????????????????????? isTianxiangRed", isTianxiangRed)
	-- error("isTianxiangRed", isTianxiangRed)
	return isTianxiangRed

end
