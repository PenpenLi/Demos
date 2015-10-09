--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_90 = class(MacroCommand);

function Handler_27_90:execute()
  print(".27.90.",recvTable["MapId"],recvTable["Count"]);

  local data={};
  data.MapId=recvTable["MapId"];
  data.Count=recvTable["Count"];
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
    possessionBattleMediator:refreshSignCount(data);
  end
end

Handler_27_90.new():execute();