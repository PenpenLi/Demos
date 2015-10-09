ImmPropertyEffect = class(AbstractSkillEffect);
--降低属性值(持续，到时间后会还原降低的属性)
function ImmPropertyEffect:ctor()
	self.class = ImmPropertyEffect;
end

function ImmPropertyEffect:cleanSelf()
	self:removeSelf()
end

function ImmPropertyEffect:dispose()
    self:cleanSelf();
end

function ImmPropertyEffect:doExecute(now)
	if not self.isFirst then return; end
	self.isFirst = nil;
	local propertyManager;
	local objId
	if self.useSource then
		propertyManager = self.source:getPropertyManager();
		objId = self.source:getObjectId()
	else
		propertyManager = self.target:getPropertyManager();
		objId = self.target:getObjectId()
	end
	if self:isIndescred() then
		print("~~~~~~~~~~~>Temp property CH",objId,self:getProperty(),-self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:subIntValue(self:getProperty(), self:innerGetEffectValue());
	else 
		print("~~~~~~~~~~~>Temp property CH",objId,self:getProperty(),"+"..self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:addIntValue(self:getProperty(), self:innerGetEffectValue());
	end
	--propertyManager:sendUpdatePropertyValue();
end

function ImmPropertyEffect:doUnExecute()
	local propertyManager;
	local objId
	if self.useSource then
		propertyManager = self.source:getPropertyManager();
		objId = self.source:getObjectId()
	else
		propertyManager = self.target:getPropertyManager();
		objId = self.target:getObjectId()
	end
	if self:isIndescred() then
		print("~~~~~~~~~~~>Temp property RECH",objId,self:getProperty(),"+"..self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:addIntValue(self:getProperty(), self:innerGetEffectValue());
	else
		print("~~~~~~~~~~~>Temp property RECH",objId,self:getProperty(),-self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:subIntValue(self:getProperty(), self:innerGetEffectValue());
	end
	--propertyManager:sendUpdatePropertyValue();
end
function ImmPropertyEffect:innerGetEffectValue()
	local basicValue = self:getEffectValue()+self:getEffectPersent();
	return basicValue;
end
