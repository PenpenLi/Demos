---------------------------------------------------------------------------------
-- 从配置解出来的tile定义
---------------------------------------------------------------------------------

require "zoo.config.TileConfig"
TileMetaData = class()

function TileMetaData:ctor()
	self.x = 1    --col
	self.y = 1    --row
	self.tileProperties = {}
	for i = 1, TileConst.kMaxTile do
		table.insert(self.tileProperties, false)
	end
end

function TileMetaData:dispose()
	self.tileProperties = nil
end

function TileMetaData:removeTileData(index)
	self.tileProperties[index] = false
end

function TileMetaData:isEmptyTile()
	return self.tileProperties[1]
end

function TileMetaData:clearAllProperties()
	--空格的定义不用清
	if not self:isEmptyTile() then
		for i = 2, #self.tileProperties do
			self.tileProperties[i] = false
		end
	end
end

function TileMetaData:hasProperty(property)
	if property == TileConst.kInvalid then
		for i = 1, #self.tileProperties do
			if self.tileProperties[i] then
				return false
			end
		end

		return true
	end
	return self.tileProperties[property]
end

function TileMetaData:getChainsMeta()
	local chains = {}
	for i = TileConst.kChain1, TileConst.kChain5_Left do
		if self.tileProperties[i] then
			local chain = {}
			chain.level = math.floor((i - TileConst.kChain1) / 5) + 1
			chain.direction = (i - TileConst.kChain1) % 5
			table.insert(chains, chain)
		end
	end 
	return chains
end

function TileMetaData:hasMagicStoneProperty()
	for i = TileConst.kMagicStone_Up, TileConst.kMagicStone_Left do
		if self.tileProperties[i] then
			local dir = i - TileConst.kMagicStone_Up + 1
			return true, dir
		end
	end
	return false, nil
end

function TileMetaData:getCrossStrengthValue()
	return self.crossStrengthValue
end

function TileMetaData:setTileData(index)
	self.tileProperties[index] = true
end

function TileMetaData:copyProperties(t)
	for i = 1, #t.tileProperties do
		if t.tileProperties[i] then
			self:setTileData(i)
		end
	end
end

function TileMetaData:addTileData(property)
	if property ~= TileConst.kInvalid then
		self.tileProperties[property] = true
	else
		self:clearAllProperties()
	end
end

function TileMetaData:removeMultipleTileData(properties)
	for i = 1, #properties do
		self:removeTileData(properties[i])
	end
end

function TileMetaData:convertFromStringToTileIndex( value )
	-- body
	local propertyList = value:split(",")
	for k, v in pairs(propertyList) do
		self:setTileData(tonumber(v) + 1)
	end
	if #propertyList > 0 then
		self:removeTileData(TileConst.kEmpty)
	end
end

function TileMetaData:addPropertiesArray(value)
	local reverse = #value + 1
	for i = 1, #value do
		local c = string.sub(value, i, i)
		self.tileProperties[reverse - i] = c ~= "0"
	end

	--如果是个空格，把第一位标志设成true
	local a, b = string.find(value, "1")
	if a and a < #value then
		self:removeTileData(TileConst.kEmpty)
	else
		self:setTileData(TileConst.kEmpty)
	end
end

function TileMetaData:getProperties()
	return self.tileProperties
end

function TileMetaData:toString()
	local str = ""
	local len = #self.tileProperties
	while len > 0 do
		if self.tileProperties[len] then
			str = str .. "1"
		else
			str = str .. "0"
		end
		len = len - 1
	end

	local val = BigInt.str2bigInt(str, 2, 0)
	str = BigInt.bigInt2str(val, 10)
	return str
end

function TileMetaData:clone()
	local t = TileMetaData:create(self.x, self.y)
	--t:removeTileData(1)
	t:copyProperties(self)
	return t
end

--------------------------------------------------------------------
-- static function
--------------------------------------------------------------------

--static create function
function TileMetaData:create(x, y)
  	local t = TileMetaData.new()
  	t.x = x
  	t.y = y
  	return t
end

function TileMetaData:getEmptyArray()
	local t = {}
	for h = 1, 9 do
		local rt = {}
		table.insert(t, rt)
		for w = 1, 9 do
			table.insert(rt, TileMetaData:create(w, h))
		end
	end
	return t
end

totalClockUsedByConvertFromBitToTileIndex = 0

function TileMetaData:convertFromBitToTileIndex(value, x, y)

	local t = TileMetaData:create(x, y)
	local bit = BigInt.bigInt2str(BigInt.str2bigInt(tostring(value), 10, 1), 2)
	t:addPropertiesArray(bit)

	return t
end

function TileMetaData:convertArrayFromBitToTile(bitMap, stringMap , crossStrengthCfg)
	local t = {}
	for h = 1, #bitMap do
		local rt = {}
		table.insert(t, rt)
		for w = 1, #bitMap[h] do
			local tileData = TileMetaData:convertFromBitToTileIndex(bitMap[h][w], w, h)
			if stringMap and stringMap[h] and stringMap[h][w] then
				tileData:convertFromStringToTileIndex(stringMap[h][w])
			end

			tileData.crossStrengthValue = 0
			if crossStrengthCfg and type(crossStrengthCfg) == "table" then
				if crossStrengthCfg[h] and type(crossStrengthCfg[h]) == "table" then
					tileData.crossStrengthValue = tonumber(crossStrengthCfg[h][w] or 0)
				end 
			end

			table.insert(rt, tileData)
		end
	end
	return t
end
