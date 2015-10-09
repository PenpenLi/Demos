
GuideToTowerCommand=class(MacroCommand);

function GuideToTowerCommand:ctor()
	self.class=GuideToTowerCommand;
end

function GuideToTowerCommand:execute(notification)
  self:addSubCommand(MainSceneToTowerCommand);
  self:complete();
end