
 -- 我方移动动作,背景移动,敌方位移
local BAForSelfTeamMoveAndScrollImg = class("BAForSelfTeamMoveAndScrollImg",require(BATTLE_CLASS_NAME.BaseAction))

BAForSelfTeamMoveAndScrollImg.soundCountTime 	= nil -- 声音播放时间(用于从新播放音效)
BAForSelfTeamMoveAndScrollImg.walkSound 		= nil -- 行走音效名称
BAForSelfTeamMoveAndScrollImg.costTime  		= nil -- 行走已花费时间
BAForSelfTeamMoveAndScrollImg.backGroundMove 	= nil -- 背景移动
BAForSelfTeamMoveAndScrollImg.armyTeam 			= nil
BAForSelfTeamMoveAndScrollImg.selfTeam 			= nil

function BAForSelfTeamMoveAndScrollImg:start( ... )
	
		-- local playersDataList = BattleMainData.fightRecord:getPlayDataByPositionList(data)
		local playersDataList = BattleTeamDisplayModule.selfDisplayListByPostion
		local armyTeamDataList = BattleTeamDisplayModule.armyDisplayListByPostion
		Logger.debug("BAForSelfTeamMoveAndScrollImg:start 1")
		if( 
			playersDataList  and #playersDataList  > 0 and
		    armyTeamDataList and #armyTeamDataList > 0 and 
		    BATTLE_CONST.HERO_MOVE_COST_TIME > 0
		  ) then
			Logger.debug("BAForSelfTeamMoveAndScrollImg:start 2")
			-- 我方播放移动动作
			self.selfTeam = playersDataList
			for k,displayData in pairs(playersDataList) do
				displayData:playMoveAnimation(true)
				-- displayData:setVisible(true)
			end

			 
			-- 背景移动
			self.backGroundMove = require(BATTLE_CLASS_NAME.BAForBackGroundImgScrollAction).new()--BAForBackGroundImgScrollAction
			self.backGroundMove.moveTime			= BATTLE_CONST.HERO_MOVE_COST_TIME
			self.backGroundMove.moveDistence 		= BattleMainData.moveDistence
			self.backGroundMove.targets 			= BattleMainData.backgroundInstance
			self.backGroundMove:start()				

			--敌方位移
			self.armyTeam = armyTeamDataList
			for k,displayData in pairs(armyTeamDataList) do
				-- displayData:playMoveAnimation(true)
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
 			Logger.debug("BAForSelfTeamMoveAndScrollImg:start error")
 			self:complete()	
		end
	
end


function BAForSelfTeamMoveAndScrollImg:update( dt )
	-- Logger.debug("BAForTargetsPlayMoveInTimeAction:moveTime:"..self.time .. "  " .. self.costTime) 
	-- self.soundCountTime = self.soundCountTime + dt
	-- if(self.soundCountTime >= BATTLE_CONST.WALK_SOUND_TIME) then
	-- 	 BattleSoundMananger.playEffectSound(self.walkSound)
	-- 	 self.soundCountTime = 0
	-- end
	self.costTime = self.costTime + dt
	if(self.costTime >= BATTLE_CONST.HERO_MOVE_COST_TIME) then

		Logger.debug("BAForSelfTeamMoveAndScrollImg:start complete")

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
		local dy = dt/BATTLE_CONST.HERO_MOVE_COST_TIME  * -BattleMainData.moveDistence
		for k,v in pairs(self.armyTeam) do
			v:moveBy(0,dy)
		end
		if(self.walkSoundPlayer) then
		 		self.walkSoundPlayer:update(dt)
		end
	end
end


function BAForSelfTeamMoveAndScrollImg:release()
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


return BAForSelfTeamMoveAndScrollImg