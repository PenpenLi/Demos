 require "main.model.ShopProxy";
Handler_24_1 = class(Command);

function Handler_24_1:execute()
  local shopProxy=self:retrieveProxy(ShopProxy.name);
  shopProxy.RemainSeconds = recvTable["Time"];
  shopProxy.IDBooleanArray = recvTable["IDBooleanArray"];
  shopProxy.osTime = os.time();
    


    if ShopTwoMediator then
		local shopTwoMediator = self:retrieveMediator(ShopTwoMediator.name);
		if shopTwoMediator then
			shopTwoMediator:refreshData();
		end
	end	
end




Handler_24_1.new():execute();