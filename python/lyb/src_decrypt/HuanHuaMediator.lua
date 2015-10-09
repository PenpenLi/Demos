require "main.view.huanHua.ui.HuanHuaUI";

HuanHuaMediator = class(Mediator)

function HuanHuaMediator:ctor()
	self.class = HuanHuaMediator
	self.viewComponent = HuanHuaUI.new()
end

rawset(HuanHuaMediator,"name","HuanHuaMediator")

function HuanHuaMediator:onRegister()

	self.viewComponent:addEventListener("HuanHuaClose", self.onHuanHuaClose,self)
end

function HuanHuaMediator:onHuanHuaClose(event)
   self:sendNotification(MainSceneNotification.new(MainSceneNotifications.CLOSE_HUANHUA_UI_COMMAND));
end

function HuanHuaMediator:setData(dataTable)
	self.viewComponent:setData(dataTable)
end


function HuanHuaMediator:onClickReturnButton()
	self.viewComponent:closeUI()
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.viewComponent)
	sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):removeChild(self.backUI)
	self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPERATION_RECORD));
end

function HuanHuaMediator:refreshData(display)
	self.viewComponent:refreshData(display)
end

function HuanHuaMediator:onRemove()
	if self:getViewComponent().parent then
    	self:getViewComponent().parent:removeChild(self:getViewComponent());
  	end
end

function HuanHuaMediator:refreshHuanHua(IDArray)
	self:getViewComponent():refreshHuanHua(IDArray)
end
