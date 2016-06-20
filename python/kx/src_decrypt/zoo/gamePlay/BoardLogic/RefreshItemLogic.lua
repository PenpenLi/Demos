-- helper functions
local function swapInTable(table, i, j)
	local t = table[i]
	table[i] = table[j]
	table[j] = t
end

local function swapInMatrix(matrix, r1, c1, r2, c2)
	local t = matrix[r1][c1]
	matrix[r1][c1] = matrix[r2][c2]
	matrix[r2][c2] = t
end

local function getColorOfGameItem(r, c, gameItemMap)
	local color = 0
	if r > 0 and r <= #gameItemMap and c > 0 and c <= #gameItemMap[r] then
		local item = gameItemMap[r][c]
		if item:canBeCoverByMatch() then
			color = item.ItemColorType
		end
	end
	return color
end

local function tryAssignItemWithColor(selectionPool, sourceGameItemMap, destGameItemMap, position, color, isSpecial)
	for r, row in pairs(selectionPool.items) do
		for c, col in pairs(row) do
			local item = sourceGameItemMap[r][c]
			if (not isSpecial and color ~= nil and item.ItemColorType == color)
			or (not isSpecial and color == nil)
			or (isSpecial == true and AnimalTypeConfig.isSpecialTypeValid(item.ItemSpecialType))
			then
				destGameItemMap[position.r][position.c] = item:copy()
				selectionPool.items[r][c] = nil
				table.getMapValue(selectionPool.colors, item.ItemColorType).count = table.getMapValue(selectionPool.colors, item.ItemColorType).count - 1
				return true
			end
		end
	end

	return false
end

local function isItemInFixedPositions(r, c, fixedPositions)
	for k, v in pairs(fixedPositions) do
		if r == v.r and c == v.c then
			return true
		end
	end
	return false
end


local function checkMatchQuick(r, c, gameItemMap)
	local color = getColorOfGameItem(r, c, gameItemMap)
	local x1 = getColorOfGameItem(r - 2 , c, gameItemMap)
	local x2 = getColorOfGameItem(r - 1 , c, gameItemMap)
	local x3 = getColorOfGameItem(r + 1 , c, gameItemMap)
	local x4 = getColorOfGameItem(r + 2 , c, gameItemMap)

	local y1 = getColorOfGameItem(r , c - 2, gameItemMap)
	local y2 = getColorOfGameItem(r , c - 1, gameItemMap)
	local y3 = getColorOfGameItem(r , c + 1, gameItemMap)
	local y4 = getColorOfGameItem(r , c + 2, gameItemMap)

	if color ~= 0 then
		if (color == x2 and x1 == x2)
			or (color == x2 and color == x3)
			or (color == x3 and color == x4)
			or (color == y2 and y1 == y2)
			or (color == y2 and y3 == y2)
			or (color == y3 and y3 == y4)
			then
			return true
		end
	end
	return false
end

local function tryExchangeItemColor(newGameItemMap, needExchangeMap, position, fixedPositions)
	for r = 1, #newGameItemMap do
		for c = 1, #newGameItemMap[r] do
			local item = newGameItemMap[r][c]
			local color = item.ItemColorType
			if RefreshItemLogic.isItemRefreshable(item) 
			and not isItemInFixedPositions(r, c, fixedPositions)
			and AnimalTypeConfig.isColorTypeValid(color) --[[or color == AnimalTypeConfig.kDrip]] then
				local banned = false
				-- 检查颜色是否被ban
				for k, v in pairs(needExchangeMap[position.r][position.c].banColor) do
					if k == color then
						banned = true
						break
					end
				end
				if not banned then
					-- 检查交换后是否产生匹配
					swapInMatrix(newGameItemMap, r, c, position.r, position.c)
					if checkMatchQuick(r, c, newGameItemMap) 
					or checkMatchQuick(position.r, position.c, newGameItemMap) then
						-- 产生匹配，不能交换，再换回来
						swapInMatrix(newGameItemMap, r, c, position.r, position.c)
					else
						return true
					end
				end
			end
		end
	end
	return false
end

