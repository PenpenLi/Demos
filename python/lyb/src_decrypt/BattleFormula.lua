-- 计算战场
BattleFormula = {};
-- 攻击时候取得攻击位置
-- 保证在左右120度的扇形区域内
-- battleUnit对象 target目标 skill技能相关
function BattleFormula:getTargetXYBybtlUnit(battleUnit, target)
	local offsetX;
	if battleUnit:getCoordinateX() < target:getCoordinateX() then
		offsetX = -200;
	else
		offsetX = 200;
	end
	return target:getCoordinateX()+offsetX,target:getCoordinateY()
end

function BattleFormula:stateBeAttack(battleUnit,targets,skillMgr)
	local hitMpm = {}
	for targetK,targetV in pairs(targets) do
		local mpm = BattleFormula:onBeAttack(skillMgr,battleUnit,targetV);
		table.insert(hitMpm,mpm)
	end
	return hitMpm
end
function BattleFormula:onBeAttack(skillMgr,battleUnit,targetV)
	local mpm = {};
	mpm.TargetBattleUnitId = targetV:getObjectId();
	mpm.AttackResult = 0;--TODU 闪避 暴击类型
	mpm.CurrentHP = targetV:getCurrHp();
	mpm.hurtEffectArray = BattleFormula:triggerSkillEffect(skillMgr,targetV);
	return mpm
end
function BattleFormula:triggerSkillEffect(skillMgr,target)
	local effArr = {};
	for semk,semv in pairs(skillMgr:getSkillConfig():getTargetSkillEffects()) do
		local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- target:getBattleField():addRandomValue(randomValue);
		if randomValue <= tonumber(semv.rate) then
			table.insert(effArr,semv:getEffectId()); 
		end
	end
	return effArr;
end


--进攻暴击=进攻方暴击-防守方韧性
function BattleFormula:getAttackCrit(source,target)
	-- local attackCirt = source:getCrit() - target:getTenacity();
	-- attackCirt = math.max(attackCirt, 1);
	-- local maxAttackCirt = analysis("Xishuhuizong_Xishubiao",7,"constant")
	-- attackCirt = math.min(maxAttackCirt, attackCirt);
	return attackCirt;
end

function BattleFormula:getAttackSkill()
	--return analysis("Xishuhuizong_Xishubiao",6,"constant")
end
 -- * 攻击结果 判定攻击方行为，从攻击方【进攻技能攻击+进攻暴击】中随机【随机数2】 若【随机数2】<【进攻技能攻击】 判定进攻方是普通技能攻击；
	--  * 若【随机数2】<【进攻技能攻击+进攻暴击】 判定进攻方是暴击；
function BattleFormula:attackResult(skillResult)
	local value1 = self:getAttackSkill();--进攻技能攻击
	local value2 = self:getAttackCrit(skillResult:getSource(), skillResult:getTarget());
	local randomValue = math.random()*(value2 + value1-1)+1
	if randomValue <= value1 then
		return BattleConstants.BATTLE_ATTACK_RESULT_TYPE_4;
	end
	return BattleConstants.BATTLE_ATTACK_RESULT_TYPE_5;
end

function BattleFormula:getGaiLv(source, target)
	local maxLevel = math.abs(source:getLevel() - target:getLevel())
	local leiXing = source:getLevel() >= target:getLevel() and 1 or 2
	local mingzhongxishuTable = analysisTotalTable("Zhandoupeizhi_Mingzhongxishu")
	for key,PO in pairs(mingzhongxishuTable) do
		if PO.leiXing == leiXing and maxLevel <= PO.max and maxLevel >= PO.min then
			return PO.gaiLv
		end
	end
end

