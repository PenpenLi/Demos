require "zoo.gamePlay.BoardAction.GameBoardActionDataSet"
require "zoo.gamePlay.BoardLogic.MatchItemLogic"
require "zoo.gamePlay.BoardLogic.SpecialMatchLogic"
----交换两个Item的逻辑-----
----mainLogic是GameBoardLogic
SwapItemLogic = class{}
--可以被交换，但是不一定有匹配
function SwapItemLogic:canBeSwaped(mainLogic, r1,c1,r2,c2)
	return SwapItemLogic:_canBeSwaped(mainLogic.boardmap, mainLogic.gameItemMap, r1,c1,r2,c2)
end

function SwapItemLogic:_canBeSwaped(_boardmap, _gameItemMap, r1,c1,r2,c2)
	if (r1 == r2 and c1 == c2 + 1) or (r1 == r2 and c1 == c2 - 1) or (r1 == r2 + 1 and c1 == c2) or (r1 == r2 - 1 and c1 == c2) then
		local board1 = _boardmap[r1][c1];
		local board2 = _boardmap[r2][c2];
		local item1 = _gameItemMap[r1][c1];
		local item2 = _gameItemMap[r2][c2];

		--相邻两个Item
		if item1:canBeSwap() and item2:canBeSwap() then
			------判断绳子
			if (r1 == r2 and c1 == c2 + 1) then ----左右
				if board1:hasLeftRope() or board2:hasRightRope() then
					return 2;
				end
			end
			if (r1 == r2 and c1 == c2 - 1) then ----左右
				if board1:hasRightRope() or board2:hasLeftRope() then
					return 2;
				end
			end
			if (r1 == r2 + 1 and c1 == c2) then ----左右
				if board1:hasTopRope() or board2:hasBottomRope() then
					return 2;
				end
			end
			if (r1 == r2 - 1 and c1 == c2) then ----左右
				if board1:hasBottomRope() or board2:hasTopRope() then
					return 2;
				end
			end

			return 1
		end
	end
	return 0
end

--交换两个Item--并且尝试匹配消除
function SwapItemLogic:SwapedItemAndMatch(mainLogic, r1, c1, r2, c2, doSwap)	--doSwap==true表示确实进行交换，并且引起相应效果，doSwap==false表示仅仅判断是否能够交换
	--1.特效交换	
	local st1 = SwapItemLogic:_trySwapedSpecialItem(mainLogic, r1,c1,r2,c2, doSwap)
	if st1 then --能够进行特效交换
		local possbileMoves = {{{ r = r1, c = c1 }, { r = r2, c = c2 }, dir = { r = r2 - r1, c = c2 - c1 } }}
		return true, possbileMoves
	else
		local st2, possbileMoves = SwapItemLogic:_trySwapedMatchItem(mainLogic, r1, c1, r2, c2, doSwap)
		if st2 then ---能够进行普通交换
			if doSwap then ------2.交换后的动作
				mainLogic.gameMode:afterSwap(r1, c1)
				mainLogic.gameMode:afterSwap(r2, c2)
			end
			return true, possbileMoves
		end
	end
	return false
end

