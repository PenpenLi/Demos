require "main.view.mainScene.functionOpen.FunctionOpenPopup";

FunctionOpenMediator = class(Mediator)

function FunctionOpenMediator:ctor()
	self.class = FunctionOpenMediator
	self.viewComponent = FunctionOpenPopup.new()
end

rawset(FunctionOpenMediator,"name","FunctionOpenMediator")

function FunctionOpenMediator:onRegister()

  self:getViewComponent():initialize();
  self:getViewComponent():addEventListener("CLOSE_FUNCTION_OPEN_UI", self.onFunctionUIClose, self);

end

function FunctionOpenMediator:initializeUI(functionId, functionData, tutorData)
  self.viewComponent:initializeUI(functionId, functionData, tutorData);
end

function FunctionOpenMediator:onFunctionUIClose(event)
  self:getViewComponent():closeUI()
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_CLOSE_FUNCTION_OPEN_UI));
end
function FunctionOpenMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
end
