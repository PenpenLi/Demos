require "main.view.firstPay.ui.FirstPayPopup";
FirstPayMediator=class(Mediator);

function FirstPayMediator:ctor()
  self.class = FirstPayMediator;
  
end

rawset(FirstPayMediator,"name","FirstPayMediator");

function FirstPayMediator:initialize()
    self.viewComponent=FirstPayPopup.new();
    self:getViewComponent():initialize(self);
end

function FirstPayMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("FirstPayClose", self.onFirstPayClose, self);
  self:getViewComponent():addEventListener("FirstPayToChongZhi", self.FirstPayToChongZhi, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
end

function FirstPayMediator:refreshData(data)
 self:getViewComponent():refreshData(data);
end

function FirstPayMediator:FirstPayToChongZhi()
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end


function FirstPayMediator:onFirstPayClose(event)
  self:sendNotification(FirstPayNotification.new(FirstPayNotifications.FIRST_PAY_CLOSE));
end

function FirstPayMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end

function FirstPayMediator:onItemTip(event)
  print("function FirstPayMediator:onItemTip()")
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end