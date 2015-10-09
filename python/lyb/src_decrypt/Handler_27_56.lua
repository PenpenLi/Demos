
Handler_27_56 = class(Command);

function Handler_27_56:execute()
   local ID = recvTable["ID"];
   local ConfigId = recvTable["ConfigId"];
   local userProxy = self:retrieveProxy(UserProxy.name);
   local mainMediator = self:retrieveMediator(MainSceneMediator.name);
   if mainMediator then
       mainMediator:addFuDai(ID, ConfigId, userProxy:getVipLevel());
   end
end

Handler_27_56.new():execute();