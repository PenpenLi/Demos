
-- 装饰节点,当子节点返回 complete 状态时 返回false(true和false不影响) 没有孩子返回false

-- 不支持多个node节点,只能装饰1个
-- 如果有多个动作,则直接返回false
local BSDecoratorCompleteFalse = class("BSDecoratorCompleteFalse",require(BATTLE_CLASS_NAME.BSNode))
	------------------ properties ----------------------
	function BSDecoratorCompleteFalse:travel()
		if(self.state == nil) then
			self.state = "wait"
		end
		-- --print("----------------------------  BSDecoratorCompleteFalse:travel ->",self.data.des)
		if (self.children ~= nil) then
			-- 不支持多个node节点,只能装饰1个
			if(#self.children > 1) then 
			 	--print(debug.traceback()) 
				return BATTLE_CONST.NODE_FALSE 
			end

			for key,action in pairs(self.children) do
				local result = action:travel()

				if(result == BATTLE_CONST.NODE_COMPLETE) then -- 如果执行完毕
					-- --print("BSDecoratorCompleteFalse:action is complete")
					self.state = "complete->false"
					return BATTLE_CONST.NODE_FALSE
				elseif result == BATTLE_CONST.NODE_RUNNING then
					-- --print("BSDecoratorCompleteFalse:action is running")
					-- action:toString("+++++++")
					self.state = "running->true"

					return BATTLE_CONST.NODE_TRUE
				elseif result == BATTLE_CONST.NODE_TRUE then
					self.state = "true->true"
					-- --print("BSDecoratorCompleteFalse:action is true")		
					return BATTLE_CONST.NODE_TRUE
				else
					self.state = "other->false"
					-- --print("BSDecoratorCompleteFalse:action is else:",result)
					return BATTLE_CONST.NODE_FALSE	
				end
			end -- for end
		end
		return BATTLE_CONST.NODE_FALSE
	end

	function BSDecoratorCompleteFalse:releaseChildren( ... )
		
		 if self.children ~= nil then
			for key,value in pairs(self.children) do
				-- if(value.release) then
					value:release()
					-- --print("BSDecoratorCompleteFalse:releaseChildren:",value.__cname)
				-- end
			end -- for end
		end -- if end
	end
	-- function BSDecoratorCompleteFalse:release()
	-- 	self.disposed 									= true
	--    --print("BSDecoratorCompleteFalse:release:",self.__cname)
		
	-- 	self:removeAllListeners()
	-- 	self:releaseChildren()

	-- 	self.blackBoard									= nil
	-- 	self.events 									= nil
	-- 	self.data 										= nil
	-- 	self.parent 									= nil
	-- 	self.children 									= nil
	-- end
	------------------ functions -----------------------
	function BSDecoratorCompleteFalse:printValue()
		if(self.state == nil) then
			self.state = "wait"
		end
		return "decorator:" .. self.state
	end
 
	
return BSDecoratorCompleteFalse