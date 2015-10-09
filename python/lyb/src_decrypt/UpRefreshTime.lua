
UpRefreshTime = class(Object);

-- 构造函数
function UpRefreshTime:ctor()
        self.class = UpRefreshTime;
        --self.TIME_STRING = "00 : 00 : 00";
        self.totalTime = nil;
        self.timerHandler = nil;
        self.backFun = nil;
        self.timeType = nil;
end

-- 销毁对象
function UpRefreshTime:dispose()
        self.context=nil;
        self.backFun=nil;
        if self.timerHandler then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
        end
        UpRefreshTime.superclass.dispose(self);
end

--1为默认效果，2为去空格的效果，3为只有分钟和秒效果。timeType
function UpRefreshTime:initTime(time, fun, context,timeType)
        if time == nil then return end;
        self.timeType = timeType and timeType or 1;
        self.totalTime = 0;
        self.endTime = time;
        self.standardTime = os.time();
        self.context=context;
        self.backFun = fun;
        self:startTimer();
end

function UpRefreshTime:getTotalTime()
  return self.totalTime;
end

function UpRefreshTime:setEndTime(endTime,timeType)
  self.endTime = endTime
  self.standardTime = os.time();
  self.timeType = timeType and timeType or 1;
end

function UpRefreshTime:startTimer()
      local function timerLoop()
          if self.totalTime > self.endTime then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
          end
          self.totalTime = os.time() - self.standardTime;
          self.totalTime = self.totalTime <= self.endTime and self.totalTime or self.endTime
          if self.backFun ~= nil then
              self.backFun(self.context);
          end
      end
			self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
        
end

function UpRefreshTime:getTimeStr()
      
      local tempTime = self.totalTime;
			local maxTime = 0;
			local midTime = 0;
			local minTime = 0;
			
			if tempTime >= 60 * 60 then
				maxTime = math.floor(tempTime / (60 * 60));
        local num1 = tempTime - maxTime * 60 * 60;
				tempTime = num1;
			end
			if tempTime >= 60 then
				midTime = math.floor(tempTime / 60);
        local num2 = tempTime - midTime * 60;
				tempTime = num2;
      end
      minTime = tempTime;
			if minTime >= 0 then
        local timeString;
        if self.timeType == 1 then
           timeString = self:analyticalTime(maxTime) .. " : " .. self:analyticalTime(midTime) .. " : " .. self:analyticalTime(minTime);
        elseif self.timeType == 2 then
           timeString = self:analyticalTime(maxTime) .. ":" .. self:analyticalTime(midTime) .. ":" .. self:analyticalTime(minTime);
        elseif self.timeType == 3 then
           timeString = self:analyticalTime(midTime) .. ":" .. self:analyticalTime(minTime);
        end
				return timeString;
			end
      local timeString;
      if self.timeType == 1 then
           timeString = "00 : 00 : 00";
      elseif self.timeType == 2 then
           timeString = "00:00:00";
      elseif self.timeType == 3 then
           timeString = "00:00";
      end
			return timeString;
end

function UpRefreshTime:analyticalTime(num)
      local strOne;
			if num == 0 then 
        strOne = "00" ;
        return strOne;
      end
      
			if 10 > num and num > 0 then 
        strOne = "0" .. num;
        return strOne;
      end
			if num > 9 then 
        strOne = num;
        return strOne;
      end
			return num;
end


