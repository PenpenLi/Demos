-- 执行所有children 节点,有1个为true,则返回true, 全部为false则返回false
--  
local BSParallelOr = class("BSParallelOr",require(BATTLE_CLASS_NAME.BSNode))
	 
		------------------ properties ----------------------
		-- 节点结果
-- NODE_FALSE											= 1 				-- 相当于返回false
-- NODE_TRUE											= 2					-- 相当于返回true
-- NODE_RUNNING 										= 3 				-- 当前节点正在运行
-- NODE_COMPLETE										= 4	
	
		------------------ functions -----------------------
		function BSParallelOr:travel()
			-- --print("---------------------------- BSParallelOr:travel ->",self.data.des)
			if(self.disposed == true) then
				return BATTLE_CONST.NODE_FALSE
			end
			if(self.state == nil) then
				self.state = ""
			end
			if self.children ~= nil then
				-- 是否动作有一个是true
				local hasTrue				= BATTLE_CONST.NODE_FALSE
	 			-- 全部执行, or 逻辑：有一个true 则返回true
	 			local count 				= 0
	 			local returnResult 			= BATTLE_CONST.NODE_FALSE
				for key,action in pairs(self.children) do
					-- --print("------------------or node travel:",action.name)
					count 					= count + 1
					local result 			= action:travel() 
					if(result == BATTLE_CONST.NODE_TRUE or result == BATTLE_CONST.NODE_RUNNING) then
						-- --print("BSParallelOr:",action.data.des)
						hasTrue 			= result 
						returnResult 		= BATTLE_CONST.NODE_TRUE
					end -- if end

				end
				-- if(hasTrue == false) then 
				if(hasTrue == BATTLE_CONST.NODE_TRUE )then 
					self.state = "true"
					-- --print("BSParallelOr return:",self.data.des," travel :","true" ,"num:",count) 
				elseif(hasTrue == BATTLE_CONST.NODE_RUNNING) then
					self.state = "running"
					-- --print("BSParallelOr return:",self.data.des," travel :","running" ,"num:",count) 
				elseif(hasTrue == BATTLE_CONST.NODE_FALSE) then
					self.state = "false"
					-- --print("BSParallelOr return:",self.data.des," travel :","false" ,"num:",count) 
				end
				return returnResult 
			end -- if end
			-- --print("BSParallelOr ", self.name," get fasle ")
			self.state = "false"
			return BATTLE_CONST.NODE_FALSE
		end -- function end


		function BSParallelOr:printValue()
			if(self.state == nil) then
				self.state = "wait"
			end	
			return " BSParallelOr:" .. self.data.des .. " " ..  self.state
		end

return BSParallelOr