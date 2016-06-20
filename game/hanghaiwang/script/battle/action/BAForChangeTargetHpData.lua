





-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForChangeTargetHpData = class("BAForChangeTargetHpData",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForChangeTargetHpData.target 							= nil
	BAForChangeTargetHpData.value 							= nil
	-- BAForChangeTargetHp.runAction 						= nil
	-- BAForChangeTargetHp.color 							= nil
	------------------ functions -----------------------
 	function BAForChangeTargetHpData:start()
		if(self.target ~= nil and self.value ~= nil) then 
		 	self.target:hpChangeBy(self.value)
		else
			--print("BAForChangeTargetHpData target:",self.target.name," value:",self.value)
		end
		self.target = nil
		self:complete()
	end

return BAForChangeTargetHpData