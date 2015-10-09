

DataInitializeCommand5=class(MacroCommand);

function DataInitializeCommand5:ctor()
	self.class=DataInitializeCommand5;
end

function DataInitializeCommand5:execute()

  self:requireCommand();
  -- self:addSubCommand(AchievementDataInitialize);
  -- self:addSubCommand(TitleDataInitializeCommand);
  self:addSubCommand(RankListDataInitialize);
  -- self:addSubCommand(SystemMarkDataInitialize);
  -- self:addSubCommand(LoginLotteryDataInitialize);
  self:addSubCommand(ActivityDataInitialize);
  self:addSubCommand(SmallChatDataInitialize);
  self:addSubCommand(OpenFuncionInitialize);
  -- self:addSubCommand(FactionBattleDataInitialize);
  self:addSubCommand(EffectDataInitialize);
  -- self:addSubCommand(BugReportDataInitialize);
  self:addSubCommand(FamilyDataInitialize);
  -- self:addSubCommand(FamilyTaskDataInitialize);
  -- self:addSubCommand(FirstSevenDataInitialize);
  -- self:addSubCommand(TeamShadowDataInitialize);
  -- self:addSubCommand(OperationBonusDataInitialize);
  -- self:addSubCommand(PossessionBattleDataInitialize);
  self:addSubCommand(ServerMergeDataInitialize);
  self:addSubCommand(CommonDataInitialize);
  self:complete();


  require "main.model.OperationProxy"

  local operationProxy=OperationProxy.new();
  self:registerProxy(operationProxy:getProxyName(),operationProxy);

end

function DataInitializeCommand5:requireCommand()
	-- require "main.controller.command.data.AchievementDataInitialize";
	-- require "main.controller.command.data.TitleDataInitializeCommand";
	require "main.controller.command.data.RankListDataInitialize";
	-- require "main.controller.command.data.SystemMarkDataInitialize";
	-- require "main.controller.command.data.LoginLotteryDataInitialize";
	require "main.controller.command.data.ActivityDataInitialize";
	require "main.controller.command.data.SmallChatDataInitialize";
	require "main.controller.command.data.OpenFuncionInitialize";
	require "main.controller.command.data.BattleProxyInitialize";
	-- require "main.controller.command.data.FactionBattleDataInitialize";
	require "main.controller.command.data.EffectDataInitialize";
	-- require "main.controller.command.data.BugReportDataInitialize";
	require "main.controller.command.data.FamilyDataInitialize";
	-- require "main.controller.command.data.FamilyTaskDataInitialize";
	-- require "main.controller.command.data.FirstSevenDataInitialize";
	-- require "main.controller.command.data.TeamShadowDataInitialize";
	-- require "main.controller.command.data.OperationBonusDataInitialize";
	-- require "main.controller.command.data.PossessionBattleDataInitialize";
	require "main.controller.command.data.ServerMergeDataInitialize";
  require "main.controller.command.data.CommonDataInitialize";
end