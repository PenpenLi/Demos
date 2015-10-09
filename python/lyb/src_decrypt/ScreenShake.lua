-----------
--ScreenShake
-----------

ScreenShake = {};

function ScreenShake:initShake()
      self.battleScene = sharedBattleLayerManager().layer;
      self.shakeArr = {};
      self.updateHandleIndex = -1
      self.sourceX = self.battleScene:getPositionX()
      self.sourceY = self.battleScene:getPositionY()
end

local function updateHandle()
      if ScreenShake.isStopTimer then return end
      local value = ScreenShake.shakeArr;
      if not value then return;end;
      local spt = value[1];
      if not spt then return;end;
      if not spt.sprite then return;end;
      local data = value[2];
      local isShakeBool = false;
      if not data then return;end; 
      if data[3] > 0 then
          if spt:getPositionX() ~= ScreenShake.sourceX then
              spt:setPositionX(ScreenShake.sourceX);
          else
               local num = math.random(2);
               num = math.random(2) == 1 and 1 or -1;
               spt:setPositionX(ScreenShake.sourceX + num*data[1]);
          end
          data[3] = data[3] - 1;
          isShakeBool = true;
      end
      
      if data[4] > 0 then
          if spt:getPositionY() ~= ScreenShake.sourceY then
              spt:setPositionY(ScreenShake.sourceY);
          else
               local num = math.random(2);
               num = math.random(2) == 1 and 1 or -1;
               spt:setPositionY(num*data[2]+ScreenShake.sourceY);
          end
          data[4] = data[4] - 1;
          isShakeBool = true;
      end
      
      if not isShakeBool then
          ScreenShake:removeIndex();
      end
end

function ScreenShake:setStopTimer(bool)
    self.isStopTimer = bool
end

--------------
--1为上下震动,2为左右震动,3为上下左右震动
--------------
function ScreenShake:shakeStart(typeId,backFun)
      -- if self.limitTimer then return;end;
      -- typeId = typeId and typeId or BattleConfig.SHAKE_SCREEN_3
      -- local num1;local num2;
      -- local speedX = 12;local speedY = 12;
      -- if typeId == BattleConfig.SHAKE_SCREEN_1 then
      --     num1 = 15;
      --     num2 = 0;
      -- elseif typeId == BattleConfig.SHAKE_SCREEN_2 then
      --     num1 = 0;
      --     num2 = 15;
      -- elseif typeId == BattleConfig.SHAKE_SCREEN_3 then
      --     num1 = 15;
      --     num2 = 15;
      -- elseif typeId == BattleConfig.SHAKE_SCREEN_4 then
      --     num1 = 15;
      --     num2 = 15;
      --     speedX = 4;
      --     speedY = 4;
      -- elseif typeId == BattleConfig.SHAKE_SCREEN_5 then
      --     num1 = 15;
      --     num2 = 15;
      --     speedX = 9;
      --     speedY = 9;
      -- end
      -- self.shakeArr[1] = self.battleScene;
      -- --分别为x速度,y速度,x方向震动次数,y方向震动次数
      -- self.shakeArr[2] = {speedX,speedY,num1,num2};
      -- if -1 == self.updateHandleIndex  then
      --   self.updateHandleIndex = Director:sharedDirector():getScheduler():scheduleScriptFunc(updateHandle, 0, false);
      -- end
      -- self.backFun = backFun
end

--分别为x速度,y速度,x方向震动次数,y方向震动次数
function ScreenShake:generalShake(shakeObj,spd1,spd2,num1,num2)
    self.shakeArr = {};
    self.updateHandleIndex = -1
    self.shakeArr[1] = shakeObj;
    self.sourceX = shakeObj:getPositionX()
    self.sourceY = shakeObj:getPositionY()
    self.shakeArr[2] = {spd1,spd2,num1,num2};
    if -1 == self.updateHandleIndex  then
        self.updateHandleIndex = Director:sharedDirector():getScheduler():scheduleScriptFunc(updateHandle, 0, false);
    end
end

function ScreenShake:removeIndex()
        if not self.shakeArr[1] then return;end
        self.shakeArr[1]:setPositionXY(self.sourceX,self.sourceY);
        if -1 ~=  ScreenShake.updateHandleIndex then
           self:removeTimer()
           self:removeLimitTimer()
           local function limitTimerFun()
             self:removeLimitTimer()
           end
           self.limitTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(limitTimerFun, 0.1, false);
           ScreenShake.updateHandleIndex = -1
        end
        self.shakeArr = {};
        if self.backFun then
          self.backFun()
        end
end

function ScreenShake:stopShake()
    --self.isStopping = true
    self:removeIndex()
end

function ScreenShake:dispose()
      self:removeTimer()
      self.battleScene = nil
      self.shakeArr = {};
      self.battleScene = nil
end

function ScreenShake:removeLimitTimer()
  if self.limitTimer then
    Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.limitTimer);
    self.limitTimer = nil;
  end
end

function ScreenShake:removeTimer()
  if self.updateHandleIndex then
    Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.updateHandleIndex);
    self.updateHandleIndex = nil;
  end
end
