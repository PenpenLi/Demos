
Handler_7_3 = class(MacroCommand)

function Handler_7_3:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name);
    battleProxy.loadFailed = true;
    require "main.controller.command.battleScene.BattleLoadFailedCommand";
    self:addSubCommand(BattleLoadFailedCommand);  
    self:complete();
    --log("=============Handler_7_3_Fail==================="..CommonUtils:getOSTime())
end

Handler_7_3.new():execute();