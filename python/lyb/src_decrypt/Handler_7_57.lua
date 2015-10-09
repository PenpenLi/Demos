--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-19

	yanchuan.xie@happyelements.com
]]

Handler_7_57 = class(MacroCommand)

function Handler_7_57:execute()
  --print(".7.57.","RemainSeconds",recvTable["WaiteSeconds"],recvTable["RemainSeconds"]);
  local battleProxy = self:retrieveProxy(BattleProxy.name)
  battleProxy.battleremainSeconds = recvTable["RemainSeconds"]+os.time();
  --print("===================Handler_7_57====================="..recvTable["RemainSeconds"])
end

Handler_7_57.new():execute();