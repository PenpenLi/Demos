
--队伍数据： 包含队伍基础信息和成员信息
local BattleTeaminfo = class("BattleTeaminfo")

 -- 	name : string  		//用户或者怪物小队名字 TODO怪物小队名字是否可以让前端自己获得
	-- uid : int			//用户uid
	-- level : int
	-- totalHpCose : int	//小队失血总和
	-- isPlayer : bool		//是否是玩家
	-- arrHero
	------------------ properties ----------------------
	-- 队伍名称
	BattleTeaminfo.teamName 	= nil
	-- uid
	BattleTeaminfo.uid			= nil

	BattleTeaminfo.level		= nil

	-- BattleTeaminfo.maxHp		= nil

	-- BattleTeaminfo.currHp		= nil

	BattleTeaminfo.totalHpLost 	= nil

	BattleTeaminfo.isPlayer		= nil

	BattleTeaminfo.list			= nil -- key:hid value:BattleObjectData 

	BattleTeaminfo.number		= 0
	BattleTeaminfo.positions 	= nil

	BattleTeaminfo.benchList	= nil -- 替补列表

	BattleTeaminfo.benchActiveList 			= nil -- 替补替换下来的列表
	-- BattleTeaminfo.benchActiveListByPosition = nil -- 替补替换下来的列表
	BattleTeaminfo.benchActiveNum			= 0 -- 替补上场数量

	BattleTeaminfo.benchReplacedList 		= nil
	BattleTeaminfo.rawFormation 			= nil
	BattleTeaminfo.rawFormationPositions 	= nil
	BattleTeaminfo.rawData 					= nil
	BattleTeaminfo.teamid 					= nil
	BattleTeaminfo.shipData 				= nil
	BattleTeaminfo.userColor 				= nil
	------------------ functions -----------------------
	-- 检测每个人得死亡技能是否被触发
	function BattleTeaminfo:handleDeadSkills( data )
		-- hasDeadSkill
		local deadSkillMap = {}
			-- 初始化个人属性
		-- for id,playerdata in pairs(self.list) do
		for id,playerdata in pairs(self.list) do
			if(playerdata:hasDeadSkill() == true) then
				deadSkillMap[id] = playerdata.deadSkill
			end
		end
		-- 遍历战斗数据 检测是否这个人的死亡技能是否被触发
		if(data and data.battle and #data.battle > 0) then
			local total 			= #data.battle
			-- 替补出现
			local benchinfo 		= {}
			for i=1,total do
				local bench    = data.battle[i].arrBench
				if(bench) then
					for k,benchData in pairs(bench) do
						-- 这里没有用table存储,因为死亡技能引相关的替补上场肯定是离当前技能最近的一个替补上场
						local bencher = self.benchList:indexByHid(benchData.id)
						-- 只有自己队伍的替补才会被记录
						if(bencher) then
							benchinfo[tostring(benchData.pos)] = {i,bencher}
						end
						-- table.insert(benchinfo[benchData.pos],i)
						-- benchinfo[benchData.pos] = {i}
					end
				end

				local attacker = tonumber(data.battle[i].attacker)
				local attackerSkill = tonumber(data.battle[i].action)
				for id,skill in pairs(deadSkillMap) do
					-- 如果是这个人释放了技能
					if(attacker == tonumber(id) and tonumber(skill) == attackerSkill) then
						local target = self.list[tostring(id)]
						if(target) then
							target:setDeadSkillState(true)
							-- 如果死亡技能释放者位置有替补上场
							local bench = benchinfo[tostring(target.positionIndex)]
							if(bench) then
	
								-- 这里改动battle数据是因为策划需要死亡技能释放后才能替补上场,但是替补上场数据已经在人物濒死时携带了(后端不好改),所有需要将替补数据做个处理
								-- sb设定,以后不做没有技能体系的战斗了,太累!
								-- ps:魔法! 勿动!
	
								-- 将死濒死处替补数据删除
							 	local benRawData = data.battle[bench[1]].arrBench
							 	data.battle[bench[1]].arrBench = nil
							 	if(data.battle[i].arrBench == nil) then
							 		data.battle[i].arrBench = {}
							 	end
							 	-- 将替补数据插入到死亡技能处
							 	for k,v in pairs(benRawData) do
							 		table.insert(data.battle[i].arrBench,v)
							 	end
							 	
							 	 
							end
						end

					end
				end

			end
		end
		

	end


	function BattleTeaminfo:reset( data , teamid)
		--print("BattleTeaminfo:reset data->",data," teamid->",teamid)
		
		self.teamid 					= teamid
		self.rawData					= data
		self.uid						= data.uid
		self.level						= data.level
		self.totalHpLost				= data.totalHpCose
		self.isPlayer					= data.isPlayer
		self.list						= {}
		self.positions 					= {}
		self.rawFormationPositions 		= {}
		self.teamName 					= data.name
		self.benchReplacedList 			= {}
		self.rawFormation				= {}
		self.benchActiveList 			= {}
		-- 初始化玩家品质框颜色(用于显示主船信息ui中的玩家名字颜色)
		self.figure 					= data.figure
		if(self.figure and self.figure ~= nil and self.figure > 0) then
			self.userColor = UserModel.getPotentialColor({htid = self.figure,bright = true})
		else
			self.userColor =  g_QulityColor[1]
		end
		
		-- g_QulityColor[1]
		-- 如果是npc队伍
		if(not self.isPlayer) then

			require "script/module/arena/ArenaData"
		    -- local uid = math.floor((id - 11001)/2)
		    local utid = self.uid%2 + 1
		    self.teamName = ArenaData.getNpcName( self.uid, utid )
		    -- Logger.debug("getTargetNameByUid result = %s,uid:%d, utid:%d",self.teamName,self.uid,utid)

			 -- = ObjectTool.getTargetNameByUid(tonumber(self.uid))
			
		end

		assert(self.teamName,"team:" .. tostring(self.teamid) .. " name is null")
		-- Logger.debug("team is npc:%s teamName:%s",tostring(not self.isPlayer),self.teamName)
		if(teamid == BATTLE_CONST.TEAM1) then
			BattleMainData.team1LeaderName = self.teamName
		else
			BattleMainData.team2LeaderName = self.teamName
		end

		-- 初始化替补信息
		self.benchList 					= require(BATTLE_CLASS_NAME.BattleBenchListData).new()
		self.benchList:reset(data,teamid)

		self.benchActiveList 			= {}
		-- self.benchActiveListByPosition	= {}
		self.benchActiveNum 			= 0

		if(data.ship ~= nil) then
			self.shipData 					= require(BATTLE_CLASS_NAME.BattleShipData).new()
			self.shipData:reset(data.ship,teamid)
		else
			self.shipData 					= nil
		end
		
		-- 初始化个人属性
		for k,v in pairs(data.arrHero) do
			self.number 	= self.number + 1
			local playerdata 		= require(BATTLE_CLASS_NAME.BattleObjectData).new()
			
			-- playerdata.loadNameFromDB = not self.isPlayer
			playerdata:reset(v,teamid)
			self.list[tostring(playerdata.id)]= playerdata
			self.rawFormation[tostring(playerdata.id)] = playerdata
			self.positions[tonumber(playerdata.positionIndex)] = playerdata
			self.rawFormationPositions[tonumber(playerdata.positionIndex)] = playerdata
		end
	end
	-- 重置到原始数据(当前阵型数据会被还原到原始阵型,数据状态不变)
	function BattleTeaminfo:resetToRawFomation()
		self.list = ObjectTool.deepcopy(self.rawFormation)
		self.positions = ObjectTool.deepcopy(self.rawFormationPositions)
		self.benchActiveList = {}
		self.benchActiveNum = 0
	end

	function BattleTeaminfo:release( ... )
		-- 释放人物数据
		if(self.positions) then
			for k,v in pairs(self.positions) do
				if(v ~= nil) then v:release() end
			end
			self.positions 				= {}
		end

		if(self.list) then
			self.list 					= {}
		end

		self.rawFormation 				= {}
		self.rawFormationPositions 		= {}
		self.benchActiveList 			= {}
		-- 释放替补数据
		self.benchList:release()

	end

	function BattleTeaminfo:getHpLost()
		local result = 0
		local max = 0
		for k,targetData in pairs(self.list or {}) do
			result = result + targetData:getHpLost()
			max    = max + targetData.maxHp
		end
		return result,max
	end

	function BattleTeaminfo:resetToStart( ... )

		-- self.teamid 					= teamid
		-- self.rawData					= data
		-- self:resetToRawFomation()
		-- for k,targetData in pairs(self.list) do
				-- targetData:toStartState()
		-- end
		self:reset(self.rawData,self.teamid)
	end
	-- 设置死亡英雄为ghost
	function BattleTeaminfo:setDieToGhost( ... )
		for k,playerdata in pairs(self.list or {}) do
			playerdata:toGhostState()
		end
	end
	function BattleTeaminfo:linkAndRefreshHeroesDisplay()
		
		for k,playerdata in pairs(self.list or {}) do
			playerdata:linkDisplay()
			playerdata:refreshRageUI()
		end
	end

	function BattleTeaminfo:reviveAll( ... )
		for k,playerdata in pairs(self.positions or {}) do
			playerdata:linkDisplay()
			playerdata:refreshRageUI()
		end
	end


	-- 获取显示数据
	function BattleTeaminfo:getCardDisplayDataList()
		local result = {}
		for k,v in pairs(self.positions or {}) do
			table.insert(result,v:getCardDisplayData())
		end
		return result
	end

	function BattleTeaminfo:getBenchsList( ... )

		local displayList = {}
		if(self.benchList) then
			for k,targetData in pairs(self.benchList.list or {}) do
				-- for k,v in pairs(self.team2DisplayData or {}) do
				local disData = BattleDataUtil.getBenchDisplayData(targetData)
				table.insert(displayList,disData)
				-- end
			end

		table.sort(displayList,function(a,b) if(a and b) then
											return tonumber(a.pos) < tonumber(b.pos)
										end end)				
		end
		return displayList
	end
	-- 获取所有死亡英雄数据(包含替补)
	function BattleTeaminfo:getAllDeadList( ... )
		local result 				= {}
		for index,heroData in pairs(self.list or {}) do
			if(heroData:isDead()) then
				-- result[index] = index
				table.insert(result,heroData)
			end
		end
		if(#result > 0) then
			return result
		end
		return nil
	end

	-- 获取死亡列表(不包含替补)
	function BattleTeaminfo:getRawPlaysDeadList( ... )
		 	local result 				= {}
		for index,heroData in pairs(self.list or {}) do
			if(heroData:isDead() and not heroData.isBench == true) then
				-- result[index] = index
				table.insert(result,heroData)
			end
		end
		if(#result > 0) then
			return result
		end
		return nil
	end
	-- 获取当前阵上活着的英雄
	function BattleTeaminfo:getAliveBenchList()
		local result 				= {}
		for index,heroData in pairs(self.positions or {}) do
			if( heroData.isBench == true and  heroData:isDead() ~= true) then
				table.insert(result,heroData)
			end
		end
		Logger.debug("-- getAliveBenchList:%d",#result)
		return result
	end

	function BattleTeaminfo:resetPlayersAction( ... )
		for index,heroData in pairs(self.positions or {}) do
			if( heroData and  heroData:isDead() ~= true) then
				heroData:resetActions()
			end
		end
	end

	-- 获取死亡列表(当前阵上,包含替补)
	function BattleTeaminfo:getDeadDataList()
		local result 				= {}
		for index,heroData in pairs(self.positions or {}) do
			if(heroData:isDead()) then
				-- result[index] = index
				table.insert(result,heroData)
			end
		end
		if(#result > 0) then
			return result
		end
		return nil
	end


	-- 获取死亡列表(当前阵上,包含替补)
	function BattleTeaminfo:getDeadList()
		local result 				= {}
		for index,heroData in pairs(self.positions or {}) do
			if(heroData:isDead()) then
				-- result[index] = index
				table.insert(result,tonumber(index))
			end
		end
		if(#result > 0) then
			return result
		end
		return nil
	end
	--检索通过id(数据位当前镇上人员,可能会是替补人员)
	function BattleTeaminfo:indexPlayerByPosition( index )
		-- if(self.benchActiveNum > 0 and self.benchActiveListByPosition[index]) then
		-- 	return self.benchActiveListByPosition[index]
		-- end
		return self.positions[tonumber(index)]
	end
	--检索通过id(数据位当前镇上人员,可能会是替补人员)
	function BattleTeaminfo:indexPlayerByid( hid )
		
		-- if(self.benchActiveNum > 0 and self.benchActiveList[tostring(hid)]) then
		-- 	return self.benchActiveList[tostring(hid)]
		-- end

		local hero = self.list[tostring(hid)]
		return hero
	end
	-- 通过位置索引获取最初上场阵型英雄数据(也就是非替补人员)
	function BattleTeaminfo:getRawPositionData( index )
		return self.rawFormationPositions[index]
	end

	-- 根据位置删除
	function BattleTeaminfo:removeByPosition( index )
		local target = self.positions[tonumber(index)]
		if(target) then
			self.list[tostring(target.id)] = nil
			self.positions[tonumber(index)] = nil
			target:release()
		end
	end
	-- 替补上场啦~
	function BattleTeaminfo:enableBenchPlayer( hid,postion )
		-- 删除指定位置玩家
		
		local removeTarget = self:indexPlayerByPosition(postion)
		if(removeTarget) then
			table.insert(self.benchReplacedList,removeTarget)
			-- self:removeByPosition(postion)
		end

		local benchPlay = self.benchList:indexByHid(hid)
		assert(benchPlay,"未发现替补:" .. tostring(hid))

		if(self.benchActiveList[tostring(benchPlay.id)] == nil) then
			self.benchActiveNum = self.benchActiveNum + 1
		end
		
		self.benchActiveList[tostring(benchPlay.id)] = benchPlay
		-- benchActiveListByPosition[postion] = benchPlay
		benchPlay.positionIndex = postion
		self.list[tostring(benchPlay.id)] = benchPlay
		self.positions[tonumber(postion)] = benchPlay
		benchPlay:linkDisplay()
	end

	-- 获取替补总数量
	function BattleTeaminfo:getBenchTotalNum( ... )
		if(self.benchList and self.benchList.num ~= nil) then
			return self.benchList.num
		end
		
		return 0
	end

	function BattleTeaminfo:hasBench( )
		if(self.benchList and self.benchList.num ~= nil) then
			return self.benchList.num > 0
		end
		return 0
	end
	-- 获取替补存活数量
	function BattleTeaminfo:getBenchAliveNum()
		if(self.benchList) then
			return self.benchList:getAliveNum()
		end
		return 0
	end
 	
 	 
return BattleTeaminfo