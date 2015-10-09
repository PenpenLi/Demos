BaseBtlUnit = class();
--战斗单位
function BaseBtlUnit:ctor()
	self.class = BaseBtlUnit;
	self.battleUnitID = nil;
	self.userID = nil;
	self.standPoint = nil;
	self.standPosition = nil;--站位
	self.type = nil;
	self.generalID = nil;
    self.career = nil;
	self.level = nil;

	self.headImage = nil;
	self.clickSkill = nil;
    self.normalSkill = nil;
    self.standPositionCcp = nil;
    self.tableName = "Kapai_Kapaiku";
    self.modeName = "material_id";
    self.skillMap = {};
    self.paSkillMap = {};
    self.effectArray = {};

    self.coordinateX = 0;--TODO 根据点赋值
    self.coordinateY = 0;
    require("main.controller.command.battleScene.battle.battlefield.property.PropertyManagerImpl")
	require("main.controller.command.battleScene.battle.battlefield.property.PropertyValue")
	require("main.controller.command.battleScene.battle.battlefield.property.PropertyType")
	self.propertyManager = PropertyManagerImpl.new(self);
end
function BaseBtlUnit:getPropertyManager()
	return self.propertyManager;
end
function BaseBtlUnit:dispose()
    self:cleanSelf();
end
function BaseBtlUnit:setFaceDirect(isFaceL)
		self.faceDirect = isFaceL; 
end
function BaseBtlUnit:getFaceDirect()
	return self.faceDirect
end
function BaseBtlUnit:rsetFaceDirect()
	self.faceDirect = self.standPoint == BattleConstants.STANDPOINT_P2
end
function BaseBtlUnit:setPositionCcp(pos)
	self:setPositionXY(pos.x,pos.y-self.standPosition*0.0001);
end
function BaseBtlUnit:setPositionXY(x,y)
	self.coordinateX = x;
	self.coordinateY = y;
	if self.battleIcon and self.battleIcon.sprite then
		self.battleIcon:setPositionXY(self.coordinateX,self.coordinateY,true);
		self.roleShadow:setPositionXY(self.coordinateX,self.coordinateY,true)
	end
end
function BaseBtlUnit:getPositionXY()
	if self.battleIcon and self.battleIcon.sprite then
		local pos = self.battleIcon:getPosition();
		return pos.x,pos.y;
	else
		return self.coordinateX,self.coordinateY;
	end
end
function BaseBtlUnit:getCoordinateX()
	local x,y = self:getPositionXY();
	return x;
end
function BaseBtlUnit:getCoordinateY()
	local x,y = self:getPositionXY();
	return y;
end
function getStandPos()
	if self.standPoint == BattleConstants.STANDPOINT_P1 then
		return Battle_Pos_L[self.standPosition];
	else
		return Battle_Pos_R[self.standPosition];
	end
end
function BaseBtlUnit:configMonsterData()
	self.tableName = "Guaiwu_Guaiwubiao";
    self.modeName = "modelId";
    self:initMonsterValues();