--尝试交换两个特效
function SwapItemLogic:_trySwapedSpecialItem(mainLogic, r1,c1,r2,c2, doSwap)--doSwap==true表示确实进行交换，并且引起相应效果，doSwap==false表示仅仅判断是否能够交换
	local item1 = mainLogic.gameItemMap[r1][c1]
	local item2 = mainLogic.gameItemMap[r2][c2]
	local sp1 = item1.ItemSpecialType
	local sp2 = item2.ItemSpecialType
	local color1 = item1.ItemColorType
	local color2 = item2.ItemColorType

	local function swapItemData()
		local item1Clone = item1:copy()
		local item2Clone = item2:copy()
		item1:getAnimalLikeDataFrom(item2Clone)
		item2:getAnimalLikeDataFrom(item1Clone)
		-- 仅仅有神灯的匹配会引起block的变化
		if item1.ItemType == GameItemType.kMagicLamp or item2.ItemType == GameItemType.kMagicLamp then
			mainLogic:checkItemBlock(r1, c1)
			mainLogic:checkItemBlock(r2, c2)
			FallingItemLogic:preUpdateHelpMap(mainLogic)
		end
	end
	
	if sp1 >= AnimalTypeConfig.kLine and sp1<= AnimalTypeConfig.kColor
		and sp2 >= AnimalTypeConfig.kLine and sp2<= AnimalTypeConfig.kColor then 
		--两个都是特效
		if doSwap then ----------确实要交换
			if sp1 == sp2 and sp1 == AnimalTypeConfig.kColor then 		--鸟+鸟特效
				SpecialMatchLogic:MatchBirdBird(mainLogic, r1, c1, r2, c2) 
			elseif sp1 == AnimalTypeConfig.kColor and sp2 == AnimalTypeConfig.kWrap then 	--鸟+区域特效
				SpecialMatchLogic:BirdWrapSwapBomb(mainLogic, r1, c1, r2, c2)
			elseif sp2 == AnimalTypeConfig.kColor and sp1 == AnimalTypeConfig.kWrap then 	--鸟+区域特效
				SpecialMatchLogic:BirdWrapSwapBomb(mainLogic, r2, c2, r1, c1)
			elseif sp1 == AnimalTypeConfig.kColor and (sp2 == AnimalTypeConfig.kLine or sp2 == AnimalTypeConfig.kColumn) then 	--鸟+直线特效
				SpecialMatchLogic:BirdLineSwapBomb(mainLogic, r1, c1, r2, c2)
			elseif sp2 == AnimalTypeConfig.kColor and (sp1 == AnimalTypeConfig.kLine or sp1 == AnimalTypeConfig.kColumn) then 	--鸟+直线特效
				SpecialMatchLogic:BirdLineSwapBomb(mainLogic, r2, c2, r1, c1)
			elseif sp1 == AnimalTypeConfig.kWrap and sp2 == AnimalTypeConfig.kWrap then 	--区域+区域特效
				SpecialMatchLogic:WrapWrapSwapBomb(mainLogic, r1, c1, r2, c2)
			elseif sp1 == AnimalTypeConfig.kWrap and (sp2 == AnimalTypeConfig.kLine or sp2 == AnimalTypeConfig.kColumn) then 		--区域+直线特效
				SpecialMatchLogic:WrapLineSwapBomb(mainLogic, r1, c1, r2, c2)
			elseif sp2 == AnimalTypeConfig.kWrap and (sp1 == AnimalTypeConfig.kLine or sp1 == AnimalTypeConfig.kColumn) then 		--区域+直线特效
				SpecialMatchLogic:WrapLineSwapBomb(mainLogic, r2, c2, r1, c1)
			elseif (sp1 == AnimalTypeConfig.kLine or sp1 == AnimalTypeConfig.kColumn) 
				and (sp2 == AnimalTypeConfig.kLine or sp2 == AnimalTypeConfig.kColumn) then --直线+直线
				SpecialMatchLogic:LineLineSwapBomb(mainLogic, r1, c1, r2, c2)
			end
			swapItemData()
		end
		return true
	end

	if sp1 == AnimalTypeConfig.kColor and color2 >= AnimalTypeConfig.kBlue and color2 <= AnimalTypeConfig.kYellow then 			--鸟+颜色
		if doSwap then 
			SpecialMatchLogic:BirdColorSwapBomb(mainLogic, r1, c1, r2, c2) 
			swapItemData()
		end
		return true
	elseif sp2 == AnimalTypeConfig.kColor and color1 >= AnimalTypeConfig.kBlue and color1 <= AnimalTypeConfig.kYellow then 		--鸟+颜色
		if doSwap then 
			SpecialMatchLogic:BirdColorSwapBomb(mainLogic, r2, c2, r1, c1) 
			swapItemData()
		end
		return true
	end

	return false
end

