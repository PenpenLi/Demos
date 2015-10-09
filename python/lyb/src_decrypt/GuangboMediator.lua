require "main.view.mainScene.guangbo.ui.GuangboUI";

GuangboMediator = class(Mediator)

function GuangboMediator:ctor()
	self.class = GuangboMediator
end

rawset(GuangboMediator,"name","GuangboMediator")

function GuangboMediator:onRegister()
	self.viewComponent = GuangboUI.new()
	self.viewComponent:addEventListener("REMOVE_GUANGBO",self.onRemoveGuangbo,self);
end

function GuangboMediator:playGuangbo()
	self.viewComponent:playGuangbo()
end

function GuangboMediator:init(userProxy)
	self.viewComponent:init(userProxy)
end

function GuangboMediator:onRemoveGuangbo(event)
   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REMOVE_GUANGBO));
end

function GuangboMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
  	self:getViewComponent():dispose4End();
end
