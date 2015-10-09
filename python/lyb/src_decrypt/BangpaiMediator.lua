require "main.view.family.bangPai.BangpaiPopup";

BangpaiMediator=class(Mediator);

function BangpaiMediator:ctor()
  self.class=BangpaiMediator;
	self.viewComponent=BangpaiPopup.new();
end

rawset(BangpaiMediator,"name","BangpaiMediator");

function BangpaiMediator:onClose(event)
  self:sendNotification(FamilyNotification.new(FamilyNotifications.FAMILY_CLOSE));
end

function BangpaiMediator:onTuichu()
	self:getViewComponent():onTuichu();
end

function BangpaiMediator:onRegister()
  self:getViewComponent():addEventListener(FamilyNotifications.FAMILY_CLOSE,self.onClose,self);
end

function BangpaiMediator:onRemove()
	if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end