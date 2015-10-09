require "main.model.EquipmentInfoProxy";
require "main.controller.command.bagPopup.CheckBetterEquipCommand"
Handler_10_1 = class(MacroCommand);

function Handler_10_1:execute()
  -- for k,v in pairs(recvTable["EquipmentInfoArray"]) do
  --   print("");
  --   for k_,v_ in pairs(v) do
  --     print(".10.1.",k_,v_);
  --   end
  -- end

  for k,v in pairs(recvTable["EquipmentInfoArray"]) do
    local function sort(data_a, data_b)
      if 0 == data_a.Type and 0 ~= data_b.Type then
        return false;
      elseif 0 ~= data_a.Type and 0 == data_b.Type then
        return true;
      end
      return data_a.Type < data_b.Type;
    end
    table.sort(v.PropertyArray,sort);
  end

	local equipmentInfoProxy=self:retrieveProxy(EquipmentInfoProxy.name);
  equipmentInfoProxy:refresh(recvTable["EquipmentInfoArray"]);

  local strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
  if strengthenProxy.Qianghua_ALL_Bool then
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    for k,v in pairs(recvTable["EquipmentInfoArray"]) do
      heroHouseProxy:setHongdianData(v.GeneralId,1);
      heroHouseProxy:setHongdianData(v.GeneralId,6);
    end
  end
  -- local userProxy=self:retrieveProxy(UserProxy.name);
  -- if userProxy.state ~= GameConfig.STATE_TYPE_2 then
  --    CheckBetterEquipCommand.new():execute();
  -- end

  if StrengthenPopupMediator then
    local strengthenPopupMediator=self:retrieveMediator(StrengthenPopupMediator.name);
    if strengthenPopupMediator then
      uninitializeSmallLoading();
      for k,v in pairs(recvTable["EquipmentInfoArray"]) do
        strengthenPopupMediator:getViewComponent():refreshStrengthenToTop(v["GeneralId"],v["ItemId"],v["StrengthenLevel"]);
      end
    
      local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
      local generalArray = heroHouseProxy.generalArray;
      for k,v in pairs(generalArray) do
        heroHouseProxy:setHongdianData(v.GeneralId,1);
        heroHouseProxy:setHongdianData(v.GeneralId,6);
      end
      if HeroRedDotRefreshCommand then
        HeroRedDotRefreshCommand.new():execute();
      end
    end
  end
  if HeroProPopupMediator then
    local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
    if heroProPopupMediator then
      heroProPopupMediator:getViewComponent():refreshStrengthenAll();
    end
  end

  if HeroRedDotRefreshCommand then
    HeroRedDotRefreshCommand.new():execute();
  end
end


Handler_10_1.new():execute();