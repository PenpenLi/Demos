Handler_3_31 = class(Command);

function Handler_3_31:execute()
  print(".3.31.",recvTable["Time"]);
  
  local limitTime = recvTable["Time"];
  local tabID = recvTable["Type"];
  local limitShopItemArray = recvTable["LimitShopItemArray"];
  local itemList = {};
  for k,v in pairs(limitShopItemArray)do
    local item = {};
    item.id = v["ID"];
    item.itemid = v["ItemId"];
    item.sort = v["Sort"];
    item.money = v["CurrencyType"];
    item.price = v["Price"];
    item.UserCount = v["UserCount"];
    item.UserMaxCount = v["UserMaxCount"];
    item.TotalLeftCount = v["Count"];
    item.TotalCount = v["MaxCount"];
    item.term = 0; --自己添加的物品爵位限制
    itemList[v["Sort"]] = item;
    for k_,v_ in pairs(v)do
    	print("3.31 item",k_,v_)
    end
  end

  local shopMediator = self:retrieveMediator(ShopMediator.name);
  if not shopMediator then
  	OpenShopUICommand.new():execute({tabID = tabID});
  	shopMediator = self:retrieveMediator(ShopMediator.name);
  end
  shopMediator:updateLimitMall(itemList,limitTime);
  

end

Handler_3_31.new():execute();