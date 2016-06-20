

local BattleArmyData = class("BattleArmyData")
	-- army
			-- 1.队伍显示名臣
			-- 2.队伍类型（是否是npc）
			-- 3.对话，音乐 dialog_scene_over
			-- 4.战斗展现模式
			-- 5.teamid(team包含了具体队伍成员信息)
	-- team
			-- 	1.队伍成员id列表
			-- 	2.成员是否是boss
			-- 	3.成员是否是魔王
			-- 	4.成员使用卡片底

		-- hero or monster
					--		额外继承：是否是boss，是否是魔王，是否使用卡片底(从team中获取)
 --monsterIdArray {单位在阵型中的索引:{isBoss=true,isDemon=true,isOutLine=true}}
 --注意这里的 selfTeamDataArray，armyTeamDataArray索引是从1开始的 不是 0

 -- npc更新规则:
 --				1.如果当前army木有指定npc部队,那么就引入上一次npc列表
 --				2.如果当前army有指定npc部队,则上一次上场的npc全部被下场.
 --				好蛋疼的规则啊 !!!

 -- 使用前请先 refresh一下
	------------------ properties ----------------------
	
	BattleArmyData.name									= nil			-- 队伍名字
	BattleArmyData.id									= nil			-- id
	BattleArmyData.isNpc								= nil			-- 是否是npc
	BattleArmyData.startTalkid							= nil 			-- 开始对战前的对话
	
	BattleArmyData.completeTalkid						= nil			-- 对战结束对话
	BattleArmyData.fightingTalksMap						= nil			-- 战斗中对话

	BattleArmyData.afterTalkMusic						= nil			-- 对话完成后播放音乐
	BattleArmyData.afterTalkBackGround					= nil			-- 对话完成后背景更换为
	--BattleArmyData.showWay								= "" 			
	BattleArmyData.teamid 								= 0				-- teamid
	BattleArmyData.playerShowWay						= 0				-- 玩家出场方式


	BattleArmyData.selfNpcIdArray						= nil			-- 己方npc队伍 id array
	BattleArmyData.selfNpcDataArray						= nil			-- 己方npc队伍 data array(index是站位索引 从1开始)
	BattleArmyData.selfNpcToServerArray					= nil 			-- 服务器交互用(npc队伍阵型)

	BattleArmyData.selfNpcList							= nil 			-- 己方npc表(不包含主角) 类型:数组,元素值:BattleObjectCardUIData,索引值postionIndex
	BattleArmyData.selfNpcNum							= nil 			-- 己方npc数量(不包含主角)

	BattleArmyData.monsterIdArray						= nil			-- 敌方monster id表
	BattleArmyData.monsterDataArray						= nil			-- 敌方monster data array(index是站位索引 从1开始)


	BattleArmyData.selfTeamDataArray					= nil
	BattleArmyData.armyTeamDataArray					= nil

	BattleArmyData.armyTeamSoldiers						= nil			-- team2除boss外的小兵
	BattleArmyData.armyTeamBosses						= nil 			-- team2的boss列表	
	-- armyTeamSoldiers +  armyTeamBosses = armyTeamDataArray

	BattleArmyData.printDebug 							= true			-- 是否打印

	BattleArmyData.index								= 0				-- 此army数据在stronghold中总战斗中的索引
	BattleArmyData.total 								= 0				-- stronghold中总战斗次数
	BattleArmyData.refresWay							= 0
	BattleArmyData.inheritLastFightState 				= nil			-- 是否使用上一场战斗的人物状态 废弃
	BattleArmyData.dataRequested		 				= nil		 
	------------------ functions -----------------------
	function BattleArmyData:printSelfNpcList( ... )
		for k,v in pairs(self.selfNpcList or {}) do
			--print("postion:",k," htid:",v.htid)
		end
	end
	function BattleArmyData:getFightingTalks( ... )
		-- print("getFightingTalks fightingTalksMap 1:")
		-- for k,v in pairs(self.fightingTalksMap or {}) do
		-- 	print(k,v)
		-- end
		if(self.fightingTalksMap) then
			local copy = {}

			-- setmetatable(copy, getmetatable(self.fightingTalksMap))
			-- print("getFightingTalks copy 2:")
			for k,v in pairs(self.fightingTalksMap or {}) do
				copy[k] = v
			end

			return copy
		end
		return nil
	end
	-- 获取对话信息[开始,战斗中,结束]
	function BattleArmyData:getTalksInfo( ... )
		local result = {}
		result.fightingTalks = self:getFightingTalks()
		result.startTalkid 	 = self.startTalkid
		result.completeTalkid= self.completeTalkid
		return result
	end
	function BattleArmyData:refresh( )
	 	self:reset(self.id)
	end	

	function BattleArmyData:team1HasActionId( heroImgName )
		
		for k,cardUIData in pairs(targets or {}) do
			if(cardUIData.heroImgName == actionid) then return true end
		end
		return false
	end

	function BattleArmyData:team1HasHtid( htid )
		return self:isTargetsHasHtid(self.selfTeamDataArray,htid)
	end

	function BattleArmyData:team2HasHtid( htid )
		return self:isTargetsHasHtid(self.armyTeamDataArray,htid)
	end

	function BattleArmyData:isTargetsHasHtid( targets,htid )

		-- if(type(targets) == "string") then
		-- 	--print("=============== isTargetsHasHtid: targets is string======================")
		-- 	--print(debug.traceback())
		-- 	--print("===========================================================")
		 
		-- end
		for k,cardUIData in pairs(targets or {}) do
			if(cardUIData.htid == htid) then return true end
		end
		return false
	end

	function BattleArmyData:indexTeam2ByHid(hid)
		for k,cardUIData in pairs(self.armyTeamDataArray or {}) do
			if(cardUIData.hid == hid) then return cardUIData end
		end
		return nil
	end
	-- 是否真正包含npc人物(己方除了自己外的npc)
	function BattleArmyData:hasNPCHeroInSelf()
		return self.selfNpcList and self.selfNpcNum > 0
	end


	function BattleArmyData:reset( id )
		self.dataRequested 								= false
		self.id 										= tonumber(id)
		--print("====== BattleArmyData: id:",self.id)
		-- team name
		self.name 										= db_army_util.getName(id)
		--print("====== BattleArmyData: name:",self.name)
		-- teamid 
		self.teamid										= db_army_util.getTeamid(id)

		-- is npc
		self.isNpc										= db_army_util.isNPC(id)
		--print("====== BattleArmyData: isNpc:",self.isNpc)
		-- get the player team show way when start battle
		self.playerShowWay								= db_army_util.getPlayerShowWay(id)

		-- start talk id
		self.startTalkid								= db_army_util.getStartTalkid(id)

		self.completeTalkid 							= db_army_util.getCompleteTalkid(id)
		
		if(self.completeTalkid) then
			Logger.debug("armyid:"..self.id.. "completeTalkid:".. self.completeTalkid)
		else
			Logger.debug("armyid:"..self.id.. "木有 completeTalkid")
		end
		
		self.fightingTalksMap							= db_army_util.getFightingTalks(id)		
		
		-- after talk music
		self.afterTalkMusic								= db_army_util.getAfterTalkMusicChange(id)

		-- after talk backGroud
		self.afterTalkBackGround						= db_army_util.getAfterTalkChangeBackGround(id)

		self.monsterIdArray 							= db_team_util.getMonsterIDArray(self.teamid)
		self.monsterDataArray							= self:generateData(self.teamid,self.monsterIdArray)

		if(self.playerShowWay >= 3) then
			self.showWayPara 							= db_army_util.getShowWayParas(id)
		end
		

		-- init self npc
		if self.isNpc then
			-- local printaction =  self.printDebug and self.printDebug and --print("************************************	is npcArmy")
			local npcid 								= db_army_util.getNPCTeamid(id)
			self.selfNpcIdArray							= db_team_util.getMonsterIDArray(npcid)
			self.selfNpcDataArray						= self:generateData(npcid,self.selfNpcIdArray)
			--BattleObjectData
		end

		----- 初始化显示数据
		--
		self.selfTeamDataArray							= {}
		self.armyTeamDataArray							= {}

		-- 初始化己方npc列表
		self.selfNpcList								= {}
		self.selfNpcNum									= 0

			local displayData --(hid,htid,postion,teamid)
			local postion
			local playerTeamProperty
			--初始化玩家显示数据
			if self.isNpc then --如果玩家是npc，则用npc数据初始化 玩家数据
				self.inheritLastFightState				= false
				-- local printaction =  self.printDebug and --print("@@@				isnpc")
				-- for k,v in pairs(self.selfNpcIdArray) do
				-- 	--print("xx create npc team  displayData:",v)
				-- end
			 	-- 注意坑: selfNpcIdArray 的索引从1开始
			 	self.selfNpcToServerArray = {}
				for key,value in pairs(self.selfNpcIdArray) do
					postion 							= tonumber(key) - 1
					self.selfNpcToServerArray[postion] 	= value
					if value ~= nil and tonumber(value - 1) >= 0   then
						
						playerTeamProperty 					= self.selfNpcDataArray[key]
						if playerTeamProperty == nil then
							playerTeamProperty 				= {}
						end -- if end
						
						displayData 						= require("script/battle/data/BattleObjectCardUIData").new()
						displayData.isBoss					= playerTeamProperty.isBoss
						displayData.isDemon					= playerTeamProperty.isDemon
						displayData.isOutline				= playerTeamProperty.isOutline
						displayData.isSuperCard				= playerTeamProperty.isSuperCard
						-- 如果不是玩家
						--print("create npc team  displayData:",value)
						if tonumber(value) ~= BATTLE_CONST.PLAYER_NPC_ID then -- 如果不是玩家
							displayData:reset(
												value, -- 如果不是玩家 hid = htid
												value,  
												postion,
												BATTLE_CONST.TEAM1
											)
							self.selfNpcNum 			= self.selfNpcNum + 1
							self.selfNpcList[postion] 	= displayData
						else
							displayData:reset(	
												HeroModel.getNecessaryHero().hid, -- 这里的hid只是用来判断是hero还是monster，所以用了默认的hid
												UserModel.getUserInfo().htid,
												postion,
												BATTLE_CONST.TEAM1
											 )
							self.selfNpcToServerArray[postion] 	= HeroModel.getNecessaryHero().hid
						end -- if end


						-- local printaction =  self.printDebug and --print("@@@				 postion:",key) 
						self.selfTeamDataArray[tonumber(postion)]	= displayData

					end -- if end
					-- --print("selfNpcToServerArray:",postion,self.selfNpcToServerArray[postion])
				end -- for end
			
			else -- 如果不是，则用服务器的阵型数据 + 本地英雄缓存]
				self.inheritLastFightState 				= true
				self:refreshPlayerTeamFromCacheData()
				--local printaction =  self.printDebug and --print("@@@-----------------------------------------------------				  scNum:",scNum)
			end -- if end


			self.armyTeamSoldiers 						= {}
			self.armyTeamBosses 						= {}
			--
				-- for k,v in pairs(self.monsterDataArray) do
				-- 			print("monsterDataArray:",k,v.isBoss)
				-- end

			----- 初始化敌方显示数据
			--   注意坑: monsterIdArray 的索引从1开始
			-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------				monsterIdArray data len：",#self.monsterIdArray)
			for key,value in pairs(self.monsterIdArray) do
					postion = tonumber(key - 1) 
					if value ~= nil and value > 0 then
						Logger.debug("monsterIdArray:" .. key )
						playerTeamProperty 				= self.monsterDataArray[tostring(key)]
					
						if playerTeamProperty == nil then
							playerTeamProperty 			= {}
						end -- if end
						-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------monsterIdArray data->hid:",value)
						displayData 					= require("script/battle/data/BattleObjectCardUIData").new()
						displayData.isBoss				= playerTeamProperty.isBoss
						displayData.isDemon				= playerTeamProperty.isDemon
						displayData.isOutline			= playerTeamProperty.isOutline
						displayData.isSuperCard			= playerTeamProperty.isSuperCard

						-- displayData 					= require("script/battle/data/BattleObjectCardUIData").new()
						displayData:reset(
												value, -- 如果不是玩家 hid = htid
												value,  
												postion,
												BATTLE_CONST.TEAM2
					 					)
						-- local printaction =  self.printDebug and --print("@@@			monster 	 postion:",key) 
					 	self.armyTeamDataArray[tonumber(postion)]	= displayData
					 	-- 如果不是士兵
					 	if(playerTeamProperty.isBoss or playerTeamProperty.isDemon or playerTeamProperty.isOutline) then
					 		table.insert(self.armyTeamBosses,displayData)
					 	else
					 		table.insert(self.armyTeamSoldiers,displayData)
					 	end
					 end -- if end
			end	-- for end

	end -- function end
	
	-- 从cacheData中刷新玩家队伍信息
	function BattleArmyData:refreshPlayerTeamFromCacheData()

			-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------				local data")
			local scNum = 0
			  	-- 注意坑: scPlayerFormation 的索引从0开始
			  	
				-- for i,v in pairs(BattleMainData.scPlayerFormation or {}) do
				for i,v in pairs(FormationModel.getFormationInfo() or {}) do
					scNum = scNum + 1
					postion = tonumber(i)
					if v ~= nil and tonumber(v) > 0   then
						-- 获取本地缓存数据
						local localHero					= HeroModel.getHeroByHid(v)
						if localHero~=nil then
					 		displayData 					= require("script/battle/data/BattleObjectCardUIData").new()
					 		-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------local data->hid:",
					 			-- localHero.hid,
					 			-- " htid:",localHero.htid)
					 		displayData:reset(
					 							localHero.hid 		,
					 							localHero.htid 		,
					 							postion				,
					 							BATTLE_CONST.TEAM1
					 						 )
					 		self.selfTeamDataArray[tonumber(i)]	= displayData
					 	else 
					 		-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------not find:",v)
					 	end-- if end
					else
						--error("BattleArmyData:refreshPlayerTeamFromCacheData-> v == nil or tonumber(v) ")
						-- local printaction =  self.printDebug and --print("@@@-----------------------------------------------------scPlayerFormation:",i,",",v)
					end -- if end

				end	-- for end

	end -- function end

	function BattleArmyData:iniDisplayData(  )
		
	end
	 --  获取指定位置人的 数据
	 function BattleArmyData:getObjectInfo(teamid,positon)
	 	-- is player team
	 		--如果玩家是npc则读取数据
	 	if teamid == BATTLE_CONST.TEAM1 then
	 		if self.isNpc then 
	 			return self.selfNpcDataArray[positon]
	 		else
	 			return nil
	 		end
	 	else -- 如果是敌军队伍
	 		return self.monsterDataArray[positon]
	 	end
	 end
 function BattleArmyData:generateData( teamid ,idArray)
			-- --print("											")
			--print("BattleArmyData:generateData -> teamid:",teamid,"idArray:",idArray)
			local bossMarkMap 								= db_team_util.getBossIDMap(teamid)
			local demonMarkMap 								= db_team_util.getDemonLoadIdMap(teamid)
			local outlinMarkMap 							= db_team_util.getOutlineIdMap(teamid)
			local superCardMarkMap 							= db_team_util.getSuperCardIdMap(teamid)
			local result 									= {}
			for i,v in ipairs(idArray) do

				local positon 								= tostring(i)
				 result[positon]							= {}
				 -- boss属性
				 if bossMarkMap ~= nil then
				  	result[positon].isBoss					= bossMarkMap[tonumber(v)] == true

				 else
				 	result[positon].isBoss 					= false
				 end-- if end
				 Logger.debug("isBoss:" .. tostring(result[positon].isBoss))
				 if(demonMarkMap and demonMarkMap[tonumber(v)]) then
				 	Logger.debug("isDemon:" .. tostring(demonMarkMap[tonumber(v)]))
				 else
				 	Logger.debug("isDemon:false")
				 end
				 --魔王(2倍黑卡,三国遗留,暂时不用)
				 if demonMarkMap ~= nil then
				  	result[positon].isDemon					= demonMarkMap[tonumber(v)] == true
				 else
				 	result[positon].isDemon 				= false
				 end-- if end
				  -- --print("isDemon:",result[positon].isDemon)

				 -- super cards
				 if superCardMarkMap ~= nil then
				 	result[positon].isSuperCard					= superCardMarkMap[tonumber(v)] == true
				 else
				 	result[positon].isSuperCard 				= false
				 end

				 --是否用卡牌
				 if outlinMarkMap ~= nil then
				  	result[positon].isOutline				= outlinMarkMap[tonumber(v)] == true
				 else
				 	result[positon].isOutline 				= false
				 end -- if end
				  -- --print("isOutLine:",result[positon].isOutLine)
			end -- for end

			-- --print("————————————————————————————————————————————————")
			return result
	end 

	-- 返回阵型索引位置上的team属性（isBoss,isDemon,isOutLine)
	function BattleArmyData:getIndexData( index )
		return self.monsterDataArray[index]
	end

	return BattleArmyData
 
