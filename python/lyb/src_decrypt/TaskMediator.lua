require "main.view.task.ui.TaskPopup";

TaskMediator=class(Mediator);

function TaskMediator:ctor()
  self.class = TaskMediator;
end


rawset(TaskMediator,"name","TaskMediator");
function TaskMediator:initialize()
    self.viewComponent=TaskPopup.new();
    self:getViewComponent():initialize()
end


function TaskMediator:onRegister()
  self:initialize();
  self:getViewComponent():addEventListener("TaskClose", self.onTaskClose, self);
  self:getViewComponent():addEventListener("ON_BUTTON_GO", self.onButtonGo, self);
end

function TaskMediator:refreshNoTaskData(taskCount,itemCount)
  self:getViewComponent():refreshNoTaskData(taskCount,itemCount);
end
function TaskMediator:setData()
  self:getViewComponent():setData();
end
function TaskMediator:refreshData(taskData, newTask)
  self:getViewComponent():refreshData(taskData, newTask);
end

function TaskMediator:onTaskTap(event)
  local itemId = event.data;
  self:sendNotification(TipNotification.new(TipNotifications.OPEN_TIP_COMMOND, itemId));
end

function TaskMediator:onTaskClose(event)
  --self:sendNotification(TipNotification.new(TipNotifications.REMOVE_TIP_COMMOND))

  self:sendNotification(TaskNotification.new(TaskNotifications.TASK_CLOSE_COMMOND));
end

function TaskMediator:onButtonGo(event)

  self:sendNotification(OpenFunctionNotification.new(OpenFunctionNotifications.OPEN_UI_BY_FUNCTION_ID,event.data));
end

function TaskMediator:onRemove()
  if self:getViewComponent().parent then
    self:getViewComponent().parent:removeChild(self:getViewComponent());  
  end
end

   


