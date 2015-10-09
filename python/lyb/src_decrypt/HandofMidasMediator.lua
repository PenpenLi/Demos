require "main.view.handofMidas.ui.HandofMidasUI";

HandofMidasMediator = class(Mediator)

function HandofMidasMediator:ctor()
	self.class = HandofMidasMediator
end

rawset(HandofMidasMediator,"name","HandofMidasMediator")

function HandofMidasMediator:onRegister()
	self.viewComponent = HandofMidasUI.new()
	self.viewComponent:initialize();
	self.viewComponent:addEventListener("CLOSE_HAND_OF_MIDAS", self.onClose, self)
	self.viewComponent:addEventListener("OPEN_VIP_UI", self.onoOpenVipUi, self)
end
function HandofMidasMediator:refreshData(count)
  self.viewComponent:refreshData(count);
end

function HandofMidasMediator:setBaojiEffect(type)
	self.viewComponent:setBaojiEffect(type)
end

function HandofMidasMediator:setShowCurrency(bool)
	self.viewComponent:setShowCurrency(bool)
end

function HandofMidasMediator:onoOpenVipUi(event)
    self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP)); 
end
function HandofMidasMediator:onClose(event)
  print("onClose");
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_CLOSE_HAND_OF_MIDAS_UI));
end

function HandofMidasMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  end
end
