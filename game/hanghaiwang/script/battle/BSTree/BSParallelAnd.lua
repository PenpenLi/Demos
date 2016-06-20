-- 执行所有children 节点,有1个为true,则返回true, 全部为false则返回false
local BSParallelAnd = class("BSParallelAnd",require(BATTLE_CLASS_NAME.BattleTreeNode))
	
return BSParallelAnd