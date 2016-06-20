


require (BATTLE_CLASS_NAME.class)
local BSSpawn = class("BSSpawn",require(BATTLE_CLASS_NAME.BaseAction))
-- local BSSpawn = class("BSSpawn")
	------------------ properties ----------------------
	BSSpawn.list 			= nil
	BSSpawn.isRunning 		= nil
	BSSpawn.completeCall 	= nil
	BSSpawn.completeNum 	= nil
	------------------ functions -----------------------
	function BSSpawn:ctor( ... )
		self.super.ctor(self,...)
 
		self:reset()

		local targets = ...
		if(targets ~= nil) then
			self:addTargetsWithTable(targets)
		end
	end



	function BSSpawn:add(item)
		if(item and self.isRunning ~= true) then
			table.insert(self.list,item)
			-- print("BSSpawn add",#self.list)
		else
			-- print("BSSpawn add error:",item,self.isRunning)
		end
	end
 	function BSSpawn:addTargets( targets )
 		self:addTargetsWithTable(targets)
 	end
 	function BSSpawn:addTargetsWithTable( targets )
 		 for k,item in pairs(targets or {}) do
 		 	self:add(item)
 		 end
 	end


 	function BSSpawn:start()
 		-- print("BSSpawn start 1")
 		if(self.isRunning ~= true) then
 			
 			if(#self.list > 0) then
 				-- print("BSSpawn start 3")

 				 self.isRunning  = true
 				 for k,action in pairs(self.list or {}) do
					if(action) then
		 				action:addCallBacker(self,self.handleOneActionComplete)
		 				action:start()
		 				-- print("BSSpawn start 4")
			 		else
			 			-- print("BSSpawn start 5")
			 			self:handleOneActionComplete()
					end
				 end
 			else
 				 -- print("BSSpawn start 6")
 				 self:handleOneActionComplete()
 			end
 		else
 			 		-- print("BSSpawn start 2")

 		end
	end

	function BSSpawn:reset( ... )
		 
		for k,action in pairs(self.list or {}) do
			if(action) then
				action:release()
			end
		end
		self.list 					= {}
		self.completeNum 			= 0
		self.isRunning  			= false
	end
 

 	function BSSpawn:runCompleteCallBack( ... )
 		if(self.completeCall ~= nil) then
 			self.completeCall()
 			self.completeCall = nil
 		end
 		self:complete()
 		self:reset()
 	end
 	function BSSpawn:release( ... )
 		self.super.release(self)
 		self.completeCall = nil
 	end

	function BSSpawn:handleOneActionComplete(...)
		self.completeNum = self.completeNum + 1
		if(self.completeNum >= #self.list) then
			self:runCompleteCallBack()
		end
	end

return BSSpawn

