


-- 按时间点来触发
local BattleDamageGeneraterWithTime = class("BattleDamageGeneraterWithTime")
	 
		------------------ properties ----------------------
		BattleDamageGeneraterWithTime.underAttackers 				= nil -- 被攻击的人
	 	BattleDamageGeneraterWithTime.rageExcuted					= nil -- 怒气是否输入
		------------------ functions -----------------------
		function BattleDamageGeneraterWithTime:ctor()
			self.rageExcuted = false
		end
		function BattleDamageGeneraterWithTime:pushData(data,time)
			assert(time)
			--print("BattleDamageGeneraterWithTime:pushData:",time)
			assert(time >= 0)

			if(self.underAttackers == nil ) then 
				self.underAttackers  = {}
			end
			if(data ~= nil ) then 
				self.underAttackers[data] = time
				-- table.insert(,data)
			else
				--print("BattleDamageGenerater:pushData is nil ")
			end
		end
 
		function BattleDamageGeneraterWithTime:release( ... )
			self.underAttackers = nil
		end


		-- 触发怒气伤害
		function BattleDamageGeneraterWithTime:excuteRage( ... )
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


		function BattleDamageGeneraterWithTime:update( dt )
 			for targetData,leftTime in pairs(self.underAttackers or {}) do
 				leftTime = leftTime - dt
 				if(leftTime <= 0) then

 					local data 	 = BattleMainData.getTargetData(targetData.defender)
					
 					data:pushDamageInfo(targetData.hp,targetData)--self.blackBoard)
				 	if(targetData.buffer and targetData.buffer:hasBuffInfo()) then
				 		data:pushBuffInfo(targetData.buffer,2)
				 	end
				 	self.underAttackers[targetData] = nil
				 	self:excuteRage()
				else
					self.underAttackers[targetData] = leftTime
 				end
 			end
		end

		function BattleDamageGeneraterWithTime:excuteAll( ... )
			for targetData,leftTime in pairs(self.underAttackers or {}) do
				 
				local data 	 = BattleMainData.getTargetData(targetData.defender)
				
				data:pushDamageInfo(targetData.hp,targetData)--self.blackBoard)
			 	if(targetData.buffer and targetData.buffer:hasBuffInfo()) then
			 		data:pushBuffInfo(targetData.buffer,2)
			 	end
 				 
 			end
 			self:excuteRage()
		end
return BattleDamageGeneraterWithTime