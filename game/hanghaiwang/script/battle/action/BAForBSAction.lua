




-- 用于 BSTree(行为选择树)  
require (BATTLE_CLASS_NAME.class)
local BAForBSAction = class("BAForBSAction",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	BAForBSAction.blackBoard							= nil 
	BAForBSAction.logicData 							= nil -- 逻辑数据table
	BAForBSAction.rootNode 								= nil -- root node
	BAForBSAction.paused								= nil -- 暂停
	BAForBSAction.state									= nil -- 状态
	BAForBSAction.printTree								= false

	BAForBSAction.idle									= 0
	BAForBSAction.running 								= 1
	BAForBSAction.completeState 						= 2
	BAForBSAction.pause 								= 3
	BAForBSAction.treeDes 								= nil

	------------------ functions -----------------------
	function BAForBSAction:release( ... )
		-- 释放函数
		self.disposed 	= true
		self:removeFromRender()					-- 执行
		self.calllerBacker:clearAll()
		self.blockBoard	= nil
		
		if(self.rootNode) then
			self.rootNode:release()
			self.rootNode = nil
		end

		self.logicData = nil
		self.blackBoard = nil
	end
	function BAForBSAction:isRunning( ... )
		return self.state == self.running
	end

	function BAForBSAction:isCompleteState( ... )
		return self.state == self.completeState
	end

	function BAForBSAction:start()
		-- Logger.debug("BAForBSAction:start 1")
		if(self.blackBoard ~= nil and self.logicData ~= nil and self.disposed ~= true) then 
			-- Logger.debug("BAForBSAction:start 2")
			-- --print("BAForBSAction:start->",self:instanceName(),"  name:",self.blackBoard.des)
		 	if(self.state == nil or self.state == self.idle) then -- 如果是没有开始
		 		-- Logger.debug("BAForBSAction:start 3")
		 		self.state 			 = self.running
		 		
		 		if(self.blackBoard.refresh ~= nil) then
		 			self.blackBoard:refresh()
		 		end

		 		local actionComplete = function( ... )
		 			local target = self
		 			if(target.disposed ~= true) then
		 				target:actionComplete()
		 			end
		 		end -- function end

			 	local completeClosure = function( ... )
			 		local target = self
				 	if(target.disposed ~= true) then
				 		target:allComplete()
				 	end
			 	end -- function end

			 	-- for k,v in pairs(self.logicData) do
			 	-- 	print("logicData",k,v)
			 	-- end
				self.blackBoard.treeComplete					= completeClosure
				self.blackBoard.actionComplete 					= actionComplete
				self.rootNode 									= BattleNodeFactory.getRootNode(self.logicData,self.blackBoard)
				-- self.rootNode:--print("start@@@")
				self.rootNode:travel()
				-- self:addToRender()


			elseif(self.state == self.pause) then	-- 如果是暂停状态
				self.state 			 = self.running
				self:actionComplete()
		 	end -- if end


		else
			error("BAForBSAction start error")
			self:complete()
		end
		
	end


	function BAForBSAction:pause()
		self.state 			 = self.pause
	end

	function BAForBSAction:toString(p)
		if(self.rootNode) then
				Logger.debug(" 	")
		 		Logger.debug(" 	")
		 		Logger.debug(" *************************** ")
				self.rootNode:toString(p)
				Logger.debug(" 	")
				Logger.debug(" 	")
		end
	end
 	function BAForBSAction:actionComplete()

 	-- 	if(self.rootNode) then
		-- 	Logger.debug(" 	")
	 -- 		Logger.debug(" 	")
	 -- 		Logger.debug(" *************************** ")
		-- 	self.rootNode:toString("@@@")
		-- 	Logger.debug(" 	")
		-- 	Logger.debug(" 	")
		-- end

 		
 		-- if(self.printTree == true) then self.rootNode:--print("actionComplete$$$") end
 		-- --print("BAForBSAction:complete",self.name)
		 -- --print("*************************", self.name ,  " AttackerLogic:actionComplete")
		 -- if(__cname)
		 -- --print("								")
		 -- --print("================================= one complete ",self:instanceName()," des:",self.blackBoard.des)
		 if(self.disposed ~= true) then
 			 if(self.state == self.running) then

			 	if(BATTLE_CONST.NODE_FALSE == self.rootNode:travel()) then
			 		self:allComplete()
			 	end
			 	
			 	if(self.state ~= self.completeState) then
			 		-- self.rootNode:--print("actionComplete$$$")
			 	end
			 	 -- --print("================================= one print end")
			 else
			 	 --print("BSTree is pause:",self.blackBoard.des)
			 end
		 else
		 	 -- --print("================================= BAForBSAction:actionComplete disposed",self.name)
		 end
	

		 -- --print("								")
	end

	function BAForBSAction:allComplete()
		-- Logger.debug(" 	")
 	-- 	Logger.debug(" 	")
 	-- 	Logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$")
		-- self.rootNode:toString("allComplete$$$")
		-- Logger.debug(" 	")
		-- Logger.debug(" 	")
 
		-- --print("############# BSActionComplete:")
		-- if(self.printTree == true) then self.rootNode:toString("allComplete$$$") end
		self.state			= self.completeState
		
		 if(self.disposed ~= true) then
		 	self:complete()
		 	self:release()
		 else

		 	--print("BAForBSAction:allComplete disposed:",debug.traceback())
 
		 	return nil
		 end

		-- --print("BSTree end:",self.name)
		-- --print("================================= allComplete ",self:instanceName()," des:",self.blackBoard.des)
		-- --print("BAForBSAction:start->end->",self:instanceName(),"  name:",self.blackBoard.des)
		-- self.rootNode:toString("@@@")
		
		-- --print("================================= allComplete print end")
		-- --print("								")
	end
return BAForBSAction