-- 是否触发心法(暴击)
function BattleFormula:_calcAttackType(source, target)
	-- 命中，闪避
	--// 命中率=基础命中+命中加成-闪避
	local hit = self:getGaiLv(source, target) + source:getPropertyValue(PropertyType.HIT);
	local hitAddition = 0;
	local dodge = target:getPropertyValue(PropertyType.DODGE);
	local hitRate = hit + hitAddition - dodge;
	local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
	-- source:getBattleField():addRandomValue(randomValue);
	if randomValue <= hitRate then
		return BattleConstants.BATTLE_ATTACK_RESULT_TYPE_2;
	end
	-- 会心几率+（会心等级-目标会心抵抗等级*0.75）/[（会心等级-目标会心抵抗等级*0.75）*1.4+30*卡牌/英雄等级+480）]
	local baojiRate = source:getPropertyValue(PropertyType.BAOJI_ATTACK_PER);
	local baojiLevel = source:getPropertyValue(PropertyType.BAOJI_ATTACK_LEVEL);
	local targetBaojiDefLevel = target:getPropertyValue(PropertyType.BAOJI_DEFENSE_LEVEL);
	local value1 = baojiLevel - targetBaojiDefLevel*0.75;
	local value2 = value1*1.4;
	local value3 = 30*source:getLevel()+480;
	local rate = math.floor(baojiRate+value1/(value2+value3));
	local randomValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
	-- source:getBattleField():addRandomValue(randomValue);
	if randomValue<=rate then
		return BattleConstants.BATTLE_ATTACK_RESULT_TYPE_1;
	end
	return BattleConstants.BATTLE_ATTACK_RESULT_TYPE_0;
end

-- function BattleFormula:lua_math_round(number)
--     local num = math.floor(math.abs(number*100000)+0.5)/100000
--     return number >= 0 and num or -num
-- end

-- /**
-- 	 * 
-- 	 * MAX(1-MAX((max(总攻击*职业攻击系数-总防御*0.8*职业防御系数,0.05*总攻击)*技能百分比+技能伤害数值)/被击方血量-1,
-- 	 * 0)*0.2^1.3,0.5)
-- 	 * 
-- 	 * @param castResult
-- 	 * @return
-- 	 */
-- function BattleFormula:_calcAttackExactXishu(attack,defense,initValue,wjskillHurtPervenValue,castSkillResult) 
-- 		local maxValue = math.floor(math.max(attack * castSkillResult:getSource():getCareerAttackParam()-defense*80000*castSkillResult:getTarget():getCareerDefenceParam()/100000, 5000*attack)/100000);
-- 		-------
-- 		BattleUtils:writelog("maxValue="..maxValue);
-- 		local tempValue = math.floor(maxValue*wjskillHurtPervenValue/100000);
-- 		BattleUtils:writelog("tempValue1="..tempValue);
-- 		tempValue = tempValue+initValue;
-- 		BattleUtils:writelog("tempValue2="..tempValue);
-- 		local divMaxHpValue = math.floor((tempValue/castSkillResult:getTarget():getMaxHP()-1)*100000);
-- 		BattleUtils:writelog("divMaxHpValue="..divMaxHpValue);
-- 		tempValue = math.max(divMaxHpValue, 0);
-- 		BattleUtils:writelog("tempValue3="..tempValue);
-- 		tempValue = 100000 - math.floor(math.pow(tempValue*20000/(100000*100000), 1.3)*100000);
-- 		BattleUtils:writelog("tempValue4="..tempValue);
-- 		tempValue =  math.max(tempValue, 50000);
-- 		BattleUtils:writelog("tempValue5="..tempValue);
-- 		return tempValue;
-- end


-- function BattleFormula:getHurtDriftXishu(source)
-- 	local xishu = 100000;
-- 	if source:getType() == BattleConstants.BATTLE_UNIT_TYPE_1 then
-- 		--TODO 读表随机
-- 		local config = analysis("Zhandouxishu_Xishubiao",source:getCarrer())
-- 		BattleUtils:writelog("lowerLimit"..config.lowerLimit*BattleConstants.HUNDRED_THOUSAND)
-- 		BattleUtils:writelog("lowerLimit"..config.upperLimit*BattleConstants.HUNDRED_THOUSAND)
-- 		BattleUtils:writelog("finalvalue="..value)
-- 		return value;
-- 	end
-- 	return xishu;
-- end

--附加属性
-- function BattleFormula:extPropertyGrow(level,baseProperty,growValue)
-- 	return math.floor(baseProperty + (level - 1) * growValue);
-- end

-- 防御系数=min(max((0.8+max(攻击方总攻击/(防御方总防御+1)-2,0)*0.2)^1.2,0.8),5)
-- function BattleFormula:getDefenseXishu(castResult)
-- 	return math.min(math.max((0.8+math.max(castResult.source:getTotalAttack()/(castResult.target:getTotalDefense()+1)-2,0)*0.2)^1.2,0.8),5)
-- end
--吸血效果 = （吸血值 + 治疗 / m1）* [ 1 +（击中数量 – 1） /（击中数量 + m2）]
function BattleFormula:computeXiXue(source,hurtCount)
	local xixue = source:getTotalPropertyValue(PropertyType.XIXUE,PropertyType.XIXUE_PER);
	if not xixue or xixue<=0 then return 0 end;
	if not hurtCount or hurtCount<=0 then return 0 end;
	local sourceAdd = source:getPropertyValue(PropertyType.ZHILIAOZHI);
	local m1 = analysis("Xishuhuizong_Gongshicanshubiao", 20,"number")
	local m2 = analysis("Xishuhuizong_Gongshicanshubiao", 21,"number")
	local value = math.floor((xixue+sourceAdd/m1)*(1+(hurtCount-1)/(hurtCount+m2)))
	print("<><><><><><><>---->>",xixue,sourceAdd,hurtCount,value);
	return value;
