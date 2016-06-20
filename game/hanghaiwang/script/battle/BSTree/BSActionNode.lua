






-- 逻辑 or(执行到第一个为true就返回)

require (BATTLE_CLASS_NAME.class)
local BSActionNode = class("BSActionNode",require(BATTLE_CLASS_NAME.BSNode))


	------------------ properties ----------------------
  	BSActionNode.isRunning						= nil
  	BSActionNode.isComplete						= nil
  	BSActionNode.action 						= nil
  	BSActionNode.actionComplete					= nil
	------------------ functions -----------------------

	function BSActionNode:release()
		-- call super release
		-- --print("actionRelease")
		self.disposed 						  = true
		
	 
		self.super.release(self)
		self:releaseAction()

		if(self.actionComplete ~= nil ) then
			self.actionComplete 			  = nil
		end

		self:resetState()
		self.stateChangeCall				  = nil

		
	end

	function BSActionNode:ctor()
		self.calllerBacker					  = require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
		self.isComplete 					  = false
		self.isRunning						  = false
		ObjectTool.setProperties(self)
	end
	function BSActionNode:travel()
		-- --print("---------------------------- BSActionNode:travel ->",self.data.des," isComplete:",self.isComplete)
		-- 如果动作没完成 则返回动作
		if(self.state == nil) then
			self.state = "wait"
		end

		if(self.disposed == true) then
			--print("---------------------------- error BSActionNode:travel:",self.data.des)
			-- error(debug.traceback())
			--print("----------------------------")
		 -- return BATTLE_CONST.NODE_COMPLETE
		 return BATTLE_CONST.NODE_FALSE
		end

		if self.isComplete == false then
			 
				if (self.isRunning == false) then
						
					   -- self.delay = require(BATTLE_CLASS_NAME.BAForDelayAction).new()
					   -- self.delay.total = 15
					   -- self.delay:addCallBacker(self,self.onDelayComplete)
					   -- self.delay:start()

					   self.state = "start"
					   self:releaseAction()
					   self.isRunning 				  = true
					   self.actionComplete 		  	  = self.blackBoard.actionComplete
					   self.action 					  = BattleNodeFactory.getAction(self.data,self.blackBoard)
					   -- Logger.debug("***  actionNode:start -> " .. self.action.name .. " des:",self.data.des)
					   if(self.action ~= nil ) then 
							
							   -- self.action 					  = require("script/battle/action/BaseActionForMoveTo").new()
							   -- self.action.blackBoard		  = self.blackBoard
							   --self.name 					  = self.action.name
							   self.action:addCallBacker(self,self.onActionComplete)
							    -- --print("----------------------------  action started:",self.action.name)
							   self.action:start()
					   else
					   		error("BSNode get nil action des:" .. self.data.des .. " actionType:" .. (self.data.actionType or "nil"))
					   		--print("BSActionNode:travel action is nil ",self.data.des,"actionType:",self.data.actionType)
					   end

				  
				else -- 正在运行
					-- --print("*** actionNode:travel -> ", self.action.name ," des:",self.data.des," weight:",self.data.weight," state:running")
					self.state = "running"
					if(self.action == nil) then
						 --print("---------------------------- error running action is nil:",self.data.des)
						 --print(debug.traceback())
						 --print("----------------------------")
					end
				 	  -- --print("----------------------------  action is running:",self.action.name ," des:",self.data.des)
				 	  return BATTLE_CONST.NODE_RUNNING
				end	-- if end

				-- if self.action then
					 ----print("----------------------------  action is running:",self.action.name ," des:",self.data.des)
				-- end

				-- --print("---------------------------- actionNode isRunning:",self.isRunning," action:",self.action)
				return BATTLE_CONST.NODE_RUNNING
		else 
				self.state = "complete"
				-- print("***  actionNode:travel -> "," des:",self.data.des," weight:",self.data.weight," state:complete")
				return BATTLE_CONST.NODE_COMPLETE
		end -- if end
 
	end
	function BSActionNode:onDelayComplete( ... )
		if(self.isRunning) then
			local mes = "action run out 600 frames:" .. self.data.des
			error(mes)
		end

	end
 

	function BSActionNode:onActionComplete()
		 -- self.delay:release()
		-- print("---------------------------- BSActionNode:onActionComplete:",self.action.name)
		 -- Logger.debug("*********** complete actionNode -> " .. self.action.name .. " des:",self.data.des)
		self.isRunning						  = false
		self.isComplete						  = true

		self.state = "complete"

		if(self.delay) then
			self.delay:release()
			self.delay = nil
		end
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
			-- --print("BSActionNode:onActionComplete:",self.root)
			-- if(self.root == nil )then
			-- 	--print("BSActionNode:onActionComplete:",self.root)
			-- end
			-- self.root:actionComplete()
			self:releaseAction()
			-- self:removeAllListeners()
		end
		
	end	

	function BSActionNode:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end		
		return "action: " .. self.data.des .. " " .. self.state
	end
	
 
	


	function BSActionNode:resetState()
		self.isRunning						  = false
		self.isComplete						  = false
	end
	function BSActionNode:releaseAction()
		if self.action ~= nil then 
			self.action:release()
			self.action 					  = nil
		end
	end
 
	
return BSActionNode