local function getNeedExchangeMap(newGameItemMap, fixedPositions)
	-- 消除直接匹配
	local needExchangeMap = {}
	for r = 1, #newGameItemMap do
		needExchangeMap[r] = {}
		for c = 1, #newGameItemMap[r] do
			needExchangeMap[r][c] = {item = nil, banColor = {}}
		end
	end

	for r = 1, #newGameItemMap do
		for c = 1, #newGameItemMap[r] do
			local item1 = newGameItemMap[r][c]
			local item2 = newGameItemMap[r][c+1]
			local item3 = newGameItemMap[r][c+2]
			if item1 and item2 and item3 and item1.isUsed and item2.isUsed and item3.isUsed 
			and RefreshItemLogic.isItemMatchable(item1) and RefreshItemLogic.isItemMatchable(item2) and RefreshItemLogic.isItemMatchable(item3)
			and ( AnimalTypeConfig.isColorTypeValid(item1.ItemColorType) --[[or item1.ItemColorType == AnimalTypeConfig.kDrip]] )
			and (item1.ItemColorType == item2.ItemColorType and item2.ItemColorType == item3.ItemColorType)
			then
				-- 标记item需要移走，并记录此处不接受的颜色
				if not isItemInFixedPositions(r, c, fixedPositions) and RefreshItemLogic.isItemRefreshable(item1) then
					needExchangeMap[r][c].item = item1
					needExchangeMap[r][c].banColor[item1.ItemColorType] = true
				elseif not isItemInFixedPositions(r, c+1, fixedPositions) and RefreshItemLogic.isItemRefreshable(item2) then
					needExchangeMap[r][c+1].item = item2
					needExchangeMap[r][c+1].banColor[item2.ItemColorType] = true
				elseif not isItemInFixedPositions(r, c+2, fixedPositions) and RefreshItemLogic.isItemRefreshable(item3) then
					needExchangeMap[r][c+2].item = item3
					needExchangeMap[r][c+2].banColor[item3.ItemColorType] = true
				else
					-- 出错：三个item都不能被移走，但是又产生了三消，说明本次刷新失败
					return false, needExchangeMap
				end
			end

			if newGameItemMap[r+1] and newGameItemMap[r+2] then
				local item1 = newGameItemMap[r][c]
				local item2 = newGameItemMap[r+1][c]
				local item3 = newGameItemMap[r+2][c]
				if item1 and item2 and item3 and item1.isUsed and item2.isUsed and item3.isUsed 
				and RefreshItemLogic.isItemMatchable(item1) and RefreshItemLogic.isItemMatchable(item2) and RefreshItemLogic.isItemMatchable(item3)
				and ( AnimalTypeConfig.isColorTypeValid(item1.ItemColorType) --[[or item1.ItemColorType == AnimalTypeConfig.kDrip]] )
				and (item1.ItemColorType == item2.ItemColorType and item2.ItemColorType == item3.ItemColorType)
				then
					-- 标记item需要移走，并记录此处不接受的颜色
					if not isItemInFixedPositions(r, c, fixedPositions) and RefreshItemLogic.isItemRefreshable(item1) then
						needExchangeMap[r][c].item = item1
						needExchangeMap[r][c].banColor[item1.ItemColorType] = true
					elseif not isItemInFixedPositions(r+1, c, fixedPositions) and RefreshItemLogic.isItemRefreshable(item2) then
						needExchangeMap[r+1][c].item = item2
						needExchangeMap[r+1][c].banColor[item2.ItemColorType] = true
					elseif not isItemInFixedPositions(r+2, c, fixedPositions) and RefreshItemLogic.isItemRefreshable(item3) then
						needExchangeMap[r+2][c].item = item3
						needExchangeMap[r+2][c].banColor[item3.ItemColorType] = true
					else
						return false, needExchangeMap
					end
				end
			end
		end
	end
	return true, needExchangeMap
end

local function checkFailure(gameItemMap)
	for r=1,#gameItemMap do
		for c=1,#gameItemMap[r] do
			if gameItemMap[r][c].ItemColorType ~= 0 and checkMatchQuick(r, c, gameItemMap) then
				return true
			end
		end
	end
	return false
end


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

---------------------Special Swap Area -------------------
--             _____________   _____________ 
--            | A Position |  | B Position | 
--            -------------   -------------   
----------------------------------------------------------   

SpecialSwapArea = class({})
function SpecialSwapArea:ctor(posA, direction)
	self.direction = direction
	self.posA = posA
	if self.direction == 'U' then
		self.posB = {r = posA.r + 1, c = posA.c}
	elseif self.direction == 'L' then
		self.posB = {r = posA.r, c = posA.c + 1}
	end
end

function SpecialSwapArea:create(posA, direction)
	local instance = SpecialSwapArea.new(posA, direction)
	return instance
end

function SpecialSwapArea:isValide(mainLogic)
	if not mainLogic.gameItemMap[self.posA.r] 
	or not mainLogic.gameItemMap[self.posB.r] then
		return false
	end
	local itemA = mainLogic.gameItemMap[self.posA.r][self.posA.c]
	local itemB = mainLogic.gameItemMap[self.posB.r][self.posB.c]

	if itemA and itemB then
		if (RefreshItemLogic.isItemRefreshable(itemA) and RefreshItemLogic.isItemRefreshable(itemB))
		or (itemA.ItemSpecialType == AnimalTypeConfig.kColor and RefreshItemLogic.isItemMovable(itemA) and (itemB.ItemSpecialType == AnimalTypeConfig.kColor or RefreshItemLogic.isItemMovable(itemB) and RefreshItemLogic.isItemMatchable(itemB)))
		or (itemB.ItemSpecialType == AnimalTypeConfig.kColor and RefreshItemLogic.isItemMovable(itemB)  and (itemA.ItemSpecialType == AnimalTypeConfig.kColor or RefreshItemLogic.isItemMovable(itemA) and RefreshItemLogic.isItemMatchable(itemA))) 
		or (itemA.ItemSpecialType == AnimalTypeConfig.kColor and RefreshItemLogic.isItemMovable(itemA)  and itemB.ItemSpecialType == AnimalTypeConfig.kColor and RefreshItemLogic.isItemMovable(itemB) )

		then
			local boardA = mainLogic.boardmap[self.posA.r][self.posA.c]
			local boardB = mainLogic.boardmap[self.posB.r][self.posB.c]
			if self.direction == 'U' then
				if boardA:hasBottomRope() or boardB:hasTopRope() then
					return false
				end
			elseif self.direction == 'L' then
				if boardA:hasRightRope() or boardB:hasLeftRope() then
					return false
				end
			end
			return true
		end
	end
	return false