end

function BattleFormula:computeHurt(source,target,effectModel)
	--local battlelog = "currentFrame="..source:getBattleField().currentFrame.."\n";
	local attackType = self:_calcAttackType(source, target);

	-- 闪避
	if(attackType == BattleConstants.BATTLE_ATTACK_RESULT_TYPE_2) then
		return 0;
	end

	local attack = source:getTotalPropertyValue(PropertyType.ATTACK, PropertyType.ATTACK_PER);
	local defense = target:getDefense();

	local hurt = attack - defense;
	if(hurt < math.ceil(attack*10000/100000)) then
		hurt = math.ceil(attack*10000/100000);
	end

	--会心修正
	local baojiPer = 100000;
	if attackType == BattleConstants.BATTLE_ATTACK_RESULT_TYPE_1 then
		baojiPer = 150000 + source:getPropertyValue(PropertyType.BAOJI_HURT_ADDITION_PER) - target:getPropertyValue(PropertyType.BAOJI_HURT_REDUCE_PER);
	end
	hurt = math.ceil(hurt*baojiPer/100000);

	-- 伤害加成(1+伤害增加-承受伤害减少)
	local hurtAdditionPer = 100000+source:getPropertyValue(PropertyType.HURT_ADDITION_PER) - target:getPropertyValue(PropertyType.HURT_REDUCE_PER);
	hurt = math.ceil(hurt*hurtAdditionPer/100000);
	--// 检查技能小狗(嘲讽等效果会影响伤害值)
	--hurt = target:checkSkillEffectAddition(castSkillResult);
	return hurt;
end

