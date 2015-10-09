--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_15_3 = class(Command);

function Handler_15_3:execute()
   print(".15.3.",recvTable["AchievementId"]);

   local achievementProxy=self:retrieveProxy(AchievementProxy.name);
   achievementProxy:onFetch(recvTable["AchievementId"]);

   --AchievementMediator
  local achievementMediator=self:retrieveMediator(AchievementMediator.name);
  if nil~=achievementMediator then
    achievementMediator:onFetchRefresh(recvTable["AchievementId"]);
  end
end

Handler_15_3.new():execute();