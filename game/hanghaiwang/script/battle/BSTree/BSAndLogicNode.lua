



-- 逻辑 and(全true为true,否则返回false)

require (BATTLE_CLASS_NAME.class)
local BSAndLogicNode = class("BSAndLogicNode",require(BATTLE_CLASS_NAME.BSNode))

  
	------------------ properties ----------------------
  

	------------------ functions -----------------------
	function BSAndLogicNode:travel()
		-- --print("---------------------------- BSAndLogicNode:travel ->",self.data.des)
		-- --print(self.treeName,"->traveled",self.name)
 		
		if(self.state == nil) then
			self.state = ""
		end

 		if self.children ~= nil then
 			-- and 逻辑：有一个false 则返回FALSE,如果是返回true则继续执行下一个,全部都是true 则返回true
			for key,action in pairs(self.children) do
				local result = action:travel() 
				if result == BATTLE_CONST.NODE_FALSE then
					-- --print("BSAndLogicNode ", self.name," get fasle ")
					self.state = "false"
					return BATTLE_CONST.NODE_FALSE

				-- elseif result == BATTLE_CONST.NODE_RUNNING then
				--  	return result
				end
			end
			self.state = "true"
			return BATTLE_CONST.NODE_TRUE
		end
		self.state = "false"
		return BATTLE_CONST.NODE_FALSE
	end

	function BSAndLogicNode:printValue()	
		if(self.state == nil) then
			self.state = "wait"
		end		
		return "and: " .. self.data.des .. " " ..  self.state
	end
 
	

return BSAndLogicNode