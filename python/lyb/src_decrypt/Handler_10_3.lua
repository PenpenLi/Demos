Handler_10_3 = class(Command)

function Handler_10_3:execute()
	uninitializeSmallLoading();
  if StrengthenProxy then
      local strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
      strengthenProxy.Dazao_Bool = nil;
  end
  local equipmentInfoProxy=self:retrieveProxy(EquipmentInfoProxy.name);
  equipmentInfoProxy:refreshJinjie();

  local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
  local generalArray = heroHouseProxy.generalArray;
  for k,v in pairs(generalArray) do
    heroHouseProxy:setHongdianData(v.GeneralId,1);
    heroHouseProxy:setHongdianData(v.GeneralId,6);
  end

  if StrengthenPopupMediator then
    local strengthenPopupMediator=self:retrieveMediator(StrengthenPopupMediator.name);
    if strengthenPopupMediator then
      strengthenPopupMediator:getViewComponent():refreshJinjie();
    end
  end
  if HeroProPopupMediator then
    local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
    if heroProPopupMediator then
      heroProPopupMediator:getViewComponent():refreshJinjie();
    end
  end

  if HeroRedDotRefreshCommand then
    HeroRedDotRefreshCommand.new():execute();
  end
end

Handler_10_3.new():execute()