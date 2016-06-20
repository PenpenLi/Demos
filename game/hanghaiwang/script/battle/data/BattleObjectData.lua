

local BattleObjectData = class("BattleObjectData")


------------------ properties ----------------------
	BattleObjectData.id 			= nil
	BattleObjectData.htid			= nil
	BattleObjectData.positionIndex	= nil
	-- BattleObjectData.rawPostion		= nil
	BattleObjectData.level			= nil
	BattleObjectData.maxHp			= nil
	BattleObjectData.currHp			= nil
	BattleObjectData.currRage		= nil
 	BattleObjectData.rawHp			= nil
 	BattleObjectData.rawRage		= nil
 	BattleObjectData.heroName 		= nil 
 	BattleObjectData.isBench 		= nil -- 是否是替补
	-- BattleObjectData.attackSkill	= nil
	-- BattleObjectData.rageSkill		= nil
	-- BattleObjectData.arrSkill		= nil
	BattleObjectData.equipInfo		= nil
	BattleObjectData.isPlayer		= nil
	BattleObjectData.teamId			= nil		-- 队伍id 1：玩家队列， 2：敌军队伍
	BattleObjectData.buffInfo 		= nil		-- buff BattleObjectBuffData
	-- BattleObjectData.isDead			= nil
	------------------ display data -----------------------
	BattleObjectData.displayData	= nil		-- 显示数据
	-- BattleObjectData.isBoss			= false		-- 是否是boss
	-- BattleObjectData.isOutline		= nil 		-- true:不使用卡片做底
	-- BattleObjectData.isDemon		= false		-- 是否是恶魔

	-- BattleObjectData.isBigCard		= false		-- 是否是大牌面(英雄动作和底都要用)

	-- BattleObjectData.cardBackURL	= nil		-- 牌的背面图片URL
	-- BattleObjectData.actionImageURL	= nil 		-- 动作URL
	BattleObjectData.actionRunner  	= nil 
	BattleObjectData.isRunning		= nil							-- 动作执行队列
	
	BattleObjectData.willDropItem  	= nil	
	BattleObjectData.dropItemNum 	= nil
	BattleObjectData.dropList 		= nil


	BattleObjectData.damageRunner 	= nil

	BattleObjectData.completeCall 	= nil
	-- 获取改英雄反击技能(用于判断反击)
	BattleObjectData.beatBackSkill 	= nil
	BattleObjectData.callBackList 	= nil

	BattleObjectData.deadSkill 				= nil -- 死亡技能id
	BattleObjectData.deadSkillWillExcute 	= nil -- 死亡技能是否会被触发
	-- BattleObjectData.deadSkillExcuting 		= nil -- 死亡技能是否正在触发
	BattleObjectData.deadSkillExcuted 		= nil -- 死亡技能是否已经触发过
	BattleObjectData.nearDeathLeftRound 	= nil -- 濒死
	-- BattleObjectData.
	------------------ functions -----------------------
	-- 设置死亡技能状态
	function BattleObjectData:setDeadSkillState( value )
		-- print("--- set dead skill:",value,self.deadSkill)
		self.deadSkillExcuted 	 = not value
		self.deadSkillWillExcute = value
 		
	end
	-- 是否有死亡技能
	function BattleObjectData:hasDeadSkill( ... )
		return self.deadSkill ~= nil
	end

	function BattleObjectData:revive()
		self.currHp = self.maxHp
		self.currRage = 0
		self:hpChangeBy(0)
		self:rageChangeBy(0)
		if(self.displayData) then
			self.displayData:toStartState()
		end
	end
	function BattleObjectData:isAttackerTeam( ... )
		return self.teamId == BATTLE_CONST.TEAM1
	end
	function BattleObjectData:getHpLost( ... )
		if(self.currHp < 1) then
			return self.maxHp
		end
		return self.maxHp - self.currHp
	end
	function BattleObjectData:getCardDisplayData()

		-- Logger.debug("== BattleObjectData getCardDisplayData heroName:" .. tostring(self.heroName))
		
		local result = require("script/battle/data/BattleObjectCardUIData").new()
		result:reset(
						self.id,  
						self.htid,  
						self.positionIndex,
						self.teamId
						-- self.heroName
	 				)

		return result
	end
	-- 获取全局索引(0 -- 11)
	-- index = [0-11]
	function BattleObjectData:getGlobalIndex( ... )
		if(self.teamId == BATTLE_CONST.TEAM2) then
			return 6 + self.positionIndex
		end
		return self.positionIndex
	end
	function BattleObjectData:resetActions( ... )
		
			self.actionRunner:release()
			self.damageRunner:release()
			self.completeCall:clearAll()
			
			self.actionRunner				= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
	   		self.damageRunner 				= require(BATTLE_CLASS_NAME.BAForRunActionQueueParallel).new()
	end
	function BattleObjectData:toStartState( ... )
			self.isRunning	= false
			Logger.debug("******  BattleObjectData:toStartState")

			self:resetActions()

 			self.currHp 					= self.rawHp
 			self.currRage 					= self.rawRage
 			self.buffInfo					= require(BATTLE_CLASS_NAME.BattleObjectBuffData).new()

 			if(self.displayData == nil or self.displayData:isOnStage() == false) then
				return 
			end

 			if(self.displayData) then
 				self.displayData:toStartState()
 			end
 			if(self.displayData.hpBaseBar) then
 				self.displayData.hpBaseBar:setValue(self.currHp,self.maxHp)
 			end
 			if(self.displayData.rageBar) then
 				self.displayData.rageBar:setValue(self.rawRage)
 			end
 			
	end

	function BattleObjectData:toState( hpChangeToRaw , call)

		-- if(self.teamId == BATTLE_CONST.TEAM2) then
		-- 	print("--h-- currHp:",self.currHp," hpChangeToRaw:",hpChangeToRaw)
		-- end
		if(self.displayData == nil or self.displayData:isOnStage() ~= true) then
			return
		end
		
		if(self:isDead() ~= true ) then
				self.displayData:toRawPosition()
				self.displayData:resetCardState()
		end
		
		if(self.currHp >= 1) then
			self.hpHistory  = {}
			self.isRunning	= false
			
			self.actionRunner:release()
			self.damageRunner:release()
			self.completeCall:clearAll()
			
			self.actionRunner				= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
	   		self.damageRunner 				= require(BATTLE_CLASS_NAME.BAForRunActionQueueParallel).new()
 

			local finalHp = self.rawHp + hpChangeToRaw  
            local hpChange = finalHp - self.currHp                       
            self:hpChangeBy(hpChange)
			-- local totalChange = hpChangeToRaw - self.rawHp
			-- local hpChange = self.currHp - totalChange 
			-- self:hpChangeBy(hpChange)
 
			
			-- end
			if(self.displayData and self.displayData:isOnStage()) then 
				local action = require(BATTLE_CLASS_NAME.BAForShowNumberAnimation).new()
				action.value = hpChange
				action.heroUI = self.displayData
				if(hpChange > 0) then
					action.color = BATTLE_CONST.NUMBER_GREEN
				else
					action.color = BATTLE_CONST.NUMBER_RED
				end
				if(finalHp < 1) then
					-- if(self.teamId == BATTLE_CONST.TEAM2) then
					-- 	print("--v-- id:",self.id," currHp:",finalHp)
					-- 	Logger.debug("BattleObjectData:toState id=" .. self.id .. " pos:" ..  self.positionIndex .. " hpChangeToRaw:" .. hpChangeToRaw .. " rawHp:" .. self.rawHp .. " currHp:" .. self.currHp .. " finalHp:" .. finalHp)
				
					-- end
					self:pushDieAction(false,call) -- 快速跳过战斗不出现掉落
				end
				-- Logger.debug("BattleObjectData:toState id=" .. self.id .. " pos:" ..  self.positionIndex .. " hpChangeToRaw:" .. hpChangeToRaw .. " rawHp:" .. self.rawHp .. " currHp:" .. self.currHp .. " finalHp:" .. finalHp)
				-- BATTLE_CONST.XML_ANI_DIE_HERO_DIE
				BattleActionRender.addAutoReleaseAction(action)
			end
		else
			-- if(self.teamId == BATTLE_CONST.TEAM2 and self.currHp < 1) then
			-- 	print("--v-- hp id:",self.id," currHp:",self.finalHp)
			-- end

		end
		
		if(self.displayData == nil or self.displayData:isOnStage() == false) then
			print("== BattleObjectData:toState displayData is not on stage")
			return 
		end

		-- if(self.displayData ~= nil) then
		
		-- self.displayData:toRawPosition()

	end

	function BattleObjectData:willDie(damage)
		if(self.currHp < 1) then return false end

		return self.currHp + damage < 1
	end
	-- 是否是濒死状态
	function BattleObjectData:willNearDeath( damage )

		-- 伤害会造成死亡
		if(self:willDie(damage) == true) then
	 
			
			if( self.deadSkill ~= nil and  -- 如果有死亡技能
		    	self.deadSkillExcuted ~= true and -- 如果死亡技能还没被使用
		    	self.deadSkillWillExcute == true ) then -- 如果改技能在本场战斗会被触发
			 return true
			end
		end
		return false
	end

	function BattleObjectData:isDead()
		return self.currHp  <  1
	end
	function BattleObjectData:ctor()
	    --print("create BattleObjectData")
	   	self.actionRunner								= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
	   	self.damageRunner 								= require(BATTLE_CLASS_NAME.BAForRunActionQueueParallel).new()
	   	self.completeCall 								= require(BATTLE_CLASS_NAME.BattelEvtCallBacker).new()
	    self.actionRunner.name 							= "BattleObjectData.actionRunner:"
		self.buffInfo									= require(BATTLE_CLASS_NAME.BattleObjectBuffData).new()
		self.isPlayer 									= false
		self.isRunning 									= false
		self.willDropItem 								= false
		self.dropList 									= {}
		self.dropItemNum 								= 0
	end




	function BattleObjectData:addQueueCallBacker( target,callBack )
		
		-- if(self.callBackList == nil )  then
		-- 	self.callBackList = {}
		-- end

	 	-- self.callBackList[target] = callBack

		if(target and callBack) then
			self.completeCall:addCallBacker(target,callBack)
			-- --print("BattleObjectData:addQueueCallBacker:",self.id)
			-- self.actionRunner:addCallBacker(target,callBack)
		else
			error("BattleObjectData:addQueueCallBacker is error")
		end
	end
	function BattleObjectData:pushBSTAction( target )
		-- --print("xxxxxxx isRunning->true")
		self.isRunning									= true
		self.actionRunner:push(target)
		self.actionRunner:addCallBacker(self,self.onActionComplete)
		self.actionRunner:start()
	end

	function BattleObjectData:isRunningDamageAction( ... )
		return self.damageRunner:isRunning()
	end

	function BattleObjectData:pushDamageAction( action)
		
		self.isRunning									= true
		-- self.damageRunner:addCallBacker(self,self.onActionComplete)
		self.damageRunner:pushAndStart(action)
		-- self.actionRunner:start()

	-- self.damageRunner:		
	end

	function BattleObjectData:onActionComplete( target , data )

		--print("player to idle")
		--print("xxxxxxx isRunning:",self.actionRunner.running," dr:",self.damageRunner.running)
		-- if(self.actionRunner == false) then
		if(self.damageRunner.running == false) then
 			self.isRunning	= false
 			-- Logger.debug("BattleObjectData idle from onActionComplete")
 			self.completeCall:runCompleteCallBack(self,data)
 			self.completeCall:clearAll()
 		end
 		-- end
 		-- if(self.actionRunner) then
 		-- 	self.actionRunner:release()
 		-- end
 		-- self.actionRunner								= require(BATTLE_CLASS_NAME.BAForRunActionQueueWithWeight).new()
	  --   self.actionRunner:addCallBacker(self,self.onActionComplete)
	  --   self.actionRunner.name 							= "BattleObjectData.actionRunner:"
	
	end

	function BattleObjectData:isIdle( ... )
		-- print("=====   check idle  self.isRunning",self.isRunning," actionRunner.isRunning:",self.actionRunner.running," damageRunner.running:",self.damageRunner.running)
		return (self.actionRunner.running==false and self.damageRunner.running == false) -- and self.displayData.isPlaying == false
		-- return (self.actionRunner.running==false) -- and self.displayData.isPlaying == false
	end

	function BattleObjectData:reset( data , team ,isBench)
		
		self.deadSkillWillExcute 	= false
		self.deadSkillExcuted = false

		self.nearDeathLeftRound 	= nil
		self.hpHistory 				= {}
		-- Logger.debug("******  BattleObjectData:reset")
		self.isBench				= isBench or false
		-- self.isDead 				= false
		self.id						= tonumber(data.hid)
		self.teamId					= tonumber(team)
		self.htid					= tonumber(data.htid)
		self.positionIndex			= tonumber(data.position)
		self.deadSkill 				= data.deathSkill

		if(self.deadSkill == 0) then
			self.deadSkill = nil
		end
		
		if(self.deadSkill ~= nil) then
			self.deadSkill = tonumber(self.deadSkill)
			print("----- player:",self.id,"has dead skill:",self.deadSkill)
		end
		-- 获取改英雄反击技能(用于判断反击)
		self.beatBackSkill 								= BattleDataUtil.getBeatBackSKill(self.id,self.htid)

		-- self.heroName 				= tostring(data.name)
		-- Logger.debug("== BattleObjectData heroName:" .. tostring(self.heroName))
		-- self.starLevel				= BattleDataUtil.getGradeColor()
		-- self.nameColor				= BattleDataUtil.getGradeColor(self.starLevel)
		-- for k,v in pairs(data) do
		-- 	--print("BattleObjectData:",k," ",v)
		-- end

		
 
		self.moveToPosition			= {}
		
		self.level					= tonumber(data.level)
		self.maxHp					= tonumber(data.maxHp)
		if(data.maxHp == nil) then
			self.maxHp 				= 0
		else
			
		end
		if(data.currHp == nil) then
			self.currHp				= tonumber(data.maxHp)
		else
			self.currHp				= tonumber(data.currHp)
		end
		self.rawHp 					= self.currHp

		if(data.currRage == nil ) then
			self.currRage			= 0
		else
			self.currRage			= tonumber(data.currRage)
		end
		self.rawRage 				= self.currRage

		 -- == nil or 0
		 self.isPlayer				= self.teamId == BATTLE_CONST.TEAM1
		-- self.isPlayer				= self.id >= BATTLE_CONST.ID_MARK

		-- if self.teamId == BATTLE_CONST.TEAM2 then
		-- 	self.rawPostion			= BattleGridPostion.getEnemyPointByIndex(self.positionIndex)
		-- else
		-- 	self.rawPostion			= BattleGridPostion.getPlayerPointByIndex(self.positionIndex)
		-- end

 
		self.buffInfo				= require(BATTLE_CLASS_NAME.BattleObjectBuffData).new()
		self.displayData 			= nil


		self.dropList 									= {}
		self.dropItemNum 								= 0
		self.willDropItem 								= false
		--print("BattleObjectData:reset id:",self.id,
				-- " teramId:",self.teamId,
				-- " htid:",self.htid ,
				-- " positionIndex:",self.positionIndex,
				-- " isPlayer:",self.isPlayer)

	end

	function BattleObjectData:release( ... )
		if(self.actionRunner) then
			self.actionRunner:release()
		end

		if(self.damageRunner) then
			self.damageRunner:release()
		end
		self.completeCall:clearAll()
	end

	function BattleObjectData:refreshRageUI()
		
		if(self.currRage > 0) then 
			self.displayData.rageBar:setValue(self.currRage)
		end
		
	end
	-- 刷新显示状态
	function BattleObjectData:refreshDisplayState( )
		-- print("== refreshDisplayState 1")
		if(self:isDead()) then
			-- print("== refreshDisplayState isDead")
			if(self.displayData and self.displayData:isOnStage() == true) then
				self.displayData:ghostState()
				-- print("== refreshDisplayState onstage")
			else
				-- print("== refreshDisplayState error",self.displayData,self.displayData:isOnStage())
			end
		else
			-- print("== refreshDisplayState not dead")
			-- print("self.currHp,self.maxHp",self.currHp,self.maxHp,self.positionIndex)
			-- 刷新血量
			if(self.displayData and self.displayData.hpBaseBar) then
 				self.displayData.hpBaseBar:setValue(self.currHp,self.maxHp)
 			end
		end
	end

	function BattleObjectData:toGhostState( ... )
		if(self:isDead() and self.displayData and self.displayData:isOnStage()) then
			self.displayData:ghostState()
		end
	end


	function BattleObjectData:linkDisplay()
		self.displayData 			= BattleTeamDisplayModule.getCardByPostionAndTeam(self.positionIndex,self.teamId)
		assert(self.displayData,"team:".. tostring(self.teamId) .. "postion hero:" .. self.positionIndex .. " not found")
		-- 这里需要初始化一下血量
		self:hpChangeBy(0)
		self:rageChangeBy(0)
		if( self:isDead() == true ) then
			self.displayData:dead()
			-- 如果是玩家
			if(self.isPlayer == true) then
				self.displayData:diedState()
			else
				self.displayData:setVisible(false)
			end
		end

		self.displayData:refreshDisplayName()
		-- self:rageChangeBy(12)
		-- Logger.debug("hero state:%d,%d",self.currHp,self.maxHp)
		-- print("hero state:%d,%d",self.currHp,self.maxHp)
		-- self.displayData.isDead 	= false
		-- if (self.displayData == nil ) then
		-- 	--print("BattleObjectData:reset -> displayData is nil")
		-- end
	end

	function BattleObjectData:getHeadPosition()
		return self.displayData:globalHeadPoint()
	end
 

	-- function BattleObjectData:pushRageInfo(rage)
	-- 	--print("BattleObjectData:pushRageInfo:self.currRage:",self.currRage)
	-- 	self.currRage = self.currRage + rage
	-- end
	-- function BattleObjectData:getHpLost( ... )
	-- 	local result = 0
	-- 	for k,hp in pairs(self.hpHistory or {}) do
	-- 		if(hp < 0) then
	-- 			result = result + hp
	-- 		end
	-- 	end
	-- 	return math.abs(result)
	-- end
	function BattleObjectData:hpChangeBy( value )

		table.insert(self.hpHistory,value)
		local isDead = self:isDead()
		-- Logger.debug(self.id .. " hp change:" .. self.currHp .. "-->" ..  self.currHp + value .."/" ..self.maxHp)
		self.currHp = self.currHp + value
		if(self.displayData == nil or self.displayData:isOnStage() ~= true) then
			return 
		end
		
		self.displayData.hpBaseBar:setValue(self.currHp,self.maxHp)
		if(self.currHp < 1 and isDead == false ) then
			self.displayData:dead()
			if( self.deadSkill ~= nil 				and -- 有死亡技能
				self.deadSkillWillExcute == true 	and -- 死亡技能会被激活
				self.deadSkillExcuted == false  	    -- 未被激活
			  ) then 

				self.deadSkillExcuted = true
				self.nearDeathLeftRound = 1 -- 濒死延迟人物到下次人物出手后死亡
				-- self.displayData:shineState()
			end
			EventBus.sendNotification(NotificationNames.EVT_UI_BENCH_REFRESH_ALIVE_NUM)
		end
		
		EventBus.sendNotification(NotificationNames.EVT_BELLY_EVENT_INFO_REFRESH_DAMAGE)
		-- if(self.currHp <= 0) then
		-- 	--print("IIIIIIIIIIIIIII am die")
		-- 	self:pushDieAction()
		-- end -- if end
	end

	-- 是否在濒死状态
	function BattleObjectData:isInNearDeath( ... )
		return self.nearDeathLeftRound > 0
	end
	
	function BattleObjectData:downNearDeathRound( ... )
		self.nearDeathLeftRound = self.nearDeathLeftRound - 1
		-- if(self.nearDeathLeftRound > 0) then
		-- 	if(self.nearDeathLeftRound <= 0) then
		-- 		self.deadSkillExcuted = true
		-- 	end
		-- end
	end
 
	function BattleObjectData:rageChangeBy( value )
		-- Logger.debug(self.id .. " rage change:" .. self.currRage .. "-->" .. (self.currRage + value))
		self.currRage = self.currRage + value
		if(self.displayData and self.displayData.rageBar) then
			self.displayData.rageBar:setValue(self.currRage)
		end
	end


	-- function BattleObjectData:pushRageInfo( rageInfo ,target,callBack)

	--  	if(rageInfo) then
	--  		--print("BattleObjectData:pushRageInfo")
	 	 
	--  		self.isRunning									= true
	-- 		-- --print("BattleObjectData:pushBuffInfo:hasBuffInfo")
	-- 		local rageAction 			= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	--         rageAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSSkillRageDamageBB).new()
	--         rageAction.blackBoard:reset(rageInfo)
	-- 		rageAction.logicData 		= SkillRageDamageActionLogicData.getLogicData()
	--         rageAction.name 			= "rage logic tree"
	--             -- behavierTree:start()
	--         if(target ~= nil and callBack ~= nil) then
	--         	rageAction:addCallBacker(target,callBack)
	--         end -- if end
 --        	self:pushBSTAction(rageAction)
	-- 	end	-- if end

	-- end

