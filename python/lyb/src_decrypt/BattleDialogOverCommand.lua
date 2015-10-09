BattleDialogOverCommand=class(MacroCommand);

function BattleDialogOverCommand:ctor()
	self.class=BattleDialogOverCommand;
end

function BattleDialogOverCommand:execute(notification)
	-- self:removeMediator(ModalDialogMediator.name);
	-- self:unobserve(BattleDialogOverCommand);
	-- 新手脚本用
	local table_green = {type = "GreenHandBattle"};
	if notification.type == "GreenHandBattle" then
		self:addSubCommand(GreenHandBattle)		
		self:complete(table_green)		
		return
	end

	local table = {type = "BattleDialogOverCommand"};
	local tableMid = {type = "BattleDialogMidOverCommand"};
	local battleProxy = self:retrieveProxy(BattleProxy.name);

	if battleProxy.dialogType == BattleConfig.Battle_Dialog_Inter then--开始战斗
			self:addSubCommand(BattleInitCommand)
			self:complete(table) 
	elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_Middle_Behind then--中间战斗后
			self:addSubCommand(BattleInitCommand)
			self:complete(tableMid) 
	elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_Middle_Before then--中间战斗前
			self:addSubCommand(BattleInitCommand)
			self:complete(tableMid) 			
	elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_Leave then--战斗结束
			self:addSubCommand(BattleOverCommand)
			self:complete(table) 
	elseif battleProxy.dialogType == BattleConfig.Battle_Dialog_GREEN then--新手战斗
			battleProxy.greenHandBattle:dialogOtherOver()
			closeTutorUI()
	end
	--self:removeCommand(BattleSceneNotifications.BATTLE_DIALOG_OVER,BattleDialogOverCommand);
end
