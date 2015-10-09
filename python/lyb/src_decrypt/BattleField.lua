BattleField = class();
function BattleField:ctor(battleId,battleFieldConfig,seed,battleProxy,storyLineProxy,userProxy,operatonProxy,heroHouseProxy,generalListProxy)
	self.class = BattleField;
	require "main.view.battleScene.BattleLayerManager"
	require("main.controller.command.battleScene.battle.battlefield.compute.BattleFormula")
	require("main.controller.command.battleScene.battle.battlefield.config.BattleConstants")
	
	--print("===============battlefieldId==============="..battleId)
	--战场阶段
	self.battleStage = BattleConstants.WAITING;

	self.firstTeam = nil;
	self.secondTeam = nil;
	self.flyUniList = nil;
	self.currentFrame=1;
	--战场结束检查
	self.checkerSet = {}
	--打点相关
	self.source = nil
	self.sourceParam = nil
	
	self.attackRrcordArray = {}
	self.clickSkillTimes = 0;
	--战场id
	self.id = battleId;
	self.battleUnitMap = {};--战斗角色用于排序出手
	self.battleFieldConfig = battleFieldConfig;
	self.battleTime = battleFieldConfig.longestTime*1000;
	self.seed = seed;
	self.battleProxy = battleProxy;
	self.storyLineProxy = storyLineProxy;
	self.userProxy = userProxy;
	self.operatonProxy = operatonProxy;
	self.heroHouseProxy = heroHouseProxy
	self.generalListProxy = generalListProxy
	-- 战场里随机
	self.randomMap = {};
	self.randomIndex = 1;
	--// 伤害加成(默认为1)
	self.hurtAdditionValue = 100000;
	self.round = 0;
	self.attackUnitCount = 0;
	self.attackIdx = 1;
	self.maxRound = 10;
	self.selectSkillTag = 1;
	self.autoAtkIdx = 1;
	self.pauseStageArr = {};
end

function BattleField:removeSelf()
	self.class = nil;
end

function BattleField:dispose()
	self.firstTeam:dispose()
	self.secondTeam:dispose()
	self:removeRecordLoopTimer()
	self:removeRecord_LoopTimer()
	self.pauseStageArr = nil;
	self.battleProxy = nil;
	if self.battleScript then
		self.battleScript:dispose()
	end
	self:removeSelf()
end

function BattleField:getBattleRound()
	return self.round;
end

function BattleField:getFirstTeamBattleUnits()
	return self.firstTeam:getBattleUniMap();
end

function BattleField:getSecocdTeamBattleUnits()
	return self.secondTeam:getBattleUniMap();
end

function BattleField:getFirstTeam()
	return self.firstTeam;
end

function BattleField:setFirstTeam(firstTeam)
	self.firstTeam = firstTeam;
end

function BattleField:getSecondTeam()
	return self.secondTeam;
end

function BattleField:getBattleFieldConfig()
	return self.battleFieldConfig;
end

function BattleField:setSecondTeam(secondTeam)
	self.secondTeam = secondTeam;
end

function BattleField:getId()
	return self.id;
end
function BattleField:getBtlModeId()
	return self.battleProxy.btlModeId;
end

function BattleField:getSource()--状态释放者
	return self.source;
end

function BattleField:setSource(source)--状态释放者
	self.source = source;
end

function BattleField:getSourceParam()
	return self.sourceParam;
end

function BattleField:setAttackRecordArray(record)
	table.insert(self.attackRrcordArray,record)
end

function BattleField:addClickSkillTimes()
	self.clickSkillTimes = self.clickSkillTimes + 1
end

function BattleField:getRecordLength()
	return #self.attackRrcordArray
end

function BattleField:getAttackRecordArray()
	return self.attackRrcordArray
end

function BattleField:setSourceParam(sourceParam)
	self.sourceParam = sourceParam;
end

--脚本战斗强制结束也用
function BattleField:forceBattleOver()
	self.battleProxy:removeBattleAITimer()
	--self.firstTeam:battleOverForceHold()
	--self.secondTeam:battleOverForceHold()
	self:battleOverByType()
	self:sendLeftRoleProperty()
end

function BattleField:battleOverByType()
	if self.battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_4 then
		self:scriptFourBattleStepStart()
	else
		self.battleScript:scriptBattleOver()
	end
end

