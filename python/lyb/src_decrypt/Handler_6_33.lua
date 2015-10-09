

Handler_6_33 = class(MacroCommand);

function Handler_6_33:execute()
  require "main.model.ActivityProxy";
  require "main.view.activity.LimitedSummonHeroMediator";
  require "main.view.mainScene.MainSceneMediator";

  print("=(6,33)return=============",recvTable["Count"],recvTable["Ranking"],recvTable["ActivityEmployScore"],recvTable["ActivityEmployRankingArray"])

  local activityProxy=self:retrieveProxy(ActivityProxy.name);
  activityProxy.limitedSummonHeroData.Count = recvTable["Count"];
  activityProxy.limitedSummonHeroData.Ranking = recvTable["Ranking"];
  activityProxy.limitedSummonHeroData.ActivityEmployScore = recvTable["ActivityEmployScore"];
  activityProxy.limitedSummonHeroData.ActivityEmployRankingArray = recvTable["ActivityEmployRankingArray"];
  activityProxy.limitedSummonHeroData.GeneralEmployInfoArray = recvTable["GeneralEmployInfoArray"];

  for k, v in pairs(activityProxy.limitedSummonHeroData.ActivityEmployRankingArray) do
    print(k,v.UserId,v.UserName,v.Ranking,v.ActivityEmployScore);
    activityProxy.limitedSummonHeroData.ActivityEmployRankingArray[v.Ranking] = v;
  end

  local mainSceneMediator = self:retrieveMediator(MainSceneMediator.name)
  if mainSceneMediator then
    --小助手闪光
    --mainSceneMediator:setIconEffectFund(activityProxy:isHaveOfflineCompensation());
  end

  local limitedSummonHeroMediator = self:retrieveMediator(LimitedSummonHeroMediator.name)
  if limitedSummonHeroMediator then
    --刷新数据
    limitedSummonHeroMediator:refresh();
  end


end

Handler_6_33.new():execute();