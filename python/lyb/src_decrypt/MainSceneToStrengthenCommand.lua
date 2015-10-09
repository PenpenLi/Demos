--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-3-13

	yanchuan.xie@happyelements.com
]]

require "main.view.strengthen.StrengthenPopupMediator";

MainSceneToStrengthenCommand=class(Command);

function MainSceneToStrengthenCommand:ctor()
	self.class=MainSceneToStrengthenCommand;
end

function MainSceneToStrengthenCommand:execute(notification)
  self:require();
  --StrengthenPopupMediator
  self.strengthenPopupMediator=self:retrieveMediator(StrengthenPopupMediator.name);  
  if nil==self.strengthenPopupMediator then
    self.strengthenPopupMediator=StrengthenPopupMediator.new(notification);
    self:registerMediator(self.strengthenPopupMediator:getMediatorName(),self.strengthenPopupMediator);

    self:registerStrengthenCommands();
  end
  -- sharedMainLayerManager():getLayer(MainConfig.MAIN_LAYER_POPUP):addChild(self.strengthenPopupMediator:getViewComponent());
  LayerManager:addLayerPopable(self.strengthenPopupMediator:getViewComponent());
  self:observe(StrengthenCloseCommand);
  if GameVar.tutorStage == TutorConfig.STAGE_1020 then
    openTutorUI({x=627, y=88, width = 190, height = 60, alpha = 125});--, showPerson = true
  elseif GameVar.tutorStage == TutorConfig.STAGE_2010 then
    print("++++++++++++++++++++++++++++++da dian step", 201002)
    hecDC(5, 201002)
    hecDC(5, 201003)
    GameVar.tutorSmallStep = 201003
    openTutorUI({x=1172, y=362, width = 77, height = 120, alpha = 125});--, showPerson = true
  end
  --setButtonGroupVisible(false);
  self:refreshMediator();
end

function MainSceneToStrengthenCommand:refreshMediator()
  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(false);
    end
  end
end

function MainSceneToStrengthenCommand:registerStrengthenCommands()
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_DEGRADE,StrengthenDegradeCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_FORGE,StrengthenForgeCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_LEVELUP,StrengthenLevelupCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_LEVELUP_MAX,StrengthenLevelupMaxCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_STARADD,StrengthenStarAddCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_TRACK,StrengthenTrackCommand);
  self:registerCommand(StrengthenPopupNotifications.STRENGTHEN_CLOSE,StrengthenCloseCommand);
end

function MainSceneToStrengthenCommand:require()
  require "main.controller.command.strengthenPopup.StrengthenDegradeCommand";
  require "main.controller.command.strengthenPopup.StrengthenForgeCommand";
  require "main.controller.command.strengthenPopup.StrengthenLevelupCommand";
  require "main.controller.command.strengthenPopup.StrengthenLevelupMaxCommand";
  require "main.controller.command.strengthenPopup.StrengthenStarAddCommand";
  require "main.controller.command.strengthenPopup.StrengthenTrackCommand";
  require "main.controller.command.strengthenPopup.StrengthenCloseCommand";
  require "main.controller.notification.StrengthenPopupNotification";
  require "main.model.UserProxy";
end