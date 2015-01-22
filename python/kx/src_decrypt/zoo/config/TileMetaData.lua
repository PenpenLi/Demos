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

function TileMetaData:convertArrayFromBitToTile(map)
	local t = {}
	for h = 1, #map do
		local rt = {}
		table.insert(t, rt)
		for w = 1, #map[h] do
			table.insert(rt, TileMetaData:convertFromBitToTileIndex(map[h][w], w, h))
		end
	end
	return t
end
