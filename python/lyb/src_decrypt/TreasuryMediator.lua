
TreasuryMediator=class(Mediator);
function TreasuryMediator:ctor()
	self.class = TreasuryMediator;
	require "main.view.treasury.ui.TreasuryPopup";
	self.viewComponent=TreasuryPopup.new();
end

rawset(TreasuryMediator,"name","TreasuryMediator");

function TreasuryMediator:intializeUI()
 
end

function TreasuryMediator:onRegister()
    self:getViewComponent():addEventListener("closeNotice",self.onClose,self);
    self:getViewComponent():addEventListener(MainSceneNotifications.TO_HEROTEAMSUB, self.openSubNotice, self);
end

function TreasuryMediator:onClose(event)
  self:sendNotification(TreasuryNotification.new(TreasuryNotifications.TREASURY_CLOSE_COMMAND));
end
function TreasuryMediator:openSubNotice(event)

  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HEROTEAMSUB,event.data));
end

function TreasuryMediator:onRemove()
  if self:getViewComponent().parent then
     self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end

function TreasuryMediator:refreshCountData()
	 self:getViewComponent():refreshCountData();
end
function TreasuryMediator:refreshRemainSeconds(type,value)
	self:getViewComponent():refreshRemainSeconds(type,value);
end