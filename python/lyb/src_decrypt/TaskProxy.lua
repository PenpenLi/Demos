
--	Copyright @2009-2013 www.happyelements.com, all rights reserved.

require "main.config.TaskConstConfig";

TaskProxy=class(Proxy);

function TaskProxy:ctor()
  self.class=TaskProxy;

  
  self.tasks = {};
  self.afterBattle = nil;
end

--龙骨
function TaskProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("task_ui");
  end
  return self.skeleton;
end


function TaskProxy:refreshTaskData(data)
  local task=self:getTaskDataByID(data.ID);
  if task then
    task.TaskState=data.TaskState;
    task.TaskConditionArray=data.TaskConditionArray;
  else
    error("");
  end
end

function TaskProxy:getTaskDataByID(id)
  for k,v in pairs(self.tasks) do
    if id==v.ID then
      return v;
    end
  end
end
function TaskProxy:removeTaskDataByID(id)
  for k,v in pairs(self.tasks) do
    if id==v.ID then
      self.tasks[k] = nil;
      break;
    end
  end
end
--
function TaskProxy:getModalDialogSkeleton()
  if nil == self.ModalDialogSkeleton then
    self.ModalDialogSkeleton = SkeletonFactory.new();
    self.ModalDialogSkeleton:parseDataFromFile("modalDialog_ui");
  end
  return self.ModalDialogSkeleton;
end
--
function TaskProxy:getTaskData(id)
  local key = "key" .. id;
  return self.tasks[key];
end

function TaskProxy:getEverydayTaskData()
  for k,v in pairs(self.tasks) do
    if TaskConstConfig.RICHANG_TASK_TYPE_ID==v.MainType then
      return v;
    end
  end
end

function TaskProxy:getCanGetAwardTaskCount()
  local count = 0;
  for k,v in pairs(self.tasks) do
    if 3==v.TaskState and v.MainType == 3 then
      count = count + 1;
    end
  end
  return count;
end

rawset(TaskProxy,"name","TaskProxy");
