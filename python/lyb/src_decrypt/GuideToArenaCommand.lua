
GuideToArenaCommand=class(MacroCommand);

function GuideToArenaCommand:ctor()
	self.class=GuideToArenaCommand;
end

function GuideToArenaCommand:execute(notification)
  self:addSubCommand(MainSceneToArenaCommand);
  self:complete();
end