
-- 战斗队伍显示
   -- 提供更新显示对象
   -- 通过 位置索引 -> display
module("BattleTeamDisplayModule", package.seeall)
 selfDisplayListByPostion 								= nil 			-- 自己队伍的显示数据
 armyDisplayListByPostion								= nil 			-- 自己队伍的显示数据


 selfBenchPlayerByPostion 								= nil 			-- 自己队伍的替补
 armyBenchPlayerByPostion 								= nil 			-- 自己队伍的替补
 		-- 自己队伍死亡队员(待复活队员,貌似只有精英的时候才能用,副本不用这个?)
 	 
-- local isMoveMode 										= false
-- function switchToMoveMode()
	
-- end

-- function stopMoveMode( ... )
-- 	if(isMoveMode == true) then

-- 	end
-- end

-- function switchHero(index1,index2)
-- 	assert(self.selfDisplayListByPostion[index1]== nil and )
-- end
	function setCardPostion(card,postionIndex,pos)
		 assert(card)
		 assert(pos)
		 assert(postionIndex)

		 local oldPostion = card.data.positionIndex
		  --print("card postion: from ",oldPostion," to:",postionIndex)

		 selfDisplayListByPostion[oldPostion] = nil
		 selfDisplayListByPostion[postionIndex] = card
		 card.data.positionIndex = postionIndex
		 -- 位置处理
		 card.container:setPosition(pos.x,pos.y)
		 card:toZOder(postionIndex)
		 card.rawPositon 	= pos
		 card.rawPositon.z  = postionIndex
	end
	-- 交换卡牌
	function switchCard( card1,card2 )
		assert(card1)
		assert(card2)
 		-- 设置在selfAllDisplayListByPostion中的索引 positionIndex
 		--print("switchCard:",card1.data.positionIndex,card2.data.positionIndex)
		selfDisplayListByPostion[card1.data.positionIndex] = card2
		selfDisplayListByPostion[card2.data.positionIndex] = card1

		-- 交换位置和深度
		local copy 			= card2.rawPositon
		-- local location 		= ccp(card1.rawPositon.x,card1.rawPositon.y)
		card2.container:setPosition(card1.rawPositon.x,card1.rawPositon.y)
		card2:toZOder(card1.rawPositon.z)

		card1.container:setPosition(card2.rawPositon.x,card2.rawPositon.y)
		card1:toZOder(card2.rawPositon.z)

		local pi1=  card1.data.positionIndex
		local pi2=  card2.data.positionIndex
		
		card1.data.positionIndex = pi2
		card2.data.positionIndex = pi1
		-- 位置信息
		card2.rawPositon 	= card1.rawPositon
		card1.rawPositon 	= copy

		getFormationRequestData()
	end


function isFormationChanged()
	
	local info = getFormationRequestData()
	local cacheData = FormationModel.getFormationInfo()		
	-- 
	for i=0,5 do
		local cacheid = tonumber(cacheData["" .. i])
		local infoid  = tonumber(info["" .. i])

		if(cacheid == nil) then
			cacheid = 0
		end
		if(infoid == nil) then
			infoid = 0
		end
		-- print("-- isFormationChanged postion:",i,"cacheid,infoid:",cacheid,infoid)
		if(cacheid ~= infoid) then
			return true
		end
	end

	return false
end	


function getFormationRequestData()
	local result = {}
	
	for k,cardDisplay in pairs(selfDisplayListByPostion or {}) do
		result[tostring(cardDisplay.data.positionIndex)] = cardDisplay.data.hid
		-- print("getFormationRequestData:",cardDisplay.data.positionIndex," hid:",cardDisplay.data.hid)
	end
	for i=0,5 do
		 if(result[tostring(i)] == nil) then
		 	result[tostring(i)] = 0
		 end

	end

	-- for k,v in pairs(result) do
	-- 	print("getFormationRequestData1:",k,v)
	-- end
	return result
end

function toStartPosition( ... )
	for k,cardDisplay in pairs(selfDisplayListByPostion or {}) do
		 cardDisplay:toRawPosition()
	end
end

function printSelfState( ... )	
	for k,v in pairs(selfDisplayListByPostion  or {}) do
		--print("hero index:",v.data.positionIndex,"visible:",v.container:isVisible())
	end
end
-- 删除自己队伍的ui
function removeSelfTeam( ... )
	for k,v in pairs(selfDisplayListByPostion  or {}) do
		v:release()
	end
	selfDisplayListByPostion = {}
end
-- 删除敌对队伍ui
function removeArmyTeam( ... )
	
	for k,v in pairs(armyDisplayListByPostion  or {}) do
		v:release()
	end
	armyDisplayListByPostion = {}
end

 

-- 删除所有
function removeAll( ... )
	removeSelfTeam()
	removeArmyTeam()
	-- removeGhostHeroes()
end

