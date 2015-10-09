--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]
require "main.view.hero.heroTeam.HeroTeamSubMediator";
Handler_6_13 = class(Command);

function Handler_6_13:execute()
  -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_127));
  print("--------------Handler_6_13");
  local heroTeamSubMediator=self:retrieveMediator(HeroTeamSubMediator.name);
  heroTeamSubMediator:setData();
end

Handler_6_13.new():execute();