--[[

]]

require "main.view.shadow.ShadowHeroImageMediator";

OpenHeroImageUICommand=class(Command);

function OpenHeroImageUICommand:ctor()
	self.class=OpenHeroImageUICommand;
end

function OpenHeroImageUICommand:execute(notification)
  self:require();
  local strongPointId = nil;
  local showNewHeroEffect = nil;
  if notification and notification.data then
    print("notification.data.strongPointId", notification.data.strongPointId);
    strongPointId = notification.data.strongPointId
    showNewHeroEffect = notification.data.showNewHeroEffect;
  end


  self.shadowHeroMed=self:retrieveMediator(ShadowHeroImageMediator.name);  
  if nil==self.shadowHeroMed then
    self.shadowHeroMed=ShadowHeroImageMediator.new();

    self:registerMediator(self.shadowHeroMed:getMediatorName(),self.shadowHeroMed);
    print("999999999999999999999  strongPointId", strongPointId)
    self.shadowHeroMed:initializeUI(strongPointId);

    self:registerShadownCommand();
  end

  self:observe(HeroImageCloseCommand);
  LayerManager:addLayerPopable(self.shadowHeroMed:getViewComponent());

  if showNewHeroEffect then
    self.shadowHeroMed:showNewHeroEffect();
  end

  if GameVar.tutorStage == TutorConfig.STAGE_1007 then
    openTutorUI({x=1080, y=66, width = 122, height = 132, alpha = 125});
  end
  -- self.shadowHeroMed:getViewComponent():setVisible(false)

  hecDC(3,30,1)

end

function OpenHeroImageUICommand:registerShadownCommand()
  self:registerCommand(ShadowNotifications.CLOSE_HEROIMAGE_UI_COMMAND, HeroImageCloseCommand);
end

function OpenHeroImageUICommand:require()
  require "main.controller.command.shadow.HeroImageCloseCommand";
end