


require (BATTLE_CLASS_NAME.class)
local BSShipAttackBBData = class("BSShipAttackBBData",require(BATTLE_CLASS_NAME.BSBlackBoard))

		BSShipAttackBBData.shipid 				= nil 	-- 	船的id
		BSShipAttackBBData.skillid 				= nil 	-- 	技能id
		BSShipAttackBBData.gunAnimationName 	= nil 	-- 	炮的动画名称
		BSShipAttackBBData.teamid 				= nil
		BSShipAttackBBData.shipUI 				= nil
		BSShipAttackBBData.gunUI 				= nil
		BSShipAttackBBData.rotationTo 			= nil 	--  炮口旋转角度

		BSShipAttackBBData.targetsUI		 	= nil 	--  击中目标ui
		BSShipAttackBBData.targets		 	= nil 		--  击中目标object

		BSShipAttackBBData.isFireShipSkill 		= nil 	--  是射击类技能
		BSShipAttackBBData.fireActionName 		= nil 	--  射击动画名称
		BSShipAttackBBData.skillNameImg		 	= nil 	--  技能名图片

		BSShipAttackBBData.isAimEffAtCenter		= nil 	--  是否只有一个在中间
		BSShipAttackBBData.isAimEffOnEvery		= nil 	--  是否每个人都有
		
		BSShipAttackBBData.aimAnimationName 	= nil 	--  瞄准特效名称
		BSShipAttackBBData.shipHeight 			= nil
		BSShipAttackBBData.muzzleEffect 	= nil	-- 开炮挂接特效(例如炮管冒烟)
		-- BSShipAttackBBData.gunFireEffPosX 		= nil	-- 船炮挂接位置x
		-- BSShipAttackBBData.gunFireEffPosY 		= nil	-- 船炮挂接位置y
		BSShipAttackBBData.gunEffectLinkPosX 	= nil	-- 船炮挂点X
		BSShipAttackBBData.gunEffectLinkPosY 	= nil	-- 船炮挂点Y
		BSShipAttackBBData.isRotationAimStyle 	= nil  	-- 是否是旋转瞄准(只有在弹道射击类型下起作用)

		BSShipAttackBBData.aimCenterX 	= nil	--  X
		BSShipAttackBBData.aimCenterY 	= nil	--  Y

		BSShipAttackBBData.attackAnimation = nil
		BSShipAttackBBData.EVT_EXCUTE_SKILL = nil

		BSShipAttackBBData.skillNamePosX = nil -- 技能名图片x轴位置
		BSShipAttackBBData.skillNamePosY = nil -- 同上y轴位置
		
		BSShipAttackBBData.isFireBulletSkill = nil -- 是否发射弹道
		BSShipAttackBBData.isAaccumulateSkill = nil -- 是否是蓄力
		BSShipAttackBBData.enterSceneSound = nil -- 入场音效
		BSShipAttackBBData.shipInfoSound = nil -- 主船面板声音

		BSShipAttackBBData.isShowShipInfo 	= nil -- 是否显示主船信息
		BSShipAttackBBData.isShowFightUp 	= nil -- 是否显示队伍战斗力上升动画
		BSShipAttackBBData.shipInfoKeyTime 	= nil -- 主船信息显示的关键帧

		function BSShipAttackBBData:reset( data )
			self.roundData = data
			

			-- 策划说的延迟(显示战斗力上升的延迟)
			self.shipInfoKeyTime = 24 * BATTLE_CONST.FRAME_TIME

			self.EVT_EXCUTE_SKILL = self.roundData:getRoundMark()

			self.skill = data.skill
			-- 获取主船技能
			local shipSkillid = db_ship_skill_util.getShipSkillIDFromSkill(self.skill)
			assert(shipSkillid,"未发现主船映射技能:" .. tostring(self.skill))
			-- print(" BSShipAttackBBData.skill:",self.skill)
			-- print(" BSShipAttackBBData.shipSkill:",shipSkillid)
			-- 获取炮口旋转音效
			self.rotationSound = db_ship_skill_util.getRotationSound(shipSkillid)
			self.rotationSound = "aim1"
			-- 获取挂接特效音效
			self.muzzleEffectSound = db_ship_skill_util.getMuzzleEffectSound(shipSkillid)
			-- 获取主船入场音效 
			self.enterSceneSound = db_battleConfig_util.getShipEnterSceneSound()
				print(" BSShipAttackBBData.enterSceneSound:",self.enterSceneSound)
			-- 获取主船信息显示ui动画音效
			self.shipInfoSound = db_battleConfig_util.getShipInfoSound()

			if(data) then
				self.shipid = data.attacker
				self.skillid = data.action
				local shipData = BattleMainData.fightRecord
				self.shipUI = BattleShipDisplayModule.getShipByID(data.attacker)
			end
			 
			self.isFireBulletSkill = db_ship_skill_util.isFireBullet(shipSkillid)
			-- print("---- BSShipAttackBBData:",data.skill,shipSkillid,self.isFireBulletSkill,db_ship_skill_util.getShipBulletName(shipSkillid))
			-- self.isAaccumulateSkill = false
			-- 
			self.isMoveInStyle = true
			self.isShowSkillName = true
			self.isRotationAimStyle = true

			local start,endPo,factor
			local skillTargetIndex = 0


			self.isAaccumulateSkill = db_ship_skill_util.isAaccumulateSkill(shipSkillid)

			-- 如果是蓄力
			if(self.isAaccumulateSkill) then
				self.attackAnimation = nil
				-- todo 获取蓄力特效
				self.aaccumulateEff = db_ship_skill_util.getAaccumulateEff(shipSkillid)
				-- self.aaccumulateEff = "seffect4"
				local totalFrame = db_BattleEffectAnimation_util.getAnimationTotalFrame(self.aaccumulateEff)
				self.aaccumulateEffTime = BATTLE_CONST.FRAME_TIME * totalFrame

				self.isFireBulletSkill = false
				self.isRotationAimStyle = false


			end

			-- 计算炮弹和旋转角度
			if(self.isFireBulletSkill == true) then
					

					if(self.roundData.underAttackers ~= nil and #self.roundData.underAttackers > 0) then
						local pos = {}
						for k,info in pairs(self.roundData.underAttackers or {}) do
							info.isShipSkill 					= true
							local id  							= info.defender
				 			local target 						= BattleMainData.getTargetData(id)
				 			local errorNum 						= 0
				 			if target ~= nil then
				 				if(target and target.displayData) then
				 					local gpos = target.displayData:globalCenterPoint()
				 					if(gpos) then
				 						table.insert(pos,gpos)
				 					else
				 						errorNum = errorNum + 1
				 					end
				 				else
				 					errorNum = errorNum + 1
				 				end
				 			end 

				 			if(errorNum == 0) then
				 				endPo = ObjectTool.getCentreOfGravityOfPoints(pos)
				 			else
				 				-- 如果出现错误,我们选择屏幕中心为选择点
				 				endPo = BattleGridPostion.getCenterScreenPostion()
				 			end
						end
					-- 如果没有攻击对象,我们选择屏幕中心为选择点
					else
						endPo = BattleGridPostion.getCenterScreenPostion()
					end

						-- 这里有潜规则,技能为0时 为buff技能,也就是没有技能信息
					if(self.roundData.defender ~= 0 and self.roundData.defender ~= nil) then
						self.skillTarget 						= BattleMainData.fightRecord:getTargetData(self.roundData.defender)
						skillTargetIndex 						= self.skillTarget.positionIndex
						assert(self.skillTarget,"未发现目标英雄:",self.roundData.defender)
					else
						self.skillTarget 						= 4
					end


					start = ccp(self.shipUI:getPositionX(),self.shipUI:getPositionY())
					local extRotation = 0
					if(self.shipUI and self.shipUI.teamid == BATTLE_CONST.TEAM1) then
						--BattleGridPostion.getPlayerPointByIndex(4)
		              	-- endPo = BattleGridPostion.getEnemyPointByIndex(skillTargetIndex)
		              	factor = 1
		              	extRotation = 0
					else
						-- start = BattleGridPostion.getEnemyPointByIndex(4)
		              	-- endPo = BattleGridPostion.getPlayerPointByIndex(skillTargetIndex)
		              	factor = -1
		              	extRotation = 180
					end
		            -- local ro = 
		            -- print("BSShipAttackBBData rotationTo info :",start.x,start.y,endPo.x,endPo.y,factor)
					self.rotationTo 	= ObjectTool.getRotation(start.x,start.y,endPo.x,endPo.y,factor)
					self.muzzleEffectRotation = self.rotationTo + extRotation
					-- print(" ==BSShipAttackBBData: ",self.rotationTo,endPo.x,endPo.y,start.x,start.y,factor)
					-- print("BSShipAttackBBData rotationTo:",self.rotationTo,skillTargetIndex)
			else
				self.rotationTo = 0
			end
			-- if(self.rotationTo > 180) then
			-- 	self.rotationTo = self.rotationTo - 180
			-- end
			
			-- 炮口动画
			self.gunAnimationName = "cannon1"
			-- self.attackAnimation = "cannon1_action1"
			-- 开炮动画
			self.fireActionName = db_ship_skill_util.getShipFireSkillActionName(shipSkillid) --"cannon1_action1"
			self.attackAnimation = db_ship_skill_util.getShipFireSkillActionName(shipSkillid) --"cannon1_action1"
			


			

			-- 瞄准镜显示模式
			self.isAimEffAtCenter = db_ship_skill_util.isAimEffShowAtCenter(shipSkillid)
			self.isAimEffOnEvery = db_ship_skill_util.isAimEffShowAtEveryOne(shipSkillid)
			
			-- 获取技能名图片
			
			self.skillNameImg =  db_ship_skill_util.getShipSkillNameImg(shipSkillid)
			local positon = BattleGridPostion.getCenterScreenPostion()
			-- 获取技能名图片位置
			self.skillNamePosX = positon.x
			self.skillNamePosY = positon.y

			-- 炮口挂接特效
			self.muzzleEffect = db_ship_skill_util.getEffectAtMuzzle(shipSkillid) --"cannon_fire1"
			
			-- 获取瞄准镜特效
			self.aimAnimationName 	= db_ship_skill_util.getAimEffectName(shipSkillid)

			-- print("BSShipAttackBBData:",self.fireActionName,self.skillNameImg,self.muzzleEffect,self.aimAnimationName)
			self.targets = data.underAttackers
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
			
			if(self.shipUI) then

				local linkPos = self.shipUI:getGunLinkEffPos()
				self.gunUI = self.shipUI.shipGun

				local p
				if(self.shipUI.teamid == BATTLE_CONST.TEAM1) then
					p = BattleGridPostion.getArmyTeamCenterPostion()
				
				else
					p = BattleGridPostion.getSelfTeamCenterPostion()
				end
				self.aimCenterX = p.x
				self.aimCenterY = p.y
				self.teamid = self.shipUI.teamid

				-- 播放过一次后就不用播了
				if(self.teamid == BATTLE_CONST.TEAM1) then
					self.isShowShipInfo = not BattleMainData.isTeam1ShowedShipInfo
					self.isShowFightUp = not BattleMainData.isTeam1ShowedShipInfo
					BattleMainData.isTeam1ShowedShipInfo = true
				else
					self.isShowShipInfo = not BattleMainData.isTeam2ShowedShipInfo
					self.isShowFightUp = not BattleMainData.isTeam2ShowedShipInfo
					BattleMainData.isTeam2ShowedShipInfo = true
				end
			end
		end

return BSShipAttackBBData