require "main.view.huiGu.ui.HuiGuPopup";
HuiGuMediator=class(Mediator);
function HuiGuMediator:ctor()
	self.class = HuiGuMediator;
	self.viewComponent=HuiGuPopup.new();
end

rawset(HuiGuMediator,"name","HuiGuMediator");

function HuiGuMediator:intializeUI()
 
end

function HuiGuMediator:onRegister()
    self:getViewComponent():addEventListener("closeNotice",self.onClose,self);
    self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
    self:getViewComponent():addEventListener("ON_SHOW_VIP", self.onShowVip, self);
    self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.openSubNotice, self);
end
function HuiGuMediator:onShowVip(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end
function HuiGuMediator:openSubNotice(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end
function HuiGuMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function HuiGuMediator:onClose(event)
	self:sendNotification(HuiGuNotification.new(HuiGuNotifications.HUIGU_CLOSE_COMMAND));
end
function HuiGuMediator:refreshCountData()
   self:getViewComponent():refreshCountData();
end
function HuiGuMediator:onRemove()
  if self:getViewComponent().parent then
     self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end