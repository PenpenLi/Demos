local BattleRecordSourcAnalyser = class("BattleRecordSourcAnalyser")
 -- 解析战斗串(table)包含的所有特效资源
	------------------ properties ----------------------
	BattleRecordSourcAnalyser.indexMap 			= nil -- key,value:特效名称
	BattleRecordSourcAnalyser.allMap 			= nil -- key:特效名称 value:出现次数
	------------------ functions -----------------------
	
	function BattleRecordSourcAnalyser:reset( battleObject )
		assert(battleObject," 战斗数据不存在")
		self.indexMap = {}
		self.allMap = {}
		self.allMap["meffect_31"] = 999 	-- 爆豆
		self.allMap["ragebar"] = 999 		-- 怒气
		self.allMap["ragebar_2"] = 999 		-- 怒气
		self.allMap["nuqi_1"] = 999 		-- 怒气
		self.allMap["meffect_die"] = 999 		-- 怒气
		self.allMap["die_1_1"] = 999 		-- 怒气
		self.allMap["die_1_2"] = 999 		-- 怒气
		self.allMap["battle_total_hurt"] = 999 		-- 怒气
		self.allMap["meffect_die"] = 999 		-- 怒气
		-- self.allMap["nuqiji_2"] = 999 		-- 怒气
 
		for k,v in pairs(battleObject.battle) do
			 self.indexMap[k] = {}
			 self:recordRoundData(v,self.indexMap[k],k)
			 self:recordSubSkill(v,self.indexMap[k],k)
		end
 
	end
	function BattleRecordSourcAnalyser:printMap( ... )
		for k,v in pairs(self.indexMap or {}) do
			 for index,effect in pairs(v) do
			 	 Logger.debug("BattleRecordSourcAnalyser ->index:" .. k .. " " .. effect)
			 end
		end

		for k,v in pairs(self.allMap) do
			 Logger.debug("BattleRecordSourcAnalyser ->source count:" .. k .. " " .. v)
		end

	end
	function BattleRecordSourcAnalyser:recordRoundData(input,output,index)
		self.index = index
		local skill = tonumber(input.action)
		 self:recordSpellEffect(skill,output)
		 self:recordHitEffect(skill,output)
		 self:recordRemoteEffect(skill,output)
		 self:recordRageFireEffect(skill,output)
		 self:recordAnimationRageMask(skill,output)
		 self:recordBuffEffects(input,output)
		 self:recordUnderAttackers(input,output)
	end

	function BattleRecordSourcAnalyser:recordSubSkill( data , output ,index)
		if(data.arrChild) then
			for k,v in pairs(data.arrChild) do
				self:recordRoundData(v,output,index)
			end
		end
	end

	-- 记录攻击者数据
	function BattleRecordSourcAnalyser:recordUnderAttackers( data,output )
		 if(data and data.arrReaction) then
		 	for k,targetInfo in pairs(data.arrReaction) do
		 		 self:recordBuffEffects(targetInfo,output)
		 	end
		 end
	end
	-- 记录魔法效果
	function BattleRecordSourcAnalyser:recordSpellEffect(skill,output)
		local skillEffect = db_skill_util.getSkillAttackEffectName(skill)
		if(skillEffect ~= nil and skillEffect ~= "") then
			output[skillEffect] = skillEffect
			-- self.allMap[skillEffect] = skillEffect
			self:recordGlobalMap(skillEffect)
			-- Logger.debug("### skillEffect:" .. tostring(skillEffect))
		end
	end
	-- 击中效果
	function BattleRecordSourcAnalyser:recordHitEffect(skill,output)
		local hitEffect = db_skill_util.getHitEffectName(skill)
		if(hitEffect ~= nil and hitEffect ~= "") then
			output[hitEffect] = hitEffect
			-- self.allMap[hitEffect] = hitEffect
			self:recordGlobalMap(hitEffect)
			-- Logger.debug("### hitEffect:" .. tostring(hitEffect))
		end
 
	end

	-- 远程弹道
	function BattleRecordSourcAnalyser:recordRemoteEffect(skill,output)
		local distancePath = db_skill_util.getDistancePathName(skill)
		if(distancePath ~= nil and distancePath ~= "") then
			output[distancePath] = distancePath
			-- self.allMap[distancePath] = distancePath
			self:recordGlobalMap(distancePath)
			-- Logger.debug("### distancePath:" .. tostring(distancePath))
		end

	end
	function BattleRecordSourcAnalyser:recordRageFireEffect( skill,output )
		-- rageFireEffect
		 local rageFireEffect 					= db_skill_util.getRageFireEffect(skill)
		 if(rageFireEffect ~= nil and rageFireEffect ~= "") then
			output[rageFireEffect] = rageFireEffect
			-- self.allMap[rageFireEffect] = rageFireEffect
			self:recordGlobalMap(rageFireEffect)
			-- Logger.debug("### rageFireEffect:" .. tostring(rageFireEffect))
		end
	end

	function BattleRecordSourcAnalyser:recordRageFireEffect( skill,output )
		-- rageFireEffect
		 local rageFireEffect 					= db_skill_util.getRageFireEffect(skill)
		 if(rageFireEffect ~= nil and rageFireEffect ~= "") then
			output[rageFireEffect] = rageFireEffect
			-- self.allMap[rageFireEffect] = rageFireEffect
			self:recordGlobalMap(rageFireEffect)
			-- Logger.debug("### rageFireEffect:" .. tostring(rageFireEffect))
		end
	end

	
	function BattleRecordSourcAnalyser:recordAnimationRageMask( skill,output )
		-- rageFireEffect
		local isAnimationRageMask 				= db_skill_util.isAnimationRageMask(skill)
		local rageMaskName 						= db_skill_util.getSkillRageMaskName(skill)


		 if(isAnimationRageMask == true and rageMaskName ~= nil and rageMaskName ~= "") then
			output[rageMaskName] = rageMaskName
			-- self.allMap[rageFireEffect] = rageFireEffect
			self:recordGlobalMap(rageMaskName)
			-- Logger.debug("### rageFireEffect:" .. tostring(rageFireEffect))
		end
	end

	 

	function BattleRecordSourcAnalyser:recordGlobalMap(key)
		if(self.allMap[key] == nil) then 
			self.allMap[key] = self.index
		else
			if(self.index > self.allMap[key]) then
				self.allMap[key] = self.allMap[key]
			end
		end
		 
	end

	-- buff
	function BattleRecordSourcAnalyser:recordBuffEffects(data,output)
	
		-- buff添加
	
		if(data.enBuffer) then
			for k,v in pairs(data.enBuffer) do
				 -- buff图标
				 local buffIconName = db_buff_util.getIcon(v)
				 if(buffIconName ~= nil and buffIconName ~= "") then
					output[buffIconName] = buffIconName
					self:recordGlobalMap(buffIconName)
					-- Logger.debug("### buffIconName:" .. tostring(buffIconName))
				 end
				 -- 添加特效
				 local addEffect = db_buff_util.getAddEffectName(v)
				 if(addEffect ~= nil and addEffect ~= "") then
					output[addEffect] = addEffect
					-- self.allMap[addEffect] = addEffect
					self:recordGlobalMap(addEffect)
					-- Logger.debug("### addEffect:" .. tostring(addEffect))
				 end
			end
			
		end
		-- buff删除
		if(data.deBuffer) then
			for k,v in pairs(data.deBuffer) do
				local removeEffect = db_buff_util.getRemoveEffectName(v)

				 if(removeEffect ~= nil and removeEffect ~= "" and removeEffect ~= "nil") then
					output[removeEffect] = removeEffect
					-- self.allMap[removeEffect] = removeEffect
					self:recordGlobalMap(removeEffect)
					-- Logger.debug("### removeEffect:" .. tostring(removeEffect))
				 end
			end
		end
		-- buff伤害
		if(data.buffer) then
			for k,v in pairs(data.buffer) do
				local damageEffect = db_buff_util.getDamageEffectName(v.bufferId)
				if(damageEffect ~= nil and damageEffect ~= "") then
					output[damageEffect] = damageEffect
					-- self.allMap[damageEffect] = damageEffect
					self:recordGlobalMap(damageEffect)
					-- Logger.debug("### damageEffect:" .. tostring(damageEffect))
				end
			end
			
		end

		

	end -- function end


return BattleRecordSourcAnalyser