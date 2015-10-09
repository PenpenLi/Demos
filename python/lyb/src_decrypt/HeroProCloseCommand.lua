--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroProCloseCommand=class(Command);

function HeroProCloseCommand:ctor()
	self.class=HeroProCloseCommand;
end

function HeroProCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroProPopupMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroProCloseCommand);

  local heroHousePopupMediator = self:retrieveMediator(HeroHousePopupMediator.name);
  if heroHousePopupMediator then
    heroHousePopupMediator:getViewComponent().pageView:setMoveEnabled(true);
  	heroHousePopupMediator:getViewComponent():refreshOnProClose();
  end
  if  GameVar.tutorStage == TutorConfig.STAGE_1010 then
    openTutorUI({x=1182, y=628, width = 78, height = 75, alpha = 125});
  elseif GameVar.tutorStage == TutorConfig.STAGE_1004 then
    print("GameVar.tutorStage == TutorConfig.STAGE_1004")
    openTutorUI({x=1182, y=632, width = 78, height = 75, alpha = 125});

  elseif GameVar.tutorStage == TutorConfig.STAGE_1009 then
    hecDC(5, 100909)
    GameVar.tutorSmallStep = 100909
    openTutorUI({x=1178, y=632, width = 78, height = 75, alpha = 125, fullScreenTouchable = true, hideTutorHand = true, blackBg = true});
    self.tutorLayer = Layer.new();
    self.tutorLayer:initLayer();
    self.tutorLayer:setContentSize(Director:sharedDirector():getWinSize());
    self.tutorLayer:addEventListener(DisplayEvents.kTouchTap, self.onTutorTap, self);
    sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):addChild(self.tutorLayer)

  end
end
function HeroProCloseCommand:onTutorTap(event)
  print("function HeroShipinXilianLayer:onTutorTap(event)")
  if GameVar.tutorStage == TutorConfig.STAGE_1009 then
   hecDC(5, 100910)
   sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_EFFECTS):removeChild(self.tutorLayer)
   sendServerTutorMsg({});
   GameVar.tutorStage = TutorConfig.STAGE_99999
   closeTutorUI();
  end
end