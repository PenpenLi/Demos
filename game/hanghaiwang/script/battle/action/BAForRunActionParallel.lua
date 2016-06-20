





-- 同时播放action
 
local BAForRunActionParallel = class("BAForRunActionParallel",require(BATTLE_CLASS_NAME.BaseAction))
	------------------ properties ----------------------

	BAForRunActionParallel.listForRunning 					= nil	-- 动作列表
	BAForRunActionParallel.listForComplete 					= nil	-- 动作完成列表
	BAForRunActionParallel.data 							= nil   -- 原始数据
	BAForRunActionParallel.blackBoard 						= nil
	BAForRunActionParallel.running 							= nil
	------------------ functions -----------------------

 	function BAForRunActionSequencely:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
		self.listForRunning 		= {}
		self.listForComplete 		= {}
		self.total 					= 0
		self.running 				= false
	end

	function BAForRunActionSequencely:push(action)
		if(action ~= nil ) then 
			table.insert(self.listForRunning,action)
			-- self.total = self.total + 1
		else
			--print("BAForRunActionSequencely:push nil action")
		end
	end

	-- 添加回调 执行所有action,
	function BAForRunActionParallel:start(data)
		--print("BAForRunActionParallel:start 0")
		if(#self.listForRunning > 0) then
			local counter = 0
			self.name = "sameRun:"
			for i,childAction in ipairs(self.listForRunning) do
				counter = counter + 1
				childAction.calllerBacker:addCallBacker(self,self.handleOneActionComplete)
				--print("BattleActionForRunActionInSameTime:start call ",childAction.name)
				self.name = self.name.." "..childAction.name
				childAction:start()
			end
			--print("BattleActionForRunActionInSameTime:start run ",counter ," actions")
		else
			--print("BattleActionForRunActionInSameTime:start error")
			self:complete()
		end
 
	end -- function end

	-- 记录完成的action 
	function BAForRunActionParallel:handleOneActionComplete(action,data)
		if action ~= nil then 
			--print("BAForRunActionParallel:handleOneActionComplete:",action.name)
			table.insert(self.listForComplete,action)
			if #self.listForComplete == #self.listForRunning then 
				--print("BAForRunActionParallel:handleOneActionComplete all complete",self.name)
				self:complete()
			end
		else
			--print("xxxxxxxxx action call back,action is nil")
		end
		
	end -- function end

	-- 销毁,释放回调 和 队列里的action
	function BAForRunActionParallel:release()
		if self.calllerBacker ~= nil then
			self.calllerBacker:clearAll()
		end	
 		self.disposed 	= true
		self:removeFromRender()					-- 执行
 
 
	    self.blockBoard											= nil
		self.data 												= nil

		if self.listForComplete ~= nil then 
			for k,value in pairs(self.listForComplete) do
				value:release()
			end
			self.listForComplete								= nil
		end

		if self.listForRunning ~= nil then 
			for k,value in pairs(self.listForRunning) do
				value:release()
			end
			self.listForRunning									= nil
		end
		
		-- self.animationName 										= nil
		self.name 												= nil
	end -- function end

return BAForRunActionParallel