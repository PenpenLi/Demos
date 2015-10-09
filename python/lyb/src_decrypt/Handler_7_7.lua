

Handler_7_7 = class(MacroCommand);

function Handler_7_7:execute()
    self:addSubCommand(BattleOverCommand) 
    self:complete({type = "BattleExitCloseCommand"}) 
end

Handler_7_7.new():execute();