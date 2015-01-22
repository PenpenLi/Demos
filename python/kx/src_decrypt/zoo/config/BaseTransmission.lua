BaseTransmission = class()
function BaseTransmission:create(value)
	local bt = BaseTransmission.new()
	bt:init(value)
	return bt
end

function BaseTransmission:init(value)
	self:setStart(value)
	self:setStartType(value)
	self:setEnd(value)
	self:setEndType(value)
	self:setLink(value)
	self.sign = IntCoord:create(self.endItem.x - self.startItem.x, self.endItem.y - self.startItem.y)
	self.sign.x = self.sign.x == 0 and 0 or (self.sign.x > 0 and 1 or -1)
	self.sign.y = self.sign.y == 0 and 0 or (self.sign.y > 0 and 1 or -1) 
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
	if self.sign.x == 0 then
		return math.abs(self.startItem.y - self.endItem.y) + 1
	else
		return math.abs(self.startItem.x - self.endItem.x) + 1
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

function BaseTransmission:getstartType()
	return self.startType
end

function BaseTransmission:getEndType()
	return self.endType
end