HandofMidasUICloseCommand=class(MacroCommand);

function HandofMidasUICloseCommand:ctor()
	self.class=HandofMidasUICloseCommand;
end

function HandofMidasUICloseCommand:execute(notification)
  self:removeMediator(HandofMidasMediator.name);
  self:unobserve(HandofMidasUICloseCommand);
end