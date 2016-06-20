

require (BATTLE_CLASS_NAME.class)
local BSShipSkillRoundBBData = class("BSShipSkillRoundBBData",require(BATTLE_CLASS_NAME.BSBlackBoard))

			BSShipSkillRoundBBData.roundData 					= nil
		 	BSShipSkillRoundBBData.allBuffs						= nil -- 所有buff(攻击者和被攻击者)
		 	BSShipSkillRoundBBData.allBeAttackers 				= nil -- 所有被攻击者
		 	BSShipSkillRoundBBData.hasSubSkills 				= nil -- 是否有子技能
		 	BSShipSkillRoundBBData.startTimeValue 				= BATTLE_CONST.BT_START
		 	BSShipSkillRoundBBData.endTimeValue 				= BATTLE_CONST.BT_END
		 	BSShipSkillRoundBBData.middleTimeValue 				= BATTLE_CONST.BT_MIDDLE 
		 	BSShipSkillRoundBBData.subSkillsList 				= nil -- 子技能表
		 	BSShipSkillRoundBBData.shipUI 						= nil
		 	BSShipSkillRoundBBData.des 							= "BSShipSkillRoundBBData"
		 	BSShipSkillRoundBBData.smallRoundDelay				= 0.1   -- 小回合结束delay
		 	BSShipSkillRoundBBData.EVT_EXCUTE_SKILL 			= nil -- 当前技能事件触发名(每个技能的名字不一样)
		 	BSShipSkillRoundBBData.benchsInfo 					= nil -- 替补信息
		function BSShipSkillRoundBBData:reset( roundData )

			self.benchsInfo					= roundData.benchList
			self.allBuffs 					= roundData.allBuffs
			self.roundData 					= roundData
			-- self.roundData.isSubskill 		= true
			self.allBeAttackers 			= roundData.underAttackers
			self.hasSubSkills				= roundData.arrChildSkills ~= nil
			self.subSkillsList 				= roundData.arrChildSkills
			
			-- self.attackerUI = BattleShipDisplayModule.getTeam1Ship()
			self.shipUI 	= BattleShipDisplayModule.getShipByID(roundData.attacker)
			-- 被攻击者
			self.underAttackers						= roundData.underAttackers
			self.EVT_EXCUTE_SKILL 					= roundData:getRoundMark()
		end

return BSShipSkillRoundBBData


