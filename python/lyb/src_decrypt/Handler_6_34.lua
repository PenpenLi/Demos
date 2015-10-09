

Handler_6_34 = class(MacroCommand);

function Handler_6_34:execute()
  require "main.model.ActivityProxy";
  require "main.view.activity.LimitedSummonHeroMediator";
  require "main.view.mainScene.MainSceneMediator";

  print("=(6,34)return=============",recvTable["GeneralEmployInfoArray"],recvTable["Count"],recvTable["ActivityEmployScore"])

  local activityProxy=self:retrieveProxy(ActivityProxy.name);
  activityProxy.limitedSummonHeroData.Count = recvTable["Count"];
  activityProxy.limitedSummonHeroData.ActivityEmployScore = recvTable["ActivityEmployScore"];
  activityProxy.limitedSummonHeroData.GeneralEmployInfoArray = recvTable["GeneralEmployInfoArray"];


  for k, v in pairs(activityProxy.limitedSummonHeroData.GeneralEmployInfoArray) do
    print("=(6,34)",k,v.ConfigId);
    --activityProxy.fundStateArray[v.ID] = [v.CurrentCount,v.MaxCount];
  end

  local limitedSummonHeroMediator = self:retrieveMediator(LimitedSummonHeroMediator.name)
  if limitedSummonHeroMediator then
    --刷新数据
    limitedSummonHeroMediator:drawResult();
    limitedSummonHeroMediator:refresh();
  end


end

Handler_6_34.new():execute();