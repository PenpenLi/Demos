
-- 将目标的zOder恢复
require (BATTLE_CLASS_NAME.class)
local BAForResumeTargetsZOder = class("BAForResumeTargetsZOder",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForResumeTargetsZOder.targets 			= nil -- 需要调整的目标
	------------------ functions -----------------------
 	function BAForResumeTargetsZOder:start()
		if(self.targets) then 
			for k,display in pairs(self.targets or {}) do
				display:toRawZOder()
			end
		end
		self.targets = nil
		self:complete()
	end
return BAForResumeTargetsZOder