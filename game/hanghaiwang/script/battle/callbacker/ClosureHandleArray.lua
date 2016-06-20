require (BATTLE_CLASS_NAME.class)

local ClosureHandleArray = class("ClosureHandleArray")
 	-- 同一个 handler只会被注册1次
	------------------ properties ----------------------
	ClosureHandleArray.handlList 							= nil		-- 回调列表
	ClosureHandleArray.name									= nil
	ClosureHandleArray.useWeekKey							= false		-- 是否使用弱引用key
	--- 这里会有可能在回调函数中 被调用了clearAll,导致后面的回调被清除的坑
	-- 增加下面2个参数来判断clear的时候是否是在调用回调过程
	-- 如果是回调过程,我们就在回调完成后清理
	ClosureHandleArray.runningCall							= false -- 当前是否处于调用回调列表中
	ClosureHandleArray.callRelease 							= false -- 回调完成后,是否调用clearAll函数
	------------------ functions -----------------------

	function ClosureHandleArray:ctor()
		ObjectTool.setProperties(self)
		self.handlList 										= self:getWeakKeyMap()
 
		-- setmetatable(self.targetList, { __mode = "k" })
	end
	function ClosureHandleArray:getWeakKeyMap()
		local result = {}
		setmetatable(result, { __mode = "k" })
		return result
	end
	function ClosureHandleArray:runArray(data)
 		
	   
		if self.handlList ~= nil and self.runningCall ~= true then 
			-- for i,action in pairs(actionMap) do
			local count = 0
			self.runningCall  = true
			for i,handler in pairs(self.handlList) do
				if handler~= nil then
				     count = count + 1
					 handler:runHandle(data)
					 if handler:canRemove() then
					 	 
					 	if(handler.calller == nil) then
						 	error("handler:",handler.calller," isf:",handler.foreverCall)
						end
					 	
					 	self.handlList[handler.calller] = nil
					 	handler:release()
					 end -- if
				end
			end -- for end
			self.runningCall  = false
			if(self.callRelease == true) then
				self.callRelease = false
				self:clearAll()
			end
			-- --print("ClosureHandleArray count is:",count)
		else
			 	-- --print("ClosureHandleArray array is nil")
		end-- if end
	end -- function end

	function ClosureHandleArray:addForeverCall( call )
		local handle = require(BATTLE_CLASS_NAME.ClosureHandle).new()
		handle.calller = call
		handle.leftTime = 0
		handle.foreverCall = true
		self:add(handle)
	end

	function ClosureHandleArray:addLimitTimeCall(call,time)
		if(time == nil or tonumber(time) <= 0 ) then
			time = 1
		end
		local handle = require(BATTLE_CLASS_NAME.ClosureHandle).new()
		handle.calller = call
		handle.leftTime = time
		self:add(handle)

	end
	function ClosureHandleArray:add(handle)
	 	if(handle.calller == nil or handle:instanceName() == nil ) then
       		error("ClosureHandleArray add handle nil")
	 	end
	 	-- 这里之所以用回调函数当做key,就是为了避免同一个函数被注册多次
	 	self.handlList[handle.calller] 				= handle
	end

	function ClosureHandleArray:getSize(target)
		local count = 0
		for k,v in pairs(target or {}) do
			count = count + 1
		end
		return count
	end
	function ClosureHandleArray:toString( ... )
		local count = 1
		for i,handler in pairs(self.handlList) do

				if handler~= nil then
				     count = count + 1
				end
		end
		-- --print("ClosureHandleArray has calller:",count)
	end

	function ClosureHandleArray:clearAll()

		if(self.runningCall == false) then

				for calller,handler in pairs(self.handlList) do
					-- --print("		ClosureHandleArray:release:",handler:instanceName())
				 	handler:release()
				 	self.handlList[calller] = nil
				end -- for end

		else
			-- 如果是在回调过程中调用了清除,那么标记回调完成后自动清除
			self.callRelease 		  = true
		end
	end

return ClosureHandleArray