

-- 初始化主船ui
require (BATTLE_CLASS_NAME.class)
local BAForInitializeShipUIAction = class("BAForInitializeShipUIAction",require(BATTLE_CLASS_NAME.BaseAction))
	
	BAForInitializeShipUIAction.shipid = nil
	BAForInitializeShipUIAction.skillid = nil

	function BAForInitializeShipUIAction:start( )
		
	end

return BAForInitializeShipUIAction

