ObtainSilverCloseCommand=class(MacroCommand);

function ObtainSilverCloseCommand:ctor()
	self.class=ObtainSilverCloseCommand;
end

function ObtainSilverCloseCommand:execute(notification)
  self:removeMediator(ObtainSilverMediator.name);
  self:unobserve(ObtainSilverCloseCommand);

  
end