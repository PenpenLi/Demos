
Handler_7_64 = class(MacroCommand)

function Handler_7_64:execute()

  self.challengeProxy=self:retrieveProxy(ChallengeProxy.name);
  self.challengeProxy:refreshUniversalBossOverRankData(recvTable["WorldBossRankingArray"]);

end

Handler_7_62.new():execute();