end
function BaseBtlUnit:initMonsterValues()
	local monsterConfig = self:getMonsterConfig(self.generalID);
	self.isElite = monsterConfig.type == 2;
	self.isBoss = monsterConfig.type == 3;
	self.career = monsterConfig.job;
	self.suDu = monsterConfig.suDu;--出手速度
	local propertyConfig = self:getProperty1Config(monsterConfig.job)
	local map = {};
	local config = self:getProperty2Config(monsterConfig.zhanChangPP);
	map[PropertyType.MAX_HP] = createIntProperValue(PropertyType.MAX_HP,config.lif);
	map[PropertyType.WAI_ATTACK] = createIntProperValue(PropertyType.WAI_ATTACK, config.attackWai);
	map[PropertyType.NEI_ATTACK] = createIntProperValue(PropertyType.NEI_ATTACK, config.attackNei);
	map[PropertyType.WAI_DEFENSE] = createIntProperValue(PropertyType.WAI_DEFENSE, config.ArmorWai);
	map[PropertyType.NEI_DEFENSE] = createIntProperValue(PropertyType.NEI_DEFENSE, config.ArmorNei);
	map[PropertyType.BAOJI] = createIntProperValue(PropertyType.BAOJI, config.criticalHitLv);
	map[PropertyType.POFANG] = createIntProperValue(PropertyType.POFANG, config.ArmorDown);
	map[PropertyType.ZHILIAOZHI] = createIntProperValue(PropertyType.ZHILIAOZHI, config.HealUp);
	map[PropertyType.SHANBI] = createIntProperValue(PropertyType.SHANBI, config.Dodge);
	map[PropertyType.DIKANG] = createIntProperValue(PropertyType.DIKANG, config.Negative);
	map[PropertyType.ZUDANG] = createIntProperValue(PropertyType.ZUDANG, config.Parry);
	map[PropertyType.XIXUE] = createIntProperValue(PropertyType.XIXUE, config.Suck);
	map[PropertyType.MOVE_SPEED] = createIntProperValue(PropertyType.MOVE_SPEED, propertyConfig.speedBattle);
	self.propertyManager:initializePropertyValue(map);
	self.checkMaxHP = self.propertyManager:getIntValue(PropertyType.MAX_HP)--服务器验证的数据
	self.propertyManager:addIntValue(PropertyType.CURR_HP,self:getMaxHP());
	self.propertyManager:getProperty(PropertyType.CURR_HP):setUpdate(false);

	self.skillMap = {};
	if monsterConfig.pugong > 0 then
	    local skillPg = analysis("Jineng_Jineng",monsterConfig.pugong);
	    skillPg.lv =  self.level;
	    self.skillMap[monsterConfig.pugong] = skillPg;
	end
    if monsterConfig.skill > 0 then
	    local skillJN = analysis("Jineng_Jineng",monsterConfig.skill);
	    skillJN.lv =  self.level;
	    self.skillMap[monsterConfig.skill] = skillJN;
	end
end
function BaseBtlUnit:initPropertyValues(UnitPropertyArray)
	local map = {};
	-- --武将属性,没有攻防血
	for key,value in pairs(UnitPropertyArray) do
		local propertyValue =  PropertyValue.new(value.PropertyKey,BattleConstants.VALUE_TYPE_INT);
		map[value.PropertyKey] = propertyValue
		propertyValue:addIntValue(value.PropertyValue);
	end
	self.propertyManager:initializePropertyValue(map);
	self.checkMaxHP = self.propertyManager:getIntValue(PropertyType.MAX_HP)--服务器验证的数据
	local maxHp = self:getTotalPropertyValue(PropertyType.MAX_HP,PropertyType.MAX_HP_PER)
	self.propertyManager:setIntValue(PropertyType.MAX_HP,maxHp);
	-- self.propertyManager:setIntValue(PropertyType.MAX_HP,maxHp+9999999);--测试用
	-- self.propertyManager:setIntValue(PropertyType.CURR_HP,maxHp+9999999);--测试用
end
local function sortSkillFun(a,b)
	return a:getSkill().typyP>b:getSkill().typyP;
end 
function BaseBtlUnit:initData()
	self.skillAddRage = 0;
	require "main.controller.command.battleScene.battle.battlefield.SkillAttackManager"
	local skillMapTmp = {};
	for k,v in pairs(self.skillMap) do
		local skillManager = SkillAttackManager.new(self,v);
		table.insert(skillMapTmp,skillManager);
	end
	self.skillMap = skillMapTmp;
	table.sort( self.skillMap, sortSkillFun );
end
function BaseBtlUnit:initUnit()
	require("main.controller.command.battleScene.battle.battlefield.BattleUnitMoveManager")
	self.moveManager = BattleUnitMoveManager.new(self);
	require("main.controller.command.battleScene.battle.fsm.MachineState")
	self.machineState = MachineState.new(self);
	self.machineState:initialize();
	require("main.controller.command.battleScene.battle.battlefield.BattleUnitEffectManager")
	self.effectManager = BattleUnitEffectManager.new(self)
	require "main.view.battleScene.core.AIEngin"
	self.actionManager = AIEngin.new();
  	self.actionManager:initData(self);
  	self.speed = self.propertyManager:getIntValue(PropertyType.MOVE_SPEED);