function BattleFormula:computeHurt3(castSkillResult,currTimes)
	local source = castSkillResult:getSource();
	local target = castSkillResult:getTarget();
	local fskill = castSkillResult:getFightSkill();
	local battlelog = "currentFrame="..source:getBattleField().currentFrame.."\n";
	local attackResultType = self:_calcAttackType(source, target);
	battlelog = battlelog.."source="..source:getObjectId().." target="..target:getObjectId().." skillId="..fskill.skillId.." currTimes="..currTimes.."\n"
	
	-- /*** 最终技能伤害=（技能攻击-目标防御） *会心修正*(1+伤害增加-承受伤害减少)*五行克制系数 ****/

	-- /** 技能攻击=攻击*技能加成系数+技能附加伤害 **/
	-- // 攻击
	local attack = source:getTotalPropertyValue(PropertyType.ATTACK, PropertyType.ATTACK_PER);
	-- // 攻击*技能加成系数
	local tempAttack = math.ceil(attack*fskill:getAdditionParam()/100000);
	local attackAddition = tempAttack+fskill:getAdditionHurt();

	battlelog = battlelog.."tempAttack="..tempAttack.." attack="..attack.." additionParam="..fskill:getAdditionParam().." additionHurt="..fskill:getAdditionHurt().." fskillLevel="..fskill:getLevel().."\n";
	-- 目标防御(内功防御或者外功防御)
	local defense = target:getTotalPropertyValue(PropertyType.WAI_DEFENSE, PropertyType.WAI_DEFENSE_PER);

	--/** 会心修正(暴击) **/
	local baoji = 100000;
	if attackResultType == BattleConstants.BATTLE_ATTACK_RESULT_TYPE_1 then
		baoji = 150000 + source:getPropertyValue(PropertyType.BAOJI_HURT_ADDITION_PER) - target:getPropertyValue(PropertyType.BAOJI_HURT_REDUCE_PER);
	end
	battlelog = battlelog.."baoji="..baoji.." attackResultType="..attackResultType.."\n";

	-- /** (1+伤害增加-承受伤害减少) **/
	local hurtAdditionPer = 100000 + source:getPropertyValue(PropertyType.HURT_ADDITION_PER) - target:getPropertyValue(PropertyType.HURT_REDUCE_PER);

	-- // 技能攻击加成-目标防御
	local hurt = math.max(1,attackAddition - defense);
	battlelog = battlelog.."hurt1="..hurt.. " defense="..defense.."\n";
	-- hurt*会心修正*（1-目标角色装备元素防-目标角色元素防）*(1+伤害增加-承受伤害减少)*缘分增加
	hurt = math.ceil(hurt*baoji/100000);
	battlelog = battlelog.."hurt2="..hurt.. " baoji="..baoji.."\n";

	hurt = math.ceil(hurt * hurtAdditionPer/100000);
	battlelog = battlelog.."hurt3="..hurt.." hurtAdditionPer="..hurtAdditionPer.."\n";

	--print(battlelog);
	--print("***********hurt****over***************");
	-- local wuxingAdditionPer = 0;
	-- if self:isKeWuXing(source:getWuXing(),target:getWuXing()) then
	-- 	wuxingAdditionPer = source:getBattleField().battleProxy:getXiShuByWuXing(source:getWuXing());
	-- 	hurt = math.ceil(wuxingAdditionPer*hurt/100000)
	-- 	castSkillResult:setKeWuXing(source:getWuXing())
	-- else
	-- 	castSkillResult:setKeWuXing(nil)
	-- end
	local wuxingAdditionPer = 0--self:_calcWuxingAdditionPer(castSkillResult,source, target);

	battlelog = battlelog.."hurt4="..hurt.." wuxiang wuxingAdditionPer="..wuxingAdditionPer.."\n";
	

	if self:isMonsterToTeamHurt(source,target) then
		local playUnitNum = target:getBattleTeam():getPlayUnitNum();
		local deadUnitNum = target:getBattleTeam():getDeadUnitNum();
		hurt = hurt + math.ceil(playUnitNum*target:getMaxHP()*0.04 + deadUnitNum*target:getMaxHP()*0.01)
	end
	local totalLen = #skillMgr:getActionConfig():getBeijiyanchiArr()

	battlelog = battlelog.."totalLen=" .. totalLen.." currTimes=" .. currTimes.."\n";

	if totalLen > 1 then--三段击伤害
		if currTimes == totalLen then
			hurt = math.ceil((hurt*0.9)/currTimes + hurt*0.1)
			--battlelog = battlelog.."hurt6="..hurt.." currTimes="..currTimes.." totalLen="..totalLen.."\n";
		else
			hurt = math.ceil((hurt*0.9)/currTimes)
			--battlelog = battlelog.."hurt7="..hurt.." currTimes="..currTimes.." totalLen="..totalLen.."\n";
		end
	end
	battlelog = battlelog.."hurt6=" .. hurt.."\n";

	

	hurt = hurt < attack/3.3 and math.ceil(attack/3.3) or hurt
    --战场类型伤害加成
	hurt = math.ceil(hurt*source:getBattleField():getHurtAdditionValue()/100000);
	battlelog = battlelog.."hurt7="..hurt.." hurtAdditionValue="..source:getBattleField():getHurtAdditionValue().."\n";
		-- 身上有嘲讽效果，伤害减少50%
	local effect80 = target.effectManager:getEffect(BattleConstants.SKILL_EFFECT_ID_80);
	if effect80 then
		hurt = math.ceil(hurt*(100000-effect80:getEffectValue())/100000);
	end
	hurt = math.ceil(hurt);
	battlelog = battlelog.."hurt8="..hurt;
	BattleUtils:writelog(battlelog);
	return hurt;
end

function BattleFormula:isMonsterToTeamHurt(source,target)
	local battleType = source:getBattleField().battleProxy.battleType
	local suppress = analysis("Zhandoupeizhi_Zhanchangleixing",battleType,"suppress")
	if suppress == 0 then return end
	if battleType ~= BattleConfig.BATTLE_TYPE_2 then
		if source:getType() ~= BattleConstants.BATTLE_UNIT_TYPE_3 then return end
	end
	if target:getLevel() >= 20 then
		return true
	end
end

function BattleFormula:isKeWuXing(sourceWuXing,targetWuXing)
	if sourceWuXing == 1 then
		return false
	elseif sourceWuXing == 2 then
		return targetWuXing == 3
	elseif sourceWuXing == 3 then
		return targetWuXing == 6
	elseif sourceWuXing == 4 then
		return targetWuXing == 5
	elseif sourceWuXing == 5 then
		return targetWuXing == 2
	elseif sourceWuXing == 6 then
		return targetWuXing == 4
	elseif sourceWuXing == 7 then
		return true
	end
