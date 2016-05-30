GoldZongZiState = class(BaseStableState)

local releaseSpecialNum = 6

function GoldZongZiState:create(context)
    local v = GoldZongZiState.new()
    v.context = context
    v.mainLogic = context.mainLogic
    v.boardView = v.mainLogic.boardView
    return v
end

function GoldZongZiState:dispose()
    self.mainLogic = nil
    self.boardView = nil
    self.context = nil
    self.selectedMap = nil
    self.zongziList = nil
    self.zongziReleasedNum = 0
end

function GoldZongZiState:update(dt)
    
end

function GoldZongZiState:onEnter()
    BaseStableState.onEnter(self)
    self.nextState = nil
    self.hasItemToHandle = false
    self.selectedMap = {}
    self.zongziList = {}
    self.zongziReleasedNum = 0

    self:tryExplodeGoldZongZi()
end

function GoldZongZiState:isNormal(item)
    if (item.ItemType == GameItemType.kAnimal or item.ItemType == GameItemType.kAddMove or item.ItemType == GameItemType.kCrystal)
    and item.ItemSpecialType == 0 -- not special
    and item:isAvailable()
    --and not item:hasLock() 
    --and not item:hasFurball()
    and not self.selectedMap[item.y .. "_" .. item.x]
    then
        return true
    end
    
    return false
end

