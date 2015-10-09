require "main.view.vip.ui.VipPopup";

VipMediator=class(Mediator);

function VipMediator:ctor()
	self.class = VipMediator;
	self.viewComponent=VipPopup.new();
end

rawset(VipMediator,"name","VipMediator");

function VipMediator:intializeVipUI()
 
end

function VipMediator:onRegister()
    self:getViewComponent():addEventListener("closeNotice",self.onVipClose,self);
    self:getViewComponent():addEventListener("TO_PAY_COMMOND",self.onVipPayCommand,self);
end

function VipMediator:onVipClose(event)
	self:sendNotification(VipNotification.new(VipNotifications.VIP_CLOSE_COMMAND));
end

function VipMediator:onVipPayCommand(event)

	self:sendNotification(VipNotification.new(VipNotifications.TO_PLATFORM_PAY,event.data));
end

function VipMediator:onUpdateView()
	self.viewComponent:onUpdateView();
end

function VipMediator:onRemove()
  if self:getViewComponent().parent then
     self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end