end

function BattleFormula:_calcWuxingAdditionPer(castSkillResult, source,target)
	local wuxingAdditionPer = 100000;
	local config = analysis("Shuxing_Wuxing",source:getWuXing())
	if self:isKeZhi(config.keZhi,target:getWuXing()) then
		if source:getType() == BattleConstants.BATTLE_UNIT_TYPE_3 then
			wuxingAdditionPer = config.xiShu
		else
			wuxingAdditionPer = analysis("Jineng_Wuxingjinengkezhi",source:getWuxingLevel(),"XiaoGuo")
		end
		castSkillResult:setKeWuXing(source:getWuXing())
	else
		castSkillResult:setKeWuXing(nil)
	end
	return wuxingAdditionPer;
end

function BattleFormula:isKeZhi(keZhi,wuxing)
	local keZhiArr = StringUtils:lua_string_split(keZhi,",");
	for key,value in pairs(keZhiArr) do
		if wuxing == tonumber(value) then
			return true
		end
	end
end

function BattleFormula:computeHurt4(source, target, effectModel, hurtNum)
	-- 闪避/抵抗 - 穿透 - 伤害计算 - 暴击 - 阻挡 - 吸血
	local zudangReduceHurt = 0;
	if(self:checkDikang(target, effectModel, hutNum)) then
		return 0;
	end
	if effectModel:isWai() then
		local attack = source:getTotalPropertyValue(PropertyType.WAI_ATTACK,PropertyType.WAI_ATTACK_PER);
		local defense = target:getTotalPropertyValue(PropertyType.WAI_DEFENSE,PropertyType.WAI_DEFENSE_PER) - source:getPropertyValue(PropertyType.POFANG);
		local hurt = 0;
		if attack>=defense*1.5 then
			hurt = (attack*1.05 - defense*0.9)*(1.1/1.5)*attack/defense;
		else
			hurt = math.pow(attack, 3)/(math.pow(defense, 2)*0.1)
		end
		local zudang = target:getTotalPropertyValue(PropertyType.ZUDANG, PropertyType.ZUDANG_PER);
		local zudangRate = target:getPropertyValue(PropertyType.ZUDANG_RATE)+30000;
		local randomZudangValue = MathUtils:random(0, BattleConstants.HUNDRED_THOUSAND);
		-- source:getBattleField():addRandomValue(randomZudangValue);
		if randomZudangValue<=zudangRate then
			zudangReduceHurt = zudang;
		end
	else
		local attack = source:getTotalPropertyValue(PropertyType.NEI_ATTACK, PropertyType.NEI_ATTACK_PER);
		local defense = target:getTotalPropertyValue(PropertyType.NEI_DEFENSE, PropertyType.NEI_DEFENSE_PER);
		local jianshangRate = attack/(defense*1.4+30+target:getLevel()*4);
		hurt = (1-jianshangRate)*(attack+25)*attack/defense;
	end
	hurt = math.max(hurt, 1);

	--暴击
	local baojiValue = source:getTotalPropertyValue(PropertyType.BAOJI, PropertyType.BAOJI_PER);
	if self:checkBaoji(baojiValue) then
		local baojiJiacheng = 1+baojiValue*2/(baojiValue+1000);
		hurt = hurt * (1+baojiJiacheng);
	end
	--print(hurt.."----"..zudangReduceHurt.."|"..effectModel:getValue().."|"..effectModel:getPersent());
	--TODO 这个地方加成，怎么算
	hurt = hurt + effectModel:getValue();
	hurt = math.floor(hurt * effectModel:getPersent()/100000);
	--print(hurt..">>>>>>"..zudangReduceHurt);
	hurt = hurt - zudangReduceHurt;
	hurt = math.max(1,hurt);
	return hurt;
end

