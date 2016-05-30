require "zoo.gamePlay.BoardLogic.BombItemLogic"
require "zoo.gamePlay.BoardLogic.MatchCoverLogic"
--------------
-----控制Match功能的Logic
MatchItemLogic = class{}

function MatchItemLogic:cleanSwapHelpMap(mainLogic)
	if mainLogic.swapHelpMap then
		for i=1, #mainLogic.gameItemMap do
			for j=1,# mainLogic.gameItemMap[i] do
				mainLogic.swapHelpMap[i][j] = 0
			end
		end
	else
		mainLogic.swapHelpMap = {}
		for i=1, #mainLogic.gameItemMap do
			mainLogic.swapHelpMap[i] = {}
			for j=1,# mainLogic.gameItemMap[i] do
				mainLogic.swapHelpMap[i][j] = 0
			end
		end
	end
	mainLogic.swapHelpList = nil;
	mainLogic.swapHelpList = {}
	mainLogic.swapHelpMakePos = nil;
	mainLogic.swapHelpMakePos = {}
end

----检测是否能对位置(r,c)调整为color进行合成
function MatchItemLogic:checkMatchStep1(mainLogic, r, c, color, doSwap)
	--print("RRR   MatchItemLogic:checkMatchStep1")
	local includePos = {}
	local colMatchIncludePos = {}
	local rowMatchIncludePos = {}
	local r_add = 1
	local sf_start = r
	local sf_end = r
	local sf_new = #mainLogic.swapHelpList + 1
	local canDeleted = false
	----颜色为0不参与匹配
	--print("RRR   MatchItemLogic:checkMatchStep1    r = " , r , "  c = " , c , "  color = " , color , "  doSwap = " , doSwap )
	if color == 0 then 
		return false
	end
	----特殊类型为鸟，不参与匹配
	if mainLogic.gameItemMap[r][c].ItemSpecialType == AnimalTypeConfig.kColor then
		return false
	end

	if not mainLogic.gameItemMap[r][c]:canBeCoverByMatch() then
		return false
	end

	local originSwapSetId = mainLogic.swapHelpMap[r][c]
	local hasCoveredByOtherMatch = true 		----测试成功，表示，这一排已经都检查过了
	for i = r-1 , 1, -1 do
		if (mainLogic.gameItemMap[i][c].ItemColorType == color) 
			and mainLogic.gameItemMap[i][c].ItemSpecialType ~= AnimalTypeConfig.kColor 		----不是魔力鸟
			and mainLogic.gameItemMap[i][c]:canBeCoverByMatch()
			then --竖排
			r_add = r_add + 1
			sf_start = i
			table.insert(colMatchIncludePos, { r = i, c = c })

			if mainLogic.swapHelpMap[i][c] > 0 then
				if originSwapSetId > 0 and originSwapSetId ~= mainLogic.swapHelpMap[i][c] then 
					hasCoveredByOtherMatch = false 
				end
			else
				hasCoveredByOtherMatch = false
			end
		else
			break
		end
	end

	for i = r+1 , #mainLogic.gameItemMap do
		if (mainLogic.gameItemMap[i][c].ItemColorType == color)
			and mainLogic.gameItemMap[i][c].ItemSpecialType ~= AnimalTypeConfig.kColor		----不是魔力鸟
			and mainLogic.gameItemMap[i][c]:canBeCoverByMatch()
			then 	--竖排
			r_add = r_add + 1
			sf_end = i
			table.insert(colMatchIncludePos, { r = i, c = c })

			if mainLogic.swapHelpMap[i][c] > 0 then
				if originSwapSetId > 0 and originSwapSetId ~= mainLogic.swapHelpMap[i][c] then 
					hasCoveredByOtherMatch = false 
				end 
			else
				hasCoveredByOtherMatch = false
			end
		else
			break
		end
	end

	if r_add >= 3 and not hasCoveredByOtherMatch then
		if doSwap then
			MatchItemLogic:_checkCombineItem(mainLogic, r,c, sf_start, sf_end, true, sf_new)
		end
		canDeleted = true
	else
		colMatchIncludePos = {}
	end

	hasCoveredByOtherMatch = true 		----测试成功，表示，这一排已经都检查过了

	sf_start = c
	sf_end = c
	local c_add = 1
	for j = c-1, 1, -1 do
		if mainLogic.gameItemMap[r][j].ItemColorType == color 
			and mainLogic.gameItemMap[r][j].ItemSpecialType ~= AnimalTypeConfig.kColor 		----不是魔力鸟
			and mainLogic.gameItemMap[r][j]:canBeCoverByMatch()
			then 		--横排
			c_add = c_add + 1
			sf_start = j
			table.insert(rowMatchIncludePos, { r = r, c = j })
			
			if mainLogic.swapHelpMap[r][j] > 0 then
				if originSwapSetId > 0 and originSwapSetId ~= mainLogic.swapHelpMap[r][j] then 
					hasCoveredByOtherMatch = false 
				end 
			else
				hasCoveredByOtherMatch = false
			end
		else
			break
		end
	end

	for j = c+1, #mainLogic.gameItemMap[r] do
		if mainLogic.gameItemMap[r][j].ItemColorType == color 
			and mainLogic.gameItemMap[r][j].ItemSpecialType ~= AnimalTypeConfig.kColor		----不是魔力鸟
			and mainLogic.gameItemMap[r][j]:canBeCoverByMatch()
			then		--横排
			c_add = c_add + 1
			sf_end = j
			table.insert(rowMatchIncludePos, { r = r, c = j })

			if mainLogic.swapHelpMap[r][j] > 0 then
				if originSwapSetId > 0 and originSwapSetId ~= mainLogic.swapHelpMap[r][j] then 
					hasCoveredByOtherMatch = false 
				end
			else
				hasCoveredByOtherMatch = false															----有0，测试失败
			end
		else
			break
		end
	end
	if c_add >= 3 and not hasCoveredByOtherMatch then
		if doSwap then
			MatchItemLogic:_checkCombineItem(mainLogic, r,c,sf_start, sf_end, false, sf_new)
		end
		canDeleted = true
	else
		rowMatchIncludePos = {}
	end

	if #colMatchIncludePos > 0 then
		includePos = colMatchIncludePos
	elseif #rowMatchIncludePos > 0 then
		includePos = rowMatchIncludePos
	end

	return canDeleted, includePos