function BattleField:lastScriptOver()
	self:removeRecord_LoopTimer()
	local function record_LoopTimer2()
		--log("===record_LoopTimer==")
		self:battleOver();
	end
	local function record_LoopTimer1()
		self:removeRecord_LoopTimer()
		record_LoopTimer2()
		self.record_LoopTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(record_LoopTimer2, 8, false)
	end
	self.record_LoopTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(record_LoopTimer1, 0.8, false)
end

function BattleField:battleOver()
	if not self.battleProxy then return end
	if self.firstTeam:isWin() then
		self:removeRecordLoopTimer()
		if self.battleProxy.serverBackBattleOver then
			self:removeRecord_LoopTimer()
			self.battleProxy:cleanAIBattle()
			return
		end
		local function recordLoopTimer()
	        self:battle_Over()
	    end
	    self.recordLoopTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(recordLoopTimer, 0, false)
	else
		sendMessage(7,21,{BattleId = self.battleProxy.battleId})
	end
end

function BattleField:battle_Over()
	local standPoint = 0;
	local starLevel = 0;
	self:removeRecordLoopTimer()
	if self.firstTeam:isWin() then
		standPoint = 1
		BattleUtils:setDebugWinner(1)
		if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 or self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_10 then
			self.battleProxy:makeBattleStar();
			starLevel = self.battleProxy:getBattleStar();
		else
			self.battleProxy:makeBattleStar(true);
		end
	elseif self.secondTeam:isWin() then
		standPoint = 2
		self.battleProxy:makeBattleStar(true);
	end
	self.storyLineProxy.standPoint = standPoint;--这个字段在4_1里面会用不要删
	local message720 = {};
	message720.Param = self.battleProxy.battleId;
	local md5Data = CommonUtils:getBattleOverData(self.battleProxy.battleId,self.userProxy:getUserID(),standPoint)
	message720.ParamStr1 = md5Data;
	message720.Param2 = starLevel;
	message720.Param3 = self.clickSkillTimes;
	local rm = {};
	table.insert(rm,self.randomMap[1]);
	for i=1,10 do
		table.insert(rm,self.randomMap[math.random(1,#self.randomMap)]);
	end
	table.insert(rm,self.randomMap[#self.randomMap]);
	message720.BufArray = rm
	if standPoint>0 then
		sendMessage(7,20,message720);
	end
end

function BattleField:sendLeftRoleProperty()
	if self.battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_3 then return end
	local manager = self.secondTeam.bornMonsterManager;
    local message = {};
	message.BattleId = self.battleProxy.battleId;
	message.GeneralStateArray = self.firstTeam:getAliveUnitsProMap();
	message.TargetStateArray = self.secondTeam:getAliveUnitsProMap();
	sendMessage(7,59,message);
end

function BattleField:removeRecordLoopTimer()
    if self.recordLoopTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.recordLoopTimer)
        self.recordLoopTimer = nil; 
    end
end

function BattleField:removeRecord_LoopTimer()
    if self.record_LoopTimer then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.record_LoopTimer)
        self.record_LoopTimer = nil; 
    end
end

function BattleField:getHurtReduceAddition()
	if self.battleFieldConfig.type==BattleConstants.BATTLE_TYPE_4 or self.battleFieldConfig.type==BattleConstants.BATTLE_TYPE_22 then
		return 50000;
	end
	return 0;
end

function BattleField:getCurrentFrame()
 	return self.currentFrame;
end
function BattleField:getCurrentTime()
 	return self.currentFrame*BattleConstants.Frame_Time;
end
function BattleField:getXishubiao1030() 
	if not self.Xishubiao1030 then
		self.Xishubiao1030 = analysis("Xishuhuizong_Xishubiao",1030,"constant");
	end
	return self.Xishubiao1030*3
end

function BattleField:addRandomValue(value)
	local randomArray = {};
	randomArray.Type = self.randomIndex;
	randomArray.Value = value;
	table.insert(self.randomMap, randomArray);
	self.randomIndex = self.randomIndex + 1;
end
--fjm begin---
function BattleField:setBattleUser(battleUserArray)-- fjm---2.0
	for k1,user in pairs(battleUserArray) do
		if user.standPoint == BattleConstants.STANDPOINT_P1 then
			self.firstUser = user;
			self.firstUser:setMyTeam(self.firstTeam);
		else
			self.secdUser = user;
			self.secdUser:setMyTeam(self.secondTeam);
		end
	end
end
function BattleField:setBattleUnitMap(battleGeneralArray)-- fjm---2.0
	self.battleUnitMap = {};
	for k1,unit in pairs(battleGeneralArray) do
		table.insert(self.battleUnitMap,unit);
		if unit.standPoint == BattleConstants.STANDPOINT_P1 then
			self.firstTeam:addBattleUnit(unit);
		else
			self.secondTeam:addBattleUnit(unit);
		end
	end
end

function BattleField:initBattle(battleSceneMediator)
	self.battleSceneMediator = battleSceneMediator;
	self.round = 0;--回合
	self.currentStage = BattleConstants.BATTLE_START;
	self.battleProxy:resetData();
    --设置长长UI
    self:initBattleMap();
    --战场角色
    self:initRoleInfo();
	self:viewBattle();
	self:initFightUI();
	self.secondTeam:initDrop()
	self:scriptOneBattleStart()
end
-----------------------
--初始化战场背景地图
-----------------------
function BattleField:initBattleMap()
	local map = CCSprite:create(self.battleProxy.mapArr[1]);
    local mapSpr = Sprite.new(map);
    mapSpr.name = BattleConfig.Battle_Map_Name;
    mapSpr:setPositionY((GameConfig.STAGE_HEIGHT-mapSpr:getContentSize().height)/2)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP).mapBatchLayer:addChild(mapSpr);
	if self.battleProxy.mapArr[5] and tonumber(self.battleProxy.mapArr[5])>0 then
		local mapEffect = cartoonPlayer(self.battleProxy.mapArr[5],0,0,0);
		mapEffect.name = "mapEffect";
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_MAP):addChildAt(mapEffect);
    end
end
-----------------------
--初始化战场角色
-----------------------
function BattleField:initRoleInfo()
	self.firstTeam:bornRole();
	self.secondTeam:bornRole();
end
function BattleField:initFightUI()
    self.battleSceneMediator:initFightUI();
    self.battleProxy.currentFightUserID = self.userProxy.userId;
    self.battleSceneMediator:setBattleUIData();
end
function BattleField:playBeginAttackEffect(battleUnitID,attackSkillId)
	--self:onPauseBattle();
	self.battleSceneMediator:playBeginAttackEffect(battleUnitID,attackSkillId);
end
--战斗开始的脚本1号停止点
function BattleField:scriptOneBattleStart()
	if not self.battleProxy then return end
	if self.battleProxy.battleScriptArr then
		self:initBattleScript()
	else
		self:playBattleStart();
	end
end
--战斗中的2号和4号停止点脚本开始
function BattleField:scriptTwoBattleStepStart()
	if not self.battleProxy then return end
	if self.battleProxy.battleScriptArr then
		self:initBattleScript()
	else
		self.secondTeam.bornManager:moveToNextWavePlace()
	end
end
--战斗中的2号和4号停止点脚本结束
function BattleField:scriptTwoBattleContinue()
	self.secondTeam.bornManager:moveToNextWavePlace()
end
--战斗中的3号和5号停止点脚本开始
function BattleField:scriptThreeBattleStepStart()
	if not self.battleProxy then return end
	if self.battleProxy.battleScriptArr then
		self:initBattleScript()
	else
		self:moveToNextWaveOver()
	end
end
--战斗中的3号和5号停止点脚本结束
function BattleField:scriptThreeBattleContinue()
	self:moveToNextWaveOver()
end
--战斗中的6号停止点或战斗结束点脚本开始
function BattleField:scriptFourBattleStepStart()
	if not self.battleProxy then return end
	if self.battleProxy.battleScriptArr then
		self.secondTeam.bornManager:addCurrentScriptStep()
		self:initBattleScript(true)
	else
		self:scriptFourBattleContinue()
	end
end
--战斗中的6号停止点脚本结束
function BattleField:scriptFourBattleContinue()
	self:lastScriptOver()
end
--战斗脚本初始化
function BattleField:initBattleScript(isOverScript)
	if not self.battleScript then
		self.battleScript = BattleScript.new();
		self.battleScript:initScript(self);
	end
	self.battleScript:beginScript(self.secondTeam.bornManager.currentScriptStep,isOverScript);
end
--脚本跳过
function BattleField:onTiaoGuoTap()
	self.battleScript:onTiaoGuoTap()
end
function BattleField:getCurWave()
  return self.secondTeam.bornManager.currentRound
end
function BattleField:getMaxRound()
	return self.secondTeam.bornManager.maxRound;
end
------------------
--战斗开始
------------------
function BattleField:viewBattle()
  --log("viewBattle-----1")
  -- if not GameData.isKickByOther then
    sharedTextAnimateReward():disposeTextAnimateReward()
    GameData.isPopQuitPanel = false

    Director:sharedDirector():replaceScene(self.battleSceneMediator:getViewComponent());   
    GameData.currentSceneIndex = 3
    Director:sharedDirector():setAnimationInterval(1.0/60)

    local musicID = analysis("Zhandoupeizhi_Zhanchangpeizhi", self.battleProxy.battleFieldId,"music")
    -- 战场背景音乐
    if musicID == 12 then
      if GameData.isMusicOn then
            MusicUtils:play(5,true)
      end
    else
      if GameData.isMusicOn then
            MusicUtils:play(musicID,true)
      end
    end
  -- end
end
--召唤
function BattleField:playBattleStart()
    local function startFun()
        local cartoon;
		local function actionTimer()
			self:send_Battle_Start()
			if self.battleScript then
				self.battleScript:guildSkillClick(true)
			end
			self.battleSceneMediator:fightUIActivite();
			sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):removeChild(cartoon); 
		end      
		cartoon = cartoonPlayer("200",GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT*0.5,1,actionTimer,1,nil,nil)
		sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):addChild(cartoon); 
    end
    self:firstTeamMoveToNextPlace(true)
	self:secondTeamMoveToNextPlace()
	Tweenlite:delayCallS(0.8,startFun);
