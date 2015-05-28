BaseTransmission = class()
function BaseTransmission:create(value)

	local ints = string.split(value, ',')
	if #ints == 1 then

		local bt = BaseTransmission.new()
		bt:init(ints[1])
		return bt
	else
		local allTrans = {}
		for k, v in pairs(ints) do
			local tmp = BaseTransmission:create(v)
			table.insert(allTrans, tmp)
		end
		-- 判断是否带环
		-- 如果有环，链表并不会形成一个环，而是随便选一个做头
		local hasCercle = true
		local head, tail
		local function getTransByStart(start)
			for k, v in pairs(allTrans) do
				local s = v:getStart()
				if s.x == start.x and s.y == start.y then
					return allTrans[k]
				end
			end
			return nil
		end
		for k, v in pairs(allTrans) do
			local linkItem = v:getLink()
			if linkItem.x ~= 16 or linkItem.y ~= 16 then
				hasCercle = false
			end
		end

		-- 配置保证了第一个就是head节点的配置
		head = allTrans[1]

		-- hasCercle属性同步到链表中所有节点
		for k, v in pairs(allTrans) do
			v._hasCercle = hasCercle
		end

		print('HAS CERCLE', hasCercle)

		local next, pointer
		pointer = head
		next = getTransByStart(pointer:getEnd())
		while (next ~= nil and next ~= head) do
			print('next', next:getStart().x, next:getStart().y)
			pointer:setNextTrans(next)
			next:setPrevTrans(pointer)
			pointer = next
			next = getTransByStart(pointer:getEnd())
		end
		head:setPrevTrans(nil)
		pointer:setNextTrans(nil)

		-- debug
		print('LINKED TRANSMISSIONS')
		pointer = head
		while (pointer ~= nil) do
			print('start ', pointer:getStart().x, pointer:getStart().y)
			print('end ', pointer:getEnd().x, pointer:getEnd().y)
			print('link', pointer:getLink().x, pointer:getLink().y)
			print('direction', pointer:getDirection())
			print('startType', pointer:getStartType())
			print('endType', pointer:getEndType())
			print('length', pointer:getTransLength())
			print('')
			pointer = pointer:getNextTrans()
		end

		return head
	end
end

function BaseTransmission:init(config)


	self.prevTrans = nil
	self.nextTrans = nil

	local value = tonumber(config)
	self:setStart(value)
	self:setStartType(value)
	self:setEnd(value)
	self:setEndType(value)
	self:setLink(value)
	self.sign = IntCoord:create(self.endItem.x - self.startItem.x, self.endItem.y - self.startItem.y)
	self.sign.x = self.sign.x == 0 and 0 or (self.sign.x > 0 and 1 or -1)
	self.sign.y = self.sign.y == 0 and 0 or (self.sign.y > 0 and 1 or -1) 

end

-- corner只会是length == 1的item
function BaseTransmission:getCornerType()
	local prevTrans
	if self == self:getHeadTrans() then
		prevTrans = self:getEndTrans()
	else
		prevTrans = self:getPrevTrans()
	end
	local prevDirection = prevTrans:getDirection()
	local thisDirection = self:getDirection()

	if prevDirection == TransmissionDirection.kUp then
		if thisDirection == TransmissionDirection.kLeft then
			return TransmissionType.kCorner_UL
		elseif thisDirection == TransmissionDirection.kRight then
			return TransmissionType.kCorner_UR
		elseif thisDirection == TransmissionDirection.kUp then
			return TransmissionType.kRoad
		elseif thisDirection == TransmissionDirection.kDown then
			assert(false, 'TRANSMISSION DIRECTION IS WRONG')
			return nil
		end

	elseif prevDirection == TransmissionDirection.kDown then
		if thisDirection == TransmissionDirection.kLeft then
			return TransmissionType.kCorner_DL
		elseif thisDirection == TransmissionDirection.kRight then
			return TransmissionType.kCorner_DR
		elseif thisDirection == TransmissionDirection.kDown then
			return TransmissionType.kRoad
		elseif thisDirection == TransmissionDirection.kUp then
			assert(false, 'TRANSMISSION DIRECTION IS WRONG')
			return nil
		end

	elseif prevDirection == TransmissionDirection.kLeft then
		if thisDirection == TransmissionDirection.kUp then
			return TransmissionType.kCorner_LU
		elseif thisDirection == TransmissionDirection.kDown then
			return TransmissionType.kCorner_LD
		elseif thisDirection == TransmissionDirection.kLeft then
			return TransmissionType.kRoad
		elseif thisDirection == TransmissionDirection.kRight then
			assert(false, 'TRANSMISSION DIRECTION IS WRONG')
			return nil
		end

	elseif prevDirection == TransmissionDirection.kRight then
		if thisDirection == TransmissionDirection.kUp then
			return TransmissionType.kCorner_RU
		elseif thisDirection == TransmissionDirection.kDown then
			return TransmissionType.kCorner_RD
		elseif thisDirection == TransmissionDirection.kRight then
			return TransmissionType.kRoad
		elseif thisDirection == TransmissionDirection.kLeft then
			assert(false, 'TRANSMISSION DIRECTION IS WRONG')
			return nil
		end

	end

