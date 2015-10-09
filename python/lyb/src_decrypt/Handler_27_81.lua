--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_81 = class(Command);

function Handler_27_81:execute()
  print(".27.81.",recvTable["MapId"],recvTable["ApplyFamilyWarInfoArray"]);
  print(".27.81.",#recvTable["ApplyFamilyWarInfoArray"]);
  for k,v in pairs(recvTable["ApplyFamilyWarInfoArray"]) do
    print(".27.81..",v.Place,v.FamilyId,v.FamilyName,v.State);
  end

  uninitializeSmallLoading();
  local data={};
  data.MapId=recvTable["MapId"];
  data.ApplyFamilyWarInfoArray=recvTable["ApplyFamilyWarInfoArray"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshPosData(data);
  end
end

Handler_27_81.new():execute();