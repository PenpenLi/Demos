require "main.view.hero.heroPro.HeroProPopupMediator";
Handler_6_6 = class(Command);

function Handler_6_6:execute()
  -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_127));
  print("--------------Handler_6_6");
  local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
  heroProPopupMediator:setData();
end

Handler_6_6.new():execute();