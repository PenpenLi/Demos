
RefreshTime = class(Object);

-- 构造函数
function RefreshTime:ctor()
        self.class = RefreshTime;
        --self.TIME_STRING = "00 : 00 : 00";
        self.totalTime = nil;
        self.timerHandler = nil;
        self.backFun = nil;
        self.timeType = nil;
end

-- 销毁对象
function RefreshTime:dispose()
        self.context=nil;
        self.backFun=nil;
        if self.timerHandler then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
        end
        RefreshTime.superclass.dispose(self);
end

--1为默认效果，2为去空格的效果，3为只有分钟和秒效果。timeType
function RefreshTime:initTime(time, fun, context,timeType)
        if time == nil then return end;
        self.timeType = timeType and timeType or 1;
        self.totalTime = time;
        self.standardTime = os.time() + time;
        self.context=context;
        self.backFun = fun;
        self:startTimer();
end

function RefreshTime:getTotalTime()
  return self.totalTime;
end

function RefreshTime:setTotalTime(totalTime,timeType)
  self.totalTime = totalTime;
  self.standardTime = os.time() + totalTime;
  self.timeType = timeType and timeType or 1;
end
--addTime单位为秒
function RefreshTime:addPauseTime(addTime)
  self.standardTime = self.standardTime + addTime
  self.isPause = nil
end

function RefreshTime:pauseTime()
    self.pauseOsTime = os.time()
    self.isPause = true
end

function RefreshTime:resumeTime()
    self.standardTime = self.standardTime + os.time() - self.pauseOsTime
    self.isPause = nil
end

function RefreshTime:startTimer()
      local function timerLoop()
          if self.totalTime <= 0 then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
          end
          self.totalTime = self.standardTime - os.time();
          self.totalTime = self.totalTime >= 0 and self.totalTime or 0
          if self.backFun ~= nil then
              self.backFun(self.context);
          end
      end
			self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
        
end

function RefreshTime:getTimeStr()
      
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
        elseif self.timeType == 4 then
          timeString = self:analyticalTime(minTime);
        end
        if self.isPause then
            return self.timeString
        else
            self.timeString = timeString
            return timeString
        end
			end
      local timeString;
      if self.timeType == 1 then
           timeString = "00 : 00 : 00";
      elseif self.timeType == 2 then
           timeString = "00:00:00";
      elseif self.timeType == 3 then
           timeString = "00:00";
      elseif self.timeType == 4 then
           timeString="00";
      end
      if self.isPause then
          return self.timeString
      else
          self.timeString = timeString
          return timeString
      end
end

function RefreshTime:analyticalTime(num)
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

-------------------以上为时间不暂停,以下为时间暂停用-------------------------

--1为默认效果，2为去空格的效果，3为只有分钟和秒效果。timeType
function RefreshTime:initStopTime(time, fun, context,timeType)
        if time == nil then return end;
        self.timeType = timeType and timeType or 1;
        self.totalTime = time;
        -- self.standardTime = time;
        self.context=context;
        self.backFun = fun;
        self:startStopTimer();
end

function RefreshTime:startStopTimer()
      local function timerLoop()
          if self.totalTime <= 0 then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
          end
          self.totalTime = self.totalTime - 1;
          self.totalTime = self.totalTime >= 0 and self.totalTime or 0
          if self.backFun ~= nil then
              self.backFun(self.context);
          end
      end
      self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
end


-------------------以下为战斗时间暂停用-------------------------
--1为默认效果，2为去空格的效果，3为只有分钟和秒效果。timeType
function RefreshTime:initStopBattleTime(time, fun, context,timeType)
        if time == nil then return end;
        self.timeType = timeType and timeType or 1;
        self.totalTime = time;
        -- self.standardTime = time;
        self.context=context;
        self.backFun = fun;
        self:startStopBattleTimer();
end
function RefreshTime:startStopBattleTimer()
      local function timerLoop()
          if self.totalTime <= 0 then
              Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
          end
          if self.context.battleProxy:isPauseBattle() then
              return 
          end
          if self.context.battleProxy.battleLeftTime == 0 then
              return 
          end
          self.totalTime = math.floor(self.context.battleProxy.battleLeftTime/1000)
          if self.backFun ~= nil then
              self.backFun(self.context);
          end
      end
      self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
end