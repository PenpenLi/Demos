FiveEleBtleCloseCommand=class(Command);

function FiveEleBtleCloseCommand:ctor()
	self.class=FiveEleBtleCloseCommand;
end

function FiveEleBtleCloseCommand:execute(notification)
  self:removeMediator(HuiGuMediator.name);
  self:unobserve(FiveEleBtleCloseCommand);

end