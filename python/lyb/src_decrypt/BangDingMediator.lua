require "main.view.huoDong.ui.BangDingPopup";
BangDingMediator=class(Mediator);

function BangDingMediator:ctor()
  self.class = BangDingMediator;
  
end

rawset(BangDingMediator,"name","BangDingMediator");

function BangDingMediator:initialize()
    self.viewComponent=BangDingPopup.new();
    self:getViewComponent():initialize();
end

function BangDingMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("BangDingClose", self.onBangDingClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
end


function BangDingMediator:refreshData(count, booleanValue)
 self:getViewComponent():refreshData(count, booleanValue);
end


function BangDingMediator:onBangDingClose(event)
  self:sendNotification(BangDingNotification.new(BangDingNotifications.BANG_DING_CLOSE));
end

function BangDingMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
