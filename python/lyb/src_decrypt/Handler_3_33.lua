

Handler_3_33 = class(MacroCommand);

function Handler_3_33:execute()
  require "main.model.ShopProxy";
  require "main.view.mainScene.MainSceneMediator";
  require "main.controller.command.mainScene.MainSceneToFundCommand"

  print("=(3,33)return=============",recvTable["RemainSeconds"],recvTable["IDBooleanArray"])

  local shopProxy=self:retrieveProxy(ShopProxy.name);
  shopProxy.RemainSeconds = recvTable["RemainSeconds"];
  shopProxy.IDBooleanArray = recvTable["IDBooleanArray"];
  shopProxy.osTime = os.time();


  --todo 假数据，测试用
  --table.insert(shopProxy.IDBooleanArray,{ID=141,BooleanValue=0})
  --table.insert(shopProxy.IDBooleanArray,{ID=142,BooleanValue=0})

  for k, v in pairs(shopProxy.IDBooleanArray) do
    print(k,v.ID,v.BooleanValue);
  end

  local shopMediator = self:retrieveMediator(ShopMediator.name)
  if shopMediator then
    shopMediator:refreshShopMystery();
  end


end

Handler_3_33.new():execute();