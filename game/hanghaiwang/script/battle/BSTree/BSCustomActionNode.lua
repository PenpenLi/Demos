-- 自定义actionNode: 根据获取action的 isIgnore 接口判断是否需要忽略节点(也就是只负责触发,然后立即complete)
require (BATTLE_CLASS_NAME.class)
local BSCustomActionNode = class("BSCustomActionNode",require(BATTLE_CLASS_NAME.BSActionNode))

	------------------ properties ----------------------
	BSCustomActionNode.isRunning						= nil
  	BSCustomActionNode.isComplete						= nil
  	BSCustomActionNode.action 							= nil
  	BSCustomActionNode.actionComplete					= nil

	------------------ functions -----------------------

	function BSCustomActionNode:release()
		-- call super release
		-- --print("actionRelease")
		self.disposed 						  = true
		
		if(self.actionComplete ~= nil ) then
			self.actionComplete 			  = nil
		end

		self:resetState()
		self.stateChangeCall				  = nil

		
	end

	function BSCustomActionNode:ctor()
		self.calllerBacker					  = require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
		self.isComplete 					  = false
		self.isRunning						  = false
		ObjectTool.setProperties(self)
	end
	function BSCustomActionNode:travel()
		-- --print("---------------------------- BSCustomActionNode:travel ->",self.data.des," isComplete:",self.isComplete)
		-- 如果动作没完成 则返回动作
		if(self.state == nil) then
			self.state = "wait"
		end

		if(self.disposed == true) then
			--print("---------------------------- error BSCustomActionNode:travel:",self.data.des)
			error(debug.traceback())
			--print("----------------------------")
		 return BATTLE_CONST.NODE_COMPLETE
		end
		-- 如果没有结束
		if self.isComplete == false then
		  	   -- 如果不是正在执行
		  	   if (self.isRunning == false) then


				   self.actionComplete 		  	  = self.blackBoard.actionComplete
				   self.action 					  = BattleNodeFactory.getAction(self.data,self.blackBoard)
				   self.state 					  = "start"
				   self.isRunning 				  = true
				   -- Logger.debug("***  actionNode:start -> " .. self.action.name .. " des:",self.data.des)
				   
				   if(self.action ~= nil) then
				   		local isIgnore = false
				   		if(self.action.isIgnore ~= nil and type(self.action.isIgnore) == "function") then
				   			isIgnore = self.action:isIgnore()  
				   			print("==== get not isIgnore BSCustomActionNode:",isIgnore)
				   		else
				   			isIgnore = true
				   		end

				   		if(isIgnore == true) then
				   			BattleActionRender.addAutoReleaseAction(self.action)
				   			self:onActionComplete()
				   	    	return BATTLE_CONST.NODE_COMPLETE
				   		else
				   			self.action:addCallBacker(self,self.onActionComplete)
							self.action:start()
							return BATTLE_CONST.NODE_RUNNING
				   		end
				   
				   else
				   		error("BSNode get nil action des:" .. self.data.des .. " actionType:" .. (self.data.actionType or "nil"))
				   end
				else -- 正在运行
					self.state = "running"
				 	return BATTLE_CONST.NODE_RUNNING
				end
			   
			   
 
		else 
				self.state = "complete"
				-- return BATTLE_CONST.NODE_RUNNING
				-- print("***  actionNode:travel -> "," des:",self.data.des," weight:",self.data.weight," state:complete")
				return BATTLE_CONST.NODE_COMPLETE
		end -- if end
 		
	end

	function BSCustomActionNode:onDelayComplete( ... )
		if(self.isRunning) then
			local mes = "action run out 600 frames:" .. self.data.des
			error(mes)
		end

	end
 

	function BSCustomActionNode:onActionComplete()
		 -- self.delay:release()
		-- print("---------------------------- BSCustomActionNode:onActionComplete:",self.action.name)
		 -- Logger.debug("*********** complete actionNode -> " .. self.action.name .. " des:",self.data.des)
		self.isRunning						  = false
		self.isComplete						  = true

		self.state = "complete"
 
		if(self.disposed ~= true) then
				-- self.stateChangeCall()
			-- self.blackBoard.completeCall()
			-- self.rootCaller:runCallBack(self)
			if(self.actionComplete ~= nil ) then
				self.actionComplete()
				self.actionComplete 			  = nil
				 
			else
				error("self.callBackFunc is nil:",self.data.des)
			end
 
		end
		
	end	

	function BSCustomActionNode:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end		
		return "action: " .. self.data.des .. " " .. self.state
	end
	
 
	


	function BSCustomActionNode:resetState()
		self.isRunning						  = false
		self.isComplete						  = false
	end

return BSCustomActionNode