function overrideTeamDisplay( data,list ,visible)
	 for i,v in pairs(data) do
		local display
		local index = tonumber(v.positionIndex)

		if(overridePostion) then 
	    	list[index]:release()
       	end
       	display 							= require("script/battle/ui/BattlPlayerDisplay").new()
       	display:reset(v)
		
		if(display:getParent() == nil) then
			display:setParent(BattleLayerManager.battlePlayerLayer)
		end
		list[v.positionIndex] 		= display
		-- 默认不显示
		display:setVisible(visible or false)
    end -- for end
end

-- 按table创建显示,添加到图层 并更新idToDisplay
function createTeamDisplay( data , list , overridePostion,des)
	--local postionMarks = {}
	--removeUnIntersectionFromDisplayList(data,list)
	des 			= des or ""
	overridePostion = overridePostion or true

	local count = 0
	-- 遍历team数据
	for i,v in pairs(data) do
		local display
		local index = tonumber(v.positionIndex)
		-- 没有就生成
		if (list[index] == nil) then
	        display 							= require("script/battle/ui/BattlPlayerDisplay").new()
	    else
	    	if(overridePostion) then 
       			display 							= list[index]
       			-- display:setVisible(true)
       			display:toRawZOder()
       		else
       			error("BattleTeamDisplayModule.createTeamDisplay the position:",v.positionIndex,"has hero!!",des)
       		end
		end
		--if idToDisplay == nil then --print("idToDisplay is nil ") end
		-- if v == nil then --print("data is nil") 
		-- 	else 
		-- 		--print("v.id is:",v.id) 
		-- 	end
		-- idToDisplay[v.id] 						= v
		-- --print("createTeamDisplay: display.isGhostState->",display.isGhostState)
		if(display.isGhostState ~= true) then
			display:reset(v)
		end
		-- --print("createTeamDisplay: display.getParent->",display:getParent())
		
		if(display:getParent() == nil) then
			display:setParent(BattleLayerManager.battlePlayerLayer)
		end
		list[v.positionIndex] 		= display
		count = count + 1
    end -- for end

    --print("   count:",count)
end

function getHeroDisplay( data )
	local result = {}

	for k,index in pairs(data or {}) do
		
		target = selfDisplayListByPostion[index]
		 
        table.insert(result,target)	
	end
	return result
end

function setSelfDisplayGhostState(data)
	local target
	for k,index in pairs(data or {}) do
		
		target = selfDisplayListByPostion[index]
		-- for k,v in pairs(selfDisplayListByPostion) do
		-- 	-- --print("setSelfDisplayGhostState:",k,v)
		-- end
		if(target) then
			target:ghostState()
		end
	
	end
end
 
-- 移除目标ghostState
function removeGhostHero( hid )
	for k,target in pairs(selfDisplayListByPostion or {}) do
		if(target and target.data.hid == hid) then
			target:normalState()
			return
		end
	
	end
end
-- 从 displayList 中移除非交集
function removeUnIntersectionFromDisplayList(x1,displayList)
	 for i,v in ipairs(displayList) do
	 	if ( x1[i] == nil ) then
			v:release()
			displayList[i] = nil
		end -- if end
	 end -- for end
end -- function end

-- 获取指定位置索引的英雄列表([0,11])
function getPlayerDisplayByPositionList(list,exceptDead)
	if(exceptDead == nil ) then
		exceptDead = false
	end
	local result = {}
	local item = nil
	for k,index in pairs(list or {}) do
		
		if(index >= 0 and index <= 11) then

			if(index < 6) then
				item = getSelfTeamHeroByPostion(index)

				-- for k,v in pairs(selfDisplayListByPostion or {}) do
				-- 	print("selfDisplayListByPostion",k,v)
				-- end
				 
			else
				-- for k,v in pairs(armyDisplayListByPostion or {}) do
				-- 	print("armyDisplayListByPostion",k,v)
				-- end
				item = getArmyTeamHeroByPostion(index - 6)
			end
			
			if(item ~= nil) then
				-- print("getPlayerDisplayByPositionList:",exceptDead,item.isDead,item.isGhostState)
				if(exceptDead) then
					if(item.isDead ~= true) then
						table.insert(result,item)
					end
				else
					table.insert(result,item)
				end
				
			end
		end

	end

	return result
end

function getSelfTeamHeroByPostion( position )
	 return getCardByPostionAndTeam(position,BATTLE_CONST.TEAM1)
end
function getArmyTeamHeroByPostion( position )
	 return getCardByPostionAndTeam(position,BATTLE_CONST.TEAM2)
