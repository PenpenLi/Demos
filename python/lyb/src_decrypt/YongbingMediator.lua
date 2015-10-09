require "main.view.yongbing.YongbingPopup";

YongbingMediator=class(Mediator);

function YongbingMediator:ctor()
  self.class=YongbingMediator;
	self.viewComponent=YongbingPopup.new();
end

rawset(YongbingMediator,"name","YongbingMediator");

function YongbingMediator:onClose(event)
  self:sendNotification(YongbingNotification.new(YongbingNotifications.YONGBING_CLOSE, event.data));
end

function YongbingMediator:onRegister()
  self:getViewComponent():addEventListener(YongbingNotifications.YONGBING_CLOSE,self.onClose,self);
end

function YongbingMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end