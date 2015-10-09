--
	-- Copyright @2009-2013 www.happyelements.com, all rights reserved.


StoryLineProxy=class(Proxy);

function StoryLineProxy:ctor()
  self.class=StoryLineProxy;
  self.skeleton = nil;
  self.strongPointArray = {};
  self.lastStrongPointId = nil;--开启的最远的关卡
  self.lastStrongPointState = nil;
  self.storyLineId = nil;
  self.openedStorylineIds = {};
  self.standPoint = nil;
  self.awardTable = {}
  self.lastStongPointStarCount = 1
  self.currentStorylineId = 0
end

rawset(StoryLineProxy,"name","StoryLineProxy");
--龙骨
function StoryLineProxy:getSkeleton()
  if nil==self.skeleton then
    self.skeleton = SkeletonFactory.new();
    self.skeleton:parseDataFromFile("storyLine_ui");
  end
  return self.skeleton;
end

function StoryLineProxy:setLastStrongPointId(lastStrongPointId)
  self.lastStrongPointId = lastStrongPointId;
  self.lastStoryLineId = analysis("Juqing_Guanka",Juqing_Zhandouguanka,"storyId")
  
end
function StoryLineProxy:setStrongPointState(strongPointId, state)
  local key = "key_" .. strongPointId;
  local strongPointData = self.strongPointArray[key] ;
  if strongPointData then 
    strongPointData.State = state;
  end
end
function StoryLineProxy:getStrongPointState(strongPointId)
  local key = "key_" .. strongPointId;
  local strongPointData = self.strongPointArray[key] ;
  if nil == strongPointData then return nil; end
  return strongPointData.State;
end
--Count(今天打了的次数) 
function StoryLineProxy:getStrongPointFinishCount(strongPointId)
  if not strongPointId then return;end;
  local key = "key_" .. strongPointId;
  local strongPointData = self.strongPointArray[key] ;
  if not strongPointData then return;end
  return strongPointData.Count;
end
--TotalCount(通关次数) 
function StoryLineProxy:getStrongPointTotalCount(strongPointId)
  if not strongPointId then return;end;
  local key = "key_" .. strongPointId;
  local strongPointData = self.strongPointArray[key] ;
  if not strongPointData then return;end
  return strongPointData.TotalCount;
end

function StoryLineProxy:getStrongPointStarCount(strongPointId)
  local key = "key_" .. strongPointId;
  local strongPointData = self.strongPointArray[key];
  local strongPointStars = 3

  -- log("*******************strongPointData.key========"..key)
  -- log("*******************strongPointData.State========"..strongPointData.State)

  if strongPointData.State == GameConfig.STRONG_POINT_STATE_2 
  or strongPointData.State == GameConfig.STRONG_POINT_STATE_3 then
    strongPointStars = 0
  else
    if strongPointData.StarLevel ~= nil then
      strongPointStars = strongPointData.StarLevel
    end
  end

  return strongPointStars
end

function StoryLineProxy:getStorylineStarCount(storyLineId)
  local storylineStarCount = 0
  local strongPoints = analysisByName("Juqing_Guanka", "storyId", storyLineId)
  for k, v in pairs(strongPoints) do
    storylineStarCount = storylineStarCount + self:getStrongPointStarCount(v.id)
  end

  return storylineStarCount
end

function StoryLineProxy:getStrongPointCount(storyLineId)
  local strongPointCount = 0
  local strongPoints = analysisByName("Juqing_Guanka", "storyId", storyLineId)
  for k, v in pairs(strongPoints) do
    strongPointCount = strongPointCount + 1
  end

  return strongPointCount
end

rawset(StoryLineProxy,"name","StoryLineProxy");

function StoryLineProxy:getTotalStoryLineCount()
  if nil==self.totalStoryLineCount then
    local totalStoryLines = analysisByName("Juqing_Juqing", "type", 1);
    self.totalStoryLineCount = Utils:getItemCount(totalStoryLines)
  end
  return self.totalStoryLineCount;
end

