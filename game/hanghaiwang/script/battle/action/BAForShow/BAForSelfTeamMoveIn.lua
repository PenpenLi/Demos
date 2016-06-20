

 -- 我方移动动作 + 我方位移 + 背景不动 + 敌方不动
local BAForSelfTeamMoveIn = class("BAForSelfTeamMoveIn",require(BATTLE_CLASS_NAME.BaseAction))


BAForSelfTeamMoveIn.soundCountTime 	= nil -- 声音播放时间(用于从新播放音效)
BAForSelfTeamMoveIn.walkSound 		= nil -- 行走音效名称
BAForSelfTeamMoveIn.costTime  		= nil -- 行走已花费时间
BAForSelfTeamMoveIn.backGroundMove 	= nil -- 背景移动
BAForSelfTeamMoveIn.armyTeam 			= nil
BAForSelfTeamMoveIn.selfTeam 			= nil

function BAForSelfTeamMoveIn:start( ... )
	
		Logger.debug("BAForSelfTeamMoveIn:start 1")
		-- local playersDataList = BattleMainData.fightRecord:getPlayDataByPositionList(data)
		local playersDataList = BattleTeamDisplayModule.selfDisplayListByPostion
		local armyTeamDataList = BattleTeamDisplayModule.armyDisplayListByPostion
		local playerNum = ObjectTool.countTable(playersDataList)
		local armyNum = ObjectTool.countTable(armyTeamDataList)
		if( 
			playersDataList  and playerNum  > 0 and
		    armyTeamDataList and armyNum > 0 and 
		    BATTLE_CONST.HERO_MOVE_COST_TIME > 0
		  ) then
			
		
			
		 	Logger.debug("BAForSelfTeamMoveIn:start 2")

	 		

			-- 敌方位移
			-- 敌方播放移动动作
			self.armyTeam = armyTeamDataList


			self.selfTeam = playersDataList
			for k,displayData in pairs(playersDataList) do
				displayData:playMoveAnimation(true)
				displayData:moveBy(0,-BattleMainData.moveDistence)
				-- displayData:setVisible(true)
			end


			-- for k,displayData in pairs(armyTeamDataList) do
				-- displayData:setVisible(true)
			-- end
			
			self:addToRender()
			self.costTime 							= 0
 			-- self.soundCountTime 					= 0
		  -- 	self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()
 		else
 			Logger.debug("BAForSelfTeamMoveIn:start error")
 			self:complete()	
		end
	
end


function BAForSelfTeamMoveIn:update( dt )
	-- Logger.debug("BAForTargetsPlayMoveInTimeAction:moveTime:"..self.time .. "  " .. self.costTime) 
	-- self.soundCountTime = self.soundCountTime + dt
	-- if(self.soundCountTime >= BATTLE_CONST.WALK_SOUND_TIME) then
	-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
	-- 	 self.soundCountTime = 0
	-- end
	self.costTime = self.costTime + dt
	if(self.costTime >= BATTLE_CONST.HERO_MOVE_COST_TIME) then

		Logger.debug("BAForSelfTeamMoveIn:start 3")
		for k,v in pairs(self.selfTeam) do
			v:toStandState()
		end
		
		if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 		end

		BattleSoundMananger.stopAllLoop()
		self:complete()
		self:release()
	else
		local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * BattleMainData.moveDistence
		for k,v in pairs(self.selfTeam) do
			v:moveBy(0,dy)
		end
		if(self.walkSoundPlayer) then
		 		self.walkSoundPlayer:update(dt)
		end
	end
end


function BAForSelfTeamMoveIn:release()
 		-- --print(" BAForTargetsPlayMoveInTimeAction:release:",self.targets)
 		self:removeFromRender()					 
		self.calllerBacker:clearAll()
 		self.data = nil
 		self.armyTeam = nil
 		self.selfTeam = nil
 		if(self.walkSoundPlayer) then
 		 		self.walkSoundPlayer:release()
 		 		self.walkSoundPlayer = nil
 		end
end

return BAForSelfTeamMoveIn