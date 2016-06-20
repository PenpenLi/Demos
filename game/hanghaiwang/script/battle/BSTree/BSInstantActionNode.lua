-- 瞬时action:被travel的时候立即被执行,并返回complete状态
-- 注意这个node只负责生产和触发action,然后action会通过BattleActionRender.addAutoReleaseAction到结束自动释放队列中

require (BATTLE_CLASS_NAME.class)
local BSInstantActionNode = class("BSInstantActionNode",require(BATTLE_CLASS_NAME.BSActionNode))

 
	------------------ properties ----------------------
	BSInstantActionNode.isRunning						= nil
  	BSInstantActionNode.isComplete						= nil
  	BSInstantActionNode.action 							= nil
  	BSInstantActionNode.actionComplete					= nil

	------------------ functions -----------------------

	function BSInstantActionNode:release()
		-- call super release
		-- --print("actionRelease")
		self.disposed 						  = true
		
		if(self.actionComplete ~= nil ) then
			self.actionComplete 			  = nil
		end

		self:resetState()
		self.stateChangeCall				  = nil

		
	end

	function BSInstantActionNode:ctor()
		self.calllerBacker					  = require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
		self.isComplete 					  = false
		self.isRunning						  = false
		ObjectTool.setProperties(self)
	end
	function BSInstantActionNode:travel()
		-- --print("---------------------------- BSInstantActionNode:travel ->",self.data.des," isComplete:",self.isComplete)
		-- 如果动作没完成 则返回动作
		if(self.state == nil) then
			self.state = "wait"
		end

		if(self.disposed == true) then
			--print("---------------------------- error BSInstantActionNode:travel:",self.data.des)
			error(debug.traceback())
			--print("----------------------------")
		 -- return BATTLE_CONST.NODE_COMPLETE
		 return BATTLE_CONST.NODE_FALSE
		end

		if self.isComplete == false then
		  
			   self.actionComplete 		  	  = self.blackBoard.actionComplete
			   self.action 					  = BattleNodeFactory.getAction(self.data,self.blackBoard)
			   -- Logger.debug("***  actionNode:start -> " .. self.action.name .. " des:",self.data.des)
			   if(self.action ~= nil ) then 
					 BattleActionRender.addAutoReleaseAction(self.action)  
			   else
			   		error("BSNode get nil action des:" .. self.data.des .. " actionType:" .. (self.data.actionType or "nil"))
			   		--print("BSInstantActionNode:travel action is nil ",self.data.des,"actionType:",self.data.actionType)
			   end

			   self:onActionComplete()
 
		else 
				self.state = "complete"
				-- print("***  actionNode:travel -> "," des:",self.data.des," weight:",self.data.weight," state:complete")
				
		end -- if end
 		return BATTLE_CONST.NODE_COMPLETE
	end
	function BSInstantActionNode:onDelayComplete( ... )
		if(self.isRunning) then
			local mes = "action run out 600 frames:" .. self.data.des
			error(mes)
		end

	end
 

	function BSInstantActionNode:onActionComplete()
		 -- self.delay:release()
		-- print("---------------------------- BSInstantActionNode:onActionComplete:",self.action.name)
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

	function BSInstantActionNode:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end		
		return "action: " .. self.data.des .. " " .. self.state
	end
	
 
	


	function BSInstantActionNode:resetState()
		self.isRunning						  = false
		self.isComplete						  = false
	end
 
	
return BSInstantActionNode
