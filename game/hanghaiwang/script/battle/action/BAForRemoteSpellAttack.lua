-- 远程攻击类  (包含:1个远程弹道,1个触发,多个伤害类)

require (BATTLE_CLASS_NAME.class)
local BAForRemoteSpellAttack = class("BAForRemoteSpellAttack",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
  	-- BAForRemoteSpellAttack.spellAnimation 					= nil -- 动画实例 BAForRemoteSpell
 	BAForRemoteSpellAttack.trigger 							= nil -- BAForRemoteSpellTrigger
 	BAForRemoteSpellAttack.damageGenerater 					= nil -- BAForDamageGenerater



	------------------ functions -----------------------
	function BAForRemoteSpellAttack:start(data)
	-- --print(" BAForSpellAttack:start:",self.blackBoard.distancePathName)
 	if (self.blackBoard.distancePathName ~= nil and self.blackBoard and self.blackBoard.underAttackers) then

 			local fromPostion 								= self.blackBoard.attackerUI:globalCenterPoint()
 			local counter 									= 0

 			local total 									= #self.blackBoard.underAttackers
 			local completeCount 							= 0
 			for k,v in pairs(self.blackBoard.underAttackers or {}) do
 						counter = counter  + 1
			 			-- 获取该对象的显示数据
			 			local id  							= v.defender
			 			local target 						= BattleMainData.getTargetData(id)
			 			if target ~= nil then 

							 -- 生成伤害数据
							local damageGenerater1 						= require(BATTLE_CLASS_NAME.BattleDamageGenerater).new() -- todo
							damageGenerater1.blackBoard 				= self.blackBoard
							damageGenerater1:pushData(v)
		 					damageGenerater1:init(1)

		 					-- 生成弹道动画
							local animation						= require(BATTLE_CLASS_NAME.BAForRemoteSpell).new()
							local id  						= v.defender
			 				local target 					= BattleMainData.getTargetData(id)
			 				local toPostion 				= target.displayData:globalCenterPoint()
				 		 	animation.startX				= fromPostion.x
				 		 	animation.startY				= fromPostion.y
				 		 	animation.endX 					= toPostion.x
				 		 	animation.endY 					= toPostion.y
				 		 	animation.needRotation 			= self.blackBoard.remoteNeedRotation
							animation.animationName	 		= self.blackBoard.distancePathName
							animation.overTarget 			= self.blackBoard.remoteOverTarget
							animation.particleName 			= self.blackBoard.particleName
							animation.soundName 			= self.blackBoard.spellSound
							-- 生成延迟 + 伤害触发 + 结束回调
							local line 							= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()

							local delayAction 					= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
							delayAction.total					= animation:getHitTime() 
							
							if(delayAction.total == 0 or delayAction.total == nil) then
								delayAction.total = 0.01
							end
							
							local runFunction 					= require(BATTLE_CLASS_NAME.BAForFunction).new()
							runFunction.caller					= function() --print("BAForSpellAttack damageGenerater:excute() ") 
																	damageGenerater1:excute("BAForSpellAttack")	 
																	if(self.blackBoard and self.blackBoard.keyFrameShake) then
																			ObjectTool.playShakeScreen(BATTLE_CONST.KEY_FRAME_SHAKE_TIME)
															 		end

																end

							local runComplete 					= require(BATTLE_CLASS_NAME.BAForFunction).new()
							runComplete.caller					= function() 
																   completeCount = completeCount + 1
																   --print("BAForSpellAttack damageGenerater:complete() total:",total,"completeCount:",completeCount)
																   if(total <= completeCount) then self:complete() end
																 end

							if(target ~= nil ) then

							end

							line:push(delayAction)
							line:push(runFunction)
							-- line:push(hit)
							
							line:push(runComplete)



							

							-- --print("self.blackBoard.distancePathName:",self.blackBoard.distancePathName)
							BattleActionRender.addAutoReleaseAction(animation)	

							BattleActionRender.addAutoReleaseAction(line)	
						else
							--print("BAForRemoteSpellAttack start  error : can't find target:",id)
			 			end

			 end -- for end

			 if(counter== 0) then self:complete() end
 	else
 		self:complete()
 	end
 	
 	-- 根据伤害数据生成 特效位置 (1个伤害对象 特效固定在人身上,如果有多个则以技能目标所在队伍的中心点)
 	-- 更具技能生成技能特效,多帧技能触发
 	-- 设置触发回调

	end -- function end

 

return BAForRemoteSpellAttack
