
require "main.view.bag.BagPopupMediator";
require "main.model.BagProxy";
require "main.model.GeneralListProxy";

Handler_6_4 = class(Command);

function Handler_6_4:execute()
  --BagPopupMediator
  local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
  local generalListProxy=self:retrieveProxy(GeneralListProxy.name);
  local bagProxy=self:retrieveProxy(BagProxy.name);
  local replaceEquipmentArray = recvTable["ReplaceEquipmentArray"];
  print(".6_4..");
  for k,v in pairs(replaceEquipmentArray) do
    print("");
    for k_,v_ in pairs(v) do
      print(".6_4...",k_,v_);
    end
  end
  generalListProxy:refreshUsingEquipmentArray(recvTable["ReplaceEquipmentArray"]);
  if nil~=bagPopupMediator then
    bagPopupMediator:refreshAvatarFigure(generalListProxy,bagProxy);
  end
end

Handler_6_4.new():execute();