end
--第一队开场或下一波移动
function BattleField:firstTeamMoveToNextPlace(isFirstWave)
	for k,v in pairs(self.firstTeam.bornUnitMap) do
		local function playBack()
			v.battleIcon:playAndLoop(BattleConfig.ROLE_HOLD);
		end
		local reduceDis = 0;
		local addDistance = GameConfig.STAGE_WIDTH
		local moveTime = 3;
		if isFirstWave then
			reduceDis = GameConfig.STAGE_WIDTH/2;
			addDistance = 0;
			moveTime = 1.5;
		end
		v.battleIcon:stopAndRemoveAllAction()
		v:setPositionXY(Battle_Pos_L[v.standPosition].x-reduceDis,Battle_Pos_L[v.standPosition].y);
		v.battleIcon:playAndLoop(BattleConfig.RUN);
		v.standPositionCcp = CCPointMake(Battle_Pos_L[v.standPosition].x+addDistance,Battle_Pos_L[v.standPosition].y);
		v.battleIcon:tweenLiteAnimation(moveTime+math.random(1,50)/100, v.standPositionCcp, playBack,true);
	end
end
--第二队开场或下一波移动
function BattleField:secondTeamMoveToNextPlace()
	for k1,v1 in pairs(self.secondTeam.bornUnitMap) do
		local function playBack1()
			v1.battleIcon:playAndLoop(BattleConfig.ROLE_HOLD);
		end
		v1.battleIcon:stopAndRemoveAllAction()
		v1:setPositionXY(Battle_Pos_R[v1.standPosition].x+GameConfig.STAGE_WIDTH/2,Battle_Pos_R[v1.standPosition].y);
		v1.battleIcon:playAndLoop(BattleConfig.RUN);
		v1.standPositionCcp = Battle_Pos_R[v1.standPosition];
		v1.battleIcon:tweenLiteAnimation(1.5+math.random(1,50)/100, v1.standPositionCcp , playBack1,true);
	end
