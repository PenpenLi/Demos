
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年08月21日 18:37:42
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com


require "zoo.model.LuaXml"
require "hecore.utils"

---------------------------------
---- Utility
-----------------------------

local function convertPcCoordToMobile(pcX, pcY, ...)
	assert(pcX)
	assert(pcY)
	assert(#{...} == 0)

	local winSize = CCDirector:sharedDirector():getWinSize()

	local mobileX = pcX / 950 * winSize.width
	local mobileY = pcY / 660 * 764

	return mobileX, mobileY
end

---- Function : Parse String Like This "123-456"
-----		Return Number 124 And Number 456
local function getTwoNumberSeparatedByHyphen(valueStr, ...)
	assert(valueStr)
	assert(type(valueStr) == "string")
	assert(#{...} == 0)

	local hyphenIndex	= string.find(valueStr, "-")
	assert(hyphenIndex)

	local firstValue	= string.sub(valueStr, 1, hyphenIndex-1)
	local secondValue	= string.sub(valueStr, hyphenIndex+1)

	return tonumber(firstValue), tonumber(secondValue)
end


-------------------------------------------------------------------
----    CSV: Is The Comma Separated Value
----	Get A Table Representation OF Like "value1, value2, value3"
--------------------------------------------------------------
function getTableFromCSV(csv, ...)
	assert(csv)
	assert(type(csv) == "string")
	assert(#{...} == 0)

	-- Construct A Lua Chunk
	local luaChunk = "return {" .. csv .. "}"

	local chunk = loadstring(luaChunk)
	assert(chunk, "InValied Comma Separated Value Froamt")

	local table = chunk()

	return table
end

---------------------------------------------------
-------------- MetaModel
---------------------------------------------------
MetaModel = class()

function MetaModel:ctor()
end

function MetaModel:init(...)
	assert(#{...} == 0)

	--获取当前路径
	self.metaXML = xml.eval(HeFileUtils:decodeFile(CCFileUtils:sharedFileUtils():fullPathForFilename("meta/meta_client.inf")))
	assert(self.metaXML)
end

function MetaModel:sharedInstance(...)
	assert(#{...} == 0)

	if not metaModelSharedInstance then
		metaModelSharedInstance = MetaModel.new()
		metaModelSharedInstance:init()
	end

	return metaModelSharedInstance
end

----------------------------------------------------------------------
----------- Function About Properties
----------------------------------------------------------------------


function MetaModel:getPropertyDataArray(...)
	assert(#{...} == 0)

	if not self.propertyDataArray then
		--self.propertyDataArray = {}

		local propXmlNode = xml.find(self.metaXML, "prop")
		assert(propXmlNode)

		self.propertyDataArray = propXmlNode
	end

	return self.propertyDataArray
end

function MetaModel:getPropertyDataById(propertyId, ...)
	assert(propertyId)
	assert(#{...} == 0)

	local propertyDataArray = self:getPropertyDataArray()
	assert(propertyDataArray)

	for index = 1, #propertyDataArray do

		local curPropId = tonumber(propertyDataArray[index].id)
		assert(curPropId)

		if curPropId == propertyId then
			return propertyDataArray[index]
		end
	end

	return nil
end

--------------------------------------------------------------------------
-------- Function About Map Data
-------------------------------------------------------------------------



assert(not GameModeType)
GameModeType = {

	-- Limited Step, Get Enough Score
	CLASSIC_MOVES	= "Classic moves",

	-- Clear All The Ice
	LIGHT_UP	= "Light up",

	-- Collect The Pod
	DROP_DOWN	= "Drop down",

	-- Limited TIme , Get Enough Score
	CLASSIC		= "Classic",

	---- 
	--DIG_TIME	= "",
	----
	DIG_MOVE	= "DigMove",

	-- Limited Step, Clear The Target
	ORDER		= "Order",

	DIG_MOVE_ENDLESS = 'DigMoveEndless',

	MAYDAY_ENDLESS = 'MaydayEndless',
	RABBIT_WEEKLY = 'RabbitWeekly',
	WORLD_CUP = 'WorldCUP',
	SEA_ORDER = 'seaOrder',-- attention: 特殊情况 小写字母
    HALLOWEEN = 'halloween',
    TASK_UNLOCK_DROP_DOWN = 'Mobile Drop down',
    HEDGEHOG_DIG_ENDLESS = "HedgehogDigEndless",
    WUKONG_DIG_ENDLESS = "MonkeyDigEndless",
    SUMMER_WEEKLY = "Summer_Weekly",
    LOTUS = "meadow",
}

local function checkGameModeType(gameModeType, ...)
	assert(gameModeType)
	assert(#{...} == 0)


	assert(gameModeType == GameModeType.CLASSIC_MOVES or
		gameModeType == GameModeType.LIGHT_UP or
		gameModeType == GameModeType.DROP_DOWN or
		gameModeType == GameModeType.CLASSIC or
		gameModeType == GameModeType.ORDER or 
		gameModeType == GameModeType.DIG_MOVE or
		gameModeType == GameModeType.DIG_MOVE_ENDLESS or
		gameModeType == GameModeType.MAYDAY_ENDLESS or
		gameModeType == GameModeType.RABBIT_WEEKLY or
		gameModeType == GameModeType.WORLD_CUP or
		gameModeType == GameModeType.SEA_ORDER or
		gameModeType == GameModeType.HALLOWEEN or 
		gameModeType == GameModeType.TASK_UNLOCK_DROP_DOWN or
		gameModeType == GameModeType.HEDGEHOG_DIG_ENDLESS or
		gameModeType == GameModeType.WUKONG_DIG_ENDLESS or
		gameModeType == GameModeType.LOTUS or
		gameModeType == GameModeType.SUMMER_WEEKLY
		)
end


assert(not GameModeTypeId)
GameModeTypeId = {

	CLASSIC_MOVES_ID	= 1,
	CLASSIC_ID		= 2,
	DROP_DOWN_ID		= 3,
	LIGHT_UP_ID		= 4,
	DIG_TIME_ID		= 5,
	DIG_MOVE_ID		= 6,
	ORDER_ID		= 7,
	DIG_MOVE_ENDLESS_ID	= 8,
	RABBIT_WEEKLY_ID 	= 9,
	CHRISTMAS_ENDLESS_ID = 10,
	SPRING_FESTIVAL_ENDLESS_ID = 11,
	MAYDAY_ENDLESS_ID = 12,
	WORLD_CUP_ID = 13,
	SEA_ORDER_ID = 14,
	HALLOWEEN    = 15,
	TASK_UNLOCK_DROP_DOWN = 16,
	SUMMER_WEEKLY = 17,
	HEDGEHOG_DIG_ENDLESS_ID = 18,
	WUKONG_DIG_ENDLESS_ID = 19,
	LOTUS_ID = 20,
}

function getGameModeTypeIdFromModeType(modeType, ...)
	assert(modeType)
	checkGameModeType(modeType)
	assert(#{...} == 0)

	if modeType == GameModeType.CLASSIC_MOVES then
		return GameModeTypeId.CLASSIC_MOVES_ID
	elseif modeType == GameModeType.LIGHT_UP then
		return GameModeTypeId.LIGHT_UP_ID
	elseif modeType == GameModeType.DROP_DOWN then
		return GameModeTypeId.DROP_DOWN_ID
	elseif modeType == GameModeType.CLASSIC then
		return GameModeTypeId.CLASSIC_ID
	elseif modeType == GameModeType.ORDER then
		return GameModeTypeId.ORDER_ID
	elseif modeType == GameModeType.DIG_MOVE then
		return GameModeTypeId.DIG_MOVE_ID
	elseif modeType == GameModeType.DIG_MOVE_ENDLESS then
		return GameModeTypeId.DIG_MOVE_ENDLESS_ID
	elseif modeType == GameModeType.MAYDAY_ENDLESS then
		return GameModeTypeId.MAYDAY_ENDLESS_ID
	elseif modeType == GameModeType.RABBIT_WEEKLY then
		return GameModeTypeId.RABBIT_WEEKLY_ID
	elseif modeType == GameModeType.WORLD_CUP then
		return GameModeTypeId.WORLD_CUP_ID
	elseif modeType == GameModeType.SEA_ORDER then
		return GameModeTypeId.SEA_ORDER_ID
	elseif modeType == GameModeType.HALLOWEEN then
		return GameModeTypeId.HALLOWEEN
	elseif modeType == GameModeType.TASK_UNLOCK_DROP_DOWN then 
		return GameModeTypeId.TASK_UNLOCK_DROP_DOWN
	elseif modeType == GameModeType.HEDGEHOG_DIG_ENDLESS then
		return GameModeTypeId.HEDGEHOG_DIG_ENDLESS_ID
	elseif modeType == GameModeType.WUKONG_DIG_ENDLESS then
		return GameModeTypeId.WUKONG_DIG_ENDLESS_ID
	elseif modeType == GameModeType.SUMMER_WEEKLY then
		return GameModeTypeId.SUMMER_WEEKLY
	elseif modeType == GameModeType.LOTUS then
		return GameModeTypeId.LOTUS_ID
	else
		assert(false)
	end
end

function MetaModel:getLevelConfigData(levelId, ...)
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	local levelMeta = LevelMapManager.getInstance():getMeta(levelId)
	if levelMeta then return levelMeta end
	return nil
end

function MetaModel:getLevelModeTypeId(levelId, ...)
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	local levelMeta = LevelMapManager.getInstance():getMeta(levelId)

	if levelMeta then 
		local gameData = levelMeta.gameData
		assert(gameData)

		local gameModeName = gameData.gameModeName
		assert(gameModeName)

		checkGameModeType(gameModeName)
		print(gameModeName,gameModeName,gameModeName)

		local gameModeTypeId = getGameModeTypeIdFromModeType(gameModeName)
		assert(gameModeTypeId)

		return gameModeTypeId
	end

	return nil
end

function MetaModel:getLevelTargetScores(levelId, ...)
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	local levelConfigData = self:getLevelConfigData(levelId)
	assert(levelConfigData)

	local gameData	= levelConfigData.gameData
	assert(gameData)

	local targetScores = gameData.scoreTargets
	assert(targetScores)

	return targetScores
end

--------------------------------------------------------------------
------------	Function About Level Reward
--------------------------------------------------------------------

function MetaModel:getLevelRewardDataArray(...)
	assert(#{...} == 0)

	if not self.levelRewardDataArray then

		local levelRewardNode = xml.find(self.metaXML, "level_reward")
		assert(levelRewardNode)

		return levelRewardDataNode
	end
end

function MetaModel:getLevelRewardData(levelId, ...)
	assert(levelId)
	assert(type(levelId) == "number")
	assert(#{...} == 0)

	local levelRewardDataArray = self:getLevelRewardDataArray()
	assert(levelRewardDataArray)

	for index = 1, #levelRewardDataArray do

		if tonumber(levelRewardDataArray[index].levelId) == levelId then
			return levelRewardDataArray[index]
		end
	end

	return nil
end


function MetaModel:getLevelOneStarDefaultReward(...)
	assert(#{...} == 0)

	
end

function MetaModel:getLevelOneStarReward(...)
	assert(#{...} == 0)

	
end

function MetaModel:getLevelThreeStarReward(...)
	assert(#{...} == 0)

	
end

--------------------------------------------------------------------
---------	Function About Game Mode Property
-------------------------------------------------------------------

function MetaModel:getGameModePropsDataArray(...)
	assert(#{...} == 0)

	if not self.gameModePropsArray then
		self.gameModePropsArray = {}

		local gameModePropXmlNode = xml.find(self.metaXML, "gamemode_prop")
		assert(gameModePropXmlNode)

		for index = 1, #gameModePropXmlNode do
			table.insert(self.gameModePropsArray, gameModePropXmlNode[index])
		end
	end

	return self.gameModePropsArray
end

function MetaModel:getGameModePropsData(gameModeId, ...)
	assert(gameModeId)
	assert(type(gameModeId) == "number")
	assert(#{...} == 0)

	local gameModePropsDataArray = self:getGameModePropsDataArray()
	assert(gameModePropsDataArray)

	for index = 1, #gameModePropsDataArray do

		if tonumber(gameModePropsDataArray[index].id) == gameModeId then
			return gameModePropsDataArray[index]
		end
	end

	return nil
end

function MetaModel:getGameModeInitProps(gameModeId, ...)
	assert(gameModeId)
	assert(type(gameModeId) == "number")
	assert(#{...} == 0)

	local gameModePropsData = self:getGameModePropsData(gameModeId)
	assert(gameModePropsData)

	-- Parse The initProps Field
	local initPropsString = gameModePropsData.initProps

	local propIdArray = getTableFromCSV(initPropsString)

	return propIdArray
end


function MetaModel:getGameModeInGameProps(gameModeId, ...)
	assert(gameModeId)
	assert(type(gameModeId) == "number")
	assert(#{...} == 0)


	assert(false)
end


-----------------------------------------------------------------------
------------  Function About Locked Area
----------------------------------------------------------------------

function MetaModel:getLevelAreaDataArray(...)
	assert(#{...} == 0)

	if not self.levelArea then
		self.levelArea = {}

		local xmlLevelAreaNode = xml.find(self.metaXML, "level_area")
		assert(xmlLevelAreaNode)

		for index = 1,#xmlLevelAreaNode do
			table.insert(self.levelArea, xmlLevelAreaNode[index])
		end
	end

	return self.levelArea
end

function MetaModel:getLevelAreaDataById(levelAreaId, ...)
	assert(levelAreaId)
	assert(type(levelAreaId) == "number")
	assert(#{...} == 0)

	local levelAreaDataArray = self:getLevelAreaDataArray()

	for index = 1,#levelAreaDataArray do

		if tonumber(levelAreaDataArray[index].id) == levelAreaId then
			return levelAreaDataArray[index]
		end
	end

	return nil
end

------------------------------
--- Branch Data:
--- type:	1 Or 2, (Right Direction Or Left)
--- x:		X Position
--- y:		Y Position
---
---
--- Below Four Variable : n
--- When The Nomal Level From startNormalLevel To endNormalLevel Is All 3 Stars
--- Then Hidden Level From startHiddenLevel To endHiddenLevel Is Open
---
--- startNormalLevel: 
--- endNormalLevel:
--- startHiddenLevel:
--- endHiddenLevel:
-----------------------------------

function MetaModel:debugPrintHiddenBranchDataList(...)
	assert(#{...} == 0)

	if self.branchList then

		print("MetaModel:debugPrintAllChildren Called !")

		for index = 1, #self.branchList do
			local branch = self.branchList[index]

			print("============================")
			print("index: " .. index)
			print("type: " .. branch.type)
			print("x: " .. branch.x)
			print("y: " .. branch.y)
			print("startNormalLevel: " .. branch.startNormalLevel)
			print("endNormalLevel: " .. branch.endNormalLevel)
			print("startHiddenLevel: " .. branch.startHiddenLevel)
			print("endHiddenLevel: " .. branch.endHiddenLevel)
		end
	else 
		print("MetaModel:debugPrintHiddenBranchDataList : self.branchList Is nil !")
	end
end

function MetaModel:initHiddenBranchListData(...)
	assert(#{...} == 0)

	if not self.branchList then
		self.branchList = {}
		self.openBranchList = {}

		---------------------------------------------
		---- Get Other Hidden Branch Data From meta_client.xml
		---------------------------------------------------

		local branchPosYCache = {}
		local function calculateBranchPosY(index)
			if index == 1 then
				branchPosYCache[index] = 3600 
				return branchPosYCache[index]
			else
				if (index - 1) % 2 == 1 then
					branchPosYCache[index] = calculateBranchPosY(index - 1) + 1660
				else
					branchPosYCache[index] = calculateBranchPosY(index - 1) + 1445
				end
			end
			return branchPosYCache[index]
		end

		local function calculateBranchPosX(index)
			local x
			if index % 2 == 1 then
				x = 500
			else
				x = 229
			end
			return x
		end

		local hideAreaMetaList = MetaManager.getInstance().hide_area

		for index = 1, #hideAreaMetaList + 1 do
			local metaInfo = hideAreaMetaList[index]
			
			-- 显示设计施工中
			if not metaInfo then
				metaInfo = {
					id = index,
					continueLevels = {
						table.last(table.last(hideAreaMetaList).continueLevels) + 1,
						table.last(table.last(hideAreaMetaList).continueLevels) + 15,						
					},
					hideLevelRange = {
						table.last(table.last(hideAreaMetaList).hideLevelRange) + 1,
						table.last(table.last(hideAreaMetaList).hideLevelRange) + 3,						
					},
					hideAreaId = 0,
					hideReward = {}
				}
			end

			local id = tonumber(metaInfo.id)

			-- Parse continueLevels Attribute
			local continueLevels = metaInfo.continueLevels
			local startLevel = false
			local endLevel = false

			-- Parse hideLevelRange Attribute
			local hideLevelRange = metaInfo.hideLevelRange
			local startHiddenLevel = false
			local endHiddenLevel = false

			startLevel, endLevel = continueLevels[1], continueLevels[#continueLevels]
			startHiddenLevel, endHiddenLevel = hideLevelRange[1], hideLevelRange[#hideLevelRange]

			local branchData = {}
			branchData.branchId = index
			branchData.startNormalLevel = startLevel
			branchData.endNormalLevel = endLevel
			branchData.dependHideAreaId = tonumber(metaInfo.hideAreaId)
			branchData.startHiddenLevel = LevelMapManager.getInstance().hiddenNodeRange + startHiddenLevel
			branchData.endHiddenLevel = LevelMapManager.getInstance().hiddenNodeRange + endHiddenLevel
			branchData.x = calculateBranchPosX(index)
			branchData.y = calculateBranchPosY(index)
			branchData.hideReward = metaInfo.hideReward
			
			if index % 2 == 1 then
				branchData.type = "1"
			else
				branchData.type = "2"
			end
			self.branchList[id] = branchData

		end



	end
end

function MetaModel:getHiddenBranchDataList(...)
	assert(#{...} == 0)

	self:initHiddenBranchListData()
	return self.branchList
end

function MetaModel:isHiddenBranchCanShow(branchId)
	self:initHiddenBranchListData()

	local branch = self.branchList[branchId]
	if not branch then
		return false
	end

	local startNormalLevel	= branch.startNormalLevel
	local endNormalLevel	= branch.endNormalLevel

	for index = startNormalLevel, endNormalLevel do
		local score = UserManager.getInstance():getUserScore(index)
		if not JumpLevelManager:getInstance():hasJumpedLevel(index) and 
			(score == nil or score.star <= 0) then
			return false
		end
	end

	return true
end

-- 显示设计正在施工中
function MetaModel:isHiddenBranchDesign( branchId )
	self:initHiddenBranchListData()
	return branchId >= #self.branchList
end

function MetaModel:isHiddenBranchCanOpen(branchId, ...)
	assert(branchId)
	assert(#{...} == 0)

	self:initHiddenBranchListData()

	if self:isHiddenBranchDesign(branchId) then
		return false
	end

	local branch = self.branchList[branchId]
	assert(branch)

	-- Get Normal Level Range
	local startNormalLevel	= branch.startNormalLevel
	local endNormalLevel	= branch.endNormalLevel

	local allLevelIsThreeStar = true
	for index = startNormalLevel, endNormalLevel do
		local score = UserManager.getInstance():getUserScore(index)
		if score == nil or score.star < 3 then
			allLevelIsThreeStar = false
			break
		end
	end

	if allLevelIsThreeStar then
		return true
	end

	local isDependHideLevelsAllThreeStar = false
	if branch.dependHideAreaId > 0 then
		local allHiddenLevelIsThreeStar = true
		local dependBranchData = self.branchList[branch.dependHideAreaId]
		for i = dependBranchData.startHiddenLevel, dependBranchData.endHiddenLevel do
			local score = UserManager.getInstance():getUserScore(i)
			if score == nil or score.star < 3 then
				allHiddenLevelIsThreeStar = false
				break
			end
		end
		return allHiddenLevelIsThreeStar
	end
	return isDependHideLevelsAllThreeStar
end

function MetaModel:getHiddenBranchDataByHiddenLevelId(hiddenLevelId)
	local index = self:getHiddenBranchIdByHiddenLevelId(hiddenLevelId)
	if index ~= nil then
		return self.branchList[index]
	end
	return nil
end

function MetaModel:getHiddenBranchDataByBranchId( branchId  )
	return self.branchList[branchId]
end

function MetaModel:getHiddenBranchIdByHiddenLevelId(hiddenLevelId, ...)
	assert(hiddenLevelId)
	assert(#{...} == 0)

	self:initHiddenBranchListData()

	for index = 1,#self.branchList do

		if hiddenLevelId >= self.branchList[index].startHiddenLevel and
			hiddenLevelId <= self.branchList[index].endHiddenLevel then

			return index
		end
	end

	return nil
end

function MetaModel:getHiddenBranchIdByNormalLevelId(normalLevelId, ...)
	assert(normalLevelId)
	assert(#{...} == 0)

	self:initHiddenBranchListData()

	for index = 1, #self.branchList do

		if normalLevelId >= self.branchList[index].startNormalLevel and
			normalLevelId <= self.branchList[index].endNormalLevel then
			return index
		end
	end

	return nil
end

function MetaModel:getHiddenBranchIdByDependingBranch(branchId)
	for i = 1, #self.branchList do
		if self.branchList[i].dependHideAreaId == branchId then
			return i
		end
	end
	return nil
end

function MetaModel:getFullStarInHiddenRegion()
	local result = 0
	local branchList = self:getHiddenBranchDataList()
	for index = 1, #branchList do
		result = result + (branchList[index].endHiddenLevel - branchList[index].startHiddenLevel + 1) * 3
	end
	return result
end

function MetaModel:getFullStarInOpenedHiddenRegion()
	self:initHiddenBranchListData()

	local result = 0
	local branchList = self:getHiddenBranchDataList()
	for index = 1, #branchList do
		if self:isHiddenBranchCanOpen(index) then
			result = result + (branchList[index].endHiddenLevel - branchList[index].startHiddenLevel + 1) * 3
		end
	end
	return result
end

function MetaModel:markHiddenBranchOpen(hiddenBranchId)
	self.openBranchList[hiddenBranchId] = true
end

function MetaModel:markHiddenBranchClose(hiddenBranchId)
	self.openBranchList[hiddenBranchId] = nil
end

function MetaModel:isHiddenBranchUnlock(hiddenBranchId)
	if self.openBranchList then
		return self.openBranchList[hiddenBranchId]
	end
	return false
end

function MetaModel:getNeedGuideHiddenBranchId( ... )

	local function isTopLevelPassed( ... )
		local user = UserManager:getInstance():getUserRef()
		if user:getTopLevelId() == MetaManager:getInstance():getMaxNormalLevelByLevelArea() then
			local score = UserManager:getInstance():getUserScore(user:getTopLevelId())
			if score and score.star >= 1 then
				return true
			end
		end
		return false
	end

	local function hasEnterLessStar2Level( ... )

		local uid = UserManager.getInstance().uid
		local data = Localhost:readLocalLevelData(uid)
		local dataIsChanged = false

		local scores = UserManager:getInstance():getScoreRef()

		for k,v in pairs(scores) do
			-- 没有上次进入关卡时间数据,当成当前时间
			if not data[tostring(v.levelId)] then
				data[tostring(v.levelId)] = {}
			end
			if not data[tostring(v.levelId)].lastEnterTime then
				data[tostring(v.levelId)].lastEnterTime = Localhost:time()
				dataIsChanged = true
			end
		end
		if dataIsChanged then
			Localhost:writeLocalLevelData(uid,data)
		end	

		local hasLessStar2Level = false
		for k,v in pairs(scores) do
			if LevelMapManager:isNormalNode(v.levelId) then
				if v.star < 3 then
					hasLessStar2Level = true
					break
				end
			end
		end

		-- 没有当成已经进入过了
		if not hasLessStar2Level then
			return true
		end

		for k,v in pairs(scores) do
			if LevelMapManager:isNormalNode(v.levelId) then
				if v.star < 3 then
					if Localhost:time() - data[tostring(v.levelId)].lastEnterTime < 5 * 24 * 3600 * 1000 then
						return true
					end
				end
			end
		end

		return false
	end

	local function getHiddenNoPasseBranchId( ... )

		self:initHiddenBranchListData()
		for index = 1,#self.branchList do
			if self:isHiddenBranchCanShow(index) and not self:isHiddenBranchDesign(index) then
				for levelId=self.branchList[index].startHiddenLevel,self.branchList[index].endHiddenLevel do
					local score = UserManager:getInstance():getUserScore(levelId)
					if not score or score.star == 0 then
						return index
					end
				end				
			end
		end

		return nil
	end

	local lastGuideTime = tonumber(Cookie.getInstance():read(CookieKey.kHiddenAreaLastGuideTime)) or 0
	if isTopLevelPassed() then
		local nextGuideTime = lastGuideTime + 4 * 24 * 3600 * 1000
		if nextGuideTime > Localhost:time() then
			return nil
		end
	else
		if hasEnterLessStar2Level() then
			return nil
		end 

		local nextGuideTime = lastGuideTime + 7 * 24 * 3600 * 1000
		if nextGuideTime > Localhost:time() then
			return nil
		end
	end

	local branchId = getHiddenNoPasseBranchId()
	if branchId then
		Cookie.getInstance():write(CookieKey.kHiddenAreaLastGuideTime,Localhost:time())
		return branchId
	end

	return nil
end

function MetaModel:getRewardGuideHiddenBranchId( ... )

	local lastGuideTime = tonumber(Cookie.getInstance():read(CookieKey.kHiddenAreaLastRewardGuideTime)) or 0
	if Localhost:time() - lastGuideTime < 3 * 24 * 3600 * 1000 then
		return
	end

	local uid = UserManager.getInstance().uid
	for index = 1,#self.branchList do
		if self:isHiddenBranchCanOpen(index) and not self:isHiddenBranchDesign(index) then
			local endHiddenLevel = self.branchList[index].endHiddenLevel
			if UserManager.getInstance():hasPassedLevel(endHiddenLevel) then
				if not UserManager:getInstance():getUserExtendRef():isHideAreaRewardReceived(index) then

					local data = Localhost:readLocalBranchDataByBranchId(uid,index)
					if data.canRewardTime and Localhost:time() - data.canRewardTime > 3 * 24 * 3600 * 1000 then
						Cookie.getInstance():write(CookieKey.kHiddenAreaLastRewardGuideTime,Localhost:time())
						return index
					end
				end
			end
		end
	end

	return nil
end

-- 更新新的掩藏关卡
function MetaModel:getNewGuideHiddenBranchId( ... )

	local lastMaxBranchId = tonumber(Cookie.getInstance():read(CookieKey.kHiddenAreaLastMaxBranchId)) or 16

	if #self.branchList > lastMaxBranchId then
		Cookie.getInstance():write(CookieKey.kHiddenAreaLastMaxBranchId,#self.branchList)
	else
		return nil
	end

	for index = lastMaxBranchId,#self.branchList do
		if self:isHiddenBranchCanShow(index) and not self:isHiddenBranchDesign(index) then
			return index
		end
	end

	return nil
end