MonsterConfig = class();
--根据等级取属性时用
function MonsterConfig:ctor(monsterLevelConfig, monsterConfig)
	self.class = MonsterConfig;
	--self.attackIntervalTime = monsterConfig.cd;
	--self.campId = monsterConfig.power;
	self.atk = monsterLevelConfig.atk;
	self.crit = monsterLevelConfig.crit;
	self.def = monsterLevelConfig.def;
	self.evade = monsterLevelConfig.evade;
	self.parry = monsterLevelConfig.parry;
	self.puncture = monsterLevelConfig.puncture;
	self.hit = monsterLevelConfig.hit;
	self.hp = monsterLevelConfig.hp;
	self.tenacity = monsterLevelConfig.tenacity;
	self.distance = monsterConfig.distance;
	self.elementType = monsterConfig.five;
	self.id = monsterConfig.id;
	self.lv = monsterLevelConfig.lv;
	self.modelId = monsterConfig.modelId;
	self.nanducanshu = monsterConfig.nanducanshu;
	self.pugong = monsterConfig.pugong;
	self.skill = monsterConfig.skill;
	self.speed = monsterConfig.speed;
	self.type = monsterConfig.type;
	self.cd = monsterConfig.CD;
end

function MonsterConfig:removeSelf()
	self.class = nil;
end

function MonsterConfig:dispose()
	self.cleanSelf();
end
