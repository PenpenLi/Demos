require 'zoo.net.Localhost'

FUUUManager = {}
FUUUManager.isGameRunning = false

function FUUUManager:init()

	local platform = UserManager.getInstance().platform
	local uid = UserManager.getInstance().uid
	local fuuuFileKey = "fuuuManagerFileKey_" .. tostring(platform) .. "_u_".. tostring(uid) .. ".ds"

	local localData = Localhost:readFromStorage(fuuuFileKey)

	if not localData then
		localData = {}
		localData.gameFailedLog = {}
		localData.fuuuData = {}
	end

	if not localData.gameFailedLog then
		localData.gameFailedLog = {}
	end

	if not localData.fuuuData then
		localData.fuuuData = {}
	end
	
	self.localData = localData
	self.fuuuFileKey = fuuuFileKey

end

function FUUUManager:onGameDefiniteFinish(result , gameBoardLogic)

	if not gameBoardLogic then
		return
	end
	
	if not self.localData.gameFailedLog["level"..gameBoardLogic.level] then
		self.localData.gameFailedLog["level"..gameBoardLogic.level] = {continuousFailures=0,historyMaxContinuousFailures=0}
	end

	local failData = self.localData.gameFailedLog["level"..gameBoardLogic.level]

	if result then
		failData.continuousFailures = 0
	else
		local cf = failData.continuousFailures
		failData.continuousFailures = failData.continuousFailures + 1
		if failData.continuousFailures > failData.historyMaxContinuousFailures then
			failData.historyMaxContinuousFailures = failData.continuousFailures
		end
	end
	
	Localhost:writeToStorage( self.localData , self.fuuuFileKey )

	self.isGameRunning = false
end

function FUUUManager:update(GameMode)
	if self.isGameRunning then
		self:onGameDefiniteFinish(false,self.mainLogic)
		self.isGameRunning = true
	else
		self.isGameRunning = true
	end
	
	self.gameMode = GameMode
	self.mainLogic = self.gameMode.mainLogic
end

