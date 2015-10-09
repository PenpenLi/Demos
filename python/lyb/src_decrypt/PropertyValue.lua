PropertyValue = class();
--属性管理器
function PropertyValue:ctor(key,valueType,isView)
	self.class = PropertyValue;
	--/** 属性键值 **/
	self.key = key
	--/** 属性客户端是否可见 **/
	self.isView = isView --or PropertyType.getType(key).isView();
	--/** 属性是否需要跟新 **/
	self.isUpdate = nil
	--/** 属性整型值 **/
	self.intValue = 0
	--/** 属性长整型值 **/
	self.longValue = nil
	--/** 值类型 **/
	self.valueType = valueType
	--/** 变化的值 **/
	self.changValue = nil
end

function PropertyValue:removeSelf()
	self.class = nil;
end

function PropertyValue:dispose()
	self.cleanSelf();
end
--static静态
function createIntPropertyValue(propertyValue)
	local ret = PropertyValue.new();
	ret.key = propertyValue.key;
	ret.isView = propertyValue.isView;
	ret.isUpdate = propertyValue.isUpdate;
	ret.intValue = propertyValue.intValue;
	ret.longValue = propertyValue.longValue;
	ret.valueType = propertyValue.valueType;
	ret.changValue = propertyValue.changValue;
	return ret;
end
--static静态
function createIntProperValue(key,value)
	local propertyValue = PropertyValue.new(key, BattleConstants.VALUE_TYPE_INT);
	propertyValue:setIntValue(value);
	return propertyValue;
end

function PropertyValue:getChangValue()
	return self.changValue;
end

function PropertyValue:setChangValue(changValue)
	self.changValue = changValue;
end

--static静态
function createLongPropertyValue(key,value)
	local propertyValue = PropertyValue.new(key, BattleConstants.VALUE_TYPE_LONG);
	propertyValue:setLongValue(value);
	return propertyValue;
end

function PropertyValue:getKey()
	return self.key;
end

function PropertyValue:setKey(key)
	self.key = key;
end

function PropertyValue:isView()
	return self.isView;
end

function PropertyValue:setView(isView)
	self.isView = isView;
end

function PropertyValue:isUpdate()
	return self.isUpdate;
end

function PropertyValue:setUpdate(isUpdate)
	self.isUpdate = isUpdate;
	if not self.isUpdate then
		self.changValue = 0;
	end
end

function PropertyValue:getIntValue()
	return self.intValue;
end

function PropertyValue:setIntValue(intValue)
	if self.intValue == intValue then
		return;
	end
	self.changValue = intValue - self.intValue;
	self.intValue = intValue;
	self.isUpdate = true;
end

function PropertyValue:getLongValue()
	return self.longValue;
end

function PropertyValue:setLongValue(longValue)
	if self.longValue == longValue then
		return;
	end
	self.changValue = math.floor(longValue - self.longValue);
	self.longValue = longValue;
	self.isUpdate = true;
end

function PropertyValue:getValueType()
	return self.valueType;
end

function PropertyValue:setValueType(valueType)
	self.valueType = valueType;
end

function PropertyValue:addIntValue(value)
	if value == 0 then
		return;
	end
	self.intValue = self.intValue + value;
	self.changValue = value;
	self.isUpdate = true;
end

function PropertyValue:subIntValue(value)
	if value == 0 then
		return;
	end
	self.changValue = -value;
	self.intValue = self.intValue - value;
	self.isUpdate = true;
end

function PropertyValue:subLongValue(value)
	if value == 0 then
		return;
	end
	self.changValue = -math.floor(value);
	self.longValue = self.longValue - value;
	self.isUpdate = true;
end