-------------------------
-- CloseBattleOverMediatorCommand
-------------------------

CloseBattleOverMediatorCommand=class(Command);

function CloseBattleOverMediatorCommand:ctor()
	self.class=CloseBattleOverMediatorCommand;
end

function CloseBattleOverMediatorCommand:execute()
	--self:removeMediator(BattleOverMediator.name);
	self:removeCommand(BattleSceneNotifications.TO_LOTTERY,BattleToLotteryCommand);
	self:removeCommand(BattleSceneNotifications.CLOSE_BATTLEOVER_MEDIATOR,CloseBattleOverMediatorCommand);	
	-- self:removeCommand(BattleSceneNotifications.BATTLE_MIDDLE_DIALOG,BattleDialogMiddleCommand);
	self:removeCommand(BattleSceneNotifications.Battle_UnitID_Dead,BattleUnitDeadCommand);
	self:removeCommand(BattleSceneNotifications.Battle_UnitID_Hurt,BattleChangeHPCommand);
end