-- 1为闪避，2为伤害，3为暴击，4位暴击值，5为是否阻挡，6为阻挡的数值
function BattleFormula:computeWaigongHurt(source, target, effectModel, isChixu)
	-- 普通攻击 才有闪避
	local shanbi = target:getTotalPropertyValue(PropertyType.SHANBI, PropertyType.SHANBI_PER);
	local isShanbi = (analysis("Jineng_Jineng", effectModel:getSkillId()).typyP == BattleConstants.SKILL_TYPE_1) and self:checkShanbi(shanbi);
	if (isShanbi) then
		return 1,0;
	end
	-- 计算攻防属性,代入穿透
	local attack = source:getTotalPropertyValue(PropertyType.WAI_ATTACK, PropertyType.WAI_ATTACK_PER);
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong attack=".. attack);
	local defense = target:getTotalPropertyValue(PropertyType.WAI_DEFENSE, PropertyType.WAI_DEFENSE_PER);
	local pofang = source:getPropertyValue(PropertyType.POFANG);
	-- 基础伤害计算
	local hurt = BattleFormula:computeWaigongBaseHurt(attack, defense, pofang);
	-- 暴击
	local isBaoji;
	if (not isChixu) then
		local baoji = source:getPropertyValue(PropertyType.BAOJI);
		isBaoji = BattleFormula:checkBaoji(source, baoji);
		hurt = BattleFormula:computeBaojiHurt(hurt, baoji, isBaoji);
	end
	-- 技能最终伤害 = [（基础伤害 + 数值加成） * 百分比加成 – 阻挡 + 易伤数值加成 ] * （1 + 易伤百分比加成）
	-- 阻挡前伤害计算
	local shuzhiJiacheng = effectModel:getSkillEffectConfig().chuShiFuJiaGongJi + effectModel:getSkillEffectConfig().chengZhangFuJiaGongJi * (effectModel:getSkillLevel() - 1) + source:getPropertyValue(PropertyType.SHUZHI_JIACHENG) + target:getPropertyValue(PropertyType.SHUZHI_JIACHENG);
	local baifenbiJiacheng = effectModel:getSkillEffectConfig().chuShiJiaChen + effectModel:getSkillEffectConfig().jiaChenZenJia * (effectModel:getSkillLevel() - 1) + source:getPropertyValue(PropertyType.BAIFENBI_JIACHENG) + target:getPropertyValue(PropertyType.BAIFENBI_JIACHENG);
	hurt = (hurt + shuzhiJiacheng) * (baifenbiJiacheng / BattleConstants.HUNDRED_THOUSAND);
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong zudangqian hurt=".. hurt);
	-- 计算阻挡
	local isZudang;
	if (not isChixu) then
		local zudang = target:getTotalPropertyValue(PropertyType.ZUDANG, PropertyType.ZUDANG_PER);
		isZudang = BattleFormula:checkZudang(zudang);
		hurt, zudangReduceHurt = BattleFormula:computeZudang(hurt, zudang, isZudang);
	end
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong yishang qian hurt=".. hurt);
	-- 易伤数值加成和易伤百分比加成
	local yishangshuzhijiacheng = source:getPropertyValue(PropertyType.YISHANG_SHUZHI_JIACHENG) + target:getPropertyValue(PropertyType.YISHANG_SHUZHI_JIACHENG);
    local yishangbaifenbijiacheng = source:getPropertyValue(PropertyType.YISHANG_BAIFENBI_JIACHENG) + target:getPropertyValue(PropertyType.YISHANG_BAIFENBI_JIACHENG);
    hurt = (hurt + yishangshuzhijiacheng) * (1 + yishangbaifenbijiacheng / BattleConstants.HUNDRED_THOUSAND);
	hurt = math.floor(math.max(1, hurt));
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong final hurt=".. hurt);
	return false, hurt, isBaoji, isZudang;
end

