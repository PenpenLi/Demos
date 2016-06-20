--  穿刺攻击
local BAForPierceAttack = class("BAForPierceAttack",require(BATTLE_CLASS_NAME.BaseAction))
 
	------------------ properties ----------------------
	

	------------------ functions -----------------------
	function BAForPierceAttack:start( ... )
		-- 从攻击者当前位置出发 到对方屏幕外侧

		-- 生成按时间释放伤害类
		self.damageGenerater 						= require(BATTLE_CLASS_NAME.BattleDamageGeneraterWithTime).new()
		-- self.blackBoard.attackEffectName = "bullet_9"
		if (self.blackBoard.distancePathName ~= nil ) then
			
			-- 获取攻击者
			local  attacker = self.blackBoard.attacker

			-- 获取开始点和结束点
	 		local startPostion = BattleGridPostion.getSelfCenterScreenPostion()
	 		-- local startPostion = attacker.displayData:globalCenterPoint()
	 		local endPostion
			if(attacker.teamId == BATTLE_CONST.TEAM1) then
				endPostion 	 = BattleGridPostion.getArmyTeamOutScreenPostion() 
			else
				endPostion	 = BattleGridPostion.getSelfTeamOutScreenPostion()
			end
	 		-- 计算弹道飞行距离
			local len 		 = ObjectTool.length(startPostion,endPostion) * BattleMainData.scale
			-- 计算弹道飞行时间
			self.total 		 = len/(BATTLE_CONST.BULLET_SPEED * 2)

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

			self.moveAnimation						= require(BATTLE_CLASS_NAME.BAForPlayAndMoveAnimation).new()
			--local selfUI 					= self.blackBoard.attackerUI
			self.moveAnimation.xChange				= endPostion.x - startPostion.x
			self.moveAnimation.yChange				= endPostion.y - startPostion.y
			self.moveAnimation.animationName	 	= self.blackBoard.distancePathName
			self.moveAnimation.totalTime	 		= self.total
			self.moveAnimation.xStart				= startPostion.x
			self.moveAnimation.yStart				= startPostion.y
	 		self.moveAnimation.soundName 			= self.blackBoard.spellSound
			if(self.blackBoard.attackerIsPlayer == false) then 
				self.moveAnimation.rotation 		= self.blackBoard.rotation
			end
			self.moveAnimation:start()
			self.moveAnimation:addCallBacker(self,self.onActionComplete)
			self:addToRender()

			-- --震屏
			-- self.shake = require(BATTLE_CLASS_NAME.BAForShakeScreen).new()
			-- self.shake.total = self.total * 0.8
			-- self.shake:start()

		end -- if end
	end
	
	function BAForPierceAttack:onActionComplete( ... )
		 if(self.damageGenerater) then self.damageGenerater:excuteAll() end
		 --print("BAForPierceAttack:onActionComplete")
		 self:complete()
		 self:release()
	end

	function BAForPierceAttack:update( dt )
		self.damageGenerater:update(dt)
	end

	function BAForPierceAttack:release( ... )

		if(self.damageGenerater) then self.damageGenerater:release() end
		if(self.moveAnimation) then self.moveAnimation:release() end
		self.moveAnimation 		= nil
		self.blackBoard 		= nil
		self.damageGenerater 	= nil
		self.super.release(self)
	end

return BAForPierceAttack
