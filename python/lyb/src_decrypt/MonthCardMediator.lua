require "main.view.monthCard.ui.MonthCardPopup";
MonthCardMediator=class(Mediator);

function MonthCardMediator:ctor()
  self.class = MonthCardMediator;
  
end

rawset(MonthCardMediator,"name","MonthCardMediator");

function MonthCardMediator:initialize()
    self.viewComponent=MonthCardPopup.new();
    self:getViewComponent():initialize();
end

function MonthCardMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("MonthCardClose", self.onMonthCardClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
end


function MonthCardMediator:refreshData(count, booleanValue)
 self:getViewComponent():refreshData(count, booleanValue);
end


function MonthCardMediator:onMonthCardClose(event)
  self:sendNotification(MonthCardNotification.new(MonthCardNotifications.MONTH_CARD_CLOSE));
end

function MonthCardMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end

