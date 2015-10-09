require "main.view.shop.ui.ShopPopup";
ShopMediator=class(Mediator);

function ShopMediator:ctor()
  self.class = ShopMediator;
	
end

rawset(ShopMediator,"name","ShopMediator");

function ShopMediator:initialize()
    self.viewComponent=ShopPopup.new();
    self:getViewComponent():initialize();
end

function ShopMediator:flipByItemID(itemID, count)
  self:getViewComponent():flipByItemID(itemID, count);
end

function ShopMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("ShopClose", self.onShopClose, self);
  self:getViewComponent():addEventListener("SHOP_ITEM_CLICK", self.onShopItemTap, self);
  self:getViewComponent():addEventListener("CLOSETIP", self.closeTip, self);
end

function ShopMediator:setShopPageAndType(itemId, type)
  self:getViewComponent():setShopPageAndType(itemId, type)
end
function ShopMediator:refreshData(ifsetpage)
 self:getViewComponent():refreshData(ifsetpage);
end

function ShopMediator:onShopItemTap(event)
  -- local itemId = event.data;
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function ShopMediator:onShopClose(event)
  
  self:sendNotification(ShopNotification.new(ShopNotifications.SHOP_UI_CLOSE));
end

function ShopMediator:onRemove()
	if self:getViewComponent().parent then
		self:getViewComponent().parent:removeChild(self:getViewComponent());	
	end
end

function ShopMediator:closeTip()
    self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))
end