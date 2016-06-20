require (BATTLE_CLASS_NAME.class)
local BADelayTime = class("BADelayTime",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BADelayTime.total 					= nil 	-- 总延迟
	BADelayTime.cost 					= nil   -- 延迟

	------------------ functions -----------------------

	function BADelayTime:ctor(...)
		self.super.ctor(self,...)
 
		local frame = ...
		if(frame) then
			-- print("-- delayframe:",frame)
			self:createWithFrame(frame)
		end
	end

	function BADelayTime:create(time)
		self.total 	   = time
		self.cost 	   = 0
	end

	function BADelayTime:createWithFrame( frames )
		self:create(tonumber(frames) * BATTLE_CONST.FRAME_TIME)
		-- self:create(tonumber(frames))
	end

	function BADelayTime:update( dt )
		if(self.delayCall > 0) then
			 self.delayCall = self.delayCall - 1
		else
			 self.cost = self.cost + dt
			 -- self.cost = self.cost + 1
			 -- print("BADelayTime complete:delay cost:",self.cost," dt:",dt,"total:",self.total)
			 if( self.cost > self.total ) then  -- 如果到时间了
			 
			 	 self:complete()
			 	 self:release()
			 	 -- self.endTime = os.clock()
			 	 
			 end
			 
			 -- self.cost = self.cost + dt
		end
		-- )

	end

	-- 运行函数
	function BADelayTime:start()
		-- self.startTime = os.clock()
		if(self.total > 0 ) then
			-- Logger.debug("-- BADelayTime:start " .. tostring(self.total))
			-- --print("BADelayTime start ")
			self.cost = 0
			self:addToRender()
			self.delayCall = 0
		else
			-- print("-- 1 complete dir")
			self:complete()
		end

	end

	function BADelayTime:release( ... )
		self:removeFromRender()
	end

return BADelayTime