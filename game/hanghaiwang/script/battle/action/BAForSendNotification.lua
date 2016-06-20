

local BAForSendNotification = class("BAForSendNotification",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForSendNotification.notificationName 			= nil  
 	BAForSendNotification.data 						= nil
 	BAForSendNotification.delay						= nil
 	BAForSendNotification.count 					= nil
	------------------ functions -----------------------
 

	-- 运行函数
	function BAForSendNotification:start(data)

		if(self.delay and self.delay > 0) then
			self:addToRender()
			self.count = 0
		else
			if( self.notificationName ) then
				EventBus.sendNotification(self.notificationName,self.data)
			end
			self.notificationName 	= nil
			self.data  				= nil
			self:complete()

		end
		-- --print("BAForSendNotification:start")
		
	end

	function BAForSendNotification:update( dt )
		self.count = self.count + 1
		if(not self:isOK()) then
			self:complete()
			return
		end
		if(self.count >= self.delay) then
			if( self.notificationName ) then
				EventBus.sendNotification(self.notificationName,self.data)
			end
			self.notificationName 	= nil
			self.data  				= nil
			self:complete()
		end
	end
return BAForSendNotification