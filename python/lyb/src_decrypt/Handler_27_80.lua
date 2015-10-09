--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_80 = class(Command);

function Handler_27_80:execute()
  --Stage,RemainSeconds,MapInfoArray,Time
  print(".27.80.",recvTable["Stage"],recvTable["RemainSeconds"],recvTable["MapInfoArray"],recvTable["Time"]);
  print(".27.80.",#recvTable["MapInfoArray"]);
  for k,v in pairs(recvTable["MapInfoArray"]) do
    print(".27.80..");
    print(v.MapId,v.Count,v.BooleanValue,v.BooleanValue2,v.FamilyId,v.FamilyName);
  end

  uninitializeSmallLoading();
  local data={};
  data.Stage=recvTable["Stage"];
  data.RemainSeconds=recvTable["RemainSeconds"];
  data.MapInfoArray=recvTable["MapInfoArray"];
  data.Time=recvTable["Time"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshStage(data);
  end
end

Handler_27_80.new():execute();