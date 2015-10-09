
Handler_3_43 = class(MacroCommand);

function Handler_3_43:execute()
	local IDArray = recvTable["IDArray"]

	local huanHuaMediator = self:retrieveMediator(HuanHuaMediator.name)
	if huanHuaMediator then
		huanHuaMediator:refreshHuanHua(IDArray)
	end

end

Handler_3_43.new():execute();