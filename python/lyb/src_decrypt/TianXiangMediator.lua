require "main.view.tianXiang.ui.TianXiangPopup";

TianXiangMediator=class(Mediator);

function TianXiangMediator:ctor()
  self.class = TianXiangMediator;
end


rawset(TianXiangMediator,"name","TianXiangMediator");
function TianXiangMediator:initialize()
    self.viewComponent=TianXiangPopup.new();
    self:getViewComponent():initialize()
end


function TianXiangMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("TianXiangClose", self.onTianXiangClose, self);
  self:getViewComponent():addEventListener("ON_BUTTON_GO", self.onButtonGo, self);
  self:getViewComponent():addEventListener("ON_QIAN_ZHUANG", self.onQianZhuan, self);
end

function TianXiangMediator:refreshNoTaskData(taskCount,itemCount)
  self:getViewComponent():refreshNoTaskData(taskCount,itemCount);
end
function TianXiangMediator:setData()
  self:getViewComponent():setData();
end
function TianXiangMediator:refreshData(bool)
  self:getViewComponent():refreshData(bool);
end

function TianXiangMediator:onTianXiangClose(event)
  --self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))

  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.CLOSE_TIANXIANG_UI_COMMAND));
end
function TianXiangMediator:onQianZhuan(event)
  self:sendNotification(MainSceneNotification.new(MainSceneNotifications.TO_OPEN_HAND_OF_MIDAS_UI));
end
function TianXiangMediator:onButtonGo(event)

  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function TianXiangMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end

   


