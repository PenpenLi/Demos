--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroSkillCloseCommand=class(Command);

function HeroSkillCloseCommand:ctor()
	self.class=HeroSkillCloseCommand;
end

function HeroSkillCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroSkillPopupMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroSkillCloseCommand);

end