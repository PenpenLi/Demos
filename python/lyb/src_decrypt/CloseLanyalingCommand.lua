-- CloseLanyalingCommand

CloseLanyalingCommand=class(Command);

function CloseLanyalingCommand:ctor()
	self.class = CloseLanyalingCommand;
end

function CloseLanyalingCommand:execute(notification)
  self:removeMediator(LangyalingMediator.name);
  -- print("notification.data", notification.data);
	if GameVar.tutorStage == TutorConfig.STAGE_1003 and not notification.data then
	 	local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
	    local targetPosData = hBttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_24)
	    openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_STORY_BTN_W, height = GameConfig.TUTOR_STORY_BTN_H});
	end
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