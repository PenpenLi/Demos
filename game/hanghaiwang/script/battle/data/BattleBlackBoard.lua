-- module("BattleBlackBoard",package.seeall)

-- function getBlackBorad( roundData )
-- 	local blackBoard  				= {}
-- 	blackBoard.skill 				= roundData.skill
-- 	local player 					= BattleMainData.strongholdADT
-- 	blackBoard.attackerUI = display
-- end



 

local BattleBlackBoard = class("BattleBlackBoard")
	-- roundData:BattlePlayerRoundData
	BattleBlackBoard.skill 						= nil -- 技能
	BattleBlackBoard.attackerUI 				= nil -- 攻击者UI
	BattleBlackBoard.roundData 					= nil -- 回合数据

	BattleBlackBoard.isRageSkill 				= nil -- 是否是怒气技能
	BattleBlackBoard.isRemoteSkill 				= nil -- 是否是远程技能
	BattleBlackBoard.isOneEffect 				= nil -- 是否是1个魔法特效
	BattleBlackBoard.isEffectOnSelf				= nil -- 魔法特效是否在自己身上

	BattleBlackBoard.needMove 					= nil -- 是否需要移动
	BattleBlackBoard.xMoveDistance				= nil -- x移动增量
	BattleBlackBoard.yMoveDistance 				= nil -- y移动增量

	BattleBlackBoard.underAttackIsEnemy 		= nil -- 被攻击者是否是敌人
	BattleBlackBoard.attackEffectName 			= nil -- 魔法特效名字
	BattleBlackBoard.skillTarget 				= nil -- 技能基准对象
	BattleBlackBoard.skillTargetPositionIndex 	= nil -- 技能基准对象阵型中的索引
	function BattleBlackBoard:reset( roundData )
		self.roundData 							= roundData
		self.skill 								= roundData.skill--= roundData.skill 1020 --
		self.isRageSkill 						= db_skill_util.isSkillRageSkill(roundData.skill)
		self.isRemoteSkill 						= db_skill_util.isRemoteSkill(self.skill)
		self.isOneEffect 						= db_skill_util.isOneAttackEffect(self.skill)
		self.isEffectOnSelf						= db_skill_util.isOneAttackOnAttacker(self.skill)
		self.attackEffectName 					= db_skill_util.getSkillAttackEffectName(self.skill)
		self.attackHitEffectName 				= db_skill_util.getHitEffectName(self.skill)
		self.underAttackers						= roundData.underAttackers
		self.distancePathName 					= db_skill_util.getDistancePathName(self.skill)
		self:setMoveData()
		--print("isRemoteSkill:",self.isRemoteSkill," getDistancePathName:",self.distancePathName)
	end


	function BattleBlackBoard:setMoveData()
		local mpostionType 	= db_skill_util.getMoveType(self.skill)
		local needMove 		= false
		local xMoveDistance = 0
		local yMoveDistance = 0

		local attacker 							= BattleMainData.fightRecord:getTargetData(self.roundData.attacker)
		self.skillTarget 						= BattleMainData.fightRecord:getTargetData(self.roundData.defender)
		--print("attacker:",self.roundData.attacker," defender:",self.roundData.defender)
		self.skillTargetPositionIndex 			= self.skillTarget.positionIndex
		
		if(self.skillTarget.teamId == BATTLE_CONST.TEAM2) then
			self.underAttackIsEnemy 			= true
		else
			self.underAttackIsEnemy 			= false
		end


		-- 魔法效果
		if(self.attackEffectName and self.attackEffectName ~= "") then
			local  url  							= BattleURLManager.getAttackEffectURL(self.attackEffectName)
			--print("BattleBlackBoard:setMoveData",self.attackEffectName)
			if(file_exists("images/battle/effect/".. self.attackEffectName .. ".plist"))then
			else
				if(attacker.teamId == BATTLE_CONST.TEAM2) then
					self.attackEffectName = self.attackEffectName .."_u"
				else
					self.attackEffectName = self.attackEffectName .."_d"
				end
			end
		end



		-- 击中效果
		if(file_exists("images/battle/effect/" .. self.attackHitEffectName .. ".plist")) then
                --damageEffectSprite = CCLayerSprite:layerSpriteWithName(CCString:create("images/battle/effect/" .. skillHitEffect), -1,CCString:create(""));
        else
                if(attacker.teamId == BATTLE_CONST.TEAM2) then
					self.attackHitEffectName = self.attackHitEffectName .."_u"
				else
					self.attackHitEffectName = self.attackHitEffectName .."_d"
				end
        end

         
   --      -- 击中动画
        
   --      if(mpostionType==7)then

   --      		if(attacker.teamId == BATTLE_CONST.TEAM2) then
			-- 		self.hurtActionName = "images/battle/xml/action/hurt2_u_0"
			-- 	else
			-- 		 self.hurtActionName  = "images/battle/xml/action/hurt2_d_0"
			-- 	end

   --              -- if( isDefenderEnemy) then
   --              --     strTemp = CCString:create("images/battle/xml/action/hurt2_u_0" )
   --              -- else
   --              --     strTemp = CCString:create("images/battle/xml/action/hurt2_d_0" )
   --              -- end
   --      else

   --          if(attacker.teamId == BATTLE_CONST.TEAM2) then
			-- 	self.hurtActionName  = "images/battle/xml/action/hurt1_u_0"
			-- else
			-- 	self.hurtActionName  = "images/battle/xml/action/hurt1_d_0"
			-- end
   --      end


		-- local toPostion 					
		--needMove 	= true.
		

		----print("BattleBlackBoard:setMoveData positionIndex:",skillTarget.positionIndex)


		-- self.needMove 		= true
		self.attackerUI 	= attacker.displayData
		self.haveBattleData = true
		-- mpostionType 		= 1
		
				if(mpostionType==1) then 		--近身释放

						if skillTarget.teamId == BATTLE_CONST.TEAM1 then
								toPostion 							= BattleGridPostion.getSelfCloseAttackPostion(skillTarget.positionIndex)
								
						else
								toPostion 							= BattleGridPostion.getEnemyCloseAttackPostion(skillTarget.positionIndex)
								-- self.underAttackIsEnemy 			= true
						end

				elseif(mpostionType==2) then 	--原地释放
					needMove 				= false
				elseif(mpostionType==3) then 	--固定地点
					needMove 				= true
					toPostion 				= ccp(CCDirector:sharedDirector():getWinSize().width/2,CCDirector:sharedDirector():getWinSize().height/2)

				elseif(mpostionType==4) then 	--原地弹道
					needMove 				= false
				elseif(mpostionType==5) then 	--固定点弹道
					needMove 				= true
					toPostion 				= ccp(CCDirector:sharedDirector():getWinSize().width/2,CCDirector:sharedDirector():getWinSize().height/2)

				elseif(mpostionType==7) then 	--撞击
					needMove 				= false
				else 							--全屏
					needMove 				= false
				end-- if end

		if(self.needMove) then
			self.xMoveDistance 	= toPostion.x - attacker.rawPostion.x
			self.yMoveDistance	= toPostion.y - attacker.rawPostion.y
		else
			self.xMoveDistance 	= 0
			self.yMoveDistance	= 0
		end
		--print("BattleBlackBoard:setMoveData x,y,needMove:",self.xMoveDistance," ",self.yMoveDistance," ",self.needMove)
		
	end -- function end
	function BattleBlackBoard:getTargetPostion( battleObject )
		return self:getPostionByTeamIndexAndId(battleObject.positionIndex,battleObject.teamId)
	end
	function BattleBlackBoard:getPostionByTeamIndexAndId( index ,teamId)
		local toPostion 		

		if teamId == BATTLE_CONST.TEAM1 then
				toPostion 							= BattleGridPostion.getSelfCloseAttackPostion(index)
		else
				toPostion 							= BattleGridPostion.getEnemyCloseAttackPostion(index)
		end
		return toPostion
	end -- function end

 
return BattleBlackBoard
