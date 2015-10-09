--[[
	Copyright @2009-2015 www.happyelements.com, all rights reserved.
	Create date: 2015-04-02

	hao.yin@happyelements.com
]]
-- require "main.view.family.ui.familyBanquet.FamilyBanquetMediator";

Handler_27_36 = class(Command);

function Handler_27_36:execute()
  uninitializeSmallLoading();
  local UserIdNameArray = recvTable["UserIdNameArray"];
  local HeatWineArray = recvTable["HeatWineArray"];
  local ID = recvTable["ID"];
  local UserId = recvTable["UserId"];
  
  local familyBanquetMediator = self:retrieveMediator(FamilyBanquetMediator.name);
  local userProxy = self:retrieveProxy(UserProxy.name);
  local familyProxy = self:retrieveProxy(FamilyProxy.name);
  familyProxy.userIdNameArray = UserIdNameArray;
  for i,v in ipairs(UserIdNameArray) do
    if userProxy.userId == v.UserId then
      familyProxy.myBanquetData = UserIdNameArray;
    end
  end
  familyProxy.banquetID = ID;

  for i,v in ipairs(UserIdNameArray) do
    if userProxy.userId == v.UserId then
        familyProxy.inBanquetId = ID;
    end
  end

  if familyBanquetMediator then
    familyBanquetMediator:refreshMediatorviewComponentWithUHIU(UserIdNameArray, HeatWineArray, ID, UserId);
  end

  -- if MainSceneMediator then
  --   local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name);
  --   if mainSceneMediator then
  --     mainSceneMediator:addBanquetPerson(ID, #UserIdNameArray);
  --   end
  -- end
end

Handler_27_36.new():execute();