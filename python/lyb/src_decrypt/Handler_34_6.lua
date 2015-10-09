Handler_34_6 = class(Command)

function Handler_34_6:execute()
	local userProxy = self:retrieveProxy(UserProxy.name);
	log("Handler_34_6----recvTable==="..recvTable["BooleanValue"])
	userProxy.userInviteFinished = recvTable["BooleanValue"] == 1 or false;
end

Handler_34_6.new():execute()