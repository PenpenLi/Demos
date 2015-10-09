
Handler_3_19 = class(Command);

function Handler_3_19:execute()
    local nameStr = recvTable["UserName"];    
    local userProxy = self:retrieveProxy(UserProxy.name);

    local generalListProxy = self:retrieveProxy(GeneralListProxy.name);

    ConstConfig.USER_NAME = nameStr;
    userProxy.userName = nameStr;

    RoleNameCloseCommand.new():execute();

end

Handler_3_19.new():execute();