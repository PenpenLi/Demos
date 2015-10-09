--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_84 = class(Command);

function Handler_27_84:execute()
  print(".27.84.",recvTable["MapId"]);

  uninitializeSmallLoading();
  
  local possessionBattleMediator=self:retrieveMediator(PossessionBattleMediator.name);
  if nil~=possessionBattleMediator then
  	possessionBattleMediator:refreshDeployConfirmed(recvTable["MapId"]);
  end
end

Handler_27_84.new():execute();