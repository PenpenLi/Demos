require "main.view.qianDao.ui.QianDaoPopup";
QianDaoMediator=class(Mediator);

function QianDaoMediator:ctor()
  self.class = QianDaoMediator;
  
end

rawset(QianDaoMediator,"name","QianDaoMediator");

function QianDaoMediator:initialize()
    self.viewComponent=QianDaoPopup.new();
    self:getViewComponent():initialize();
end

function QianDaoMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("QianDaoClose", self.onQianDaoClose, self);
  self:getViewComponent():addEventListener("ON_ITEM_TIP", self.onItemTip, self);
end

function QianDaoMediator:initializeUI()

end
function QianDaoMediator:refreshData()
 self:getViewComponent():refreshData();
end

function QianDaoMediator:onQianDaoClose(event)
  self:sendNotification(QianDaoNotification.new(QianDaoNotifications.QIANDAO_UI_CLOSE));
end
function QianDaoMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end
function QianDaoMediator:onItemTip(event)
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, event.data));
end