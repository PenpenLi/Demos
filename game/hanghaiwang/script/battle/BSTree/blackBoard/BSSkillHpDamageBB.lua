


--  技能伤害
require (BATTLE_CLASS_NAME.class)
local BSSkillHpDamageBB = class("BSSkillHpDamageBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
 

 		------------------ properties ----------------------
 		BSSkillHpDamageBB.hasHpDamage 					= false 	-- 有hp伤害
 		BSSkillHpDamageBB.hasXMLAnimation 				= false 	-- 有伤害xml动作
 		BSSkillHpDamageBB.hasReactionAnimation 			= false 	-- 有reaction动画(特效)
 		BSSkillHpDamageBB.hasReactionLabelAnimation		= false		-- 是否有 reaction 文字动画
 		
 		BSSkillHpDamageBB.value							= nil 		-- hp伤害改变值
 		BSSkillHpDamageBB.xmlAnimationName				= nil 		-- 伤害xml动画名称
 		BSSkillHpDamageBB.reactionEffectName			= nil 		-- reaction 特效名字
 		BSSkillHpDamageBB.reactionLabelAnimationName	= nil   	-- reaction 文字特效名字
 		BSSkillHpDamageBB.color 						= nil 		-- 文字颜色

 		BSSkillHpDamageBB.target						= nil 		-- 目标
 		BSSkillHpDamageBB.targetUI 						= nil 		-- 目标ui
 		BSSkillHpDamageBB.des							= "BSSkillHpDamageBB"

 		BSSkillHpDamageBB.willDie 						= nil		-- 是否会死亡
 		BSSkillHpDamageBB.willNearDeath					= nil 		-- 是否会濒死

 		BSSkillHpDamageBB.isLastMulityTime 				= nil 		-- 是否是否多段最后一个伤害
 		BSSkillHpDamageBB.isMulityTime 					= nil 		-- 是否是多段
 		BSSkillHpDamageBB.isFatal 						= nil 		-- 是否是暴击

 		BSSkillHpDamageBB.damageShowNumber 				= nil 		-- 伤害显示数字(策划有需求多段时伤害数值和显示数值不一样)
 		BSSkillHpDamageBB.showHitEffect 				= nil		-- 是否显示击中效果
 		BSSkillHpDamageBB.attackHitEffectName 			= nil		-- 击中特效名字
 		BSSkillHpDamageBB.showBlockReactionAnimation 	= false		-- 是否显示反击特效(2015.10.21 监修问题,陈帅要求不显示)
 		------------------ functions -----------------------
 		function BSSkillHpDamageBB:ctor( ... )
 			self.willDie 					= false
 			self.hasHpDamage				= false
 			self.hasXMLAnimation			= false
 			self.hasReactionAnimation 		= false
 			self.hasReactionLabelAnimation  = false
 			self.isLastMulityTime 			= false
 			self.isMulityTime 				= false
 			self.isFatal 					= false
 			self.willNearDeath 				= false
 			self.showHitEffect 				= false
 		end
 		
		function BSSkillHpDamageBB:resetFromSkill(damage,battleUnderAttackerData,damageShowNumber) -- BattleUnderAttackerData
				 -- 目标
				 self.target								= BattleMainData.fightRecord:getTargetData(battleUnderAttackerData.id)
				 self.targetUI								= self.target.displayData
				 self.value									= damage
				 self.skill 								= battleUnderAttackerData.skill
				 -- 击中特效
				 self.attackHitEffectName 					= db_skill_util.getHitEffectName(self.skill)

				 --如果伤害显示数字没有传入直接用伤害值
				 if(damageShowNumber == nil) then
				 	damageShowNumber = damage
				 end
				 self.damageShowNumber = damageShowNumber
				 -- self.value 								= 0
		 		 -- hp伤害	
				 if(damage== nil or damage == 0) then
						self.hasHpDamage					= false
						self.value 							= 0
				 else
				 		self.hasHpDamage					= true
				 		self.willNearDeath 					= self.target:willNearDeath(damage)	
				 		if(self.willNearDeath == true) then
				 			self.willDie 					= false
				 		else
				 			self.willDie						= self.target:willDie(damage)
				 		end	
				 end

				 -- 暴击
				 self.isFatal 								= battleUnderAttackerData.fatal
				 -- 颜色
				 self.color 								= BattleDataUtil.getHpNumberColor(damage,battleUnderAttackerData.fatal)
				 -- Logger.debug("--- damage:" .. damage .. ",color:" .. self.color)
				 -- 动作
				 local reactionXMLAni						= battleUnderAttackerData:reactionXMLAnimationName()
				 -- --print("+++++++++++++ reactionXMLAni:",reactionXMLAni)
				 if(reactionXMLAni ~= nil )then
				 		-- --print("BSSkillHpDamageBB has reactionAnimation:",reactionXMLAni)
				 		self.hasXMLAnimation				= true
				 		self.xmlAnimationName 				= reactionXMLAni
				 else
				 		self.hasXMLAnimation				= false
				 	   --print("+++++++++++++BSSkillHpDamageBB without reactionAnimation:",battleUnderAttackerData.reaction)
				 end
				 -- if(self.willDie) then self.hasXMLAnimation = false end
				 -- 文字动画(暴击,闪躲,格挡)
				 local labelAnimation						= battleUnderAttackerData:reactionLabelEffectName()
				 if(labelAnimation ~= nil )then
				 		self.hasReactionLabelAnimation		= true
				 		self.reactionLabelAnimationName 	= labelAnimation
				 		-- --print("reactionLabelAnimationName:",self.reactionLabelAnimationName)
				 else
				 		self.hasReactionLabelAnimation		= false
				 end	 

				 --  额外特效(格挡特效之类的)
				 local extraEff								= battleUnderAttackerData:reactionAnimationEffectName()
				 if(extraEff ~= nil )then
				 		self.hasReactionAnimation			= true
				 		self.reactionEffectName 			= extraEff
				 else
				 		self.hasReactionAnimation			= false
				 end	

				 -- 如果是格挡或者是闪躲则不需要显示击中
				 if(battleUnderAttackerData:isBlock() == true or battleUnderAttackerData:isDodge() == true) then
						self.showHitEffect = false
				 else
				 		self.showHitEffect = true
				 end
				 -- --暴击
				 -- if(battleUnderAttackerData.fatal) then
				 -- 	self.skillDamageTitle 					= BATTLE_CONST.BITMAP_CRITICAL
				 -- end
				 	 
		end
 
return BSSkillHpDamageBB