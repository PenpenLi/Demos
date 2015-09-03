TileMoveDirConfig = table.const {
	kUndefined = 0,
	kUp = 1,
	kRight = 2,
	kDown = 3,
	kLeft = 4
}

TileMoveRouteMeta = class()

function TileMoveRouteMeta:ctor()
	self.startPos = nil
	self.endPos = nil
	self.next = nil
	self.pre = nil
end

function TileMoveRouteMeta:fromMeta(posData)
	local posInNum = tonumber(posData)
	local bit = require "bit"
	local startPosC = bit.band(bit.rshift(posInNum, 12), 0xf) + 1
	local startPosR = bit.band(bit.rshift(posInNum, 8), 0xf) + 1
	local endPosC = bit.band(bit.rshift(posInNum, 4), 0xf) + 1
	local endPosR = bit.band(posInNum, 0xf) + 1

	self.startPos = IntCoord:create(startPosR, startPosC)
	self.endPos = IntCoord:create(endPosR, endPosC)
end

function TileMoveRouteMeta:moveWithStep(r, c, step, isReverse)
	local leftStep = step
	local retR, retC = r, c
	local dir = TileMoveDirConfig.kUndefined
	if isReverse then
		dir = TileMoveRouteMeta:calcDirection(self.endPos, self.startPos)
	else
		dir = TileMoveRouteMeta:calcDirection(self.startPos, self.endPos)
	end

	local endPos = self.endPos
	if isReverse then endPos = self.startPos end -- 反向移动

	if dir == TileMoveDirConfig.kUp then
		retR = r - step
		if retR < endPos.x then  retR = endPos.x end
	elseif dir == TileMoveDirConfig.kRight then
		retC = c + step
		if retC > endPos.y then retC = endPos.y end
	elseif dir == TileMoveDirConfig.kDown then
		retR = r + step
		if retR > endPos.x  then retR = endPos.x end
	elseif dir == TileMoveDirConfig.kLeft then
		retC = c - step
		if retC < endPos.y then retC = endPos.y end
	end
	leftStep = leftStep - (math.abs(r - retR) + math.abs(c - retC))
	return retR, retC, leftStep
end

function TileMoveRouteMeta:getDirection(isReverse)
	if isReverse then
		return self:calcDirection(self.endPos, self.startPos)
	else
		return self:calcDirection(self.startPos, self.endPos)
	end
end

function TileMoveRouteMeta:calcDirection(startPos, endPos)
	local dr = endPos.x - startPos.x
	local dc = endPos.y - startPos.y
	if dr == 0 and dc < 0 then
		return TileMoveDirConfig.kLeft
	elseif dr == 0 and dc > 0 then
		return TileMoveDirConfig.kRight
	elseif dc == 0 and dr < 0 then
		return TileMoveDirConfig.kUp
	elseif dc == 0 and dr > 0 then
		return TileMoveDirConfig.kDown
	end
	return TileMoveDirConfig.kUndefined
end

function TileMoveRouteMeta:isStartPos(r, c)
	return self.startPos.x == r and self.startPos.y == c
end

function TileMoveRouteMeta:isEndPos(r, c)
	return self.endPos.x == r and self.endPos.y == c
end

function TileMoveRouteMeta:isFinalPos(r, c, isReverse)
	if isReverse then
		return not self.pre and self:isStartPos(r, c)
	else
		return not self.next and self:isEndPos(r, c)
	end
end

TileMoveMeta = class()

function TileMoveMeta:ctor()
	self.step = 0
	self.routes = {}
	self.moveCountDown = 1 -- default 1
end

function TileMoveMeta:create(meta)
	assert(type(meta) == "string")
	-- print("TileMoveMeta:create ", meta)
	local tmMeta = TileMoveMeta.new()
	tmMeta:fromMeta(meta)
	return tmMeta
end

function TileMoveMeta:fromMeta(meta)
	local stepAndRoutes = string.split(meta, ":")
	self.step = 0
	self.routes = {}

	if #stepAndRoutes >= 2  then
		self.step = tonumber(stepAndRoutes[1])

		local routesInNumber = string.split(stepAndRoutes[2], ",")
		if routesInNumber and #routesInNumber > 0 then
			for _, v in pairs(routesInNumber) do
				local route = TileMoveRouteMeta.new()
				route:fromMeta(v)
				table.insert(self.routes, route)
			end

			local function findNextRouteByStartPos(pos)
				for _, v in pairs(self.routes) do
					if v.startPos.x == pos.x and v.startPos.y == pos.y then
						return v
					end
				end
			end
			-- 创建双向链表
			for _, route in pairs(self.routes) do
				local nextRoute = findNextRouteByStartPos(route.endPos)
				if nextRoute then
					route.next = nextRoute
					if not nextRoute.pre then nextRoute.pre = route end
				end
			end
		end
	end
end

function TileMoveMeta:findRouteByPos(r, c, isReverse)
	if isReverse then
		for _, v in pairs(self.routes) do
			if r == v.endPos.x and c == v.endPos.y then -- 在终点中找
				return v
			end
		end
	else
		for _, v in pairs(self.routes) do
			if r == v.startPos.x and c == v.startPos.y then -- 在起点中找
				return v
			end
		end
	end
	
	for _, v in pairs(self.routes) do
		if r == v.startPos.x and r == v.endPos.x and ((c - v.startPos.y) * (c - v.endPos.y) <= 0) then -- 是否在行中间
			return v
		end
		if c == v.startPos.y and c == v.endPos.y and ((r - v.startPos.x) * (r - v.endPos.x) <= 0) then -- 是否在列中间
			return v
		end
	end
	return nil
end

TileMoveConfig = class()

function TileMoveConfig:ctor()
	self.tileMoveCfgs = {}
end

function TileMoveConfig:create(config)
	local ret = TileMoveConfig.new()
	ret:fromConfig(config)
	return ret
end

function TileMoveConfig:fromConfig(config)
	self.tileMoveCfgs = {}

	if type(config) == "table" and #config > 0 then
		for _, meta in pairs(config) do
			local tmMeta = TileMoveMeta:create(meta)
			if tmMeta.step > 0 and #tmMeta.routes > 0 then
				local initPos = tmMeta.routes[1].startPos
				self.tileMoveCfgs[initPos.x.."_"..initPos.y] = tmMeta
			end
		end
	end
end

function TileMoveConfig:findTileMoveMetaByPos(r, c)
	return self.tileMoveCfgs[r.."_"..c]
end
