require (BATTLE_CLASS_NAME.class)

local CallForverHandle = class("CallForverHandle",require(BATTLE_CLASS_NAME.CallHandle))
 
	------------------ properties ----------------------
	
	function CallForverHandle:ctor()
			 ObjectTool.setProperties(self)
			 self.leftTime			= 1
			 self.foreverCall		= true
	end

	------------------ functions -----------------------

return CallForverHandle