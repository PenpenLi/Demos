
require "main.view.family.ui.familyBanquet.FamilyBanquetMediator"
require "main.view.family.ui.familyBanquet.FamilyHoldBanquetMediator"
Handler_27_31 = class(MacroCommand);

function Handler_27_31:execute()
  uninitializeSmallLoading();
  local familyHoldBanquetMediator = self:retrieveMediator(FamilyHoldBanquetMediator.name);
  local remainSeconds = recvTable["RemainSeconds"];
  local physicalPower = recvTable["PhysicalPower"];
  local ID = recvTable["ID"];
  local BooleanValue = recvTable["BooleanValue"]
  
  --27_31请求过来的，BooleanValue=1，其他的都为0
  if familyHoldBanquetMediator and tonumber(BooleanValue) == 0 then
    familyHoldBanquetMediator:holdBanquet();
  end
  
  local familyBanquetMediator = self:retrieveMediator(FamilyBanquetMediator.name);
  
  if familyBanquetMediator and ID then 
    if not familyBanquetMediator.viewComponent.banquetID then
        familyBanquetMediator:initializeViewComponent();
    end
    
  	familyBanquetMediator:refreshMediatorviewComponentWithRPI(remainSeconds, physicalPower, ID);
  end
  
end

Handler_27_31.new():execute();