TrackItemCloseCommand=class(MacroCommand);

function TrackItemCloseCommand:ctor()
	self.class=TrackItemCloseCommand;
end

function TrackItemCloseCommand:execute(notification)
  self:removeMediator(TrackItemMediator.name);
  self:unobserve(TrackItemCloseCommand);

  if HeroHousePopupMediator then
    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(true);
    end
  end

  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(true);
    end
  end
end