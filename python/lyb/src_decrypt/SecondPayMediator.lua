require "main.view.secondPay.ui.SecondPayPopup";
SecondPayMediator=class(Mediator);

function SecondPayMediator:ctor()
  self.class = SecondPayMediator;
  
end

rawset(SecondPayMediator,"name","SecondPayMediator");

function SecondPayMediator:initialize()
    self.viewComponent=SecondPayPopup.new();
    self:getViewComponent():initialize(self);
end

function SecondPayMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("SecondPayClose", self.onSecondPayClose, self);
  self:getViewComponent():addEventListener("SecondPayToChongZhi", self.SecondPayToChongZhi, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
  
end

function SecondPayMediator:refreshData(data)
 self:getViewComponent():refreshData(data);
end

function SecondPayMediator:SecondPayToChongZhi()
  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid=2}));
end


function SecondPayMediator:onSecondPayClose(event)
  self:sendNotification(SecondPayNotification.new(SecondPayNotifications.SECOND_PAY_CLOSE));
end

function SecondPayMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end

function SecondPayMediator:onItemTip(event)
  print("function SecondPayMediator:onItemTip()")
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end