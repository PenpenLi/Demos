require (BATTLE_CLASS_NAME.class)

local CallOnceHandle = class("CallOnceHandle",require(BATTLE_CLASS_NAME.CallHandle))
 
	------------------ properties ----------------------
	
	function CallOnceHandle:ctor()
			 self.leftTime			= 1
			 self.foreverCall		= false
			 ObjectTool.setProperties(self)
	end

	------------------ functions -----------------------

return CallOnceHandle