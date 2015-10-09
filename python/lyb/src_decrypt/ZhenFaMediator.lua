require "main.view.zhenFa.ui.ZhenFaPopup";
ZhenFaMediator=class(Mediator);

function ZhenFaMediator:ctor()
  self.class = ZhenFaMediator;
  
end

rawset(ZhenFaMediator,"name","ZhenFaMediator");

function ZhenFaMediator:initialize()
    self.viewComponent=ZhenFaPopup.new();
    self:getViewComponent():initialize();
end

function ZhenFaMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("ZhenFaClose", self.onZhenFaClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self)
  self:getViewComponent():addEventListener("TO_VIP",self.onToVip,self);
  self:getViewComponent():addEventListener("TO_DIANJINSHOU",self.onToDianjinshou,self);  
end

function ZhenFaMediator:onToVip(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function ZhenFaMediator:onToDianjinshou(event)
  log("onToDianjinshou")
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI, {showCurrency = true}));
end

function ZhenFaMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end

function ZhenFaMediator:refreshData(ID, Level)
 self:getViewComponent():refreshData(ID, Level);
end

function ZhenFaMediator:onZhenFaClose(event)
  self:sendNotification(ZhenFaNotification.new(ZhenFaNotifications.ZHEN_FA_CLOSE));
end

function ZhenFaMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