end
--下一波提前做一些动画
function BattleField:onActionUI()
	self.battleSceneMediator:onActionUI()
end
--下一波移动
function BattleField:moveToNextWavePlace()
	self:firstTeamMoveToNextPlace()
	local function fadeInOver()
		self.secondTeam.bornManager:addCurrentScriptStep()
		self:scriptThreeBattleStepStart()
	end
	BattleUtils:blackScreenFadeInOut(fadeInOver)
end
function BattleField:onExitClean()
	self.flyUniList:onRemoveAll()
end
function BattleField:moveToNextWaveOver()
	self.secondTeam.bornManager:botnBattleUnit()
	self.firstTeam:chickBorn();
	self:firstTeamMoveToNextPlace(true)
	self:secondTeamMoveToNextPlace()
	local function nextStartFun()
		self:onBornWaitOver()
		if self.battleScript then
			self.battleScript:guildSkillClick(true)
		end
	end
	Tweenlite:delayCallS(2,nextStartFun);
end
--战斗开始
function BattleField:send_Battle_Start()
    self.battleProxy.dialogType = nil;
    if self.battleProxy.battleStatus == BattleConfig.Battle_Status_1 then
		local table = {BattleId = self.battleProxy.battleId};
		sendMessage(7,2,table);
    elseif self.battleProxy.battleStatus == BattleConfig.Battle_Status_2 then
        require "main.controller.command.battleScene.BattlePlaybackCommond"
        self:addSubCommand(BattlePlaybackCommond);
        self:complete();
    elseif self.battleProxy.battleStatus == BattleConfig.Battle_Status_3 then
        self.battleProxy:startBattleAI()
    end
    self:makeAttackUnitArr();
    self:usePassiveSkill();
