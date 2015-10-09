--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-21

	yanchuan.xie@happyelements.com
]]

StrengthenCloseCommand=class(Command);

function StrengthenCloseCommand:ctor()
	self.class=StrengthenCloseCommand;
end

function StrengthenCloseCommand:execute(notification)
  self:removeMediator(StrengthenPopupMediator.name);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_DEGRADE,StrengthenDegradeCommand);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_FORGE,StrengthenForgeCommand);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_LEVELUP,StrengthenLevelupCommand);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_LEVELUP_MAX,StrengthenLevelupMaxCommand);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_STARADD,StrengthenStarAddCommand);
  self:removeCommand(StrengthenPopupNotifications.STRENGTHEN_CLOSE,StrengthenCloseCommand);
  self:unobserve(StrengthenCloseCommand);

  if GameVar.tutorStage == TutorConfig.STAGE_2010 or  GameVar.tutorStage == TutorConfig.STAGE_1020 then
    sendServerTutorMsg({})
    closeTutorUI();
  end
  self:refreshMediator();
  --setButtonGroupVisible(true);
end

function StrengthenCloseCommand:refreshMediator()
  if HeroProPopupMediator then
    local mediator = self:retrieveMediator(HeroProPopupMediator.name);
    if mediator then
      mediator:getViewComponent().pageView:setMoveEnabled(true);
      mediator:getViewComponent():refreshCurrentData();
    end
  end
end