end
-- 根据位置和 队伍id来获取ui
function getCardByPostionAndTeam(postion,teamid)
	
	 if (teamid == BATTLE_CONST.TEAM1) then 
	 	local target = selfDisplayListByPostion[tonumber(postion)]
		 	if(target == nil ) then
		 		--print("	getCardByPostionAndTeam: postion->",postion," teamid->",teamid ," is nil ")
		 		
		 		-- for k,v in pairs(selfDisplayListByPostion) do
		 		-- 	--print("Team1 have: postion->",k)
		 		-- 	-- --print("	getCardByPostionAndTeam1:",k," type:",type(k))
		 		-- end
		 	end
	 	return target
	 else

	 	local target = armyDisplayListByPostion[tonumber(postion)]
		 	if(target == nil ) then
		 		--print("	getCardByPostionAndTeam:",postion,teamid ," is nil ")
		 		for k,v in pairs(armyDisplayListByPostion) do
		 			--print("Team2 have: postion->",k)
		 			-- --print("getCardByPostionAndTeam2:",k," type:",type(k))
		 		end
		 	end

	 	return target

	 end
end

function visibleAll( ... )
		for i,display in pairs(selfDisplayListByPostion or {}) do
			display:setVisible(true)
		end

		for i,display in pairs(armyDisplayListByPostion or {}) do
			display:setVisible(true)
		end
end

function unvisableAll( ... )

		for i,display in pairs(selfDisplayListByPostion or {}) do
			display:setVisible(false)
		end

		for i,display in pairs(armyDisplayListByPostion or {}) do
			display:setVisible(false)
		end
end
-- 刷新成和战斗同步
function createHeroDisplayToMainData(dea)

		-- idToDisplay 											= {}
		
		if (selfDisplayListByPostion == nil) then
			selfDisplayListByPostion							= {}
		end 

		if (armyDisplayListByPostion == nil) then
			armyDisplayListByPostion							= {}
		end 
		-- local armyData 											= BattleMainData.strongholdData:getCurrentArmyData()
		-- --print(" self team:")
		createTeamDisplay(BattleMainData.selfTeamDisplayData,selfDisplayListByPostion)
		createTeamDisplay(BattleMainData.armyTeamDisplayData,armyDisplayListByPostion) -- 刷新敌方数据

	-- for test
   -- local scene = CCDirector:sharedDirector():getRunningScene()
   
   -- local displayName = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
   -- positon = BattleGridPostion.getPlayerPointByIndex(4)
   -- displayName:setAnchorPoint(CCP_HALF)
   -- displayName:setPosition(positon.x,positon.y)
   -- scene:addChild(displayName,999990)

   -- displayName = CCSprite:create(BATTLE_CONST.RAGE_BAR_PATH)
   -- positon = BattleGridPostion.getEnemyPointByIndex(1)
   -- positon.y = positon.y + 50
   -- displayName:setAnchorPoint(CCP_HALF)
   -- displayName:setPosition(positon.x,positon.y)
   -- scene:addChild(displayName,999990)

 		
end -- function end
-- 继承上一次npc数据
function createExtraNPCFromLastArmy()
	createTeamDisplay(BattleMainData.strongholdData.extraNPC,selfDisplayListByPostion,false,"继承npc队员")
end
function createSelfTeamDisplayData( dataes , overridePostion)
	assert(dataes)
	if (selfDisplayListByPostion == nil) then
			selfDisplayListByPostion							= {}
	end 
	createTeamDisplay(dataes,selfDisplayListByPostion,overridePostion) -- 刷新自己方数据		


end


function createArmyTeamDisplayData( dataes )
	assert(dataes)
	if (armyDisplayListByPostion == nil) then
			armyDisplayListByPostion							= {}
	end 
	createTeamDisplay(dataes,armyDisplayListByPostion) -- 刷新自己方数据	
end

function setArmyAddMovePostion()
	-- 设置敌人位置
	for k,v in pairs(armyDisplayListByPostion) do
		v.container:setPositionY(v.container:getPositionY() + BattleMainData.moveDistence)
	end
end

-- 激活替补
function activeNewPlayer(playerDisplayData,index,teamid)
	assert(playerDisplayData,"错误:100002")
	assert(index,"错误:100003")
	assert(teamid,"错误:100004")
	
	local targetContainer = nil
	if(teamid == BATTLE_CONST.TEAM1) then
		targetContainer = selfDisplayListByPostion
	else
		targetContainer = armyDisplayListByPostion
	end
	-- 填充ui
		-- selfBenchPlayerByPostion[playerData.positionIndex] = 
		local display
		if (targetContainer[index] ~= nil) then
			targetContainer[index]:release()
			-- targetContainer[index]:setVisible(false)
			targetContainer[index]:removeFromParent()
		end

		-- if (targetContainer[index] == nil) then
	    display 							= require("script/battle/ui/BattlPlayerDisplay").new()
	    -- else
     --   			display 							= list[index]
     --   			display:toRawZOder()
     --   	end
 
		Logger.debug("activeBenchPlayer:" .. tostring(index) .. tostring(" team:") .. tostring(playerDisplayData.teamId))
		display:reset(playerDisplayData)

		-- --print("createTeamDisplay: display.getParent->",display:getParent())
		
		-- if(display:getParent() == nil) then
		display:setParent(BattleLayerManager.battlePlayerLayer)
		-- end
		-- display:setVisible(false)
		targetContainer[index] = display
end
 