
-- 修改目标为不可视
require (BATTLE_CLASS_NAME.class)
local BAForChangeTargetUnVisable = class("BAForChangeTargetUnVisable",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForChangeTargetUnVisable.target 						= nil
	BAForChangeTargetUnVisable.value 							= nil
 
	-- BAForChangeTargetHp.runAction 						= nil
	-- BAForChangeTargetHp.color 							= nil
	------------------ functions -----------------------
 	function BAForChangeTargetUnVisable:start()
 		Logger.debug("BAForChangeTargetUnVisable:start1")
		if(self.target) then 
			-- Logger.debug("BAForChangeTargetUnVisable:start2")
		 -- 	self.target:setVisible(false)
		 	self.target:setVisibleWithLevel(self.value,false)
		end
		self.target = nil
		self:complete()
	end

return BAForChangeTargetUnVisable
