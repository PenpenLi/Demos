--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.possessionBattle.PossessionBattleMediator";

Handler_27_85 = class(Command);

function Handler_27_85:execute()
  print(".27.85.",recvTable["BooleanValue"]);
  sharedTextAnimateReward():animateStartByString(1==recvTable["BooleanValue"] and "抢夺位置成功咯~" or "抢夺位置失败鸟...");
end

Handler_27_85.new():execute();