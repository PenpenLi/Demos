
DataInitializeCommand4=class(MacroCommand);

function DataInitializeCommand4:ctor()
	self.class=DataInitializeCommand4;
end

function DataInitializeCommand4:execute()
  self:requireCommand();
  -- self:addSubCommand(PetBankDataInitialize);
  -- self:addSubCommand(PetAndRollDataInitialize);
  self:addSubCommand(UserDataAccumulateInitialize);
  -- self:addSubCommand(PetRollDataInitialize);
  -- self:addSubCommand(ObtainSilverDataInitialize);
  -- self:addSubCommand(FirstChargeDataInitialize);
  self:addSubCommand(ShopDataInitialize);
  self:addSubCommand(QianDaoDataInitialize);
  self:addSubCommand(HuoDongDataInitialize);
  self:addSubCommand(MonthCardDataInitialize);
  self:addSubCommand(FirstPayDataInitialize);
  self:addSubCommand(BangDingDataInitialize);
  self:addSubCommand(ZhenFaDataInitialize);
  self:addSubCommand(XunbaoDataInitialize);
  -- self:addSubCommand(LookIntoPlayerDataInitialize);
  self:addSubCommand(MailDataInitialize);
  --开服七天乐 add by mohai.wu
  self:addSubCommand(SevenDaysDataInitialize);
  -- 累充 add by mohai.wu
  self:addSubCommand(SecondPayDataInitialize);

  self:complete();
end

function DataInitializeCommand4:requireCommand()
	-- require "main.controller.command.data.PetBankDataInitialize";
	-- require "main.controller.command.data.PetAndRollDataInitialize";
	require "main.controller.command.data.UserDataAccumulateInitialize";
	-- require "main.controller.command.data.PetRollDataInitialize";
	-- require "main.controller.command.data.ObtainSilverDataInitialize";
	-- require "main.controller.command.data.FirstChargeDataInitialize";
  require "main.controller.command.data.ShopDataInitialize";
  require "main.controller.command.data.QianDaoDataInitialize";
  require "main.controller.command.data.HuoDongDataInitialize";
  require "main.controller.command.data.MonthCardDataInitialize";
  require "main.controller.command.data.FirstPayDataInitialize";
  require "main.controller.command.data.BangDingDataInitialize";
  require "main.controller.command.data.ZhenFaDataInitialize";
  require "main.controller.command.data.XunbaoDataInitialize";

	-- require "main.controller.command.data.LookIntoPlayerDataInitialize";
  require "main.controller.command.data.MailDataInitialize";
  require "main.controller.command.data.SevenDaysDataInitialize"
  require "main.controller.command.data.SecondPayDataInitialize"
end