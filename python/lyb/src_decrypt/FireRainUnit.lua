FireRainUnit = class();
function FireRainUnit:ctor(fireballList,caster,fireballId,skillMgr,target)
	self.class = FireRainUnit;
	self.fireballList = fireballList;
	self.theCaster = caster;
	self.target = target;
	self.attackIsOver = false;
	self.fireballId = fireballId;
	self.skillMgr = skillMgr;
	self.config = self.skillMgr:getActionConfig();
	self:init();
end
function FireRainUnit:getId()
	return self.fireballId;
end
function FireRainUnit:dispose()
	self.fireballList = nil;
	self.theCaster = nil;
	self.target = nil;
	self.skillMgr = nil;
	self.config = nil;
end
function FireRainUnit:setCoordinateX(cx)
	self.coordinateX = cx;
end
function FireRainUnit:setCoordinateY(cy)
	self.coordinateY = cy;
end
function FireRainUnit:getCoordinateX()
	return self.coordinateX;
end
function FireRainUnit:getCoordinateY()
	return self.coordinateY;
end
function FireRainUnit:init()
	self:setCoordinateX(self.theCaster:getCoordinateX());
	self:setCoordinateY(self.theCaster:getCoordinateY());
	self:RainAction();
	self.skillMgr:updataAttack();
end
function FireRainUnit:RainAction()
	local screen = self.config.screenSkill;
	local effectID = screen["feixingTexiaoID"];
    if(effectID == nil or effectID == "#") then return end
	      
    local effectSpeed = screen["feixingTexiaoSudu"];
	local effectDelayTime = screen["feixingTexiaoYanchi"]; 
	local effectScale = screen["feixingTexiaoSuofang"];
	--local effectAnimateSpeed = screen["effectAnimateSpeed"];
	--local attackRange = self:getValue(screen["attackRange"])*0.7;
	local effectIDArr = StringUtils:lua_string_split(effectID,"?");
	local effectSpeedArr = StringUtils:lua_string_split(effectSpeed,"?");
	local effectDelayTimeArr = StringUtils:lua_string_split(effectDelayTime,"?");
	local effectScaleArr = StringUtils:lua_string_split(effectScale,"?");
    local defDelayTime = self:getValue(effectDelayTimeArr[1]);

    for k,v in pairs(effectIDArr) do
    	local delayEffectFunction;
		local effectDelayTimeSingal = tonumber(self:getValue(effectDelayTimeArr[k]))-defDelayTime;
		local effectScaleSingal = tonumber(self:getValue(effectScaleArr[k],1));	
		local function deleyPlayEffect()
			if nil~=delayEffectFunction then
				Director:sharedDirector():getScheduler():unscheduleScriptEntry(delayEffectFunction)  
			end
			local effectIconEach = nil;					
			local function backFun()
                if sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):contains(effectIconEach) then
					sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):removeChild(effectIconEach)
				end
				effectIconEach = nil;
				self:onAttackOver();
        	end
            effectIconEach = cartoonPlayer(v,self.coordinateX,self.coordinateY,1,backFun,effectScaleSingal,nil,nil)
            effectIconEach.name = BattleConfig.Is_Fly_Effect
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

function FireRainUnit:update(now)

end

function FireRainUnit:getFireballList()
	return self.fireballList;
end

function FireRainUnit:getBattleField()
	return self.fireballList:getBattleField();
end

function FireRainUnit:getTheCaster()
	return self.theCaster;
end

function FireRainUnit:getSkill()
	return self.skill;
end

function FireRainUnit:isOver()
	return self.attackIsOver;
end

function FireRainUnit:onAttackOver()
	self.attackIsOver = true;
end

function FireRainUnit:sendBorenMessage()
	
end