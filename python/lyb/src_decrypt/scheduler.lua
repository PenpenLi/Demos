-- --
-- 	Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- 	Create date: 2013-2-26

-- 	yanchuan.xie@happyelements.com


local scheduler={};
local scheID=0;
local scheduler_func={};

function addSchedule(context, func)
  local a={context,func};
  table.insert(scheduler,a);
end

local function onSche()
  local s=copyTable(scheduler);
  for k,v in pairs(s) do
    v[2](v[1]);
  end
end

function removeSchedule(context, func)
  for k,v in pairs(scheduler) do
    if context==v[1] and func==v[2] then
      table.remove(scheduler,k);
      return;
    end
  end
end

function startupSchedule()
  scheID=CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(onSche,0,false);
end

function stopSchedule()
  CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(scheID);
end

function scheduleUpdateForTarget(scheduler,num,bool)
  CCDirector:sharedDirector():getScheduler():scheduleUpdateForTarget(scheduler,num,bool);
end

function schedulerFunction(context, func, num)
  table.insert(scheduler_func,{context=context,func=func,num=num});
end

function removeScheduleFunction(context)
  for k,v in pairs(scheduler_func) do
    if context == v.context then
      table.remove(scheduler_func,k);
      return removeScheduleFunction(context, func);
    end
  end
end

function disposeAllScheduler()
  stopSchedule();
  scheduler={};
  scheduler_func={};
  scheID=0;
end