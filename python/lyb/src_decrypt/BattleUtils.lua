BattleUtils = {}

function BattleUtils:sendUpdateHRValue(target,changeHP,changeRage,skillId,sanBi,isBaoJi,isZhuDang)
	local mpm = {}
	mpm.BattleUnitID = target:getObjectId()
	mpm.ChangeValue = changeHP and changeHP or 0;
	mpm.ChangeValue1 = changeRage and changeRage or 0;
	mpm.SkillID = skillId
	mpm.SanBi = sanBi;
	mpm.isBaoJi = isBaoJi and 1 or 0;
	mpm.isZhuDang = isZhuDang and 1 or 0;
	mpm.SubType = 4;
	target:getBattleField().battleProxy:sendAIMessage(mpm)
end
function BattleUtils:getTruePos(postion)
	local pos = postion;
	if pos == 20 or pos == 10 or pos == 16 then 
		pos = 1 
	elseif pos == 11 or pos == 17 then
		pos = 2
	elseif pos == 12 then
		pos = 3
	elseif pos == 13 or pos == 18 then
		pos = 4
	elseif pos == 14 or pos == 19 then
		pos = 5
	elseif pos == 11 or pos == 17 then
		pos = 6
	end
	return pos;
end
function BattleUtils:checkHappen(value)
	return self:randomThousand() <= value;
end

function BattleUtils:randomThousand()
	return math.random()*BattleConstants.HUNDRED_THOUSAND
end

function BattleUtils:checkPassiveSkill(battleUnit,triggerId)
	for k1,skill in pairs(battleUnit:passiveSkillSet()) do
		local passiveSkilTable = analysis2key("Jineng_Beidongjineng","id",skill.skillId,"lv",skill.level)
		if psConfig and psConfig:getTriggerId() == triggerId then
			if not self.passiveSkillTriggerTable then
				self.passiveSkillTriggerTable = {};
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_0] = PassiveSkillTriggerZero.new();
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_1] = PassiveSkillTriggerOne.new();
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_2] = PassiveSkillTriggerTwo.new();
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_3] = PassiveSkillTriggerThree.new();
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_4] = PassiveSkillTriggerFour.new();
				self.passiveSkillTriggerTable[BattleConstants.BATTLE_PASSIVE_SKILL_TRIGGER_ID_5] = PassiveSkillTriggerFive.new();
			end
			self.passiveSkillTriggerTable[passiveSkilTable.cftj]:checkAndCreateEffect(battleUnit);
		end
	end
end

function BattleUtils:between(value1,value2,value3)
	if value3 >= value1 then
		if value3 <= value2 then
			return true;
		end
	end
	if value3 <= value1 then
		if value3 >= value2 then
			return true;
		end
	end
	return false;
end

function BattleUtils:randomArray(array)
	local tableT = {}
	for key,value in pairs(array) do
		table.insert(tableT,value)
	end
	local ran = math.random(1,table.getn(tableT));
	return tableT[ran]
end

function BattleUtils:getRandomArrayByNum(array,num)
	local copyArray = copyTable(array)
	local len;
	local tempArray = {}
	for i=1,num do
		copyArray = self:getSortArray(copyArray)
		len = table.getn(copyArray);
		local ran = math.random(1,len);
		table.insert(tempArray,copyArray[ran]) 
		copyArray[ran] = nil
	end
	return tempArray
end

function BattleUtils:getSortArray(array)
	local tempArray = {}
	for key,value in pairs(array) do
		table.insert(tempArray,value)
	end
	return tempArray
end

function BattleUtils:isWuShuangSkill(skillId)
	if skillId < BattleConstants.SKILLID_WUSHUAGN_MIN then
		return false;
	end
	if skillId > BattleConstants.SKILLID_WUSHUAGN_MAX then
		return false;
	end
	return true;
end

function BattleUtils:getDistance(targetX,targetY,currentX,currentY)
	-- if not targetX then return 10 end --temp临时用下
	local dx = targetX-currentX;
    local dy = targetY-currentY;
    return math.sqrt(math.pow(dx, 2)+math.pow(dy, 2));
end

function BattleUtils:getDistanceP(P1,P2)
	return self:getDistance(P1.x,P1.y,P2.x,P2.y)
end

function BattleUtils:isWuJiangSkill(skillId)
	if skillId < BattleConstants.SKILLID_WUJIANG_MIN then
		return false;
	end
	if skillId > BattleConstants.SKILLID_WUJIANG_MAX then
		return false;
	end
	return true;
end

function BattleUtils:getArrayLength(array)
	local tempArray = {}
	for key,value in pairs(array) do
		table.insert(tempArray,value)
	end
	return #tempArray;
end

function BattleUtils:getOSTime()
	--log("===============ostime01=="..CommonUtils:getOSTime()+900000000)
	--log("===============ostime02=="..CommonUtils:getOSTime())
	return tonumber(CommonUtils:getOSTime())
end

function BattleUtils:writelog(log)
	if not self.needDebug then return end
	table.insert(self.debugMessageArray,{ErrorMessage = log})
	-- local file = io.open('E:/battleLog.txt','a');
	-- file:write(log..'\n');
	-- file:close();
