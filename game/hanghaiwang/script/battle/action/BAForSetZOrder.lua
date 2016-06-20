-- 设置目标英雄的z
require (BATTLE_CLASS_NAME.class)
local BAForSetZOrder = class("BAForSetZOrder",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForSetZOrder.target 					= nil
	BAForSetZOrder.zValue 					= nil

	------------------ functions -----------------------
 	function BAForSetZOrder:start()
		if(self.target ~= nil and self.zValue ~= nil) then 
		 	self.target:toZOder(self.zValue)
		end
		self:complete()
	end

return BAForSetZOrder