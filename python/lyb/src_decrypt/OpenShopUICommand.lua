OpenShopUICommand=class(Command);

function OpenShopUICommand:ctor()
	self.class=OpenShopUICommand;
end

function OpenShopUICommand:execute(notification)
  require "main.model.ShopProxy";
	require "main.view.shop.ShopMediator";
	require "main.controller.command.shop.ShopCloseCommand";
  require "main.controller.command.shop.ItemBuyCommand";

  --ShopMediator
  self.userProxy=self:retrieveProxy(UserProxy.name);
  self.shopProxy=self:retrieveProxy(ShopProxy.name);
  self.bagProxy=self:retrieveProxy(BagProxy.name);
  
  self.notification = notification;
  local itemId =  notification.data and notification.data.itemId or nil
  self.shopMed=self:retrieveMediator(ShopMediator.name);  
  if nil==self.shopMed then
    self.shopMed=ShopMediator.new();

    self:registerMediator(self.shopMed:getMediatorName(),self.shopMed);
        
    self.shopMed:setShopPageAndType(itemId, notification:getData().Type);

    self:registerShopCommands();
  end

   self:observe(ShopCloseCommand);
   LayerManager:addLayerPopable(self.shopMed:getViewComponent());
    
    hecDC(3,20,1)

end

function OpenShopUICommand:registerShopCommands()
  self:registerCommand(ShopNotifications.SHOP_UI_CLOSE, ShopCloseCommand);
  self:registerCommand(ShopNotifications.ITEM_BUY,ItemBuyCommand);
end
