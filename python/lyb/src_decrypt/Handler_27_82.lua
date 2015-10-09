--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_82 = class(Command);

function Handler_27_82:execute()
  print(".27.82.",recvTable["ArmyTeamArray"]);
  print(".27.82.",#recvTable["ArmyTeamArray"],recvTable["Count"]);
  for k,v in pairs(recvTable["ArmyTeamArray"]) do
    print(".27.82..",v.MapId,v.ID,v.UserId,v.UserName,v.Level,v.Zhanli);
  end

  uninitializeSmallLoading();
  local data={};
  data.ArmyTeamArray=recvTable["ArmyTeamArray"];
  data.Count=recvTable["Count"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshDeploy(data);
  end
end

Handler_27_82.new():execute();