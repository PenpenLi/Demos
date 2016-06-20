
--技能系统用的数据 输入table.roundData 为所需要的数据
-- 技能特效攻击方式:meffectType(1:每个人都有,2:只有1个, 默认值1)
-- 释放技能移动方式:mpostionType(1:近身释放,2:原地释放,3:固定地点,4:原地弹道,5:固定点弹道,7:撞击)
-- 攻击特效挂点?attackEffctPosition(默认值是2)
-- 技能是否怒气技能:functionWay(2怒气技能)
-- 攻击动作id: actionid
-- 被攻击者身上的魔法特效名:attackEffct,
-- 攻击者身上的魔法特效名:skillEffect
-- 空白处是否播放:skipAble -> "1,1,1,1,1,1,1,1,1,1,0,0,0,0,0"

-- 施法地点 mpostionType 1近身释放/2原地释放/3中点释放
-- 弹道皮肤路径  distancePath
-- 技能释放动作ID actionid
-- 技能释放特效  skillEffect
-- 技能打击特效挂点 attackEffctPosition
-- 技能击中效果特效路径  hitEffct
-- 空格可否播放特效 skipAble
-- 释放类型 1普通释放/2弹道/3冲撞/4特效穿透/5敌方身后释放
-- 前台技能效果类型  1.每个伤害都有魔法效果/2.只有一个魔法效果（多个人受伤）
-- 魔法效果是否震屏 isShake
-- 蓄力特效 rageFireEffect
-- 蓄力特效挂点 rageFireEffectPosition
-- 技能ID	技能原型ID	技能模板名称	技能显示名称	技能图标	施法地点	弹道皮肤路径	技能释放动作ID	技能释放特效	是否全屏特效	技能打击效果特效路径	技能打击特效挂点	打击音效	技能击中效果特效路径	击中音效	目标是否播放受伤动作	空格可否播放特效	是否固定地点播放	特效显示顺序	前台技能效果类型	技能显示类型	技能描述	释放方式	技能类型	技能耗魔	范围ID	是否增加怒气	施法者怒气获得基础值	施法者怒气获得修正值	施法者怒气获得倍率	被打者怒气获得基础值	被打者怒气获得修正值	被打者怒气获得倍率	是否跳过命中判定	是否跳过致命判定	是否跳过格挡判定	是否跳过伤害过程	输出通道	属性输出通道	物理基础攻击修正值	物理攻击百分比修正值	物理攻击伤害倍率	魔法基础攻击修正值	魔法攻击百分比修正值	魔法攻击伤害倍率	技能最终伤害值加成	技能修正致命一击率	技能修正命中率	多段伤害系数	次数限制	技能发动权重	状态包ID X	复合技能IDX	释放概率	是否享受怒气加成	技能目标范围图片	怒气技能类型	技能提示	击中效果提示
-- id		modelName	name	icon				mpostionType	distancePath	actionid	skillEffect	fullScreen	attackEffct	attackEffctPosition	spell_effect	hitEffct	hit_effect	showDamageAction	skipAble	isFix	effectOder	meffectType	mattackNumberType	des	functionWay	class	magicCost	range																									skillWeight		isComplexSkill			skillRangeImg	Ragetype	skillTip	hitTipEffect
require (BATTLE_CLASS_NAME.class)
local BSSkillSystemBBData = class("BSSkillSystemBBData",require(BATTLE_CLASS_NAME.BSBlackBoard))
-- roundData:BattlePlayerRoundData
	BSSkillSystemBBData.skill 						= nil -- 技能id
	BSSkillSystemBBData.attacker 					= nil -- 攻击者
	BSSkillSystemBBData.attackerUI 					= nil -- 攻击者UI
	BSSkillSystemBBData.roundData 					= nil -- 回合数据

	BSSkillSystemBBData.isRageSkill 				= nil -- 是否是怒气技能
	BSSkillSystemBBData.isRemoteSkill 				= nil -- 是否是远程技能
	BSSkillSystemBBData.isOneEffect 				= nil -- 是否是1个魔法特效
	BSSkillSystemBBData.isEffectOnSelf				= nil -- 魔法特效是否在自己身上
	BSSkillSystemBBData.isImpactSill				= nil -- 是否是撞击技能
	BSSkillSystemBBData.isNormalSkill				= nil -- 是否是一般技能
	BSSkillSystemBBData.isPierceSkill				= nil -- 是否是穿刺技能
	BSSkillSystemBBData.isBuffSkill					= nil -- 是否是buff技能(只有buff伤害,没有技能信息)
	BSSkillSystemBBData.isBackRemoteSkill 			= nil -- 背部穿刺
	BSSkillSystemBBData.needMove 					= nil -- 是否需要移动
	BSSkillSystemBBData.xMoveDistance				= nil -- x移动增量
	BSSkillSystemBBData.yMoveDistance 				= nil -- y移动增量
	BSSkillSystemBBData.underAttackIsEnemy 		 	= nil -- 被攻击者是否是敌人
	BSSkillSystemBBData.attackEffectName 			= nil -- 魔法特效名字
	BSSkillSystemBBData.attackEffectKeyFrame 		= nil -- 魔法特效关键帧
	BSSkillSystemBBData.skillTarget 				= nil -- 技能基准对象
	BSSkillSystemBBData.skillTargetPositionIndex 	= nil -- 技能基准对象阵型中的索引
	BSSkillSystemBBData.isAutoFlipAttEffect 		= true -- 是否需要翻转魔法特效

	BSSkillSystemBBData.underAttackers				= nil -- 技能攻击目标
	BSSkillSystemBBData.rotation					= 180 -- 旋转
	BSSkillSystemBBData.attackerIsPlayer			= nil -- 攻击者是否是玩家(eg:用于判断是否需要翻转特效,因为队伍2攻击队伍1的时候有的特效需要翻转)
	BSSkillSystemBBData.moveCostTime				= 0   -- 移动时间
	BSSkillSystemBBData.skillName 					= nil -- 技能名字
	BSSkillSystemBBData.attackEffctPosition 		= nil -- 魔法特效挂点
	BSSkillSystemBBData.hasRageSkillBar 			= nil -- 是否有怒气动画
	BSSkillSystemBBData.middleTimeValue 			= BATTLE_CONST.BT_MIDDLE
	BSSkillSystemBBData.keyFrameShake				= nil -- 关键帧是否震屏
	BSSkillSystemBBData.remoteNeedRotation			= true -- 弹道是否需要根据位置做旋转
	BSSkillSystemBBData.hideAttacker 				= false -- 播放魔法特效时是否隐藏攻击者
	BSSkillSystemBBData.attackerHideLevel 			= 0 -- 玩家攻击后隐藏等级
	BSSkillSystemBBData.remoteOverTarget			= false -- 远程弹道是否穿透
	BSSkillSystemBBData.particleName				= nil -- 弹道粒子名称
	BSSkillSystemBBData.rageSkillHeadImgURL			= nil -- 怒气头像中英雄头像地址
	BSSkillSystemBBData.rageBarMusic 				= nil -- 怒气技能头像声音
	BSSkillSystemBBData.spellSound					= nil -- 魔法音效
	BSSkillSystemBBData.hitSound 					= nil -- 击中音效
	BSSkillSystemBBData.moveSkillDelay				= 0.1 -- 技能移动后延迟
	BSSkillSystemBBData.targetType					= nil -- 你能目标类型(敌人,自己)
	BSSkillSystemBBData.attackEffectRotation		= nil -- 远程弹道时魔法特效旋转角度
	BSSkillSystemBBData.EVT_EXCUTE_SKILL 			= nil -- 当前技能事件触发名(每个技能的名字不一样)
	BSSkillSystemBBData.des  						= "BSSkillSystemBBData"

	BSSkillSystemBBData.rageFireEffect 				= nil -- 蓄力特效名称
	BSSkillSystemBBData.hasRageFire					= nil -- 是否有蓄力特效
	BSSkillSystemBBData.rageFirePosition 			= nil -- 蓄力特效挂点
	BSSkillSystemBBData.hasRagePingEffect 			= nil -- 是否有曝气特效
	BSSkillSystemBBData.BeatTextName 				= BATTLE_CONST.FIGHT_BACK_IMG_TEXT
	BSSkillSystemBBData.isBeatBackSkill				= nil -- 是否是反击技能
	BSSkillSystemBBData.isShowRageSkillName 		= nil -- 是否显示怒气技能名称图片
	BSSkillSystemBBData.isShowRageSkillNameLabel 	= nil -- 是否显无怒气头像技能名文本动画(怒气技能,无技能头像)
	function BSSkillSystemBBData:reset( data )
		self.roundData 							= data
		local roundData 						= data
		-- self.subSkillsList 						= data.arrChildSkills
		self.skill 								= roundData.skill--= roundData.skill 1020 --
		
		self.EVT_EXCUTE_SKILL 					= roundData:getRoundMark()
		-- print("---- create:",self.EVT_EXCUTE_SKILL)

		self.isRageSkill 						= db_skill_util.isSkillRageSkill(roundData.skill)
		self.isRemoteSkill 						= db_skill_util.isRemoteSkill(self.skill)
		self.isImpactSill 						= db_skill_util.isImpactSill(self.skill)
		self.isBackRemoteSkill					= db_skill_util.isBackRemoteSkill(self.skill)
		self.isPierceSkill						= db_skill_util.isPierceSkill(self.skill)
		self.skillName 							= db_skill_util.getSkillName(self.skill)
		self.attackEffctPosition 				= db_skill_util.geAttackEffectPostion(self.skill)
		self.targetType 						= db_skill_util.getSkillTargetType(self.skill)
		self.attackerbuffinfo 					= roundData.attackerbuffinfo
		self.isShowRageSkillName 				= db_skill_util.getIsShowRageSkillName(self.skill)
		self.isShowRageSkillNameLabel 			= db_skill_util.getIsShowSkillNameLabel(self.skill)
		-- self.isShowRageSkillName 				= false

		-- print("BSSkillSystemBBData:isShowRageSkillName",self.isShowRageSkillName)
		--print("是否是怒气技能:",self.isRageSkill)
		--print("是否是远程技能:",self.isRemoteSkill)
		--print("是否是撞击技能:",self.isImpactSill)
		--print("是否背部穿刺:",self.isBackRemoteSkill)
		--print("是否是穿刺技能:",self.isPierceSkill)
		
	

		if(
			self.isRemoteSkill ~= true and
		    self.isImpactSill ~= true  and 
		    self.isPierceSkill ~= true
		   ) then
		   	 self.isNormalSkill = true
		else
			 self.isNormalSkill = false
		end


		-- --print("BSSkillSystemBBData:",self.skill)
		if(self.isBackRemoteSkill == true) then
			self.isImpactSill					= false
			self.isRemoteSkill 					= false
			-- self.isRageSkill 					= false
			self.isNormalSkill 					= false
			self.isPierceSkill					= false
		end
		if(self.isPierceSkill == true) then
			self.isImpactSill					= false
			self.isRemoteSkill 					= false
			-- self.isRageSkill 					= false
			self.isNormalSkill 					= false
		 	self.isBackRemoteSkill 				= false
		end
		
		if(self.isPierceSkill 	== false and 
			self.isImpactSill	== false and
			self.isRemoteSkill 	== false and
		 	self.isBackRemoteSkill == false) then
			self.isNormalSkill  = true
		end

		-- self.isNormalSkill 						=  (self.isRemoteSkill 			== false or
		-- 											self.isImpactSill			== false or
		-- 											self.isBackRemoteSkill		== false) or true
		-- 获取怒气头像声音
		self.rageBarMusic 						= db_skill_util.getRageBarMusic(self.skill)
		-- 获取魔法特效音效
		self.spellSound 						= db_skill_util.getSpellSound(self.skill)
		-- 获取击中特效音效
		self.hitSound 							= db_skill_util.getHitSound(self.skill)
		-- Logger.debug("skill:%s spellSound:%s hitSound:%s",tostring(self.skill),tostring(self.spellSound),tostring(self.hitSound))
		self.isOneEffect 						= db_skill_util.isOneAttackEffect(self.skill)
		-- self.isEffectOnSelf						= db_skill_util.isOneAttackOnAttacker(self.skill)
		self.isEffectOnSelf						= db_skill_util.isOneAttackOnAttacker(self.skill)
		-- self.isEffectOnSelf						= db_skill_util.getSkillTargetType(self.skill) == 1 and self.isOneEffect == true
		-- 魔法效果
		self.attackEffectName 					= db_skill_util.getSkillAttackEffectName(self.skill) --"meffect_14" 
		-- self.attackEffectName 					= "meffect_44" 
		self.isAutoFlipAttEffect 				= db_skill_util.isAutoFlipWhenOnSelf(self.skill)


		local attacker 							= BattleMainData.fightRecord:getTargetData(self.roundData.attacker)
		assert(attacker,"未发现攻击英雄:",self.roundData.attacker)


		

		if(self.isRemoteSkill) then
			-- self.attackEffectName  = "meffect_24"
			if(attacker and attacker.teamId == BATTLE_CONST.TEAM2) then
				self.attackEffectRotation = 180
			end
			
		end
		
		-- 如果有动画且有关键帧
		if(self.attackEffectName and 
		   db_BattleEffectAnimation_util.hasKeyFrame(self.attackEffectName) == true) then
			self.attackEffectKeyFrame 			= db_BattleEffectAnimation_util.getFirstKeyFrame(self.attackEffectName) * BATTLE_CONST.FRAME_TIME
		
		else
			self.attackEffectKeyFrame 			= 0
		end
		-- print("-- attackEffectKeyFrame:",self.attackEffectKeyFrame)
		-- 击中特效
		self.attackHitEffectName 				= db_skill_util.getHitEffectName(self.skill)
		-- 被攻击者
		self.underAttackers						= roundData.underAttackers
		-- 弹道
		self.distancePathName 					= db_skill_util.getDistancePathName(self.skill)
		-- 魔法特效关键帧是否震屏
		self.keyFrameShake 						= db_skill_util.isShake(self.skill)

		-- 释放技能时是否显示攻击对象
		self.hideAttacker 						= db_skill_util.isHideWhenAttackEffect(self.skill) --false --

		-- 攻击者隐藏等级(0全部显示,1不显示卡牌,2都不显示)
		self.attackerHideLevel 					= db_skill_util.getAttackerHideLevel(self.skill) --1 -- 

		--弹道穿透
		self.remoteOverTarget 					= db_skill_util.isRemoteOverTarget(self.skill) -- true -- 

		-- 远程弹道是否需要根据位置做旋转
		self.remoteNeedRotation 				= db_skill_util.isRemoteNeedRotate(self.skill) --true -- 

		-- 弹道粒子名称
		self.particleName 						= db_skill_util.getParticleName(self.skill)
		if(self.isRemoteSkill) then
			if(self.distancePathName == nil or self.distancePathName == "") then
				error("技能:"..self.skill.." 弹道皮肤为空!")
			else
				--print("弹道皮肤:",self.distancePathName)
			end
		end

		-- 蓄力
		self.rageFireEffect 					= db_skill_util.getRageFireEffect(tonumber(self.skill))


		-- 是否有蓄力
		self.hasRageFire 						= self.rageFireEffect ~= nil

		-- 蓄力特效挂点
		self.rageFirePosition 					= db_skill_util.getRageFirePosition(tonumber(self.skill))

		-- print("**&&^^ self.rageFireEffect",self.skill,self.hasRageFire,self.rageFireEffect,self.rageFirePosition)

		-- 策划需求,有蓄力不播曝气
		if(self.hasRageFire == true) then
			self.hasRagePingEffect = false
		else
			self.hasRagePingEffect = self.isRageSkill
		end

		self.attackAnimation           			= db_skill_util.getSkillActionName(tonumber(self.skill)) --BATTLE_CONST.ANIMATION_ATTACK

		self:setMoveData()
		-- 如果是技能0,或者技能1
		if(self.skill == 0 or self.skill == 1) then
			self.attackAnimation = nil
			self.needMove = false
		end
		-- self.isRemoteSkill = true
		-- self.isNormalSkill = false
		-- self.distancePathName  = "bullet_9"									
		-- --print("attackAnimation: ",self.attackAnimation)
		-- --print("isRemoteSkill:",self.isRemoteSkill," getDistancePathName:",self.distancePathName)
	end


	function BSSkillSystemBBData:setMoveData()
		local mpostionType 	= db_skill_util.getMoveType(self.skill)
		 
		-- debug
		-- self.isImpactSill  = true
		-- self.isRemoteSkill = false 

		-- 如果是撞击 则需要近身,这里强制转位近身战斗
		-- if(self.isImpactSill) then
		-- 	mpostionType = 1
		-- 	if(self.attackAnimation ~= "A007") then
		-- 		self.attackAnimation = "A007"
		-- 	end
		-- end
		self.needMove 		= false
		local xMoveDistance = 0
		local yMoveDistance = 0
		local attacker 							= BattleMainData.fightRecord:getTargetData(self.roundData.attacker)
		assert(attacker,"未发现攻击英雄:",self.roundData.attacker)
		-- 这里有潜规则,技能为0时 为buff技能,也就是没有技能信息
		if(self.roundData.defender ~= 0 and self.roundData.defender ~= nil) then
			self.skillTarget 						= BattleMainData.fightRecord:getTargetData(self.roundData.defender)
			assert(self.skillTarget,"未发现目标英雄:",self.roundData.defender)
		else
			self.isBuffSkill = true
			self.skillTarget 						= attacker
		end


		self.hasRageSkillBar = false
		-- self.isRageSkill = true
		-- 是否是怒气技能
		if(self.isRageSkill) then
			-- 技能名图片 是否存在
			self.skillIconURL			= db_skill_util.getSkillIcon(self.skill) or ""
			
			if(self.skillIconURL ~= "" and self.skillIconURL ~= nil) then
				self.skillIconURL   		= BattleURLManager.getRageHeadURL(self.skillIconURL)
			end

			

			-- 如果怒气头像不存在或者为空,则应默认空白图像
			Logger.debug("skill attacker:" .. attacker.id .. "   htid:" .. tostring(attacker.htid))
			if(BattleDataUtil.isHero(attacker.id) == true) then
				self.rageSkillHeadImgURL 	= db_heroes_util.getRageHeadImage(attacker.htid) or ""
			else
				self.rageSkillHeadImgURL 	= db_monsters_util.getRageHeadIconName(attacker.htid) or ""
			end



			-- self.rageSkillHeadImgURL 			= "nuqi_suolong.png"
			self.rageSkillHeadImgURL   	= BattleURLManager.getRageHeadURL(self.rageSkillHeadImgURL)

			if(
				self.rageSkillHeadImgURL == nil or 
				self.rageSkillHeadImgURL == "" or 
				file_exists(self.rageSkillHeadImgURL)~= true
			  ) then
				self.rageSkillHeadImgURL = BattleURLManager.getRageHeadURL(BATTLE_CONST.BITMAP_BLANK)
			end


			

			-- 如果资源不存在,或者不是攻击者队伍(team1) 则不显示怒气技能
			-- 这里的资源是指 技能名图片,策划说:有的人物怒气技能没有头像,所以我们判断是否有怒气技能条需要通过技能名字图片资源来判断
			if(self.skillIconURL == "" or file_exists(self.skillIconURL)~= true or  not attacker:isAttackerTeam()) then
				self.hasRageSkillBar 	= false
			else
				if(self.isShowRageSkillName == false) then
					self.skillIconURL = BattleURLManager.BATTLE_BLANK_ICON
				-- else
				end
				self.hasRageSkillBar 	= true
			 
			end
			-- self.hasRageSkillBar = true
			-- Logger.debug("skill:".. tostring(self.skill))
			-- Logger.debug("hasRageSkillBar:".. tostring(self.hasRageSkillBar))
			-- Logger.debug("rageBarHead:".. tostring(self.rageSkillHeadImgURL))
			-- Logger.debug("rageBarIcon:".. tostring(self.skillIconURL))
			-- self.rageSkillHeadImgURL = "images/battle/rage_head/nuqi_beibo.png"
 		-- 	self.skillIconURL = "images/battle/rage_head/ji_aisi.png"
			
		end



		
		
		--print("attacker:",self.roundData.attacker," defender:",self.roundData.defender)
		self.skillTargetPositionIndex 			= self.skillTarget.positionIndex


		if(self.skillTarget.teamId == BATTLE_CONST.TEAM2) then
			self.underAttackIsEnemy 			= true
		else
			self.underAttackIsEnemy 			= false
		end
		-- --print("1")
		-- 旋转角度
		-- self.isEffectOnSelf and
		if( attacker.teamId == BATTLE_CONST.TEAM2) then
			self.rotation = 180
		else
			self.rotation = nil
		end
		-- --print("2")
		
		if(attacker.teamId == BATTLE_CONST.TEAM2) then
			self.attackerIsPlayer = false
		else
			self.attackerIsPlayer = true
		end
		-- --print("3:",self.attackHitEffectName)

	
		-- 击中效果
		local url 				
		if(self.attackHitEffectName) then
			url = BattleURLManager.BATTLE_EFFECT..self.attackHitEffectName .. ".ExportJson"
		end
 
 

		-- self.needMove 		= true
		self.attacker 		= attacker
		self.attackerUI 	= attacker.displayData
		self.targetUI		= attacker.displayData
		self.haveBattleData = true
		-- mpostionType 		= 4
		

		-- 是否是反击技能
		self.isBeatBackSkill    = self.attacker:isBeatBackSkill(self.roundData.skill)
		
		-- mpostionType = 1
		-- --print("6")
				--近身释放
				if(mpostionType==1) then 		--近身释放

						if self.skillTarget.teamId == BATTLE_CONST.TEAM1 then
								toPostion 							= BattleGridPostion.getSelfCloseAttackPostion(self.skillTarget.positionIndex)
								
						else
								toPostion 							= BattleGridPostion.getEnemyCloseAttackPostion(self.skillTarget.positionIndex)
								-- self.underAttackIsEnemy 			= true
						end
					assert(toPostion,"line 284" .. self.skillTarget.positionIndex)
					self.needMove 				= true
				--原地释放
				elseif(mpostionType==2) then 	--原地释放
					self.needMove 				= false
				-- 中点释放
				elseif(mpostionType==3) then 	-- 中点释放
					self.needMove 				= true
					toPostion 				= ccp(CCDirector:sharedDirector():getWinSize().width/2,
												  CCDirector:sharedDirector():getWinSize().height/2)
				elseif(mpostionType == 4) then -- 近敌行中点
					self.needMove 				= true
					toPostion 					= BattleGridPostion.getCloseLineCenter(self.skillTarget.teamId,self.skillTarget.positionIndex) 
				
				elseif(mpostionType == 5) then -- 近身远敌点
					self.needMove 				= true
					if self.skillTarget.teamId == BATTLE_CONST.TEAM1 then
							toPostion 		= BattleGridPostion.getSelfFarAttackPostion(self.skillTarget.positionIndex)
					else
							toPostion 		= BattleGridPostion.getEnemyFarAttackPostion(self.skillTarget.positionIndex)
					end

					
				else
					self.needMove 				= false
					mpostionType 				= 2
				end

				-- elseif(mpostionType==4) then 	-- 
				-- 	self.needMove 				= false
				-- elseif(mpostionType==5) then 	--固定点弹道
				-- 	self.needMove 				= true
				-- 	toPostion 				= ccp(CCDirector:sharedDirector():getWinSize().width/2,
				-- 								  CCDirector:sharedDirector():getWinSize().height/2)

				-- elseif(mpostionType==7) then 	--撞击
				-- 	self.needMove 				= true
				-- else 							--全屏
				-- 	self.needMove 				= false
				-- end-- if end
