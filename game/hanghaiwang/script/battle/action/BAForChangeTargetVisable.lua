
-- 修改目标为可视
require (BATTLE_CLASS_NAME.class)
local BAForChangeTargetVisable = class("BAForChangeTargetVisable",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForChangeTargetVisable.target 						= nil
	BAForChangeTargetVisable.value 							= nil
 
	-- BAForChangeTargetHp.runAction 						= nil
	-- BAForChangeTargetHp.color 							= nil
	------------------ functions -----------------------
 	function BAForChangeTargetVisable:start()
		if(self.target) then 
		 	-- self.target:setVisible(true)
			self.target:setVisibleWithLevel(self.value,true)
		end
		self.target = nil
		Logger.debug("BAForChangeTargetVisable:start1")
		self:complete()
	end

return BAForChangeTargetVisable
