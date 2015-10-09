--[[
	Copyright @2009-2013 www.happyelements.com, all rights reserved.
	Create date: 2013-2-20

	yanchuan.xie@happyelements.com
]]

DataInitializeCommand2=class(MacroCommand);

function DataInitializeCommand2:ctor()
	self.class=DataInitializeCommand2;
end

function DataInitializeCommand2:execute()

  self:requireCommand();
  self:addSubCommand(HeroHouseDataInitialize);
  self:addSubCommand(ArenaDataInitialize);
  -- self:addSubCommand(EighteenCopperInitialize);
  self:addSubCommand(VipInitialize);
  -- self:addSubCommand(ChallengeInitialize);
  -- self:addSubCommand(LittleHelperInitialize);
  self:addSubCommand(TaskDataInitialize);
  self:addSubCommand(TenCountryDataInitialize);
  self:complete();
end


function DataInitializeCommand2:requireCommand()
	require "main.controller.command.data.HeroHouseDataInitialize";
	require "main.controller.command.data.ArenaDataInitialize";
	-- require "main.controller.command.data.EighteenCopperInitialize";
	require "main.controller.command.data.VipInitialize";
	-- require "main.controller.command.data.ChallengeInitialize";
	-- require "main.controller.command.data.LittleHelperInitialize";
	require "main.controller.command.data.TaskDataInitialize";
	require "main.controller.command.data.TenCountryDataInitialize";
end