function GoldZongZiState:createSpeical(zongzi , itemList)
    
    local i
    local randList = {}
    local randListNum = releaseSpecialNum
    local function actionCallback()
        self.zongziReleasedNum = self.zongziReleasedNum + 1
        if self.zongziReleasedNum >= #self.zongziList then
            self:onActionComplete(true)
        end
    end

    if #itemList < releaseSpecialNum then
    	randListNum = #itemList
    end

    local randIndex = 1

    if randListNum > 0 then
    	for i=1,randListNum do  
    		randIndex = self.mainLogic.randFactory:rand(1, #itemList)   
    		table.insert( randList , itemList[randIndex] )
    		self.selectedMap[itemList[randIndex].r .. "_" .. itemList[randIndex].c] = true
    		table.remove( itemList , randIndex )
		end 
    end

	local action = GameBoardActionDataSet:createAs(
		GameActionTargetType.kGameItemAction,
		GameItemActionType.kItem_Gold_ZongZi_Explode,
		IntCoord:create(zongzi.y, zongzi.x),
		nil,
		GamePlayConfig_MaxAction_time
	)

	action.completeCallback = actionCallback
	action.speicalItemPos = randList
	self.mainLogic:addGameAction(action)
end

function GoldZongZiState:tryExplodeGoldZongZi()
    local mainLogic = self.mainLogic
    local gameItemMap = mainLogic.gameItemMap
    local gameBoardMap = mainLogic.boardmap
   
    local magixTileList = {}
    local magixTileUnitList = {}
    local normalList = {}
    local item = nil
    local board = nil

    local buildNormalList = function()
    	normalList = {}
		for r = 1, #gameItemMap do 
	        for c = 1, #gameItemMap[r] do
	        	item = nil
	            item = gameItemMap[r][c]
	            if item ~= nil and self:isNormal(item) and r >= 5 and r <= 9 then
	            	table.insert( normalList , {r = r, c = c} )
	            end
	        end
    	end
	end
    

    local buildMagicTile = function()
    	magixTileList = {}
    	magixTileUnitList = {}
    	for r = 1, #gameBoardMap do 
	        for c = 1, #gameBoardMap[r] do
	        	board = gameBoardMap[r][c]
	        	if board.isMagicTileAnchor then
	        		
	        		table.insert( magixTileList , {r = r, c = c , id = board.magicTileId} )

	        		for i=1,2 do
	        			for j=1,3 do
	        				table.insert( magixTileUnitList , {r = tonumber(r+i-1), c = tonumber(c+j-1) , id = board.magicTileId} )
	        			end
	        		end

	        	end
	        end
	    end
	end

	--获取某个超级地格（tileData）内部可用的小动物数量
	local getMagixTileContainAnimalNum = function(tileData)

    	local k1,v1
    	local num = 0
    	local item = nil

    	for k1, v1 in pairs(magixTileUnitList) do
    		if v1.id == tileData.id then
    			item = nil
    			if gameItemMap[v1.r] then
    				item = gameItemMap[v1.r][v1.c]
    			end
    			if item and self:isNormal(item) then
    				num = num + 1
    			end
    		end
    	end
    	return num
	end

	--以tileData所在的超级地格为中心，一圈圈的往外需找满足条件的item，并随机出neednum，插入containerList
	local randomItemAroundTile = function(tileData , neednum , containerList)
		local currLevel = 1 --外围第1圈
		local maxLevel = 8 --最多遍历8圈
		local currR = 1
		local currC = 1
		local i = 1
		local t = 5
		local y = 2
		local item = nil
		local list = {}
		local needBreak = false

		if not tileData or neednum == 0 or not containerList then
			-- print("RRR  !!!!!!!!!!!!!!!!!!!   randomItemAroundTile  Error !!!!!!!!!!!!!!!!!!!!!!!")
			return
		end

		--寻找周围，searchLevel表示外围的第几圈。第一圈表示紧贴地格的一圈
		local searchAround = function(searchLevel)
			currR = tileData.r - searchLevel
			currC = tileData.c - searchLevel
			for i=1 , tonumber(t + (searchLevel - 1)*2) do
				--遍历上下横着的两条
				
				item = nil
				if gameItemMap[currR] then
	    			item = gameItemMap[currR][tonumber(currC + i -1)]
	    		end

	    		--print("RRR   ||||||||||||| search ||||||||||||")
	    		--print("RRR   R = " .. tostring(currR) .. "   C = " .. tostring(currC + i -1) .. "  item = " .. tostring(item))
	    		if item and self:isNormal(item) then
	    			table.insert(list , item)
	    			--print("RRR   insert  Item")
	    		end
	    		--print("RRR   ------------------------------------------")

	    		item = nil
	    		local lowR = tonumber(  currR + 3 + ((searchLevel - 1)*2)  )
	    		if gameItemMap[lowR] then
	    			item = gameItemMap[lowR][tonumber(currC + i -1)]
	    		end

	    		--print("RRR   ||||||||||||| search ||||||||||||")
	    		--print("RRR   R = " .. tostring(lowR) .. "   C = " .. tostring(currC + i -1) .. "  item = " .. tostring(item))
	    		if item and self:isNormal(item) then
	    			table.insert(list , item)
	    			--print("RRR   insert  Item")
	    		end
	    		--print("RRR   ------------------------------------------")
			end

			currR = tileData.r - (searchLevel - 1)
			currC = tileData.c - searchLevel
			for i=1 , tonumber(y + (searchLevel - 1)*2) do
				--遍历左右竖着的两条

				item = nil
				if gameItemMap[currR + i - 1] then
	    			item = gameItemMap[currR + i - 1][currC]
	    		end

	    		--print("RRR   ||||||||||||| search ||||||||||||")
	    		--print("RRR   R = " .. tostring(currR + i - 1) .. "   C = " .. tostring(currC) .. "  item = " .. tostring(item))
	    		if item and self:isNormal(item) then
	    			table.insert(list , item)
	    			--print("RRR   insert  Item")
	    		end
	    		--print("RRR   ------------------------------------------")

	    		item = nil
	    		local lowC = tonumber(  currC + 4 + ((searchLevel - 1)*2)  )
				if gameItemMap[currR + i - 1] then
	    			item = gameItemMap[currR + i - 1][lowC]
	    		end

	    		--print("RRR   ||||||||||||| search ||||||||||||")
	    		--print("RRR   R = " .. tostring(currR + i - 1) .. "   C = " .. tostring(lowC) .. "  item = " .. tostring(item))
	    		if item and self:isNormal(item) then
	    			table.insert(list , item)
	    			--print("RRR   insert  Item")
	    		end
	    		--print("RRR   ------------------------------------------")
			end

			--至此，一圈扫描完毕，结果在list里，
			--如数量足够， 则随机，如不够，searchLevel+1，重新开始随机更外围的一圈
			if #list <= neednum then
				for k, v in pairs(list) do
					v.zongziSelected = true
					--如果#list <= neednum，说明当前的searchLevel下，周围的可用item全部选中也无法满足需要
					--那么把当前所有选中的item都设置为zongziSelected = true
					--这样，当某一个searchLevel下，#list > neednum了，那么整个list中，zongziSelected等于false的为最外圈item，等于true的为内圈item
				end
			end

			if #list >= neednum then
				--当前数量已满足需求，开始随机

				local selectedList = {}--非最外圈的item，它们必然会被选中，不需要随机
				local needRandomList = {}--最外圈的item，它们需要随机
				local rst = nil
				for i=1,#list do
					if list[i].zongziSelected then
						--内圈item，必然要选中
						rst = {r = list[i].y , c = list[i].x}  
						table.insert( selectedList , rst)
					else
						--最外圈item，需要随机一部分出来
						table.insert( needRandomList , list[i])
					end
				end
				--至此needRandomList中的都是最外圈的，需要随机
				local randomnum = neednum - #selectedList--需要随机的数量=总的需求数量-必然要选中的数量
				local itemIndex
				for i=1,randomnum do  
		    		itemIndex = self.mainLogic.randFactory:rand(1, #needRandomList) 
		    		rst = {r = needRandomList[itemIndex].y , c = needRandomList[itemIndex].x}   
		    		table.insert( selectedList , rst )
		    		table.remove( needRandomList , itemIndex )
				end 

				--至此selectedList已经是完整数据，包含内圈所有的item，和最外圈被随机到的item，
				--且总数应该等于neednum
				if #selectedList == neednum then
					for k, v in pairs(selectedList) do
						table.insert( containerList , v )
					end
				end
				needBreak = true--算法结束，跳出剩余循环
			end

		end

		--开始搜索，从第一圈开始往外找，一直找到第maxLevel圈
		for currLevel = 1 , maxLevel do
			searchAround(currLevel)

			if needBreak then
				break
			end
		end

		if not needBreak then
			--这时needBreak=false，说明遍历8圈后依然没有找到足够的item
			--有多少返回多少，把当前找到的都插入containerList

			local itemIndex
			for i=1,#list do  
	    		local rst = {r = list[i].y , c = list[i].x}  
	    		table.insert( containerList , rst )
			end 
		end
	end


-----------------------------------------------------------------------
    
	--找出屏幕里所有的即将爆炸（digGoldZongZiLevel == 0）的粽子
    for r = 1, #gameItemMap do
        for c = 1, #gameItemMap[r] do
            local item = gameItemMap[r][c]
            if item and item.ItemType == GameItemType.kGoldZongZi and item.digGoldZongZiLevel == 0 then
                table.insert(self.zongziList, item)
            end
        end
    end

    --如果没有即将爆炸的粽子，则跳过整个逻辑
    if #self.zongziList == 0 then
        self:onActionComplete()
        return
    end

    --遍历每一个即将爆炸粽子，给它随机releaseSpecialNum个释放特效的对象
	for zk, zv in pairs(self.zongziList) do
		buildNormalList()--构建画面中所以满足释放条件的item的合集
    	buildMagicTile()--构建画面中所有的地格的临时数据

		if #magixTileList > 0 then
			--如果画面中存在超级地格
			local maxAnimalNum = 0
	    	local maxAnimalNumTile = nil
	    	for k, v in pairs(magixTileList) do
	    		local animalNum = getMagixTileContainAnimalNum(v)
	    		if animalNum > maxAnimalNum then
	    			maxAnimalNum = animalNum
	    			maxAnimalNumTile = v
	    			--至此找出内部满足可释放特效条件的item数量最多的超级地格
	    			--将此地格作为目标地格
	    		end
	    	end

	    	local function createItemInMagicTile()
	    		--如果目标地格存在
	    		local inTileList = {}
	    		for k, v in pairs(magixTileUnitList) do
    				local item = nil
    				if v.id == maxAnimalNumTile.id then
    					if gameItemMap[v.r] then
	    					item = gameItemMap[v.r][v.c]
	    				end
	    				if item and self:isNormal(item) then
	    					table.insert(inTileList , {r=v.r,c=v.c})
	    					--首先将目标地格内部的可用item都插入inTileList
	    				end
    				end
    			end

    			if #inTileList >= releaseSpecialNum then
    				--如果此时inTileList的数量已经满足技能释放需求，则直接释放技能
	    			self:createSpeical(zv , inTileList)
	    		else
	    			--如果地格内部的item数量不够技能释放，则在地格周围继续随机，直到数量满足
	    			for k, v in pairs(inTileList) do
	    				self.selectedMap[v.r .. "_" .. v.c] = true
	    				--将之前地格内部的item都设置为已选中，避免后续算法重复选中这些地格
	    			end
	    			local rnum = releaseSpecialNum - #inTileList--在地格周围还需要随机多少个（总需求-地格内部已选中的）

	    			--在maxAnimalNumTile周围开始随机rnum个符合条件的item,并插入inTileList
	    			randomItemAroundTile(maxAnimalNumTile , rnum , inTileList)
	    			
				    --此时inTileList的item个数刚好等于releaseSpecialNum
				    self:createSpeical(zv , inTileList)
	    		end
	    	end

	    	if maxAnimalNumTile then
				local boss = self.mainLogic:getHalloweenBoss()
	 			if GamePlaySceneSkinManager:isHalloweenLevel() and not boss then
	 				--2015万圣节关卡 虽然有超级地格 但是没有boss 直接在屏幕随机
	 				self:createSpeical(zv , normalList)
	 			else
	 				createItemInMagicTile()
	 			end
	    	else
	    		--目标地格不存在，说明画面中虽然有地格，但每个地格内部都没有可用的item
	    		--那么等同于画面里没有地格，直接随机
	    		self:createSpeical(zv , normalList)
	    	end
		else
			--画面中不存在超级地格，直接在屏幕中随机
			self:createSpeical(zv , normalList)
		end
	end

end

function GoldZongZiState:getClassName()
    return "GoldZongZiState"
end

function GoldZongZiState:checkTransition()
    return self.nextState
end

function GoldZongZiState:onActionComplete()
    self.nextState = self:getNextState()	
    --self.context:onEnter()
end

function GoldZongZiState:getNextState()
    return self.context.halloweenBossStateInLoop
end

function GoldZongZiState:onExit()
    BaseStableState.onExit(self)
    self.hasItemToHandle = nil
    self.nextState = nil
    self.needCheckMatch = nil
    self.selectedMap = nil
    self.zongziList = nil
    self.zongziReleasedNum = 0
end