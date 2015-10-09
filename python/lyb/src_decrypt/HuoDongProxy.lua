
HuoDongProxy=class(Proxy);

function HuoDongProxy:ctor()
  self.class=HuoDongProxy;
  self.itemData = {};
  self.redDotTab = {};
  self.havdCharged = false;
  self.hasBindPhone = false;
  self.phoneNum = nil;

  self.huodong_datas={};
  self.IsBuyFund =false;
  --七天乐开启了哪几天
  self.OpenDays = {};
  self.CurrentDays = 1;
  self.SevenDaysRemainSeconds = 0;

  self.IsFirstPay = false;
  -- 活动小红点数据
  self.reddotData = {};

  -- 判断主界面上是否需要显示ICON
  self.IsOpenSevenDays = true;
  self.IsOpenFisrtSecondPay = false;

  self.boolOpenButton = false;

  -- self.timerHandler = nil;

end

rawset(HuoDongProxy,"name","HuoDongProxy");

--龙骨
function HuoDongProxy:getSkeleton()
  if nil==self.skeleton then
	  self.skeleton = SkeletonFactory.new();
	  self.skeleton:parseDataFromFile("huodong_ui");
  end
  return self.skeleton;
end

function HuoDongProxy:setData(tab)
 
  local med = Facade.getInstance():retrieveMediator(MainSceneMediator.name);
  self.med = med;

  for k, v in pairs(tab)do
    if v.ID == 1 and v.Type ~= 1 then
      tab[k].RemainSeconds = os.time()+tab[k].RemainSeconds
      break;
    end
  end
  self.datas=tab
  
  -- add by mohai.wu 七天乐中开启了哪几天,是首充还是累充
  self.OpenDays = {};
  for k,v in pairs(tab) do
    if v.ID > 6 and v.ID < 14 then
      table.insert(self.OpenDays, v.ID);
      self.SevenDaysRemainSeconds = v.RemainSeconds;
    end
    if v.ID == 4 then
      self.IsFirstPay = true;
    end
    if v.ID == 4 or v.ID == 17 then 
      self.IsOpenFisrtSecondPay = true;
    end
  end

  -- 测试用的数据
    -- self.SevenDaysRemainSeconds = 3;
  -- -- self.OpenDays = nil;
  -- self.IsOpenSevenDays = false;
  -- end

  print(" self.OpenDays SevenDaysRemainSeconds = ", self.IsOpenSevenDays, self.SevenDaysRemainSeconds)
  -- 主界面icon是否开启
  if self.OpenDays ~= nil and #self.OpenDays > 0 and self.SevenDaysRemainSeconds > 0 then
    self.IsOpenSevenDays = true;
    self.CurrentDays = #self.OpenDays;
    -- med:openSevenDaysIcon();
  else
    print("=--------------------------close sevendays")
    --关闭主界面七天icon
    self.IsOpenSevenDays = false;
    med:closeButtonsByFunctionID(73)
  end

  if self.IsOpenFisrtSecondPay == false then
    -- 关闭主界面累充Icon
    med:closeButtonsByFunctionID(56);
  end


  -- 刷新七天里面的活动倒计时
  self:updateSevendaysRemainSeconds();
  -- self.IsFirstPay = true;

  print("---------------------------sevendays")
  -- for k,v in pairs(self.OpenDays) do
  --   print(k,v)
  -- end
  -- print("\n\n\n\nself.OpenDays = ", #self.OpenDays, self.CurrentDays);

  -- 判断是首充还是累充
  med:refreshFirstPayToSecondPay(self.IsFirstPay);
  -- med:refreshSevenDaysLogin(self.CurrentDays);


  --创建红点tab,通过维护此tab,确定主界面是否有红点
  print("------------------------------")
  
  for i,v in ipairs(self.datas) do
    if v.ID == 1 or   
        v.ID == 5  or  
        v.ID == 6  or  
        v.ID == 14 or 
        v.ID == 16 then
        -- print("v.ID v.BooleanValue ", v.ID, v.BooleanValue);
      table.insert(self.redDotTab, {ID = v.ID, BooleanValue = v.BooleanValue})
    end

    -- add by mohai.wu 重做小红点数据 BooleanValue = 1 为可以领取
    self.reddotData[v.ID] = v.BooleanValue;
  end
  
  self.boolOpenButton = true;
  local openFunctionProxy = Facade.getInstance():retrieveProxy(OpenFunctionProxy.name);
  med:openButtons(openFunctionProxy:getOpenedHMenu2());

end

function HuoDongProxy:updateSevendaysRemainSeconds()
  local remainTime = self.SevenDaysRemainSeconds;
  if self.SevenDaysRemainSeconds == nil then
    remainTime = 0;
  end
  local day = math.floor(remainTime/ 86400)
  remainTime = remainTime % 86400;
  local hour = math.floor(remainTime/ 3600)
  remainTime = remainTime % 3600;
  local minute = math.floor(remainTime/ 60);
  local second = remainTime % 60;
  if day < 10 then
    day = "0" .. tostring(day);
  end
  if hour < 10 then 
    hour = "0" .. tostring(hour);
  end
  if minute < 10 then 
    minute = "0" .. tostring(minute);
  end
  if second < 10 then
    second = "0" .. tostring(second);
  end
  
  if SevenDaysMediator ~= nil then
    local sevendaysMed = Facade.getInstance():retrieveMediator(SevenDaysMediator.name);
    if sevendaysMed ~= nil then
        sevendaysMed:updateTextDate("活动结束时间："..day.."天"..hour.."小时"..minute.."分"..second.. "秒")
    end
  end
  local function timerLoop(  )
    self.SevenDaysRemainSeconds = self.SevenDaysRemainSeconds - 1;
    local currentTime = os.time();
    local remainTime = self.SevenDaysRemainSeconds;
    local day = math.floor(remainTime/ 86400)
    remainTime = remainTime % 86400;
    local hour = math.floor(remainTime/ 3600)
    remainTime = remainTime % 3600;
    local minute = math.floor(remainTime/ 60);
    local second = remainTime % 60;

    if day + hour + minute + second == 0 then
      --表示活动已经结束
       Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
              self.timerHandler=nil
      if SevenDaysMediator ~= nil then
        local sevendaysMed = Facade.getInstance():retrieveMediator(SevenDaysMediator.name);
        if sevendaysMed ~= nil then
            sevendaysMed:stopSevendays();
        end
      end
      print(" huodong jie su ")
      self.IsOpenSevenDays =  false;
      self.med:closeButtonsByFunctionID(73);
    end

    if day < 10 then
      day = "0" .. tostring(day);
    end
    if hour < 10 then 
      hour = "0" .. tostring(hour);
    end
    if minute < 10 then 
      minute = "0" .. tostring(minute);
    end
    if second < 10 then
      second = "0" .. tostring(second);
    end
    if SevenDaysMediator ~= nil then
    local sevendaysMed = Facade.getInstance():retrieveMediator(SevenDaysMediator.name);
      if sevendaysMed ~= nil then
        sevendaysMed:updateTextDate("活动结束时间："..day.."天"..hour.."小时"..minute.."分"..second.. "秒")
      end
    end
    remainTime = remainTime -1;
  end
  if self.timerHandler == nil then
    self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false);
    print("\n\n\n\n\n\n\n\n\n\n\n\n self.timerHandler", self.timerHandler);
  end
