--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_86 = class(Command);

function Handler_27_86:execute()
  print(".27.86.",recvTable["Stage"],recvTable["RemainSeconds"],recvTable["FamilyPromotionArray"]);
  print(".27.86.",#recvTable["FamilyPromotionArray"]);
  for k,v in pairs(recvTable["FamilyPromotionArray"]) do
    print(".27.86..",v.MapId,v.PromotionPositionId,v.FamilyId,v.FamilyName,v.BooleanValue);
  end

  uninitializeSmallLoading();
  local data={};
  data.Stage=recvTable["Stage"];
  data.RemainSeconds=recvTable["RemainSeconds"];
  data.FamilyPromotionArray=recvTable["FamilyPromotionArray"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshStage(data);
  end
end

Handler_27_86.new():execute();