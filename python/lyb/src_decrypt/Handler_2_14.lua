--
Handler_2_14 = class(Command);

function Handler_2_14:execute()
	log("Handler_2_14 BooleanValue"..recvTable["BooleanValue"])
	local isRecount = recvTable["BooleanValue"] == 1
	if isRecount then -- 可以重连
		
	else -- 重新登录
		logoutSuccess(GameConfig.CONNECT_TYPE_0)
	end

end

Handler_2_14.new():execute();