-- --print("7")
		-- 如果是撞击技能		
		if(self.isImpactSill == true) then

			if(self.skillTarget) then
				toPostion 			= self.skillTarget.displayData:getImpactPoint()
				assert(toPostion,"line 314")
				self.xMoveDistance 	= toPostion.x - attacker.displayData.rawPositon.x
				self.yMoveDistance	= toPostion.y - attacker.displayData.rawPositon.y
				
				self.moveCostTime 		= BATTLE_CONST.IMPACT_TO_COST_TIME
				self.attackEffectName 	= BATTLE_CONST.IMPACT_ACTION_NAME
			else
				error("撞击技能无技能目标:",self.skill)
			end

		-- 如果不是
		else
			self.moveCostTime 		= BATTLE_CONST.MOVE_TO_COST_TIME
			if(self.needMove) then
				--print(" attacker.rawPostion:", attacker.displayData.rawPositon.x, attacker.displayData.rawPositon.y)
				--print(" attacker position :", attacker.displayData:getPositionX(), attacker.displayData:getPositionY())
				--print(" toPostion:", toPostion.x , toPostion.y)
				 -- local nameLabel = CCLabelTTF:create(tostring(1),g_sFontName,30)
		   --      nameLabel:setAnchorPoint(CCP_HALF)
		   --      nameLabel:setPosition(toPostion.x,toPostion.y)
		   --      BattleLayerManager.battleAnimationLayer:addChild(nameLabel)

				self.xMoveDistance 	= toPostion.x - attacker.displayData.rawPositon.x
				self.yMoveDistance	= toPostion.y - attacker.displayData.rawPositon.y
			else
				self.xMoveDistance 	= 0
				self.yMoveDistance	= 0
			end
		end

		local dis	= math.sqrt(self.xMoveDistance * self.xMoveDistance + self.yMoveDistance * self.yMoveDistance)
		self.moveCostTime = 0.01 + dis/2400

