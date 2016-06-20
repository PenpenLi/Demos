


-- 用于 BSTree(行为选择树) 内部结束回调的节点
-- blackBoard.treeComplete 为回调函数
require (BATTLE_CLASS_NAME.class)
local BAForChangeTargetRageData = class("BAForChangeTargetRageData",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForChangeTargetRageData.target 							= nil
	BAForChangeTargetRageData.value 							= nil
	-- BAForChangeTargetHp.runAction 						= nil
	-- BAForChangeTargetHp.color 							= nil
	------------------ functions -----------------------
 	function BAForChangeTargetRageData:start()
		if(self.target ~= nil and self.value ~= nil) then 
		 	self.target:rageChangeBy(self.value)
		else
			--print("BAForChangeTargetRageData target:",self.target," value:",self.value)
		end
		self.target = nil
		self:complete()
	end

return BAForChangeTargetRageData