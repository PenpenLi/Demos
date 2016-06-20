

-- 将目标的zOder设置为rawZOder + 200
require (BATTLE_CLASS_NAME.class)
local BAForUpTargetsZOder = class("BAForUpTargetsZOder",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForUpTargetsZOder.targets 			= nil -- 需要调整的目标
	------------------ functions -----------------------
 	function BAForUpTargetsZOder:start()
		if(self.targets) then 
			for k,display in pairs(self.targets or {}) do
				display:toZOder(display:getRawZOder() + 200)
			end
		end
		self.targets = nil
		self:complete()
	end
return BAForUpTargetsZOder