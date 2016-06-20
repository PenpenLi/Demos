
 -- 敌方移动动作 + 敌方位移 + 背景不动 + 我方不动
local BAForArmyTeamMoveIn = class("BAForArmyTeamMoveIn",require(BATTLE_CLASS_NAME.BaseAction))

BAForArmyTeamMoveIn.soundCountTime 	= nil -- 声音播放时间(用于从新播放音效)
BAForArmyTeamMoveIn.walkSound 		= nil -- 行走音效名称
BAForArmyTeamMoveIn.costTime  		= nil -- 行走已花费时间
BAForArmyTeamMoveIn.backGroundMove 	= nil -- 背景移动
BAForArmyTeamMoveIn.armyTeam 			= nil
BAForArmyTeamMoveIn.selfTeam 			= nil

function BAForArmyTeamMoveIn:start( ... )
		-- Logger.debug("BAForArmyTeamMoveIn:start")
		-- local playersDataList = BattleMainData.fightRecord:getPlayDataByPositionList(data)
		local playersDataList = BattleTeamDisplayModule.selfDisplayListByPostion
		local armyTeamDataList = BattleTeamDisplayModule.armyDisplayListByPostion
		local playerNum = ObjectTool.countTable(playersDataList)
		local armyNum = ObjectTool.countTable(armyTeamDataList)
		-- Logger.debug("BAForArmyTeamMoveIn:start " .. " playerNum:"  .. tostring(playerNum) .. ", armyNum:" .. tostring(armyNum) .."," ..  tostring(BATTLE_CONST.HERO_MOVE_COST_TIME))
 			
		if( 
			playersDataList  and playerNum  > 0 and
		    armyTeamDataList and armyNum > 0 and 
		    BATTLE_CONST.HERO_MOVE_COST_TIME > 0
		  ) then
			
			Logger.debug("BAForArmyTeamMoveIn:start1")
			self.selfTeam = playersDataList
 				

			-- 敌方位移
			-- 敌方播放移动动作
			self.armyTeam = armyTeamDataList
			for k,displayData in pairs(armyTeamDataList) do
				displayData:playMoveAnimation(true)
				-- displayData:setVisible(true)
				displayData:moveBy(0,BattleMainData.moveDistence)
			end
			
			self:addToRender()
			self.costTime 							= 0
 			-- self.soundCountTime 					= 0
		  -- 	self.walkSound 							= ObjectTool.getRandomWalkSoundName() --
 			-- BattleSoundMananger.playEffectSound(self.walkSound,true,true)
 			self.walkSoundPlayer 						= require(BATTLE_CLASS_NAME.BAForPlayRandomSound).new()
			self.walkSoundPlayer:start()

 		else
 			Logger.debug("BAForArmyTeamMoveIn:start2" .. " playerNum:"  .. tostring(#playerNum) .. ", armyNum:" .. tostring(armyNum) .."," ..  tostring(BATTLE_CONST.HERO_MOVE_COST_TIME))
 			self:complete()	
		end
	
end


function BAForArmyTeamMoveIn:update( dt )
	-- Logger.debug("BAForArmyTeamMoveIn:update:"..self.costTime .. "/" .. BATTLE_CONST.HERO_MOVE_COST_TIME) 
	-- self.soundCountTime = self.soundCountTime + dt
	-- if(self.soundCountTime >= BATTLE_CONST.WALK_SOUND_TIME) then
	-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
	-- 	 self.soundCountTime = 0
	-- end
	self.costTime = self.costTime + dt
	if(self.costTime >= BATTLE_CONST.HERO_MOVE_COST_TIME) then

		for k,v in pairs(self.armyTeam) do
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
		local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * -BattleMainData.moveDistence
		for k,v in pairs(self.armyTeam) do
			v:moveBy(0,dy)
		end

		if(self.walkSoundPlayer) then
	 		self.walkSoundPlayer:update(dt)
		end

	end
end


function BAForArmyTeamMoveIn:release()
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
return BAForArmyTeamMoveIn