require "main.view.battleScene.core.PlaySkill"
AIEngin = class();

function AIEngin:ctor()
	self.class = AIEngin;
	self.battleProxy = nil;
	self.bloodTime = 250
end

function AIEngin:removeSelf()
	self.class = nil;
end

function AIEngin:dispose()
	self.battleProxy = nil;
	if self.playSkill then
		self.playSkill:dispose()
		self.playSkill = nil
	end
	if self.roleMove then
		self.roleMove:dispose()
		self.roleMove = nil
	end
	self:removeSelf();
end

function AIEngin:initData(roleVO)

  self.battleProxy = roleVO:getBattleProxy();
  self.skeleton = self.battleProxy:getSkeleton()
  self.playSkill = PlaySkill.new();
  self.playSkill:initData(self,roleVO.battleUnitID)
  self.roleVO = roleVO;
end

-----------------
--攻击
-----------------
function AIEngin:attackAction()
	self.roleVO.battleIcon:setPositionXY(self.roleVO.coordinateX,self.roleVO.coordinateY,true)
	local faceDirect = self.roleVO.standPoint == BattleConfig.Battle_StandPoint_2
    self.roleVO.battleIcon:changeFaceDirect(faceDirect);
    local jinengPO = analysis("Jineng_Jineng",self.roleVO.attackSkillId)
    local realKey = "key".. jinengPO.editorid
	-- if self.roleMove then
	-- 	self.roleMove:removeWalkTimer()
	-- end
    local skillTable = BattleData.attackSkillArray[realKey]
	-- local attackTable = {}
	-- for k,v in pairs(skillTable) do
 --      if(k == "a1"
 --      or k == "a2"
 --      or k == "a3"
 --      or k == "a4"
 --      or k == "a5"
	--   or k == "a6"
	--   or k == "a7"
	--   or k == "a8"
	--   or k == "a9"
	--   or k == "a10") then
 --        attackTable[k] = v
 --      end
	-- end	  
	local function attackActionBack()
	    self.roleVO.battleIcon:setActionScale(1);
		self.roleVO.battleIcon:playAndLoop(BattleConfig.HOLD)
	end
	self.playSkill:playAttack(skillTable,attackActionBack,faceDirect,jinengPO.typyP)
	self:quanpingEffectHandler(realKey,faceDirect,jinengPO.typyP)
end

function AIEngin:quanpingEffectHandler(realKey,faceDirect,typyP)
	local skillTable = BattleData.screenSkillArray[realKey]
    if skillTable["quanpingEffect"] and skillTable["quanpingEffect"] ~= "#" then
        self.playSkill:quanpingEffectHandler(skillTable,faceDirect,self.roleVO,typyP)
    end
    local geziTexiaoID = skillTable["geziTexiaoID"]
	if geziTexiaoID ~= nil and geziTexiaoID ~= "#" then
		local standPoint = self.roleVO:getTarget().standPoint
		local positionArray = getPositionArray(self.roleVO:getTarget().standPosition,skillTable["attackShape"],standPoint,skillTable["geziTexiaoYanchi"])
		local dataTable = {}
		dataTable["effectID"] = skillTable["geziTexiaoID"]
		dataTable["effectX"] = skillTable["geziTexiaoX"]
		dataTable["effectY"] = skillTable["geziTexiaoY"]
		dataTable["effectDelayTime"] = skillTable["geziTexiaoYanchi"]
		dataTable["effectScale"] = skillTable["geziTexiaoSuofang"]
		dataTable["texiaoYanchi"] = skillTable["gzTexiaoYanchi"]
		self.playSkill:geziAction(dataTable,positionArray,standPoint)
	end
