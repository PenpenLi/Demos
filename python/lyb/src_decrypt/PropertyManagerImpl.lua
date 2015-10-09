PropertyManagerImpl = class();
--属性管理器
function PropertyManagerImpl:ctor(battleUnit)
	self.class = PropertyManagerImpl;
	self.propertyMap = {}
	self.battleUnit = battleUnit
end

function PropertyManagerImpl:removeSelf()
	self.class = nil;
end

function PropertyManagerImpl:dispose()
	self.cleanSelf();
end

function PropertyManagerImpl:getPropertyMap()
	return self.propertyMap;
end

function PropertyManagerImpl:addIntValue(key,value)
	local propValue = self:getProperty(key);
	propValue:addIntValue(value);
end

function PropertyManagerImpl:addLongValue(key,value)
	local propValue = self:getProperty(key);
	propValue:addLongValue(value);
end

function PropertyManagerImpl:subIntValue(key,value)
	local propValue = self:getProperty(key);
	propValue:subIntValue(value);
end

function PropertyManagerImpl:subLongValue(key,value)
	local propValue = self:getProperty(key);
	propValue:subLongValue(value);
end

function PropertyManagerImpl:getProperty(key)
	local propValue = self.propertyMap[key]
	if propValue == nil then
		--propValue = PropertyValue.new(key, BattleConstants.VALUE_TYPE_INT);
		propValue = createIntProperValue(key,0);
		self.propertyMap[key] = propValue;
	end
	return propValue;
end

function PropertyManagerImpl:getPropertyValue(key)
	local propValue = self.propertyMap[key]
	if propValue == nil then
		--propValue = PropertyValue.new(key, BattleConstants.VALUE_TYPE_INT);
		propValue = createIntProperValue(key,0);
		self.propertyMap[key] = propValue;
	end
	return propValue:getIntValue();
end

function PropertyManagerImpl:initializePropertyValue(propertyMap)
	self.propertyMap = propertyMap;
end

function PropertyManagerImpl:getViewPropCount()
	local count = 0;
	for k1,propValue in pairs(self.propertyMap) do
		if propValue:isView() then
			count = count + 1
		end
	end
	return count;
end

function PropertyManagerImpl:getLongValue(key)
	local propValue = self:getProperty(key);
	return propValue:getLongValue();
end

function PropertyManagerImpl:getIntValue(key)
	local propValue = self:getProperty(key);
	return propValue:getIntValue();
end

function PropertyManagerImpl:getFloatValue(key)
	return self:getProperty(key):getIntValue()/BattleConstants.HUNDRED_THOUSAND;
	--return DummyUtils.convertIntToFloatByHundredThousand(self:getProperty(key):getIntValue());
end


function PropertyManagerImpl:setIntValue(key,value)
	local propValue = self:getProperty(key);
	propValue:setIntValue(value);
end

function PropertyManagerImpl:setLongValue(key,value)
	local propValue = self:getProperty(key);
	propValue:setLongValue(value);
end

function PropertyManagerImpl:sendUpdatePropertyValue1(changeHp,changeRage) 
	local propertyValue = self:getProperty(PropertyType.CURR_HP);
	if propertyValue.isUpdate then
		self:synHp(propertyValue:getChangValue(),changeRage);
		propertyValue:setUpdate(false);
	end
end
function PropertyManagerImpl:sendUpdatePropertyValue() 
	local propertyValue = self:getProperty(PropertyType.CURR_HP);
	local propertyValue1 = self:getProperty(PropertyType.CURRENT_RAGE);
	if propertyValue.isUpdate or propertyValue1.isUpdate then
		self:synHp(propertyValue:getChangValue(),propertyValue1:getChangValue());
		propertyValue:setUpdate(false);
	end
end

function PropertyManagerImpl:synHp(changeHp,changeRage)
	local mpm = {}
	mpm.BattleUnitID = self.battleUnit:getObjectId()
	mpm.CurrentRage = self.battleUnit:getCurrRage()
	-- mpm.CurrentHP = self.battleUnit:getCurrHp()
	mpm.ChangeValue1 = changeRage
	-- mpm.ChangeValue = changeHp
	mpm.SubType = 4;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end

--效果掉血加血都走这个(强制加减血)
function PropertyManagerImpl:sendUpdatePropertyHPValue(changeHp)
	local mpm = {}
	mpm.BattleUnitID = self.battleUnit:getObjectId()
	mpm.CurrentHP = self.battleUnit:getCurrHp()
	mpm.ChangeValue = changeHp
	mpm.SubType = 4;
	self.battleUnit:getBattleField().battleProxy:sendAIMessage(mpm)
end