-- 1为抵抗，2为伤害，3为暴击，4位暴击值，5为是否阻挡，6为阻挡的数值
function BattleFormula:computeNeigongHurt(source, target, effectModel, mingzhongNum, isChixu)
	local jinengType = analysis("Jineng_Jineng", effectModel:getSkillId()).typyP;
	local dikang = target:getTotalPropertyValue(PropertyType.DIKANG, PropertyType.DIKANG_PER);
	local isDikang = ((BattleConstants.SKILL_TYPE_2 == jinengType) or (BattleConstants.SKILL_TYPE_3 == jinengType)) and BattleFormula:checkDikang(dikang, mingzhongNum);
	if (isDikang) then
		return 2,0;
	end
	-- 计算攻防属性,代入穿透
	local attack = source:getTotalPropertyValue(PropertyType.NEI_ATTACK, PropertyType.NEI_ATTACK_PER);
	print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>neigong attack=".. attack);
	local defense = target:getTotalPropertyValue(PropertyType.NEI_DEFENSE, PropertyType.NEI_DEFENSE_PER);
	-- 基础伤害计算
	local pofang = source:getPropertyValue(PropertyType.POFANG);
	local hurt = BattleFormula:computeNeigongBaseHurt(attack, defense, target:getLevel(), pofang);
	-- 暴击
	local isBaoji;
	if (not isChixu) then
		local baoji = source:getPropertyValue(PropertyType.BAOJI);
		isBaoji = BattleFormula:checkBaoji(source, baoji);
		hurt = BattleFormula:computeBaojiHurt(hurt, baoji, isBaoji);
	end
	-- 技能最终伤害 = [（基础伤害 + 数值加成） * 百分比加成 – 阻挡 + 易伤数值加成 ] * （1 + 易伤百分比加成）
	-- 阻挡前伤害计算
	local shuzhiJiacheng = effectModel:getSkillEffectConfig().chuShiFuJiaGongJi + effectModel:getSkillEffectConfig().chengZhangFuJiaGongJi * (effectModel:getSkillLevel() - 1) + source:getPropertyValue(PropertyType.SHUZHI_JIACHENG) + target:getPropertyValue(PropertyType.SHUZHI_JIACHENG);
	local baifenbiJiacheng = effectModel:getSkillEffectConfig().chuShiJiaChen + effectModel:getSkillEffectConfig().jiaChenZenJia * (effectModel:getSkillLevel() - 1) + source:getPropertyValue(PropertyType.BAIFENBI_JIACHENG) + target:getPropertyValue(PropertyType.BAIFENBI_JIACHENG);
	hurt = (hurt + shuzhiJiacheng) * (baifenbiJiacheng / BattleConstants.HUNDRED_THOUSAND);
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>neigong zudangqian hurt=".. hurt);
	-- 计算阻挡
	local isZudang;
	if (not isChixu) then
		local zudang = target:getTotalPropertyValue(PropertyType.ZUDANG, PropertyType.ZUDANG_PER);
		isZudang = BattleFormula:checkZudang(zudang);
		hurt, zudangReduceHurt = BattleFormula:computeZudang(hurt, zudang, isZudang);
	end
	-- 易伤数值加成和易伤百分比加成
	local yishangshuzhijiacheng = source:getPropertyValue(PropertyType.YISHANG_SHUZHI_JIACHENG) + target:getPropertyValue(PropertyType.YISHANG_SHUZHI_JIACHENG);
    local yishangbaifenbijiacheng = source:getPropertyValue(PropertyType.YISHANG_BAIFENBI_JIACHENG) + target:getPropertyValue(PropertyType.YISHANG_BAIFENBI_JIACHENG);
    hurt = (hurt + yishangshuzhijiacheng) * (1 + yishangbaifenbijiacheng / BattleConstants.HUNDRED_THOUSAND);
	hurt = math.floor(math.max(1, hurt));
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>neigong final hurt=".. hurt);
	return false, hurt, isBaoji, isZudang;
end

function BattleFormula:computeWaigongBaseHurt(attack, defense, pofang)
	-- 外功攻击 >= 外功防御 * 破防系数
	-- 破防系数=150
	local pofangParam = analysis("Xishuhuizong_Gongshicanshubiao", 1).number;
	if (attack >= defense * pofangParam / 100) then
		-- [ 外攻 * m1 – max(1,（外防 – 穿透）) * m2 ] * m3 * 外攻 / 外防 / 100
		local m1 = analysis("Xishuhuizong_Gongshicanshubiao", 2).number;
		local m2 = analysis("Xishuhuizong_Gongshicanshubiao", 3).number;
		local m3 = analysis("Xishuhuizong_Gongshicanshubiao", 4).number / analysis("Xishuhuizong_Gongshicanshubiao", 5).number;
		--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong attack=".. attack..",defense="..defense..",m1="..m1..",m2="..m2..",m3="..m3);
		local hurt = (attack * m1 - math.max(1, (defense - pofang)) * m2) * m3 * attack / math.max(defense, 1) / 100;
		--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong hurt=".. hurt);
		-- 伤害的最小值取1
		return math.max(hurt, 1);
	else
		-- 基础伤害 = pow(外攻,3) / pow(外防,2) * n1 / 10
		local n1 = analysis("Xishuhuizong_Gongshicanshubiao", 6).number;
		--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong attack=".. attack..",defense="..defense..",n1="..n1);
		local hurt = math.pow(attack, 3) / math.pow(defense, 2) * n1 / 10;
		--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>waigong jiben hurt=".. hurt);
		-- 伤害的最小值取1
		return math.max(hurt, 1);
	end
end

