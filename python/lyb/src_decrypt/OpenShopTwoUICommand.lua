OpenShopTwoUICommand=class(Command);

function OpenShopTwoUICommand:ctor()
  self.class=OpenShopTwoUICommand;
end

function OpenShopTwoUICommand:execute(notification)
  require "main.view.shopTwo.ShopTwoMediator";
  require "main.controller.command.shopTwo.ShopTwoCloseCommand";

 local shopType = notification.data and notification.data.shopType or nil
 local itemId =  notification.data and notification.data.itemId or nil
  self.shopTwoMed=self:retrieveMediator(ShopTwoMediator.name);
  if nil==self.shopTwoMed then
    self.shopTwoMed=ShopTwoMediator.new();

    self:registerMediator(self.shopTwoMed:getMediatorName(),self.shopTwoMed);
        
    self.shopTwoMed:initializeUI(shopType, itemId);

    self:registerShopTwoCommands();
  end

   self:observe(ShopTwoCloseCommand);
   LayerManager:addLayerPopable(self.shopTwoMed:getViewComponent());
   hecDC(3,14,1)


end

function OpenShopTwoUICommand:registerShopTwoCommands()
  self:registerCommand(ShopTwoNotifications.SHOPTWO_UI_CLOSE, ShopTwoCloseCommand);

end
