HeroImageCloseCommand=class(MacroCommand);

function HeroImageCloseCommand:ctor()
	self.class=HeroImageCloseCommand;
end

function HeroImageCloseCommand:execute(notification)
  self:removeMediator(ShadowHeroImageMediator.name);
  self:unobserve(HeroImageCloseCommand);


  if HButtonGroupMediator then
    local hBttonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name);
    if hBttonGroupMediator then
      hBttonGroupMediator:refreshYingXiongZhi();
    end

  end
  if ButtonGroupMediator then
    local bttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name);
    if GameVar.tutorStage == TutorConfig.STAGE_1008 then
        local targetPosData = bttonGroupMediator:getTargetButtonPosition(FunctionConfig.FUNCTION_ID_13)--英雄库
        openTutorUI({x=targetPosData.x, y=targetPosData.y, width = GameConfig.TUTOR_BIG_BTN_W, height = GameConfig.TUTOR_BIG_BTN_H});
    end
  end
end