end

----r,c 为Item的检测点
----sf_start,sf_end是范围，sf_direction表示是r方向的变化还是c方向的
----sf_new表示如果是新集合，集合的ID
function MatchItemLogic:_checkCombineItem(mainLogic, r,c, sf_start, sf_end, sf_direction, sf_new)--看看是否能合成区域特效，或者粘连性的鸟
	local addset = nil								--与此时的match有交集的match的set id list
	local crossWithOtherMatch = false 				--与其他match有交集
	local minCombineID = 0
	addset = {}
	if sf_end - sf_start >= 2 then --当可以存在一个消除时，判断是否出现交集
		if sf_direction then ----r方向
			for i = sf_start, sf_end do
				if mainLogic.swapHelpMap[i][c] ~= 0 then 
					addset[mainLogic.swapHelpMap[i][c]] = true
					crossWithOtherMatch = true
					if mainLogic.swapHelpMap[i][c] < minCombineID or minCombineID == 0 then 
						minCombineID = mainLogic.swapHelpMap[i][c]		--最小合并号
					end
				end
			end
		else
			-----c方向
			for j = sf_start, sf_end do
				if mainLogic.swapHelpMap[r][j] ~= 0 then
					addset[mainLogic.swapHelpMap[r][j]] = true
					crossWithOtherMatch = true
					if mainLogic.swapHelpMap[r][j] < minCombineID or minCombineID == 0 then 
						minCombineID = mainLogic.swapHelpMap[r][j]		--最小合并号
					end
				end
			end
		end
	else
		return 0
	end

	local checkItem = mainLogic.gameItemMap[r][c]

	local maxMix = 0

	----match中的部分item带有swapHelpMap Id, 代表此match与其他math发生交汇, 由于另一个match长度至少为3,
	----且交汇的另一match方向与此时的match垂直(由hasCoveredByOtherMatch保证两个match不存在父集与子集的关系,因此不是平行关系)
	----因此此时应该是区域或鸟特效
	if crossWithOtherMatch then 				
		if sf_end - sf_start >= 4 then ---合成鸟
			maxMix = AnimalTypeConfig.kColor
		else
			maxMix = AnimalTypeConfig.kWrap --区域特效
		end
		for i,v in pairs(addset) do
		 	if mainLogic.swapHelpList[i] > maxMix then  --如果matchData的最大合成物为鸟则放弃区域特效
		 		maxMix = mainLogic.swapHelpList[i]		--记录最大合成物
		 	end
		end

		if checkItem.ItemType == GameItemType.kDrip then
			maxMix = AnimalTypeConfig.kDrip
		end

		if minCombineID > 0 then
			for i = 1, #mainLogic.swapHelpMap do 			----合并号统一
				for j = 1, #mainLogic.swapHelpMap[i] do
					if addset[mainLogic.swapHelpMap[i][j]] then
						mainLogic.swapHelpMap[i][j] = minCombineID
					end
				end
			end
		end
		mainLogic.swapHelpList[minCombineID] = maxMix		---记录合并号生成的物体类型

		--成功合成
		MatchItemLogic:_swapHelpMakeSign(mainLogic, r, c, sf_start, sf_end, sf_direction, minCombineID)---填充合成标志--用合成ID填充
		
		return minCombineID
	else 
		--判断是否能生成直线或鸟特效
		if sf_end - sf_start >= 4 then
			if checkItem.ItemType == GameItemType.kDrip then
				maxMix = AnimalTypeConfig.kDrip
			else
				maxMix = AnimalTypeConfig.kColor
			end
			mainLogic.swapHelpList[sf_new] = maxMix
			MatchItemLogic:_swapHelpMakeSign(mainLogic, r, c, sf_start, sf_end, sf_direction, sf_new)
		elseif sf_end - sf_start == 3 then 
			if sf_direction then
				maxMix = AnimalTypeConfig.kLine	---r方向合成，生成横线特效
			else
				maxMix = AnimalTypeConfig.kColumn---c方向合成，生成列特效
			end
			if checkItem.ItemType == GameItemType.kDrip then
				maxMix = AnimalTypeConfig.kDrip
			end
			mainLogic.swapHelpList[sf_new] = maxMix
			MatchItemLogic:_swapHelpMakeSign(mainLogic, r, c, sf_start, sf_end, sf_direction, sf_new)
			return sf_new 		--返回生成的物品的集合ID
		elseif sf_end - sf_start == 2 then
			----标号表上的东西
			if checkItem.ItemType == GameItemType.kDrip then
				mainLogic.swapHelpList[sf_new] = AnimalTypeConfig.kDrip
				--mainLogic.swapHelpList[sf_new] = 1
			else
				mainLogic.swapHelpList[sf_new] = 1		---什么也不合成
			end
			MatchItemLogic:_swapHelpMakeSign(mainLogic, r, c, sf_start, sf_end, sf_direction, sf_new)
			return sf_new
		end
	end
	---完全不能合成
	return 0
