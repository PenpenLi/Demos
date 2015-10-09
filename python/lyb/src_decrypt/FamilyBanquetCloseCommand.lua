
FamilyBanquetCloseCommand=class(Command);

function FamilyBanquetCloseCommand:ctor()
	self.class=FamilyBanquetCloseCommand;
end

function FamilyBanquetCloseCommand:execute(notification)
  self:removeMediator(FamilyBanquetMediator.name);
  self:unobserve(FamilyBanquetCloseCommand);
end
