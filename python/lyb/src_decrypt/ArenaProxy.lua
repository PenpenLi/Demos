ArenaProxy=class(Proxy);

function ArenaProxy:ctor()
  self.class=ArenaProxy;

  self.generalIdArray = nil
  self.timeValue = 0
  self.allRankGeneralArray = {}
  self.afterBattle = nil-- 新手引导用的
  self.isUpdating = 0;
end


rawset(ArenaProxy,"name","ArenaProxy");

function ArenaProxy:isInUpDefItem(generalId)
  for key,value in pairs(self.generalIdArray) do
    if value.GeneralId == generalId then
      return true
    end
  end
end

function ArenaProxy:isInUpAtkItem(generalId)
  for key,value in pairs(self.generalIdArray2) do
    if value.GeneralId == generalId then
      return true
    end
  end
end

function ArenaProxy:getArenaGeneralInPlayOverCount()
    return 3 == #self.generalIdArray
end

function ArenaProxy:setTimeValue(timeValue)
    self.timeValue = timeValue
end

function ArenaProxy:getTimeValue()
  return self.timeValue
end

function ArenaProxy:setIsUpdating(v)
  self.isUpdating = v;
end

function ArenaProxy:getIsUpdating()
  return self.isUpdating;
end