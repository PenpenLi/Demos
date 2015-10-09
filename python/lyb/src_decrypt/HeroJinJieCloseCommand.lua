--
-- Author: Your Name
-- Date: 2014-08-27 11:11:45
--

HeroJinJieCloseCommand=class(Command);

function HeroJinJieCloseCommand:ctor()
	self.class=HeroJinJieCloseCommand;
end

function HeroJinJieCloseCommand:execute(notification)
	print("==============close");
  self:removeMediator(HeroJinJiePopupMediator.name);
  -- self:removeCommand(HeroBankNotifications.HERO_TIPS_COMMAND,HeroBankToDetailTipsCommand);
  self:unobserve(HeroJinJieCloseCommand);

end