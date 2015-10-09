
FamilyHoldBanquetCloseCommand=class(Command);

function FamilyHoldBanquetCloseCommand:ctor()
	self.class=FamilyHoldBanquetCloseCommand;
end

function FamilyHoldBanquetCloseCommand:execute(notification)
  self:removeMediator(FamilyHoldBanquetMediator.name);
  self:unobserve(FamilyHoldBanquetCloseCommand);
end
