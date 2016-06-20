
local BattleUnderAttackerData = class("BattleUnderAttackerData")
 

 -- 		defender : int 		
	-- 		reaction : int		//响应ID： 命中/闪避/格挡。。。
	-- 		fatal : bool		//是否触发暴击
	-- 		rage : int			
	-- 		arrDamage : array
	-- 		[
	-- 			{
	-- 				damageType : int
	-- 				damageValue : int
	-- 			}
	-- 		]
	-- 		enBuffer : array	
	-- 		deBuffer : array
	-- 		imBuffer : array
	-- 		buffer : array
 
 

	------------------ properties ----------------------
	BattleUnderAttackerData.id 		 = nil --防御者id(和defender一样)
	BattleUnderAttackerData.defender = nil --防御者id
	BattleUnderAttackerData.reaction = nil --响应id 命中/闪避/格挡
	BattleUnderAttackerData.fatal 	 = false
	BattleUnderAttackerData.rage	 = nil
	BattleUnderAttackerData.hp 		 = nil
	BattleUnderAttackerData.buffer 	 = nil -- buff信息
	BattleUnderAttackerData.hasDamage = nil
	BattleUnderAttackerData.skill 	 = nil -- 受击技能
	------------------ functions -----------------------
	function BattleUnderAttackerData:reset( data , skill )
		self.skill 				= skill
		self.id 				= tonumber(data.defender)
		self.defender			= tonumber(data.defender)
		self.reaction			= tonumber(data.reaction)--BATTLE_CONST.REACTION_BLOCK--tonumber(data.reaction)
		-- self.reaction			= BATTLE_CONST.REACTION_DODGE--BATTLE_CONST.REACTION_BLOCK--tonumber(data.reaction)
		-- self.reaction			= BATTLE_CONST.REACTION_BLOCK--BATTLE_CONST.REACTION_BLOCK--tonumber(data.reaction)
		-- self.reaction			= BATTLE_CONST.REACTION_DODGE--BATTLE_CONST.REACTION_BLOCK--tonumber(data.reaction)
		self.fatal				=  data.fatal --true--

		self.rage				= tonumber(data.rage or 0)
		self.hp 				= 0
		self.hasDamage 			= false
		
		if data.arrDamage ~= nil then
			self.hasDamage 		= true
			for i,v in pairs(data.arrDamage) do
			 self.hp = self.hp - v.damageValue -- 技能伤害是按负的
			end -- for end
		end -- if end
		-- --print("total damage:",self.hp)
		-- --print("BattleUnderAttackerData rage:",data.rage)
		-- buff信息
		self.buffer 			= require(BATTLE_CLASS_NAME.BattleBuffsInfo).new()
		self.buffer:reset(data,self.id)
		self.buffer.hasSkillDamage = self:skillHpDamage() ~= 0
		-- print("--- BattleUnderAttackerData skillHpDamage:",self:skillHpDamage(),self:skillHpDamage() ~= 0)
		-- self.hp 				= self.hp --+ self.buffer.totalHpDamge
		-- self.rage 				= self.rage --+ self.buffer.totalRageDamage
	end	-- function end

	function BattleUnderAttackerData:totalHpDamage( ... )
		-- if(self.buffer.totalHpDamge ~= 0) then
		-- 	Logger.debug("id:".. self.id .. " bufferDamage:" .. self.buffer.totalHpDamge)
		-- end
		return self.hp + self.buffer.totalHpDamge
	end
	function BattleUnderAttackerData:skillHpDamage( ... )
		return self.hp 
	end

	function BattleUnderAttackerData:bufferHpDamage( ... )
		 return self.buffer.totalHpDamge
	end

	function BattleUnderAttackerData:totalRageDamage( ... )
		return self.rage + self.buffer.totalRageDamage
	end

	-- function BattleUnderAttackerData:totalHPChange()
	-- 	return self.hp + self.buffer.totalHpDamge
	-- end

	-- function BattleUnderAttackerData:totalRageChange( ... )
	-- 	return self.rage + self.buffer.totalRageDamage
	-- end

	function BattleUnderAttackerData:isDodge( ... )
		return self.reaction == BATTLE_CONST.REACTION_DODGE
	end
	-- 是否是格挡
	function BattleUnderAttackerData:isBlock( ... )
		return self.reaction == BATTLE_CONST.REACTION_BLOCK
	end
	-- 获取响应xml动画名字(如果是nil 则代表什么都不做)
	function BattleUnderAttackerData:reactionXMLAnimationName()
		-- 如果没有伤害
		-- if(self.hp == 0) then 
		-- 	return nil
		-- end
		if(self.reaction == BATTLE_CONST.REACTION_NONE) then
			return nil
		elseif(	self.reaction == BATTLE_CONST.REACTION_HIT or 
			self.reaction == BATTLE_CONST.REACTION_REHIT) then			 -- 命中(反击算作里面)
			-- 
			-- --print("BattleUnderAttackerData::reactionXMLAnimationName hp:",self.hp)
			if(self.hp < 0) then -- 如果是受伤 
				-- return "tuqi"
				local actionName = db_skill_util.getUnderAttackAction(self.skill)
				-- print("=== xmlAction",self.skill,actionName)
				return actionName
				-- return "zab"
				-- return BATTLE_CONST.REACTION_ANIMATION_HURT
			
			else 				 -- 如果是加血
				return "A009"
			end
			
		elseif(self.reaction == BATTLE_CONST.REACTION_DODGE) then	 -- 闪躲
			return BATTLE_CONST.REACTION_ANIMATION_DODGE
		elseif(self.reaction == BATTLE_CONST.REACTION_BLOCK) then 	 -- 格挡
			return BATTLE_CONST.REACTION_ANIMATION_BLOCK
		else
			error("BattleUnderAttackerData:error reaction value ",self.reaction)
		end
		return nil
	end

	 
	-- 获取响应文字动画特效名字(nil代表没有)
	function BattleUnderAttackerData:reactionLabelEffectName( )
 
		
		if(self.reaction == BATTLE_CONST.REACTION_DODGE) then	 -- 闪躲
		 	return BATTLE_CONST.DODGE_IMG_TEXT
		elseif(self.reaction == BATTLE_CONST.REACTION_BLOCK) then 	 -- 格挡
			return BATTLE_CONST.BLOCK_IMG_TEXT
		 
		elseif(self.fatal == true) then
			return BATTLE_CONST.CRITICAL_IMG_TEXT
		end
		 
		return nil
	end

	-- 获取响应动画特效名字(nil代表没有,目前只有block有特效)
	function BattleUnderAttackerData:reactionAnimationEffectName( )
		if(self.reaction == BATTLE_CONST.REACTION_BLOCK) then 	 -- 格挡
			return BATTLE_CONST.REACTION_EFFECT_BLOCK
		end
		return nil
	end


	-- function BattleUnderAttackerData:combin( data )
	-- 	if data.defender == self.defender then
		
	-- 	end -- if end
	-- end
	
return BattleUnderAttackerData