end


------------------------ Swap Area ------------------------
--                   _____________
--   Type T         | A Position |
--                  ------------- 
--   _____________   _____________    _____________
--  | B Position |  | D Position |   | C Position |
--  -------------   -------------    -------------
--
--------------------------------------------------------

------------------------ Swap Area ------------------------
--                                    _____________
--   Type L                          | A Position |
--                                   ------------- 
--   _____________   _____________    _____________
--  | B Position |  | C Position |   | D Position |
--  -------------   -------------    -------------
--
--------------------------------------------------------
------------------------ Swap Area ------------------------
--            _____________
--   Type RL  | A Position |   (Reverse L)
--           ------------- 
--            _____________   _____________    _____________
--           | D Position |  | C Position |   | B Position |
--           -------------   -------------    -------------
--
--------------------------------------------------------

------------------------ Swap Area ------------------------
--            
--   Type I  
--            _____________   _____________    _____________    _____________
--           | B Position |  | C Position |   | D Position |   | A Position |
--           -------------   -------------    -------------    ------------- 
--
--------------------------------------------------------

-- A是可以移动的，带颜色的
-- BC是带颜色的
-- D是可以移动的，颜色与BC不同的（如果有颜色）

SwapArea = class({})

function SwapArea:ctor(posD, type, direction)
	self.type = type
	self.direction = direction
	if type == 'T' then
		if direction == 'L' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c - 1}
			self.posB = {r = posD.r + 1, 	c = posD.c}
			self.posC = {r = posD.r - 1, 	c = posD.c}
		elseif direction == 'R' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c + 1}
			self.posB = {r = posD.r - 1, 	c = posD.c}
			self.posC = {r = posD.r + 1, 	c = posD.c}
		elseif direction == 'U' then
			self.posD = posD
			self.posA = {r = posD.r - 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c - 1}
			self.posC = {r = posD.r, 		c = posD.c + 1}

		elseif direction == 'D' then
			self.posD = posD
			self.posA = {r = posD.r + 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c + 1}
			self.posC = {r = posD.r, 		c = posD.c - 1}
		end

	elseif type == 'L' then
		if direction == 'L' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c - 1}
			self.posB = {r = posD.r + 2, 	c = posD.c}
			self.posC = {r = posD.r + 1, 	c = posD.c}

		elseif direction == 'R' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c + 1}
			self.posB = {r = posD.r - 2, 	c = posD.c}
			self.posC = {r = posD.r - 1, 	c = posD.c}
		elseif direction == 'U' then
			self.posD = posD
			self.posA = {r = posD.r - 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c - 2}
			self.posC = {r = posD.r, 		c = posD.c - 1}

		elseif direction == 'D' then
			self.posD = posD
			self.posA = {r = posD.r + 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c + 2}
			self.posC = {r = posD.r, 		c = posD.c + 1}
		end
	elseif type == 'RL' then
		if direction == 'L' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c - 1}
			self.posB = {r = posD.r - 2, 	c = posD.c}
			self.posC = {r = posD.r - 1, 	c = posD.c}

		elseif direction == 'R' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c + 1}
			self.posB = {r = posD.r + 2, 	c = posD.c}
			self.posC = {r = posD.r + 1, 	c = posD.c}
		elseif direction == 'U' then
			self.posD = posD
			self.posA = {r = posD.r - 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c + 2}
			self.posC = {r = posD.r, 		c = posD.c + 1}

		elseif direction == 'D' then
			self.posD = posD
			self.posA = {r = posD.r + 1, 	c = posD.c}
			self.posB = {r = posD.r, 		c = posD.c - 2}
			self.posC = {r = posD.r, 		c = posD.c - 1}
		end
	elseif type == 'I' then
		if direction == 'L' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c - 1}
			self.posB = {r = posD.r, 		c = posD.c + 2}
			self.posC = {r = posD.r, 		c = posD.c + 1}

		elseif direction == 'R' then
			self.posD = posD
			self.posA = {r = posD.r, 		c = posD.c + 1}
			self.posB = {r = posD.r, 		c = posD.c - 2}
			self.posC = {r = posD.r, 		c = posD.c - 1}
		elseif direction == 'U' then
			self.posD = posD
			self.posA = {r = posD.r - 1, 	c = posD.c}
			self.posB = {r = posD.r + 2, 	c = posD.c}
			self.posC = {r = posD.r + 1, 	c = posD.c}

		elseif direction == 'D' then
			self.posD = posD
			self.posA = {r = posD.r + 1, 	c = posD.c}
			self.posB = {r = posD.r - 2, 	c = posD.c}
			self.posC = {r = posD.r - 1, 	c = posD.c}
		end
	end