end

--求特效合成点
function MatchItemLogic:calculateSpecialMergePos(mainLogic, setId)
	if not mainLogic.swapHelpMakePos[setId] then
		if mainLogic.swapInfo then
			local r1 = mainLogic.swapInfo[1].r
			local c1 = mainLogic.swapInfo[1].c
			local r2 = mainLogic.swapInfo[2].r
			local c2 = mainLogic.swapInfo[2].c
			if mainLogic.swapHelpMap[r1][c1] == setId then
				local item = mainLogic.gameItemMap[r1][c1]
				if not AnimalTypeConfig.isSpecialTypeValid(item.ItemSpecialType) and item:canBeMixToSpecialByMatch() then
					mainLogic.swapHelpMakePos[setId] = { r = r1, c = c1 }
				end
			elseif mainLogic.swapHelpMap[r2][c2] == setId then
				local item = mainLogic.gameItemMap[r2][c2]
				if not AnimalTypeConfig.isSpecialTypeValid(item.ItemSpecialType) and item:canBeMixToSpecialByMatch() then
					mainLogic.swapHelpMakePos[setId] = { r = r2, c = c2 }
				end
			end

			if mainLogic.swapHelpMakePos[setId] then
				return mainLogic.swapHelpMakePos[setId]
			end
		end

		local result = {}
		for r = 1, #mainLogic.swapHelpMap do
			for c = 1, #mainLogic.swapHelpMap[r] do
				if mainLogic.swapHelpMap[r][c] == setId then
					local item = mainLogic.gameItemMap[r][c]
					if not AnimalTypeConfig.isSpecialTypeValid(item.ItemSpecialType) and item:canBeMixToSpecialByMatch() then
						table.insert(result, {r = r, c = c})
					end
				end
			end
		end

		if #result then
			local idx = mainLogic.randFactory:rand(1, #result)
			local target = result[idx]
			mainLogic.swapHelpMakePos[setId] = target
		else
			mainLogic.swapHelpMakePos[setId] = { r = -1, c = -1 }
		end
	end

	return mainLogic.swapHelpMakePos[setId]
end

--交换标志填充
function MatchItemLogic:_swapHelpMakeSign(mainLogic, r,c, sf_start, sf_end, sf_direction, sf_new)
	if sf_direction then
		for i = sf_start, sf_end do
			mainLogic.swapHelpMap[i][c] = sf_new
		end
	else
		for j = sf_start, sf_end do
			mainLogic.swapHelpMap[r][j] = sf_new
		end
	end
end

----成功合成和消除
function MatchItemLogic:_MatchSuccessAndMix(mainLogic)
	for r = 1, #mainLogic.swapHelpMap do
		for c = 1, #mainLogic.swapHelpMap[r] do
			if mainLogic.swapHelpMap[r][c] > 0 then 		----有合成
				local matchItem = mainLogic.gameItemMap[r][c]
				local setId = mainLogic.swapHelpMap[r][c]
				local color = matchItem.ItemColorType
				local needDeleted = true
				
				local specialType = mainLogic.swapHelpList[setId] ----通过集合编号找到特效类型
				
				if specialType and AnimalTypeConfig.isSpecialTypeValid(specialType) then 	----合成了东西   1表示进行了普通消除
					-- local pos = mainLogic.swapHelpMakePos[setId]
					local pos = MatchItemLogic:calculateSpecialMergePos(mainLogic, setId)

					if pos and pos.r ~= -1 and pos.c ~= -1 then

						if pos.r == r and pos.c == c then
							--合成时需要为原有位置上的普通动物消除数量额外计数
							mainLogic:tryDoOrderList(r, c, GameItemOrderType.kAnimal, matchItem.ItemColorType)
							-- 给水晶石充能
							if matchItem:canChargeCrystalStone() then
								GameExtandPlayLogic:chargeCrystalStone(mainLogic, r, c, matchItem.ItemColorType)
							end

							--修改数据，生成新物品
							if (specialType == AnimalTypeConfig.kColor and color ~= 0) then
								color = 0
							end
							if matchItem.ItemType == GameItemType.kCrystal then
								ProductItemLogic:shoundCome(mainLogic, GameItemType.kCrystal)
							end
							GameExtandPlayLogic:itemDestroyHandler(mainLogic, r, c)

							if matchItem.ItemType == GameItemType.kDrip then

								if _G.test_DripMode == 2 then
									--print("RRR   【MatchItemLogic:_MatchSuccessAndMix】1  " , r , c )
									--if not matchItem.startDripCastingAction then
										matchItem.dripState = DripState.kGrow
										matchItem.dripLeaderPos = IntCoord:create( pos.c , pos.r )
										mainLogic:checkItemBlock(r, c)

										--matchItem:AddItemStatus(GameItemStatusType.kIsMatch)------作用是注册一个状态，防止播放两次消除动画
										--matchItem.gotoPos = nil
										--matchItem.comePos = nil
										GameExtandPlayLogic:__dripCasting( mainLogic, r, c )
									--end
								else
									matchItem.dripState = DripState.kGrow
									matchItem.dripLeaderPos = IntCoord:create( pos.c , pos.r )
									mainLogic:checkItemBlock(r, c)
								end

							else
								matchItem.oldItemType = matchItem.ItemType 
								matchItem.ItemType = GameItemType.kAnimal
								matchItem:changeItemType(color, specialType)
								mainLogic.swapHelpMap[r][c] = -mainLogic.swapHelpMap[r][c]		--生成后不再属于等待消除的数据
							end
							
							----播放特效生成动画
							needDeleted = false

							local boardView = mainLogic.boardView
							local itemView = boardView.baseMap[r][c]
							itemView:updateByNewItemData(matchItem)
							
							matchItem.isNeedUpdate = true

							----声音
							if specialType == AnimalTypeConfig.kLine or specialType == AnimalTypeConfig.kColumn then
								GamePlayMusicPlayer:playEffect(GameMusicType.kCreateLine)
							elseif specialType == AnimalTypeConfig.kWrap then
								GamePlayMusicPlayer:playEffect(GameMusicType.kCreateWrap)
							elseif specialType == AnimalTypeConfig.kColor then
								GamePlayMusicPlayer:playEffect(GameMusicType.kCreateColor)
							end
						else

							if matchItem.ItemType == GameItemType.kDrip then

								if _G.test_DripMode == 2 then
									--if not matchItem.startDripCastingAction then
										matchItem.dripState = DripState.kReadyToMove
										matchItem.dripLeaderPos = IntCoord:create( pos.c , pos.r )
										mainLogic:checkItemBlock(r, c)

										--matchItem:AddItemStatus(GameItemStatusType.kIsMatch)------作用是注册一个状态，防止播放两次消除动画
										--matchItem.gotoPos = nil
										--matchItem.comePos = nil
										GameExtandPlayLogic:__dripCasting( mainLogic, r, c )
									--end
								else
									matchItem.dripState = DripState.kReadyToMove
									matchItem.dripLeaderPos = IntCoord:create( pos.c , pos.r )
									mainLogic:checkItemBlock(r, c)
								end

								needDeleted = false
							end
						end
					end
				end

				----2.播放rc的消除动画
				if needDeleted then
					local item = matchItem
					if item:canBeEliminateByMatch() then
						item:AddItemStatus(GameItemStatusType.kIsMatch)------作用是注册一个状态，防止播放两次消除动画
						item.gotoPos = nil
						item.comePos = nil
						if item.ItemType == GameItemType.kCrystal then
							ProductItemLogic:shoundCome(mainLogic, GameItemType.kCrystal)
						end
					end
				end
			end
		end
	end

	mainLogic.swapInfo = nil

	----3.match对地图的影响----to do
	MatchCoverLogic:signEffectByMatchHelpMap(mainLogic)
	MatchCoverLogic:doEffectByMatchHelpMap(mainLogic)

	----4.记录由match引起的特效爆破包含的matchData,用于破冰运算,
	----对于由match引起的特效爆炸,不再重复爆破match点内的冰块
	BombItemLogic:BombByMatch(mainLogic)
end

function MatchItemLogic:checkPossibleMatch(mainLogic)
	if mainLogic.isCrystalStoneInHandling then 
		return false 
	end

	MatchItemLogic:cleanSwapHelpMap(mainLogic)
	-----全地图落点判断------
	local needMix = false
	local output = "need check match point "
	local flag = false
	for i,v in ipairs(mainLogic.needCheckMatchList) do
		local r = v.r
		local c = v.c
		if mainLogic.gameItemMap[r][c].isUsed == true then
			local item = mainLogic.gameItemMap[r][c]
			local color = item.ItemColorType
			flag = true
			output = output .. string.format("(%d, %d) ", r, c)
			if MatchItemLogic:checkMatchStep1(mainLogic, r, c, color, true) then
				needMix = true
				-- mainLogic.gameItemMap[r][c].isNeedUpdate = true
			end
		end
	end

	-- if flag then
		-- print(output)
	-- end

	-----全地图match------
	if needMix then 
		MatchItemLogic:_MatchSuccessAndMix(mainLogic)
	end

	mainLogic:cleanNeedCheckMatchList()
	MatchItemLogic:cleanSwapHelpMap(mainLogic)
	return needMix
end