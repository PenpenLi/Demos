
-- 远程攻击类  (包含:1个远程弹道,1个触发,多个伤害类)

require (BATTLE_CLASS_NAME.class)
local BAForShipRemoteSpellAttack = class("BAForShipRemoteSpellAttack",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
	BAForShipRemoteSpellAttack.distancePathName = nil -- 弹道名称
	BAForShipRemoteSpellAttack.underAttackers = nil -- 被攻击对象的伤害数据
	BAForShipRemoteSpellAttack.attackerUI = nil -- 发动攻击的船体
	BAForShipRemoteSpellAttack.isBulletAtEveryOne = nil -- 是否每个人都要有弹道
	BAForShipRemoteSpellAttack.toPosition = nil -- 
	------------------ functions -----------------------
	function BAForShipRemoteSpellAttack:start(data)
	print(" BAForShipRemoteSpellAttack:start:",self.blackBoard.distancePathName,self.isBulletAtEveryOne)

 	if (self.distancePathName ~= nil and self.underAttackers) then

 			local fromPostion 								= self.attackerUI:globalCenterPoint()
 			local counter 									= 0
 			local toPosition 				
 			local total 									= #self.underAttackers
 			local completeCount 							= 0
 			-- 如果每个伤害对象都有弹道
 			if(self.isBulletAtEveryOne) then
 				 			for k,v in pairs(self.underAttackers or {}) do
				 						counter = counter  + 1
							 			-- 获取该对象的显示数据
							 			local id  							= v.defender
							 			local target 						= BattleMainData.getTargetData(id)
							 			if target ~= nil then 

						 					-- 生成弹道动画
											local animation						= require(BATTLE_CLASS_NAME.BAForRemoteSpell).new()
											local id  						= v.defender
							 				local target 					= BattleMainData.getTargetData(id)
							 				toPosition 						= target.displayData:globalCenterPoint()
								 		 	animation.startX				= fromPostion.x
								 		 	animation.startY				= fromPostion.y
								 		 	animation.endX 					= toPosition.x
								 		 	animation.endY 					= toPosition.y
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
												delayAction.total = 0.1
											end
											
											local runFunction 					= require(BATTLE_CLASS_NAME.BAForFunction).new()
											runFunction.caller					= function() --print("BAForSpellAttack damageGenerater:excute() ") 
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
											--print("BAForShipRemoteSpellAttack start  error : can't find target:",id)
							 			end

							 end -- for end
			-- 只有一个有弹道
			else
				local fromPostion = self.attackerUI:globalCenterPoint()
				counter = counter  + 1
				-- 如果有预置炮弹落点
				if(self.toPosition ~= nil) then
					toPosition = self.toPosition
				else
					-- 如果没有 我们取受击者阵型中心点

					if(self.underAttackers and self.underAttackers[1] ~= nil) then
						local id  						= self.underAttackers[1].defender
						local target 					= BattleMainData.getTargetData(id)
					    if(target.teamId == BATTLE_CONST.TEAM1) then
							toPosition = BattleGridPostion.getSelfTeamCenterPostion()
						else
							toPosition = BattleGridPostion.getArmyTeamCenterPostion()
						end

					
					else
						if(self.attackerUI.teamid == BATTLE_CONST.TEAM1) then
							toPosition = BattleGridPostion.getArmyTeamCenterPostion()
						else
							toPosition = BattleGridPostion.getSelfTeamCenterPostion()
						end

					end

				end
				

				-- 生成弹道动画
				local animation						= require(BATTLE_CLASS_NAME.BAForRemoteSpell).new()
	 		 	animation.startX				= fromPostion.x
	 		 	animation.startY				= fromPostion.y
	 		 	animation.endX 					= toPosition.x
	 		 	animation.endY 					= toPosition.y
	 		 	animation.needRotation 			= self.blackBoard.remoteNeedRotation
				animation.animationName	 		= self.blackBoard.distancePathName
				animation.soundName 			= self.blackBoard.spellSound
				animation.overTarget 			= false
				-- 生成延迟 +   结束回调
				local line 							= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()

				local delayAction 					= require(BATTLE_CLASS_NAME.BAForDelayAction).new()
				delayAction.total					= animation:getHitTime() 
				
				if(delayAction.total == 0 or delayAction.total == nil) then
					delayAction.total = 0.1
				end
				
				local runFunction 					= require(BATTLE_CLASS_NAME.BAForFunction).new()
				runFunction.caller					= function() --print("BAForSpellAttack damageGenerater:excute() ") 
														if(self.blackBoard and self.blackBoard.keyFrameShake) then
																ObjectTool.playShakeScreen(BATTLE_CONST.KEY_FRAME_SHAKE_TIME)
												 		end

													end

				local runComplete 					= require(BATTLE_CLASS_NAME.BAForFunction).new()
				runComplete.caller					= function() 
													   -- completeCount = completeCount + 1
													   --print("BAForSpellAttack damageGenerater:complete() total:",total,"completeCount:",completeCount)
													   -- if(total <= completeCount) then self:complete() end
													   self:complete()
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

 			end


			 if(counter== 0) then self:complete() end
 	else
 		self:complete()
 	end
 	
 	-- 根据伤害数据生成 特效位置 (1个伤害对象 特效固定在人身上,如果有多个则以技能目标所在队伍的中心点)
 	-- 更具技能生成技能特效,多帧技能触发
 	-- 设置触发回调

	end -- function end

 

return BAForShipRemoteSpellAttack
