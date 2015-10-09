SelectTargetImpl = class();

function SelectTargetImpl:ctor()
	self.class = SelectTargetImpl;
end

rawset(SelectTargetImpl,"instance",nil);
rawset(SelectTargetImpl,"getInstance",
	function()
		if SelectTargetImpl.instance then
		else
			rawset(SelectTargetImpl,"instance",SelectTargetImpl.new());
		end
		return SelectTargetImpl.instance;
	end);

function SelectTargetImpl:removeSelf()
	self.class = nil;
end

function SelectTargetImpl:dispose()
	self.cleanSelf()
end
function SelectTargetImpl:getTargetPosArr(source)
	if not source then return {} end;
	local myTeam = source:getMyTeam();
	local enemyTeam = myTeam:getEnemyTeam()
	return self:teamPosArr(enemyTeam);
end
function SelectTargetImpl:getSourcePosArr(source)
	if not source then return {} end;
	local myTeam = source:getMyTeam();
	return self:teamPosArr(myTeam);
end
function SelectTargetImpl:teamPosArr(enemyTeam)
	local posArr = {};
	if not enemyTeam then return posArr end
	for k,v in pairs(enemyTeam.bornUnitMap) do
		if v:isDie() then
		elseif v.standPosition<10 then
			posArr[v.standPosition] = v;
		elseif v.standPosition< 16 then
			local dp = v.standPosition-10
			posArr[1+dp] = v;
			posArr[4+dp] = v;
		elseif v.standPosition<20 then
			local dp1 = v.standPosition-16
			if v.standPosition>17 then dp1 = dp1+1 end
			posArr[1+dp1] = v;
			posArr[2+dp1] = v;
			posArr[4+dp1] = v;
			posArr[5+dp1] = v;
		elseif v.standPosition== 20 then
			posArr[1] = v;
			posArr[2] = v;
			posArr[3] = v;
			posArr[4] = v;
			posArr[5] = v;
			posArr[6] = v;
			posArr[7] = v;
			posArr[8] = v;
			posArr[9] = v;
		end
	end
	return posArr;
