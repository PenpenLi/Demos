

-- 单个弹道从后往前
 
local BAForPierceAttackFromBack = class("BAForPierceAttackFromBack",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	

	BAForPierceAttackFromBack.damageGenerater 					= nil -- 伤害生成		BAForDamageGenerater
	BAForPierceAttackFromBack.blackBoard						= nil
	BAForPierceAttackFromBack.total 							= nil
	BAForPierceAttackFromBack.cost 								= nil
	BAForPierceAttackFromBack.moveAnimation 					= nil
	BAForPierceAttackFromBack.shake 							= nil
	------------------ functions -----------------------
	function BAForPierceAttackFromBack:start( ... )
		--print("BAForPierceAttackFromBack:start")
		-- self:generateDamageInfo(1)
		self.damageGenerater 						= require(BATTLE_CLASS_NAME.BattleDamageGeneraterWithTime).new()
		-- self.blackBoard.attackEffectName = "bullet_9"
		if (self.blackBoard.attackEffectName ~= nil ) then
			
			-- 获取 技能起始点 
			local  attacker = self.blackBoard.attacker
	 		local startPostion
	 		local endPostion
			if(attacker.teamId == BATTLE_CONST.TEAM1) then
				startPostion = BattleGridPostion.getArmyTeamOutScreenPostion()
				endPostion	 = BattleGridPostion.getArmyCenterScreenPostion()
			else
				startPostion = BattleGridPostion.getSelfTeamOutScreenPostion()
				endPostion	 = BattleGridPostion.getSelfCenterScreenPostion()
			end
	 	-- getSelfCenterScreenPostion
	 		-- 获取 技能终点(需要提供接口支持)
	 		 -- = BattleGridPostion.getCenterScreenPostion()
			-- 计算总时间(Y值)
			local len 		 = ObjectTool.length(startPostion,endPostion) * BattleMainData.scale

			self.total 		 = len/(BATTLE_CONST.BULLET_SPEED * 2)
			--print("BAForPierceAttackFromBack fly total:",self.total," len:",len)
			-- 遍历每个伤害对象,获取显示位置,计算时间
			for k,v in pairs(self.blackBoard.underAttackers or {}) do
				local id  							= v.defender
	 			local target 						= BattleMainData.getTargetData(id)
	 			if target ~= nil then 
	 				local postion = target.displayData:globalCenterPoint()
	 				local hitCost = ObjectTool.length(startPostion,postion)/BATTLE_CONST.BULLET_SPEED
	 				if(hitCost > self.total) then hitCost = self.total end
	 				self.damageGenerater:pushData(v,hitCost)
	 				--print("BAForPierceAttackFromBack hero ",id," cast:",hitCost)
	 			else
	 				error("can't find hero:",id)
			 	end		
			end -- for end

			-- 生成动画

			self.moveAnimation					= require(BATTLE_CLASS_NAME.BAForPlayAndMoveAnimation).new()
			--local selfUI 					= self.blackBoard.attackerUI
			self.moveAnimation.xChange				= endPostion.x - startPostion.x
			self.moveAnimation.yChange				= endPostion.y - startPostion.y
			self.moveAnimation.animationName	 	= self.blackBoard.attackEffectName
			self.moveAnimation.totalTime	 		= self.total
			self.moveAnimation.xStart				= startPostion.x
			self.moveAnimation.yStart				= startPostion.y
	 		self.moveAnimation.soundName 			= self.blackBoard.spellSound
			if(self.blackBoard.attackerIsPlayer == true) then 
				self.moveAnimation.rotation 		= self.blackBoard.rotation
			end
			self.moveAnimation:start()
			self.moveAnimation:addCallBacker(self,self.onActionComplete)
			self:addToRender()

			--震屏
			self.shake = require(BATTLE_CLASS_NAME.BAForShakeScreen).new()
			self.shake.total = self.total * 0.8
			self.shake:start()
			
		else
			--print("BAForPierceAttackFromBack can't find the attackEffectName -> complete")
			-- 没有魔法效果直接触发伤害
			 for k,v in pairs(self.blackBoard.underAttackers or {}) do
				
				self.damageGenerater:pushData(v,0)
			 end
			self.damageGenerater:excuteAll()
			self.damageGenerater:release()
			self:complete()
	 	end
		
	end
	function BAForPierceAttackFromBack:onActionComplete( ... )
		 if(self.damageGenerater) then self.damageGenerater:excuteAll() end
		 --print("BAForPierceAttackFromBack:onActionComplete")
		 self:complete()
		 self:release()
	end
	-- function BAForPierceAttackFromBack:generateDamageInfo( totalKeyFrame )
	-- 	-- 遍历被伤害的人
	-- 		-- 生成伤害信息
	-- 		 for k,v in pairs(self.blackBoard.underAttackers) do
				
	-- 			self.damageGenerater:pushData(v)
	-- 		 end
	-- 		 self.damageGenerater:init(totalKeyFrame)
	-- end

	function BAForPierceAttackFromBack:update( dt )
		self.damageGenerater:update(dt)

	end

	function BAForPierceAttackFromBack:release( ... )

		if(self.damageGenerater) then self.damageGenerater:release() end
		if(self.moveAnimation) then self.moveAnimation:release() end
		self.moveAnimation 		= nil
		self.blackBoard 		= nil
		self.damageGenerater 	= nil
		if(self.shake) then
			self.shake:release()
			self.shake 			= nil
		end
		self.super.release(self)
	end

return BAForPierceAttackFromBack