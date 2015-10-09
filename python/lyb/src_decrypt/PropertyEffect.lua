PropertyEffect = class(AbstractSkillEffect);
--增加属性值(持续状态，到时间后会卸载所加的属性)
function PropertyEffect:ctor()
	self.class = PropertyEffect;
end

function PropertyEffect:cleanSelf()
	self:removeSelf()
end

function PropertyEffect:dispose()
    self:cleanSelf();
end

function PropertyEffect:doExecute(now)
	if not self.isFirst then return; end
	self.isFirst = nil;
	local propertyManager = self.target:getPropertyManager();
	if self:isIndescred() then
		print("~~~~~~~~~~~>Property CH",self.target:getObjectId(),self:getProperty(),-self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:subIntValue(self:getProperty(), self:innerGetEffectValue());
	else 
		print("~~~~~~~~~~~>Property CH",self.target:getObjectId(),self:getProperty(),"+"..self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:addIntValue(self:getProperty(), self:innerGetEffectValue());
	end
	--propertyManager:sendUpdatePropertyValue();
end

function PropertyEffect:doUnExecute()
	local propertyManager = self.target:getPropertyManager();
	if self:isIndescred() then
		print("~~~~~~~~~~~>Property RECH",self.target:getObjectId(),self:getProperty(),"+"..self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:addIntValue(self:getProperty(), self:innerGetEffectValue());
	else
		print("~~~~~~~~~~~>Property RECH",self.target:getObjectId(),self:getProperty(),-self:innerGetEffectValue(),propertyManager:getIntValue(self:getProperty()))
		propertyManager:subIntValue(self:getProperty(), self:innerGetEffectValue());
	end
	--propertyManager:sendUpdatePropertyValue();
end

function PropertyEffect:innerGetEffectValue()
	local basicValue = self:getEffectValue()+self:getEffectPersent();
	basicValue = basicValue*self.repeatCount
	return basicValue;
end


