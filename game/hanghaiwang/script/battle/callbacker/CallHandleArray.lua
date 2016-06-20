
require (BATTLE_CLASS_NAME.class)

local CallHandleArray = class("CallHandleArray")
 	-- 同一个对象的handler只会被注册1次
	------------------ properties ----------------------
	CallHandleArray.handlList 							= nil		-- 回调列表
	CallHandleArray.name								= nil
	CallHandleArray.targetList							= nil
	CallHandleArray.useWeekKey							= false		-- 是否使用弱引用key
	--- 这里会有可能在回调函数中 被调用了clearAll,导致后面的回调被清除的坑
	-- 增加下面2个参数来判断clear的时候是否是在调用回调过程
	-- 如果是回调过程,我们就在回调完成后清理
	CallHandleArray.runningCall							= false -- 当前是否处于调用回调列表中
	CallHandleArray.callRelease 						= false -- 回调完成后,是否调用clearAll函数
	------------------ functions -----------------------

	function CallHandleArray:ctor()
		ObjectTool.setProperties(self)
		self.handlList 										= {}
		-- key用弱引用
		if self.useWeekKey then
			self.targetList									= self:getWeakKeyMap()
		else
			self.targetList									= {}
		end
		-- setmetatable(self.targetList, { __mode = "k" })
	end
	function CallHandleArray:getWeakKeyMap()
		local result = {}
		setmetatable(result, { __mode = "k" })
		return result
	end
	function CallHandleArray:runArray(target,data)
 		
	   
		if self.handlList ~= nil and self.runningCall ~= true then 
			-- for i,action in pairs(actionMap) do
			local count = 0
			self.runningCall  = true
			for i,handler in pairs(self.handlList) do
				if handler~= nil then
				     count = count + 1
					 handler:runHandle(target,data)
					 -- --print("CallHandleArray run-> key:",data,"leftTime:",handler.leftTime)
					 if handler:canRemove() then
					 	 
					 	if(handler.selfPointer == nil or handler.calller == nil) then
							 	-- 	--print("=============== CallHandleArray runHandle handle nil======================")
									-- --print(debug.traceback())
									-- --print("===========================================================")
						 	--print("---------------------------- error CallHandleArray:runArray")
								--print(debug.traceback())
							--print("----------------------------")
						 --print("CallHandleArray:error on remove->",handler:instanceName())
						 -- --print("callTrace:",self.clearAllTrace)
						 error("handler:",handler.selfPointer,handler.calller," isf:",handler.foreverCall)
					 		 	
						end

					 	self.targetList[handler.selfPointer][handler.calller] = nil
					 	
					 	if(self:getSize(self.targetList[handler.selfPointer]) == 0) then
					 		self.targetList[handler.selfPointer] = nil
					 	end
					 	
					 	
					 	self.handlList[handler:instanceName()] = nil
					 	handler:release()
					 	-- --print("CallHandleArray removeHandle")
					 else
					 	-- --print("CallHandleArray canCall")
					 end -- if
				else
					--print("CallHandleArray handler is nil")
				end
			end -- for end
			self.runningCall  = false
			if(self.callRelease) then
				self.callRelease = false
				self:clearAll()
				if(self.callRelease == true) then
					-- error("CallHandleArray:runArray")
				end
			end
			-- --print("CallHandleArray count is:",count)
		else
			 	-- --print("CallHandleArray array is nil")
		end-- if end
	end -- function end

	function CallHandleArray:add(handle)
	 	-- table.insert(self.array,handle)
	 	-- --print("CallHandleArray:add->",handle:instanceName())
	 	-- 每个对象的同一个函数只能添加1次，以防有坑
	 	if self.targetList[handle.selfPointer] == nil then 
	 		self.targetList[handle.selfPointer]	= {}--self:getWeakKeyMap()
	 	end
	 	if(handle.selfPointer == nil or handle.calller == nil or handle:instanceName() == nil ) then
	 		--print("=============== CallHandleArray add handle nil======================")
			--print(debug.traceback())
			--print("===========================================================")
       		error("CallHandleArray add handle nil")
					 	
	 	end
	 	
	 	if self.targetList[handle.selfPointer][handle.calller] == nil then
	 		self.targetList[handle.selfPointer][handle.calller]	= true
	 		self.handlList[handle:instanceName()] 				= handle
	 	else
	 		--print("same target same function regest same callback")
	 	end
	end

	function CallHandleArray:getSize(target)
		local count = 0
		for k,v in pairs(target or {}) do
			count = count + 1
		end
		return count
	end
	function CallHandleArray:toString( ... )
		local count = 1
		for i,handler in pairs(self.handlList) do

				if handler~= nil then
				     count = count + 1
				end
		end
		-- --print("CallHandleArray has calller:",count)
	end

	function CallHandleArray:clearAll()

		if(self.runningCall == false) then

			-- self.clearAllTrace = debug.traceback()
			-- --print("CallHandleArray ", self:instanceName()," clearAll")
			-- if self.targetList ~= nil then 
				for i,handler in pairs(self.handlList) do
					-- --print("		CallHandleArray:release:",handler:instanceName())
				 	handler:release()
				 	self.handlList[i] = nil
				end -- for end
			-- end-- if end
			-- self.handlList = {}

			-- if self.targetList ~= nil then 
			-- 	for i,targets in pairs(self.targetList) do			  
			-- 	 		for k,v in pairs(targets) do
			-- 	 			targets[k]= nil
			-- 	 		end
			-- 	 	self.targetList[i] = nil
			-- 	end -- for end
			-- end-- if end
			-- self.targetList			  = {} -- 因为用了如引用，所以直接nil
		else
			-- 如果是在回调过程中调用了清除,那么标记回调完成后自动清除
			self.callRelease 		  = true
		end
	end

return CallHandleArray