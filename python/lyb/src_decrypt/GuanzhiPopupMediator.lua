require "main.view.guanzhi.ui.GuanzhiPopup";

GuanzhiPopupMediator=class(Mediator);

function GuanzhiPopupMediator:ctor()
  self.class=GuanzhiPopupMediator;
	self.viewComponent=GuanzhiPopup.new();
end

rawset(GuanzhiPopupMediator,"name","GuanzhiPopupMediator");

function GuanzhiPopupMediator:onClose(event)
  self:sendNotification(GuanzhiNotification.new(GuanzhiNotifications.GUANZHI_CLOSE, event.data));
end

function GuanzhiPopupMediator:refresh(idCountArray)
  self:getViewComponent():refresh(idCountArray);
end

function GuanzhiPopupMediator:refreshUpdate()
  self:getViewComponent():refreshUpdate();
end

function GuanzhiPopupMediator:onRegister()
  self:getViewComponent():addEventListener(GuanzhiNotifications.GUANZHI_CLOSE,self.onClose,self);
end

function GuanzhiPopupMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end