end
function SelectTargetImpl:getSelectEnemyTarget(source,skill)--TODU新的选择方式 未完待续
	local pos = BattleUtils:getTruePos(source.standPosition)
	local selectType = skill.heroSkillRange;
	local posArr = self:getTargetPosArr(source);
	local myPosArr= self:getSourcePosArr(source);
	local line = (pos-1)%3+1;
	local target;
	local function getTarget(posA,line,dl)
		local target = posA[line+dl] or posA[2+dl] or posA[1+dl] or posA[3+dl];
		return target;
	end
	if selectType == 1 then
		target = getTarget(myPosArr,line,0) or getTarget(myPosArr,line,3) or getTarget(myPosArr,line,6);
	elseif selectType == 2 then
		target = getTarget(posArr,line,6) or getTarget(posArr,line,3) or getTarget(posArr,line,0);
	elseif selectType == 3 then
		target = getTarget(myPosArr,line,6) or getTarget(myPosArr,line,3) or getTarget(myPosArr,line,0);
	elseif selectType == 4 then
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getCurrHp() > v:getCurrHp() then
					target = v;
				end
			end
		end
	elseif selectType == 5 then
		local myTeam = source:getMyTeam();
		for k,v in pairs(myTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getCurrHp() > v:getCurrHp() then
					target = v;
				end
			end
		end
	elseif selectType == 6 then
		local tmpArr = {};
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				table.insert(tmpArr,v);
			end
		end
		if #tmpArr > 0 then  
			local randomValue = math.random(1, #tmpArr);
			target = tmpArr[randomValue]
		else
			target = nil;
		end
	elseif selectType == 7 then
		local tmpArr = {};
		local myTeam = source:getMyTeam();
		for k,v in pairs(myTeam.bornUnitMap) do
			if v:isAlive() then
				table.insert(tmpArr,v);
			end
		end
		if #tmpArr > 0 then  
			local randomValue = math.random(1, #tmpArr);
			target = tmpArr[randomValue]
		else
			target = nil;
		end
	elseif selectType == 8 then
		target = source;
	elseif selectType == 9 then--TODU内功最高 未完待续
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getPropertyValue(PropertyType.NEI_ATTACK) < v:getPropertyValue(PropertyType.NEI_ATTACK) then
					target = v;
				end
			end
		end
	elseif selectType == 10 then--TODU外功最高 未完待续
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getPropertyValue(PropertyType.WAI_ATTACK) < v:getPropertyValue(PropertyType.WAI_ATTACK) then
					target = v;
				end
			end
		end
	elseif selectType == 11 then--TODU内防最高 未完待续
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getPropertyValue(PropertyType.NEI_DEFENSE) < v:getPropertyValue(PropertyType.NEI_DEFENSE) then
					target = v;
				end
			end
		end
	elseif selectType == 12 then--TODU外防最高 未完待续
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		local target;
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getPropertyValue(PropertyType.WAI_DEFENSE) < v:getPropertyValue(PropertyType.WAI_DEFENSE) then
					target = v;
				end
			end
		end
	elseif selectType == 13 then
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getCurrHp() < v:getCurrHp() then
					target = v;
				end
			end
		end
	elseif selectType == 14 then
		target = source:getAttackSouce();
	elseif selectType == 15 then
		local myTeam = source:getMyTeam();
		local enemyTeam = myTeam:getEnemyTeam()
		for k,v in pairs(enemyTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getCurrHp()/target:getMaxHP() > v:getCurrHp()/v:getMaxHP() then
					target = v;
				end
			end
		end
	elseif selectType == 16 then
		local myTeam = source:getMyTeam();
		for k,v in pairs(myTeam.bornUnitMap) do
			if v:isAlive() then
				if not target or target:getCurrHp()/target:getMaxHP() > v:getCurrHp()/v:getMaxHP() then
					target = v;
				end
			end
		end
	else --默认方式
		target = getTarget(posArr,line,0) or getTarget(posArr,line,3) or getTarget(posArr,line,6);
	end
	return target;
end

function SelectTargetImpl:getSelectTargetFun(skill)--TODO 从技能表里取出选目标方式去选择
	local function getRdTarget(target,count)
		local targs = target:getMyTeam().bornUnitMap;
		local tmpA = {};
		for k,v in pairs(targs) do
			table.insert(tmpA,v);
		end
		if #tmpA<=count+1 then return tmpA; end
		local rtnTmp = {};
		targs = tmpA;
		for i=1,count do
			tmpA = {};
			table.insert(rtnTmp,target);
			for k,v in pairs(targs) do
				if  v:getObjectId() ~= target:getObjectId() then table.insert(tmpA,v); end
			end
			local rk = math.random(1, #tmpA);
			target = tmpA[rk];
			targs = tmpA;
		end
		table.insert(rtnTmp,target);
		return rtnTmp;
	end
	if skill.SkillSDJfanW == 2 then
		local function selectFun(source)
			local line = math.floor((BattleUtils:getTruePos(source:getTarget().standPosition)-1)/3)*3;
			local posArr = SelectTargetImpl:getInstance():getSourcePosArr(source:getTarget());
			return {posArr[line+1],posArr[line+2],posArr[line+3]};
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 3 then
		local function selectFun(source)
			local line = (BattleUtils:getTruePos(source:getTarget().standPosition)-1)%3+1;
			local posArr = SelectTargetImpl:getInstance():getSourcePosArr(source:getTarget());
			return {posArr[line],posArr[line+3],posArr[line+6]};
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 4 then
		local function selectFun(source)
			return SelectTargetImpl:getInstance():getSourcePosArr(source:getTarget());
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 5 then
		local function selectFun(source)
			return getRdTarget(source:getTarget(),1);
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 6 then
		local function selectFun(source)
			return getRdTarget(source:getTarget(),2);
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 7 then
		local function selectFun(source)
			return getRdTarget(source:getTarget(),3);
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 8 then
		local function selectFun(source)
			local line1 = math.floor((BattleUtils:getTruePos(source:getTarget().standPosition)-1)/3)*3;
			local line2 = (BattleUtils:getTruePos(source:getTarget().standPosition)-1)%3+1;
			local posArr = SelectTargetImpl:getInstance():getSourcePosArr(source:getTarget());
			local rtnTmp = {};
			rtnTmp[line1+1] = posArr[line1+1];
			rtnTmp[line1+2] = posArr[line1+2];
			rtnTmp[line1+3] = posArr[line1+3];
			rtnTmp[line2] = posArr[line2];
			rtnTmp[line2+3] = posArr[line2+3];
			rtnTmp[line2+6] = posArr[line2+6];
			return rtnTmp;
		end
		return selectFun;
	elseif skill.SkillSDJfanW == 9 then
		local function selectFun(source)
			local target = source:getTarget();
			local posArr = SelectTargetImpl:getInstance():getSourcePosArr(source:getTarget());
			local other = posArr[target.standPosition+3];
			return {target,other};
		end
		return selectFun;
	else
		local function selectFun(source)
			return {source:getTarget()};
		end
		return selectFun;
	end
end
function SelectTargetImpl:selectPosiEnemyTarget(team,posMap)
	local posArr = self:teamPosArr(team);
	local targets = {};
	for i,v in ipairs(posMap) do
		local unit = posArr[v];
		if unit then
			targets[unit.generalID] = unit;
		end
	end
	return targets;
end

--怪选择敌人
local function sortOnIndex(a, b) return a.nearDistance < b.nearDistance end
function SelectTargetImpl:selectEnemyTarget(source,skill)
	local battleUnits = source:getEnemyTeam():getBattleUniMap();
	local enemyArray = {}
	for buk,buv in pairs(battleUnits) do
		if not buv:isProtectStatus() then--
			if (not buv:isDieAway()) or buv:getCurrHp()>0 then
				local distance = source:get3DDistance(buv)
				if source:getAlterRange() >= distance then
					if not source:isBoss() or not source:isElite() then
						buv.nearDistance = distance
						table.insert(enemyArray,buv)
					else
						if not buv:isMoveSideByBoss() then
							table.insert(enemyArray,buv)
						end
					end
				end
			end
		end
	end
	table.sort(enemyArray,sortOnIndex)
	return enemyArray[1];
end

--只支持友方最多四个角色选择敌人--友方选择敌人
function SelectTargetImpl:getSelectEnemyTarget1(source,skill)
	local enemyArray,nearestEnemy,bossUnit = self:getEnemyIndexArray(source)
	-- if source:getBattleField().battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then
	-- 	return nearestEnemy
	-- end
	-- if bossUnit then return bossUnit end
	local len = #enemyArray
	if len == 0 then return end
	if len == 1 then
		return enemyArray[1]
	end
	local indexY,totalNum = self:getIndexYSelfTeam(source)
	if totalNum == 1 then
		return nearestEnemy
	end
	if indexY == 1 then
		return enemyArray[1]--self:getNearEnemy(nearestEnemy,enemyArray[1],source,skill)
	elseif indexY == totalNum then
		return enemyArray[len]--self:getNearEnemy(nearestEnemy,enemyArray[len],source,skill)
	else
		if indexY == 2 then
			if totalNum == 3 then
				if len >= 3 then
					return self:getMidNearEnemy(2,len-1,enemyArray)
				else
					return self:getMidNearEnemy(1,2,enemyArray)
				end
			elseif totalNum == 4 then
				if len == 3 then
					return enemyArray[2]
				elseif len > 3 then
					return self:getMidNearEnemy(2,math.floor(len/2),enemyArray)
				else
					return self:getMidNearEnemy(1,2,enemyArray)
				end
			end
		elseif indexY == 3 then
			if len > 3 then
				return self:getMidNearEnemy(math.ceil(len/2),len-1,enemyArray)
			else
				return self:getMidNearEnemy(1,3,enemyArray)
			end
		end
		return enemyArray[1]
	end
end
function SelectTargetImpl:getMidNearEnemy(startN,endN,enemyArray)
	local tempArray = {}
	for i=startN,endN do
		table.insert(tempArray,enemyArray[i])
	end
	table.sort(tempArray,sortOnIndex)
	return tempArray[1]
end
--友方选择敌人
function SelectTargetImpl:getNearEnemy(nearestEnemy,enemy,source,skill)
	local attackRange = skill:getAttackDistance(source:getCarrer())
	local nearestDis = source:get3DDistance(enemy)
	if nearestDis < attackRange then
		return enemy
	else
		return nearestEnemy
	end
end

--友方选择敌人
local function sortOnCoordinateY(a, b) return a.coordinateY < b.coordinateY end
function SelectTargetImpl:getEnemyIndexArray(source)
	local battleUnits = source:getEnemyTeam():getBattleUniMap();
	local enemyArray = {}
	local bossUnit;
	for buk,buv in pairs(battleUnits) do
		if not buv:isProtectStatus() then
			if (not buv:isDieAway()) or buv:getCurrHp()>0 then
				local distance = source:get3DDistance(buv)
				-- if source:getAlterRange() >= distance then
					buv.nearDistance = distance
					table.insert(enemyArray,buv)
					if buv:isBoss() or buv:isElite() then
						bossUnit = buv
					end
				-- end
			end
		end
	end
	table.sort(enemyArray,sortOnIndex)
	local nearestEnemy = enemyArray[1]
	local num = #enemyArray
	if num > 1 then
		for key,value in ipairs(enemyArray) do
			if nearestEnemy:get3DDistance(enemyArray[num]) > 10 then
				table.remove(enemyArray,num)
			else
				break
			end
			num = num - 1
		end
	end
	table.sort(enemyArray,sortOnCoordinateY)
	return enemyArray,nearestEnemy,bossUnit
end
--友方选择敌人
function SelectTargetImpl:getIndexYSelfTeam(source)
	local battleUnits = source:getSelfTeam():getBattleUniMap();
	local friendArray = {}
	for buk,buv in pairs(battleUnits) do
		if (not buv:isDieAway()) or buv:getCurrHp()>0 then
			table.insert(friendArray,buv)
		end
	end
	table.sort(friendArray,sortOnCoordinateY)
	for buk,buv in pairs(friendArray) do
		if buv:getObjectId() == source:getObjectId() then
			return buk,#friendArray
		end
	end
end

function SelectTargetImpl:getSelectTargetFun1(skill)
	if skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget6 then
		local function selectSkillTarget(caster,centerPoint, skill)
			return self:selectTarget_DisCircle(caster, skill);
		end
		return selectSkillTarget;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget7 
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget12 then
		local function selectSkillTarget(caster,centerPoint, skill)
			return self:selectTarget_Sector(caster,centerPoint, skill);
		end
		return selectSkillTarget;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget8 then
		local function selectSkillTarget(caster,centerPoint, skill)
			return {caster};
		end
		return selectSkillTarget;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget9 then
		local function selectSkillTarget(caster,centerPoint, skill)
			return self:selectSelfTarget_Circle(caster,centerPoint, skill);
		end
		return selectSkillTarget;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget11 then
		local function selectSkillTarget(caster,centerPoint, skill)
			return self:selectSelfTarget_Diamond(caster,centerPoint, skill);
		end
		return selectSkillTarget;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget4 or
		  skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget5 then
		local function selectSkillTarget(caster, centerPoint, skill)
			return self:selectTarget_Circle_limited(caster, centerPoint, skill);
		end
		return selectSkillTarget;
	else
		local function selectSkillTarget(caster, centerPoint, skill)
			return self:selectTarget_Circle(caster, centerPoint, skill);
		end
		return selectSkillTarget;
	end
end
-----------
--选择QTE区域内角色
-----------
function SelectTargetImpl:getQTETargetFun(skill)
	if skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget2 
	or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget4
	or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget5 then-------胶囊型
		local function selectSkillTarget(caster, centerPoint, skill)
			return self:selectTarget_CircleDiamond(caster, centerPoint, skill);
		end
		return selectSkillTarget;
	else
		return 	self:getSelectTargetFun(skill);
	end
end
-----------
--生成QTE区域点
-----------
function SelectTargetImpl:getQTEPosFun(caster,target,centerPoint,skill)
	print("skill:getTarget()---->",skill:getTarget())
	local attackX,attackY,attackEX,attackR = 0,0,0,0;
	local face = caster:getFaceDirect();
	local attackR = skill:getSkillActionConfig():getEffectRange();
	local attackD = skill:getSkillActionConfig():getAttackDistance();
	if skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget2 
	or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget4
	or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget5 then-------胶囊型
		attackX,attackY  = caster:getCoordinateX(),caster:getCoordinateY();
		attackX = attackX-face*attackR;
		attackEX = attackX+face*(attackR+attackD);
		attackR = attackR;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget6
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget8
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget9 then-------自身中心圆
		attackX,attackY  = caster:getCoordinateX(),caster:getCoordinateY();
		attackX = attackX-attackD;
		attackEX = attackX+attackD;
		attackR = attackD;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget1 
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget3
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget10 then-------目标中心圆
		if not centerPoint then
			local trgt = self.caster:getTarget();
			if trgt then
				centerPoint = ccp(trgt:getCoordinateX(),trgt:getCoordinateY());
			else
				centerPoint = ccp(self.caster:getCoordinateX(),self.caster:getCoordinateY());
			end
		end
		attackX,attackY  = centerPoint.x,centerPoint.y;
		attackX = attackX-attackR;
		attackEX = attackX+attackR;
		attackR = attackR;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget7
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget12 then-------自身中心扇形
		attackX,attackY  = caster:getCoordinateX(),caster:getCoordinateY();
		attackEX = attackX+face*attackD;
		local rc = analysis("Xishuhuizong_Xishubiao",1030,"constant");
		attackR = math.sin(rc*0.5)*attackD;
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget11 then-------自身中心菱形
		attackX,attackY  = caster:getCoordinateX(),caster:getCoordinateY();
		attackEX = attackX+face*attackD;
		attackR = attackR;
	end
	if attackX>attackEX then
		attackX,attackEX = attackEX,attackX;
	end
	return BattleFormula:makeQTEPoint(caster,attackX,attackEX,attackY,target:getCoordinateX(),target:getCoordinateY(),attackR);--(source,sx,ex,sey,tx,ty,r)
end
-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能
function SelectTargetImpl:selectTarget_CircleDiamond(caster,centerPoint, skill)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	centerPoint = centerPoint and centerPoint or ccp(caster:getCoordinateX(),caster:getCoordinateY());
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	local function isInRange(centerPoint, buv, skill,face)
		local centerPoint1 = ccp(centerPoint.x+skill:getSkillActionConfig():getAttackDistance()*face,centerPoint.y);
		face = face==-1;
		return BattleFormula:isInCircleRange(centerPoint, buv, skill) 
			or BattleFormula:isInDiamond(centerPoint, buv, skill,face)
			or BattleFormula:isInCircleRange(centerPoint1, buv, skill);
	end
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and isInRange(centerPoint, buv, skill,caster:getFaceDirect()) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if isInRange(centerPoint, buv, skill,caster:getFaceDirect()) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end
-- caster 释放者 skill是技能
function SelectTargetImpl:selectTarget_DisCircle(caster, skill)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	local centerPoint = ccp(caster:getCoordinateX(),caster:getCoordinateY());

	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and BattleFormula:isInCircleDis(centerPoint, buv, skill) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if BattleFormula:isInCircleDis(centerPoint, buv, skill) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end
-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能
function SelectTargetImpl:selectTarget_Circle(caster,centerPoint, skill)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	centerPoint = centerPoint and centerPoint or ccp(caster:getCoordinateX(),caster:getCoordinateY());
	
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and BattleFormula:isInCircleRange(centerPoint, buv, skill) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if BattleFormula:isInCircleRange(centerPoint, buv, skill) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end

-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能，冲刺
function SelectTargetImpl:selectTarget_Circle_limited(caster,centerPoint, skill)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	centerPoint = centerPoint and centerPoint or ccp(caster:getCoordinateX(),caster:getCoordinateY());
	
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and BattleFormula:isInCircleRangeLimited(centerPoint, buv, skill,caster) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if BattleFormula:isInCircleRangeLimited(centerPoint, buv, skill,caster) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end

-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能
function SelectTargetImpl:selectTarget_Sector(caster,centerPoint, skill,faceDirect)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	local attPoint = ccp(caster:getCoordinateX(),caster:getCoordinateY())
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	
	local face = faceDirect or caster:getFaceDirect() == -1
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and BattleFormula:isInSectorDis(attPoint, buv, skill,face) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if BattleFormula:isInSectorDis(attPoint, buv, skill,face) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end
-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能
function SelectTargetImpl:selectSelfTarget_Diamond(caster,centerPoint, skill,faceDirect)
	if caster.effectManager:hasEffect(BattleConstants.SKILL_EFFECT_ID_80) then
		return {caster:getTarget()};
	end
	local targets = {};
	local battleUnits = {};
	local attPoint = ccp(caster:getCoordinateX(),caster:getCoordinateY())
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	
	local face = faceDirect or caster:getFaceDirect() == -1
	for buk,buv in pairs(battleUnits) do
		if skill.duangjnzdid == 0 or caster:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 and BattleFormula:isInDiamond(attPoint, buv, skill,face) then
				if not buv:isProtectStatus() then
					table.insert(targets,buv);
				end
			end	
		else
			if BattleFormula:isInDiamond(attPoint, buv, skill,face) then
				table.insert(targets,buv);
			end	
		end
	end
	return targets;
end
-- caster 释放者 centerPoint 是选取攻击目标的基准点 skill是技能
function SelectTargetImpl:selectSelfTarget_Circle(caster,centerPoint, skill)
	local targets = {};
	local battleUnits = {};
	battleUnits = caster:getSelfTeam():getBattleUnits();
	if skill:getSeltctTargetType() == BattleConstants.Target_Select_type1 then
		local target = nil;
		for buk,buv in pairs(battleUnits) do
			if target == nil or (not buv:isDieAway() and buv:getCurrHp() < target:getCurrHp())  then
				target = buv;
			end	
		end
		targets = {target};
	elseif skill:getSeltctTargetType() == BattleConstants.Target_Select_type2 then
		for buk,buv in pairs(battleUnits) do
			if buv:btlPosType() == BattleConstants.Target_Position_type1 then
				table.insert(targets,buv);
			end
		end
	else
		for buk,buv in pairs(battleUnits) do
			if (not buv:isDieAway()) and buv:getCurrHp() > 0 then -- and BattleFormula:isInCircleRange(centerPoint, buv, skill) then
				--if not buv:isProtectStatus() then
				table.insert(targets,buv);
				--end
			end	
		end
	end
	return targets;
end

local function sortOnTargetIndex(a, b) return a.sectorDistance < b.sectorDistance end
function SelectTargetImpl:getChoosedSkillTarget(caster,skill)
	local rightTargets = self:selectTarget_Sector(caster,nil, skill,false)
	local leftTargets = self:selectTarget_Sector(caster,nil, skill,true)
	if #rightTargets == 0 and #leftTargets == 0 then return end
	if #rightTargets > #leftTargets then
		table.insert(rightTargets,sortOnTargetIndex)
		return rightTargets[1]
	else
		table.insert(leftTargets,sortOnTargetIndex)
		return leftTargets[1]
	end 
end

function SelectTargetImpl:chooseStopSkillTarget(caster,centerPoint, skill)
	if skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget6 then
		return self:selectTarget_DisCircle(caster, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget7 
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget12 then
			return self:selectTarget_Sector(caster,centerPoint, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget8 then
			return {caster};
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget9 then
			return self:selectSelfTarget_Circle(caster,centerPoint, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget11 then
			return self:selectSelfTarget_Diamond(caster,centerPoint, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget1
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget3
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget10 then
			return self:selectTarget_Circle(caster, centerPoint, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget2 then
		return self:selectSelfTarget_Diamond(caster,centerPoint, skill);
	elseif skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget4
		or skill:getTarget() == BattleConstants.CastTargetTypeEnemyTarget5 then
			return self:selectSelfTarget_Diamond_AddCicle(caster, centerPoint, skill);
	end
end

function SelectTargetImpl:selectSelfTarget_Diamond_AddCicle(caster,centerPoint, skill)
	local targets = {};
	local battleUnits = {};
	local attPoint = ccp(caster:getCoordinateX(),caster:getCoordinateY())
	battleUnits = caster:getEnemyTeam():getBattleUnits(skill);
	
	-- local face = faceDirect or caster:getFaceDirect() == -1
	for buk,buv in pairs(battleUnits) do
		if BattleFormula:isInDiamondAddCicle(attPoint, buv, skill,caster) then
			table.insert(targets,buv);
		end	
	end
	return targets;
end













