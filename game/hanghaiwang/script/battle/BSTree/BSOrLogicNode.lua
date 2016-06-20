



-- 逻辑 or(执行到第一个为true就返回)

require (BATTLE_CLASS_NAME.class)
local BSOrLogicNode = class("BSOrLogicNode",require(BATTLE_CLASS_NAME.BSNode))

  
	------------------ properties ----------------------
  

	------------------ functions -----------------------
	-- function BSOrLogicNode:travelSelf()
 -- 		if self.children ~= nil then

	-- 		for key,value in pairs(self.children) do
	-- 			local result = value:travel() 
	-- 			 if result ~= false then return result end
	-- 		end
	-- 	end
	-- 	return false
	-- end

	function BSOrLogicNode:release()
		-- call super release
		self.disposed 						  = true
		self.super.release(self)
	end
	function BSOrLogicNode:travel()
		-- --print("---------------------------- BSOrLogicNode:travel ->",self.data.des)
		-- --print(self.treeName,"->traveled orNode ",self.name)
		if(self.state == nil) then
			self.state = ""
		end

		if(self.disposed == true) then
			--print("---------------------------- error BSOrLogicNode:travel:",self.data.des)
			-- error(debug.traceback())
			--print("----------------------------")
			return BATTLE_CONST.NODE_FALSE
		end

		-- --print("***** travel or Node:",self.data.des)
 		if self.children ~= nil then
 			-- or 逻辑：有一个true 则返回true
			for key,action in pairs(self.children) do
				-- --print("------------------or node travel:",action.name)
				local result = action:travel() 
				-- --print("------------------or node get:",result)
				if(result == BATTLE_CONST.NODE_TRUE) then
					self.state = "true"
					return BATTLE_CONST.NODE_TRUE
				-- if type(result) == "table" then
				-- 	-- --print("or node get action:",result.__cname)
				-- 	return result
			 	end
				-- elseif result == BATTLE_CONST.NODE_RUNNING then
				--  	return BATTLE_CONST.NODE_TRUE
				-- end
			end
			self.state = "false"
			return BATTLE_CONST.NODE_FALSE
		end
		 --print("BSOrLogicNode ", self.name," get fasle ")
		return BATTLE_CONST.NODE_FALSE
	end

	function BSOrLogicNode:onActionComplete()
	
	end

	function BSOrLogicNode:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end	
		return " or:" .. self.data.des .. " " .. self.state
	end
 

return BSOrLogicNode