end

function BattleUtils:initDebugData(needDebug)
	self.needDebug = needDebug;
	if not needDebug then return end
	self.debugMessageArray = {}
end

function BattleUtils:clearDebug()
	self.needDebug = nil
	self.debugMessageArray = nil
	self.standPoint = nil
end

function BattleUtils:setDebugWinner(standPoint)
	self.standPoint = standPoint;
end

function BattleUtils:needDebugFun()
	return self.standPoint == 1
end

function BattleUtils:getPowerSecondNum(battleProxy)
	if battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then
		return 1
	end
	if not self.powerSecondNum then
		self.powerSecondNum = analysis("Xishuhuizong_Xishubiao",1066,"constant");
	end
	return self.powerSecondNum
end

function BattleUtils:getSiteYRandom()
	return math.random(1,10000000)/10000000
end

-- function BattleUtils:sendDebugMessage(battleId)
-- 	local function recordLoopTimer()
--         self:battle_Debug(battleId)
--     end
--     self.recordLoopTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(recordLoopTimer, 0, false)
-- end

-- function BattleUtils:battle_Debug(battleId)
-- 	local sendTable = {}
--     local length = 0;
--     for key,msg in pairs(self.debugMessageArray) do
--     	table.insert(sendTable,msg)
--     	self.debugMessageArray[key] = nil;
--     	length = length + 1
--     	if length >= 30 then
--     		break
--     	end
--     end
--     local message = {}
-- 	message.BattleId = battleId;
-- 	message.ErrorMessageArray = sendTable;
-- 	if BattleUtils:getArrayLength(self.debugMessageArray) == 0 then
-- 		message.ErrorMessageArray = {{ErrorMessage = "battle_end"}};
-- 		self:removeRecordLoopTimer()
-- 		self:clearDebug()
-- 	end
-- 	sendMessage(7,35,message)
-- end

function BattleUtils:removeRecordLoopTimer()
    if self.recordLoopTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.recordLoopTimer)
        self.recordLoopTimer = nil; 
    end
end

function BattleUtils:setIsBossMonster(generalVO,allMonstersTable,monsterArray)
	local guaiwubiao = analysis("Guaiwu_Guaiwubiao",generalVO.generalID);
    for k1,v1 in pairs(allMonstersTable) do
       if v1.monsterId == generalVO.generalID then
            if guaiwubiao.type == 3 or guaiwubiao.type == 4 then
                generalVO.isBoss = true;
            else
                monsterArray[generalVO.battleUnitID] = generalVO
            end
       end
    end
end

--怪物掉落
function BattleUtils:setMonsterDrop(battleProxy,allMonstersTable,monsterArray,round)
    local dropArray = {}
    for key,monsterPO in pairs(allMonstersTable) do
        if monsterPO.round == round then --表示波数
            local tempDropArr = StringUtils:lua_string_split(monsterPO.itemNum,";");
            for i=1,monsterPO.specialNum do
                if not dropArray[monsterPO.monsterId] then
                    dropArray[monsterPO.monsterId] = {}
                end
                table.insert(dropArray[monsterPO.monsterId],self:randomArray(tempDropArr))
            end
        end
    end
    local typeArray = {}
    for battleUnitID,generalVO in pairs(monsterArray) do
        if not typeArray[generalVO.generalID] then
            typeArray[generalVO.generalID] = {}
        end
        table.insert(typeArray[generalVO.generalID],generalVO)
    end
    for generalID,array in pairs(typeArray) do
    	if dropArray[generalID] then
	        local randomArray = self:getRandomArrayByNum(array,#dropArray[generalID])
	        for key,generalVO in pairs(randomArray) do
	            battleProxy.battleGeneralArray[generalVO.battleUnitID].dropItemId = dropArray[generalID][key]
	        end
        end
    end
end

function BattleUtils:paowuxianAnimation(icon,vx,vy,zl,backFun,downY) 
      local oldPy = downY or icon:getPositionY()
      local loopHandle;
      local function loopHandleF()
        vy = vy + zl;
        if not icon:getPositionX() then
            Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopHandle);
            return;
        end
        icon:setPositionX(icon:getPositionX() + vx);
        icon:setPositionY(icon:getPositionY() + vy);
        if icon:getPositionY() <= oldPy then
           Director:sharedDirector():getScheduler():unscheduleScriptEntry(loopHandle);
           if backFun then
           		backFun()
           end
        end
      end
      loopHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(loopHandleF, 0, false)
end

function BattleUtils:setGuideHecDCNumber(battleProxy)
	if not battleProxy.guideHecDCNumber then
		battleProxy.guideHecDCNumber = self:getGuideIDByBattleID(battleProxy)
	else
		battleProxy.guideHecDCNumber = battleProxy.guideHecDCNumber + 1
	end
end

function BattleUtils:getGuideHecDCNumber(battleProxy)
	return battleProxy.guideHecDCNumber
end

