

-- 基于链表的队列
local LinkNodeQueue = class("LinkNodeQueue")
 
	------------------ properties ----------------------
	LinkNodeQueue.rootNode 		= nil 		-- 头结点
	LinkNodeQueue.tailNode 		= nil
 	LinkNodeQueue.count			= nil

	------------------ functions -----------------------
	function LinkNodeQueue:ctor( ... )
		self.count = 0
	end
	function LinkNodeQueue:push( target )
		self.count = self.count + 1
 		if(self.count > 0) then 
 			self.tailNode.next  = {value=target}
 			self.tailNode 		= self.tailNode.next
 		else
 			self.rootNode = {value=target}
 			self.tailNode = self.rootNode
 		end
	end

	function LinkNodeQueue:pop()
		if(self.count > 0) then
			local result  = self.rootNode.value
			self.rootNode = self.rootNode.next
			self.count = self.count - 1
			if(self.count <= 0) then

				self.count = 0
				self.rootNode = nil
 				self.tailNode = nil
			
			end
			return result
		end
	end

	function LinkNodeQueue:clear()
		while(self.count > 0) do
			local node = self:pop()
			if(node) then
				node.next 	= nil
				node.value 	= nil
			end -- if end
		end -- while end
	end -- function end


	function LinkNodeQueue:hasNext()
		return self.count > 0
	end
return LinkArray