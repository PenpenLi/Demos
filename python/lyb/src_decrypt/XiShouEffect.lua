XiShouEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function XiShouEffect:ctor()
	self.class = XiShouEffect;
end

function XiShouEffect:cleanSelf()
	self:removeSelf()
end

function XiShouEffect:dispose()
    self:cleanSelf();
end

function XiShouEffect:initTtlValue()
	self.ttlValue = self:getEffectValue();
end

function XiShouEffect:cutHurt(value)
	self.ttlValue = self.ttlValue + value;
	if self.ttlValue <= 0 then
		local rtCut = self.ttlValue;
		self.ttlValue = 0;
		self.isOverFlg = true;
		return rtCut;
	else
		return 0;
	end
end

function XiShouEffect:doExecute(now)
end

function XiShouEffect:doUnExecute()
end