end
function BaseBtlUnit:getMoveManager()
	return self.moveManager;
end
function BaseBtlUnit:BornUnit()
	self.isBornOver = true;
	self:initUnit();
	self:rsetFaceDirect();
	self:compositeRole();
	self:initRoleShadow();
	self:startSkillCD();
end
function BaseBtlUnit:startSkillCD()
	for k,v in pairs(self.skillMap) do
		v:startCDTime();
	end
end
function BaseBtlUnit:compositeRole()
	require "main.common.transform.CompositeActionAllPart"
	local roleComposite = CompositeActionAllPart.new();
	roleComposite:initLayer();
	roleComposite:setPositionXY(self.coordinateX,self.coordinateY);
	self.battleIcon = roleComposite;
	--首场战斗
	self.zishiType = BattleConfig.HOLD;
	self:initItemIdBody(roleComposite);
	roleComposite:setRoleVO(self);
	roleComposite.name = BattleConfig.Is_Player_Role
	roleComposite:initHpProgressBar(self:getBattleProxy():getSkeleton(),self:getCurrHp()/self:getMaxHP())
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):addChild(roleComposite);
	roleComposite:changeFaceDirect(self.faceDirect);
end
--生成影子
function BaseBtlUnit:initRoleShadow()
    local roleShadow
    if self.isBoss or self.isElite then
      local cartoonId = self.isBoss and 1091 or 1092
      roleShadow = cartoonPlayer(cartoonId,0,0,0);
      sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):addChild(roleShadow);
    else
      roleShadow = Image.new()
      roleShadow:loadByArtID(19)
      roleShadow:setAnchorPoint(CCPointMake(0.5,0.5));
      sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):addChild(roleShadow);
    end
    roleShadow:setPositionXY(self.coordinateX,self.coordinateY);
    self.roleShadow = roleShadow;
    self.battleIcon.roleShadow = roleShadow;
    
end
function BaseBtlUnit:initItemIdBody(roleComposite)
    local VO = analysis(self.tableName,self.generalID); 
    self.modeId = VO[self.modeName];
    local array = {[1] = {["type"] = BattleConfig.TRANSFORM_BODY, ["sourceName"] = self.modeId .. "_" .. BattleConfig.HOLD}};
    self.name = VO.name;
    roleComposite:transformPartCompose(array,true);
end
function BaseBtlUnit:getActionTotalTime(actionNo)
	local key = "key_"..self.modeId.."_"..actionNo;
	require("main.controller.command.battleScene.battle.battlefield.ArtsFrameConfigContext")
	return ArtsFrameConfigContext:getInstance():getCartoonTotalTime(key);
end
--/** 综合数值和百分比，返回最终数值 **/
function BaseBtlUnit:getTotalPropertyValue(valueKey,perKey)
	local value = self.propertyManager:getPropertyValue(valueKey);
	local valuePer = self.propertyManager:getPropertyValue(perKey) + BattleConstants.HUNDRED_THOUSAND;
	if value <= 0 then
		return 0;
	end
	if valuePer <= 0 then
		return value;
	end
	return math.floor(value * valuePer / BattleConstants.HUNDRED_THOUSAND);
end
function BaseBtlUnit:getPropertyValue(key)
	return self.propertyManager:getPropertyValue(key);
end
function BaseBtlUnit:update(now)
	if not self.isBornOver then return end
	self.machineState:update(now);--执行状态机
	self.effectManager:update(now);--执行效果
end
function BaseBtlUnit:updateState(now)
	self.machineState:update(now);--执行状态机
end
--可变部分的攻击
function BaseBtlUnit:getChangeAttack()
	local addValue = self.propertyManager:getIntValue(PropertyType.ATTACK);
	local addPercent = self.propertyManager:getIntValue(PropertyType.ATTACK_PER);
	return math.floor((addValue*addPercent+addValue*100000)/100000);
end
function BaseBtlUnit:getMonsterConfig(monsterId)
	return analysis("Guaiwu_Guaiwubiao",monsterId)
end