end
----------------
--被攻击
----------------
function AIEngin:beAttackAction(skillId)
	local faceDirect = self.roleVO.standPoint == BattleConfig.Battle_StandPoint_2
	local realKey = getAnalysisSkillRealKey(skillId)
    if not realKey then return end
    local screenTable = BattleData.screenSkillArray[realKey]
    if not screenTable then return end
    local skillTable = BattleData.beAttackSkillArray[realKey]
	local hurtCount = 0
	local beAttackTable = {}
	local isForceDead = true
	local forceHurtCount = 0
	-- for k,v in pairs(skillTable) do
	-- 	if(k == "b1"
	-- 	or k == "b2"
	-- 	or k == "b3"
	-- 	or k == "b4"
	-- 	or k == "b5"
	-- 	or k == "b6"
	-- 	or k == "b7"
	-- 	or k == "b8"
	-- 	or k == "b9"
	-- 	or k == "b10") then
	-- 		beAttackTable[k] = v
	-- 	end
	-- end
	local delayBeattackTimeArr = StringUtils:lua_string_split(screenTable.beijiyanchi,"?")
	-- local beAttackTableTemp,isNeedCheckDead = self:getBeattackDataTable(#delayBeattackTimeArr,copyTable(skillTable),self.roleVO.beAttackActionId)    
	local function beAttackActionBack()
		Director.sharedDirector():getScheduler():setTimeScale(1)		
		-- 动作播完后去发憋着的命令
		if self.roleVO:getCurrHp() > 0 then
			self.roleVO.battleIcon:playAndLoop(1)
		end	
	end
	self.playSkill:setIsForceDead(isForceDead,isNeedCheckDead)
	self.playSkill:setBeAttackPaowuxian(screenTable.paowuxian)
	self.playSkill:playAttack(skillTable,beAttackActionBack,not faceDirect,true)
	return true;
end
--------------------
--效果
--------------------
function AIEngin:addEffectAction()
    self.roleVO.battleIcon:bodyToColor(self.roleVO);
    self.roleVO.battleIcon:addSkillEffect(self.roleVO);
    self.roleVO.battleIcon:refreshBuffer(self.roleVO);
end

function AIEngin:removeEffectAction()
      self.roleVO.battleIcon:removeColor();
      self.roleVO.battleIcon:removeSkillEffect();
      self:addEffectAction(self.roleVO);
end

------------------
--移动
------------------
function AIEngin:movingAction()
	self.roleVO.battleIcon:removeTweenlite();
	if self.roleVO.battleIcon.actionId ~= BattleConfig.RUN then 
		self.roleVO.battleIcon:playAndLoop(BattleConfig.RUN);	
	end
	self:heroRoleMove()
end

function AIEngin:heroRoleMove()
	if not self.roleMove then
		require "main.view.battleScene.function.RoleMove"
		self.roleMove = RoleMove.new()
		self.roleMove:initData(self.roleVO)
	end
	self.roleMove:startMove()
	self.roleVO.battleIcon:changeFaceDirect(self.roleVO.moveFaceDirect);
end
function AIEngin:isOnMove()
	if self.roleMove and self.roleMove:positionMove() then
		return true;
	else
		return false;
	end
end

-------------------------
--角色坐标修正，直截跳转到目标点
-------------------------
function AIEngin:modifyAction()
	self.roleVO.battleIcon:removeTweenlite();
	self.roleVO.battleIcon:setPositionXY(self.roleVO.coordinateX,self.roleVO.coordinateY,true)
	self.roleVO.battleIcon:changeFaceDirect(self.roleVO.standPoint == BattleConfig.Battle_StandPoint_2)
	self.roleVO.battleIcon:playAndLoop(BattleConfig.HOLD)
end

function AIEngin:playDeadAnimation()
	local function deadBack()
		self.roleVO:switchDead()
	end
	self.roleVO.battleIcon:setBeadVisible(false)
	local faceDirect = self.roleVO.standPoint == BattleConfig.Battle_StandPoint_2
	self.roleVO.battleIcon:playDeadAnimation(self,faceDirect,deadBack)
end

function AIEngin:refreshDropDaoju(dropDaojuArray,position)
	self.roleVO:getBattleField().battleSceneMediator:refreshDropDaoju(dropDaojuArray,position)
end

-------------
--显示加减血量数字
--掉血飘字，有三种来源，1被击动作时掉血，2被击不播动作时掉血，3BUFF直截掉血
-------------
function AIEngin:changeHPAction(skillId)
	local number = self.roleVO.changeValue > 0 and "+"..self.roleVO.changeValue or self.roleVO.changeValue
	if skillId then
		local delayTimeArray,beAttackActionMap,typyP = self:getDelayTimeArray(skillId)
		local tTimes = #delayTimeArray;
		local average = math.floor(number/tTimes)
		local yu = number%tTimes
		local beTotalTime = self:getBeattackTotalTime(beAttackActionMap)
		if #delayTimeArray ~= 0 then
			for key,delayTime in pairs(delayTimeArray) do
				if key ~= #delayTimeArray then
					self:playBloodTimer(delayTime,average)
				else
					self:playBloodTimer(delayTime,average+yu)
				end
			end
		else
			self:playBloodTimer(self.bloodTime,number)
		end
		if typyP ~= 3 then
			self:playDeadTimer(beTotalTime)
		end
	else
		self:playBloodTimer(self.bloodTime,number)
		self:playDeadTimer(self.bloodTime)
	end
	
end

function AIEngin:getBeattackTotalTime(beAttackActionMap)
	if #beAttackActionMap == 0 then return self.bloodTime end
	if not self.skillActionConfig then
		self.skillActionConfig = SkillActionConfig.new()
	end
	self.skillActionConfig:setBeAttackActionMap(beAttackActionMap)
	return self.skillActionConfig:getSkillBeAttackActionTime(self.roleVO)
end

function AIEngin:isPlayDead()
	return self.roleVO:getCurrHp() <= 0
end

function AIEngin:playBloodTimer(delayTime,number,playDead)
	local deleyBlood;
	local function deleyBloodFun()
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(deleyBlood)  
		self:initTextAnimate(number,playDead)
	end
    deleyBlood = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyBloodFun, delayTime/1000, false)
end

function AIEngin:playDeadTimer(delayTime)
	if not self:isPlayDead() then return end
	local deleyDead;
	local function deleyDeadFun()
		Director:sharedDirector():getScheduler():unscheduleScriptEntry(deleyDead)
		self:playDeadAnimation()
	end
    deleyDead = Director:sharedDirector():getScheduler():scheduleScriptFunc(deleyDeadFun, delayTime/1000, false)
