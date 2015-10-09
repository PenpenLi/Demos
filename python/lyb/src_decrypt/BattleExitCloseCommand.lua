

BattleExitCloseCommand=class(MacroCommand);

function BattleExitCloseCommand:ctor()
	self.class=BattleExitCloseCommand;
end

function BattleExitCloseCommand:execute()
	self.battleProxy = self:retrieveProxy(BattleProxy.name);
    self.battleProxy:cleanBattleOverData()

  	self:removeCommand(BattleSceneNotifications.BATTLE_EXIT,BattleExitCloseCommand);
end

