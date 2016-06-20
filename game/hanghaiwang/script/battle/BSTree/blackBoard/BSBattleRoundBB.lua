

-- buff删除
require (BATTLE_CLASS_NAME.class)
local BSBattleRoundBB = class("BSBattleRoundBB",require(BATTLE_CLASS_NAME.BSBlackBoard))
  
 	------------------ properties ----------------------
 	BSBattleRoundBB.roundData 					= nil
 	BSBattleRoundBB.allBuffs					= nil -- 所有buff(攻击者和被攻击者)
 	BSBattleRoundBB.attackerbuffinfo			= nil -- 被攻击者buff
 	BSBattleRoundBB.allBeAttackers 				= nil -- 所有被攻击者
 	BSBattleRoundBB.hasSubSkills 				= nil -- 是否有子技能
 	BSBattleRoundBB.startTimeValue 				= BATTLE_CONST.BT_START
 	BSBattleRoundBB.endTimeValue 				= BATTLE_CONST.BT_END
 	BSBattleRoundBB.middleTimeValue 			= BATTLE_CONST.BT_MIDDLE 
 	BSBattleRoundBB.subSkillsList 				= nil -- 子技能表
 	BSBattleRoundBB.attackerUI					= nil
 	BSBattleRoundBB.attacker 					= nil
 	BSBattleRoundBB.attackerZOderTo				= 1000 -- 攻击者释放技能时z值
	BSBattleRoundBB.attackerZOderFrom 			= nil  -- 攻击者原始z值
	BSBattleRoundBB.totalDamage					= nil
	BSBattleRoundBB.isMulityAttack 				= nil -- 是否是多段伤害
 	BSBattleRoundBB.des 						= "BSBattleRoundBB"
 	BSBattleRoundBB.isRageSkill 				= nil -- 是否是怒气技能
 	BSBattleRoundBB.skillEffectTargets 			= nil -- 技能相关人物
 	BSBattleRoundBB.skillUnEffectTargets 		= nil -- 技能未影响目标
 	BSBattleRoundBB.smallRoundDelay				= 0.1   -- 小回合结束delay
 	BSBattleRoundBB.isBenchPlayerShow			= nil -- 替补队员是否上场
 	BSBattleRoundBB.benchsInfo					= nil -- 替补信息 
 	BSBattleRoundBB.isAnimationRageMask 		= nil -- 是否有特定技能遮罩
 	BSBattleRoundBB.rageMaskName 				= nil -- 指定怒气遮罩动画名称
 	BSBattleRoundBB.node 						= nil
 	BSBattleRoundBB.nextRoundSkillEffectPlayers = nil
 	BSBattleRoundBB.hasSkillEffect 				= nil
 	BSBattleRoundBB.needStun 					= nil
 	BSBattleRoundBB.stunTime 					= 0.4
 	-- BSBattleRoundBB.roundStartDelay 			= nil 

 	-- BSBattleRoundBB.isBeatBackSkill				= nil -- 是否是反击技能
 	-- BSBattleRoundBB.BeatTextName 				= BATTLE_CONST.FIGHT_BACK_IMG_TEXT

 	BSBattleRoundBB.canPreStart 				= nil -- 是否可以提前开始执行下一回合
 	BSBattleRoundBB.preStartDelay 				= nil -- 人物回合开始延迟

 	BSBattleRoundBB.EVT_EXCUTE_SKILL 			= nil -- 当前技能事件触发名(每个技能的名字不一样)
 	
 	------------------ functions -----------------------
 	function BSBattleRoundBB:reset( roundData ,delay)
 		self.allBuffs 			= roundData.allBuffs
 		self.roundData 			= roundData
 		self.allBeAttackers 	= roundData.underAttackers
 		self.hasSubSkills		= roundData.arrChildSkills ~= nil
 		self.subSkillsList 		= roundData.arrChildSkills
 		self.attackerbuffinfo 	= roundData.attackerbuffinfo
 		self.preStartDelay 		= delay
 		-- 读取是否可以提前执行指令
 		self.canPreStart    	= roundData.canPreStart
 		-- print("=== BSBattleRoundBB:canPreStart",self.canPreStart, BattleMainData.fightRecord.index,self.roundData.attacker)

 		-- --print("BSBattleRoundBB has sub skill:",self.hasSubSkills,self.subSkillsList)
 		-- --print("BSBattleRoundBB attacker:",self.roundData.attacker)
 		self.attacker 			= BattleMainData.fightRecord:getTargetData(self.roundData.attacker)
		assert(self.attacker,"未发现攻击英雄:" .. tostring(self.roundData.attacker))
		if(self.attacker.displayData ~= nil) then
			self.attackerUI 		= self.attacker.displayData
			self.attackerZOderFrom 	= self.attackerUI.data.positionIndex
		else
			print("--- BSBattleRoundBB: attackerUI is nil:",self.roundData.attacker,"hp:",self.attacker.currHp,self.attacker.maxHp)
		end
		
		self.totalDamage 		= math.abs(self.roundData.skillDamage) -- 因为总伤害无符号,所以取绝对值


		self.EVT_EXCUTE_SKILL 					= roundData:getRoundMark()

		-- 是否是反击技能
		self.isBeatBackSkill    = self.attacker:isBeatBackSkill(self.roundData.skill)

		-- 是多段攻击或者是多目标攻击时 显示总伤害
		self.isMulityAttack 	= db_BattleEffectAnimation_util.isSkillMulityAttack(roundData.skill) or roundData:hasMulityTargets()
 
		-- Logger.debug("skill:" .. roundData.skill .. " isMulityAttack:" .. tostring(self.isMulityAttack) )

		self.isRageSkill 						= db_skill_util.isSkillRageSkill(self.roundData.skill)

		-- 获取 指定怒气遮罩(动画)
		self.isAnimationRageMask 				= db_skill_util.isAnimationRageMask(self.roundData.skill)
		self.rageMaskName 						= db_skill_util.getSkillRageMaskName(self.roundData.skill)

		local effectName 						= db_skill_util.getSkillAttackEffectName(self.roundData.skill) --"meffect_14"
		local totalFrame 						= 0
		self.hasSkillEffect 					= effectName == nil or effectName == ""

		-- print("== effectName:",effectName) 
		self.needStun = false
		local hasBuff = self.roundData ~= nil and self.roundData:isPlayerHasBuff(self.roundData.attacker)
		-- 如果有buff那么就不需要补偿,如果受击目标有多个则不需要补偿
		if(hasBuff  ~= true and roundData:hasMulityTargets() ~= true) then
			if(effectName ~= nil) then
				totalFrame = db_BattleEffectAnimation_util.getAnimationTotalFrame(effectName)
				if(totalFrame > 0 and totalFrame <= 25) then
					self.needStun = true
					self.stunTime = math.max(0.5,  1 - totalFrame * BATTLE_CONST.FRAME_TIME)
				end
			else

				self.needStun = true
				self.stunTime = 0.6
			end
		end
		-- print("=== rount info:",self.roundData.skill,self.attacker:isBeatBackSkill(self.roundData.skill))
		-- print("=== rount info test:", self.attacker:isBeatBackSkill(2), self.attacker:isBeatBackSkill(3))
		if(self.attacker and self.attacker:isBeatBackSkill(self.roundData.skill)) then
			self.needStun = false
			self.stunTime = 0
		end
		-- 如果后一个人攻击多个人
		if(roundData:hasMulityTargets() == true) then
			self.needStun = false
			self.stunTime = 0
		end
		-- print("== effectName hero:",self.attackerUI.data.heroImgURL) 
		-- print("== effectName:",effectName,self.needStun,db_skill_util.getSkillActionName(tonumber(self.roundData.skill)),hasBuff) 
 		-- self.needStun = false
		-- self.rageMaskName  						= "meffect_58_02"
		-- if(self.rageMaskName ~= nil) then
		-- 	self.hasRageMask = true
		-- else
		-- 	self.hasRageMask = false
		-- end
		-- print("====== rageMaskInfo:",self.isRageSkill,self.rageMaskName,self.isAnimationRageMask)
		
		--如果是怒气技能,我们需要将所有技能涉及人员收集起来
		if(self.isRageSkill) then
			local postionRecord = {}
			self.skillEffectTargets = {}
			local hidList = self.roundData:getSkillEffectTargets()
			for hid,v in pairs(hidList or {}) do
				 local target = BattleMainData.fightRecord:getTargetData(hid)
				 assert(target,"未发现目标:".. hid .. " errorid=10002")
				 assert(target.displayData,"未发现目标显示数据:".. hid .. "errorid=10003")
				 table.insert(self.skillEffectTargets,target.displayData)
				 -- table.insert(postionRecord,target:getGlobalIndex())
				 postionRecord[target:getGlobalIndex()] = 1
			end
			-- 获取技能不相关人物
			local result = {}
			for i=0,11 do
				if(postionRecord[i] == nil) then
					table.insert(result,i)
				end		
			end
			if(#result > 0 ) then
				self.skillUnEffectTargets = BattleTeamDisplayModule.getPlayerDisplayByPositionList(result)
			else
				self.skillUnEffectTargets = {}
			end

		end
		self.benchsInfo	= roundData.benchList

		self.isBenchPlayerShow = false
		if(self.benchsInfo and #self.benchsInfo > 0) then
			print("-- #self.benchsInfo: ",#self.benchsInfo)
			self.isBenchPlayerShow = true
		else
			print("-- #self.benchsInfo is nil: ",self.benchsInfo)
		end
		-- getSkillEffectTargets
 	end -- function end

return BSBattleRoundBB