function BattleUtils:getHeroContion(battleProxy,generalID)
	if battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_4 then
		return "1,0",1
	else
		local VO = analysis("Zhandoupeizhi_Xinshouzhanchangyingxiong",generalID)
		return "3,"..VO.competion,VO.competion;
	end
end

function BattleUtils:getGuideIDByBattleID(battleProxy)
	local battleFieldId = battleProxy.battleFieldId
	if battleFieldId == 10001001 then
		return 200101
	elseif battleFieldId == 10002001 then
		return 200301
	elseif battleFieldId == 1 then
		return 100101
	end
end

function BattleUtils:getGuideStopTime(battleProxy)
	local guideStep = battleProxy.guideHecDCNumber
	if guideStep == 100101 then
		return 1
	elseif guideStep == 100102 then
		return 1
	elseif guideStep == 100103 then
		return 2.5
	elseif guideStep == 100104 then
		return 3
	elseif guideStep == 100105 then
		return 3.5
	elseif guideStep == 200101 then
		return 1
	elseif guideStep == 200102 then
		return 3
	elseif guideStep == 200301 then
		return 0
	elseif guideStep == 200302 then
		return 0
	end
end

function BattleUtils:getBeattackDataTable(length,beAttackTable,currTimes)
	local isNeedCheckDead = nil
	if length == 1 then
		isNeedCheckDead = true
	elseif length == 2 then
		if currTimes == 1 then
			for key,value in pairs(beAttackTable) do
				if key ~= "b1" then
					beAttackTable[key] = nil
				end
			end
		else
			beAttackTable["b1"] = nil
			isNeedCheckDead = true
		end
	elseif length == 3 then
		if currTimes == 1 then
			for key,value in pairs(beAttackTable) do
				if key ~= "b1" then
					beAttackTable[key] = nil
				end
			end
		elseif currTimes == 2 then
			for key,value in pairs(beAttackTable) do
				if key ~= "b2" then
					beAttackTable[key] = nil
				end
			end
		elseif currTimes == 3 then
			beAttackTable["b1"] = nil
			beAttackTable["b2"] = nil
			isNeedCheckDead = true
		end
	end
	return beAttackTable,isNeedCheckDead
end

function BattleUtils:blackScreenFadeInOut(fadeInOver)
	local blackScreen = LayerColorBackGround:getBackGround()
	blackScreen:setScale(2)
	blackScreen:setAlpha(0)
	blackScreen:setPositionY(-GameData.uiOffsetY)
	sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):addChild(blackScreen);
	local function complete()
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_SHIFT_SCENE):removeChild(blackScreen);
		blackScreen = nil
	end
	local function fadeBack()
		local mapBatchLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP).mapBatchLayer
		mapBatchLayer:setPositionX(GameConfig.STAGE_WIDTH)
		mapBatchLayer:setScaleX(-1)
		fadeInOver()
	end
	local array = CCArray:create();
	array:addObject(CCDelayTime:create(1.5))
	array:addObject(CCFadeTo:create(0.6,255))
	array:addObject(CCCallFunc:create(fadeBack))
	array:addObject(CCDelayTime:create(0.7))
	array:addObject(CCFadeTo:create(1,0))
	array:addObject(CCCallFunc:create(complete))
	blackScreen:runAction(CCSequence:create(array));
end

function getPositionArray(standPlace,skillSDJfanW,standPoint,geziTexiaoYanchi)
    if geziTexiaoYanchi == "" or geziTexiaoYanchi == "#" then--说明只有一个格子播特效
      return getStandPoint(standPlace,standPoint)
    end
    local tempArray = {}
    if skillSDJfanW == BattleConfig.SkillSDJfanW1 then
      table.insert(tempArray,getStandPoint(standPlace,standPoint))
    elseif skillSDJfanW == BattleConfig.SkillSDJfanW2 then
      for i=1,3 do
        local place = math.ceil(standPlace/3) * 3-(3-i)
        table.insert(tempArray,getStandPoint(place,standPoint))
      end
    elseif skillSDJfanW == BattleConfig.SkillSDJfanW3 then
      for i=1,3 do
        local number = standPlace%3
        number = number ~= 0 and number or 3
        local place = number + 3*(i-1)
        table.insert(tempArray,getStandPoint(place,standPoint))
      end
    elseif skillSDJfanW == BattleConfig.SkillSDJfanW4 then
      for i=1,9 do
        table.insert(tempArray,getStandPoint(i,standPoint))
      end
    elseif skillSDJfanW == BattleConfig.SkillSDJfanW5 then
      table.insert(tempArray,getStandPoint(5,standPoint))
    end
    return tempArray
end

function getStandPoint(standPlace,standPoint)
  if standPoint == 1 then
    return Battle_Pos_L[standPlace]
  else
    return Battle_Pos_R[standPlace]
  end
end

function BattleUtils:playEffectYinxiao(eId)
	if analysisHas("Yinxiao_Jinengyinxiaoduiyingbiao",eId) then
        local musicId = analysis("Yinxiao_Jinengyinxiaoduiyingbiao",eId,"dymusicID")
        MusicUtils:playEffect(musicId,false)
    end
end