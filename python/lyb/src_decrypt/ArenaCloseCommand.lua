

ArenaCloseCommand=class(MacroCommand);

function ArenaCloseCommand:ctor()
	self.class=ArenaCloseCommand;
end

function ArenaCloseCommand:execute(notification)
  self:removeMediator(JingjichangMediator.name);
  self:removeCommand(ArenaNotifications.ARENA_CLOSE_COMMOND,ArenaCloseCommand);
  --[[local challengeMediator=self:retrieveMediator(ChallengeMediator.name);
  if nil~=challengeMediator then
    	challengeMediator:setScrollViewMove();
  end]]
  self:unobserve(ArenaCloseCommand);
  
  local currencyGroupMediator=self:retrieveMediator(CurrencyGroupMediator.name);
  if currencyGroupMediator then
    currencyGroupMediator:areaExitRongYu()
  end
  if GameVar.tutorStage == TutorConfig.STAGE_1016 then
    self.arenaProxy=self:retrieveProxy(ArenaProxy.name);
    if self.arenaProxy.afterBattle then
      sendServerTutorMsg({})
      closeTutorUI();
    end
  end
 --  require "main.controller.command.mainScene.ToTenCountryCommand";
 -- self:addSubCommand(ToTenCountryCommand);
 -- self:complete()
end