end
function BattleField:usePassiveSkill()
	for k1,unit1 in pairs(self.firstTeam.bornUnitMap) do
		unit1:usePassiveSkill()
	end
	for k2,unit2 in pairs(self.secondTeam.bornUnitMap) do
		unit2:usePassiveSkill()
	end
end
function BattleField:updateRound()
	self.round = self.round+1;
end
local function sortFun(a, b)
	if a.standPosition == b.standPosition then
		return a.standPoint<b.standPoint;
	else
		return a.standPosition < b.standPosition;
	end
end
function BattleField:makeAttackUnitArr()
	if self.attackIdx > self.attackUnitCount then
		self.attackUnitArr = {};
		self.attackUnitCount = 0;
		self.attackIdx = 1;
		self:updateRound();
		for k1,unit1 in pairs(self.firstTeam.bornUnitMap) do
			unit1:roundAddRage();
			table.insert(self.attackUnitArr,unit1);
			self.attackUnitCount = self.attackUnitCount + 1;
		end
		for k2,unit2 in pairs(self.secondTeam.bornUnitMap) do
			unit2:roundAddRage();
			table.insert(self.attackUnitArr,unit2);
			self.attackUnitCount = self.attackUnitCount + 1;
		end
		table.sort( self.attackUnitArr, sortFun );
	end
end
function BattleField:getNextAttackUnit()
	self:makeAttackUnitArr();
	local attUnit = self.attackUnitArr[self.attackIdx];
	while( attUnit:isDie() )do
		self.attackIdx = self.attackIdx + 1;
		attUnit = self.attackUnitArr[self.attackIdx]
		if self.attackIdx > self.attackUnitCount then break end
	end
	self.attackIdx = self.attackIdx + 1;
	return attUnit;
end
function BattleField:chickSkill()--自动释放技能
	local autoUnit = self.attackUnitArr[self.autoAtkIdx];
	self.autoAtkIdx = self.autoAtkIdx+1;
	if self.autoAtkIdx > self.attackUnitCount then self.autoAtkIdx = 1 end
	if autoUnit and autoUnit:isAlive() then
		local skillId = autoUnit:chickSkill();
		if skillId then
			self:useSkill(autoUnit:getObjectId(),skillId);
		end
	end
end
function BattleField:onBornWait()
	self.flyUniList:onRemoveAll();
	self:onPauseBattle(BattleConstants.BATTLE_ROUND_WAIT)
end
function BattleField:onBornWaitOver()
	self:onContinueBattle(BattleConstants.BATTLE_ROUND_WAIT)
	self:usePassiveSkill();
end
function BattleField:update()
	if BattleConstants.BATTLE_OVER == self.currentStage then
		self:forceBattleOver()
		self.flyUniList:onRemoveAll()
		return;
	end
	if self:isPauseBattle() then
		if self.nextBtlUnit and not self.nextBtlUnit:isAttackOver() then
			self.nextBtlUnit:updateState(now) --只更新状态不更新效果
		end
		return;
	end
	self:setBattleLeftTime();
	local now = self.currentFrame*BattleConstants.Frame_Time;
	if (not self.nextBtlUnit or self.nextBtlUnit:isAttackOver()) 
		and (not self.attackUnit or self.attackUnit:isAttackOver()) then
		self.firstTeam:chickBorn();
		self.secondTeam:chickBorn();
		if self:checkBattleOver() then return end;
		self.nextBtlUnit = nil;
		self.attackUnit = self:getNextAttackUnit();
		if  self.attackUnit then
			self.attackUnit:perAttackStart()
		end
	end
	if not self.nextBtlUnit or not self.nextBtlUnit:isPerSkill() then
		self:chickSkill();
	end
	self.firstTeam:update(now);
	self.secondTeam:update(now);
	self.flyUniList:update(now);
	self.currentFrame = self.currentFrame+1;