function FUUUManager:lastGameIsFUUU(needDCLog)
	local result = false

	local gameModeType = nil
	local progressStr = ""
	local gameModeType = 0

	local fuuu_orderList = {}
	local fuuu_orderMap = {}

	local fuuu_animal = nil--动物	仅剩1-6动物未消除
	local fuuu_snow = nil--雪块	仅剩2个及以下一层/两层雪块未消除
	local fuuu_coin = nil--银币	仅剩5个及以下银币未消除
	local fuuu_blackfurry = nil--黑色毛球	仅剩1个黑色毛球未消除
	local fuuu_venom = nil--毒液	仅剩2个及以下毒液未消除
	local fuuu_specialpower = nil--特效 仅剩2个特效未消除
	local fuuu_swappower = nil--特效交换 仅剩1个特效交换未达成 
	local fuuu_snail = nil--蜗牛	仅剩1只蜗牛未收集
	local fuuu_honey = nil--蜂蜜	蜂蜜距离过关目标差距数量小于等于3
	local fuuu_sand = nil--流沙	仅剩3块及以下流沙未消除 
	local fuuu_greyfurry = nil--灰色毛球	距离目标剩余2个灰色毛球 关卡中有至少2个灰色毛球
	local fuuu_brownfurry = nil--褐色毛球	距离目标剩余1个褐色毛球 关卡中有至少1个褐色毛球
	local fuuu_seaanimal = nil--海洋生物	仅剩1只海洋生物未收集
	local fuuu_magicstone = nil --魔法石	距离目标剩余2个魔法石
	local fuuu_balloon = nil--气球	距离目标剩余2个气球

	if self.gameMode and self.mainLogic then

		gameModeType = self.mainLogic.theGamePlayType

		local getFuuuData = function(itemType , diff)
			local fuuu = nil

			if itemType == 1 then
				if not fuuu_animal then
					fuuu_animal = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_animal"}
				end
				fuuu = fuuu_animal
			elseif itemType == 2 then
				if not fuuu_snow then
					fuuu_snow = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_snow"}
				end
				fuuu = fuuu_snow
			elseif itemType == 3 then
				if not fuuu_coin then
					fuuu_coin = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_coin"}
				end
				fuuu = fuuu_coin
			elseif itemType == 4 then
				if not fuuu_blackfurry then
					fuuu_blackfurry = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_blackfurry"}
				end
				fuuu = fuuu_blackfurry
			elseif itemType == 5 then
				if not fuuu_venom then
					fuuu_venom = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_venom"}
				end
				fuuu = fuuu_venom
			elseif itemType == 6 then
				if not fuuu_specialpower then
					fuuu_specialpower = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_specialpower"}
				end
				fuuu = fuuu_specialpower
			elseif itemType == 7 then
				if not fuuu_swappower then
					fuuu_swappower = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_swappower"}
				end
				fuuu = fuuu_swappower
			elseif itemType == 8 then
				if not fuuu_snail then
					fuuu_snail = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_snail"}
				end
				fuuu = fuuu_snail
			elseif itemType == 9 then
				if not fuuu_honey then
					fuuu_honey = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_honey"}
				end
				fuuu = fuuu_honey
			elseif itemType == 10 then
				if not fuuu_sand then
					fuuu_sand = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_sand"}
				end
				fuuu = fuuu_sand
			elseif itemType == 11 then
				if not fuuu_greyfurry then
					fuuu_greyfurry = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_greyfurry"}
				end
				fuuu = fuuu_greyfurry
			elseif itemType == 12 then
				if not fuuu_brownfurry then
					fuuu_brownfurry = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_brownfurry"}
				end
				fuuu = fuuu_brownfurry
			elseif itemType == 13 then
				if not fuuu_seaanimal then
					fuuu_seaanimal = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_seaanimal"}
				end
				fuuu = fuuu_seaanimal
			elseif itemType == 14 then
				if not fuuu_magicstone then
					fuuu_magicstone = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_magicstone"}
				end
				fuuu = fuuu_magicstone
			elseif itemType == 15 then
				if not fuuu_balloon then
					fuuu_balloon = {cv=0,tv=0,diff=diff,ty="stage_end_fuuu_balloon"}
				end
				fuuu = fuuu_balloon
			end

			if not fuuu_orderMap[fuuu.ty] then
				table.insert( fuuu_orderList , fuuu )
				fuuu_orderMap[fuuu.ty] = true
			end

			return fuuu
		end

		local updateFuuuData = function(fuuu , orderdata)
			fuuu.tv = fuuu.tv + orderdata.v1
			if orderdata.f1 > orderdata.v1 then
				fuuu.cv = fuuu.cv + orderdata.v1
			else
				fuuu.cv = fuuu.cv + orderdata.f1
			end
		end

		local countOrderFuuu = function(theOrderList)
			
			local i,v

			for i,v in ipairs(theOrderList) do

    			local fuuuData = nil
    			if v.key1 == GameItemOrderType.kAnimal then
    				fuuuData = getFuuuData(1,6)
    				if not fuuuData.animalList then
    					fuuuData.animalList = {}
    				end
    				table.insert(fuuuData.animalList , {animal=v.key2 , cv=v.f1 , tv=v.v1})
    			elseif v.key1 == GameItemOrderType.kSpecialBomb then
    				fuuuData = getFuuuData(6,2)
    			elseif v.key1 == GameItemOrderType.kSpecialSwap then
    				fuuuData = getFuuuData(7,1)
    			elseif v.key1 == GameItemOrderType.kSpecialTarget then

    				if v.key2 == GameItemOrderType_ST.kSnowFlower then
    					fuuuData = getFuuuData(2,2)
    				elseif v.key2 == GameItemOrderType_ST.kCoin then
    					fuuuData = getFuuuData(3,5)
    				elseif v.key2 == GameItemOrderType_ST.kVenom then
    					fuuuData = getFuuuData(5,2)
    				elseif v.key2 == GameItemOrderType_ST.kSnail then
    					fuuuData = getFuuuData(8,1)
    				elseif v.key2 == GameItemOrderType_ST.kGreyCuteBall then
    					fuuuData = getFuuuData(11,2)
    				elseif v.key2 == GameItemOrderType_ST.kBrownCuteBall then
    					fuuuData = getFuuuData(12,1)
    				end

    			elseif v.key1 == GameItemOrderType.kOthers then

    				if v.key2 == GameItemOrderType_Others.kBalloon then
    					fuuuData = getFuuuData(15,2)
    				elseif v.key2 == GameItemOrderType_Others.kBlackCuteBall then
    					fuuuData = getFuuuData(4,1)
    				elseif v.key2 == GameItemOrderType_Others.kHoney then
    					fuuuData = getFuuuData(9,3)
    				elseif v.key2 == GameItemOrderType_Others.kSand then
    					fuuuData = getFuuuData(10,3)
    				elseif v.key2 == GameItemOrderType_Others.kMagicStone then
    					fuuuData = getFuuuData(14,2)
    				end

    			elseif v.key1 == GameItemOrderType.kSeaAnimal then
    				--海洋生物	仅剩1只海洋生物未收集
    				fuuuData = getFuuuData(13,1)
    				if not fuuuData.animalList then
    					fuuuData.animalList = {}
    				end
    				table.insert(fuuuData.animalList , {animal=v.key2 , cv=v.f1 , tv=v.v1})
    			end

    			if fuuuData then
    				updateFuuuData(fuuuData , v)
    			end
    		end

    		local doneNum = 0
    		local fuuuNum = 0
    		local unDoneNum = 0
    		for i,v in ipairs(fuuu_orderList) do
    			print("RRR   v.tv = " .. tostring(v.tv) .. "   v.cv = " .. tostring(v.cv))
    			if v.cv >= v.tv then
    				v.isDone = true
    				v.isFuuuDone = true
    				doneNum = doneNum + 1
    			elseif v.cv + v.diff >= v.tv then
    				v.isFuuuDone = true
    				fuuuNum = fuuuNum + 1
    			else
    				v.isFuuuDone = false
    				unDoneNum = unDoneNum + 1
    			end
				
				progressStr = progressStr 
    					.. tostring(v.ty) .. ":" 
    					.. tostring(v.cv) .. ":" 
    					.. tostring(v.tv) .. ":" 
    					.. tostring(v.isFuuuDone)

    			if v.ty == "stage_end_fuuu_animal" or v.ty == "stage_end_fuuu_seaanimal" then
    				if v.animalList then
    					for j,k in ipairs(v.animalList) do
    						progressStr = progressStr .. ":" .. k.animal .. "_" .. k.cv .. "_" .. k.tv
    					end
    				end
    				progressStr = progressStr .. ","
    			else
    				progressStr = progressStr .. ","
    			end    			
    		end

    		local conutResult = false
    		if unDoneNum <= 0 then

    			if fuuuNum == 1 and doneNum == 0 then
    				conutResult = true
    			elseif fuuuNum <= doneNum then
    				conutResult = true
    			end
    			
    		end

    		return conutResult
		end

    	if gameModeType == GamePlayType.kClassicMoves then		----步数模式==========

    		if self.mainLogic.scoreTargets then
    			
    			if tonumber(self.mainLogic.totalScore / self.mainLogic.scoreTargets[1]) > 0.95 then
					result = true
				end
				progressStr = "stage_end_fuuu_step," .. tostring(self.mainLogic.totalScore) .. ":" .. tostring(self.mainLogic.scoreTargets[1])
			end

    	elseif gameModeType == GamePlayType.kDropDown then		----掉落模式==========
    		
    		if self.mainLogic.ingredientsTotal - self.mainLogic.ingredientsCount <= 1 then
    			result = true
    		end
    		progressStr = "stage_end_fuuu_dig," .. tostring(self.mainLogic.ingredientsCount) .. ":" .. tostring(self.mainLogic.ingredientsTotal)

    	elseif gameModeType == GamePlayType.kLightUp then			----冰层消除模式======
    		print("RRR    GamePlayType.kLightUp   kLightUpLeftCount = " .. tostring(self.mainLogic.kLightUpLeftCount))
    		
    		if self.mainLogic.kLightUpLeftCount <= 2 then
    			result = true
    		end
    		progressStr = "stage_end_fuuu_ice," .. tostring(self.mainLogic.kLightUpTotal - self.mainLogic.kLightUpLeftCount) .. ":" .. tostring(self.mainLogic.kLightUpTotal)

    	elseif gameModeType == GamePlayType.kDigMove then			----步数挖地模式======
    		
    		if self.mainLogic.digJewelLeftCount <= 3 then
    			result = true
    		end
    		progressStr = "stage_end_fuuu_dig," .. tostring(self.mainLogic.digJewelLeftCount) .. ":" .. tostring(self.mainLogic.digJewelTotalCount)

    	elseif gameModeType == GamePlayType.kOrder then  			----订单模式
    		progressStr = "stage_end_fuuu_order,"
    		result = countOrderFuuu(self.mainLogic.theOrderList)

    	elseif gameModeType == GamePlayType.kDigTime then     ----时间挖地模式
    		result = false
    	elseif gameModeType == GamePlayType.kClassic then     ----时间模式
    		
    		if self.mainLogic.scoreTargets then
    			if tonumber(self.mainLogic.totalScore / self.mainLogic.scoreTargets[1]) > 0.95 then
					result = true
				end
			end
			progressStr = "stage_end_fuuu_step_time," .. tostring(self.mainLogic.totalScore) .. ":" .. tostring(self.mainLogic.scoreTargets[1])

    	elseif gameModeType == GamePlayType.kDigMoveEndless then ----无限挖地模式

    		result = false

    	elseif gameModeType == GamePlayType.kMaydayEndless then

    		result = false

    	elseif gameModeType == GamePlayType.kRabbitWeekly then

    		result = false

    	elseif gameModeType == GamePlayType.kSeaOrder then
    		progressStr = "stage_end_fuuu_sea_order,"
    		result = countOrderFuuu(self.mainLogic.theOrderList)

    	elseif gameModeType == GamePlayType.kHalloween then

    		result = false

    	elseif gameModeType == GamePlayType.kUnlockAreaDropDown then
    		
    		if self.mainLogic.ingredientsTotal - self.mainLogic.ingredientsCount <= 1 then
    			result = true
    		end
    		progressStr = "stage_end_fuuu_dig_unlock," .. tostring(self.mainLogic.ingredientsCount) .. ":" .. tostring(self.mainLogic.ingredientsTotal)
    	end

	end


	print("RRR   FUUUManager:lastGameIsFUUU   gameModeType = "  .. tostring(gameModeType) 
		.. "   result = " .. tostring(result) .. "     " .. tostring(progressStr))

	local uid = UserManager.getInstance().uid
	local ntime = os.time()
	local fuuuLogID = tostring(ntime) .. "_" .. uid
	
	if needDCLog then
		DcUtil:gameFailedFuuu( fuuuLogID , self.mainLogic.level , gameModeType , result , progressStr , self.mainLogic.totalScore )
		self.lastFuuuLogID = fuuuLogID
	end

	if not self.localData.fuuuData[fuuuLogID] then
		local fuuulocaldata = {}
		fuuulocaldata.id = fuuuLogID
		fuuulocaldata.level = self.mainLogic.level
		fuuulocaldata.gameMode = gameModeType
		fuuulocaldata.result = result
		fuuulocaldata.progressStr = progressStr
		fuuulocaldata.score = self.mainLogic.totalScore
		self.localData.fuuuData[fuuuLogID] = fuuulocaldata

		Localhost:writeToStorage( self.localData , self.fuuuFileKey )
	end

	return result , fuuuLogID
end

function FUUUManager:getLastGameFuuuID()
	return self.lastFuuuLogID
end

function FUUUManager:getFuuuDataByID(fuuuId)
	return self.localData.fuuuData[fuuuId]
end

function FUUUManager:getLevelContinuousFailNum(levelId)
	if self.localData.gameFailedLog["level"..levelId] then
		return self.localData.gameFailedLog["level"..levelId].continuousFailures
	end
	return 0
end

function FUUUManager:setDailyData(data)
	self.localData.dailyData = data
	Localhost:writeToStorage( self.localData , self.fuuuFileKey )
end

function FUUUManager:getDailyData()
	return self.localData.dailyData
end

FUUUManager:init()