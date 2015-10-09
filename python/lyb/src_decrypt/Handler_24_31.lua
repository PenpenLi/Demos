--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

require "main.view.activity.ActivityMediator";

Handler_24_31 = class(MacroCommand);

function Handler_24_31:execute()
  log(".24.31." .. #recvTable["IDArray"]);
  for k,v in pairs(recvTable["IDArray"]) do
    log(".24.31.." .. v.ID);
  end

  local activityProxy=self:retrieveProxy(ActivityProxy.name);
  activityProxy:refreshActivityEffectIDs(recvTable["IDArray"]);

  require "main.controller.command.mainScene.MainSceneIconEffectCommand";
  self:addSubCommand(MainSceneIconEffectCommand);
  self:complete();
end

Handler_24_31.new():execute();