
-- Copyright @2009-2013 www.happyelements.com, all rights reserved.
-- Create date: 2013-2-19

-- yanchuan.xie@happyelements.com


Handler_3_7 = class(MacroCommand);

function Handler_3_7:execute()
  log("Handler_3_7");
  local timerArray = recvTable["TimerArray"];
  for k,v in pairs(timerArray) do
      local value = v["Value"];
      local timerType = v["TimerType"];
      print("Handler_3_7..",value,timerType);
      
      local typeArr = StringUtils:lua_string_split(timerType, "_");
      local bigType = tonumber(typeArr[1]);
      if bigType == GameConfig.USER_CDTIME_TYPE_1 then
        log("Handler_3_7---jjc timer==="..value);
        self:handleArea(value);
      elseif bigType == GameConfig.USER_CDTIME_TYPE_2 then
        log("Handler_3_7---shilian timer==="..value);
        self:handleTreasury(tonumber(typeArr[2]),value);
      end
  end
end

function Handler_3_7:handleArea(value)
    local arenaProxy = self:retrieveProxy(ArenaProxy.name);

    arenaProxy:setTimeValue(value)

    -- timer
    if arenaProxy.arenTimer then
      Director:sharedDirector():getScheduler():unscheduleScriptEntry(arenaProxy.arenTimer)
      arenaProxy.arenTimer = nil
    end
    local function timerFun()
      value = value - 1
      arenaProxy:setTimeValue(value)
      if value <= 0 then
        if arenaProxy.arenTimer then
          Director:sharedDirector():getScheduler():unscheduleScriptEntry(arenaProxy.arenTimer)
          arenaProxy.arenTimer = nil
        end
        
        self:addSubCommand(ToRefreshReddotCommand);
        self:complete({data={type=FunctionConfig.FUNCTION_ID_26}});         
      end
    end

    arenaProxy.arenTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerFun, 1, false)

    -- local arenaMediator=self:retrieveMediator(ArenaMediator.name);
    -- if arenaMediator then
    --     arenaMediator:refreshTimeData();
    -- end
      
    self:addSubCommand(ToRefreshReddotCommand);
    self:complete({data={type=FunctionConfig.FUNCTION_ID_26}}); 

end

function Handler_3_7:handleTreasury(type,value)
    local treasuryMediator = self:retrieveMediator(TreasuryMediator.name);
    if nil~=treasuryMediator then
         treasuryMediator:refreshRemainSeconds(type,value);
    end
end
Handler_3_7.new():execute();