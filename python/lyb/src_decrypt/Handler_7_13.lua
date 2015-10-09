--[[
    战斗单位死亡
  ]]
Handler_7_13 = class(MacroCommand)

function Handler_7_13:execute()

    --[[local battleUnitID = recvTable["BattleUnitID"];
    local tableData = {type = "Handler_7_13", untilID = battleUnitID};
	
	local battleProxy = self:retrieveProxy(BattleProxy.name)
	local generalVO = battleProxy.battleGeneralArray[battleUnitID]
	if generalVO and generalVO.isLastAttack == true then
		battleProxy.lastAttackData_7_13 = tableData
	else
		self:addSubCommand(BattleOverCommand);  
		self:complete(tableData);	
	end]]
	--battleProxy.deadUnitID = battleUnitID;
end

Handler_7_13.new():execute();