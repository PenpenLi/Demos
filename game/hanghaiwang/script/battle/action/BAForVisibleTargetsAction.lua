



-- 设置指定目标的为显示
require (BATTLE_CLASS_NAME.class)
local BAForVisibleTargetsAction = class("BAForVisibleTargetsAction",require(BATTLE_CLASS_NAME.BaseAction))
  
 	------------------ properties ----------------------
 	BAForVisibleTargetsAction.targets 					= nil
 
 	------------------ functions -----------------------
 	function BAForVisibleTargetsAction:start( ... )
 		--print("BAForVisibleTargetsAction:start")
 		if(self.targets) then
 			for k,target in pairs(self.targets or {}) do
 				-- 死亡的不用更改
 				if(not target.isDead) then
 				 	target:setVisible(true)
 				end
 			end
 		end 
 		self.targets = nil
 		self:complete()
 	end
return BAForVisibleTargetsAction