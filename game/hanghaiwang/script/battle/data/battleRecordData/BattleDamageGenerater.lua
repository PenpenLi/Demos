
local BattleDamageGenerater = class("BattleDamageGenerater")
	 
		------------------ properties ----------------------
		BattleDamageGenerater.underAttackers 				= nil -- 被攻击的人伤害数据 BattleUnderAttackerData
		BattleDamageGenerater.animationName 				= nil -- 动画,用来获取关键帧数量,由此来生成多段伤害
		BattleDamageGenerater.totalTime 					= nil -- 多段总次数
		BattleDamageGenerater.current 						= nil -- 当前次数
		BattleDamageGenerater.damagesPercent				= nil
		BattleDamageGenerater.hitEffectName 				= nil -- 击中效果
		BattleDamageGenerater.blackBoard 					= nil 
		BattleDamageGenerater.totalDamage 					= nil -- 总伤害
		BattleDamageGenerater.rageExcuted					= nil -- 怒气是否输入
		------------------ functions -----------------------
		function BattleDamageGenerater:ctor()
			self.rageExcuted = false
		end
		function BattleDamageGenerater:pushData(data)
			if(self.underAttackers == nil ) then 
				self.underAttackers  = {}
			end

			if(data ~= nil ) then 
				table.insert(self.underAttackers,data)
			else
				--print("BattleDamageGenerater:pushData is nil ")
			end
		end
		-- 触发怒气伤害
		function BattleDamageGenerater:excuteRage( ... )
			if(not self.rageExcuted) then
				self.rageExcuted = true
				for k,v in pairs(self.underAttackers or {}) do
					
					-- 发送伤害怒气伤害
					if(v.rage ~= 0) then
						local targetData = BattleMainData.getTargetData(v.defender)
						if(targetData) then
							targetData:rageChangeBy(v.rage)
						end -- if end
					end -- if end
				end-- for end
			end -- if end

		end -- function end

		function BattleDamageGenerater:init(totalTime)

					-- self.damageGenerater.animationName			= self.blackBoard.attackEffectName
				-- self.damageGenerater.hitEffectName 			= self.blackBoard.attackHitEffectName
				-- self.damageGenerater.hurtActionName 		= self.blackBoard.hurtActionName
				-- if(v) then
				-- 	--print(v," : self.underAttackers:",self.underAttackers," self.blackBoard.attackEffectName:",self.blackBoard.attackEffectName)
				if(totalTime ~= nil and totalTime > 0) then
					self.totalTime = totalTime
					self.current 							= 0
					self.damagesPercent 					= 1/self.totalTime
				-- if(self.underAttackers~= nil and self.blackBoard.attackEffectName ~= nil) then
				-- 	self.totalTime 							= db_BattleEffectAnimation_util.getAnimationTotalKeyFrames(self.blackBoard.attackEffectName)
				-- 	-- 如果没有关键帧,就代表是单帧
				-- 	if(self.totalTime == nil or self.totalTime <= 0) then 
				-- 		self.totalTime 						= 1
				-- 	end

				-- 	self.current 							= 0
				-- 	self.damagesPercent 					= 1/self.totalTime
				else
					self.totalTime = 1
					self.current 							= 0
					self.damagesPercent 					= 1/self.totalTime
				end -- if end

		end -- function end
		function BattleDamageGenerater:getMulityDieDamage(data)
			-- local damage = math.floor(math.abs((data.beforSkillHP - 1)/(self.totalTime - 1)))
			-- if(data.hp < 0) then damage = damage * -1 end
			-- if (self.current == self.totalTime) then
			-- 	return  data.beforSkillHP + damage * 3  - 1 
			-- else
			-- 	return damage
			-- end
			-- return damage

			-- 最后一击留1滴血 + 超过血量,前面的多段平分
			local damage = math.floor(math.abs((data.beforSkillHP - 1)/(self.totalTime - 1)))
			
			if (self.current == self.totalTime) then
				damage =  data.hp + damage * (self.totalTime - 1) 
			else
				if(data.hp < 0) then damage = damage * -1 end
			end
			return damage

		end

		function BattleDamageGenerater:excuteAll( ... )
			if(self.current == nil ) then self:init() end
			-- loopTime 防止进入死循环
			loopTime = 0
			while(self.current < self.totalTime and loopTime < 1000) do
				loopTime = loopTime + 1
				self:excute()
			end
			self:excuteRage()
		end


		function BattleDamageGenerater:getDamage( totalKeyFrame,currentKeyFrame,totalDamage )

			local lessThan0 = totalDamage < 0
			local xxx		= 1

			-- 这个公式只对正数起作用(策划保证伤害是正数,但是实际战斗中这个数字是负数,所以先取反,最后再乘回去)
			if(lessThan0 == true) then 
				totalDamage = totalDamage * -1 
				xxx 		= -1 
			end
			-- 第1段～N-1段， 显示值都为:INT(M/N),可以为0
			-- 第N段：显示值为M-INT(M/N)*(N-1)，可以为0
			if(currentKeyFrame ~= totalKeyFrame) then
				return math.floor(totalDamage/totalKeyFrame) * xxx
			else
				return (totalDamage - math.floor(totalDamage/totalKeyFrame) * (totalKeyFrame - 1)) * xxx
			end
		end

		function BattleDamageGenerater:excute( info )


			-- --print("====== BattleDamageGenerater:excute")
			if(self.current == nil ) then self:init() end
			if (self.current < self.totalTime) then 
				self.current = self.current + 1
				local isMulityAttack = false
				-- 如果是多段我们需要记录下技能前伤害目标的血量,用于计算多段死亡
 				if(self.totalTime > 1 and self.current == 1) then
 					
 					for index,damageInfo in pairs(self.underAttackers or {}) do
 						local targetData = BattleMainData.getTargetData(damageInfo.defender) or {}
 						damageInfo.beforSkillHP = targetData.currHp
 					end	
 					isMulityAttack = true
 				end

 				
				for k,v in pairs(self.underAttackers or {}) do
					
					-- 发送伤害
					-- EventBus.sendNotification(NotificationNames.EVT_SKILL_DAMAGE)
					local data 	 = BattleMainData.getTargetData(v.defender)
					
					-- 这里之所以用绝对值是因为,floor向下取整时会有: math.floor(-0.1) = -1 这不是想要的数值,所以用绝对值,然后取其符号
					local cost   = math.floor(math.abs(v.hp) * self.damagesPercent)
					if(v.hp < 0) then cost = cost * -1 end
					
					

					-- Logger.debug(" BattleDamageGenerater:state: cost" .. cost .. " defender:" ..v.defender .. " v.hp:" .. v.hp)
					
					

					if(data ~= nil ) then

						-- 应策划需求 多段伤害的显示和计算用不同的规则.
						-- 呵呵 2015.6.29 丁青云
						-- 用于显示数字的伤害(因为多段特殊需求:伤害显示和实际扣血不同步的需求导致)
						local showDamage = self:getDamage(self.totalTime,self.current,v.hp)

						local damage = 0	-- 这一次的伤害值 
						if (self.current == self.totalTime) then
 							
 							-- data.currHp 
 							-- 如果是多段,且死亡
							if(self.totalTime > 1 and v.beforSkillHP + v.hp < 0) then
								-- 最后一击留1滴血 + 超过血量,前面的多段平分
								damage = self:getMulityDieDamage(v)
								-- v.beforSkillHP + v.hp  - 1 --(data.currHp -1)/(self.totalTime - 1)
								-- Logger.debug("多段最终伤害:".. tostring(damage) .. " 最终总伤害:" .. v.hp)
							else

								damage = math.floor(v.hp - cost * self.current + cost)
							end

							
 							 -- Logger.debug(" BattleDamageGenerater:excute:" .. lastCost .. " " ..v.defender .. " v.hp:" .. v.hp)
							if(self.totalTime == 1) then
								data:pushDamageInfo(v.hp,v,self.current,self.totalTime)--self.blackBoard)
 							else
 								data:pushDamageInfo(damage,v,self.current,self.totalTime,showDamage)
 							end
							
							if(v.buffer and v.buffer:hasBuffInfo()) then
							 		data:pushBuffInfo(v.buffer,2)
							end
 
						else
							-- if(v.hp == 0 or v.hp == 1) then
							-- 	data:pushDamageInfo(0,v,self.current)--self.blackBoard)
							-- else
							-- 如果是多段,且死亡
							if(self.totalTime > 1 and v.beforSkillHP + v.hp < 0) then
								-- 最后一击留1滴血 + 超过血量,前面的多段平分
								-- 这里之所以用绝对值是因为,floor向下取整时会有: math.floor(-0.1) = -1 这不是想要的数值,所以用绝对值,然后取其符号
								damage   = self:getMulityDieDamage(v)
								data:pushDamageInfo(damage,v,self.current,self.totalTime,showDamage)

								
								Logger.debug("多段平均:".. tostring(damage) .. " 最终总伤害:" .. v.hp)
							else	
								data:pushDamageInfo(cost,v,self.current,self.totalTime,showDamage)--self.blackBoard)
 							end
							-- end
							-- Logger.debug("BattleDamageGenerater cost: " .. cost .. " target:" .. v.defender)
						end
						 --self.hitEffectName-- 击中效果
						-- local hit 						= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
		 			-- 	--local selfUI 					= self.blackBoard.attackerUI
						-- hit.heroUI						= data.displayData
						-- hit.animationName	 			= self.blackBoard.attackHitEffectName
						-- hit.soundName 					= self.blackBoard.hitSound
						-- -- --print("BattleDamageGenerater:excute attackEffectName:",self.blackBoard.attackHitEffectName)
						-- BattleActionRender.addAutoReleaseAction(hit)
					else 
						error("BattleDamageGenerater 未找到伤害对象:",v.defender)
					end
				end
			end
			self:excuteRage()
			-- -- todo buff
			-- if (self.current == self.totalTime) then
			-- 	for k,v in pairs(self.underAttackers) do
			-- 		-- buff信息
			-- 		-- 怒气
			-- 		if(v.rage ~= nil and v.rage ~= 0) then
			-- 			local data 	 = BattleMainData.getTargetData(v.defender)
			-- 			data:pushRageInfo(v.rage)
			-- 		end
			-- 	end
			-- end 
		end
return BattleDamageGenerater