function BattleFormula:computeNeigongBaseHurt(attack, defense, level, pofang)
	-- 内防减伤比 = max(1,（内防 – 穿透）) / [max(1,（内防 – 穿透）) * n1 + 3000 + Lv受 * n2 ] * 10000
	-- Lv受=受攻击方等级
	local n1 = analysis("Xishuhuizong_Gongshicanshubiao", 8).number;
	local n2 = analysis("Xishuhuizong_Gongshicanshubiao", 9).number;
	local jianshangRate = math.max(1, (defense - pofang)) / (math.max(1, (defense - pofang)) * n1 + 3000 + level * n2) * 10000;
	-- print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>neigong jianshangRate=".. jianshangRate);
	--（100 – 内防减伤比）* （内攻 * 100 + m1）* 内攻 / 内防 / 10000
	-- m1=25
	local m1 = analysis("Xishuhuizong_Gongshicanshubiao", 7).number;
	local hurt = (100 - jianshangRate) * (attack * 100 + m1) * attack / math.max(defense, 1) / 10000;
	--print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>neigong jiben hurt=".. hurt);
	-- 伤害的最小值取1
	return math.max(hurt, 1);
end

function BattleFormula:checkDikang(dikang, mingzhongNum)
	-- 抵抗率 = 抵抗 * m1 /（抵抗 + m2）*（击中数量 – 1）/（击中数量 + m3)
	-- m1=2,m2=800,m3=10,50%>=抵抗率>=0
		local m1 = analysis("Xishuhuizong_Gongshicanshubiao", 17).number;
		local m2 = analysis("Xishuhuizong_Gongshicanshubiao", 18).number;
		local m3 = analysis("Xishuhuizong_Gongshicanshubiao", 19).number;
		local dikangRate = dikang*m1/(dikang+m2)*(mingzhongNum - 1)/(mingzhongNum + m3);
		dikangRate = math.max(0,dikangRate);
		dikangRate = math.min(dikangRate, 0.5);
		return MathUtils:checkHappen(math.floor(dikangRate*BattleConstants.HUNDRED_THOUSAND));
end

function BattleFormula:checkBaoji(source, baoji)
	-- 暴击率 = 暴击 /（暴击 + m）* 100%
	-- m=500,80%>=暴击率>=5%
	local m = analysis("Xishuhuizong_Gongshicanshubiao", 11).number;
	local baojiRate = baoji /(baoji+m);
	baojiRate = math.min(0.8, math.max(0.05, baojiRate));
	return MathUtils:checkHappen(math.floor(BattleConstants.HUNDRED_THOUSAND * baojiRate + source:getPropertyValue(PropertyType.BAOJI_PER)));
end

function BattleFormula:computeBaojiHurt(hurt, baoji, isBaoji)
	-- 暴击伤害加成 = 100% + 暴击 * n1 / （暴击 + n2）* 100%
	-- n1=2,n2=1000
	if (isBaoji) then 
		local n1 = analysis("Xishuhuizong_Gongshicanshubiao", 12).number;
		local n2 = analysis("Xishuhuizong_Gongshicanshubiao", 13).number;
		local baojiJiacheng = 1 + baoji * n1 / (baoji + n2);
		return hurt * (1 + baojiJiacheng);
	end
	return hurt;
end

function BattleFormula:checkShanbi(shanbi)
	-- 闪避率 = 10% + 闪避 / （闪避 * m1 + m2）
		local m1 = analysis("Xishuhuizong_Gongshicanshubiao", 14).number;
		local m2 = analysis("Xishuhuizong_Gongshicanshubiao", 15).number;
		local shanbilv =  0.1 + shanbi/(shanbi*m1+m2);
		shanbilv = math.max(0,shanbilv);
		shanbilv = math.min(shanbilv, 0.3);
		return MathUtils:checkHappen(shanbilv*BattleConstants.HUNDRED_THOUSAND);
end

function BattleFormula:checkZudang(zudang)
	-- 若阻挡值 > 0，则触发概率恒定为m%，m = 30
	local m = analysis("Xishuhuizong_Gongshicanshubiao", 16).number;
	if (zudang > 0) then
		return MathUtils:checkHappen(m / 100 * BattleConstants.HUNDRED_THOUSAND);
	end
	return false;
end

function BattleFormula:computeZudang(hurt, zudang, isZudang)
	if (isZudang) then
		local zudangReduce = math.min(hurt, zudang);
		return hurt - zudangReduce, zudangReduce;
	end
	return hurt;
end