end

function AIEngin:playDeadBigAttack()
	if not self:isPlayDead() then return end
	self:playDeadAnimation()
end

function AIEngin:getDelayTimeArray(skillId)
	local realKey,duang,typyP = getAnalysisSkillRealKey(skillId)
    if not realKey then return {},{},nil end
    local skillTable = BattleData.beAttackSkillArray[realKey]
    if not skillTable then return {},{},typyP end
    local delayTimeArray = {}
    local lastTime = 0
    local beAttackActionMap = {}
	for key,beData in pairs(skillTable) do
		local actionTime = self.roleVO:getActionTotalTime(beData.attackActionID);
		local delay = self:getDeley(beData.effectDelayTime);
		if beData.isAttack == 1 then
			local beijiyanchi = lastTime + delay
			table.insert(delayTimeArray,beijiyanchi)
		end
		lastTime = lastTime + actionTime
		beAttackActionMap[beData.id] = beData;
	end
	return delayTimeArray,beAttackActionMap,typyP
end

function AIEngin:getDeley(effectDelayTime)
	if effectDelayTime == "#" then return self.bloodTime end--250按要求写死
	local delay = tonumber(StringUtils:lua_string_split(effectDelayTime,"?")[1]);
	return delay or self.bloodTime
end

function AIEngin:initTextAnimate(numberStr)
	if not self.roleVO.battleIcon.list then return end
    local textAnimate = TextAnimateUpAndUp.new();
    textAnimate:initLayer();
    local direction = self.roleVO.standPoint == BattleConfig.Battle_StandPoint_1 and "left" or "right";
    textAnimate:textAnimation(numberStr,direction,self.skeleton);
    local height = self.roleVO.battleIcon:getNameTextHeight()>180 and 180 or self.roleVO.battleIcon.nameTextHeight
    textAnimate:setPositionXY(0,height-40);
    self.roleVO.battleIcon:addChildAt(textAnimate,1000);
    self.roleVO.battleIcon.bloodProgressBar:refreshBarData(self.roleVO:getCurrHp()/self.roleVO:getMaxHP())
end

function AIEngin:isSkillType3(skillId)
	return skillId and analysis("Jineng_Jineng",skillId,"typyP") == 3
end
-------------
--汉字+数字 popup如主档1000
-------------
function AIEngin:hanZiPopShuzi(effectType,number,skillId)
	self:initTextAnimate(effectType.."_"..number,self:isPlayDead())
	if not self:isSkillType3(skillId)  then
		self:playDeadTimer(self.bloodTime)
	end
end

-------------
--汉字 popup如暴击，闪避等
-------------
function AIEngin:hanZiPop(textType,number,skillId)
	if not self.roleVO.battleIcon.list then return end
	if not self:isSkillType3(skillId)  then
		self:playDeadTimer(self.bloodTime)
	end
	local textAnimatePop = TextAnimationPopAndUp.new();
	textAnimatePop:initLayer();
	local height = self.roleVO.battleIcon:getNameTextHeight()>180 and 180 or self.roleVO.battleIcon.nameTextHeight
	textAnimatePop:setPositionXY(0,height);
	textAnimatePop:textAnimation(textType,self.skeleton);
	self.roleVO.battleIcon:addChildAt(textAnimatePop,1001);
	self.roleVO.battleIcon.bloodProgressBar:refreshBarData(self.roleVO:getCurrHp()/self.roleVO:getMaxHP())
end

--技能名字 飘字,
function AIEngin:skillNameTextPop(skillId)
	if not self.roleVO.battleIcon.list then return end
	require "main.view.battleScene.function.TextNameAnimationSkill"
	local textNameAnimationSkill = TextNameAnimationSkill.new();
	textNameAnimationSkill:initLayer();
	textNameAnimationSkill:setPositionXY(0,roleVO.battleIcon.nameTextHeight+50);
	textNameAnimationSkill:textAnimation(skillId,self.skeleton);
	roleVO.battleIcon:addChildAt(textNameAnimationSkill,1002);
end
--POP对话用
function AIEngin:popoDialog(dialogString,faceDirect)
	if not self.textAnimationDialog then 
		require "main.view.battleScene.function.TextAnimationDialog"
		self.textAnimationDialog = TextAnimationDialog.new();
		self.textAnimationDialog:initLayer();
		self.textAnimationDialog:initAnimation(self.skeleton);
		self.roleVO.battleIcon:addChild(self.textAnimationDialog);
	else
		self.textAnimationDialog:setVisibleDialog(true)
	end
	local height = self.roleVO.battleIcon:getNameTextHeight()>180 and 180 or self.roleVO.battleIcon.nameTextHeight
	self.textAnimationDialog:setPositionXY(0,height-50);
	self.roleVO.isPopDialogIng = true
	self.textAnimationDialog:textAnimation(dialogString,faceDirect,self.roleVO)
end

function AIEngin:isNeedSlowTime()
	if self.roleVO.isLastAttack then
		return true
	end
end
