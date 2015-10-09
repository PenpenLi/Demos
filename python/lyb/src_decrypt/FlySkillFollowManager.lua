FlySkillFollowManager = class();
function FlySkillFollowManager:ctor(flyUnit)
	self.class = FlySkillMoveManager;
	self.flyUnit = flyUnit;
	self.target = flyUnit:getTarget();
	self.speedX = 0;
	self.speedY = 0;
	self.startTime = 0;
	self.needTime = 0;
	self.startX = 0;
	self.startY = 0;
	self.speed = 0;
	self.config = nil;
	self.effectArr = nil;
	self.effectCount = 0;
end

function FlySkillFollowManager:removeSelf()
	self.class = nil;
end

function FlySkillFollowManager:dispose()
	self.effectArr = nil;
    self:removeSelf();
end
function FlySkillFollowManager:moveStart()
	self.effectArr = {};
	local skillMgr = self.flyUnit:getSkillMgr();
	self.config = skillMgr:getActionConfig();

	local screen = self.config.screenSkill;
	local effectID = screen["feixingTexiaoID"];
    if(effectID == nil or effectID == "#") then return end      
    local effectSpeed = screen["feixingTexiaoSudu"];
    local effectX = screen["feixingTexiaoX"];
    local effectY = screen["feixingTexiaoY"] ;
	local effectDelayTime = screen["feixingTexiaoYanchi"];
	local effectScale = screen["feixingTexiaoSuofang"];
	local effectAnimateSpeed = screen["effectAnimateSpeed"];

	local effectIDArr = StringUtils:lua_string_split(effectID,"?")
	local effectXArr = StringUtils:lua_string_split(effectX,"?");
	local effectYArr = StringUtils:lua_string_split(effectY,"?");
	local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?");
	local effectSpeedArr = StringUtils:lua_string_split(effectSpeed,"?");
	local effectScaleArr = StringUtils:lua_string_split(effectScale,"?");
    for k,v in pairs(effectIDArr) do
	    local delayEffectFunction;
		local effectDelayTimeSingal = tonumber(self:getValue(effectDelayTimeArr[k]));
		local effectSigalX = tonumber(self:getValue(effectXArr[k]))+self.flyUnit:getCoordinateX();
		local effectSigalY = tonumber(self:getValue(effectYArr[k]))+self.flyUnit:getCoordinateY();
		local effectScaleSingal = tonumber(self:getValue(effectScaleArr[k],1));
		local speed = tonumber(self:getValue(effectSpeedArr[k],1));
		if speed<10 then
			speed = speed*300;
		end	
		speed = speed*GameConfig.Game_FreamRate;
		local function deleyPlayEffect()
			if(nil~=delayEffectFunction) then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
			end
			self:PlayEffect(effectSigalX ,effectSigalY,v,speed,effectScaleSingal);
		end	
		self.effectCount = self.effectCount + 1;
		-- 特效延迟
		if(nil==delayEffectFunction) and effectDelayTimeSingal>0 then
			delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, effectDelayTimeSingal / 1000, false)
		else
			deleyPlayEffect();
		end
	end
end

function FlySkillFollowManager:PlayEffect(effectSigalX ,effectSigalY,effectId,speed,effectScaleSingal)
	if not self.effectArr then return end
	BattleUtils:playEffectYinxiao(effectId)
	local effectSpriteEach = CCSprite:create();
	local effectIconEach = Sprite.new(effectSpriteEach);
	effectIconEach:setAnchorPoint(CCPointMake(0,0));
	effectIconEach:setPositionXY(effectSigalX ,effectSigalY)	
	effectIconEach.name = BattleConfig.Is_Fly_Effect
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):addChild(effectIconEach);		
	local effectIcon = cartoonPlayer(effectId,0,0,0,nil,effectScaleSingal,nil,nil)
    effectIconEach:addChild(effectIcon);	
    effectIcon:setAnchorPoint(CCPointMake(0.5,0.1));
    local effect = {};
    effect.effectIconEach = effectIconEach;
    effect.effectIcon = effectIcon;
    effect.speed = speed;
    table.insert(self.effectArr,effect);
end

function FlySkillFollowManager:getValue(value,defaultV)
	defaultV = not defaultV and 0 or defaultV;
	if(value == nil or value == "#" or value == "") then
		return defaultV;
	else
		return value;
	end	
end
function FlySkillFollowManager:isArrived()
	return self.effectCount == 0;
end


function FlySkillFollowManager:update(now)
	if not self.effectArr then return end
	for k,v in pairs(self.effectArr) do
		local cx,cy = v.effectIconEach:getPositionX(),v.effectIconEach:getPositionY();
		local dx = (cx-self.target:getCoordinateX());
    	local dy = (cy-self.target:getCoordinateY());
    	local sqr = math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
    	if sqr<v.speed then
    		v.effectIconEach:setPositionXY(self.target:getCoordinateX(),self.target:getCoordinateY());
    		if not v.isArrive then
				self.effectCount = self.effectCount - 1;
				v.isArrive = true;
				v.effectIconEach:setVisible(false);
    		end
    	else
    		local moveX = -v.speed*dx/sqr;
    		local moveY = -v.speed*dy/sqr;
    		cx = cx+moveX;
    		cy = cy+moveY;
			local rad = math.deg(math.atan(-moveY/moveX));
			v.effectIcon:setRotation(rad);
    		v.effectIcon.sprite:setFlipX(moveX<0);
    		v.effectIconEach:setPositionXY(cx,cy);
    	end
	end
	if self:isArrived() or self.target:isDie() then
		self:onRemoveEffect();
	end
end
function FlySkillFollowManager:onRemoveEffect()
	if not self.effectArr then return end
	for k,v in pairs(self.effectArr) do
		if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):contains(v.effectIconEach) then
			sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(v.effectIconEach)
		end
	end
	self.effectArr = nil;
end