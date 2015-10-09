-------------------------
--BattleInitCommand handler_7_14 handler_7_17
-------------------------

BattleSkillCommand=class(MacroCommand);

function BattleSkillCommand:ctor()
	self.class=BattleSkillCommand;
	self.battleProxy = nil;
end

function BattleSkillCommand:execute(notification)
	require "main.config.BattleConfig"
	require "main.view.battleScene.BattleLayerManager"

    --战场数据
    self.battleProxy = self:retrieveProxy(BattleProxy.name);
    self.userProxy = self:retrieveProxy(UserProxy.name);
    
    if(notification.type == "Handler_7_14") then
        self:attack(notification["untilID"]);
    elseif(notification.type == "Handler_7_17") then
        self:beAttack(notification["untilID"]);
    end
end
--------------------
--攻击方
--------------------
function BattleSkillCommand:attack(playerUnitID)
  local aiEngin = self.battleProxy.aiEnginMap[playerUnitID];
  aiEngin:attackAction();
end
--------------------
--被攻击方
--------------------
function BattleSkillCommand:beAttack(playerUnitID)
	local function beAttackCallBack(tableData)
		tableData.type = "BattleSkillCommand";
	    self:addSubCommand(BattleOverCommand);
		self:complete(tableData);
	end

	local table = {type = "BattleSkillCommand"; untilID = playerUnitID};
    self:addSubCommand(BattleChangeHPCommand);  
    self:complete(table);
end
