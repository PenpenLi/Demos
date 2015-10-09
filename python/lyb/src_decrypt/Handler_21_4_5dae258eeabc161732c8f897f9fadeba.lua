--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_21_4 = class(MacroCommand);

function Handler_21_4:execute()
  sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_168));
end

Handler_21_4.new():execute();