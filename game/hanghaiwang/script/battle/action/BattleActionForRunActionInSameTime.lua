


-- 同时播放action
-- 这个类相关 行为树的逻辑要移除,行为树应该有自己的类型,这个类应该只做纯粹的同时执行

require (BATTLE_CLASS_NAME.class)
local BattleActionForRunActionInSameTime = class("BattleActionForRunActionInSameTime",require(BATTLE_CLASS_NAME.BaseAction))
	------------------ properties ----------------------

	BattleActionForRunActionInSameTime.listForRunning 					= nil	-- 动作列表
	BattleActionForRunActionInSameTime.listForComplete 					= nil	-- 动作完成列表
	BattleActionForRunActionInSameTime.data 							= nil   -- 原始数据
	BattleActionForRunActionInSameTime.blackBoard 						= nil
	------------------ functions -----------------------
 	-- 初始化action
 	function BattleActionForRunActionInSameTime:init(data,blackBoard)
 		--print("BattleActionForRunActionInSameTime:init")
 		self:release()
 		
 		self.data 			 		= data
 		self.blackBoard 			= blackBoard

 		self.listForRunning 		= {}
 		self.listForComplete 		= {}

 		for k,value in pairs(self.data.actionsChildren) do
 			 local childAction 		= BattleNodeFactory.getAction(value,self.blackBoard)
 			 table.insert(self.listForRunning,childAction)
 		end
 		-- 根据action的权重排序 权重大的在前面
 		self:sortByWeight(self.listForRunning)
 		--print(" BattleActionForRunActionInSameTime:init complete")
 	end -- function end

	-- 添加回调 执行所有action,
	function BattleActionForRunActionInSameTime:start(data)
		--print("BattleActionForRunActionInSameTime:start 0")
		if(#self.listForRunning > 0) then
			local counter = 0
			self.name = "sameRun:"
			for i,childAction in ipairs(self.listForRunning) do
				counter = counter + 1
				childAction.calllerBacker:addCallBacker(self,self.handleOneActionComplete)
				--print("BattleActionForRunActionInSameTime:start call ",childAction.name)
				self.name = self.name.." "..childAction.name
				childAction:start()
			end
			--print("BattleActionForRunActionInSameTime:start run ",counter ," actions")
		else
			--print("BattleActionForRunActionInSameTime:start error")
			self:complete()
		end
 
	end -- function end

	-- 记录完成的action 
	function BattleActionForRunActionInSameTime:handleOneActionComplete(action,data)
		if action ~= nil then 
			--print("BattleActionForRunActionInSameTime:handleOneActionComplete:",action.name)
			table.insert(self.listForComplete,action)
			if #self.listForComplete == #self.listForRunning then 
				--print("BattleActionForRunActionInSameTime:handleOneActionComplete all complete",self.name)
				self:complete()
			end
		else
			--print("xxxxxxxxx action call back,action is nil")
		end
		
	end -- function end

	-- 销毁,释放回调 和 队列里的action
	function BattleActionForRunActionInSameTime:release()
		if self.calllerBacker ~= nil then
			self.calllerBacker:clearAll()
		end	

	    self.blockBoard											= nil
		self.data 												= nil

		if self.listForComplete ~= nil then 
			for k,value in pairs(self.listForComplete) do
				value:release()
			end
			self.listForComplete								= nil
		end

		if self.listForRunning ~= nil then 
			for k,value in pairs(self.listForRunning) do
				value:release()
			end
			self.listForRunning									= nil
		end
		
		-- self.animationName 										= nil
		self.name 												= nil
	end -- function end

return BattleActionForRunActionInSameTime