--[[
	Copyright @2009-2015 www.happyelements.com, all rights reserved.
	Create date: 2015-04-02

	hao.yin@happyelements.com
]]
require "main.view.family.ui.familyBanquet.FamilyBanquetMediator";

Handler_27_33 = class(Command);

function Handler_27_33:execute()
  
  local ID = recvTable["ID"];
  local UserIdNameArray = recvTable["UserIdNameArray"];

  end

  local familyBanquetMediator = self:retrieveMediator(FamilyBanquetMediator.name);
  

  familyBanquetMediator:refreshMediatorviewComponentWithUI(UserIdNameArray, ID);
end

Handler_27_33.new():execute();