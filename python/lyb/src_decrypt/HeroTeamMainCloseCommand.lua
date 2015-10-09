--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroTeamMainCloseCommand=class(Command);

function HeroTeamMainCloseCommand:ctor()
	self.class=HeroTeamMainCloseCommand;
end

function HeroTeamMainCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroTeamMainMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroTeamMainCloseCommand);

end