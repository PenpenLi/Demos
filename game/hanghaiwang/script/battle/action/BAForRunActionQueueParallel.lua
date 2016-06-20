





-- 同时播放action
 
local BAForRunActionQueueParallel = class("BAForRunActionQueueParallel",require(BATTLE_CLASS_NAME.BaseAction))
	------------------ properties ----------------------

	BAForRunActionQueueParallel.listForRunning 					= nil	-- 动作列表
	BAForRunActionQueueParallel.listForComplete 				= nil	-- 动作完成列表
	BAForRunActionQueueParallel.data 							= nil   -- 原始数据
	BAForRunActionQueueParallel.blackBoard 						= nil
	-- BAForRunActionQueueParallel.running 						= false
	------------------ functions -----------------------

 	function BAForRunActionQueueParallel:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
		self.listForRunning 		= {}
		self.listForComplete 		= {}
		self.total 					= 0
		self.running 				= false
	end

	function BAForRunActionQueueParallel:pushAndStart(action)
		if(action ~= nil ) then 
			-- Logger.debug("BAForRunActionQueueParallel insert " .. (#self.listForRunning + 1))
			if(#self.listForRunning > 0 )then
				-- --print("BAForRunActionQueueParallel insert over:",#self.listForRunning + 1)
			end			
			table.insert(self.listForRunning,action)
			self.running = true
			action.calllerBacker:addCallBacker(self,self.handleOneActionComplete)
			action:start()
			self.total = self.total + 1
		else
			error("BAForRunActionQueueParallel:push nil action")
		end
	end
 

	-- 记录完成的action 
	function BAForRunActionQueueParallel:handleOneActionComplete(action,data)
		self.running = false
		-- Logger.debug("BAForRunActionQueueParallel:handleOneActionComplete:" ..  tostring(#self.listForComplete + 1) .. "/" .. tostring(#self.listForRunning))
		if action ~= nil and self.disposed ~= true then 
			
			table.insert(self.listForComplete,action)
			
			if #self.listForComplete == #self.listForRunning then 
				
				self:resetList()
				-- Logger.debug("BAForRunActionQueueParallel: all complete")
				self:complete()

				
			end
		else
			error("xxxxxxxxx action call back,action is nil")
		end
		
	end -- function end
	function BAForRunActionQueueParallel:resetList( ... )
		if self.listForComplete ~= nil then 
			for k,value in pairs(self.listForComplete) do
				 value:release()
			end
			self.listForComplete								= {}
		end

		if self.listForRunning ~= nil then 
			for k,value in pairs(self.listForRunning) do
				 value:release()
			end
			self.listForRunning									= {}
		end
	end
	-- 销毁,释放回调 和 队列里的action
	function BAForRunActionQueueParallel:release()
		if self.calllerBacker ~= nil then
			self.calllerBacker:clearAll()
		end	
		self.disposed											= true
	    self.blockBoard											= nil
		self.data 												= nil

		self:resetList()
	  	
 
		self:removeFromRender()					-- 执行
 
 
		-- if self.listForComplete ~= nil then 
		-- 	for k,value in pairs(self.listForComplete) do
		-- 		value:release()
		-- 	end
		-- 	self.listForComplete								= nil
		-- end

		-- if self.listForRunning ~= nil then 
		-- 	for k,value in pairs(self.listForRunning) do
		-- 		value:release()
		-- 	end
		-- 	self.listForRunning									= nil
		-- end
		
		-- self.animationName 										= nil
		self.name 												= nil
	end -- function end

return BAForRunActionQueueParallel