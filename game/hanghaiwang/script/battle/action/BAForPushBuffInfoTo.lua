-- 执行目标pushBuffinfo接口,并添加回调
require (BATTLE_CLASS_NAME.class)
local BAForPushBuffInfoTo = class("BAForPushBuffInfoTo",require(BATTLE_CLASS_NAME.BaseAction))
 	
	------------------ properties ----------------------
	BAForPushBuffInfoTo.target				= nil
	BAForPushBuffInfoTo.buffInfo 			= nil
	BAForPushBuffInfoTo.timeType 			= nil
	------------------ functions -----------------------
 	function BAForPushBuffInfoTo:start()
 		-- Logger.debug(">>>>>>>>BAForPushBuffInfoTo:start")
		if(self.target ~= nil and self.buffInfo ~= nil and self.buffInfo:hasBuffInfo() and self.timeType ~= nil) then 
	 		-- Logger.debug("BAForPushBuffInfoTo:start 1: timeType:" .. self.timeType )
	 		self.target:pushBuffInfo(
	 									self.buffInfo,
	 									self.timeType,
	 									self,
	 									self.onBuffComplete
	 								)
			self.target = nil
			self.buffInfo = nil
			-- self:addToRender()
		else
			-- Logger.debug("BAForPushBuffInfoTo:complete direct")
			-- Logger.debug(">>>>>>>>BAForPushBuffInfoTo:onBuffComplete")
			self:complete()
		end
		-- self:complete()
	
	end

	function BAForPushBuffInfoTo:onBuffComplete( ... )
		-- Logger.debug(">>>>>>>>BAForPushBuffInfoTo:onBuffComplete")
		self:complete()

	end

return BAForPushBuffInfoTo