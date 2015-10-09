require "core.mvc.pattern.Application";
require "main.controller.command.data.PreLoadDataInitializeCommand";
require "main.controller.command.GameStartCommand";
require "main.config.GameVar"
GameStart = class(Application);

function GameStart:initialize()

  self:registerCommand(Notifications.APPLICATION_START,PreLoadDataInitializeCommand);
  self:registerCommand(Notifications.APPLICATION_START,GameStartCommand);
  startupSchedule();
end

