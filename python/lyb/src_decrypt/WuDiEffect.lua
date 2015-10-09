WuDiEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function WuDiEffect:ctor()
	self.class = WuDiEffect;
end

function WuDiEffect:cleanSelf()
	self:removeSelf()
end

function WuDiEffect:dispose()
    self:cleanSelf();
end

function WuDiEffect:doExecute(now)

end

function WuDiEffect:doUnExecute()
	
end