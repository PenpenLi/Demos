--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]
require "main.view.hero.heroPro.HeroProPopupMediator";
Handler_6_7 = class(Command);

function Handler_6_7:execute()
  -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_127));
  print("--------------Handler_6_7");
  uninitializeSmallLoading(2);
  local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
  heroProPopupMediator:setData();
end

Handler_6_7.new():execute();