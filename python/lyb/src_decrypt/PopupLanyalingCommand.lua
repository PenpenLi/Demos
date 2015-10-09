-- PopupLanyalingCommand

require "main.view.langyaling.LangyalingMediator";

PopupLanyalingCommand=class(Command);

function PopupLanyalingCommand:ctor()
	self.class=PopupLanyalingCommand;
end

function PopupLanyalingCommand:execute(notification)
	local data=notification:getData();

	local langyalingMediator = self:retrieveMediator(LangyalingMediator.name)
	if nil == langyalingMediator then
		langyalingMediator = LangyalingMediator.new()
		self:registerMediator(langyalingMediator:getMediatorName(),langyalingMediator);
	end
	langyalingMediator = self:retrieveMediator(LangyalingMediator.name)
	if nil == langyalingMediator then
		return;
	end

	LayerManager:addLayerPopable(langyalingMediator:getViewComponent());
	--setButtonGroupVisible(false)
	if GameVar.tutorStage == TutorConfig.STAGE_1003 then
		self.bagProxy = self:retrieveProxy(BagProxy.name);
		local langyalingCount = self.bagProxy:getItemNum(1009001)
		print("langyalingCount", langyalingCount)
		if langyalingCount == 1 then
			print("langyalingCount == 1")
			GameVar.tutorSmallStep = 100302
    		openTutorUI({x=763, y=55, width = 261, height = 537, alpha = 125});
		else
			print("langyalingCount ~= 1")
			GameVar.tutorSmallStep = 100306
    		openTutorUI({x=254, y=55, width = 261, height = 537, alpha = 125});
		end
    end
    print("PopupLanyalingCommand, GameVar.tutorStage", GameVar.tutorStage)

    if HeroHousePopupMediator then
	    local mediator = self:retrieveMediator(HeroHousePopupMediator.name);
	    if mediator then
	      mediator:getViewComponent().pageView:setMoveEnabled(false);
	    end
	  end

	if HeroProPopupMediator then
	    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
	    if mediator then
	      mediator:getViewComponent().pageView:setMoveEnabled(false);
	    end
	  end
end