require "main.model.EquipmentInfoProxy";
Handler_10_2 = class(MacroCommand);

function Handler_10_2:execute()
  uninitializeSmallLoading();
  --UserEquipmentId,StrengthenLevel,Param1,Param2
  print(recvTable["GeneralId"],recvTable["ItemId"],recvTable["StrengthenLevel"],recvTable["Param1"],recvTable["Param2"]);
  
  local equipmentInfoProxy=self:retrieveProxy(EquipmentInfoProxy.name);
  equipmentInfoProxy:refreshStrengthen(recvTable["GeneralId"],recvTable["ItemId"],recvTable["StrengthenLevel"],recvTable["Param1"],recvTable["Param2"]);
  -- equipmentInfoProxy:setZhanli(recvTable["GeneralId"],recvTable["ItemId"]);
  
  local strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
  strengthenProxy.Qianghua_Bool = nil;

  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local generalArray = heroHouseProxy.generalArray;
  for k,v in pairs(generalArray) do
    heroHouseProxy:setHongdianData(v.GeneralId,1);
    heroHouseProxy:setHongdianData(v.GeneralId,6);
  end

  if StrengthenPopupMediator then
    local strengthenPopupMediator=self:retrieveMediator(StrengthenPopupMediator.name);
    if strengthenPopupMediator then
      strengthenPopupMediator:refreshStrengthen(recvTable["GeneralId"],recvTable["ItemId"],recvTable["StrengthenLevel"],recvTable["Param1"],recvTable["Param2"]);
    end
  end
  if HeroProPopupMediator then
    local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
    if heroProPopupMediator then
      heroProPopupMediator:getViewComponent():refreshStrengthen(recvTable["GeneralId"],recvTable["ItemId"],recvTable["StrengthenLevel"],recvTable["Param1"],recvTable["Param2"]);
    end
  end

  if HeroRedDotRefreshCommand then
    HeroRedDotRefreshCommand.new():execute();
  end
end


Handler_10_2.new():execute();