end

function HuoDongProxy:stopHuodongTimer()
  Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
              self.timerHandler=nil
end

function HuoDongProxy:getReddotState(Id, IdTable)
  -- Id 为判断单个小红点状态，IdTable 为判断一组ID中是否存在一个小红点
  if Id ~= nil then
    return self.reddotData[Id];
  end
  local IsVisibleReddot = 0;

  for k,v in pairs(IdTable) do
    if self.reddotData[v] == 1 then
      IsVisibleReddot = 1;
      return IsVisibleReddot;
    end
  end
  return IsVisibleReddot;
end

function HuoDongProxy:getReddotData()
  --获取小红点数据 add by mohai.wu
  return self.reddotData;
end

function HuoDongProxy:setReddotDataByID( ID ,booleanValue)
  --add by mohai.wu 设置小红点状态
  print("function HuoDongProxy:setReddotDataByID( ID ,booleanValue) = ", ID, booleanValue);
  for k,v in pairs(self.reddotData) do
    print(k,v)
  end
  -- 设置某个小红点状态
  -- if self.reddotData[ID] ~= nil then
    self.reddotData[ID] = booleanValue;
  -- end
end

function HuoDongProxy:getData()
  return self.datas
end

function HuoDongProxy:setData2(tab)
  
  local ActivityConditionArray = tab[1]["ActivityConditionArray"];
  local ID = tab[1]["ID"];
  if #ActivityConditionArray == 1 and ID > 6 and ID < 14 then
    -- 开服七天乐
    self.takeAwardData = tab[1]["ActivityConditionArray"];
    return
  else
    self.takeAwardData = nil;
  end
  --id:3七天签到 id:1 冲级有礼 id:2 礼包兑换 id:5 开服基金 id:6全民福利 id:16 VIP 福利
  self.datas2 = tab
  print("HuoDongProxy:setData2 tab = ", tab[1]["ID"])
  self.huodong_datas[tab[1]["ID"]] = tab[1]["ActivityConditionArray"];
  print("self.huodong_datas",self.huodong_datas[tab[1]["ID"]])

end

function HuoDongProxy:gettakeAwardData()
  return self.takeAwardData;
end

function HuoDongProxy:getHuodongDataByID(id)
  return self.huodong_datas[id];
end

function HuoDongProxy:getData2()

  return self.datas2
end

function HuoDongProxy:getRenderData(id)
  for i,v in ipairs(self.datas2) do
    if v.ID == id then
      print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ HuoDongProxy id ",id)
      print("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ HuoDongProxy Activity",v.ActivityConditionArray)
      return v.ActivityConditionArray;
    end
  end
end

--给data增加id = 3时候七天签到的booleanValue = 1数据，打开活动render上有红点
function HuoDongProxy:takeAward(id, conditionID)
  for i,v in ipairs(self.datas2) do
    if v.ID == id then
      for i2,v2 in ipairs(v.ActivityConditionArray) do
         if v2.ConditionID == conditionID then
          v2.BooleanValue = 1;
         end
      end
    end
  end
  for i,v in ipairs(self.datas) do
    if v.ID == id then
      v.BooleanValue = 0;
    end
  end
end

--给data增加id=4的booleanvalue数据,打开活动时候render上有红点
function HuoDongProxy:toBindPhoneNum(id ,bool)
  
  for i,v in ipairs(self.datas) do
    if v.ID == id then
      v.BooleanValue = bool;
    end
  end
end



function HuoDongProxy:setDotVisible(id, bool)
  for i,v in ipairs(self.redDotTab) do
    -- print("setDotVisible = ", i, v.ID, v.BooleanValue);
    if v.ID == id then
      v.BooleanValue = bool;
    end
  end
end

function HuoDongProxy:getRedDotTab()
  return self.redDotTab;
end