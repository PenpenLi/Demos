--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_3_30 = class(Command);

function Handler_3_30:execute()
  print(".3.30.",recvTable["UserName"]);
  
  local nameStr = recvTable["UserName"];
  ConstConfig.USER_NAME=nameStr;
  local userProxy = self:retrieveProxy(UserProxy.name);
  userProxy.userName=nameStr;
  local generalListProxy = self:retrieveProxy(GeneralListProxy.name);

  
  if BagPopupMediator then
    local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
    bagPopupMediator:setNewName(userProxy);
  end
  sharedTextAnimateReward():animateStartByString("改名字成功了呢~");
end

Handler_3_30.new():execute();