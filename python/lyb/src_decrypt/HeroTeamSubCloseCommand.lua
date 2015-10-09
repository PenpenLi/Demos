--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroTeamSubCloseCommand=class(Command);

function HeroTeamSubCloseCommand:ctor()
	self.class=HeroTeamSubCloseCommand;
end

function HeroTeamSubCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroTeamSubMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroTeamSubCloseCommand);
  if GameVar.tutorStage == TutorConfig.STAGE_1016 then
    self.arenaProxy=self:retrieveProxy(ArenaProxy.name);
    if self.arenaProxy.afterBattle then
      
    else
      self.arenaProxy.afterBattle = true
    end
  end

end