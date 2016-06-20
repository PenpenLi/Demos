

-- 动画触发伤害
-- 支持多个
require (BATTLE_CLASS_NAME.class)
local BAForAnimationTrigerAction = class("BAForAnimationTrigerAction",require(BATTLE_CLASS_NAME.BaseAction))
 

 	------------------ properties ----------------------
 	BAForAnimationTrigerAction.animationName 		 = nil -- 目标动画
 	BAForAnimationTrigerAction.underAttackers 		 = nil
 	BAForAnimationTrigerAction.eachDelay			 = nil
 	-- BAForAnimationTrigerAction.isEffOnEveryOne 		 = nil
 	-- BAForAnimationTrigerAction.isEffOnCenter 		 = nil
 	BAForAnimationTrigerAction.total				 = nil
 	BAForAnimationTrigerAction.count 				 = nil
 	BAForAnimationTrigerAction.demageMaps 			 = nil
 	BAForAnimationTrigerAction.delayStart 			 = nil -- 延迟起始值
 	------------------ functions -----------------------
 	function BAForAnimationTrigerAction:start( ... )
 		-- print(" BAForAnimationTrigerAction:start",self.delayStart)
 		if(self.delayStart == nil) then
 			self.delayStart = 0
 		end

 		-- 如果没有伤害数据,我们立即停止
 		if(self.underAttackers  and #self.underAttackers > 0 ) then
 			-- print(" BAForAnimationTrigerAction:start:",1)
 			self.demageMaps = {}
 			-- 如果没有动画 那么我们立即触发伤害
 			if(self.animationName == nil) then
 				-- print(" BAForAnimationTrigerAction:start:",2,self.delayStart)
 				
 				if(self.delayStart ~= nil and self.delayStart > 0) then

 					self.total = self.delayStart
 					self.demageMaps[1] = {self.delayStart,self.underAttackers}
		 			self:addToRender()
 				else
 					-- print(" BAForAnimationTrigerAction:start:",3)
 					self.demageMaps[1] = {0,self.underAttackers}
	 				self:excuteAll()
	 				self:complete()

 				end
 			else	
 				
 					-- 如果没有延迟参数或者不合法参数,我们将延迟定义为0
		 			 if(self.eachDelay == nil or self.eachDelay < 0) then
		 			 	self.eachDelay = 0
		 			 end

		 			 -- 获取动画触发关键帧时间
		 			 local keyFrames = db_BattleEffectAnimation_util.getAnimationKeyFrameArray(self.animationName)
		 			 local totalFrames = db_BattleEffectAnimation_util.getAnimationTotalFrame(self.animationName)
		 			 local keyFrame = 0
		 			 if(keyFrames == nil or tonumber(keyFrames[1]) < 1) then
		 			 		keyFrame = totalFrames/2
		 			 else
		 			 		keyFrame =  tonumber(keyFrames[1])
		 			 end

		 			 self.count = 0
		 			
		 			 -- 如果是同时触发
		 			-- if(self.eachDelay == nil or self.eachDelay == 0 ) then
		 				 self.total = BATTLE_CONST.FRAME_TIME * keyFrame + self.delayStart
		 				 self.demageMaps[1] = {self.total,self.underAttackers}
		 			-- -- 如果多个逐次触发
		 			-- else
		 			-- 	local underNum = #self.underAttackers
		 			-- 	self.total = BATTLE_CONST.FRAME_TIME * keyFrame + BATTLE_CONST.FRAME_TIME * self.eachDelay * (underNum - 1)
		 			-- 	for i=1,underNum + 1 do
		 			-- 		local time  = self.delayStart + BATTLE_CONST.FRAME_TIME*(keyFrame + (i - 1) * self.eachDelay)
		 			-- 		 self.demageMaps[i] = {time,{self.underAttackers[i]}}
		 			-- 	end
		 			-- end
		 			-- print(" BAForAnimationTrigerAction:start:",4, self.total)
		 			self:addToRender()
 			end
 			
 		else

 			self:complete()
 		end
 	end

 	function BAForAnimationTrigerAction:excuteAll( ... )
 		if(#self.demageMaps > 0) then
				local newDamages = {}
				-- 遍历伤害列表
				for i=1,#self.demageMaps do
					local info = self.demageMaps[i]
					-- 遍历伤害列表触发伤害
					for k,underAttacker in pairs(info[2] or {}) do
							local data 	 = BattleMainData.getTargetData(underAttacker.defender)
							if(data) then
								data:pushDamageInfo(underAttacker.hp,underAttacker,1,1)
							end
					end
				end
				self.demageMaps = {}
		end
 	end

	function BAForAnimationTrigerAction:update(dt)

		-- print(" BAForAnimationTrigerAction:update ",self.count,self.total)
		if(self.disposed ~= true) then
			-- 更细 triger
			self.count = self.count + dt				
			if(#self.demageMaps > 0) then
				local newDamages = {}
				-- 遍历伤害列表
				for i=1,#self.demageMaps do
					local info = self.demageMaps[i]
					-- 如果到达时间临界值
					if(self.count >= info[1]) then
						-- 遍历伤害列表触发伤害
						for k,underAttacker in pairs(info[2] or {}) do
								local data 	 = BattleMainData.getTargetData(underAttacker.defender)
								if(data) then
									data:pushDamageInfo(underAttacker.hp,underAttacker,1,1)
								end
						end
					-- 如果这个元素没有被触发 那么我们将其加入新表,然后用新表替换原来的数据表,这个操作是为了应对删除操作
					else
						table.insert(newDamages,info)
					end
				end
				self.demageMaps = newDamages
			end

			if(self.count >= self.total) then
				self:removeFromRender()
				self:complete()
			end
		else
			-- error("BAForAttackAnimationTrigger:update disposed")
			self:release()
		end

	end



 	function BAForAnimationTrigerAction:onActionsComplete(data)
 		-- Logger.debug("BAForAnimationTrigerAction:complete : ")
 			
		self:complete()
	end
	
 return BAForAnimationTrigerAction