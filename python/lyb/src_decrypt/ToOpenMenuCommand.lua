
ToOpenMenuCommand=class(Command);

function ToOpenMenuCommand:ctor()
	self.class=ToOpenMenuCommand;
end

function ToOpenMenuCommand:execute(notification)
  local hButtonGroupMediator = self:retrieveMediator(HButtonGroupMediator.name)
  if hButtonGroupMediator then
	hButtonGroupMediator:openMenu(notification.data.isOpen);
  end

  local buttonGroupMediator = self:retrieveMediator(ButtonGroupMediator.name)
  if buttonGroupMediator then
	buttonGroupMediator:openMenu(notification.data.isOpen);
  end

end
