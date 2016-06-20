
 
local BattleDataADT = class("BattleDataADT")
	------------------ properties ----------------------	
 
	BattleDataADT.base64Object	= nil --base64
	BattleDataADT.team1Info		= nil
	BattleDataADT.team2Info		= nil
	BattleDataADT.playerRounds	= nil -- 战斗回合数据
	BattleDataADT.enviroment	= nil -- 战斗环境参数
	BattleDataADT.result 		= nil -- 战斗结束
	BattleDataADT.index			= nil   -- 索引
 
	BattleDataADT.idToData		= nil -- id->data
	BattleDataADT.heroDropList  = nil
	BattleDataADT.appraisal  	= nil -- 评价


	BattleDataADT.recordData  					= nil -- 录像数据 BattleDataADT
	BattleDataADT.reward 						= nil -- 奖励物品
	BattleDataADT.extra_reward 					= nil -- 其他奖励信息
	BattleDataADT.copyCallBackData 				= nil -- 副本 回调 数据,用于结束画面
	BattleDataADT.isWin 						= nil -- 是否是胜利
	BattleDataADT.dropItems 					= nil -- 掉落物品
	BattleDataADT.isfollowRole  				= nil 
	BattleDataADT.idToShipData 					= nil -- 
	BattleDataADT.brid 							= nil
	-- BattleDataADT.bigRound						= nil -- 大回合
	-- BattleDataADT.smallRound					= nil -- 小回合
	-- BattleDataADT.score 						= nil -- 分数

	------------------ functions -----------------------
	-- 获取自己队伍的现实数据  table[position] = data
	function BattleDataADT:getSelfTeamDisplayList()

	end
	function BattleDataADT:getArmyTeamDisplayList()

	end


	-- 如果自己在队伍2,胜利结果则等于: not win(因为结果是针对队伍1的)
	function BattleDataADT:followRole()

		Logger.debug(" ->BattleDataADT followRole: hid" .. UserModel.getUserUid())
		if(self.team2Info and self.team2Info.uid == UserModel.getUserUid()) then
			self.isWin = (string.lower(self.appraisal) == "f" or string.lower(self.appraisal) == "e") 
			Logger.debug(" ->BattleDataADT followRole:" .. tostring(self.isWin))
			self.isfollowRole = true
		else
			self.isfollowRole = false
		end
		
	end

	function BattleDataADT:printHpInfo( ... )

		Logger.debug("====================== team1 =======================")
		for k,target in pairs(self.team1Info.list) do
		 	target:printHpInfo()
		end 

		Logger.debug("====================== team2 =======================")
		for k,target in pairs(self.team2Info.list) do
		 	target:printHpInfo()
		end 

	end
	function BattleDataADT:resetToStart( ... )
		self.index = 1

		-- self:resetTeamInfo()
		-- self:refreshIDList()
		self:reset(self.battleString)
		
	end
	-- 重置队伍信息
	function BattleDataADT:resetTeamInfo( )
		if(self.team1Info) then
			 self.team1Info:resetToStart()
			 self.team1Info:handleDeadSkills(self.data)
		end

		if(self.team2Info) then
			 self.team2Info:resetToStart()
			 self.team2Info:handleDeadSkills(self.data)
		end
	end
	function BattleDataADT:isFirstPlayerRound( ... )
		return self.index == 1
	end
		-- des:test
	function BattleDataADT:reset(serverdata)
		 self.isfollowRole = false
		 self.battleString 	= serverdata
		 Logger.debug("BattleDataADT:reset:" ..  serverdata)
		 local amf3_obj,lua_obj
		 local decode = function( ... )
		 	 amf3_obj = Base64.decodeWithZip(serverdata)
    	 	 lua_obj  = amf3.decode(amf3_obj)
		 end
		 self.data 	  = lua_obj
		 if(pcall(decode)) then
		 	     -- Logger.debug("== BattleDataADT: battle string:" .. serverdata)
		 	     -- Logger.debug("== BattleDataADT")
		    	 print_table ("== BattleDataADT", lua_obj)
		      	 self.battleObject = lua_obj
		    	 self.index 	= 1
		 		
		    	 --初始化数据
		    	 self:setEnviroment(lua_obj)
		 		 -- 英雄掉落表
		 		 -- self:setDropList(lua_obj.reward)
		    	 -- -- 队伍信息
		    	 self:setTeamInfo(lua_obj)
		    	 -- 战斗回合
		    	 self:setPlayerRounds(lua_obj)
		    	 -- 结束数据局
		    	 self:setBattleResult(lua_obj)
		    	--  Logger.debug("== after BattleDataADT")
		    	-- print_table ("== after BattleDataADT", lua_obj)

		 		self:printSkill()
		 		-- self.bigRound = -1
		 	 
		 else
		 	 	error("战斗串解析失败")
		 end

    	
    	-- encode	 
	end --function end

	function BattleDataADT:release( ... )
		if(self.team1Info) then
			self.team1Info:release()
		end

		if(self.team2Info) then
			self.team2Info:release()
		end
	end
	-- 刷新玩家ui(开场前必须要刷新,因为数据里是没有 display 对象的)
	function BattleDataADT:linkAndRefreshHeroesDisplay()
		if(self.team1Info) then
			self.team1Info:linkAndRefreshHeroesDisplay()
		end

		if(self.team2Info) then
			self.team2Info:linkAndRefreshHeroesDisplay()
		end

	end
	function BattleDataADT:printSkill()
		--print(" ===================================== ")
		for k,v in pairs(self.playerRounds) do

			--print(" rount index:",k," skill:",v.action)

		end
		--print(" ===================================== ")
	end
 

 	-- 英雄掉落
	function BattleDataADT:setDropList( reward )
	 -- ret : 
  --         dictionary{
  --             reward : 
  --                 dictionary{
  --                     exp : "0"
  --                     silver : "220"
  --                     soul : "110"
  --                     item : 
  --                         array[ 
  --                             (0):
  --                                 dictionary{
  --                                     item_id : "60002"
  --                                     item_template_id : "60002"
  --                                     item_num : "1"
  --                                 }
  --                         ]
  --                     hero : 
  --                         array[ 
  --                             (0):
  --                                 dictionary{
  --                                     htid : "430019"
  --                                     num : "10"
  --                                     mstId : "1022102"
  --                                 }
  --                             (1):
  --                                 dictionary{
  --                                     htid : "430014"
  --                                     num : "10"
  --                                     mstId : "1022106"
  --                                 }
  --                         ]
  --                 }
  --             extra_reward : 
  --                 array[ 
  --                 ]
  --             err : "ok"
  --             cd : "1"
  --             appraisal : "SSS"
  --             fightRet : "eJydVl9sU1U...."
  		self.dropItems = {}
  		-- Logger.debug("----- setDropList")
  		-- print("----- setDropList",reward.item)
  		if(reward and reward.item) then
  			-- print_table("reward.item",reward.item)
  			-- Logger.debug("----- reward.item")
  			for k,itemInfo in pairs(reward.item or {}) do
  				-- Logger.debug("----- drop item:")
  				local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  				dropItem1:resetByItem(itemInfo)
		 		table.insert(self.dropItems,dropItem1)
		 	end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end

		 	-- for k,itemInfo in pairs(reward.item or {}) do
  		-- 		Logger.debug("----- drop item:")
  		-- 		local dropItem1 = require(BATTLE_CLASS_NAME.BattleChestData).new()
  		-- 		dropItem1:resetByItem(itemInfo)
		 	-- 	table.insert(self.dropItems,dropItem1)
		 	-- end
		 	
  		end

 

  		self.heroDropList= {}
	 	if(reward and reward.hero) then
		 	for k,v in pairs(reward.hero or {}) do
		 		--print("BattleDataADT:setDropList:"..v.mstId .." num:" .. v.num)
		 		local dropItem = require(BATTLE_CLASS_NAME.BattleChestData).new()
  				dropItem:resetByHeroPart(v)
  				if(idToData[tonumber(v.mstId)]~= nil) then
  					idToData[tonumber(v.mstId)]:addDropObjectData(dropItem)
  					-- print("--- add hero part:",v.mstId)
  				end

		 	end
		end
 


		if(BattleMainData.strongholdData ~= nil and self.dropItems ~= nil and #self.dropItems > 0 and self.team2Info) then


			itemNum = #self.dropItems
			itemLeft = #self.dropItems
			local armyData = BattleMainData.strongholdData:getCurrentArmyData()
			if(armyData ~= nil) then
				local bossGet = math.ceil(itemLeft * 0.6)
				-- local bossGet = 1 -- math.ceil(itemLeft * 0.6)

				if(armyData.armyTeamBosses and #armyData.armyTeamBosses > 0) then
					-- 60% math.ceil(itemLeft * 0.6 )个 

					itemLeft = itemLeft - bossGet
					-- Logger.debug("---- boss num:%d,boss get :%d",#armyData.armyTeamBosses,bossGet)
					local bossData = self.team2Info:indexPlayerByPosition(armyData.armyTeamBosses[1].positionIndex)--[armyData.armyTeamBosses[1].positionIndex]
					for i=1,bossGet do
						bossData:addDropObjectData(self.dropItems[i])
						table.remove(self.dropItems,i)
					end
				end
				local lastOne = nil
				-- 副本和精英 肯定有多个人
				-- 遍历所有非boss
				-- 摇 1 - itemLeft个
				if(armyData.armyTeamSoldiers and #armyData.armyTeamSoldiers > 0) then
						
						-- Logger.debug("---- soldier get :%d",itemLeft)
						for i=1,#armyData.armyTeamSoldiers do
							if(itemLeft > 0) then
								local target = self.team2Info:indexPlayerByPosition(armyData.armyTeamSoldiers[i].positionIndex)--[armyData.armyTeamSoldiers[i].positionIndex]
								local getNum = math.random(1,itemLeft)
								itemLeft = itemLeft - getNum
								for j=1,getNum do
									 target:addDropObjectData(self.dropItems[1])
									 table.remove(self.dropItems,i)
								end -- for end
								lastOne = target
							else
								break
							end
						end

						-- 如果还有那么就塞给1个人
						 
						if(itemLeft > 0 and lastOne) then
							for j=1,itemLeft do
									 lastOne:addDropObjectData(self.dropItems[1])
									 table.remove(self.dropItems,i)
							end -- for end
						end

				end -- if end

			end

		end

	end -- function end

	function BattleDataADT:isTeam1PostionHasPerson(p)
		if(self.team1Info and
		   self.team1Info.positions[p] ~= nil and
		   not self.team1Info.positions[p]:isDead()) then 
			return true
		end
		return false
	end
	
	function BattleDataADT:isTeam2PostionHasPerson(p)
		if(self.team2Info and self.team2Info.positions[p] ~= nil and  not self.team2Info.positions[p]:isDead()) then 
			return true
		end
		return false
	end
	-- -- 获取下一回合数据,但是不会引起迭代器的位置变化
	-- function BattleDataADT:preGetNextRoundRawData( ... )
	-- 	-- 生成数据
	-- 	local nextIndex = self.index + 1
	-- 	if(self.playerRounds[nextIndex] ~= nil ) then -- 如果有数据
	-- 		return self.playerRounds[nextIndex]
	-- 	end
	-- 	return nil
	-- end
	-- 获取下一回合的战斗数据
	function BattleDataADT:getNextRoundData()
		
		if(self.playerRounds[self.index] ~= nil) then -- 如果有数据
			-- 生成数据
			local nextIndex = self.index + 1
			--print("[----------------- next round:",self.index + 1 ," -----------------]")
			local round = require(BATTLE_CLASS_NAME.BattlePlayerRoundData):new()
			
			-- 是否可以提前播放
			local canPreStart = false

			if(self.playerRounds[self.index + 1] ~= nil) then
				-- 下一回合技能涉及角色
				local nextRoundSkillEffectPlayers = nil
			 	local nextRound = require(BATTLE_CLASS_NAME.BattlePlayerRoundData):new()
				nextRound:reset(self.playerRounds[self.index + 1])
				nextRoundSkillEffectPlayers = nextRound:getSkillEffectTargets()
				canPreStart = nextRoundSkillEffectPlayers[self.playerRounds[self.index].attacker] ~= 1

			end
			-- 如果是替补上场那么不能提前触发
			if(self.playerRounds[self.index] and self.playerRounds[self.index].arrBench~= nil) then
				canPreStart = false
			end
			-- 如果下一回合还是自己,那么不能提前触发
			if(self.playerRounds[self.index] and self.playerRounds[self.index + 1] and 
			   self.playerRounds[self.index].attacker ==  self.playerRounds[self.index + 1].attacker ) then
				canPreStart = false
			end


			-- 这里会多传入下一个回合的数据,为了判断是否可以提前执行下一回合
			round:reset(self.playerRounds[self.index],canPreStart)
			self.index = nextIndex
			 
			return round
		end

		return nil
	end

	-- 返回 大回合_攻击者索引
	function BattleDataADT:getNextRoundAttackerStringInfo( ... )

			local nextBigRound = -1
			local attackerPostion = -1

		if(self.playerRounds[self.index] ~= nil) then -- 如果有数据

			nextBigRound = self.playerRounds[self.index].round
			attackerid = self.playerRounds[self.index].attacker
			local attacker = self:getTargetData(attackerid)
			if(attacker) then
				attackerPostion = attacker:getGlobalIndex()
			end
 
			 
		end

		return nextBigRound .. "_" .. attackerPostion
	end
	-- 获取下一个数据的回合数
	function BattleDataADT:getNextRoundNumber( ... )
		
		if(self.playerRounds[self.index] ~= nil) then -- 如果有数据
			return self.playerRounds[self.index].round
		end

		return 0
	end

	-- 获取替补上场数据
	function BattleDataADT:getBenchOnFormation( ... )
		local benchFinalState = {}
		local round = require(BATTLE_CLASS_NAME.BattlePlayerRoundData).new()
		for k,v in pairs(self.playerRounds) do
			round:reset(v)
			round:refreshBenchMap(benchFinalState)
		end

		return benchFinalState
	end

	function BattleDataADT:getFinalDamageMap()
		local result = {}
		local benchFinalState = {}
		local round = require(BATTLE_CLASS_NAME.BattlePlayerRoundData).new()
		for k,v in pairs(self.playerRounds) do
			round:reset(v)
			round:refreshDamageMap(result)
			round:refreshBenchMap(benchFinalState)
		end

		-- for k,v in pairs(result) do
		-- 	print("====getFinalDamageMap ",k,"value:",v[1])
		-- end
		return result,benchFinalState
	end

	function BattleDataADT:haveNextRoundData()
		local nextIndex = self.index + 1
		if self.playerRounds[nextIndex] ~= nil then
			return true
		end 
		return false
	end
	-- 设置战斗环境变量
	function BattleDataADT:setPlayerRounds( data )
		
		self.playerRounds 	= data.battle
		self.total 			= #data.battle
		--print("BattleDataADT:setPlayerRounds  total:",self.total)
 
	end
 

	-- 设置战斗环境变量
	function BattleDataADT:setEnviroment( data )
		
		self.enviroment = require(BATTLE_CLASS_NAME.BattleEnvironment).new()
		self.enviroment:reset(data)
		self.brid = data.brid
		BattleState.setBrid(self.brid)

	end
	function BattleDataADT:getTargetData( id )
		 return idToData[tonumber(id)]
	end
	-- 获取指定目标全局索引(0-- 11)
	function BattleDataADT:getTargetPostionGlobalIndex( id )
		local  targetData  = getTargetData(id)
		local index = nil
		if(targetData) then
			return  targetData:getGlobalIndex()
		end

		return nil
	end

	-- 获取指定位置索引的英雄列表([0,11])
	function BattleDataADT:getPlayDataByPositionList(list)
		local result = {}
		local item = nil
		for k,index in pairs(list or {}) do
			if(index >= 0 and index <= 11) then

				if(index < 6) then
					item = self:indexTeam1PlayerDataByPosition(index)
				else
					index = index - 6
					item = self:indexTeam2PlayerDataByPosition(index)
				end
				
				if(item ~= nil) then
					table.insert(result,item)
				end
			end

		end

		return result
	end
	-- 通过位置和队伍id获取指定人物数据
	function BattleDataADT:indexDataByIndexAndTeamid(index, teamid )
		if(teamid == BATTLE_CONST.TEAM1) then
			return self:indexTeam1PlayerDataByPosition(index)	
		end
		return self:indexTeam2PlayerDataByPosition(index)
	end
	-- 获取队伍索引英雄
	function BattleDataADT:indexTeam1PlayerDataByPosition( index )
		if(self.team1Info) then
			return self.team1Info:indexPlayerByPosition(index)
		end
	end

	function BattleDataADT:indexTeam2PlayerDataByPosition( index )
		if(self.team2Info) then
			return self.team2Info:indexPlayerByPosition(index)
		end
	end

	-- 获取队伍1所有队员
	function BattleDataADT:getTeam1PlayerData( ... )
		return self.team1Info.positions
	end

	function BattleDataADT:getTeam2PlayerData( ... )
		return self.team2Info.positions
	end
	
	function BattleDataADT:getTeam1LeaderName( ... )
		return self.team1Info.teamName
	end

	function BattleDataADT:getTeam2LeaderName( ... )
		return self.team2Info.teamName
	end

	function BattleDataADT:refreshIDList( ... )
		idToData	   		= {}
		idToShipData 		= {}
		for k,v in pairs(self.team1Info.list) do
			idToData[tonumber(k)]		= v
		end

		for k,v in pairs(self.team1Info.benchList.list or {}) do
			idToData[tonumber(k)]		= v
		end

		-- print("---- ",
		-- -- 掉落碎片
		for k,v in pairs(self.team2Info.list) do
			 idToData[tonumber(k)]		= v
		end

		for k,v in pairs(self.team2Info.benchList.list or {}) do
			idToData[tonumber(k)]		= v
		end

		if(self.team1Info.shipData) then
			idToShipData[self.team1Info.shipData.shipid] = self.team1Info.shipData
		end

		if(self.team2Info.shipData) then
			idToShipData[self.team2Info.shipData.shipid] = self.team2Info.shipData
		end

	end
	--设置队伍信息
	function BattleDataADT:setTeamInfo(data)
		
		self.team1Info 		= require(BATTLE_CLASS_NAME.BattleTeamInfo).new()
		self.team1Info:reset(data.team1,BATTLE_CONST.TEAM1)
		self.team1Info:handleDeadSkills(data)

		self.team2Info 		= require(BATTLE_CLASS_NAME.BattleTeamInfo).new()
		self.team2Info:reset(data.team2,BATTLE_CONST.TEAM2)
		self.team2Info:handleDeadSkills(data)
		self:refreshIDList()

	end

	--设置结束画面相关数据
	function BattleDataADT:setBattleResult( data )
		
		self.result    = require(BATTLE_CLASS_NAME.BattleResultData).new()
		self.result:reset(data)

		-- 评价
		self.appraisal				= data.appraisal

		-- 是否胜利
		self.isWin 					= string.lower(data.appraisal) ~= "f" and string.lower(data.appraisal) ~= "e"

		-- 奖励信息
		self.reward 				= data.reward or {}
		
		self.extra_reward 			= data.extra_reward

		--
		if(data.newcopuorbase) then
			self.copyCallBackData 	= data.newcopuorbase
		end
		
		-- self.score 					= data.getscore

		
	end

	function BattleDataADT:getPlayersDamageMap( ... )
		local map = {team1={},team2={}}

		
		local damageMap = {}
		local round = require(BATTLE_CLASS_NAME.BattlePlayerRoundData).new()
		for k,v in pairs(self.playerRounds) do
			round:reset(v)
			round:getAttackerDamage(damageMap)
		end
 		local damage = nil
 		 
 		for k,v in pairs(self.team1Info.rawFormation or {}) do
 			if(damageMap[v.id] == nil) then
 				damage = {reduceHP=0,addHP=0}
 			else
 				damage = damageMap[v.id]
 			end
 			Logger.debug("== getPlayersDamageMap 1:" .. tostring(v.htid))
			map.team1[tostring(v.htid)]  = damage
		end

		for k,v in pairs(self.team1Info:getBenchsList() or {}) do
 			if(damageMap[v.id] == nil) then
 				damage = {reduceHP=0,addHP=0}
 			else
 				damage = damageMap[v.id]
 			end
 			Logger.debug("== getPlayersDamageMap 2:" .. tostring(v.htid))
			map.team1[tostring(v.htid)]  = damage
		end


		local htid = 1
		for k,v in pairs(self.team2Info.list or {}) do
			if(damageMap[v.id] == nil) then
 				damage = {reduceHP=0,addHP=0}
 			else
 				damage = damageMap[v.id]
 			end
 			htid = BattleDataUtil.getHtid(v.id,v.htid)
			map.team2[tostring(htid)]  = damage
		end


		for k,v in pairs(self.team2Info:getBenchsList() or {}) do
 			if(damageMap[v.id] == nil) then
 				damage = {reduceHP=0,addHP=0}
 			else
 				damage = damageMap[v.id]
 			end
 			htid = BattleDataUtil.getHtid(v.id,v.htid)
			map.team2[tostring(htid)]  = damage
		end
		
		if(self.team2Info.uid == UserModel.getUserUid()) then
			map.selfTeam = 2
		elseif(self.team1Info.uid == UserModel.getUserUid()) then
			map.selfTeam = 1
		else
			map.selfTeam = nil
		end
		if(self.isfollowRole == true) then
			local n = nil
			if(map.selfTeam == 1) then
				n = 2
			elseif(map.selfTeam == 2) then
				n = 1
			end
			return {team1=map.team2,team2=map.team1,selfTeam = n}
		end
		-- print("====================== getPlayersDamageMap")
		-- print_table("tb",map)
		
		return map
 
	end
	-- 激活替补数据(注意需要提前生成好display数据,因为会自动去链接)
	function BattleDataADT:activeBenchData(hid,position,teamid )
		assert(hid,"BattleDataADT:activeBenchData error: hid is nil")
		assert(position,"BattleDataADT:activeBenchData error: position is nil")
		assert(teamid,"BattleDataADT:activeBenchData error: teamid is nil")

		local teamData = nil
		if(tonumber(teamid) == BATTLE_CONST.TEAM1) then
			teamData = self.team1Info
		else
			teamData = self.team2Info
		end

		teamData:enableBenchPlayer(hid,position)

	end

	function BattleDataADT:stopAllPlayerAction( ... )
		if(self.team1Info) then
			self.team1Info:resetPlayersAction()
		end
		
		if(self.team2Info) then
			self.team2Info:resetPlayersAction()
		end

	end

	-- 跳到最终状态
	function BattleDataADT:toEndState( ... )
			
			-- 获取替补上场情况,获取伤害信息
			local damageMap,benchState = self:getFinalDamageMap()
			-- 停止所有对象
			for k,targetData in pairs(self.idToData or {}) do
				targetData:release()
			end

			


			-- 将最终在场上的替补激活
			local targetData
			for pos,id in pairs(benchState or {}) do
				targetData = self:getTargetData(tonumber(id))
				if(targetData) then
					-- 激活ui
					local displayData = targetData:getCardDisplayData()
					if(displayData) then
						displayData:reset(displayData.hid,displayData.htid,pos,targetData.teamId)
						BattleTeamDisplayModule.activeNewPlayer(displayData,pos,targetData.teamId)
					end
					-- 激活数据
					self:activeBenchData(id,pos,targetData.teamId)
				end

			end

			for k,v in pairs(damageMap or {}) do
				local target = BattleMainData.fightRecord:getTargetData(k)
				assert(target,"ADT:未发现id:".. tostring(k))
				target:toState(v[1])
				-- print("----- BattleDataADT:toEndState",k,v[1])
				-- target:resetActions()
			end

			BattleTeamDisplayModule.toStartPosition()
	end

	-- function BattleDataADT:resetToRawFomation( ... )
	-- 	if(self.team1Info) then
	-- 		self.team1Info:resetToRawFomation()
	-- 	end

	-- 	if(self.team2Info) then
	-- 		self.team2Info:resetToRawFomation()
	-- 	end

	-- end



 
 return BattleDataADT