function StoryLineProxy:getLastStrongPointId()
   local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineId)
   local parentStrongPointId;
   local tempTables = {};
   for k, v in pairs(strongPoints) do
      local strongPointData = self.strongPointArray["key_" .. v.id];
      if strongPointData.State == 3 then
        return v.id;
      end
      if v.parentId == 0 then
        parentStrongPointId =v.id;
      end
      table.insert(tempTables, v.id)
   end
   local function sortFun(a, b)
      if a< b then
        return true;
      else
        return false;
      end
   end
   table.sort(tempTables, sortFun)
   for i = #tempTables, 1, -1 do
      local strongPointData = self.strongPointArray["key_" .. tempTables[i]];
      if strongPointData.State == 1 then
        print(" tempTables[i].StrongPointId",strongPointData.StrongPointId)
        return strongPointData.StrongPointId;
      end
   end
end



function StoryLineProxy:getLastPassStrongPointId()
   local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineId)
   local tempTables = {};
   for k, v in pairs(strongPoints) do
      table.insert(tempTables, v)
   end
   local function sortFun(a, b)
      if a.order < b.order then
        return true;
      else
        return false;
      end
   end
   table.sort(tempTables, sortFun)
   for i = #tempTables, 1, -1 do
      local strongPointData = self.strongPointArray["key_" .. tempTables[i].id];
      if strongPointData.State == 1 then
        print("tempTables[i].StrongPointId",strongPointData.StrongPointId)
        return strongPointData.StrongPointId;
      end
   end
   return 0;
end

function StoryLineProxy:setPassStrongPointData()
   local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineId)
   local tempTables = {};
   for k, v in pairs(strongPoints) do
      table.insert(tempTables, v)
   end
   local function sortFun(a, b)
      if a.order< b.order then
        return true;
      else
        return false;
      end
   end
   table.sort(tempTables, sortFun)

   local lastStrongPointPo = analysis("Juqing_Guanka", self.lastStrongPointId)  
   for i = #tempTables, 1, -1 do
      local tempStrongPointId = tempTables[i].id;
      local tempState;
      if tempTables[i].order < lastStrongPointPo.order then
        tempState = 1;
      elseif tempTables[i].order > lastStrongPointPo.order then
        tempState = 2;
      else
        tempState = self.lastStrongPointState;
      end
      local strongPointData = {StrongPointId = tempStrongPointId, State = tempState,StarLevel = 3};
      self.strongPointArray["key_" .. tempStrongPointId] = strongPointData
   end

end

function StoryLineProxy:setAllStrongPointNotOpen()
   local strongPoints = analysisByName("Juqing_Guanka", "storyId", self.storyLineId)
   local tempTables = {};
   for k, v in pairs(strongPoints) do
      local tempStrongPointId = v.id;
      local tempState;
      if tempStrongPointId == 10001111 then
        tempState = 3
      else
        tempState = 2
      end
      local strongPointData = {StrongPointId = tempStrongPointId, State = tempState};
      self.strongPointArray["key_" .. tempStrongPointId] = strongPointData
   end
end

function StoryLineProxy:upDataAward(storyLineAwardArray)
  if not storyLineAwardArray then return end
  for k,v in pairs(storyLineAwardArray) do
    self.awardTable[v.StoryLineId] = v.StoryLineId
  end
end
-- 是否领取了奖励
-- ture 领过
function StoryLineProxy:isGotAward(storyLineId)
  local boolValue = self.awardTable[storyLineId]
  return boolValue ~= nil
end

function StoryLineProxy:setBattleStarCount(strongPointId,starCount)
      local key = "key_" .. strongPointId;
      local oldStrongPointData = self.strongPointArray[key];
      if not oldStrongPointData then
        oldStrongPointData = {};
        oldStrongPointData.StrongPointId = strongPointId;
        self.strongPointArray[key] = oldStrongPointData;
      end

      if oldStrongPointData.StarLevel == nil
      or (oldStrongPointData.StarLevel and oldStrongPointData.StarLevel < starCount) then
        oldStrongPointData.StarLevel = starCount;
      end
end

function StoryLineProxy:getStorylineId(index)
  self.currentStorylineId = self.openedStorylineIds[index]
  return self.currentStorylineId
end
