FlySkill = class();

function FlySkill:ctor()
	self.class = FlySkill;
	self.battleProxy = nil;
	self.flaySkillVO = nil;
	self.speedX = nil;
	self.screen = nil;
	self.tagetId = nil;
end

function FlySkill:removeSelf()
	self.class = nil;
end

function FlySkill:dispose()
	self:cleanAction();
end
function FlySkill:init(playerUnitID,battleProxy)
	self.battleProxy = battleProxy;
	self.flaySkillVO = self.battleProxy.battleFlySkillArray[playerUnitID];
	self.tagetId = self.flaySkillVO.targetBattleUnitID;

	local screen,attack,beAttack = analysisSingalSkill(self.flaySkillVO.skillId);
	self.screen = screen;
end
function FlySkill:playAction()
	self.speedX = self.flaySkillVO.speedX;
	self.speedY = self.flaySkillVO.speedY;
	if self:getValue(self.screen.attackType) == BattleConstants.CastTargetTypeEnemyTarget3 then
		self:RainAction();
	else
		self:flyAction();
	end
end
function FlySkill:RainAction()
	local screen = self.screen;
	local effectID = screen["feixingTexiaoID"];
	
    if(effectID == nil or effectID == "#") then
      return
    end
	      
	local effectIDArr = StringUtils:lua_string_split(effectID,"?")
	
    local effectSpeed = screen["feixingTexiaoSudu"];
	local effectDelayTime = screen["feixingTexiaoYanchi"]; 
	local effectScale = screen["feixingTexiaoSuofang"];
	local effectAnimateSpeed = screen["effectAnimateSpeed"];
	local attackRange = self:getValue(screen["attackRange"])*0.7;
	local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?");
	local effectSpeedArr = StringUtils:lua_string_split(effectSpeed,"?");
	local effectScaleArr = StringUtils:lua_string_split(effectScale,"?");
    local defDelayTime = self:getValue(effectDelayTimeArr[1]);

    for k,v in pairs(effectIDArr) do
    	local delayEffectFunction;
		local effectDelayTimeSingal = tonumber(self:getValue(effectDelayTimeArr[k]))-defDelayTime;
		local effectSigalX = self.flaySkillVO.coordinateX;
		local effectSigalY = self.flaySkillVO.coordinateY;	
		local effectScaleSingal = tonumber(self:getValue(effectScaleArr[k],1));	
		local function deleyPlayEffect()
			if(nil~=delayEffectFunction) then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
			end
			local effectIconEach = nil;
			-- 容错						
			if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS) == nil then return; end
			local function backFun()
                if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):contains(effectIconEach) then
					sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(effectIconEach)
				end
				effectIconEach = nil;
        	end
        	-- local position = ccp(effectSigalX+math.random(-attackRange,attackRange),effectSigalY+math.random(-attackRange,attackRange));
			--effectIconEach = cartoonPlayer(v,effectSigalX+math.random(-attackRange,attackRange),effectSigalY+math.random(-attackRange,attackRange),1,backFun,effectScaleSingal,nil,nil)
			effectIconEach.name = BattleConfig.Is_Fly_Effect
            effectIconEach = cartoonPlayer(v,effectSigalX,effectSigalY,1,backFun,effectScaleSingal,nil,nil)
            sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):addChild(effectIconEach);	
            effectIconEach:setAnchorPoint(CCPointMake(0.5,0.1));
		end	

		-- 特效延迟
		if(nil==delayEffectFunction) and effectDelayTimeSingal>0 then
			delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, effectDelayTimeSingal / 1000, false)
		else
			deleyPlayEffect();
		end

	end