function BattleObjectData:pushDieAction(playDropAni,callBack)
		self.isRunning									= true
		if(playDropAni == nil) then
			playDropAni = true
		end
		-- --print("BattleObjectData:pushBuffInfo:hasBuffInfo")
		local dieAction 			= require(BATTLE_CLASS_NAME.BAForBSAction).new()
        dieAction.blackBoard 		= require(BATTLE_CLASS_NAME.BSDieBB).new()
        dieAction.blackBoard:reset(self,playDropAni)
		dieAction.logicData 		= DieLogicData.getLogicData()
        dieAction.name 				= "die logic tree"
            -- behavierTree:start()
        if(target ~= nil and callBack ~= nil) then
        	dieAction:addCallBacker(target,callBack)
        end -- if end
        -- dieAction:start()
    	self:pushBSTAction(dieAction)
    	self.displayData.isDead = true
end

	-- 开始执行buff(buff数据,时间,回调目标,回调函数)
	function BattleObjectData:pushBuffInfo( battleBuffsInfo ,timeType,target,callBack) --BattleBuffsInfo
		-- local buffData 			= {}
		-- -- buffData.enBuffer 		= {}
		-- -- buffData.enBuffer[1]	= 95
		-- buffData.buffer 		= {}
		-- buffData.buffer[1]      = {bufferId=94,type=1,data=100}

		-- -- buffData.imBuffer		= {}
		-- -- buffData.imBuffer[1]	= 93
		-- -- buffData.deBuffer		= {}
		-- -- buffData.deBuffer[1]	= 95
	 
		-- battleBuffsInfo 			= require(BATTLE_CLASS_NAME.BattleBuffsInfo).new()
		-- battleBuffsInfo:reset(buffData,self.id)
		
		if(battleBuffsInfo and battleBuffsInfo:hasBuffInfo()) then
			 
			 -- Logger.debug("BattleObjectData:pushBuffInfo 1")
			self.isRunning									= true
			----print("BattleObjectData:pushBuffInfo:hasBuffInfo")
			local bufffer 			= require(BATTLE_CLASS_NAME.BAForBSAction).new()
	        bufffer.blackBoard 		= require(BATTLE_CLASS_NAME.BSBufferBB).new()
	        --print("BattleObjectData:pushBuffInfo:",battleBuffsInfo.id)
	        bufffer.blackBoard:reset(battleBuffsInfo,timeType)
			bufffer.logicData 		= BuffLogicData.getLogicData()
	        bufffer.name 			= "人物buff BSTree"
	            -- behavierTree:start()
	        if(target ~= nil and callBack ~= nil) then
	        	bufffer:addCallBacker(target,callBack)
	        end -- if end
        	self:pushBSTAction(bufffer)
        	
        else
        	-- Logger.debug("BattleObjectData:pushBuffInfo 2")
        	if(target and callBack) then
        		callBack(target)
        	else
        		error("error:BattleObjectData:pushBuffInfo")
        	end
		end	-- if end

	end

	-- function BattleObjectData:pushAttackData( roundData )
	-- 	self.isRunning									= true
 
 --         local roundAttack 	= require(BATTLE_CLASS_NAME.BAForBSAction).new()
 --        roundAttack.name 		= "attackerTree"
 --        roundAttack.blackBoard = require(BATTLE_CLASS_NAME.BSSkillSystemBBData).new()
 --        roundAttack.blackBoard:reset(roundData)
 --        roundAttack.logicData 	= AttackLogicData.getLogicData()
 		

 --        self:pushBSTAction(roundAttack)

	-- end

	-- 压入技能伤害(注意不包含buff伤害)
		-- damageShowNumber
		-- 应策划需求 多段伤害的显示和计算用不同的规则.
		-- 呵呵 2015.6.29 丁青云
		-- 用于显示数字的伤害(因为多段特殊需求:伤害显示和实际扣血不同步的需求导致)
	function BattleObjectData:pushDamageInfo( damage ,underattackerData , time ,totalTime,damageShowNumber)
		-- print("total:",self.currHp," HPChangeBy:",damage)
		-- 如果没有实质伤害则返回
		totalTime = totalTime or 1
		-- Logger.debug("hasDamage:" .. tostring(underattackerData.hasDamage))
		if(underattackerData and underattackerData.hasDamage == false and underattackerData.hasReactionAnimation == false) then return end

		self.isRunning									= true 
		-- self.displayData:stopAction()

		local blackBoard 	= require(BATTLE_CLASS_NAME.BSSkillHpDamageBB).new()
		blackBoard:resetFromSkill(damage,underattackerData,damageShowNumber)
		-- blackBoard.damageShowNumber = damageShowNumber
		

		local logicData 	= SkillHpDamageActionLogicData.getLogicData()
		local bsTree 	 	= require(BATTLE_CLASS_NAME.BAForBSAction).new()

		-- Logger.debug("pushDamageInfo: time " .. tostring(time) )
		if(time == nil or time == 0 or time == 1) then
			blackBoard.isFirstTime = true
		else
			blackBoard.isFirstTime = false
		end

		-- 判断是否是多段
		blackBoard.isMulityTime = totalTime > 1

		-- 判断是否是多段最后一击
		if(time >= totalTime and totalTime > 1) then
			blackBoard.isLastMulityTime = true
		else
			blackBoard.isLastMulityTime = false
		end
		
		bsTree.blackBoard 	= blackBoard
		bsTree.logicData 	= logicData
		bsTree.name 		= "+伤害BS+"
		-- bsTree:start()
		-- bsTree:addCallBacker(self,self.onActionComplete)
		-- bsTree:start()
		-- self:pushBSTAction(bsTree)
		self.damageRunner:addCallBacker(self,self.onDamageActionComplete)
		-- --print("self.damageRunner:addCallBacker:",self.id)
		self.damageRunner:pushAndStart(bsTree)
		 
	end

	function BattleObjectData:onDamageActionComplete( ... )
	  
		-- if(self.actionRunner == false) then
		-- print("onDamageActionComplete self.actionRunner" ," dr:",self.actionRunner.running ,self.id ," damageRunner:" ,self.damageRunner.running)
		if(self.actionRunner.running == false) then
 			self.isRunning	= false
 			-- Logger.debug("BattleObjectData idle from onDamageActionComplete")
 			self.completeCall:runCompleteCallBack(self,data)
 			-- for k,v in pairs(self.callBackList ) do
 			-- 	v()
 			-- end
 			-- self.callBackList = {}
 			-- self.completeCall:clearAll()
 		end
	end

	-- 删除buff,立即生效
	function BattleObjectData:removeBuff(id)
		
			-- buff icon 列表 删除
			self.buffInfo:remove(id)
				-- 如果已经buff计数== 0 
				if(self.buffInfo:hasBuff(id) == false) then 

				end
			local buffCount = self:getBuffCount(id)
			-- Logger.debug(self.id .. " removeBuff:" .. id .. " aftercount:" .. tostring(buffCount))
			if(buffCount == nil or buffCount<= 0) then
				local iconName = db_buff_util.getIcon(id)
				assert(iconName)
				self.displayData:removeBuffUI(iconName)
			end
					-- 删除 removeBuffIcon
	end
	function BattleObjectData:getBuffCount( id )
		--print("BattleObjectData:getBuffCount:",id)
		return self.buffInfo:getBuffCount(id)
	end
	-- function basePrint:pushBuffInfo( data ) -- data :BattleBuffsinfo
	-- 	if(data) then
	-- 		-- 如果有buff
	-- 		if(data:hasBuffInfo()) then
				
	-- 		end
	-- 	end
	-- end
	-- 添加buff,立即生效
	function BattleObjectData:addBuff(id)
		-- local queue					= require(BATTLE_CLASS_NAME.BAForRunActionSequencely).new()
		-- local hasBuffLast 			= self.buffInfo:hasBuff(id)
		--print("BattleObjectData add buff:",id)
		self.buffInfo:add(id)
		-- buff icon 数据列表 添加
 
	end -- function end
 
 	-- function BattleObjectData:checkDead( )
 	-- 	if(self.currHp <= 0) then 
 	-- 		-- todo
 	-- 	end
 	-- end
 	function BattleObjectData:printHpInfo( ... )
 		Logger.debug(self.id.." hp :"..self.currHp.."/"..self.maxHp)
 	end
	function BattleObjectData:basePrint( )
		
		return "数据 玩家:"..self.name.." id:"..self.id.. " "
	end

	function BattleObjectData:addDropObjectData( data )
		table.insert(self.dropList,data)
		self.dropItemNum = self.dropItemNum + 1
		self.willDropItem = true
	end

	function BattleObjectData:isBeatBackSkill( id )
		if(self.beatBackSkill ~= nil and id ~= nil) then
			return self.beatBackSkill == id
		end
		return false
	end

	function BattleObjectData:popAll()
		local all = self.dropList
		self.dropList = {}
		self.willDropItem = false
		self.dropItemNum = 0
		return all
	end

return BattleObjectData