--判断是否有match
function SwapItemLogic:_trySwapedMatchItem(mainLogic, r1, c1, r2, c2, doSwap)
	local data1 = mainLogic.gameItemMap[r1][c1]
	local data2 = mainLogic.gameItemMap[r2][c2]
	local color1 = data1.ItemColorType
	local color2 = data2.ItemColorType

	if (color1 == color2) then
        --if doSwap then
            --SpecialMatchLogic:MatchBirdBird(mainLogic, r1, c1, r2, c2)
            --return true
        --end --lxb ^_^
        return false
    end --同样的颜色交换，没有意义
	--1.临时性颜色交换
	local item1Clone = data1:copy()
	local item2Clone = data2:copy()
	data2:getAnimalLikeDataFrom(item1Clone)
	data1:getAnimalLikeDataFrom(item2Clone)

	--2.对Item(x,y)进行检查
	MatchItemLogic:cleanSwapHelpMap(mainLogic)
	local ts1, possibleMove1 = MatchItemLogic:checkMatchStep1(mainLogic, r1,c1,color2, doSwap)
	local ts2, possibleMove2 = MatchItemLogic:checkMatchStep1(mainLogic, r2,c2,color1, doSwap)
	local possibleMoves = {}

	if ts1 then
		possibleMove1 = table.union({{ r = r2, c = c2 }}, possibleMove1)
		possibleMove1["dir"] = { r = r1 - r2, c = c1 - c2 }
		table.insert(possibleMoves, possibleMove1)
	end

	if ts2 then
		possibleMove2 = table.union({{ r = r1, c = c1 }}, possibleMove2)
		possibleMove2["dir"] = { r = r2 - r1, c = c2 - c1 }
		table.insert(possibleMoves, possibleMove2)
	end

	if ts1 or ts2 then
		----成功合成, 开始修改数据
		if doSwap then
			mainLogic:addNeedCheckMatchPoint(r1, c1)
			mainLogic:addNeedCheckMatchPoint(r2, c2)

			-- 仅仅有神灯的匹配会引起block的变化
			if data1.ItemType == GameItemType.kMagicLamp or data2.ItemType == GameItemType.kMagicLamp then
				mainLogic:checkItemBlock(r1, c1)
				mainLogic:checkItemBlock(r2, c2)
				FallingItemLogic:preUpdateHelpMap(mainLogic)
			end
		else
			----不是真实交换，所以颜色数据返还
			data1:getAnimalLikeDataFrom(item1Clone)
			data2:getAnimalLikeDataFrom(item2Clone)
			data1.isNeedUpdate = false
			data2.isNeedUpdate = false
		end
		----清理帮助数组
		MatchItemLogic:cleanSwapHelpMap(mainLogic)
		
		return true, possibleMoves
	else
		-- lxb ^_^
        if doSwap then
            --if r1 == r2 then SpecialMatchLogic:BirdLineSwapBomb(mainLogic, r1, c1, r2, c2) end
            --if c1 == c2 then SpecialMatchLogic:BirdWrapSwapBomb(mainLogic, r1, c1, r2, c2) end
            --return true
        else
			data1:getAnimalLikeDataFrom(item1Clone)
			data2:getAnimalLikeDataFrom(item2Clone)
			data1.isNeedUpdate = false
			data2.isNeedUpdate = false
            return false
        end
	end
end

function SwapItemLogic:calculatePossibleSwap(mainLogic)
	local result = {}
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local r1 = r
			local c1 = c
			local r2 = r
			local c2 = c + 1
			local r3 = r + 1
			local c3 = c

			if c2 <= #mainLogic.gameItemMap[r] and SwapItemLogic:canBeSwaped(mainLogic, r1, c1, r2, c2) == 1 then
				local st1, possbileMoves = SwapItemLogic:SwapedItemAndMatch(mainLogic, r1, c1, r2, c2, false) 
				if st1 then
					result = table.union(result, possbileMoves)
				end
			end
			if r3 <= #mainLogic.gameItemMap and SwapItemLogic:canBeSwaped(mainLogic, r1, c1, r3, c3) == 1 then
				local st2, possbileMoves = SwapItemLogic:SwapedItemAndMatch(mainLogic, r1, c1, r3, c3, false)
				if st2 then
					result = table.union(result, possbileMoves)
				end
			end
		end
	end
	return result
end
