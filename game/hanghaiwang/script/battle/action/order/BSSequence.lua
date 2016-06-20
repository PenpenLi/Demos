
require (BATTLE_CLASS_NAME.class)
local BSSequence = class("BSSequence",require(BATTLE_CLASS_NAME.BaseAction))
-- local BSSequence = class("BSSequence")
	------------------ properties ----------------------
	BSSequence.list 			= nil
	BSSequence.index 			= nil
	BSSequence.isRunning 		= nil
	BSSequence.completeCall 	= nil
	BSSequence.runningAction 	= nil
	------------------ functions -----------------------
	function BSSequence:ctor( ... )
		-- self.super.ctor(self)
		self.super.ctor(self,...)
 		self:reset()
		local targets = ...
		if(targets ~= nil) then
			self:addTargetsWithTable(targets)
		end

		-- self.isRunning  = false
		-- self.list 		= {}
		
	end



	function BSSequence:add(item)
		if(item and self.isRunning ~= true) then
			table.insert(self.list,item)
		end
	end
 	
 	function BSSequence:addTargetsWithTable( targets )
 		 for k,item in pairs(targets or {}) do
 		 	self:add(item)
 		 end
 	end


 	function BSSequence:start()
 		if(not self.isRunning) then
 			
 			if(#self.list > 0) then
 				self.isRunning  = true
 				self:runNext()
 			end
 		end
	end

	function BSSequence:reset( ... )
		if(self.runningAction) then
			-- self.runningAction:release()
			self.runningAction = nil
		end
		for k,action in pairs(self.list or {}) do
			if(action) then
				action:release()
			end
		end
		self.list 		= {}
		self.index 		= 1
		self.isRunning  = false
	end

 	function BSSequence:runNext()
 		if(self.index <= #self.list) then
 			self.runningAction = self.list[self.index]
 			self.index = self.index + 1
 			if(self.runningAction) then
 				self.runningAction:addCallBacker(self,self.handleOneActionComplete)
 				self.runningAction:start()
 			else
 				self.handleOneActionComplete()
 			end
 		else
 			self:runCompleteCallBack()
 		end
 	end

 	function BSSequence:runCompleteCallBack( ... )
 		if(self.completeCall ~= nil) then
 			self.completeCall()

 			self.completeCall = nil
 		end
	 	self:complete()
		self:reset()
 	end
 	function BSSequence:release( ... )
 		self.super.release(self)
 		self.completeCall = nil
 	end

	function BSSequence:handleOneActionComplete(...)
		self:runNext()
	end

return BSSequence