end
-- 飞行特效
function FlySkill:flyAction()
	local screen = self.screen;
	local effectID = screen["feixingTexiaoID"];
	
    if(effectID == nil or effectID == "#") then
      return
    end
	local directPram = 1;
	if self.speedX<0 then
		directPram = -1;
	end
	      
	local effectIDArr = StringUtils:lua_string_split(effectID,"?")
	
    local effectSpeed = screen["feixingTexiaoSudu"];
    local effectX = screen["feixingTexiaoX"];
    local effectY = screen["feixingTexiaoY"] ;
	local effectDelayTime = screen["feixingTexiaoYanchi"]; 
	local effectScale = screen["feixingTexiaoSuofang"];
	local effectAnimateSpeed = screen["effectAnimateSpeed"];
	
	local effectXArr = StringUtils:lua_string_split(effectX,"?");
	local effectYArr = StringUtils:lua_string_split(effectY,"?");
	local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?");
	local effectSpeedArr = StringUtils:lua_string_split(effectSpeed,"?");
	local effectScaleArr = StringUtils:lua_string_split(effectScale,"?");
    local defDelayTime = self:getValue(effectDelayTimeArr[1]);
    for k,v in pairs(effectIDArr) do
    	
	
	    local delayEffectFunction;

		local effectDelayTimeSingal = tonumber(self:getValue(effectDelayTimeArr[k]))-defDelayTime;
		local effectSigalX = tonumber(self:getValue(effectXArr[k]))*directPram+self.flaySkillVO.coordinateX;
		local effectSigalY = tonumber(self:getValue(effectYArr[k]))+self.flaySkillVO.coordinateY;	
		local effectScaleSingal = tonumber(self:getValue(effectScaleArr[k],1));
		local speed = tonumber(self:getValue(effectSpeedArr[k],1));
		if speed<10 then
			speed = speed*300;
		end		
		
		local function deleyPlayEffect()
			if(nil~=delayEffectFunction) then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
			end
			self:PlayEffect(effectSigalX ,effectSigalY,v,speed,effectScaleSingal);
		end	
		
		-- 特效延迟
		if(nil==delayEffectFunction) and effectDelayTimeSingal>0 then
			delayEffectFunction = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyPlayEffect, effectDelayTimeSingal / 1000, false)
		else
			deleyPlayEffect();
		end
	end
end
function FlySkill:getValue(value,defaultV)
	defaultV = not defaultV and 0 or defaultV;
	if(value == nil or value == "#" or value == "") then
		return defaultV;
	else
		return value;
	end	
end

function FlySkill:getMoveXY(sx,sy)
	local x,y;
	if self.tagetId then
		local genVO = self.battleProxy.battleGeneralArray[self.tagetId];
		if genVO and genVO.battleIcon and genVO.battleIcon.sprite then
			local targetX = genVO.battleIcon:getPositionX();
			local targetY = genVO.battleIcon:getPositionY();
			if genVO.currentHP <= 0 then
				x,y = 0,0;
			else
				x,y = (targetX-sx)*0.5,(targetY-sy)*0.5;
			end
		else
			x,y = 0,0;--self.flaySkillVO.targetCoordinateX-sx,self.flaySkillVO.targetCoordinateY-sy;
		end
	else
		x,y = self.flaySkillVO.targetCoordinateX-sx,0;--self.flaySkillVO.targetCoordinateY-sy;
		--self.flaySkillVO.targetCoordinateX = 0;
		--self.flaySkillVO.targetCoordinateY = 0;
	end
	return x,y;
end
function FlySkill:PlayEffect(effectSigalX ,effectSigalY,effectId,speed,effectScaleSingal)
	local effectSpriteEach = CCSprite:create();
	local effectIconEach = Sprite.new(effectSpriteEach);
	effectIconEach:setAnchorPoint(CCPointMake(0,0));
	
	effectIconEach:setPositionXY(effectSigalX ,effectSigalY)	
			
	-- 容错						
	if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS) == nil or effectIconEach == nil then return; end
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):addChild(effectIconEach);		

	local effectIcon = cartoonPlayer(effectId,0,0,0,nil,effectScaleSingal,nil,nil)
    effectIconEach:addChild(effectIcon);	
    effectIcon:setAnchorPoint(CCPointMake(0.5,0.1));

	local function start()
		local moveX,moveY = self:getMoveXY(effectSigalX,effectSigalY);
		local moveS = 0;

		moveS = math.sqrt(moveX*moveX+moveY*moveY);
		if moveS<30 or moveS > 1270 then
			if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):contains(effectIconEach) then
				sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(effectIconEach)
			end
			effectIconEach = nil;
			return;
		end
		
		if self.tagetId then
			local rad = math.deg(math.atan(-moveY/moveX));
			effectIcon:setRotation(rad);
		end
		if effectIcon.isBoneEffect then
			if moveX<0 then
				effectIcon:setScaleX(-1);
			end
		else
			effectIcon.sprite:setFlipX(moveX<0);
		end

		local flyTime = moveS/speed;
		local spawnTwoArray = CCArray:create();
		local jumpUp = CCJumpBy:create(flyTime, ccp(moveX,moveY),1,1);
		effectSigalX,effectSigalY = effectSigalX+moveX,effectSigalY+moveY;
		spawnTwoArray:addObject(jumpUp);
		spawnTwoArray:addObject(CCCallFunc:create(start));
		if effectIconEach ~= nil then
			effectIconEach:runAction(CCSequence:create(spawnTwoArray));        
		end	
	end
	start();
end