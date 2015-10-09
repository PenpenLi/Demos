ChenMoEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function ChenMoEffect:ctor()
	self.class = ChenMoEffect;
end

function ChenMoEffect:cleanSelf()
	self:removeSelf()
end

function ChenMoEffect:dispose()
    self:cleanSelf();
end

function ChenMoEffect:doExecute(now)

end

function ChenMoEffect:doUnExecute()
	
end
