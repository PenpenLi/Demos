--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]


require "main.controller.command.data.LoadingDataInitialize";
require "main.controller.command.data.ServerDataInitialize";



PreLoadDataInitializeCommand=class(MacroCommand);

function PreLoadDataInitializeCommand:ctor()
	self.class=PreLoadDataInitializeCommand;
end

function PreLoadDataInitializeCommand:execute()
  self:addSubCommand(LoadingDataInitialize);
  self:addSubCommand(ServerDataInitialize);
  self:complete();
end