StrongPointInfoCloseCommand=class(MacroCommand);

function StrongPointInfoCloseCommand:ctor()
	self.class=StrongPointInfoCloseCommand;
end

function StrongPointInfoCloseCommand:execute(notification)
  self:removeMediator(StrongPointInfoMediator.name);
  self:unobserve(StrongPointInfoCloseCommand);
  if StoryLineMediator then
	local storyLineMediator=self:retrieveMediator(StoryLineMediator.name);  
	if storyLineMediator then
		print("storyLineMediator:setMoveEnabled(true)")
		storyLineMediator:setMoveEnabled(true);
	end
  end
  self:refreshMediator();
end

function StrongPointInfoCloseCommand:refreshMediator()
if HeroHousePopupMediator then
    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(true);
    end
  end
  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent():refreshCurrentData();
      mediator:getViewComponent().pageView:setMoveEnabled(true);
    end
  end
end