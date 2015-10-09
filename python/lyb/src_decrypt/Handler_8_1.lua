


Handler_8_1 = class(MacroCommand)
--如果有需求改这一块代码，请注意代码可读性
function Handler_8_1:execute()

  -- uninitializeSmallLoading()

  local taskProxy = self:retrieveProxy(TaskProxy.name);
  local taskMapArray = recvTable["TaskMapArray"];

  for i_k, i_v in pairs(taskMapArray) do
     print("----------TaskId:" .. i_v.ID .. ", TaskState:" .. i_v.TaskState)--.. " TaskState", i_v.TaskState
     local newTask = false
     local key = "key" .. i_v.ID;
     if i_v.TaskState == 4 then
        taskProxy.tasks[key] = nil;
     else
        if not taskProxy.tasks[key] then
          newTask = true;
        end
        taskProxy.tasks[key] = i_v;
        if TaskConstConfig.MUBIAO_TASK_TYPE_ID == i_v.MainType then
          -- print("@@@@@@@@@@@@@@@@@MUBIAO_TASK TaskId:" .. i_v.ID .. ", TaskState:" .. i_v.TaskState)--.. " TaskState", i_v.TaskState
        elseif TaskConstConfig.RICHANG_TASK_TYPE_ID == i_v.MainType then
          -- print("!!!!!!!!!!!!!!!!!!!!!!RICHANG_TASK TaskId:" .. i_v.ID .. ", TaskState:" .. i_v.TaskState)--.. " TaskState", i_v.TaskState 
        end
     end
     self:refreshData(i_v, newTask);
  end

  if ButtonGroupMediator then
    local med=self:retrieveMediator(ButtonGroupMediator.name);
    if med then
      med:refreshRenwu();
    end
  end
end
function Handler_8_1:refreshData(taskData, newTask)
  if TaskMediator then
    local taskMediator=self:retrieveMediator(TaskMediator.name);
    if taskMediator then
      taskMediator:refreshData(taskData, newTask);
    end
  end
end
Handler_8_1.new():execute();