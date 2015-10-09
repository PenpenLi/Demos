
-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-2-19

-- yanchuan.xie@happyelements.com


require "main.model.ItemUseQueueProxy";
require "main.controller.command.bagPopup.BagFullEffectCommand";

Handler_9_7 = class(MacroCommand);

function Handler_9_7:execute()
  local userProxy = self:retrieveProxy(UserProxy.name);
  for k,v in pairs(recvTable["ItemUseQueue"]) do
    print("");
    for k_,v_ in pairs(v) do
      print(".9.7.",k_,v_);
    end
  end
  
  local itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  itemUseQueueProxy:refresh(recvTable["ItemUseQueue"]);
  
  if BagPopupMediator then
    --BagPopupMediator
    local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
    if nil~=bagPopupMediator then
      bagPopupMediator:refreshBagPlace(itemUseQueueProxy);
    end
  end



  self:addSubCommand(BagFullEffectCommand);
  self:complete();
end

Handler_9_7.new():execute();