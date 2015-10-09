
GuideToEighteenCopperCommand=class(MacroCommand);

function GuideToEighteenCopperCommand:ctor()
	self.class=GuideToEighteenCopperCommand;
end

function GuideToEighteenCopperCommand:execute(notification)
  self:addSubCommand(MainSceneToEighteenCopperCommand);
  self:complete();
end