-- --print("8")
		-- 魔法效果
		-- local url

		-- if(self.attackEffectName) then
		--  	url								= BattleURLManager.BATTLE_EFFECT..self.attackEffectName .. ".ExportJson"
		-- end
		
		-- if(self.attackEffectName and self.attackEffectName ~= "" and url and file_exists( url ) ~= true) then
		-- 	local  url  							= BattleURLManager.getAttackEffectURL(self.attackEffectName)
		-- 	-- --print("BSSkillSystemBBData:setMoveData",self.attackEffectName)
		-- 	if(file_exists("images/battle/effect/".. self.attackEffectName .. ".plist"))then
		-- 	else
		-- 		if(attacker.teamId == BATTLE_CONST.TEAM2) then
		-- 			self.attackEffectName = self.attackEffectName .."_u"
		-- 		else
		-- 			self.attackEffectName = self.attackEffectName .."_d"
		-- 		end
		-- 	end
		-- end

-- --print("9")
		-- --print("BSSkillSystemBBData:setMoveData x,y,needMove:",self.xMoveDistance," ",self.yMoveDistance," ",self.needMove)
		
	end -- function end
	function BSSkillSystemBBData:getTargetPostion( battleObject )
		return self:getPostionByTeamIndexAndId(battleObject.positionIndex,battleObject.teamId)
	end
	function BSSkillSystemBBData:getPostionByTeamIndexAndId( index ,teamId)
		local toPostion 		

		if teamId == BATTLE_CONST.TEAM1 then
				toPostion 							= BattleGridPostion.getSelfCloseAttackPostion(index)
		else
				toPostion 							= BattleGridPostion.getEnemyCloseAttackPostion(index)
		end
		return toPostion
	end -- function end
		
return BSSkillSystemBBData