end
function BattleField:isPauseBattle()
	if self.currentStage == BattleConstants.BATTLE_PAUSE or self.isInBigSkill then
		return true;
	end
end
function BattleField:onPauseBattle(stage)
	if self.currentStage == BattleConstants.BATTLE_OVER then return end
	self.currentStage = BattleConstants.BATTLE_PAUSE;
	self.pauseStageArr[stage] = true;
end
function BattleField:onContinueBattle(stage)
	self.pauseStageArr[stage] = nil;
	if self.currentStage == BattleConstants.BATTLE_OVER then return end
	for k,v in pairs(self.pauseStageArr) do
		if v then return end
	end
	self.currentStage = BattleConstants.BATTLE_START;
end
function BattleField:onPauseScript()
	self:onPauseBattle(BattleConstants.BATTLE_PAUSE_SCRIPT)
	self.firstTeam:onPauseScript()
	self.secondTeam:onPauseScript()
end
function BattleField:onContinueScript()
	self.firstTeam:onContinueScript()
	self.secondTeam:onContinueScript()
	self:onContinueBattle(BattleConstants.BATTLE_PAUSE_SCRIPT)
end
function BattleField:onBigSkill(isIn)
	self.isInBigSkill = isIn;
	if isIn then
		self.firstTeam:onRestPos();
		self.secondTeam:onRestPos();
	end
end
function BattleField:getCurrentFrameTime()
	return self.currentFrame*BattleConstants.Frame_Time;
end
function BattleField:setBattleLeftTime()
	self.battleProxy.battleLeftTime = self.battleTime-self:getCurrentFrameTime()
end
--是否发完死亡消息
function BattleField:checkBattleOver()
	if self.currentStage == BattleConstants.BATTLE_OVER then return end
	if self.secondTeam:isTeamPause() then return end
	if self.isStopSkillPause then return end
	for k,checker in pairs(self.checkerSet) do
		if checker:battleOver(self) then
			self.currentStage = BattleConstants.BATTLE_OVER;
			return true;
		end
	end
end
function BattleField:addBattleOverChecker(chekcer)
	table.insert(self.checkerSet,chekcer)
end
function BattleField:setHurtAdditionValue(hurtAdditionValue)
	self.hurtAdditionValue = hurtAdditionValue;
end

function BattleField:getHurtAdditionValue()
	return self.hurtAdditionValue;
end
function BattleField:getFlyUniList()
	return self.flyUniList;
end
function BattleField:setFlyUniList(flyUniList)
	self.flyUniList = flyUniList;
end
function BattleField:refreshSkillCDTime(battleUnitID)
	self.battleSceneMediator:refreshSkillCDTime(battleUnitID)
end
function BattleField:useSkill(battleUnitId,usekillId)
	if self:isPauseBattle() and not self.pauseStageArr[BattleConstants.BATTLE_PAUSE_SCRIPT] then return end	
	local battleUnit = self.firstTeam:getBattleUnitByID(battleUnitId);
	if not battleUnit then
		 battleUnit = self.secondTeam:getBattleUnitByID(battleUnitId);
	end
	if battleUnit:hasEffectType(BattleConstants.SKILL_EFFECT_TYPE_3005) and battleUnit:getSkillType(usekillId)~=1 then--沉默
		return
	end
	self.nextBtlUnit = battleUnit;
	if self.attackUnit == self.nextBtlUnit then
		self.attackUnit.machineState:switchState(StateEnum.IDLE);
		self.attackUnit:setPositionCcp(self.attackUnit.standPositionCcp);
	end
	self.nextBtlUnit.useSkillId = usekillId;
	self.nextBtlUnit:perAttackStart();
end
function BattleField:setSelectSkillTag(tag)
	self.selectSkillTag = tag or 1;
end
function BattleField:getSelectSkillTag()
	return self.selectSkillTag;
end
function BattleField:onSkillContinue(atkUnit)
	atkUnit:AttackStart()
end
function BattleField:toTutorAction()
	if self.battleScript then
		self.battleScript:guildSkillClick()
	end
end
--fjm end---