




-- 技能特效攻击 组合类 (包含:1个特效类,1个多帧触发,多个伤害类)
require (BATTLE_CLASS_NAME.class)
local BAForSpellAttack = class("BAForSpellAttack",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
 	--AForSpellAttack.spellAnimation 					= nil -- 动画实例 	BAForPlayEffectAtPostion
 	BAForSpellAttack.trigger 							= nil -- 多帧触发器	BAForKeyFramesAnimationTrigger
 	BAForSpellAttack.damageGenerater 					= nil -- 伤害生成		BAForDamageGenerater
	------------------ functions -----------------------
	function BAForSpellAttack:start(data)
	-- 根据技能 计算 特效位置 
 	-- 更具技能生成技能特效,多帧技能触发
 	-- 设置触发回调
 		-- --print("BAForSpellAttack skill:",self.blackBoard.skill)
 		-- --print("BAForSpellAttack:start->attackEffectName:",self.blackBoard.attackEffectName)
	 	if (self.blackBoard.attackEffectName ~= nil and self.blackBoard.attackEffectName ~= "") then
	 			-- --print("onSelf")
	 			local animation 
		 		-- -- 1个魔法特效 魔法特效在区域中心
		 		-- if (self.blackBoard.isOneEffect == true) then 				 
		 				
 				-- 魔法特效在自己身上
 			 	if(self.blackBoard.isEffectOnSelf == true) then
			 			 		-- --print("BAForSpellAttack:start 魔法特效在自己身上")
		 				animation						= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
		 				--local selfUI 					= self.blackBoard.attackerUI
						animation.heroUI				= self.blackBoard.attackerUI
						animation.animationName	 		= self.blackBoard.attackEffectName
						-- animation.atPostion 			= BATTLE_CONST.POS_MIDDLE
						animation.atPostion 			= self.blackBoard.attackEffctPosition
						animation.soundName 			= self.blackBoard.spellSound
						if(self.blackBoard.isAutoFlipAttEffect == true) then
							-- 敌方队伍才需要旋转
							if(self.blackBoard.attackerIsPlayer == false) then 
									--print("::::::::: attacker is army: rotation:",self.blackBoard.rotation)
									animation.rotation 				= self.blackBoard.rotation
									animation.atPostion 			= BATTLE_CONST.POS_MIDDLE
							end
						end
				 		BattleActionRender.addAutoReleaseAction(animation)
				-- 魔法伤害在攻击者区域
 			 	else

 			 			-- 1个魔法特效 魔法特效在区域中心
 						if (self.blackBoard.isOneEffect == true) then

 							animation						= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
			 				local postion 					

 							-- 如果是屏幕中央
 							if(self.blackBoard.targetType == 2) then		
 								postion						= BattleGridPostion.getCenterScreenPostion()
 							else
			 			 			-- --print("BAForSpellAttack:start 魔法特效在区域中心")
			 				
				 				if(self.blackBoard.underAttackIsEnemy == true) then 		-- 如果被攻击方是敌军
				 					postion						= BattleGridPostion.getEnemyPointByIndex(1)	-- 选取敌方中点释放位置
				 					postion.y 					= postion.y + 50
				 				else
				 					postion						= BattleGridPostion.getPlayerPointByIndex(4)	-- 选取玩家中点位置
				 					postion.y 					= postion.y
				 				end
				 			end

			 				animation.animationName	 		= self.blackBoard.attackEffectName
			 				animation.postionX 				= postion.x
			 				animation.postionY 				= postion.y
			 				animation.soundName 			= self.blackBoard.spellSound
			 				Logger.debug(" OneEffect postion:" .. postion.x .. ", " .. postion.y)
				 			--  animation.container				= BattleLayerManager.battleAnimationLayer -- 层级 
				 			-- end
				 			BattleActionRender.addAutoReleaseAction(animation)	
				 		else
				 				-- 每个人都是有特效
						 		-- --print("onArmy")
						 		-- --print("BAForSpellAttack:start 每个人都是有特效")
						 		local delay = nil
						 		for k,v in pairs(self.blackBoard.underAttackers or {}) do
						 			-- 获取该对象的显示数据
						 			local id  							= v.defender
						 			local target 						= BattleMainData.getTargetData(id)
						 			if target ~= nil then 
							 		 	animation						= require(BATTLE_CLASS_NAME.BAForPlayEffectAtHero).new()
							 		 	animation.heroUI				= target.displayData
										animation.animationName	 		= self.blackBoard.attackEffectName
										animation.atPostion 			= self.blackBoard.attackEffctPosition
										animation.soundName 			= self.blackBoard.spellSound
										
										if(delay ~= nil) then
											 -- animation.delay 				= math.floor(delay * 0.5)
											 animation.delay 				= math.floor(delay)
											 delay = delay + 2
										else
											  delay = 0 
										end
										
										-- --print("self.blackBoard.attackEffectName:",self.blackBoard.attackEffectName)
										BattleActionRender.addAutoReleaseAction(animation)	
									else
										--print("BAForSpellAttack start  error : can't find target:",id)
						 			end

						 		end -- for end
				 		end
 			 	end
  

		 	-- 因为目前所有伤害都是同步的,所以只用1个triger,但是要生成不同的特效
		 	-- 触发器
		 	self.trigger 									= require(BATTLE_CLASS_NAME.BAForKeyFramesAnimationTrigger).new()
		 	self.trigger.animationName 						= self.blackBoard.attackEffectName

		 	self.trigger.keyFrameCaller:addCallBacker(self,self.onKeyFrame)
		 	self.trigger.shakeFrameCaller:addCallBacker(self,self.onShakeKeyFrame)
		 	self.trigger.calllerBacker:addCallBacker(self,self.onTrigerComplete)
		 	local keyFrameNum = db_BattleEffectAnimation_util.getAnimationTotalKeyFrames(self.blackBoard.attackEffectName)
		 	-- keyFrameNum =1
		 	-- Logger.debug(self.blackBoard.attackEffectName .. " 攻击动画总关键帧:" .. keyFrameNum)
		  
		 	-- self:generateDamageInfo(db_BattleEffectAnimation_util.getAnimationTotalKeyFrames(self.blackBoard.attackEffectName))
		 	self:generateDamageInfo(keyFrameNum)

		 	-- self.timeMark = os.clock()
		 	self.trigger:start()
		 	-- fake
		 	-- --print("======== addBuff start:",self.timeMark)
		 	-- local addBuff = require(BATTLE_CLASS_NAME.BuffAddLogic).new()
		 	-- addBuff:start(95,self.blackBoard.roundData.attacker)
		-- 没有魔法效果

		else
			 --print("木有魔法效果")
			 self:generateDamageInfo(1)
			 self.damageGenerater:excute()
			 self:complete()
	 	end -- if end

	end -- function end
	function BAForSpellAttack:generateDamageInfo( totalKeyFrame )
		-- 遍历被伤害的人
			-- 生成伤害信息
			 self.damageGenerater 						= require(BATTLE_CLASS_NAME.BattleDamageGenerater).new() -- todo
			 for k,v in pairs(self.blackBoard.underAttackers or {}) do
				
				self.damageGenerater.blackBoard 			= self.blackBoard
				-- self.damageGenerater.animationName			= self.blackBoard.attackEffectName
				-- self.damageGenerater.hitEffectName 			= self.blackBoard.attackHitEffectName
				-- self.damageGenerater.hurtActionName 		= self.blackBoard.hurtActionName
				
				self.damageGenerater:pushData(v)
			 end
			 self.damageGenerater:init(totalKeyFrame)
	end

	function BAForSpellAttack:onShakeKeyFrame(target,shakeType)
		
		-- print("---- shake:",shakeType,self.blackBoard.keyFrameShake)
		if(self.blackBoard and self.blackBoard.keyFrameShake) then
				ObjectTool.playShakeWithStyle(shakeType)
 		end
	end

	function BAForSpellAttack:onKeyFrame(target,data)
		-- --print("BAForSpellAttack:onKeyFrame: cost",os.clock() - self.timeMark," from:",self.timeMark) 
 		-- if(self.blackBoard and self.blackBoard.keyFrameShake) then
			-- 	ObjectTool.playShakeScreen(BATTLE_CONST.KEY_FRAME_SHAKE_TIME)
 		-- end
		self.damageGenerater:excute()
	end
	function BAForSpellAttack:onTrigerComplete()
		

		-- --print("========= buffDamage : attacker:",self.blackBoard.roundData.attacker)
		-- local buffDamage = require(BATTLE_CLASS_NAME.BuffHurtLogic).new()
	 -- 	buffDamage:start(self.blackBoard.roundData.attacker)
	 	
	 	self.damageGenerater:excuteAll()
		-- Logger.debug("BAForSpellAttack complete")
		self:complete()
		
	end

	-- function BAForSpellAttack:excuteDamage()
 
	-- end

return BAForSpellAttack