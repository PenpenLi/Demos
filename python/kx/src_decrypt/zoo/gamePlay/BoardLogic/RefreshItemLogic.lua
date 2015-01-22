
RefreshItemLogic = class{}

function RefreshItemLogic:checkNeedRefresh(mainLogic, rowLimit)
	local numRow = rowLimit or #mainLogic.gameItemMap
	for r = 1, numRow do
		for c = 1, #mainLogic.gameItemMap[r] do
			local r1 = r
			local c1 = c
			local r2 = r
			local c2 = c + 1
			local r3 = r + 1
			local c3 = c

			if c2 <= #mainLogic.gameItemMap[r] and (SwapItemLogic:canBeSwaped(mainLogic, r1,c1,r2,c2) == 1) then
				if SwapItemLogic:SwapedItemAndMatch(mainLogic, r1,c1,r2,c2, false) then
					return false
				end
			end
			if r3 <= #mainLogic.gameItemMap and (SwapItemLogic:canBeSwaped(mainLogic, r1,c1,r3,c3) == 1) then
				if SwapItemLogic:SwapedItemAndMatch(mainLogic, r1,c1,r3,c3, false) then
					return false
				end
			end
		end
	end

	return true
end

function RefreshItemLogic:isItemCanSwaped(item)
	if item.isUsed and not item:hasLock() and not item:hasFurball()
		and item.ItemType == GameItemType.kAnimal
		and item.ItemSpecialType ~= AnimalTypeConfig.kColor
		and item:isAvailable()
		then
		return true;
	end
	return false;
end

ColorHelpData = class{}
function ColorHelpData:ctor()
	self.ItemColorType = 0;
	self.ItemSpecialType = 0;
	self.from_pos_r = 0;
	self.from_pos_c = 0;
	self.r = 0;
	self.c = 0;
end
function ColorHelpData:create(r, c)
	local v = ColorHelpData.new()
	v.from_pos_r = r;
	v.from_pos_c = c;
	v.r = r;
	v.c = c;
	return v
end

-----随机1000次进行棋盘刷新
function RefreshItemLogic:refreshGamePlayWith1000Random(mainLogic)
	local oldGameItemMap = {}		------备份原始数据
	local colorHelpMap = {}
	local colorHelpList = {}
	local count = 0
	for r = 1, #mainLogic.gameItemMap do
		colorHelpMap[r] = {}
		oldGameItemMap[r] = {}
		for c = 1, #mainLogic.gameItemMap[r] do
			mainLogic.gameItemMap[r][c].isNeedUpdate = false
			oldGameItemMap[r][c] = mainLogic.gameItemMap[r][c]:copy()		------备份原始数据

			local data = ColorHelpData:create(r, c)
			colorHelpMap[r][c] = data

			local item = mainLogic.gameItemMap[r][c]
			if item	and RefreshItemLogic:isItemCanSwaped(item) then
				data.ItemColorType = item.ItemColorType
				data.ItemSpecialType = item.ItemSpecialType

				count = count + 1
				colorHelpList[count] = data
			else
			end
		end
	end

	local gameItemHelpMap = RefreshItemLogic:TryRandomSwapWithColorHelpMap(mainLogic, colorHelpMap, colorHelpList)

	--------循环尝试--------
	local isGetAnswer = false
	for i = 1, 1000 do
		if RefreshItemLogic:CheckNewHelpMapCanUsed(mainLogic, gameItemHelpMap) then
			print("shuffle " .. i .. " times success")
			isGetAnswer = true
			break
		else
			gameItemHelpMap = RefreshItemLogic:TryRandomSwapWithColorHelpMap(mainLogic, colorHelpMap, colorHelpList)
		end
	end

	if isGetAnswer then
		----找寻到结果--随机成功----
		return true
	else
		return false
	end
end

----尝试随机交换棋盘上的两个物体times次
function RefreshItemLogic:TryRandomSwapWithColorHelpMap(mainLogic, colorHelpMap, colorHelpList)
	
	----1.随机一阵
	for i = 1, #colorHelpList do
		local targetIndex = mainLogic.randFactory:rand(1, #colorHelpList)

		local item1 = colorHelpList[i]
		local item2 = colorHelpList[targetIndex]

		local tr = item1.r;
		local tc = item1.c;
		item1.r = item2.r;
		item1.c = item2.c;
		item2.r = tr;
		item2.c = tc;
	end

	----2.随机结束，实际交换
	local tempMap = {}			------交换后的矩阵
	for r = 1,#colorHelpMap do
		tempMap[r] = {}
	end

	for r = 1,#colorHelpMap do
		for c = 1,#colorHelpMap[r] do
			local tr = colorHelpMap[r][c].r;
			local tc = colorHelpMap[r][c].c;
			tempMap[tr][tc] = colorHelpMap[r][c];
		end
	end

	local gameItemHelpMap = {} 		-----实际物体进行交换后的map
	for r = 1,#mainLogic.gameItemMap do
		gameItemHelpMap[r] = {}
	end

	for r = 1,#tempMap do
		for c = 1,#tempMap[r] do
			local r1 = tempMap[r][c].from_pos_r;
			local c1 = tempMap[r][c].from_pos_c;
			gameItemHelpMap[r][c] = mainLogic.gameItemMap[r1][c1]:copy()
		end
	end

	return gameItemHelpMap;
end

function RefreshItemLogic:CheckNewHelpMapCanUsed(mainLogic, gameItemHelpMap)
	-------1.交换赋值
	for r=1,#mainLogic.gameItemMap do
		for c=1,#mainLogic.gameItemMap[r] do
			mainLogic.gameItemMap[r][c] = gameItemHelpMap[r][c];
		end
	end

	for r=1,#mainLogic.gameItemMap do
		for c=1,#mainLogic.gameItemMap[r] do
			if mainLogic.gameItemMap[r][c].ItemColorType ~= 0 and mainLogic:checkMatchQuick(r, c, mainLogic.gameItemMap[r][c].ItemColorType) then
				return false
			end
		end
	end
	------2.测试是否可以交换
	return not RefreshItemLogic:checkNeedRefresh(mainLogic);
end

function RefreshItemLogic:runRefreshAction(mainLogic, isProp, completeCallback)
	local numItem = 0

	for r=1,#mainLogic.gameItemMap do
		for c=1,#mainLogic.gameItemMap[r] do
			numItem = numItem + 1
		end
	end

	for r=1,#mainLogic.gameItemMap do
		for c=1,#mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			local FlyingAction = GameBoardActionDataSet:createAs(
				GameActionTargetType.kGameItemAction,
				GameItemActionType.kItemRefresh_Item_Flying,
				IntCoord:create(r,c),
				IntCoord:create(item.y, item.x),
				GamePlayConfig_Refresh_Item_Flying_Time)
			FlyingAction.addInfo = "Pass"
			if isProp then
				mainLogic:addPropAction(FlyingAction)
			else
				FlyingAction.callback = completeCallback
				mainLogic:addGameAction(FlyingAction)
			end
			item.y = r
			item.x = c
		end
	end

	return numItem
end