end

function BaseTransmission:getTransTypeByIndex(index)
	-- print('index', index, 'hasCercle', self:hasCercle(), 'hasCorner', self:hasCorner(), 'isHead', self:getHeadTrans() == self, 'is End', self:getEndTrans() == self)
	local type_trans = TransmissionType.kRoad
	if self:hasCercle() then
		if index == 1 then
			type_trans = self:getCornerType()
		end
	elseif self:hasCorner() then
		if self:getHeadTrans() == self then
			if index == 1 then
				type_trans = TransmissionType.kStart
			end
		elseif self:getEndTrans() == self then
			if index == 1 then
				type_trans = self:getCornerType()
			elseif index == self:getTransLength() then
				type_trans = TransmissionType.kEnd
			end
		else
			if index == 1 then
				type_trans = self:getCornerType()
			end
		end
	else
		if index == 1 then
			type_trans = TransmissionType.kStart
		elseif index == self:getTransLength() then
			type_trans = TransmissionType.kEnd
		end
	end
	return type_trans
end

function BaseTransmission:getLinkPositionByIndex(index)
	local direction = self:getDirection()
	local dx, dy = 0, 0
	if direction == TransmissionDirection.kLeft then
		dy = -1
	elseif direction == TransmissionDirection.kRight then 
		dy = 1
	elseif direction == TransmissionDirection.kUp then
		dx = -1
	else
		dx = 1
	end 

	local start = self:getStart()
	local pos
	local nextItemPos = {x = start.x + dx*index, y = start.y + dy*index}
	local linkItemPos = self:getLink()

	if self:hasCercle() then
		pos = nextItemPos
	elseif self:hasCorner() then
		if self == self:getEndTrans() then
			if index == self:getTransLength() then
				pos = linkItemPos
			else
				pos = nextItemPos
			end
		else
			pos = nextItemPos
		end
	else
		if index == self:getTransLength() then
			pos = linkItemPos
		else
			pos = nextItemPos
		end
	end
	return pos

end

function BaseTransmission:hasCorner()
	return (self:getHeadTrans() ~= self:getEndTrans())
end

function BaseTransmission:hasCercle()
	return self._hasCercle
end

function BaseTransmission:getNextTrans()
	return self.nextTrans
end

function BaseTransmission:getPrevTrans()
	return self.prevTrans
end

function BaseTransmission:setPrevTrans(prev)
	self.prevTrans = prev
end

function BaseTransmission:setNextTrans(next)
	self.nextTrans = next
end

function BaseTransmission:getEndTrans()
	if self.nextTrans then
		return self.nextTrans:getEndTrans()
	else
		return self
	end
end

function BaseTransmission:isHeadTrans()
	return self.prevTrans == nil
end

function BaseTransmission:isEndTrans()
	return self.nextTrans == nil
end

function BaseTransmission:getHeadTrans()
	if self.prevTrans then
		return self.prevTrans:getHeadTrans()
	else
		return self
	end
end

function BaseTransmission:setStart(value)
	local r = bit.band(bit.rshift(value, 22), 15) + 1
	local c = bit.band(bit.rshift(value, 18), 15) + 1
	self.startItem = IntCoord:create(r, c)
end

function BaseTransmission:setStartType(value)
	self.startType =  bit.band(bit.rshift(value, 26), 3)
end

function BaseTransmission:setEnd(value)
	local r = bit.band(bit.rshift(value, 12), 15) + 1
	local c = bit.band(bit.rshift(value, 8), 15) + 1
	self.endItem = IntCoord:create(r, c)
end

function BaseTransmission:setEndType(value)
	self.endType = bit.band(bit.rshift(value, 16), 3)
end

function BaseTransmission:setLink(value)
	local r = bit.band(bit.rshift(value, 4), 15) + 1
	local c = bit.band(value, 15) + 1
	self.toItem = IntCoord:create(r, c)
end

function BaseTransmission:getStart()
	return self.startItem
end

function BaseTransmission:getEnd()
	return self.endItem
end

function BaseTransmission:getSign()
	return self.sign
end

function BaseTransmission:getLink()
	return self.toItem
end

function BaseTransmission:getTransLength()
	-- 不带环的最后一节，长度包括最后一个item
	if self:getEndTrans() == self and not self:hasCercle() then
		if self.sign.x == 0 then
			return math.abs(self.startItem.y - self.endItem.y) + 1
		else
			return math.abs(self.startItem.x - self.endItem.x) + 1
		end
	else -- 带环的每一节，长度都不包括最后一个item
		if self.sign.x == 0 then
			return math.abs(self.startItem.y - self.endItem.y)
		else
			return math.abs(self.startItem.x - self.endItem.x)
		end
	end
end

function BaseTransmission:getDirection()
	if self.sign.x < 0 then
		return TransmissionDirection.kUp
	elseif self.sign.y > 0 then
		return TransmissionDirection.kRight
	elseif self.sign.y < 0 then
		return TransmissionDirection.kLeft
	else
		return TransmissionDirection.kDown
	end
end

function BaseTransmission:getStartType()
	return self.startType
end

function BaseTransmission:getEndType()
	return self.endType
end