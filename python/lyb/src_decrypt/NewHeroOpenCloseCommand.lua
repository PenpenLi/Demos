NewHeroOpenCloseCommand=class(Command);

function NewHeroOpenCloseCommand:ctor()
	self.class=NewHeroOpenCloseCommand;
end

function NewHeroOpenCloseCommand:execute(notification)
  self:removeMediator(NewHeroOpenMediator.name);
  self:unobserve(NewHeroOpenCloseCommand);

end