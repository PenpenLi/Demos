
--if 条件
-- 支持 大于，小于，等于，区间
-- dtype 只有等于的时候可以用到，支持string，number,bool 3种类型

require (BATTLE_CLASS_NAME.class)
local BSConditionNode = class("BSConditionNode",require(BATTLE_CLASS_NAME.BSNode))

  
	------------------ properties ----------------------
 
	BSConditionNode.conditionType				= nil --判断类型

	-- BSConditionNode.BIG_THAN					= 1
	-- BSConditionNode.BETWEEN						= 2
	-- BSConditionNode.LESS_THAN					= 3
	-- BSConditionNode.EQUAL 						= 4

	------------------ functions -----------------------
	function BSConditionNode:travel()
		if(self.disposed) then
			return BATTLE_CONST.NODE_FALSE
			-- todo 这里有个问题一直不知道为什么,死亡的时候会多次调用,一个dispose的节点
			-- error("BSConditionNode:getSelfCondition:"..self.data.des)
		end
		
		local result = self:getSelfCondition()
		if result == true then 
			return BATTLE_CONST.NODE_TRUE
		else
			return BATTLE_CONST.NODE_FALSE
		end
	end
	function BSConditionNode:getSelfCondition( )
		if(self.disposed) then
			error("BSConditionNode:getSelfCondition:"..self.data.des)
		end
		
		self.conditionType 					= self.data.conditionType
		if self.conditionType == BATTLE_CONST.CONDITION_BIG_THAN then

			return tonumber(self.blackBoard[self.data.p1]) > tonumber(self.data.v1)

		elseif self.conditionType == BATTLE_CONST.CONDITION_LESS_THAN then

			return tonumber(self.blackBoard[self.data.p2]) < tonumber(self.data.v2)

		elseif self.conditionType == BATTLE_CONST.CONDITION_BETWEEN then

			return tonumber(self.blackBoard[self.data.p1]) > tonumber(self.data.v1) and tonumber(self.blackBoard[self.data.p2]) < tonumber(self.data.v2)
		
		elseif self.conditionType == BATTLE_CONST.CONDITION_NOT_EQUAL then

			if self.data.dtype == "string" then 
				return tostring(self.blackBoard[self.data.p1]) ~= tostring(self.data.v1)  
			elseif self.data.dtype == "bool" then 
				local value = self.data.v1
				if value == "true" or value == "1" then
					value = true
				else 
					value = false
				end
			----print("^^^^^^^^^^^ if node:",self.blackBoard[self.data.p1] == self.data.v1 or tostring(self.blackBoard[self.data.p1]) == self.data.v1)
				return self.blackBoard[self.data.p1] ~= value
			else 
				return  self.blackBoard[self.data.p1] ~= self.data.v1 or tostring(self.blackBoard[self.data.p1]) ~= self.data.v1
			end
		else
			if self.data.dtype == "string" then 
				return tostring(self.blackBoard[self.data.p1]) == tostring(self.data.v1)  
			elseif self.data.dtype == "bool" then 
				local value = self.data.v1
				if value == "true" or value == "1" or value == true then
					value = true
				else 
					value = false
				end
			-- --print("^^^^^^^^^^^ if "..self.data.p1,"node:",self.blackBoard[self.data.p1] == value)
				return self.blackBoard[self.data.p1] == value
			else 
				return  self.blackBoard[self.data.p1] == self.data.v1 or tostring(self.blackBoard[self.data.p1]) == self.data.v1
			end
		end
	end
	function BSConditionNode:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end	
		return "bool: ".. self.data.des .. " " ..  tostring(self:getSelfCondition())
	end
 
return BSConditionNode