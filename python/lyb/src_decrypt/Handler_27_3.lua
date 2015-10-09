--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.family.FamilyMediator";

Handler_27_3 = class(Command);

function Handler_27_3:execute()
  sharedTextAnimateReward():animateStartByString("退出家族成功~");
end

Handler_27_3.new():execute();