end

function SwapArea:isValide(mainLogic)
	local gameItemMap = mainLogic.gameItemMap

	if not gameItemMap[self.posA.r] or not gameItemMap[self.posB.r] 
	or not gameItemMap[self.posC.r] or not gameItemMap[self.posD.r] then
		return false
	end

	local itemA = gameItemMap[self.posA.r][self.posA.c]
	local itemB = gameItemMap[self.posB.r][self.posB.c]
	local itemC = gameItemMap[self.posC.r][self.posC.c]
	local itemD = gameItemMap[self.posD.r][self.posD.c]

	if itemA and itemB and itemC and itemD 
	and RefreshItemLogic.isItemMovable(itemA) and RefreshItemLogic.isItemMatchable(itemA)
	and RefreshItemLogic.isItemMatchable(itemB) and RefreshItemLogic.isItemMatchable(itemC)
	and RefreshItemLogic.isItemMovable(itemD) 
	then 
		local boardA = mainLogic.boardmap[self.posA.r][self.posA.c]
		local boardB = mainLogic.boardmap[self.posB.r][self.posB.c]
		local boardC = mainLogic.boardmap[self.posC.r][self.posC.c]
		local boardD = mainLogic.boardmap[self.posD.r][self.posD.c]

		-- 判断AD之间是否有绳子
		if self.direction == 'U' then
			if boardA:hasBottomRope() or boardD:hasTopRope() then
				return false
			end
		elseif self.direction == 'D' then
			if boardA:hasTopRope() or boardD:hasBottomRope() then
				return false
			end
		elseif self.direction == 'L' then
			if boardA:hasRightRope() or boardD:hasLeftRope() then
				return false
			end
		elseif self.direction == 'R' then
			if boardA:hasLeftRope() or boardD:hasRightRope() then
				return false
			end
		end

		return true
	end 
	return false
end

function SwapArea:create(posD, type, direction)
	local instance = SwapArea.new(posD, type, direction)
	return instance
end

function RefreshItemLogic.isItemRefreshable(item)
	if item.isUsed and not item:hasLock() and not item:hasFurball()
		and (item.ItemType == GameItemType.kAnimal --[[or item.ItemType == GameItemType.kDrip]])
		and item.ItemSpecialType ~= AnimalTypeConfig.kColor
		and item:isAvailable()
		then
		return true;
	end
	return false;
end

function RefreshItemLogic.isItemMatchable(item)
	if item.isUsed and not item:hasFurball()
		and item:isColorful()
		and item.ItemSpecialType ~= AnimalTypeConfig.kColor
		and item:isAvailable()
		then
		return true;
	end
	return false;
end

function RefreshItemLogic.isItemMovable(item)
	return item:canBeSwap()
end

function RefreshItemLogic.isItemSwapAreaValid(mainLogic, r, c)
	if SwapArea:create({r=r, c=c+1}, 'T', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'T', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'T', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'T', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'T', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'T', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'T', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+1}, 'T', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'T', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'T', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+1}, 'T', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'T', 'D'):isValide(mainLogic) then return true end

	if SwapArea:create({r=r, c=c+1}, 'L', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-2, c=c}, 'L', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'L', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'L', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'L', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+2, c=c}, 'L', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'L', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+1}, 'L', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+2}, 'L', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'L', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'L', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-2}, 'L', 'D'):isValide(mainLogic) then return true end

	if SwapArea:create({r=r, c=c+1}, 'RL', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'RL', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+2, c=c}, 'RL', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'RL', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'RL', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-2, c=c}, 'RL', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'RL', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'RL', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-2}, 'RL', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'RL', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+1}, 'RL', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+2}, 'RL', 'D'):isValide(mainLogic) then return true end

	if SwapArea:create({r=r, c=c+1}, 'I', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'I', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-2}, 'I', 'L'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c-1}, 'I', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+1}, 'I', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r, c=c+2}, 'I', 'R'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'I', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'I', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-2, c=c}, 'I', 'U'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r-1, c=c}, 'I', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+1, c=c}, 'I', 'D'):isValide(mainLogic) then return true end
	if SwapArea:create({r=r+2, c=c}, 'I', 'D'):isValide(mainLogic) then return true end
	
	return false
end

