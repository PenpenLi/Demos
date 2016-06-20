local BattleBuffsInfo = class("BattleBuffsInfo")
 	-- enBuffer : array	//新加的buff
	-- deBuffer : array	//消失的buff
	-- imBuffer : array	//免疫掉的buff
	-- buffer : array
	-- [
	-- 	{
	-- 		bufferId : int 	
	-- 		type : int		//buff效果类型
	-- 		data : int 		//buff效果数值
	-- 	}
 
	------------------ properties ----------------------
	BattleBuffsInfo.id 					= nil -- buff释放对象
	BattleBuffsInfo.buffer 				= nil -- 带有伤害的buff(注意这是一个数组)
	BattleBuffsInfo.enBuffer			= nil -- 添加buff图标
	BattleBuffsInfo.imBuffer			= nil -- 免疫buff
	BattleBuffsInfo.deBuffer			= nil -- 删除buff
	BattleBuffsInfo.totalHpDamge 		= nil	  -- hp改变值
	BattleBuffsInfo.totalRageDamage 	= nil	  -- 怒气改变值

	BattleBuffsInfo.completeHistory 	= nil -- buff完成
	BattleBuffsInfo.debug 				= true
	BattleBuffsInfo.hasSkillDamage 		= nil -- 是否有技能伤害(为了满足策划需求增加的属性,用于判断buff伤害数字是否需要延迟)
	------------------ functions -----------------------


	--合并(必须提供id，以防误操作)
	function BattleBuffsInfo:combin(data , id)
		if id == self.id then
				 
				 self.combinTableByArrayStyle(self.enBuffer,data.enBuffer)
				 self.combinTableByArrayStyle(self.imBuffer,data.imBuffer)
				 self.combinTableByArrayStyle(self.deBuffer,data.deBuffer)

				 if self.buffer == nil then
				 	self.buffer = {}
				 end -- if end
				self:createDamageBuff(data.buffer)
		end -- if end
	end -- function end

	--以数组形势合并table
	function BattleBuffsInfo:combinTableByArrayStyle(to,from)
		--如果本身有数据
		if to ~= nil then
			if from ~= nil then
				for i,v in ipairs(from) do
					table.insert(to,v)
				end
			end
		else
			to = ObjectTool.deepcopy(from)
		end -- if end
	end -- function end

	function BattleBuffsInfo:reset( data , id)

		self.totalHpDamge 		= 0	  -- hp改变值
		self.totalRageDamage 	= 0	  -- 怒气改变值

		-- local combineTool = require("tableUtil")
		assert(id)
		self.id 					= tonumber(id)
		self.enBuffer				= ObjectTool.deepcopy(data.enBuffer)
		self.imBuffer				= ObjectTool.deepcopy(data.imBuffer)
		self.deBuffer				= ObjectTool.deepcopy(data.deBuffer)
		--处理buff（伤害数据)
		if data.buffer ~= nil then

			self.buffer = {}
			self:createDamageBuff(data.buffer)
		
		end -- if end
		-- if(BattleBuffsInfo.debug) then
		-- 	self.enBuffer = self.enBuffer or {}
		-- 	table.insert(self.enBuffer,710)
		-- 	BattleBuffsInfo.debug = false
		-- end
		self.completeHistory 		= {}
	end --function end
	function BattleBuffsInfo:record( id ,type)
		if(self.completeHistory[type] == nil ) then 
			self.completeHistory[type] = {} 
		end
		self.completeHistory[type][tostring(id)]			= true
	end

	function BattleBuffsInfo:isFirstRun( id , type)
		if(
			self.completeHistory[type] == nil or
		    self.completeHistory[type][tostring(id)] ~= true
		   ) then
			return true
		end
		return false
	end
	--将data中的数据写入buffer中（没有就会创建BattleBuffDamage 有就会调用合并函数）
	function BattleBuffsInfo:createDamageBuff(data)
		
		for i,v in ipairs(data) do
			 local damage = require(BATTLE_CLASS_NAME.BattleBuffDamage).new()
			 damage:reset(v,self.id)
			 table.insert(self.buffer,damage)
		  	 self.totalHpDamge 		= self.totalHpDamge  		+ damage.hpDamage
			 self.totalRageDamage 	= self.totalRageDamage  	+ damage.rageDamage
			-- --如果buff中没有这个buff
			--  if self.buffer[v.bufferId] == nil then
			--  	 -- damage					
				
			-- 	 self.buffer[damage.id] = damage
			-- 	 self.totalHpDamge 		= self.totalHpDamge  		+ damage.hpDamage
			-- 	 self.totalRageDamage 	= self.totalRageDamage  	+ damage.rageDamage
			--  else
			--  	 -- self.buffer[damage.id] = damage
			-- 	 self.buffer[damage.id].totalHpDamge 		= self.buffer[damage.id].totalHpDamge  		+ damage.hpDamage
			-- 	 self.buffer[damage.id].totalRageDamage 	= self.buffer[damage.id].totalRageDamage  	+ damage.rageDamage
			--  end -- if end
		end -- for end

	end -- function end
	--获取开始时间的列表
	function BattleBuffsInfo:getStartTimeList(list)
		local result = {}
		for i,v in ipairs(list) do
			--查表看
			table.insert(result,v)
		end-- for end
	end -- function end
	-- 获取中间状态的列表
	function BattleBuffsInfo:getDamageTimeList(list)
		local result = {}
		for i,v in ipairs(list) do
			--查表看
			table.insert(result,v)
		end
	end
	--获取结束时间的buff
	function BattleBuffsInfo:getEndTimeList(list)
		local result = {}
		for i,v in ipairs(list) do
			--查表看
			table.insert(result,v)
		end
	end
 

	function BattleBuffsInfo:hasBuffInfo()
		return self.enBuffer ~= nil or self.imBuffer ~= nil or self.deBuffer ~= nil or self.buffer ~= nil 
	end

	function BattleBuffsInfo:getTotalHpDamage( )
		return self.totalHpDamge
	end

	function BattleBuffsInfo:getTotalRageDamage( )
		 return self.totalRageDamage
	end
return BattleBuffsInfo