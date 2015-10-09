--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-4-17

	yanchuan.xie@happyelements.com
]]

Handler_27_89 = class(MacroCommand);

function Handler_27_89:execute()
  print(".27.89.",#recvTable["IDArray"]);
  for k,v in pairs(recvTable["IDArray"]) do
    print(".27.89..",v.ID);
  end

  uninitializeSmallLoading();
  require "main.controller.command.shop.OpenShopUICommand";
  self:addSubCommand(OpenShopUICommand);
  self:complete({PossisseionBattle=true,IDArray=recvTable["IDArray"]});
end

Handler_27_89.new():execute();