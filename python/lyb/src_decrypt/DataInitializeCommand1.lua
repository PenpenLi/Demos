
DataInitializeCommand1=class(MacroCommand);

function DataInitializeCommand1:ctor()
	self.class=DataInitializeCommand1;
end

function DataInitializeCommand1:execute()

  self:requireCommand();
  
  self:addSubCommand(UserCurrencyInitialize);
  self:addSubCommand(BattleProxyInitialize);
  self:addSubCommand(ItemUseQueueInitialize);
  self:addSubCommand(BagDataInitialize);
  self:addSubCommand(EquipmentInitialize);
  self:addSubCommand(GeneralListInitialize);
  self:addSubCommand(StrengthenDataInitialize);
  -- self:addSubCommand(AvatarPropertyInitialize);
  self:addSubCommand(StrongPointInfoDataInitialize);
  -- self:addSubCommand(SummonHeroProxyDataInitialize);
  self:complete();
end


function DataInitializeCommand1:requireCommand()
	require "main.controller.command.data.UserCurrencyInitialize";
	require "main.controller.command.data.ItemUseQueueInitialize";
	require "main.controller.command.data.BagDataInitialize";
	require "main.controller.command.data.EquipmentInitialize";
	require "main.controller.command.data.GeneralListInitialize";
	-- require "main.controller.command.data.AvatarPropertyInitialize";
	require "main.controller.command.data.StrengthenDataInitialize";
	require "main.controller.command.data.BattleProxyInitialize";
  require "main.controller.command.data.StrongPointInfoDataInitialize";
  -- require "main.controller.command.data.SummonHeroProxyDataInitialize";
end