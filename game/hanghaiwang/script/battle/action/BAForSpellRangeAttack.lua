 --技能范围攻击特效类(在没有人得地方播放特效)
require (BATTLE_CLASS_NAME.class)
local BAForSpellRangeAttack = class("BAForSpellRangeAttack",require(BATTLE_CLASS_NAME.BaseAction))

 
	------------------ properties ----------------------
 
	------------------ functions -----------------------
	function BAForSpellRangeAttack:start(data)
		-- 检测是否是范围技能
		-- 获取范围索引
		-- 以技能基准放为目标,检索所有位置,在没有人的地方播放特效(特效名来源于技能)
		if(self.blackBoard) then 
			local skilltargetIndex = self.blackBoard.skillTargetPositionIndex
			-- getSkipByDefender
			local rangeInfo = db_skill_util.getSkipByDefender(self.blackBoard.skill,skilltargetIndex)
			if rangeInfo ~= nil then 
			 	----print("BAForSpellRangeAttack:start:",rangeInfo)
					local indexFunction
					local checkFunction 
					if self.blackBoard.underAttackIsEnemy == true then 
						indexFunction = BattleGridPostion.getEnemyPointByIndex
						checkFunction = BattleMainData.isTeam2PostionHasPerson
					else
						indexFunction = BattleGridPostion.getPlayerPointByIndex
						checkFunction = BattleMainData.isTeam1PostionHasPerson
					end
 					
 					local attackerUI = self.blackBoard.attackerUI
 					local postionFix 
 					if(attackerUI) then
 						
 						if(self.blackBoard.attackEffctPosition == BATTLE_CONST.POS_FEET) then
			           		postionFix = attackerUI:feetPoint()
			            elseif (self.blackBoard.attackEffctPosition == BATTLE_CONST.POS_HEAD)then
			            	postionFix = attackerUI:headPoint()		
			            elseif (self.blackBoard.attackEffctPosition == nil or 
			            	    self.blackBoard.attackEffctPosition == BATTLE_CONST.POS_MIDDLE)then
			            	postionFix = attackerUI:heartPoint()
			            end
 						-- Logger.debug("=== px:".. postionFix.x .. "," .. postionFix.y)
 					else
 						postionFix = CCP_ZERO
 					end
					for k,v in pairs(rangeInfo) do
						
							local result 							= checkFunction(v)
							if(result == false and v < 6) then 
								-- print("=== range index:",v)
								local postion  						= indexFunction(v)

								if(postion) then
																	  --require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
									local animation						= require(BATTLE_CLASS_NAME.BAForPlayEffectAtPostion).new()
					 				animation.animationName	 			= self.blackBoard.attackEffectName
					 				animation.postionX 					= postion.x + postionFix.x
					 				animation.postionY 					= postion.y + postionFix.y
					 				BattleActionRender.addAutoReleaseAction(animation)
					 			end
							end 	-- if end

		 				
					end -- for end
			end -- if end
		end -- if end
		self:complete()
	end -- function end

	-- function BAForSpellAttack:excuteDamage()
 
	-- end

return BAForSpellRangeAttack