function BaseBtlUnit:getProperty2Config(zhanChangPP)
	return analysisByUnionKey("Guaiwu_Zhanchangpipeishuju",{"nanducanshu","lv"},zhanChangPP.."_"..self.level);
end

-- function BaseBtlUnit:getProperty3Config(conId)
-- 	return analysis("Guaiwu_Shuxing",conId)
-- end
function BaseBtlUnit:getProperty1Config(carrerId)
	return analysis("Shuxing_Zhiye",carrerId)
end
function BaseBtlUnit:isDie()
	if not self.isBornOver then
		return false
	end 
	return self:getCurrHp() <= 0;
end
function BaseBtlUnit:isAlive()
	if not self.isBornOver then
		return false
	end 
	if self:getCurrHp() <= 0 then
		return false;
	end
	return true;
end
function BaseBtlUnit:getCurrHp()
	return self.propertyManager:getIntValue(PropertyType.CURR_HP);
end
function BaseBtlUnit:setCurrHp(currHp)
	self.propertyManager:setIntValue(PropertyType.CURR_HP,currHp);
end
function BaseBtlUnit:getMaxHP()
	local baseMaxHp = self.propertyManager:getIntValue(PropertyType.MAX_HP);
	return math.ceil(baseMaxHp)--+990000000
end
function BaseBtlUnit:getCurrRage()
	return self.propertyManager:getIntValue(PropertyType.CURRENT_RAGE);
end
function BaseBtlUnit:roundAddRage()--回合结束加怒气
	self.propertyManager:addIntValue(PropertyType.CURRENT_RAGE,self.skillAddRage);
	self.skillAddRage = 0;
end
function BaseBtlUnit:chickSkill()
	if self:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3005) then--沉默
		return
	end
	for k,v in pairs(self.skillMap) do
		if v:canUseSkill(self:getSelectSkillTag()) then
		 	return v:getSkill().id;
		end
	end
end
function BaseBtlUnit:chooseSkill()
	if self.pGSkill then return self.pGSkill end
	for k,v in pairs(self.skillMap) do
		if v:getSkill().typyP == 1 then --and v:isCDTimeArrived()
			self.pGSkill = v;
		 	return v;
		end
	end
end
function BaseBtlUnit:getSkill(id)
	for k,v in pairs(self.skillMap) do
		if v:getSkill().id == id then
			return v;
		end
	end
	for k,v in pairs(self.paSkillMap) do
		if v:getSkill().id == id then
			return v;
		end
	end
end
function BaseBtlUnit:getSkillType(id)
	return self:getSkill(id):getSkill().typyP;
end
function BaseBtlUnit:getTarget()
	return self.attackTarget;
end
function BaseBtlUnit:perAttackStart()
	--TODU 选择目标 判断远程进程
	if self:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3002)
	or self:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3004) then
		return self.machineState:switchState(StateEnum.IDLE);
	end
	self.machineState:switchState(StateEnum.PERSKILL);
	if self.useSkillId then
		self.selectSkillManager = self:getSkill(self.useSkillId);
	else
		self.selectSkillManager = self:chooseSkill();
	end
	if not self.selectSkillManager then
		print("!!!!!!!!!!!!!!have no skill can use!!!!!!!!!!!!!!!!")
		return self.machineState:switchState(StateEnum.IDLE);
	end
	self.useSkillId = self.selectSkillManager:getSkill().id;
	self.attackTarget = self.selectSkillManager:getSelectTarget();
	if not self.attackTarget then
		self.useSkillId = nil;
		return self.machineState:switchState(StateEnum.IDLE);
	end
	self:getBattleField():onBigSkill(self.selectSkillManager:getSkill().typyP==3);
	self:getBattleField():playBeginAttackEffect(self.battleUnitID,self.useSkillId);
	self.useSkillId = nil;
