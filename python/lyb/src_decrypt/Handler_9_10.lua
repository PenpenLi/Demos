--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_9_10 = class(Command);

function Handler_9_10:execute()
  for k,v in pairs(recvTable["ItemUseQueue"]) do
    print("");
    for k_,v_ in pairs(v) do
      print(".9.7.",k_,v_);
    end
  end
  
  --BagPopupMediator
  local bagPopupMediator=self:retrieveMediator(BagPopupMediator.name);
  local itemUseQueueProxy=self:retrieveProxy(ItemUseQueueProxy.name);
  itemUseQueueProxy:refresh(recvTable["ItemUseQueue"]);
  if nil~=bagPopupMediator then
    bagPopupMediator:refreshBagPlace(itemUseQueueProxy);
  end
end

Handler_9_10.new():execute();