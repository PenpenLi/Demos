-- 成功返回
Handler_1_2 = class(MacroCommand);

function Handler_1_2:execute()
    local mainCommand = recvTable["MainCommand"];
    local subCommand = recvTable["SubCommand"];
    print("mainCommand",mainCommand, "subCommand", subCommand)
    local commandName = "main.controller.handler.success.Handler_" .. mainCommand .. "_" .. subCommand;
    package.loaded[commandName] = nil
    require(commandName);
    
end

Handler_1_2.new():execute();