end
function BaseBtlUnit:AttackStart()
	--print("--------------aaaaaaaaaaa  bbb     ",self.useSkillId)
	if self.selectSkillManager and self.selectSkillManager:getSelectTarget() then
		--self.attackTarget = self.selectSkillManager:getSelectTarget();
		self.attackTarget.perAttUnit = self;
		BattleUtils:sendUpdateHRValue(self,0,self.attfury-self.selectSkillManager:getSkill().xiaoHao);
		if self.selectSkillManager:isFlySkill() then
			self.machineState:switchState(StateEnum.FLYATTACK);
		elseif self.selectSkillManager:getActionConfig().attackType == BattleConstants.CastTargetTypeEnemyTarget9 then
			self.machineState:switchState(StateEnum.ATTACK);
		else
			self.machineState:switchState(StateEnum.PURSUE);
		end
	else
		self.machineState:switchState(StateEnum.IDLE);
	end
end
function BaseBtlUnit:reSelectAndAttack()--如果攻击目标在攻击时已经死了 近战攻击时候用
	self.attackTarget = self.selectSkillManager:getSelectTarget();
	if not self.attackTarget or self.attackTarget:isDie() then
		return false;
	end
	self:AttackStart();
	return true;
end
function BaseBtlUnit:getSelectSkill()
 return self.selectSkillManager;
end
function BaseBtlUnit:getAttackTargets()
	if self.selectSkillManager then
		return self.selectSkillManager:getAttackTargets()
	else
		return {};
	end
end
function BaseBtlUnit:isPerSkill()
	return self.machineState:getCurrentState():getStateEnum() == StateEnum.PERSKILL; 
end
function BaseBtlUnit:isAttackOver()
	if self.myTeam.isPauseScript then return end
	if self:isDie() 
		or self.machineState:getCurrentState():getStateEnum() == StateEnum.IDLE 
		or self.machineState:getCurrentState():getStateEnum() == StateEnum.FROZEN then
		self.selectSkillManager = nil;
		return true;
	else
		return false;
	end
end
function BaseBtlUnit:setCurrentState(state)
	self.machineState:switchState(state);
end
function BaseBtlUnit:setMyTeam(team)
	self.myTeam = team;
end
function BaseBtlUnit:getMyTeam()
	return self.myTeam;
end
function BaseBtlUnit:getObjectId()
	return self.battleUnitID;
end
function BaseBtlUnit:getBattleField()
	return self.myTeam.battleField;
end
function BaseBtlUnit:getBattleProxy()
	return self.myTeam.battleField.battleProxy;
end
function BaseBtlUnit:getDefense()
	if self:isWaiAttack() then
		return self:getTotalPropertyValue(PropertyType.WAI_DEFENSE, PropertyType.WAI_DEFENSE_PER);
	end
	return self:getTotalPropertyValue(PropertyType.NEI_DEFENSE, PropertyType.NEI_DEFENSE_PER);
end
function BaseBtlUnit:setAttackSouce(souce)
	self.attackSouce = souce;
end
function BaseBtlUnit:getAttackSouce()
	return self.attackSouce;
end
function BaseBtlUnit:isWaiAttack()
	if not self.qingXiang then
		self.qingXiang = analysis("Shuxing_Zhiye", self.career,"qingXiang");
	end
	if self.qingXiang == 1 then
		return false
	else
		return true
	end
end
function BaseBtlUnit:onSanBi(sbV)--1315,1316 
	if sbV == 1 then
		self.actionManager:hanZiPop(BattleConfig.Effect_Text_Shanbi)
	elseif sbV == 2 then
		self.actionManager:hanZiPop(BattleConfig.Effect_Text_Yujing)--抵抗
	end
end
function BaseBtlUnit:onBaoJi(isBJ,baoJiZhi,skillID)--1314
	if isBJ ~= 0 then
		self.actionManager:hanZiPopShuzi(BattleConfig.Effect_Text_Huixin,baoJiZhi,skillID)
	end
end
function BaseBtlUnit:onZhuDang(isZhuDang,zhuDangZhi,skillID)--1317
	if isZhuDang ~= 0 then
		self.actionManager:hanZiPopShuzi(BattleConfig.Effect_Text_ZhuDang,zhuDangZhi,skillID)
	end
