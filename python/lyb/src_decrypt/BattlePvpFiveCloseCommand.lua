

BattlePvpFiveCloseCommand=class(MacroCommand);

function BattlePvpFiveCloseCommand:ctor()
	self.class=BattlePvpFiveCloseCommand;
end

function BattlePvpFiveCloseCommand:execute()
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	battleProxy.lastAttackData_7_6 = battleProxy:getLastPlaybackData()
	self:addSubCommand(BattleOverCommand)	
  	self:complete({type = "BattlePvpFiveCloseCommand"}) 

  	self:removeCommand(BattleSceneNotifications.BATTLE_PVPFIVE_CLOSE,BattlePvpFiveCloseCommand);
end

