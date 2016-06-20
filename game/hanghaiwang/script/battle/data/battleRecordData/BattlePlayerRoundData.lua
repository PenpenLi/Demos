


local BattlePlayerRoundData = class("BattlePlayerRoundData")


-- 人物回合数据(注意不会游戏的回合,人物回合是指出手1次)



-- round : int
-- 	attacker : int
-- 	defender : int
-- 	action : int 		//技能ID
-- 	rage : int			//技能导致的怒气改变


------------------ properties ----------------------
 	BattlePlayerRoundData.round 			= nil -- 回合
 	BattlePlayerRoundData.attacker			= nil -- 攻击者 id
 	BattlePlayerRoundData.id				= nil -- 攻击者 id
 	BattlePlayerRoundData.skill				= nil -- skil id
 	BattlePlayerRoundData.rage 				= nil -- 怒气
 	BattlePlayerRoundData.attackerbuffinfo	= nil -- buff
 	BattlePlayerRoundData.arrChildSkills 	= nil -- 子技能
 	BattlePlayerRoundData.underAttackers	= nil -- 受到伤害的人
 	BattlePlayerRoundData.defender 			= nil -- 技能目标
 	BattlePlayerRoundData.allBuffs 			= nil
	BattlePlayerRoundData.skillDamage		= nil -- 技能伤害(不包含buff,不包含子技能) 目前用于显示多段总伤害
	BattlePlayerRoundData.benchList			= nil -- 替补上场列表
 	BattlePlayerRoundData.damageMap 		= nil
 	BattlePlayerRoundData.canPreStart 		= nil -- 是否可以提前开始执行下一回合
	------------------ functions -----------------------
	
	function BattlePlayerRoundData:ctor( ... )
		ObjectTool.setProperties(self)
	end

  	function BattlePlayerRoundData:getAttackerDamage(damagesMap)
  		 
  		if(damagesMap[self.id] == nil) then
  			damagesMap[self.id] = {reduceHP=0,addHP=0}
  		end
  		-- 统计攻击者加血buff
  		if(self.attackerbuffinfo:hasBuffInfo()) then

			local buffDamage = self.attackerbuffinfo.totalHpDamge
			if(buffDamage > 0) then
				damagesMap[self.id].addHP		= damagesMap[self.id].addHP + buffDamage
			end
		end

  		-- 被攻击者技能伤害 和 加血buff
		if(self.underAttackers) then
			for k,under in pairs(self.underAttackers or {}) do
				damagesMap[self.id].reduceHP	= damagesMap[self.id].reduceHP + under:skillHpDamage()
				local buffDamage = under:bufferHpDamage()
				if(buffDamage > 0) then
					damagesMap[self.id].addHP		= damagesMap[self.id].addHP + buffDamage
				end
			end
		end

		-- 子技能buff
		for k,subSkill in pairs(self.arrChildSkills or {}) do
			 subSkill:getAttackerDamage(damagesMap)
		end

  	end
  	-- 获取最终上场替补
	function BattlePlayerRoundData:refreshBenchMap( benchMap )
		if(nil == benchMap) then benchMap = {} end
		-- 如果有替补数据
		if(self.benchList and #self.benchList > 0) then
			for k,info in pairs(self.benchList or {}) do
				-- 刷新阵型(key = pos, value=id)
				benchMap[tonumber(info.pos)] = tonumber(info.id)
			end
		end
 
	end
	-- 获取每个人得伤害数据
	function BattlePlayerRoundData:refreshDamageMap(damagesMap)
		if(nil == damagesMap) then damagesMap = {} end

		if(self.attackerbuffinfo:hasBuffInfo()) then
			-- 攻击者buff
			local id 			= tonumber(self.attackerbuffinfo.id)
			--print("id:",id)
			if(damagesMap[id] == nil) then
			 	damagesMap[id]	=  {0,0}
			end
			
			damagesMap[id][1] 	= damagesMap[id][1] + self.attackerbuffinfo.totalHpDamge
			damagesMap[id][2] 	= damagesMap[id][2] + self.attackerbuffinfo.totalRageDamage
		end
		-- 被攻击者
		if(self.underAttackers) then
			for k,under in pairs(self.underAttackers or {}) do
				local underid 					= tonumber(under.id)
				-- damagesMap[id] 		= damagesMap[id] or {0,0}
				if(damagesMap[underid] == nil) then
			 		damagesMap[underid]	=  {0,0}
				end
				self.skillDamage 			= self.skillDamage + under.hp
				damagesMap[underid][1] 	= damagesMap[underid][1] + under:totalHpDamage()
				damagesMap[underid][2] 	= damagesMap[underid][2] + under:totalRageDamage()
			end
		end

		-- 子技能buff
		 
		for k,subSkill in pairs(self.arrChildSkills or {}) do
			 subSkill:refreshDamageMap(damagesMap)
		end
			
	end

	function BattlePlayerRoundData:hasMulityTargets( ... )
		if(self.underAttackers and #self.underAttackers > 1 and self.skillDamage ~= 0) then
			return true
		end
		return false
	end
	--获取所有和技能相关的人( result["hid"] = 1)
	function BattlePlayerRoundData:getSkillEffectTargets()
		local result = {}
		-- 获取当前技能人员
			-- 攻击者
			result[self.attacker] = 1
			-- 被攻击者
			for k,v in pairs(self.underAttackers or {}) do
				 result[v.id] = 1
			end
		
		-- 获取子技能人员
		for k,subSkill in pairs(self.arrChildSkills or {}) do
			local subSkillPersons =  subSkill:getSkillEffectTargets()
			for id,target in pairs(subSkillPersons or {}) do
				 result[id] = 1
			end
		end

		return result

	end
	function BattlePlayerRoundData:debugDamageInfo( ... )
		Logger.debug("==================== debugDamageInfo ==================== ")
		for hid,info in pairs(self.damageMap) do
			Logger.debug("hero:"..hid .. " hpDamageTotal:" .. info[1])
		end
	end

	-- 将当前伤害数据合并到输入的参数中
	function BattlePlayerRoundData:combineTo( targetMap )
		if(targetMap) then
	
			for k,v in pairs(self.damageMap or {}) do
				local id 		 = tonumber(k)
				targetMap[id] 	 = targetMap[id] or {0,0}
				targetMap[id][1] = targetMap[id][1] + v[1]
				targetMap[id][2] = targetMap[id][2] + v[2]
			end
		end

	end
	function BattlePlayerRoundData:getRoundMark( ... )
		return tostring(self.attacker) ..  "_" .. tostring(self.skill)
	end

	-- 查询指定id的player是否有buff
	function BattlePlayerRoundData:isPlayerHasBuff( id )
		local id_num = tonumber(id)
		for k,buffinfo in pairs(self.allBuffs or {}) do
			 if(buffinfo.id == id_num) then
			 	return true
			 end
		end

		-- 子技能buff
		for k,subSkill in pairs(self.arrChildSkills or {}) do
			if(subSkill:isPlayerHasBuff(id) == true) then
			 	return true
			end
		end

		return false
	end
	function BattlePlayerRoundData:reset( data , canPreStart )
		
		self.canPreStart 					= canPreStart
		self.allBuffs 						= {}
		

 		self.round 							= tonumber(data.round)
 		self.attacker 						= tonumber(data.attacker)
 		self.id 							= self.attacker
 		self.skill 							= tonumber(data.action)
 		self.rage 							= tonumber(data.rage)
 		self.defender 						= tonumber(data.defender)
 		self.skillDamage 					= 0

 		-- 硬编码:当技能为0时,将其指向表中的技能1(因为表中没有技能0)
 		-- 已经放到了 db_skill_util中,发现不存在技能时替换为技能1
 		-- if(self.skill == 0 and getItemByid) then
 		-- 	self.skill = 1
 		-- 	data.action = 1
 		-- end

 		-- local damage					= require(BATTLE_CLASS_NAME.BattleBuffDamage).new()
		-- local fake  					= {}
		-- fake.bufferId					= 96
		-- fake.type 						= 9
		-- fake.data 						= 11
		
		-- -- damage:reset(fake,self.id)
		-- -- local bf = {}
		-- -- bf[1] = damage
		-- data.buffer = {fake}
 		--攻击者的buff信息
 		self.attackerbuffinfo 				= require(BATTLE_CLASS_NAME.BattleBuffsInfo).new()
 		self.attackerbuffinfo:reset(data,self.id)
 		-- Logger.debug("self.attackerbuffinfo:hasBuffInfo():" .. tostring(self.attackerbuffinfo:hasBuffInfo()))
 		if(self.attackerbuffinfo:hasBuffInfo()) then 
 			
 			table.insert(self.allBuffs,self.attackerbuffinfo)
 		end

 		--初始化受伤的人
 		local underAttNum = 0
 		self.underAttackers 				= nil
 		if data.arrReaction ~= nil then 
 			self.underAttackers 			= {}
 			for k,v in pairs(data.arrReaction) do
 				
 
				-- v.enBuffer 		= {}
				-- v.enBuffer[1]	= 95

				-- v.buffer 		= {}
				-- v.buffer[1]     = {bufferId=94,type=1,data=94}
				-- -- v.buffer[1]     = {bufferId=94,type=2,data=-10}

				-- v.deBuffer		= {}
				-- v.deBuffer[1]	= 95

 				local under 				= require(BATTLE_CLASS_NAME.BattleUnderAttackerData).new()
 				under:reset(v,self.skill)
 				table.insert( self.underAttackers , under )
				-- buffData.imBuffer		= {}
				-- buffData.imBuffer[1]	= 93
			
				underAttNum = underAttNum + 1

 				if(under.buffer and under.buffer:hasBuffInfo()) then 
 					table.insert(self.allBuffs,under.buffer)
 				end
 			end
 			
 		end
 		-- 修正单个目标的攻击对象
 		if(underAttNum == 1) then
 			self.defender = self.underAttackers[1].id
 		end

 		if(#self.allBuffs < 1) then 
 			self.allBuffs = nil
 		else
 			--print("BattlePlayerRoundData: has buffinfo:",#self.allBuffs)
 		end
 		self.benchList					= data.arrBench
 		-- 更细伤害信息map
 		self.damageMap 					= {}
 		-- self:refreshDamageMap(self.damageMap)
 		-- 初始化子技能
 		self.arrChildSkills 				= nil
 		if data.arrChild ~= nil then
 			self.arrChildSkills 			= {}
 			for k,v in pairs(data.arrChild) do
 				local subSkill 				= require(BATTLE_CLASS_NAME.BattlePlayerRoundData).new()
 				subSkill:reset(v)
 				subSkill.isSubskill 		= true
 				table.insert( self.arrChildSkills , subSkill )
 			end -- for end
 		end-- if end
 		self:refreshDamageMap(self.damageMap)
	end -- function end

	function BattlePlayerRoundData:getBlackBoard()
		local blackBoard 			= require("script/battle/data/BattleBlackBoard").new()
		blackBoard:reset(self)
		return blackBoard
	end



return BattlePlayerRoundData

-- 	enBuffer : array	//新加的buff
-- 	deBuffer : array	//消失的buff
-- 	imBuffer : array	//免疫掉的buff
-- 	buffer : array
-- 	[
-- 		{
-- 			bufferId : int 	
-- 			type : int		//buff效果类型
-- 			data : int 		//buff效果数值
-- 		}
-- 	]
	
-- 	arrReaction : array
-- 	[
-- 		{
-- 			defender : int 		
-- 			reaction : int		//响应ID： 命中/闪避/格挡。。。
-- 			fatal : bool		//是否触发暴击
-- 			rage : int			
-- 			arrDamage : array
-- 			[
-- 				{
-- 					damageType : int
-- 					damageValue : int
-- 				}
-- 			]
-- 			enBuffer : array	
-- 			deBuffer : array
-- 			imBuffer : array
-- 			buffer : array
			 
-- 		}
-- 	]
	
-- 	arrChild : array
-- 	[
-- 		{
-- 			//同actionRecord, 
-- 		}
-- 	]