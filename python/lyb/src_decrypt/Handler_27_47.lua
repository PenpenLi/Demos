--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.family.FamilyMediator";

Handler_27_47 = class(Command);

function Handler_27_47:execute()
  uninitializeSmallLoading();
  local activityProxy=self:retrieveProxy(ActivityProxy.name);
  local challengeProxy=self:retrieveProxy(ChallengeProxy.name);
  challengeProxy:refreshUniversalBossRankData(recvTable["WorldBossRankingArray"]);
  local familyMediator=self:retrieveMediator(FamilyMediator.name);
  if nil~=familyMediator then
    familyMediator:refreshFamilyBossRankData(activityProxy:getSkeleton(),challengeProxy);
  end
end

Handler_27_47.new():execute();