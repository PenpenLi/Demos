-- 一个个的顺序播放action,通过push方法插入
local BAForRunActionSequencely = class("BAForRunActionSequencely",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
	-- BAForRunActionSequencely.listForRunning 					= nil	-- 动作列表
	BAForRunActionSequencely.listForComplete 					= nil	-- 动作完成列表
	BAForRunActionSequencely.data 								= nil   -- 原始数据
	BAForRunActionSequencely.blackBoard 						= nil
	BAForRunActionSequencely.index 								= 0		-- 
	BAForRunActionSequencely.total 								= 0		--
	BAForRunActionSequencely.running 							= false

	BAForRunActionSequencely.headAction							= nil
	BAForRunActionSequencely.tailAction 						= nil

	BAForRunActionSequencely.list 								= nil
	------------------ functions -----------------------
	function BAForRunActionSequencely:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()	
		-- self.listForRunning 		= {}
		self.listForComplete 		= {}
		self.total 					= 0
		self.running 				= false
		self.list 					= {}
	end

	-- function BAForRunActionSequencely:pushNode( action )
	-- 	local nodeAction  			= {}
	-- 	nodeAction.action 			= action
	-- 	nodeAction.previous 		= self.tailAction

	-- 	if(self.headAction == nil ) then
	-- 			self.headAction = node
	-- 			self.tailAction = node
	-- 	else
	-- 			self.tailAction.next = node
	-- 	end
	-- 	return nodeAction
	-- end
	function BAForRunActionSequencely:push(action,start)
		-- if( self.running == false) then
		-- else
		-- end

		if(action ~= nil ) then 
			-- table.insert(self.listForRunning,action)
			self.total = self.total + 1
			table.insert(self.list,action)
			if(start and start == true) then

			end
			-- --print("BAForRunActionSequencely push: current:",self.index," total:",self.total)
			-- local nodeAction  			= {}
			-- nodeAction.action 			= action
			-- -- nodeAction.next 			= self.headAction

			-- if(self.headAction == nil ) then
			-- 		self.headAction = nodeAction
			-- 		self.tailAction = nodeAction
			-- else
			-- 		nodeAction.next 			= self.headAction
			-- 		self.headAction.previous 	= nodeAction
			-- 		self.headAction		 		= nodeAction
			-- end

		else
			error("BAForRunActionSequencely:push nil action")
		end
	end


	-- function BAForRunActionSequencely:insertHead( action )
		
	-- end

	-- function BAForRunActionSequencely:pushTail( action )
	-- 	
	-- end

	-- 添加回调 执行所有action,
	function BAForRunActionSequencely:start(data)
		-- --print("-------------------- BAForRunActionSequencely:start action number is ",self.total)
		if( self.running == false) then -- 如果是正在执行,那么什么也不做
			self.index = 1
			-- --print("BAForRunActionSequencely start ->",self:instanceName()," total:",self.total," index:",self.index)
		
			if(self.total > 0) then

				self.running 			= true
				self:runNextAction()
			else
				self.running 			= false
				-- --print("BAForRunActionSequencely:start action number is 0")
				self:complete()
			end
		else
			--print("BAForRunActionSequencely start ->",self:instanceName(),"is running")
		end

 
	end -- function end

	function BAForRunActionSequencely:runNextAction()

	 	if(self:isComplete() == false) then	
	 		-- lua 索引从1开始, index是从0开始的
	 		-- --print("run next:",self.tailAction.action.name)
	 		self.list[self.index]:addCallBacker(self,self.handleOneActionComplete)
	 		self.list[self.index]:start()
	 		
			-- self.tailAction.action:addCallBacker(self,self.handleOneActionComplete)
			-- -- --print("BAForRunActionSequencely:runNextAction:",self.tailAction.name)
			-- self.tailAction.action:start()	
		
	 	else
	 		-- --print("BAForRunActionQueueWithWeight->",self:instanceName()," complete")
	 
	 		self.running 			= false
	 		self.list 				= {}
	 		self.total				= 0
	 		self.index 				= 0
	 		self:complete()
	 		--self:release()
	 	end
	end

	function BAForRunActionSequencely:isComplete( )
		return self.index > self.total
	end

	-- 记录完成的action 
	function BAForRunActionSequencely:handleOneActionComplete(action,data)
		if action ~= nil then 
			
			-- Logger.debug("BAForRunActionQueueWithWeight-> oneComplete:" .. self.index  .. "/" .. self.total)
			self.index = self.index + 1	
			 -- --print(action.name," BAForRunActionSequencely:handleOneActionComplete:",action.name)
			table.insert(self.listForComplete,action)
			-- self.headAction = self.headAction.next
			-- self:pop()
			-- --print("BAForRunActionQueueWithWeight->",self:instanceName()," state index:",self.index," total:",self.total)
			self:runNextAction()

		else
			error("BAForRunActionSequencely action call back,action is nil")
		end
		
	end -- function end
	-- function BAForRunActionSequencely:pop()
	-- 	-- --print("--------------------  BAForRunActionSequencely:pop")
	-- 	if(self.tailAction) then

	-- 		self.tailAction.action:release()
	-- 		self.tailAction.action  	= nil

	-- 		local previous 				= self.tailAction.previous
	-- 		if(self.tailAction.next) then
	-- 			-- --print("BAForRunActionSequencely:pop:",self.tailAction.next.__cname)
	-- 			if(self.tailAction.next.action) then
	-- 				self.tailAction.next.action:release()
	-- 			end
	-- 			self.tailAction.next.previous = nil
	-- 			self.tailAction.next 	= nil
	-- 		end
	
	-- 		self.tailAction		 		= previous
	-- 		if(self.tailAction ==  nil) then
	-- 			self.headAction 		= nil
	-- 		end
	-- 	end
	-- 	--return self.tailAction
	-- end
	-- 销毁,释放回调 和 队列里的action
	function BAForRunActionSequencely:release()
		if self.calllerBacker ~= nil then
			--self.calllerBacker:clearAll()
		end	
		self.running 				= false
	    self.blockBoard				= nil
		self.data 					= nil

		if self.listForComplete ~= nil then 
			-- for k,value in pairs(self.listForComplete) do
			-- 	value:release()
			-- end
			self.listForComplete	= {}
		end

		if(self.list) then
			for k,value in pairs(self.list) do
				value:release()
			end
			self.list = {}
		end

		
		-- while self.tailAction do
		-- 	self:pop()
		-- end
 
		self.index 					= 0
		self.total 					= 0

		self.disposed 				= true
		self:removeFromRender()					-- 执行
		self.calllerBacker:clearAll()
		self.blockBoard				= nil
 
		--self.name 												= nil
	end -- function end

return BAForRunActionSequencely