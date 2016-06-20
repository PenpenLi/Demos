
require "script/battle/data/BattleArmyData"

local BattleStrongHoldData = class("BattleStrongHoldData")
 	--
 	-- Stronghold（据点数据）包含了：
	-- 								1.据点army列表（不同难度）
	-- 								2.剧情队伍的列表
	-- 								3.战斗起始位置
	-- 								4.战斗背景和音乐
	-- 								5.复活模型
	-- 	这里army不是1个部队 而是整个队伍(敌我)
	--	据点挑战 如果没有战胜过，且有剧情队伍列表 则使用剧情队伍挑战，如果挑战过了则用army


	-- npc更新规则:
	--				1.如果当前army木有指定npc部队,那么就引入上一次npc列表
	--				2.如果当前army有指定npc部队,则上一次上场的npc全部被下场.
	--				好蛋疼的规则啊 !!! 太乱了,耦合太高,容易出错....

	------------------ properties ----------------------
	-- BattleStrongHoldData.copyId				= -1	-- 副本id
	-- BattleStrongHoldData.copyType 			= nil	-- 副本类型\

	BattleStrongHoldData.id 				= -1 	-- id
	BattleStrongHoldData.background			= "" 	-- 背景图片名
	BattleStrongHoldData.backgroundMusic	= "" 	-- 背景音乐

	BattleStrongHoldData.armyIdArray		= nil	-- army的id列表
	BattleStrongHoldData.storyIdArray 		= nil	-- 剧情队伍id列表


	BattleStrongHoldData.armyDataArray		= nil	-- army列表  BattleArmyData
	BattleStrongHoldData.storyDataArray 	= nil	-- 剧情队伍列表 BattleArmyData

	BattleStrongHoldData.displayName 		= nil 	-- 显示名字

	BattleStrongHoldData.hardLevelName		= "nil"	--难度 用于得出不同难度下的队伍列表
	BattleStrongHoldData.hardLevel 			= 0 	--难度

	BattleStrongHoldData.startIndex			= 1		-- 队伍出现

	BattleStrongHoldData.storyNumber		= 0		-- 队伍数量
	BattleStrongHoldData.armyNumber 		= 0 	-- 普通队伍数量

	BattleStrongHoldData.isChallenged		= false -- 是否挑战过
	BattleStrongHoldData.isFirstChallenged	= false -- 是否是第一次挑战

 	BattleStrongHoldData.index 				= 0 	-- 攻击的army索引
	BattleStrongHoldData.total				= 0 	-- 总攻击部队数
	BattleStrongHoldData.fightArray			= nil	-- 要挑战队列 BattleArmyData
	-- BattleStrongHoldData.armyid 			= -1	-- 当前敌人id

	BattleStrongHoldData.getMoney 			= 0 	-- 获取的钱
	BattleStrongHoldData.todo 				= nil 	-- todo
	BattleStrongHoldData.extraNPC 			= nil 	-- 上一次上场的npc

	------------------ functions -----------------------
	function BattleStrongHoldData:isExtraNPCHasHeroImgName( heroImgName )
		for k,v in pairs(self.extraNPC or {}) do
			if(v.heroImgName == heroImgName) then return true end
		end
		return false
	end
	function BattleStrongHoldData:reset(id,hardLevel,battleIndex)
	
		self.armyIdArray			= {}
		self.storyIdArray			= {}
		self.armyDataArray			= {}
		self.storyDataArray			= {}
		self.fightArray 			= {}
		self.extraNPC				= {}
		self.id 					= id
		-- self.copyId					= copyId
		-- self.copyType 				= copyType
		--store hardLevel value
	  	self.hardLevel 				= hardLevel
	  	Logger.debug("BattleStrongHoldData:reset id:" .. tostring(id) .. " hardLevel:" ..  tostring(hardLevel))
	  	self.displayName 			= db_stronghold_util.getDisplayName(id)

	  	

		-- get the hardLevel name
     	self.hardLevelName			= BATTLE_CONST.getHardLevelName(hardLevel)

     	-- print("BattleStrongHoldData-> id：",self.id , "	hardName:",self.hardLevelName,"hardLevel:",hardLevel)
	   	-- get hardLevel army data
	   	if(hardLevel == 0) then
	   		
	   		self.armyIdArray 			= db_stronghold_util.getNPCArmyByHardLevelAndId(id,self.hardLevelName)
	   	else
	   		self.armyIdArray 			= db_stronghold_util.getArmyByHardLevelAndId(id,self.hardLevelName)
	   	end
	   	assert(self.armyIdArray,"self.armyIdArray is nil,id:" .. id .. " ,hardLevel:" .. self.hardLevelName .. " hardLevel:" .. hardLevel)
	   	local count = 0
	   	for i,v in ipairs(self.armyIdArray) do
	   		--print("BattleStrongHoldData-> armyid:",v)
	   		self.armyDataArray[i]				= require("script/battle/data/BattleArmyData").new()
	   		self.armyDataArray[i]:reset(v)
	   		count = count + 1
	   		-- todo strongHold的剧情队伍指定 和 army中的是否一样呢？
	   	end -- for end
	   	--print("-------------------------------------- armyDataArray len:",count)

	   	count = 0
	  	-- get story list (获取剧情队列)
	   	self.storyIdArray 						= db_stronghold_util.getNPCArmyByHardLevelAndId(id,self.hardLevel)
	   	if self.storyIdArray ~= nil then
	   		for i,v in ipairs(self.storyIdArray) do
	   			count = count + 1
		   		self.storyDataArray[i]			= require("script/battle/data/BattleArmyData").new()
		   		self.storyDataArray[i]:reset(v)
	   		-- todo strongHold的剧情队伍指定 和 army中的是否一样呢？
 			end -- for end
 		end -- if end
 			--print("-------------------------------------- storyIdArray len:",count)

	   	self.armyNumber 			= #self.armyIdArray

	   	--get the npc number
	   	if storyIdArray ~= nil then
	   		self.storyNumber 		= #storyIdArray
	   	else
	   		self.storyNumber		= 0
	   	end -- if end
	   	-- get start fightPostionIndex
	   	self.startIndex				= db_stronghold_util.getFightStartIndex(id)

	   	-- get background image
		self.background 			= db_stronghold_util.getBackGroundImageName(id)

	   	-- get background music
  		self.backgroundMusic  		= db_stronghold_util.getBackGroundMusic(id)

	   	-- get rebirth way

	   	self:refreshChallengeData()
	   	-- 如果数据不合法
	    if(battleIndex == nil or battleIndex <= 0 or battleIndex > self.total) then
	    	self.index = 1
	    else
	    	self.index = battleIndex
	    	self.startIndex 	= self.index
	    end
	   
	end -- function end

	-- 从dataCache中获取副本是否打过的标识
	function BattleStrongHoldData:refreshChallengeData()
		 
 		self.isFirstChallenged = itemCopy.fnGetAttStausByCopyBaseHard(self.id,self.hardLevel)
 
		self.isChallenged = itemCopy.fnGetAttStausByCopyBaseHard(self.id,self.hardLevel) 
 
		
		-- end
		--print("----------------------------------	isFirstChallenged:",self.isFirstChallenged)
		--如果没有挑战过 且 有剧情战斗数据
		if self.isFirstChallenged ~= true and self.storyDataArray ~= nil and #self.storyDataArray > 0 then
			self.fightArray			= self.storyDataArray
		else
			self.fightArray			= self.armyDataArray

		end


		self.total 					= #self.fightArray
		self.index 					= 1
 
		--print("----------------------------------	strongHold -> total",self.total)
	end -- function end

 
 	function BattleStrongHoldData:nextBattle()
        -- 保存npc英雄信息
        self:saveExtraNPCHero()

 		if(self:hasNextBattle()) then
 			-- 数据索引
 			self.index 			= self.index + 1
 			-- 更新地图移动索引
 			self.startIndex 	= self.startIndex + 1 
 			if(self.startIndex > BATTLE_CONST.MAX_POSTION) then 
 				self.startIndex = BATTLE_CONST.MAX_POSTION
 			end
 		end
 	end
 	-- 保存npc英雄信息(后面的相关战斗可能会用到,注意要在刷新index之前调用即:nextBattle)
 	function BattleStrongHoldData:saveExtraNPCHero( ... )
 		 	
 		 	-- local lastData 			= self:getLastArmyData()
 			local currentData   	= self:getCurrentArmyData()
 			-- 如果当前队伍有npc英雄
 			if(currentData and currentData:hasNPCHeroInSelf()) then
 				self.extraNPC 	= currentData.selfNpcList
 				for k,v in pairs(self.extraNPC) do
 					--print("BattleStrongHoldData:saveExtraNPCHero:",k,v)
 				end
 				 
 			else
 				--print("we don't have npc")
 			end
 	end
 	-- 根据潜规则,插入上一场的npc,具体见: npc更新规则
 	function BattleStrongHoldData:insertExtraNPC()
 		self:cacheExtraNPCHero()
 		-- 如果当前队伍没有npc,那么需要插入上一场npc
 		if(self:getCurrentArmyData():hasNPCHeroInSelf() ~= true) then
 		
 		end
 	end

 

 	-- 是否有上一场战斗
 	function BattleStrongHoldData:hasLastBattle()
 		return self.total > 1 and self.index > 1 
 	end
 	-- 获取上一场战斗数据
 	function BattleStrongHoldData:getLastArmyData()

 		if(self:hasLastBattle()) then
 			return self.fightArray[self.index - 1]
 		end
 		return nil
 	end

 	function BattleStrongHoldData:hasNextBattle()
 		 return self.index + 1 <= self.total
 	end

	-- 获取当前要攻打的部队
	function BattleStrongHoldData:getCurrentArmyData()
		return self.fightArray[self.index]
	end
	-- 获取人物的队伍信息
	function getObjectTeamData( teamid,postion )
		local armyData 							= self.getCurrentArmyData()
		if armyData ~= nil then
			local objectTeamdata 				= armyData:getObjectInfo(teamid,postion)
			return objectTeamdata
		end
		return nil
	end
return BattleStrongHoldData