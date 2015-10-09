XuanyunEffect = class(AbstractSkillEffect);
--眩晕 ( 持续状态，目标无法移动，攻击，或使用技能，但可以使用待机命令)
function XuanyunEffect:ctor()
	self.class = XuanyunEffect;
end

function XuanyunEffect:cleanSelf()
	self:removeSelf()
end

function XuanyunEffect:dispose()
    self:cleanSelf();
end

function XuanyunEffect:doExecute(now)
end

function XuanyunEffect:doUnExecute()
end
