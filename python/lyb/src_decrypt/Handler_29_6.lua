
Handler_29_6 = class(Command)

function Handler_29_6:execute()
	print("Handler_29_6", recvTable["BooleanValue"])
	log("Handler_29_6---recvTable ==="..recvTable["BooleanValue"])
	local proxy = self:retrieveProxy(HuoDongProxy.name);
	proxy.IsBuyFund = recvTable["BooleanValue"];
	print("proxy.IsBuyFund = ", proxy.IsBuyFund);
end

Handler_29_6.new():execute();

-- function Handler_34_6:execute()
-- 	local userProxy = self:retrieveProxy(UserProxy.name);
-- 	log("Handler_34_6----recvTable==="..recvTable["BooleanValue"])
-- 	userProxy.userInviteFinished = recvTable["BooleanValue"] == 1 or false;
-- end

-- Handler_34_6.new():execute()

-- function Handler_29_5:execute()
--   print(".29.5.",recvTable["ID"]);
--   uninitializeSmallLoading();
--   local firstChargeProxy=self:retrieveProxy(FirstChargeProxy.name);
--   firstChargeProxy:refreshItem(recvTable["ID"]);

--   local firstChargeMediator = self:retrieveMediator(FirstChargeMediator.name);
--   if firstChargeMediator then
--      firstChargeMediator:refreshDataToNextPage(recvTable["ID"]);
--   end

--   if MainSceneMediator then
--     local mainMediator = self:retrieveMediator(MainSceneMediator.name)
--     if mainMediator and mainMediator.viewComponent and mainMediator.viewComponent.mainUI then
--        mainMediator:refreshFirstChargeEffect();
--     end
--   end
-- end

-- Handler_29_5.new():execute();