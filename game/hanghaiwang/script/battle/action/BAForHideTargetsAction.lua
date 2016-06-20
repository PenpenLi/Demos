
-- 设置指定目标的显示为false
require (BATTLE_CLASS_NAME.class)
local BAForHideTargetsAction = class("BAForHideTargetsAction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForHideTargetsAction.targets 					= nil
 
 	------------------ functions -----------------------
 	function BAForHideTargetsAction:start( ... )
 		--print("BAForHideTargetsAction:start")
 		if(self.targets) then
 			for k,target in pairs(self.targets or {}) do
 				 target:setVisible(false)
 			end
 		end 
 		self.targets = nil
 		self:complete()
 	end
return BAForHideTargetsAction