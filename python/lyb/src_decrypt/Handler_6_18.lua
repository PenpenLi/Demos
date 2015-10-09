require "main.view.hero.heroPro.HeroProPopupMediator";
Handler_6_18 = class(Command);

function Handler_6_18:execute()
	uninitializeSmallLoading();
  -- sharedTextAnimateReward():animateStartByString(StringUtils:getString4Popup(PopupMessageConstConfig.ID_127));
  -- print("--------------Handler_6_18");
  -- local heroProPopupMediator=self:retrieveMediator(HeroProPopupMediator.name);
  -- heroProPopupMediator:setData();

  -- if StrongPointInfoMediator then
  --   self.strongPointInfoMediator=self:retrieveMediator(StrongPointInfoMediator.name);
  --   if self.strongPointInfoMediator then
  --   	self.strongPointInfoMediator:refreshMyTeam()
  --   end
  -- end
  sharedTextAnimateReward():animateStartByString("激活成功 ~");
  if HeroHousePopupMediator then
    local heroHousePopupMediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if heroHousePopupMediator then
      heroHousePopupMediator:getViewComponent().pageView:setMoveEnabled(true);
      heroHousePopupMediator:getViewComponent():refreshOnPopCard();
      heroHousePopupMediator:getViewComponent():popCardByJihuo();
    end
  end
end

Handler_6_18.new():execute();