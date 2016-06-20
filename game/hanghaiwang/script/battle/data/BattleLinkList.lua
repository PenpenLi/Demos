
-- 战斗专用 linkList
-- 以action为节点属性value
local BattleLinkList = class("BattleLinkList")
 

 
	------------------ properties ----------------------
	BattleLinkList.head 				= nil
	BattleLinkList.tail					= nil
	BattleLinkList.length				= 0
	BattleLinkList.nameToNode			= nil
	BattleLinkList.stopProgress 		= false
	BattleLinkList.updating				= false
	BattleLinkList.printLog 			= false
	-- BattleLinkList.
	------------------ functions -----------------------
	function BattleLinkList:ctor()
		self.nameToNode = {}
	end

	function BattleLinkList:clear( callRelease )
		self.head = nil
		self.tail = nil
		self.length = 0
		if(callRelease == true) then
			for k,action in pairs(self.nameToNode) do
				if(action and action.release ~= nil) then
					action:release()
				end
			end
		end
		self.nameToNode = {}
		if(self.updating == true) then 
			self.stopProgress = true 
		end
	end

	function BattleLinkList:clearAndRelease( ... )
		local nextNode = self.head
		self.updating = true
		while(nextNode ~= nil) do

			local afterNext = nextNode.next

			if(nextNode.value and nextNode.value.release) then
				nextNode.value:release()
			end
			nextNode = afterNext
			 
		end
		self:clear()

	end


	function BattleLinkList:add( action )

		local key = action:instanceName()
		-- if(printd) then
		-- Logger.debug("instanceName:%s,node:%s",action:instanceName(),tostring(self.nameToNode[key]))
		-- end
		if action.update ~= nil  and action:instanceName() ~= nil  and self.nameToNode[key] == nil then
			-- print("instanceName 1")
			local node = {}
			node.name = key
			node.value = action
			node.compensation = 0
			self.nameToNode[key] = node
			if(self.head == nil) then
				self.head = node
				self.tail = node
			else		
 
					local lastTail 		= self.tail
					lastTail.next  		= node
					self.tail 		 	= node

					node.pre			= lastTail
	 
				 
			end
		 
			self.length = self.length + 1
		end
		
		-- self:checkList(" BattleLinkList:add ")
	end

	function BattleLinkList:remove( action )
		local key = action:instanceName()
		local removeNode = nil
		if self.nameToNode[key] ~= nil then
			removeNode = self.nameToNode[key]

		

			if(self.length == 1) then
				self.head = nil
				self.tail = nil
				self.length = 0
			else
				if(removeNode == self.head) then
					self.head = removeNode.next
					self.head.pre = nil

				elseif(removeNode == self.tail) then
					self.tail = removeNode.pre
					self.tail.next = nil
				else
					local pre = removeNode.pre
					local nextNode = removeNode.next
					pre.next = nextNode
					nextNode.pre = pre
				end
				self.length = self.length - 1
			end
			
			self.nameToNode[key] = nil
			if(removeNode.action and removeNode.action.release)then
			   	removeNode.action:release()
			end

			if(self.printLog ~= true) then return end
			-- Logger.debug("BattleLinkList:remove action:".. key)
			-- self:checkList(" BattleLinkList:remove ")
			-- self:checkList(" BattleLinkList remove ")
		else
			if(self.printLog ~= true) then return end
			-- Logger.debug("BattleLinkList:remove can't find action:".. key)
			-- local nodes = 0
			-- for k,n in pairs(self.nameToNode) do
			-- 	Logger.debug("nameToNode:".. n.value:instanceName())
			-- end

			-- self:checkList(" BattleLinkList not remove ")
		end

		return removeNode
	end




	function BattleLinkList:markRemove( action )
		local key = action:instanceName()
		local removeNode = nil
		if self.nameToNode[key] ~= nil then
			removeNode = self.nameToNode[key]
			removeNode.removed = true
			-- self.length = self.length - 1
		end
	end

	function BattleLinkList:update( dt )
		local callTime = 0
		
		local nextNode = self.head
		self.updating = true
		local startTime = 0.0
		local compensation = false
		-- print("------------ render update start",os.clock())
		while(nextNode ~= nil) do

			-- 如果在循环中执行了 clear 就需要直接跳出循环
			if(not self.stopProgress) then

				callTime = callTime + 1
				local afterNext = nextNode.next

				-- startTime = os.clock()

				-- 当前节点为有效节点
				-- if(nextNode.removed ~= true) then
				if(compensation ~= true) then
					nextNode.value:update(dt + nextNode.compensation)
					nextNode.compensation = 0
				else
					nextNode.compensation = nextNode.compensation + dt
				end
					-- 当前节点需要删除
					-- if(nextNode.removed == true) then
					-- 	self:remove(nextNode.value)
					-- end
					

				-- -- 如果要遍历的节点已经被标记为移除
				-- else
				-- 	self:remove(nextNode.value)
				-- 	-- nextNode = afterNext
				-- end
				
				-- local cost =  os.clock() - startTime
				-- if(cost > 10000) then
				-- 	compensation = true
					-- if(nextNode) then
						-- print("-- render update compensation:",nextNode.name)
					-- end

				-- end

				nextNode = afterNext
				
				-- print("-- render update cost:",cost)
			else
				self.stopProgress = false
				break
			end
			-- end
			-- current = current.next
		end
		-- print("------------ render update complete",os.clock())
		-- if(self.length == 9 and callTime == 18) then
		-- 	for k,v in pairs(self.nameToNode) do
		-- 	 	print("className:%s,isOK:%s",v.value.__cname,tostring(v.value:isOK()))

		-- 	end
		-- end
		-- while(nextNode) do
		-- 	if(nextNode.removed == true) then
		-- 		self:remove(nextNode.value)
		-- 	end
		-- end

		self.updating = false
		-- self:checkList()
		-- Logger.debug("BattleLinkList:update time:%d,actionNumber:%d",callTime,self.length)

	end
 
	function BattleLinkList:checkList( info  )
		if(self.printLog ~= true) then return end
		local callTime = 0
		local nextNode = self.head
	 	local linkState = ""
		while(nextNode ~= nil) do

			-- 如果在循环中执行了 clear 就需要直接跳出循环
			-- if(not self.stopProgress) then

				
				local afterNext = nextNode.next
				if(afterNext == nil) then 
					linkState = linkState .. "   ".. nextNode.name .. " -> nill  "
				else
					linkState = linkState .. "  ".. nextNode.name .. " -> "
				end

				-- 当前节点为有效节点
				if(nextNode.removed ~= true) then
					callTime = callTime + 1
			 		
				end
				nextNode = afterNext
			-- else
			-- 	self.stopProgress = false
			-- 	break
			-- end
			-- end
			-- current = current.next
		end

		local dicNodes = ""		
		local nodes = 0
		for k,v in pairs(self.nameToNode) do
			 nodes= nodes + 1
			 dicNodes = dicNodes .. v.name ..  " ,"
		end
		if(callTime ~= nodes) then
			if(info) then
				Logger.debug("== linkList:" .. tostring(info) .. linkState)
			else
				Logger.debug("== linkList:" .. linkState)
			end
			Logger.debug("== node dic:%s",dicNodes)
			Logger.debug("BattleLinkList:checkList linkNumber:%d,actionNumber:%d,len:%d",callTime,nodes,self.length)

			Logger.debug("==========================================================")
		end
	end

return BattleLinkList
