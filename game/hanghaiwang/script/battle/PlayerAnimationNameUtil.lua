
module("PlayerAnimationNameUtil",package.seeall)
 


		-- 获取指定htid人物的动作名称，封装的目的是为了防止动作类型增加随机或者改名等问题

		------------------ properties ----------------------
		--普工动作
		ANI_ATTACK		= "attack"
		-- 闪躲动作
		BattleStrongHoldDataANI_SHAN		= "shan"
		-- 受伤动作
		BattleStrongHoldDataANI_UNDERATT	= "underAttack"
		-- 怒气攻击动作
		BattleStrongHoldDataANI_RAGE_ATT	= "rageAttack"
		-- 怒气技能条
		BattleStrongHoldDataANI_RAGE_BAR	= "rageSkillBar"	
	
		-- 站立
		BattleStrongHoldDataANI_STAND		= "stand"

		--move
		BattleStrongHoldDataANI_MOVE		= "move"

		------------------ functions -----------------------
		--获取一般攻击动作
		function getSimpleAttackName(htid)
			return BattleStrongHoldDataANI_ATTACK
		end
		-- 获取闪躲动作
		function getShan(htid)
			
			return BattleStrongHoldDataANI_SHAN
		end
		-- 获取受伤动作
		function getUnderAttackName(htid)
			
			return BattleStrongHoldDataANI_UNDERATT
		end
		-- 获取怒气技能条
		function getRagSkillBar( htid )
			
			return BattleStrongHoldDataANI_RAGE_BAR
		end
		-- 获取怒气攻击动画名字
		function getRagAttackName(htid)
			return BattleStrongHoldDataANI_RAGE_ATT
		end

		--  
		function getStandName(htid)
			return BattleStrongHoldDataANI_STAND
		end

		-- 获取怒气攻击动画名字
		function getMoveName(htid)
			return BattleStrongHoldDataANI_MOVE
		end

