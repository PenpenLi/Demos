--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroChangeEquipeCloseCommand=class(Command);

function HeroChangeEquipeCloseCommand:ctor()
	self.class=HeroChangeEquipeCloseCommand;
end

function HeroChangeEquipeCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroChangeEquipePopupMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroChangeEquipeCloseCommand);

end