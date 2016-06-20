

-- 延迟
 
local BAForDelayAction = class("BAForDelayAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForDelayAction.total 							= nil -- 总延迟 毫秒
	BAForDelayAction.cost 							= 0 -- 消耗时间
	BAForDelayAction.delayTime						= nil

	------------------ functions -----------------------
	function BAForDelayAction:update( dt )
		if(self.delayCall > 0) then
			self.delayCall = self.delayCall - 1
		else
		 self.cost = self.cost + dt
		 -- print("BAForDelayAction complete:delay cost:",self.cost," dt:",dt,"total:",self.total)
		 if( self.cost > self.total ) then  -- 如果到时间了
		 
		 	 self:complete()
		 	 self:release()
		 	 -- self.endTime = os.clock()
		 	 
		 end
		end
		-- )

	end

	-- 运行函数
	function BAForDelayAction:start(data)
		-- self.startTime = os.clock()
		if(self.total ~= nil  and self.total > 0 ) then
			-- Logger.debug("-- BAForDelayAction:start " .. tostring(self.total))
			-- --print("BAForDelayAction start ")
			self.cost = 0
			self:addToRender()
			self.delayCall = 1
		else
			-- Logger.debug("-- BAForDelayAction:start error")
			self:complete()
		end

	end

	function BAForDelayAction:release( ... )
		self:removeFromRender()
		if(self.calllerBacker) then	
			self.calllerBacker:clearAll()
		end
		self.blockBoard	= nil
	end
return BAForDelayAction