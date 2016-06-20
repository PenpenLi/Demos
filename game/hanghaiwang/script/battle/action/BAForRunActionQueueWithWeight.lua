


-- 一个个的顺序播放action,通过push方法插入,callbacker是永久的,todo:插入时排序
local BAForRunActionQueueWithWeight = class("BAForRunActionQueueWithWeight",require(BATTLE_CLASS_NAME.BAForRunActionSequencely))
	
	function BAForRunActionQueueWithWeight:ctor()
		--BaseAction.super:ctor()
		ObjectTool.setProperties(self)
		--__instanceName					= 1
		self.calllerBacker			= require(BATTLE_CLASS_NAME.BattleForEverCallBacker).new()	
		-- self.listForRunning 		= {}
		self.listForComplete 		= {}
		self.total 					= 0
		self.running 				= false
	end
	
	function BAForRunActionQueueWithWeight:push(action)


		
		-- if( self.running == false) then
		-- else
		-- end

		if(action ~= nil ) then 
			-- table.insert(self.listForRunning,action)
			self.total = self.total + 1
			-- --print("BAForRunActionQueueWithWeight->",self:instanceName()," push: ", action.name ," current:",self.index," total:",self.total)
			local nodeAction  			= {}
			nodeAction.action 			= action
			-- nodeAction.next 			= self.headAction

			if(self.headAction == nil ) then
					self.headAction = nodeAction
					self.tailAction = nodeAction
			else
					nodeAction.next 			= self.headAction
					self.headAction.previous 	= nodeAction
					self.headAction		 		= nodeAction
			end

		else
			--print("BAForRunActionQueueWithWeight:push nil action")
		end
	end
	-- function BAForRunActionQueueWithWeight:push(action)
	-- 	-- if( self.running == false) then
	-- 	-- else
	-- 	-- end

	-- 	if(action ~= nil ) then 
	-- 		-- table.insert(self.listForRunning,action)
	-- 		self.total = self.total + 1

	-- 		local nodeAction  			= {}
	-- 		nodeAction.action 			= action
	-- 		-- nodeAction.next 			= self.headAction

	-- 		if(self.headAction == nil ) then
	-- 				self.headAction = nodeAction
	-- 				self.tailAction = nodeAction
	-- 		else
	-- 				nodeAction.next 			= self.headAction
	-- 				self.headAction.previous 	= nodeAction
	-- 				self.headAction		 		= nodeAction
	-- 		end

	-- 	else
	-- 		--print("BAForRunActionQueueWithWeight:push nil action")
	-- 	end
	-- end
	-- function BAForRunActionQueueWithWeight:push(action)
		-- if( self.running == false) then
		-- else
		-- end

		-- if(action ~= nil ) then 
		-- 	-- table.insert(self.listForRunning,action)
		-- 	self.total = self.total + 1

		-- 	local nodeAction  			= {}
		-- 	nodeAction.action 			= action
		-- 	-- nodeAction.next 			= self.headAction

		-- 	if(self.headAction == nil ) then
		-- 			self.headAction = nodeAction
		-- 			self.tailAction = nodeAction
		-- 	else
		-- 			if(nodeAction.action.weight == nil or )
		-- 			nodeAction.next 			= self.headAction
		-- 			self.headAction.previous 	= nodeAction
		-- 			self.headAction		 		= nodeAction
		-- 	end

		-- else
		-- 	--print("BAForRunActionQueueWithWeight:push nil action")
		-- end
	-- end
return BAForRunActionQueueWithWeight