end
function BaseBtlUnit:changeHP(cutValue,isPX,skillID)
	self.changeValue = cutValue;
	cutValue = math.min(cutValue,self:getMaxHP()-self:getCurrHp());
	if cutValue+self:getCurrHp()<0 then
		cutValue=-self:getCurrHp();
	end
	self.propertyManager:addIntValue(PropertyType.CURR_HP,cutValue);
	self:getBattleField().battleSceneMediator:refreshHpData(self)
	if isPX and self.changeValue ~= 0 then
		self.actionManager:changeHPAction(skillID);
	end
	if self.machineState:getCurrentState():getStateEnum() ~= StateEnum.BEATTACKED and self:isDie() then 
		self.machineState:switchState(StateEnum.DEAD);
	end
end
function BaseBtlUnit:switchDead()
	self.machineState:switchState(StateEnum.DEAD);
end
function BaseBtlUnit:changeRange(cutValue)
	--print("changeRange     ",self:getObjectId(),cutValue,self:getCurrRage());
	--cutValue = cutValue*5
	cutValue = math.min(cutValue,self.maxRage-self:getCurrRage());
	if cutValue+self:getCurrRage()<0 then
		cutValue=-self:getCurrRage();
	end
	self.propertyManager:addIntValue(PropertyType.CURRENT_RAGE,cutValue);
end
function BaseBtlUnit:getLevel()
	return self.level;
end
function BaseBtlUnit:usePassiveSkill()
	for k,v in pairs(self.skillMap) do
		if v:getSkill().typyP == 4 then
			--print("UUU USE  PAS  Skill",v:getSkill().id)
			self.attackTarget = v:getSelectTarget();
			v:updataAttack();
		end
	end
end
function BaseBtlUnit:getSelectSkillTag()
	if self.standPoint == BattleConstants.STANDPOINT_P2 then
		return 3;
	else
		return self:getBattleField():getSelectSkillTag();
	end
end
function BaseBtlUnit:effectSkillAttack(skillId,level)
	local oldAtkTgt = self.attackTarget;
	local skillCfg = analysis("Jineng_Jineng",skillId);
	skillCfg.level = level;
	local skillManager = SkillAttackManager.new(self,skillCfg,true);
	table.insert(self.paSkillMap,skillManager);
	self.attackTarget = skillManager:getSelectTarget();
	skillManager:updataAttack();
	self.attackTarget = oldAtkTgt;
end
function BaseBtlUnit:hasEffectType(efType)
	return self.effectManager:hasEffectType(efType)
end
function BaseBtlUnit:getEffectByType(efType)
	return self.effectManager:getEffectByType(efType)
end
function BaseBtlUnit:hasEffect(efId)
	return self.effectManager:hasEffect(efId)
end
function BaseBtlUnit:onFrozen()
	if self:isDie() then return end
	self.battleIcon:onFrozen()
end
function BaseBtlUnit:getReturnState()
	if self.machineState:getCurrentState():getStateEnum() ~= StateEnum.BEATTACKED then
		self.returnState = self.machineState:getCurrentState():getStateEnum();
	end
	return self.returnState;
end
function BaseBtlUnit:beAttackAction(skillId,isPlay)
	if self.machineState:getCurrentState():getStateEnum() == StateEnum.PERSKILL 
		or self.machineState:getCurrentState():getStateEnum() == StateEnum.ATTACK
		or self.machineState:getCurrentState():getStateEnum() == StateEnum.DEAD
		or self.machineState:getCurrentState():getStateEnum() == StateEnum.FLYATTACK
		--or self.machineState:getCurrentState():getStateEnum() == StateEnum.FROZEN
	then
		return
	end
	if isPlay and self.actionManager:beAttackAction(skillId) then
		local skillCfg = SkillActionConfig.new(skillId);
		local beAcTime = skillCfg:getSkillBeAttackActionTime(self);
		self.machineState:switchState(StateEnum.BEATTACKED,beAcTime,self:getReturnState());
	end  
end
function BaseBtlUnit:onRestPos(x,y)
	self.moveManager:sendRestPosMessage(x,y);
end
function BaseBtlUnit:onRestMove()
	self.battleIcon:changeFaceDirect(self.standPoint == BattleConfig.Battle_StandPoint_2);
end