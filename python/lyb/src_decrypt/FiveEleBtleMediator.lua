require "main.view.fiveElementsBattle.ui.FiveEleBtlePopup";
FiveEleBtleMediator=class(Mediator);
function FiveEleBtleMediator:ctor()
	self.class = FiveEleBtleMediator;
	self.viewComponent=FiveEleBtlePopup.new();
end

rawset(FiveEleBtleMediator,"name","FiveEleBtleMediator");

function FiveEleBtleMediator:intializeUI()
 
end

function FiveEleBtleMediator:onRegister()
    self:getViewComponent():addEventListener("closeNotice",self.onClose,self);
    self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
    self:getViewComponent():addEventListener("ON_SHOW_VIP", self.onShowVip, self);
    self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.openSubNotice, self);
end
function FiveEleBtleMediator:onShowVip(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end
function FiveEleBtleMediator:openSubNotice(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end
function FiveEleBtleMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end
function FiveEleBtleMediator:onClose(event)
	self:sendNotification(FiveEleBtleNotification.new(FiveEleBtleNotifications.FIVEELEBTLE_CLOSE_COMMAND));
end
function FiveEleBtleMediator:refreshCountData()
   self:getViewComponent():refreshCountData();
end
function FiveEleBtleMediator:onRemove()
  if self:getViewComponent().parent then
     self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end