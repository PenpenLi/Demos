require "main.model.EquipmentInfoProxy";
Handler_10_4 = class(MacroCommand);

function Handler_10_4:execute()
  uninitializeSmallLoading();
  print(recvTable["GeneralId"],recvTable["ItemId"],recvTable["PropertyArray"]);
  for k,v in pairs(recvTable["PropertyArray"]) do
  	print(v.Type,v.Value);
  end

  local strengthenProxy = self:retrieveProxy(StrengthenProxy.name);
  strengthenProxy.Xi_Lian = nil;

  local function sort(data_a, data_b)
    if 0 == data_a.Type and 0 ~= data_b.Type then
      return false;
    elseif 0 ~= data_a.Type and 0 == data_b.Type then
      return true;
    end
    return data_a.Type < data_b.Type;
  end
  table.sort(recvTable["PropertyArray"],sort);

  if HeroProPopupMediator then
    local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
    if heroProPopupMediator then
      heroProPopupMediator:getViewComponent():refreshXilianchenggong({GeneralId=recvTable["GeneralId"],ItemId=recvTable["ItemId"],PropertyArray=recvTable["PropertyArray"]});
    end
  end
end


Handler_10_4.new():execute();