
GuideToPetCommand=class(MacroCommand);

function GuideToPetCommand:ctor()
	self.class=GuideToPetCommand;
end

function GuideToPetCommand:execute(notification)
  	self:addSubCommand(MainSceneToPetAndRollCommand);
  	self:complete();
  	self.petAndRollMediator=self:retrieveMediator(PetAndRollMediator.name);
  	self.petAndRollMediator:changeTab(notification:getData().TabNumber);
end