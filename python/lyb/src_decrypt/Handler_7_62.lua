--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_7_62 = class(MacroCommand)

function Handler_7_62:execute()
  --print(".7.62.","WorldBossRankingArray",recvTable["WorldBossRankingArray"]);
  self.challengeProxy=self:retrieveProxy(ChallengeProxy.name);
  self.challengeProxy:refreshUniversalBossRankData(recvTable["WorldBossRankingArray"]);

  if BattleSceneMediator then
  	local battleSceneMediator=self:retrieveMediator(BattleSceneMediator.name);
  	if battleSceneMediator then
  		battleSceneMediator:refreshBossInjureRank();
  	end
  end
end

Handler_7_62.new():execute();