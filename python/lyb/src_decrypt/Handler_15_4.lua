--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_15_4 = class(Command);

function Handler_15_4:execute()
   print(".15.4.");
   for k,v in pairs(recvTable["AchievementArray"]) do
   	  print(".15.4..",v.AchievementId,v.TaskConditionArray[1] and v.TaskConditionArray[1].Count,v.TaskConditionArray[1] and v.TaskConditionArray[1].MaxCount,v.BooleanValue,v.TakeAwardCount);
   end

   local achievementProxy=self:retrieveProxy(AchievementProxy.name);
   achievementProxy:refresh(recvTable["AchievementArray"]);

   --AchievementMediator
  local achievementMediator=self:retrieveMediator(AchievementMediator.name);
  if nil~=achievementMediator then
    achievementMediator:refresh(recvTable["AchievementArray"]);
  end
end

Handler_15_4.new():execute();