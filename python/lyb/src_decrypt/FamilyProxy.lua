--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-8

	yanchuan.xie@happyelements.com
]]

FamilyProxy=class(Proxy);

function FamilyProxy:ctor()
  self.class=FamilyProxy;
  self.data=nil;
  self.normal_data={Silver=0,FamilyLevel=0,Experience=0,UserId=0,UserName="",BooleanValue=0};
  self.activitys={};
  self.skeleton=nil;
  self.BanquetInfoArray=nil;
  self.myBanquetData = nil;
  self.familyMonsterCount = 0;
  self.familyLevel = nil;
  self.yongbingData = {};
  -- table.insert(self.yongbingData,{GeneralId=1987,ConfigId=2,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  -- table.insert(self.yongbingData,{GeneralId=486,ConfigId=78,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  -- table.insert(self.yongbingData,{GeneralId=88,ConfigId=38,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  -- table.insert(self.yongbingData,{GeneralId=866,ConfigId=39,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  -- table.insert(self.yongbingData,{GeneralId=18,ConfigId=3,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  -- table.insert(self.yongbingData,{GeneralId=787,ConfigId=64,Level=99,Grade=3,StarLevel=3,Zhanli=999,Count=3,Time=23154});
  self.shiguo_general_id = nil;
  self.shiguo_boolean = nil;

  self.family_npc_hongdian = nil;
end

rawset(FamilyProxy,"name","FamilyProxy");

function FamilyProxy:refreshActivity(idAndState)
  for k,v in pairs(self.activitys) do
    if v.ID==idAndState.ID then
      v.State=idAndState.State;
      v.Time=idAndState.Time;
      return;
    end
  end
  table.insert(self.activitys,idAndState);
end

function FamilyProxy:refreshActivitys(idAndStateArray)
  for k,v in pairs(idAndStateArray) do
    self:refreshActivity(v);
    if 1 == v.State then 
      self:notice(v.ID);
    end
  end
end

function FamilyProxy:refreshData(silver,familyLevel,experience,userId,userName,booleanValue)
  if self.data then
    self.data.Silver=silver;
    self.data.FamilyLevel=familyLevel;
    self.data.Experience=experience;
    self.data.UserId=userId;
    self.data.UserName=userName;
  end
  self.normal_data.Silver=silver;
  self.normal_data.FamilyLevel=familyLevel;
  self.normal_data.Experience=experience;
  self.normal_data.UserId=userId;
  self.normal_data.UserName=userName;
  self.normal_data.BooleanValue=booleanValue;
end

function FamilyProxy:getActivityIsOpen(id)
  for k,v in pairs(self.activitys) do
    if v.ID==id then
        return 1==v.State;
    end
  end
  return false;
end

function FamilyProxy:getActivityTime(id)
  for k,v in pairs(self.activitys) do
    if v.ID==id then
      return v.Time;
    end
  end
  return 0;
end

function FamilyProxy:setData(data)
  if self.data and data then
    error("");
  end
  self.data=data;
end

function FamilyProxy:getData()
  return self.data;
end

function FamilyProxy:getNormalData()
  return self.normal_data;
end

function FamilyProxy:getDonate()
  local a=0;
  if self.data then
    a=self.data.Experience;
  end
  return a;
end

function FamilyProxy:getFamilyLevel()
  return self.familyLevel;
end

function FamilyProxy:setFamilyLevel(familyLevel)
   self.familyLevel = familyLevel;
end

function FamilyProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("family_ui");
  end
  return self.skeleton;
end

function FamilyProxy:getBanquetSkeleton()
  if nil==self.banquetSkeleton then
    self.banquetSkeleton=SkeletonFactory.new();
    self.banquetSkeleton:parseDataFromFile("banquet_ui");
  end
  return self.banquetSkeleton;
end
function FamilyProxy:notice(ID)
  if 2 == ID then 
    recvTable["ID"] = 26
    recvTable["Content"] = ""
    recvTable["ParamStr1"] = ""
    recvTable["ParamStr2"] = ""
    recvTable["ParamStr3"] = ""
    self.familyEffectTap=nil;
    recvMessage(1011, 6);
  elseif 8 == ID then 
    recvTable["ID"] = 41
    recvTable["Content"] = ""
    recvTable["ParamStr1"] = ""
    recvTable["ParamStr2"] = ""
    recvTable["ParamStr3"] = ""
    recvMessage(1011, 6);
  end
end

function FamilyProxy:hasNewApply(userProxy)
  require "main.config.FamilyConstConfig";
  if 5>userProxy:getFamilyPositionID() then
    return self:getActivityIsOpen(FamilyConstConfig.ACTIVITY_5);
  end
  return false;
end

function FamilyProxy:setNewApplyTap()
  for k,v in pairs(self.activitys) do
    if FamilyConstConfig.ACTIVITY_5==v.ID then
      v.State=0;
    end
  end
end


function FamilyProxy:refredhActivityState(id, state)
  for k,v in pairs(self.activitys) do
    if v.ID == id then
       v.State = state;
    end
  end
end

function FamilyProxy:getActivityState(id)
  for k,v in pairs(self.activitys) do
    if v.ID == id then
      return v.State;
    end
  end
  return nil;
end

function FamilyProxy:getImpeachable()
  return 1==self.normal_data.BooleanValue;
end

function FamilyProxy:setBanquetData(  )
  
end

function FamilyProxy:getBanquetData(  )
  
end

function FamilyProxy:refreshYongbingData(data)
  self.yongbingData = data;
end

--Type,GeneralId,ConfigId,Level,Grade,StarLevel,Zhanli,Count
function FamilyProxy:refreshYongbingDataOnChange(data)
  for k,v in pairs(data) do
    if 1 == v.Type then
      if not v.UserCount then
        v.UserCount = 0;
      end
      table.insert(self.yongbingData,v);
    elseif 2 == v.Type then
      for k_,v_ in pairs(self.yongbingData) do
        if v.GeneralId == v_.GeneralId then
          table.remove(self.yongbingData,k_);
          break;
        end
      end
    elseif 3 == v.Type then
      for k_,v_ in pairs(self.yongbingData) do
        if v.GeneralId == v_.GeneralId then
          for k__,v__ in pairs(v) do
            v_[k__] = v[k__];
          end
          break;
        end
      end
    end
  end
end

function FamilyProxy:getYongbingData()
  return self.yongbingData;
end

function FamilyProxy:getYongbingData4Biandui()
  local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
  local data = {};
  for k,v in pairs(self.yongbingData) do
    print("getYongbingData4Biandui->",v.ConfigId,heroHouseProxy:getGeneralData(v.GeneralId),v.UserCount,v.Count);
    if heroHouseProxy:getGeneralData(v.GeneralId) then

    elseif 1 <= v.UserCount then

    elseif 5 <= v.Count then

    else
      table.insert(data,v);
    end
  end
  local function sortOnByStar1(a, b)
    local itemsData1 = analysisWithCache("Kapai_Kapaiku", a.ConfigId)--卡牌库
    local itemsData2 = analysisWithCache("Kapai_Kapaiku", b.ConfigId)--卡牌库
    if a.Level > b.Level then
      return true;
    elseif a.Level < b.Level then
      return false;
    elseif a.Grade > b.Grade then
      return true;
    elseif a.Grade < b.Grade then
      return false;
    elseif itemsData1.sort < itemsData2.sort then
      return true;
    elseif itemsData1.sort > itemsData2.sort then
      return false;
    end
    return a.ConfigId > b.ConfigId;
  end
  table.sort(data, sortOnByStar1);
  return data;
end

function FamilyProxy:getYongbingData4BianduiOnShiguo()
  if 0~=self.shiguo_general_id then
    return {self:getYongbingDataByGeneralID(self.shiguo_general_id)};
  end
  return self:getYongbingData4Biandui();
end

function FamilyProxy:getYongbingData4Paiqian()
  local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
  local player = heroHouseProxy:getGeneralArrayWithPlayer();
  local data = {};
  local tmp = {};
  for k,v in pairs(self.yongbingData) do
    tmp[v.GeneralId] = v.GeneralId;
  end
  for k,v in pairs(player) do
    if tmp[v.GeneralId] then

    else
      table.insert(data,v);
    end
  end
  return data;
end

function FamilyProxy:getUserYongbingData()
  local heroHouseProxy = Facade.getInstance():retrieveProxy(HeroHouseProxy.name);
  local data = heroHouseProxy:getGeneralArray();
  local hero_ids = {};
  local yongbingData = {};
  for k,v in pairs(data) do
    hero_ids[v.GeneralId] = v.GeneralId;
  end
  for k,v in pairs(self.yongbingData) do
    if hero_ids[v.GeneralId] then
      table.insert(yongbingData,v)
    end
  end
  return yongbingData;
end

function FamilyProxy:getYongbingDataByGeneralID(generalID)
  for k,v in pairs(self.yongbingData) do
    if v.GeneralId == generalID then
      return v;
    end
  end
end

function FamilyProxy:refreshUserCountByBiandui(generalID, type)
  local data = self:getYongbingDataByGeneralID(generalID);
  if data then
    data.UserCount = 1 + data.UserCount;
  end
end

function FamilyProxy:getFetchedSilverByGeneralID(generalID)
  local data = self:getYongbingDataByGeneralID(generalID);
  if not data then return 0;end
  local time=getTimeServer()-data.Time;
  local time_max = analysis("Xishuhuizong_Xishubiao",1072,"constant");
  time = time_max > time and time or time_max;
  time=math.ceil(time/60);
  local silver = data.Level*(1+data.StarLevel)*data.Grade*math.ceil(math.pow(time,0.4));
  return silver;
end

function FamilyProxy:getFetchedSilverByGeneralIDOnGuyong(generalID)
  local data = self:getYongbingDataByGeneralID(generalID);
  if not data then return 0;end
  local time=getTimeServer()-data.Time;
  time=math.floor(time/60);
  local silver = data.Level*(1+data.StarLevel)*data.Grade*20;
  return math.floor(silver);
end

function FamilyProxy:getFetchedSilverByGeneralIDOnBeiGuyong(generalID)
  local data = self:getYongbingDataByGeneralID(generalID);
  if not data then return 0;end
  local time=getTimeServer()-data.Time;
  time=math.floor(time/60);
  local silver = data.Level*(1+data.StarLevel)*data.Grade*18;
  return math.floor(silver)*data.Count;
end