function RefreshItemLogic.getProcessedGameBoard(mainLogic)

	local gameItemMap = mainLogic.gameItemMap 
	local swap_areas = {}
	local special_swap_areas = {}

	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local t1 = SwapArea:create({r=r, c=c}, 'T', 'L')
			if t1:isValide(mainLogic) then table.insert(swap_areas, t1) end
			local t2 = SwapArea:create({r=r, c=c}, 'T', 'R')
			if t2:isValide(mainLogic) then table.insert(swap_areas, t2) end
			local t3 = SwapArea:create({r=r, c=c}, 'T', 'U')
			if t3:isValide(mainLogic) then table.insert(swap_areas, t3) end
			local t4 = SwapArea:create({r=r, c=c}, 'T', 'D')
			if t4:isValide(mainLogic) then table.insert(swap_areas, t4) end
			local t5 = SwapArea:create({r=r, c=c}, 'L', 'L')
			if t5:isValide(mainLogic) then table.insert(swap_areas, t5) end
			local t6 = SwapArea:create({r=r, c=c}, 'L', 'R')
			if t6:isValide(mainLogic) then table.insert(swap_areas, t6) end
			local t7 = SwapArea:create({r=r, c=c}, 'L', 'U')
			if t7:isValide(mainLogic) then table.insert(swap_areas, t7) end
			local t8 = SwapArea:create({r=r, c=c}, 'L', 'D')
			if t8:isValide(mainLogic) then table.insert(swap_areas, t8) end
			local t9 = SwapArea:create({r=r, c=c}, 'RL', 'L')
			if t9:isValide(mainLogic) then table.insert(swap_areas, t9) end
			local t10 = SwapArea:create({r=r, c=c}, 'RL', 'R')
			if t10:isValide(mainLogic) then table.insert(swap_areas, t10) end
			local t11 = SwapArea:create({r=r, c=c}, 'RL', 'U')
			if t11:isValide(mainLogic) then table.insert(swap_areas, t11) end
			local t12 = SwapArea:create({r=r, c=c}, 'RL', 'D')
			if t12:isValide(mainLogic) then table.insert(swap_areas, t12) end
			local t13 = SwapArea:create({r=r, c=c}, 'I', 'L')
			if t13:isValide(mainLogic) then table.insert(swap_areas, t13) end
			local t14 = SwapArea:create({r=r, c=c}, 'I', 'R')
			if t14:isValide(mainLogic) then table.insert(swap_areas, t14) end
			local t15 = SwapArea:create({r=r, c=c}, 'I', 'U')
			if t15:isValide(mainLogic) then table.insert(swap_areas, t15) end
			local t16 = SwapArea:create({r=r, c=c}, 'I', 'D')
			if t16:isValide(mainLogic) then table.insert(swap_areas, t16) end

			local s1 = SpecialSwapArea:create({r=r, c=c}, 'U')
			if s1:isValide(mainLogic) then table.insert(special_swap_areas, s1) end
			local s2 = SpecialSwapArea:create({r=r, c=c}, 'L')
			if s2:isValide(mainLogic) then table.insert(special_swap_areas, s2) end

		end
	end

	-- print("TOTAL COUNT", #swap_areas)
	-- for k, v in pairs(swap_areas) do
	-- 	print('')
	-- 	print('TYPE', v.type, 'DIRECTION', v.direction)
	-- 	print('A pos: ', v.posA.r, v.posA.c)
	-- 	print('B pos: ', v.posB.r, v.posB.c)
	-- 	print('C pos: ', v.posC.r, v.posC.c)
	-- 	print('D pos: ', v.posD.r, v.posD.c)
	-- end

	-- print('TOTAL SPECIAL COUNT', #special_swap_areas)
	-- for k, v in pairs(special_swap_areas) do
	-- 	print('')
	-- 	print('DIRECTION', v.direction)
	-- 	print('A pos: ', v.posA.r, v.posA.c)
	-- 	print('B pos: ', v.posB.r, v.posB.c)
	-- end

	-- 随机交换n次，打乱次序
	for i = 1, 2 * #swap_areas do 
		local selector = mainLogic.randFactory:rand(1, #swap_areas)
		swapInTable(swap_areas, 1, selector)
	end

	for i = 1, 2 * #special_swap_areas do 
		local selector = mainLogic.randFactory:rand(1, #special_swap_areas)
		swapInTable(special_swap_areas, 1, selector)
	end

	-- print('RANDOMIZE T AREAS: ')
	-- for k, v in pairs(swap_areas) do
	-- 	print(v.posD.r, v.posD.c, v.type, v.direction)
	-- end



	local refreshableItems = {}
	refreshableItems.items = {}
	for r = 1, #gameItemMap do 
		refreshableItems.items[r] = {}
	end
	refreshableItems.colors = {
		[AnimalTypeConfig.kBlue] = {count = 0}, 
		[AnimalTypeConfig.kGreen] = {count = 0}, 
		[AnimalTypeConfig.kOrange] = {count = 0}, 
		[AnimalTypeConfig.kPurple] = {count = 0}, 
		[AnimalTypeConfig.kRed] = {count = 0}, 
		[AnimalTypeConfig.kYellow] = {count = 0},
		[AnimalTypeConfig.kDrip] = {count = 0},
	}

	-- 记录参与刷新的item的位置，并统计所有颜色的数量
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			local item = gameItemMap[r][c]
			if RefreshItemLogic.isItemRefreshable(item) then
				refreshableItems.items[r][c] = true
				if AnimalTypeConfig.isColorTypeValid(item.ItemColorType) --[[or item.ItemColorType == AnimalTypeConfig.kDrip]] then
					table.getMapValue(refreshableItems.colors, item.ItemColorType).count = table.getMapValue(refreshableItems.colors, item.ItemColorType).count + 1
				end
			end
		end
	end

	-- 统计棋盘上所有参与刷新的颜色（e.g.不能刷新的颜色这里不统计；后面选择最多颜色时，选择的也是可刷新的颜色）
	local colorStatistics = {
		[AnimalTypeConfig.kBlue] 	= {count = 0}, 
		[AnimalTypeConfig.kGreen] 	= {count = 0}, 
		[AnimalTypeConfig.kOrange] 	= {count = 0}, 
		[AnimalTypeConfig.kPurple] 	= {count = 0}, 
		[AnimalTypeConfig.kRed] 	= {count = 0}, 
		[AnimalTypeConfig.kYellow] 	= {count = 0},
		[AnimalTypeConfig.kDrip] = {count = 0},
	}

	for color, ele in pairs(refreshableItems.colors) do
		--print("RRR   111111111111111111111111111   ")
		table.getMapValue(colorStatistics, color).count = ele.count
	end

	return swap_areas, colorStatistics, refreshableItems, special_swap_areas
end

function RefreshItemLogic.tryRefresh(mainLogic)
	local swap_areas, colorStatistics, refreshableItems, special_swap_areas = RefreshItemLogic.getProcessedGameBoard(mainLogic)

	-- 保留一份gameItemMap的副本
	local gameItemMapCopy = {}
	for r = 1, #mainLogic.gameItemMap do 
		for c = 1, #mainLogic.gameItemMap[r] do
			if gameItemMapCopy[r] == nil then
				gameItemMapCopy[r] = {}
			end
			gameItemMapCopy[r][c] = mainLogic.gameItemMap[r][c]:copy()
		end
	end


	local successWithSwapArea = false

	if #swap_areas == 0 then
		successWithSwapArea = false
	else

		for k, v in pairs(swap_areas) do
			-- print('')
			-- print('USING SWAP AREA: ', v.posD.r, v.posD.c, v.type, v.direction)
			local result = RefreshItemLogic.tryWithSwapArea(mainLogic, gameItemMapCopy, v, colorStatistics, refreshableItems)
			if result then
				print('REFRESH SUCCESS USING SWAP AREA!!')
				mainLogic.gameItemMap = result
				successWithSwapArea = true
				break
			end
		end
	end

	if successWithSwapArea then
		return true
	end

	local successWithSpecialSwapArea = false

	local refreshableSpeicalCount = 0
	local hasBird = false


	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemSpecialType and AnimalTypeConfig.isSpecialTypeValid(item.ItemSpecialType) then
				refreshableSpeicalCount = refreshableSpeicalCount + 1
			end
			if item.ItemSpecialType == AnimalTypeConfig.kColor then
				hasBird = true
			end
		end
	end
	-- print(refreshableSpeicalCount)
	if not hasBird and refreshableSpeicalCount < 2 or #special_swap_areas == 0 then
		successWithSpecialSwapArea = false
	else
		for k, v in pairs(special_swap_areas) do
			-- print('')
			-- print('USING SPECIAL SWAP AREA: ', v.posA.r, v.posA.c, v.direction)
			local result = RefreshItemLogic.trySpecialSwapArea(mainLogic, gameItemMapCopy, v, colorStatistics, refreshableItems)
			if result then
				print('REFRESH SUCCESS USING SPECIAL SWAP AREA!!')
				mainLogic.gameItemMap = result
				successWithSpecialSwapArea = true
				break
			end
		end
	end
	if successWithSpecialSwapArea then
		return true
	end
	print('REFRESH FAILED')
	return false
end

function RefreshItemLogic.tryWithSwapArea(mainLogic, gameItemMapCopy, swap_area, colorStatistics, refreshableItems, retryBanColor)
	local gameItemMap = gameItemMapCopy

	local retry = false
	if not retryBanColor then
		retryBanColor = {}
	end

	local unrefreshableItems = {}
	local itemA = gameItemMap[swap_area.posA.r][swap_area.posA.c]
	local itemB = gameItemMap[swap_area.posB.r][swap_area.posB.c]
	local itemC = gameItemMap[swap_area.posC.r][swap_area.posC.c]
	local itemD = gameItemMap[swap_area.posD.r][swap_area.posD.c]

	if not RefreshItemLogic.isItemRefreshable(itemA) then
		table.insert(unrefreshableItems, itemA)
	end
	if not RefreshItemLogic.isItemRefreshable(itemB) then
		table.insert(unrefreshableItems, itemB)
	end
	if not RefreshItemLogic.isItemRefreshable(itemC) then
		table.insert(unrefreshableItems, itemC)
	end

	local fixedColor = nil

	-- 如果ABC位置有不参与刷新的item，那么颜色就被限定死了
	if #unrefreshableItems > 0 then
		fixedColor = unrefreshableItems[1].ItemColorType
		for k, v in pairs(unrefreshableItems) do
			if v.ItemColorType ~= fixedColor then
				return false
			end
		end
	end

	if fixedColor and table.exist(retryBanColor, fixedColor) then
		return false
	end

	-- 如果没有限定颜色，那就选择item最多的颜色
	local mostColor = nil
	if not fixedColor then		
		local tmpCompare = 0
		for k, v in pairs(colorStatistics) do
			local thisColorBanned = false
			if retryBanColor and #retryBanColor > 0 then
				if table.exist(retryBanColor, k) then
					thisColorBanned = true
				end
			end
			if not thisColorBanned and v.count >= tmpCompare then
				tmpCompare = v.count
				mostColor = k
			end
		end
	end


	
	if fixedColor then
		-- 如果BC位有锁定的颜色，那么这个颜色不需要3个，而只需要3-#unrefreshableItems个就行
		if table.getMapValue(colorStatistics, fixedColor).count < 3 - #unrefreshableItems then
			return false
		end
	elseif mostColor then 
		-- 如果没有锁定颜色，选用的颜色必须要至少3个
		if table.getMapValue(colorStatistics, mostColor).count < 3 then
			return false
		end
	elseif not mostColor then 
		-- 如果没有mostColor，应该是因为所有颜色都在retryBanColor里面
		-- 那么对于这个t_area已经失败，应该换下一个t_area再试
		return false
	end

	if not fixedColor then
		fixedColor = mostColor
	end

	local colorStatisticsCopy = table.clone(colorStatistics, true)
	local selectionPool = table.clone(refreshableItems, true)
	local destination = table.clone(selectionPool, true)

	local newGameItemMap = {}
	for r = 1, #gameItemMap do
		newGameItemMap[r] = {}
	end



	-- 首先给ABC号位赋颜色
	if RefreshItemLogic.isItemRefreshable(itemA) then
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, swap_area.posA, fixedColor) then 
			return false
		end
	end
	if RefreshItemLogic.isItemRefreshable(itemB) then
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, swap_area.posB, fixedColor) then 
			return false
		end
	end
	if RefreshItemLogic.isItemRefreshable(itemC) then
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, swap_area.posC, fixedColor) then 
			return false
		end
	end

	-- DESTINATIONS里面删除ABC号位
	destination.items[swap_area.posA.r][swap_area.posA.c] = nil
	destination.items[swap_area.posB.r][swap_area.posB.c] = nil
	destination.items[swap_area.posC.r][swap_area.posC.c] = nil

	-- 打乱destination.items的次序
	local randomizedDestinationItems = {}
	for r, row in pairs(destination.items) do
		for c, col in pairs(row) do
			if destination.items[r][c] == true then
				table.insert(randomizedDestinationItems, {r = r, c = c})
			end
		end
	end

	for i = 1, 2 * #randomizedDestinationItems do 
		local selector = mainLogic.randFactory:rand(1, #randomizedDestinationItems)
		swapInTable(randomizedDestinationItems, 1, selector)
	end

	-- 对剩下的、参与刷新的位置赋值
	for k, v in pairs(randomizedDestinationItems) do
		local color = nil
		for k, v in pairs(selectionPool.colors) do
			if v.count > 0 then
				color = k
			end
		end
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, {r = v.r, c = v.c}, color) then
			return false
		end
	end


	-- 因为上一步填入的仅仅是参与刷新的item，因此这里补满newGameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if newGameItemMap[r][c] == nil then
				newGameItemMap[r][c] = gameItemMap[r][c]:copy()
			end
		end
	end

	-- print('')
	-- print('REFRESHED COLOR MAP')
	for r = 1, #newGameItemMap do
		local s = ''
		for c = 1, #newGameItemMap[r] do
			s = s..tostring(newGameItemMap[r][c].ItemColorType)..' '
		end
		-- print(s)
	end

	-- ABC是不能被交换的位置
	local fixedPositions = {}
	table.insert(fixedPositions, swap_area.posA)
	table.insert(fixedPositions, swap_area.posB)
	table.insert(fixedPositions, swap_area.posC)
	


	local success, needExchangeMap = getNeedExchangeMap(newGameItemMap, fixedPositions)

	if not success then
		retry = true
		table.insert(retryBanColor, fixedColor)
	end

	
	-- debug
	-- print('')
	-- print('NEED EXCHANGE MAP')
	-- for r = 1, #newGameItemMap do
	-- 	for c = 1, #newGameItemMap[r] do
	-- 		if needExchangeMap[r][c].item ~= nil then
	-- 			print('item r,c,color ', r, c)
	-- 			for k, v in pairs(needExchangeMap[r][c].banColor) do
	-- 				print(k)
	-- 			end
	-- 			print('')
	-- 		end
	-- 	end
	-- end


	-- 交换已标记的item
	for r = 1, #needExchangeMap do
		for c = 1, #needExchangeMap[r] do
			if needExchangeMap[r][c].item ~= nil then
				local result = tryExchangeItemColor(newGameItemMap, needExchangeMap,{r = r, c = c}, fixedPositions)
				if not result then
					return false
				end
			end
		end
	end

	-- print('')
	-- print('COLOR MAP AFTER EXCHANGE')
	-- for r = 1, #newGameItemMap do
	-- 	local s = ''
	-- 	for c = 1, #newGameItemMap[r] do
	-- 		s = s..tostring(newGameItemMap[r][c].ItemColorType)..' '
	-- 	end
	-- 	print(s)
	-- end


	-- 最后再检查一遍是否有问题
	if checkFailure(newGameItemMap) then
		-- print('checkFailure fail')
		retry = true
		table.insert(retryBanColor, fixedColor)
	end

	if not retry then
		-- print('REFRESH SUCCESS USING T_AREA:', swap_area.posD.r, swap_area.posD.c, swap_area.type, swap_area.direction)
		return newGameItemMap
	else
		-- print('REFRESH FAILED USING T_AREA:', swap_area.posD.r, swap_area.posD.c, swap_area.type, swap_area.direction, ' RETRYING......')
		-- print('retry ban color', table.tostring(retryBanColor))
		return RefreshItemLogic.tryWithSwapArea(mainLogic, gameItemMapCopy, swap_area, colorStatistics, refreshableItems, retryBanColor)
	end

end

function RefreshItemLogic.trySpecialSwapArea(mainLogic, gameItemMapCopy, special_swap_area, colorStatistics, refreshableItems)
	local gameItemMap = gameItemMapCopy
	local selectionPool = table.clone(refreshableItems, true)
	local destination = table.clone(selectionPool, true)

	local newGameItemMap = {}
	for r = 1, #gameItemMap do
		newGameItemMap[r] = {}
	end

	local function getRandomColor()
		local tmp = {}
		for k, v in pairs(colorStatistics) do
			if v.count > 0 then
				table.insert(tmp, k)
			end
		end
		local index = mainLogic.randFactory:rand(1, #tmp)
		return tmp[index]
	end

	local itemA, itemB = gameItemMap[special_swap_area.posA.r][special_swap_area.posA.c], gameItemMap[special_swap_area.posB.r][special_swap_area.posB.c]
	-- 特殊情况下，AB中一个是魔力鸟，另一个可以是神灯或普通动物，这样也可以保证有possible move
	-- 那么就不指定颜色，直接略过
	if itemA.ItemSpecialType == AnimalTypeConfig.kColor and itemB.ItemSpecialType ~= AnimalTypeConfig.kColor then
		-- 如果A是鸟，那么B可随便指定一个，可以使特效，也可以不是
		local color = getRandomColor()
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, special_swap_area.posB, color, false)
		then
			return false
		end
	elseif itemB.ItemSpecialType == AnimalTypeConfig.kColor and itemA.ItemSpecialType ~= AnimalTypeConfig.kColor then
		local color = getRandomColor()
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, special_swap_area.posA, color, false)
		then
			return false
		end
	elseif itemA.ItemSpecialType ~= AnimalTypeConfig.kColor and itemB.ItemSpecialType ~= AnimalTypeConfig.kColor then
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, special_swap_area.posA, nil, true)
		then
			return false
		end
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, special_swap_area.posB, nil, true)
		then
			return false
		end
	end

	destination.items[special_swap_area.posA.r][special_swap_area.posA.c] = nil
	destination.items[special_swap_area.posB.r][special_swap_area.posB.c] = nil

	-- 打乱destination.items的次序
	local randomizedDestinationItems = {}
	for r, row in pairs(destination.items) do
		for c, col in pairs(row) do
			if destination.items[r][c] == true then
				table.insert(randomizedDestinationItems, {r = r, c = c})
			end
		end
	end
	for i = 1, 2 * #randomizedDestinationItems do 
		local selector = mainLogic.randFactory:rand(1, #randomizedDestinationItems)
		swapInTable(randomizedDestinationItems, 1, selector)
	end

	-- 对剩下的、参与刷新的位置赋值
	for k, v in pairs(randomizedDestinationItems) do
		local color = nil
		for k, v in pairs(selectionPool.colors) do
			if v.count > 0 then
				color = k
			end
		end
		if not tryAssignItemWithColor(selectionPool, gameItemMap, newGameItemMap, {r = v.r, c = v.c}, color) then
			return false
		end
	end


	-- 因为上一步填入的仅仅是参与刷新的item，因此这里补满newGameItemMap
	for r = 1, #gameItemMap do
		for c = 1, #gameItemMap[r] do
			if newGameItemMap[r][c] == nil then
				newGameItemMap[r][c] = gameItemMap[r][c]:copy()
			end
		end
	end

	local fixedPositions = {}
	table.insert(fixedPositions, special_swap_area.posA)
	table.insert(fixedPositions, special_swap_area.posB)

	local success, needExchangeMap = getNeedExchangeMap(newGameItemMap, fixedPositions)

	-- 交换已标记的item
	for r = 1, #needExchangeMap do
		for c = 1, #needExchangeMap[r] do
			if needExchangeMap[r][c].item ~= nil then
				local result = tryExchangeItemColor(newGameItemMap, needExchangeMap,{r = r, c = c}, fixedPositions)
				if not result then
					return false
				end
			end
		end
	end

	for r = 1, #newGameItemMap do
		local s = ''
		for c = 1, #newGameItemMap[r] do
			s = s..tostring(newGameItemMap[r][c].ItemColorType)..' '
		end
	end

	return newGameItemMap

end