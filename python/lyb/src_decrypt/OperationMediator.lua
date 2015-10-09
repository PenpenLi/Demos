require "main.view.mainScene.operation.ui.OperationUI";

OperationMediator = class(Mediator)

function OperationMediator:ctor()
	self.class = OperationMediator
	self.viewComponent = OperationUI.new()
end

rawset(OperationMediator,"name","OperationMediator")

function OperationMediator:onRegister()
	self.viewComponent:addEventListener("TURN_ON_OFF",self.onClickOperation,self);
	self.viewComponent:addEventListener("CLICK_RETURN_BUTTON",self.onClickReturnButton,self);
	self.viewComponent:addEventListener("REMOVE_OPERATION",self.onRemoveOperation,self);
	self.viewComponent:addEventListener("ON_OPEN_FUNCTION",self.onOpenFunction,self);

	self.viewComponent:addEventListener("TO_VIP",self.onToVip,self);
	self.viewComponent:addEventListener("TO_HUANHUA",self.onToHuanHua,self);
end
function OperationMediator:onOpenFunction(event)
	local data = event.data
	local id = data["functionid"]
	self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,{functionid = id}));
end
function OperationMediator:onClickOperation(event)

	local data = event.data
	local id = data["id"]
	local display = data["display"]
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPERATION_RECORD,{id = id,display = display}));
end

function OperationMediator:onRemoveOperation(event)
   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_REMOVE_OPERATION));
end

function OperationMediator:refreshMainRole()
	self.viewComponent:refreshMainRole()
end

-- function OperationMediator:setData(dataTable)
-- 	self.viewComponent:setData(dataTable)
-- end

function OperationMediator:onInit(skeleton)

end


function OperationMediator:onClickReturnButton()
	self.viewComponent:closeUI()
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.viewComponent)
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.backUI)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPERATION_RECORD));
end

function OperationMediator:refreshData(display)
	self.viewComponent:refreshData(display)
end

function OperationMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
  	if self.backUI and self.backUI.parent then
  		self.backUI.parent:removeChild(self.backUI)
  	end
end

function OperationMediator:onToVip()
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_VIP));
end

function OperationMediator:onToHuanHua(event)
		print("function ToOperationCommand:execute()22")
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_HUANHUA_UI_COMMAND));
end
function OperationMediator:refreshName()
	self:getViewComponent():refreshName()
end
