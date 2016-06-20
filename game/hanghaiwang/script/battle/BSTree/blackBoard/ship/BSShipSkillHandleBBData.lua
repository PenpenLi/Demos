
require (BATTLE_CLASS_NAME.class)
local BSShipSkillHandleBBData = class("BSShipSkillHandleBBData",require(BATTLE_CLASS_NAME.BSBlackBoard))

		BSShipSkillHandleBBData.isFireBullet = nil 			-- 	否是开炮型技能
		BSShipSkillHandleBBData.remoteNeedRotation = nil 	-- 	炮弹是否需要旋转
		BSShipSkillHandleBBData.distancePathName = nil 		--  炮弹名称
		BSShipSkillHandleBBData.remoteOverTarget = nil 		--  炮弹是否穿透
		BSShipSkillHandleBBData.spellSound = nil 			--  炮弹音效
		BSShipSkillHandleBBData.keyFrameShake = nil 		--  关键帧是否震屏
		BSShipSkillHandleBBData.attackerUI 	= nil 			--  旧技能用名,表示主船ui
		BSShipSkillHandleBBData.underAttackers 	= nil 		--  被攻击者
		BSShipSkillHandleBBData.EVT_EXCUTE_SKILL 			= nil
		BSShipSkillHandleBBData.explodeX 			= nil
		BSShipSkillHandleBBData.explodeY 			= nil

		BSShipSkillHandleBBData.skillNamePosX 			= nil
		BSShipSkillHandleBBData.skillNamePosY 			= nil
		BSShipSkillHandleBBData.skillNamePosY 			= nil
	

		BSShipSkillHandleBBData.skillEffectPosX 			= nil
		BSShipSkillHandleBBData.skillEffectPosY 			= nil

		BSShipSkillHandleBBData.isBulletSkill 			= nil -- 是否是射击类技能(发射炮弹直接出发出发伤害)
		BSShipSkillHandleBBData.skillEffectName 		= nil -- 技能特效
		BSShipSkillHandleBBData.hasBulletSkillEff 		= nil -- 是否有技能特效
		BSShipSkillHandleBBData.isAaccumulateSkill 		= nil -- 是否蓄力
		BSShipSkillHandleBBData.isEffOnEveryOne 		= nil -- skillEffect是否每个受伤对象都有
		BSShipSkillHandleBBData.isEffOnCenter 			= nil -- skillEffect是否居中播放
		BSShipSkillHandleBBData.gravityOfPoint 			= nil -- skillEffect是否居中播放

		function BSShipSkillHandleBBData:reset( roundData )

			if(roundData) then
				self.shipid = roundData.attacker
				self.skillid = roundData.action
				local shipData = BattleMainData.fightRecord
				self.shipUI = BattleShipDisplayModule.getShipByID(roundData.attacker)
			end

			local shipSkillid = db_ship_skill_util.getShipSkillIDFromSkill(roundData.skill)
			assert(shipSkillid,"未发现主船映射技能:" .. tostring(roundData.skill))

			-- self.isFireBullet = true
			self.isFireBullet = db_ship_skill_util.isFireBullet(shipSkillid)
			if(self.isFireBullet) then
				self.isBulletOnEvery = db_ship_skill_util.isBulletAtEveryOne(shipSkillid)
			end
			-- print(" BSShipSkillHandleBBData:reset",self.isFireBullet,self.isBulletOnEvery)

			self.remoteNeedRotation = false
			
			self.distancePathName = db_ship_skill_util.getShipBulletName(shipSkillid)

			-- print(" BSShipSkillHandleBBData:",shipSkillid,self.isFireBullet,self.distancePathName)

			self.remoteOverTarget = false
			
			self.keyFrameShake = true
			
			self.isNormalSkill = false
			-- self.attackerUI = BattleShipDisplayModule.getTeam1Ship()
			
			self.attackerUI = BattleShipDisplayModule.getShipByID(roundData.attacker)
			
			-- 被攻击者
			self.underAttackers						= roundData.underAttackers
			
			self.EVT_EXCUTE_SKILL 					= roundData:getRoundMark()

			if(roundData.isSubskill == true) then
				-- print(" 1BSShipSkillHandleBBData:",shipSkillid,self.isFireBullet,self.distancePathName)
				self.isFireBullet = false
				-- self.isNormalSkill = true
				self.attackAnimation = nil
				self.eachDelay = 0
				self.skillDelayStart = 0
			end
			-- self.hasBulletSkillEff = true

			local p
			if(self.attackerUI) then
				if(self.attackerUI.teamid == BATTLE_CONST.TEAM1) then
					p = BattleGridPostion.getArmyTeamCenterPostion()
				
				else
					p = BattleGridPostion.getSelfTeamCenterPostion()
				end
				self.explodeX = p.x
				self.explodeY = p.y
			end



			self.isAaccumulateSkill = db_ship_skill_util.isAaccumulateSkill(shipSkillid)
			self.hasBulletSkillEff = false

			self.isEffOnCenter = false

			

			self.skillEffectName = db_ship_skill_util.getShipSkillEffect(shipSkillid)
			-- print("==== BSShipSkillHandleBBData:",BSShipSkillHandleBBData)
			-- self.skillEffectName = "explosion5"
			if(self.skillEffectName ~= nil) then
				self.eachDelay = 1
			end
			
			local endPo = nil
			-- 计算单个特效出现位置,也就是受击者重心,这个也用来预估炮弹延迟
			local pos = {}
			local errorNum 						= 0
			for k,info in pairs(roundData.underAttackers or {}) do
				
				local id  							= info.defender
	 			local target 						= BattleMainData.getTargetData(id)
	 			
	 			if target ~= nil then
	 				if(target and target.displayData) then
	 					local gpos = target.displayData:globalCenterPoint()
	 					if(gpos) then
	 						table.insert(pos,gpos)
	 					else
	 						errorNum = errorNum + 1
	 						-- print("-- BSShipSkillHandleBBData22:",gpos)
	 					end
	 				else
	 					-- print("-- BSShipSkillHandleBBData11:")
	 					errorNum = errorNum + 1
	 				end
	 			end 
	 		end

	 		if(errorNum == 0) then
	 			-- print("-- BSShipSkillHandleBBData:",errorNum)
	 				endPo = ObjectTool.getCentreOfGravityOfPoints(pos)
	 		else
	 			-- print("-- BSShipSkillHandleBBData1:",errorNum)
	 				-- 如果出现错误,我们根据船的id来判断
	 				if(self.shipUI and self.shipUI.teamid == BATTLE_CONST.TEAM1) then
		              	endPo = BattleGridPostion.getArmyTeamCenterPostion()
					else
		              	endPo = BattleGridPostion.getSelfTeamCenterPostion()
					end

			end

			self.gravityOfPoint = endPo



			if(self.skillEffectName ~= nil ) then
					self.hasBulletSkillEff = true
					self.isEffOnEveryOne = db_ship_skill_util.isSkillEffectAtEveryOne(shipSkillid)
					self.isEffOnCenter   = db_ship_skill_util.isSkillEffectAtCenter(shipSkillid)
					self.skillEffectPosX = endPo.x
					self.skillEffectPosY = endPo.y
				end
			-- end
			-- 如果是弹道,我们需要计算弹道延迟
			if(self.isFireBullet) then
				local startPosition = self.attackerUI:globalCenterPoint()
				local endPostion = endPo

				local dx 		= endPostion.x - startPosition.x
				local dy 		= endPostion.y - startPosition.y
				local dis 		= math.sqrt(dx * dx + dy * dy)

				self.skillDelayStart = dis/BATTLE_CONST.SPELL_SPEED +0.1--math.ceil()-- *  BATTLE_CONST.FRAME_TIME
			else
				self.skillDelayStart = 0
			end

			self.targets = roundData.underAttackers
			self.targetsUI = {}
			-- 处理被攻击人物
			local c = 1
			for k,v in pairs(self.targets or {}) do
				-- print("-- add ui:",v.id,v.displayData)
				-- self.targetsUI[c] = v.displayData
				local playerData = BattleMainData.fightRecord:getTargetData(v.id)
				-- c = c + 1
				table.insert(self.targetsUI,playerData.displayData)
			end

			-- self.isAaccumulateSkill = true
			-- 如果是蓄力
			if(self.isAaccumulateSkill) then
				self.attackAnimation = nil
				-- todo 获取蓄力特效
				self.aaccumulateEff = db_ship_skill_util.getShipFireSkillActionName(shipSkillid)
				-- self.aaccumulateEff = "seffect4"
				local totalFrame = db_BattleEffectAnimation_util.getAnimationTotalFrame(self.aaccumulateEff)
				self.aaccumulateEffTime = BATTLE_CONST.FRAME_TIME * totalFrame
				self.hasBulletSkillEff = false
				self.isFireBullet = false
				self.eachDelay = 0
				self.skillDelayStart = 0
				self.skillEffectName = self.aaccumulateEff
			
				-- print(" 2BSShipSkillHandleBBData:",shipSkillid,self.isFireBullet,self.distancePathName)
				

				-- 蓄力特效不需要调整倾斜度,只需要根据队伍调整翻转角度即可
				self.aaccumulateEffRotation = 0
				if(self.shipUI and self.shipUI.teamid == BATTLE_CONST.TEAM1) then
			        self.aaccumulateEffRotation = 0
				else
	              	self.aaccumulateEffRotation = 180
				end


			end
			-- print(" 3BSShipSkillHandleBBData:",shipSkillid,self.isFireBullet,self.distancePathName)
				

		end

return BSShipSkillHandleBBData

