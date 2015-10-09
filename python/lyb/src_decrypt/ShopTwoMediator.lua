require "main.view.shopTwo.ui.ShopTwoPopup";
ShopTwoMediator=class(Mediator);

function ShopTwoMediator:ctor()
  self.class = ShopTwoMediator;
  
end

rawset(ShopTwoMediator,"name","ShopTwoMediator");

function ShopTwoMediator:initialize()
    self.viewComponent=ShopTwoPopup.new();
    self:getViewComponent():initialize();
end

function ShopTwoMediator:flipByItemID(itemID, count)
  self:getViewComponent():flipByItemID(itemID, count);
end

function ShopTwoMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("ShopTwoClose", self.onShopTwoClose, self);
  self:getViewComponent():addEventListener("SHOPTWO_ITEM_CLICK", self.onShopTwoItemTap, self);
  self:getViewComponent():addEventListener("CLOSETIP", self.closeTip, self);
  self:getViewComponent():addEventListener("gotochongzhi", self.goToChongzhi, self);
  self:getViewComponent():addEventListener("gotodianjin", self.goToDianjin, self);
end

function ShopTwoMediator:initializeUI(shopType, itemId)
    self:getViewComponent():setShopType(shopType, itemId)
end
function ShopTwoMediator:refreshData()
 self:getViewComponent():refreshData();
end
function ShopTwoMediator:refreshData2()
 self:getViewComponent():refreshData2();
end
function ShopTwoMediator:onShopTwoItemTap(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function ShopTwoMediator:goToChongzhi()
    self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end
function ShopTwoMediator:onShopTwoClose(event)
  self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))
  self:sendNotification(ShopTwoNotification.new(ShopTwoNotifications.SHOPTWO_UI_CLOSE));
end
function ShopTwoMediator:goToDianjin(event)

  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=27}));
end
function ShopTwoMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
function ShopTwoMediator:closeTip()
    self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))
end