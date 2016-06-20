
 -- 战斗背景变换
local BAForChangeBackGround = class("BAForChangeBackGround",require(BATTLE_CLASS_NAME.BaseAction))

	------------------ properties ----------------------
	BAForChangeBackGround.data 			 = nil	-- 外部指定数据

	------------------ functions -----------------------

	function BAForChangeBackGround:start(...)

		if(self.data and self.data[1]) then
	 		EventBus.sendNotification(NotificationNames.EVT_REQUEST_CHANGE_BG_DIRECT,self.data[1])
		-- else
			
		end
		self:complete()
	end

return BAForChangeBackGround