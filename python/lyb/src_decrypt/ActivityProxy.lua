--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-4

	yanchuan.xie@happyelements.com
]]

require "main.config.ActivityConstConfig";
require "main.config.CountControlConfig";
require "core.utils.RefreshTime";
require "core.utils.UserInfoUtil";

ActivityProxy=class(Proxy);

function ActivityProxy:ctor()
  self.class=ActivityProxy;
  self.data={};
  self.skeleton=nil;
  self.amassFortunesSkeleton = nil;

  self.date={};
  --table.insert(self.date,{ConfigId=7,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  --table.insert(self.date,{ConfigId=8,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  --table.insert(self.date,{ConfigId=9,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  table.insert(self.date,{ConfigId=10,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  table.insert(self.date,{ConfigId=11,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  table.insert(self.date,{ConfigId=12,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
  EffectConstConfig.ACTIVITY_NEW=3;

  self.rebateId = nil;
  self.rebateBeginTimeStr = nil;
  self.rebateEndTimeStr = nil;
  self.rebateValue = nil;

  self.sign_in_data=nil;

  self.level_gift_data=nil;
  self.download_gift_data={};

  self.rewardTable = {};
  self.retainTable = {};
  self.timerRewardTable = {};
  self.activity_effect_ids={};

  self.activityNoticeStatusTbl = {};  --活动是否需要发送感叹号提示 true 需提示 false 不提示

  self.isOpen = false

  self.fundState = 0;
  self.fundCurrentDay = 1;
  self.fundStateArray={};
  self.fundRemainTime=nil;
  self.fundMediatorInitCount = 0;
  self.downLoadActivityDeletedByCountControl=false;
  --if GameData.platFormID == GameConfig.PLATFORM_CODE_WAN then
  if CommonUtils:getCurrentPlatform()==CC_PLATFORM_ANDROID then
    table.insert(self.date,{ConfigId=9,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
    if UserInfoUtil:public_getDownLoadGiftSign(2) then
      table.insert(self.activity_effect_ids,9);
      EffectConstConfig.ACTIVITY_FETCHABLE_NUM=1+EffectConstConfig.ACTIVITY_FETCHABLE_NUM;
    end
  end

  --限时招募数据
  self.limitedSummonHeroData={Count=0,Ranking=0,ActivityEmployScore=0,cdTime=0,osTime=0,ActivityEmployRankingArray={},GeneralEmployInfoArray={}};
  --previousSendMessageType,此次只有4,5,6，写在summonHeroProxy中统一管理
  self.isOpenLimitedSummonHero = false;
  self.limitedSummonHeroBeginTime = 0;
  self.limitedSummonHeroEndTime = 0;
  self.remainSeconds = 0;
  self.osTime = 0;--这个和limitedSummonHeroData的osTime区别出来,比较好，肯定有延时

end

rawset(ActivityProxy,"name","ActivityProxy");

function ActivityProxy:getData()
  return self.data;
end

function ActivityProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton=SkeletonFactory.new();
    self.skeleton:parseDataFromFile("activity_ui");
  end
  return self.skeleton;
end


function ActivityProxy:getAmassFortunesSkeleton()
  if nil == self.amassFortunesSkeleton then
     self.amassFortunesSkeleton = SkeletonFactory.new();
     self.amassFortunesSkeleton:parseDataFromFile("amassFortunes_ui");
  end
  return self.amassFortunesSkeleton;
end

function ActivityProxy:getFundSkeleton()
  if nil == self.fundSkeleton then
     self.fundSkeleton = SkeletonFactory.new();
     self.fundSkeleton:parseDataFromFile("fund_ui");
  end
  return self.fundSkeleton;
end

function ActivityProxy:getLimitedSummonHeroSkeleton()
  if nil == self.limitedSummonHeroSkeleton then
     self.limitedSummonHeroSkeleton = SkeletonFactory.new();
     self.limitedSummonHeroSkeleton:parseDataFromFile("limitedSummonHero_ui");
  end
  return self.limitedSummonHeroSkeleton;
end

function ActivityProxy:checkData4DownLoadForce()
  if not self:getDateByID(9) then
    if CommonUtils:getCurrentPlatform()==CC_PLATFORM_ANDROID then
      table.insert(self.date,{ConfigId=9,RemainSecondsBegin=1,RemainSecondsEnd=1,BooleanValue=1});
      if UserInfoUtil:public_getDownLoadGiftSign(2) then
        table.insert(self.activity_effect_ids,9);
        EffectConstConfig.ACTIVITY_FETCHABLE_NUM=1+EffectConstConfig.ACTIVITY_FETCHABLE_NUM;
      end
    end
  end
end

function ActivityProxy:checkData4DownLoadByOpenFunction(openFunctionProxy)
  require "main.config.FunctionConfig";
  if openFunctionProxy:checkIsOpenFunction(FunctionConfig.FUNCTION_ID_100) then
    if not self.downLoadActivityDeletedByCountControl then
      self:checkData4DownLoadForce();
    end
  else
    self:deleteDate(9);
    if UserInfoUtil:public_getDownLoadGiftSign(2) then
      self:deleteEffectID(9);
    end
  end
end

------------------------------------------------公共--------------------------------------------------------------

function ActivityProxy:deleteDate(id)
  for k,v in pairs(self.date) do
    if id==v.ConfigId then
      table.remove(self.date,k);
      return;
    end
  end
end

--ConfigId：活动id， BooleanValue：1开启 0关闭
--ConfigId,Type,RemainSecondsBegin,RemainSecondsEnd,BooleanValue
--Type 1 "Huodongbiao_Huodong"
--Type 2 "Huodongbiao_Huodongshijian"
function ActivityProxy:refreshDate(activityInfoArray)
  if nil==self.date then
    self.date=activityInfoArray;
    return;
  end
  for k,v in pairs(activityInfoArray) do
    if analysisHas("Huodongbiao_Huodong",v.ConfigId) and 13~=v.ConfigId then
      self:refreshDateData(v);
    end
  end
end

function ActivityProxy:refreshDateData(data)
  for k,v in pairs(self.date) do
    if data.ConfigId==v.ConfigId then
      if 0==data.BooleanValue then
        self:deleteDate(v.ConfigId);
      else
        for k_,v_ in pairs(v) do
          v[k_]=data[k_];
        end
      end
      return;
    end
  end
  if 1==data.BooleanValue then
    table.insert(self.date,data);
  end
end

function ActivityProxy:refreshPersistentActivity(countControlProxy)
  if 0>=countControlProxy:getRemainCountByID(CountControlConfig.LEVEL_AND_DOWNLOAD_LOTTERY,CountControlConfig.Parameter_1) then
    --self:deleteDate(8);
  end
  if 0>=countControlProxy:getRemainCountByID(CountControlConfig.LEVEL_AND_DOWNLOAD_LOTTERY,CountControlConfig.Parameter_2) then
    self:deleteDate(9);
    if UserInfoUtil:public_getDownLoadGiftSign(2) then
      self:deleteEffectID(9);
    end
    self.downLoadActivityDeletedByCountControl=true;
  end
end

function sfunc(a, b)
  local type_a=analysis("Huodongbiao_Huodong",a.ConfigId,"type");
  local type_b=analysis("Huodongbiao_Huodong",b.ConfigId,"type");
  if type_a<type_b then
    return true;
  end
  return false;
end

function ActivityProxy:getAllActivities()
  local a={};
  table.sort(self.date,sfunc);
  for k,v in pairs(self.date) do
    table.insert(a,v.ConfigId);
  end
  return a;
end

function ActivityProxy:getDateByID(id)
  for k,v in pairs(self.date) do
    if id==v.ConfigId then
      return v;
    end
  end
  return nil;
end

function ActivityProxy:deleteEffectID(id)
  for k,v in pairs(self.activity_effect_ids) do
    if id==v then
      table.remove(self.activity_effect_ids,k);
      EffectConstConfig.ACTIVITY_FETCHABLE_NUM=-1+EffectConstConfig.ACTIVITY_FETCHABLE_NUM;
      break;
    end
  end
end

function ActivityProxy:refreshActivityEffectIDs(idArray)
  for k,v in pairs(idArray) do
    if self:hasEffectID(v.ID) then

    else
      table.insert(self.activity_effect_ids,v.ID);
      EffectConstConfig.ACTIVITY_FETCHABLE_NUM=1+EffectConstConfig.ACTIVITY_FETCHABLE_NUM;
    end
  end
end

function ActivityProxy:getActivityEffectIDs()
  return self.activity_effect_ids;
end

function ActivityProxy:hasEffectID(id)
  for k,v in pairs(self.activity_effect_ids) do
    if id==v then
      return true;
    end
  end
  return false;
end

------------------------------------------------充值返利--------------------------------------------------------------

------------------------------------------------消费返利--------------------------------------------------------------

function ActivityProxy:setRebateId(id)
      self.rebateId = id;
end

function ActivityProxy:getRebateId()
     return self.rebateId
end

function ActivityProxy:setRebateBeginTimeStr(id)
      self.rebateBeginTimeStr = id;
end

function ActivityProxy:getRebateBeginTimeStr()
     return self.rebateBeginTimeStr
end

function ActivityProxy:setRebateEndTimeStr(str)
      self.rebateEndTimeStr = str;
end

function ActivityProxy:getRebateEndTimeStr()
     return self.rebateEndTimeStr
end

function ActivityProxy:setRebateValue(value)
      self.rebateValue = value;
end

function ActivityProxy:getRebateValue()
     return self.rebateValue
end

------------------------------------------------招财进宝--------------------------------------------------------------

------------------------------------------------签到奖励--------------------------------------------------------------

function ActivityProxy:deleteSignInData()
  self.sign_in_data=nil;
end

--更新
function ActivityProxy:refreshSignInData(signAwardArray)
  if nil==self.sign_in_data then
    self.sign_in_data=signAwardArray;
    return;
  end
  for k,v in pairs(signAwardArray) do
    table.insert(self.sign_in_data,v);
  end
end

function ActivityProxy:getSignInDataByPlace(place)
  for k,v in pairs(self.sign_in_data) do
    if place==v.Place then
      return v;
    end
  end
end

function ActivityProxy:getFetchableByRow(row)
  local a=7*(-1+row);
  local b=0;
  while 7>b do
    b=1+b;
    if nil==self:getSignInDataByPlace(a+b) then
      return false;
    end
  end
  return true;
end

------------------------------------------------等级礼包--------------------------------------------------------------

function ActivityProxy:deleteLevelGiftData()
  self.level_gift_data=nil;
end

--更新
function ActivityProxy:refreshLevelGiftData(levelArray)
  if nil==self.level_gift_data then
    self.level_gift_data=levelArray;
    return;
  end
  for k,v in pairs(levelArray) do
    table.insert(self.level_gift_data,v);
  end
end

function ActivityProxy:refreshLevelGiftDataFetch(level)
  table.insert(self.level_gift_data,{Level=level});
end

function ActivityProxy:getLevelGiftData()
  return self.level_gift_data;
end

function ActivityProxy:hasLevelGiftData(lv)
  for k,v in pairs(self.level_gift_data) do
    if lv==v.Level then
      return true;
    end
  end
end

------------------------------------------------下载礼包--------------------------------------------------------------

function ActivityProxy:deleteDownloadGiftData()
  --self.download_gift_data=nil;
end

--更新
function ActivityProxy:refreshDownloadGiftData(levelArray)
  if nil==self.download_gift_data then
    self.download_gift_data=levelArray;
    return;
  end
  for k,v in pairs(levelArray) do
    table.insert(self.download_gift_data,v);
  end
end

function ActivityProxy:refreshDownloadGiftDataFetch(level)
  table.insert(self.download_gift_data,{Level=level});
end

function ActivityProxy:getDownloadGiftData()
  return self.download_gift_data;
end

function ActivityProxy:hasDownloadGiftData(lv)
  for k,v in pairs(self.download_gift_data) do
    if lv==v.Level then
      return true;
    end
  end
end
--------------------------------------------------------基金-------------------------------------------------------------------
function ActivityProxy:isFundOpen()
  return self.isOpen
  -- local boo = false;

  -- if self.fundState == 0 then
  --   if self.fundRemainTime then
  --     if self.fundRemainTime[1]<=0 and self.fundRemainTime[2]>0 then
  --       boo = true;
  --     end
  --   end
  -- else
  --   for k,v in pairs(self.fundStateArray) do
  --     if v==0 then
  --       boo = true;
  --       break
  --     end
  --   end
  -- end 
  -- boo = true;
  -- return boo;
end
function ActivityProxy:setIsFundOpen(boo)
  self.isOpen = boo
end
function ActivityProxy:isFundEffectEnabled()
  local boo = false;
  if self.fundState==0 then
    if self.fundRemainTime==nil then
      --初始状态，或者过期没返回
    else
      if self.fundMediatorInitCount==0 then
        --只闪1次，策划需求
        boo = true
      else
      end
    end
  else
    for i=1,self.fundCurrentDay do
      if self.fundStateArray[i]==0 then
        boo = true;
        break
      end
    end
  end

  return boo;
end

function ActivityProxy:getFirstFundAwardDayIndex()
  local returnVaule = 0
  for k,v in pairs(self.fundStateArray) do
    if v==0 then
      returnVaule = k
      break
    end
  end
  return returnVaule
end

------------------------------------限时招募-----------------------------------

function ActivityProxy:getLimitedSummonHeroPrizeContent()
  local str = "";
  local tbl = analysisTotalTableArray("Huodongbiao_Yunyingjiangli");
  print(";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;")
  for k,v in pairs(tbl) do

    --print("ooooo0>>>>:",v.huodongid,v.conditionID);

    if v.huodongid==49 and v.conditionID==13 then
      --print("ooooo1>>>>:",str);
      if v.tiaojian==0 and v.tiaojian2==1 then
        str=str.."<font color='#00FF00'>排名1玩家可获得</font><br/>";
      else 
        str=str.."<font color='#00FF00'>排名"..v.tiaojian.."-"..v.tiaojian2.."玩家可获得</font><br/>";
      end

      local aa = StringUtils:stuff_string_split(v.jianglineirong);
      local count = 0;

      for i2,v2 in pairs(aa) do
        aa[i2] = v2;
      end

      for k1,v1 in ipairs(aa) do
        --v[1],itmeId
        --v[2],count
        str=str..getHTMLText(v1[1],v1[2]);
        count = count+1;
        if(count==#aa) then
          str = str.."<br/>";
        elseif(count%2==0) then
          str = str.."<br/>";
        elseif(count%2==1) then
          str = str.."<font color='#00FF00'> </font>";
        end

      end
    end
  end

  for k,v in pairs(tbl) do
    if v.huodongid==49 and v.conditionID==14 then
      --print("ooooo2>>>>:",str);
      local aa = StringUtils:stuff_string_split(v.jianglineirong);
      for k1,v1 in pairs(aa) do
        str = str.."<font color='#00FF00'>积分超过"..v.tiaojian.."可获得</font><br/>"..getHTMLText(v1[1],v1[2]).."<br/>";
      end
     
    end
  end

  --local str="<font color='#00FF00'>这个先不看，后面来改排名1玩家可获得</font><br/><font color='#FF0000'>红卡3张</font><br/><font color='#00FF00'>排名2-3玩家可获得</font><br/><font color='#FF0000'>红卡1张</font><br/><font color='#00FF00'>积分超过60可获得</font><br/><font color='#FF0000'>紫卡1张</font>"
  str = "<content>"..str.."</content>";

  print("ooooo>>>>:",str);
  return str;
end


