require "main.managers.BattleData"

BattleProxy=class(Proxy);

function BattleProxy:ctor()
    self.class = BattleProxy;
    self.strongPointId = nil
	  self.battleType = nil
    self.mapArr = nil
    self.aiEnginMap = nil;
    self.attackResultArray = nil;
    self.monsterCount = 0;
    self.currentRage = 0;
    self.currentRageTotal = 0;
    self.totalBattleArtsTable = nil;
    self.attackSkillArray = {};
    self.beAttackSkillArray = {};
    self.screenSkillArray = {};
    -- 7_1 "命令相关"
    self.battleFieldId = nil
    self.mapId = nil
    self.battleUserArray = nil
    self.battleGeneralArray = {};
    self.battleUnitViewArray = nil;
    self.battleNewGeneralArray = nil;
    self.battleFlySkillArray = {};
    self.speed = nil;
    -- 7_4
    self.battleUnitID = nil
    self.currentHP = nil
    self.changeValue = nil
    --7_5
    self.battleUnitID = nil
    self.effectArray = nil
    --7_6
    self.battleResult = nil
    --7_8
    self.currentRage = nil
    --7_9
    self.state = nil
    --7_10
    self.wuShuangSkillArray = nil
    self.effectId = nil
    --7_14
    self.attackterBattleUnitId = nil
    self.targetBattleUnitId = nil
    self.skillId = nil
    --7_15
    self.coordinateX = nil
    --7_18
    self.unitPropertyArray = nil
    --7_17
    -- self.totalDeadNumber = 0;
  	-- 我方当前出战玩家ID（留给多人PVP）
  	self.currentFightUserID = nil
  	-- bossTable
  	--self.bossMonsterID = nil
  	-- timer function
  	self.loopFunction = nil
  	-- 是否是最后一击  播慢动作
  	self.isLastAttack = nil
  	--憋着的命令的数据
  	self.lastAttackData_7_6 = nil
    --断线重连用
    self.hasBattleOver_7_6 = nil;
  	self.lastAttackData_7_13 = nil
  	-- 是否是继续战斗
  	self.isContinueBattle = nil
    --从哪个UI界面进入战场
    self.battleFrom = BattleConfig.Battle_From_Type_0;
    --战场怪物波数
    self.waveNumber = 1;
    --self.littleWaveNumber = 0;
    self.boxIndex = 0;
    self.dialogType = nil;
    self.dialogMiddle = nil;
    self.isLittleRound = false;
    --加载
    self.loadFailed = nil;
    self.deadUnitIDArray = {};
    --战斗回放相关-----
    self.playbackArray = {};
    self.playCurrentArr = nil;
    self.currentDownBattleID = nil;
    self.viewBattleID = nil
    self.playbackContext = nil
    self.battleStatus = nil;
    self.handlerType = nil;
    self.handlerData = nil;
    self.familyViewData = {}
    --战斗回放相关-----
    
    --首场战斗
    self.firstBattleData = {}
    --首场战斗
    --self.monsterMinUnitId = 100000;--初始化时填充怪物
    self.battleUnitIDArray = {};--多波怪累加
    --已经发过的战斗数据
    self.hasSendIndexArray = {}
    -- self.needDebug = nil
    --自己带的英雄三个
    self.myHeroRoleArray = nil

    -- 3个英雄跟随的位置
    self.myHeroFollowPositions = {}

    -- 3个英雄和玩家攻击时的的位置
    self.myHeroAttackPositions = {}

    --小怪，没有BOSS，用于怪物随机掉道具
    self.monsterArray = nil
    self.hasBattleOverDialog = nil

    self.myBattleUnitID = nil
    -- self.myHeroUnitID = nil--当没有主角时的战斗用
    self.greenHandBattle = nil;--新手战斗
    self.skillItemPositionArray = nil --新手战斗
    self.tenCountryBossLevel = nil
    self.battleLeftTime = 0--停止时间用
    BattleData.boneEffectTable = {}
    self.battleScriptArr = nil
    self.battleOverBossName = ""
    self.battleOverMonsterCount = 0
    self.battleOverUseTime = ""
    self.starLevel = 0
    self.currentPowerNum = nil
end


function BattleProxy:getGeneralVOByUnitID(battleUnitID)
    return self.battleGeneralArray[battleUnitID]
end

rawset(BattleProxy,"name","BattleProxy")
----------------
--准备加载所有战场用到的素材
----------------
function BattleProxy:downlandData(userProxy,generalProxy,storyLineProxy)
  self.cachMap = {};
  --跑动灰尘
  luaUrl = "resource/image/arts/P22.lua";
  self.cachMap[luaUrl] = luaUrl
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  --死亡特效
  luaUrl = "resource/image/arts/P871.lua";
  self.cachMap[luaUrl] = luaUrl
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  --倒地灰尘
  luaUrl = "resource/image/arts/P82.lua";
  self.cachMap[luaUrl] = luaUrl
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  -- --放技能选中时的火
  -- luaUrl = "resource/image/arts/P633.lua";
  -- self.cachMap[luaUrl] = luaUrl
  -- GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  -- --BOSS血条
  -- luaUrl = "resource/image/arts/P175.lua";
  -- self.cachMap[luaUrl] = luaUrl
  -- GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  --召唤闪电
  luaUrl = "resource/image/arts/P1052.lua";
  self.cachMap[luaUrl] = luaUrl
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  --怪物出生特效
  luaUrl = "resource/image/arts/P830.lua";
  self.cachMap[luaUrl] = luaUrl
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  --BOSS脚上特效
  luaUrl = "resource/image/arts/P1092.lua";
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;--只做删除不做缓存
  --BOSS脚上特效
  luaUrl = "resource/image/arts/P1091.lua";
  GameData.deleteBattleTextureMap[luaUrl] = luaUrl;--只做删除不做缓存
  --开始战斗动画
  --玩家及怪物动作素材,技能特效
  for k,v in pairs(self.battleGeneralArray) do
    if v.type == BattleConfig.BATTLE_PET or v.type == BattleConfig.BATTLE_FRIEND or v.type == BattleConfig.BATTLE_YONGBING then
        self:downTypePetSource(v)
    end
  end
  -- 取得本战场内怪物的模型和技能信息--
  if self.battleType ~= BattleConfig.BATTLE_TYPE_2 then
      for k_monster,v_monster in pairs(self.battleUnitIDArray) do
          local monsterPO = analysis("Guaiwu_Guaiwubiao",v_monster.MonsterId);
          self:findOutFromArts(monsterPO.modelId,true);
          analysisSkillthreeArr(monsterPO.pugong);
          analysisSkillthreeArr(monsterPO.skill);
          self:readConfigEffect(monsterPO.pugong,true);
          self:readConfigEffect(monsterPO.skill,true);
      end
  end
  self:cacheMaps()
  if self.battleFieldId and storyLineProxy:getStrongPointState(self.battleFieldId) ~= 1 then--判断是否通关,不可以删
  -- 脚本战场素材缓存  目前先缓存技能的
    local scriptStr = analysis("Zhandoupeizhi_Zhanchangpeizhi",self.battleFieldId,"script");
    scriptStr = StringUtils:lua_string_split(scriptStr,";")
    
    -- if not battleScriptArr then return end
    if scriptStr[1] ~= "" and #scriptStr > 0 then
      local battleScriptArr = {}
      for k,v in pairs(scriptStr) do
        local scriptArr1 = StringUtils:lua_string_split(v,",")
        if scriptArr1[1] ~= "" then
          local scriptId = tonumber(scriptArr1[2])
          battleScriptArr[tonumber(scriptArr1[1])] = scriptId
        end
      end
      self.battleScriptArr =  battleScriptArr
    end
  end
end

function BattleProxy:downTypePetSource(generalVO)
    local isCle = false;
    local petPO = analysis("Kapai_Kapaiku",generalVO.generalID);
    self:findOutFromArts(petPO.material_id,isCle);
    analysisSkillthreeArr(petPO.skill_id1);
    self:readConfigEffect(petPO.skill_id1,isCle,generalVO);
    analysisSkillthreeArr(petPO.one);
    self:readConfigEffect(petPO.one,isCle,generalVO);
    analysisSkillthreeArr(petPO.two);
    self:readConfigEffect(petPO.two,isCle,generalVO);
    self:readBigEffectSource(petPO.two,isCle,generalVO)
    if petPO.pose then
      local skillSoundArray = {}
      local splitArr = StringUtils:lua_string_split(petPO.pose,";");
      for key,value in pairs(splitArr) do
        self:cacheSoundEffect(value)
        table.insert(skillSoundArray,value)
      end
      generalVO.skillSoundArray = skillSoundArray
    end
end

function BattleProxy:downTypeOwerSource(generalVO,deleteBool)
    local generalArtPO = analysis("Zhujiao_Zhujiaozhiye",generalVO.generalID);
    self:findOutFromArts(generalArtPO.shenti,deleteBool);
    generalVO.itemIdBody = generalArtPO.shenti;

    local kapaikuPO = analysis("Kapai_Kapaiku",generalVO.generalID);
    local splitArr = StringUtils:lua_string_split(kapaikuPO.pose,";");
    local skillSoundArray = {}
    for key,value in pairs(splitArr) do
        self:cacheSoundEffect(value)
        table.insert(skillSoundArray,value)
    end
    generalVO.skillSoundArray = skillSoundArray

    if (generalVO.skillMap) then
      for k1,v1 in pairs(generalVO.skillMap) do
          analysisSkillthreeArr(v1.id);
          self:readConfigEffect(v1.id,deleteBool,generalVO);
      end
    end
end

function BattleProxy:cacheMaps()
    local mapPO = analysis("Zhandoupeizhi_Zhandouditu",tonumber(self.mapId)); 
    self.mapArr = {};
    if mapPO.front1 ~= 0 then
        local frontBg1 = artData[tonumber(mapPO.front1)].source
        self.mapArr[1] = frontBg1;
        self.cachMap[frontBg1] = frontBg1;
    end
    -- if mapPO.mid ~= 0 then
    --     local midBg = artData[tonumber(mapPO.mid)].source
    --     self.mapArr[3] = midBg;
    --     self.cachMap[midBg] = midBg;
    -- end
    if mapPO.duang ~= 0 then
        self.mapArr[5]  = tonumber(mapPO.duang);
    end
end
------------读半身像----------开始----
function BattleProxy:cacheHeroHalfPic(bankArray,armArray)
    for k1,bankPO in pairs(armArray) do
        local source = artData[bankPO.art].source
        self.cachMap[source] = source;
    end
end

function BattleProxy:getHeroHalfPic(generalProxy,heroBankProxy,userProxy)
    if self.battleType ~= BattleConfig.BATTLE_TYPE_13 then
       return self:getBankArray(generalProxy,heroBankProxy)
    else
        local heroArray = {162,110,160,164,161}
        return self:getArmArrayType13(heroArray,userProxy)
    end
end

local function sortFun(a, b) return a.place > b.place end
function BattleProxy:getBankArray(generalListProxy,heroBankProxy)
  local armArray = generalListProxy:getArmSlaveData()
  local tempArray = {};local temp2Array = {}
  for k1,v1 in pairs(armArray) do
      for k2,v2 in pairs(heroBankProxy.slaveGeneralArray) do
          if v1.ID == v2.ID then
             local bankPO = analysis("Yinghun_Yinghunku",v2.ConfigId);
              tempArray[tonumber(bankPO.skill)] = bankPO;
              bankPO.place = v1.Place
              table.insert(temp2Array,bankPO)
          end
      end
  end
  table.sort(temp2Array,sortFun)
  return tempArray,temp2Array;
end

function BattleProxy:getArmArrayType13(heroArray,userProxy)
  local tempArr = {};local tempArr2 = {}
  local skillStr = analysis("Zhujiao_Zhujiaozhiye",userProxy.career,"xswjjn");
  local skillArray = StringUtils:lua_string_split(skillStr,",");
  local num = 1;
  for k1,v1 in pairs(heroArray) do
    local bankPO = analysis("Yinghun_Yinghunku",v1);
    table.insert(tempArr,bankPO)
    if v1 == 160 then
      tempArr2[tonumber(skillArray[num])] = bankPO;
    end
  end
  return tempArr2,tempArr;
end
------------读半身像----------结束----
---------------
--读取特效
---------------
function BattleProxy:readSingalEffect(skillId,deleteBool,generalVO)
    if skillId == "0" then return;end;
    local realKey,duangjnzdid = getAnalysisSkillRealKey(skillId)
    if realKey == "key0" then return end
    self:readDuangSource(duangjnzdid,deleteBool,generalVO)

    local screenVO = BattleData.screenSkillArray[realKey];
    local beAttackTable = BattleData.beAttackSkillArray[realKey];
    local attackTable = BattleData.attackSkillArray[realKey];
    if screenVO then
        self:skillStringSplit(screenVO.quanpingEffect,deleteBool);
        self:skillStringSplit(screenVO.feixingTexiaoID,deleteBool);
        self:skillStringSplit(screenVO.geziTexiaoID,deleteBool);
    end
    if beAttackTable then
        for k1,v1 in pairs(beAttackTable) do
            self:skillStringSplit(v1.attackEffectID,deleteBool);
            self:readySoundEffect(v1.soundEffect);
        end
    end
    if attackTable then
        for k2,v2 in pairs(attackTable) do
            self:skillStringSplit(v2.attackEffectID,deleteBool);
            self:readySoundEffect(v2.soundEffect);
        end
    end
end

function BattleProxy:readDuangSource(duangjnzdid,deleteBool,generalVO)
    if not duangjnzdid or duangjnzdid == 0 then return end
    if not generalVO then return end
    generalVO.duangjnzdid = duangjnzdid
    local luaUrl = "resource/image/arts/P"..duangjnzdid..".lua";
    self.cachMap[luaUrl] = luaUrl;
    if deleteBool then
        GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
    end
end

function BattleProxy:readBigEffectSource(skillId,deleteBool,generalVO)
    if generalVO.standPoint == BattleConfig.STANDPOINT_P2 then return end
    local daoZhaoVO = analysis("Jineng_Dazhaobiao",skillId)
    if daoZhaoVO.QJeffectsID then
      local luaUrl = "resource/image/arts/"..daoZhaoVO.QJeffectsID..".png";
      self:cachDeletecachLuaUrl(luaUrl,deleteBool)
    end
    if daoZhaoVO.BJeffectsID then
      luaUrl = "resource/image/arts/"..daoZhaoVO.BJeffectsID..".png";
      self:cachDeletecachLuaUrl(luaUrl,deleteBool)
    end
    if daoZhaoVO.LGEffectID then
      luaUrl = "resource/image/arts/"..daoZhaoVO.LGEffectID..".png";
      self:cachDeletecachLuaUrl(luaUrl,deleteBool)
    end
end

function BattleProxy:cachDeletecachLuaUrl(luaUrl,deleteBool)
  self.cachMap[luaUrl] = luaUrl;
  if deleteBool then
      GameData.deleteBattleTextureMap[luaUrl] = luaUrl;
  end
end

function BattleProxy:readConfigEffect(skillId,deleteBool,generalVO)
  if skillId == 0 or not skillId then return end
  local skillArr = StringUtils:lua_string_split(skillId,",")
  for k1,v1 in pairs(skillArr) do
    self:readSingalEffect(v1,deleteBool,generalVO)
  end
end

function BattleProxy:readySoundEffect(soundEffect)
    if soundEffect ~= nil and soundEffect ~= "#" then
        local soundEffectArr = StringUtils:lua_string_split(soundEffect,"?")
        for k1,v1 in pairs(soundEffectArr) do
            local splitArr = StringUtils:lua_string_split(v1,",");
            self:cacheSoundEffect(splitArr[2])
        end
    end
end

function BattleProxy:cacheSoundEffect(soundEffectId)
    if not soundEffectId then return;end
    self.cachMap[soundEffectId..".mp3"] = soundEffectId..".mp3";
    GameData.deleteBattleTextureMap[soundEffectId..".mp3"] = soundEffectId..".mp3";
end

function BattleProxy:skillStringSplit(skillStr,deleteBool)
    if(skillStr == nil or skillStr == 0 or skillStr =="#") then return; end;
    local skillStrArr = StringUtils:lua_string_split(skillStr, "?");
    for k,v in pairs(skillStrArr) do
        if(v ~= nil and v ~= 0 and v ~="#") then
               local idArr = StringUtils:lua_string_split(v, "_");--7_1002
               self:findOutFromArts(idArr[1],deleteBool);
        end
    end
end

function BattleProxy:getArtsIDByEquipmentIDAndCarree(equipID,career)
    local bodyTable = analysisByName("Zhuangbei_Zhuangbeisucaiduizhao","equipmentId",equipID)
    for body_k,body_v in pairs(bodyTable) do
      if body_v["occupation"] == career then
          clothEquipArtID = body_v["stuffId"]
      end
    end
    return clothEquipArtID
end

-----------------
--读取查找arts.lua中的数据
-----------------
function BattleProxy:findOutFromArts(artID,isremove)
    if not artID then return end
    local cartoonType = artData[tonumber(artID)].type
    if cartoonType == 4 then -- spritestudio 
      local boneImage = "resource/image/arts/"..artID..".png"
      self.cachMap[boneImage] = boneImage
      -- require "main.managers.BattleData"
      -- BattleData.boneEffectTable[boneSsbaPath] = boneSsbaPath
    elseif cartoonType == 5 then -- spine
      local boneImage = "resource/image/arts/"..artID..".png"
      self.cachMap[boneImage] = boneImage
    elseif cartoonType == 1 then
      local table = self.totalBattleArtsTable[tostring(artID)];
      if not table then return;end;
      for k1,v1 in pairs(table) do
        self.cachMap[v1] = v1;
        if isremove then
            GameData.deleteBattleTextureMap[v1] = v1;
        end
      end
    end
end
--------------
--对arts。lua中plist部分进行一次整理分类
--------------
function BattleProxy:artsClassify()
        if self.totalBattleArtsTable then return;end;
        self.totalBattleArtsTable = {};
        for k1,v1 in pairs(plistData) do
          local strArr = StringUtils:lua_string_split(k1,"_");
          if not self.totalBattleArtsTable[strArr[2]] then
              self.totalBattleArtsTable[strArr[2]] = {};
          end
          table.insert(self.totalBattleArtsTable[strArr[2]],v1);
        end
        for k2,v2 in pairs(self.totalBattleArtsTable) do
            local table = {};
            for k3,v3 in pairs(v2) do
                table[v3.source] = v3.source;
            end
            self.totalBattleArtsTable[tostring(k2)] = table;
        end
end

function BattleProxy:resetData()
  if self.battleType ~= BattleConfig.BATTLE_TYPE_3 then
    self.waveNumber = 0;
  end
    
    -- self.littleWaveNumber = 0
    self.isLastAttack = nil
    -- self.totalDeadNumber = 0;
    self.dialogType = nil;
    self.isContinueBattle = nil;
    self.lastAttackData_7_6 = nil;
    self.hasBattleOver_7_6 = nil;
    self.myHeroRoleArray = self.myHeroRoleArray or {}
    self.autoBattle = 0
    self.isStrongPointState3 = nil
    self.deadUnitIDArray = {};
    self.serverBackBattleOver = nil
end

function BattleProxy:addWaveNumber()
    self.waveNumber = self.waveNumber + 1;
    log("self.waveNumber" .. self.waveNumber)
end

function BattleProxy:setWaveNumber(type3LeftRound)
  self.waveNumber = type3LeftRound or 0
end

function BattleProxy:deleteAiEngin(unitID)
    self.aiEnginMap[unitID]:dispose();
    self.aiEnginMap[unitID] = nil;
    self.battleGeneralArray[unitID] = nil;
end

function BattleProxy:cleanBattleOverData()
    self.isLastAttack = nil
    self.lastAttackData_7_6 = nil;
    self.dialogType = nil;
    self.currentRage = nil
    self.loadFailed = nil;
    -- self.needDebug = nil
    self.monsterArray = nil
    self.hasBattleOverDialog = nil
    -- self:removePlaybackHandlerTimer();
    self:removeBattleAITimer()
    self.myBattleUnitID = nil
    -- self.myHeroUnitID = nil
    self.isStrongPointState3 = nil
    self.tenCountryBossLevel = nil
    self.skillItemPositionArray = nil -- 新手用
    self.battleLeftTime = 0
    self.battleWuxing = nil
    self.type3LeftRound = nil
    self.type3SmallRound = nil
    self.type3MonsterStateArray = nil
    self.deadUnitIDArray = {};
    if self.aiEnginMap then
      for k1,v1 in pairs(self.aiEnginMap) do
          self:deleteAiEngin(k1,true)
      end 
    end
    self.aiEnginMap = nil
    self.battleGeneralArray = {}
    self:cleanAIBattle()
    BattleData.boneEffectTable = {}
    self.battleScriptArr = nil
    if self.bossEffect1054 then
      self.bossEffect1054:dispose()
      self.bossEffect1054 = nil
    end
    self.guideHecDCNumber = nil
    self.isBattleType3First = nil
    self.mainUnitId = nil
    self.serverBackBattleOver = nil
    MathUtils:disPose()
end

function BattleProxy:setCurrentPowerNum(number)
    self.currentPowerNum = number
end

function BattleProxy:getCurrentPowerNum()
    return self.currentPowerNum
end

function BattleProxy:getSkeleton()
    if nil==self.skeleton then
      self.skeleton=SkeletonFactory.new();
      self.skeleton:parseDataFromFile("battle_ui");
    end
    return self.skeleton;
end

function BattleProxy:getOverSkeleton()
    if nil==self.overSkeleton then
      self.overSkeleton=SkeletonFactory.new();
      self.overSkeleton:parseDataFromFile("battleOver_ui");
    end
    return self.overSkeleton;
end
---------------------------前端计算战斗--------------------------------------
function BattleProxy:initBattleAI(storyLineProxy,userProxy,operatonProxy,heroHouseProxy,generalListProxy)
    self.heroHouseProxy = heroHouseProxy;
    self:removeBattleAITimer()
    local battleConfig = analysis("Zhandoupeizhi_Zhanchangpeizhi",self.battleFieldId)
    require("main.controller.command.battleScene.battle.battlefield.BattleField")
    require("main.controller.command.battleScene.battle.battlefield.BattleTeam")
    require("main.controller.command.battleScene.battle.battlefield.flySkill.FlySkillList")
    self.AIBattleField = BattleField.new(self.battleFieldId,battleConfig,self.randomSeed,self,storyLineProxy,userProxy,operatonProxy,heroHouseProxy,generalListProxy)
    local firstTeam = BattleTeam.new(self.AIBattleField, BattleConstants.STANDPOINT_P1);
    local secondTeam = BattleTeam.new(self.AIBattleField, BattleConstants.STANDPOINT_P2);
    local flySkillList = FlySkillList.new(self.AIBattleField);
    --创建怪物
    self.AIBattleField:setFirstTeam(firstTeam);
    self.AIBattleField:setSecondTeam(secondTeam);
    self.AIBattleField:setBattleUnitMap(self.battleGeneralArray);
    self.AIBattleField:setBattleUser(self.battleUserArray);

    firstTeam:initBornManager();
    secondTeam:initBornManager();
    firstTeam:setEnemyTeam(secondTeam);
    secondTeam:setEnemyTeam(firstTeam);
    
    self.AIBattleField:setFlyUniList(flySkillList);

    flySkillList:setFirstTeam(firstTeam);
    flySkillList:setSecondTeam(secondTeam);
    
    self:createBattleOverChecker(battleConfig)
    if self.battleType == BattleConfig.BATTLE_TYPE_2 then
        local constant = analysis("Xishuhuizong_Xishubiao",1067,"constant");
        self.AIBattleField:setHurtAdditionValue(constant)
    end
    MathUtils:setBattleField(self.AIBattleField)
    ---------------------------测试用---------------------------
    -- if self.needDebug then
    --     BattleUtils:initDebugData(self.needDebug)
    --     self.checkBattleUnitArray = {}
    --     firstTeam:checkBattleUnit(self.checkBattleUnitArray);
    --     secondTeam:checkBattleUnit(self.checkBattleUnitArray);
    --     self.secondTeam = secondTeam;
    --     self:sendCheckMessage()
    -- end
    ---------------------------测试用---------------------------
    --log("====================Battle_Status_3======================04")
end

---------------------------测试用---------------------------
function BattleProxy:bornMonsterMsg(uMap)
  self.checkBattleUnitArray = {}
  self.secondTeam:checkBattleUnit(self.checkBattleUnitArray,uMap);
  self:sendCheckMessage()
end

--战场结束条件， 条件5,6不在这里初始化
function BattleProxy:createBattleOverChecker(battleConfig)
    if battleConfig.longestTime > 0 then
        require("main.controller.command.battleScene.battle.battlefield.battleOver.BattleOverCheckerOne")
        self.AIBattleField:addBattleOverChecker(BattleOverCheckerOne.new(battleConfig.longestTime));
    end
    local wanchengArray = self:getWanchengArray(battleConfig.wancheng)
    for key,value in pairs(wanchengArray) do
        if value[1] == BattleConstants.BATTLE_OVER_CHECKER_2 then
            require("main.controller.command.battleScene.battle.battlefield.battleOver.BattleOverCheckerTwo")
            self.AIBattleField:addBattleOverChecker(BattleOverCheckerTwo.new(tonumber(value[2])));
        elseif value[1] == BattleConstants.BATTLE_OVER_CHECKER_3 then
            require("main.controller.command.battleScene.battle.battlefield.battleOver.BattleOverCheckerThree")
            self.AIBattleField:addBattleOverChecker(BattleOverCheckerThree.new(tonumber(value[2])));
        elseif value[1] == BattleConstants.BATTLE_OVER_CHECKER_4 then
            require("main.controller.command.battleScene.battle.battlefield.battleOver.BattleOverCheckerFour")
            self.AIBattleField:addBattleOverChecker(BattleOverCheckerFour.new(tonumber(value[2])));
        end
    end
end

function BattleProxy:getClientMainUnit()
    for key,unit in pairs(self.myHeroRoleArray) do
      if unit.battleUnitID == self.mainUnitId then
          unit.isMainPlayer = true
          return unit
      end
    end
end

function BattleProxy:getServerMainUnit()
    for key,unit in pairs(self.AIBattleField.firstTeam:getBattleUniMap()) do
      if unit:getObjectId() == self.mainUnitId then
          return unit
      end
    end
end

local function sortHP(a, b) return a.hp < b.hp end;
function BattleProxy:setMainUnitId()
    local hpTable = {}
    for key,unit in pairs(self.AIBattleField.firstTeam:getBattleUniMap()) do
        if unit:getCurrHp() > 0 then
          local tempTable = {}
          tempTable.hp = unit:getMaxHP()
          tempTable.unit = unit
          table.insert(hpTable,tempTable)
        end
    end
    table.sort(hpTable, sortHP)
    if table.getn(hpTable) == 0 then return end
    local len = table.getn(hpTable)
    hpTable[len].unit.isMainPlayer = true
    self.mainUnitId = hpTable[len].unit:getObjectId()
end

function BattleProxy:getWanchengArray(wancheng)
    local checkerArray1 = StringUtils:lua_string_split(wancheng,";")
    local checkerArray3 = {}
    for k1,v1 in pairs(checkerArray1) do
        local checkerArray2 = StringUtils:lua_string_split(v1,",")
        table.insert(checkerArray3,checkerArray2)
    end
    --local checkerArray3 = {{"4","0"}}
    return checkerArray3
end

--MonsterId,Round,BattleUnitID
function BattleProxy:getMonsterMaxUnitId(round,monsterId)
  for key,value in pairs(self.battleUnitIDArray) do
      if value.MonsterId == monsterId and value.Round == round then
          local unitID = value.BattleUnitID
          self.battleUnitIDArray[key] = nil;
          return unitID,value.Level;
      end
  end
end

function BattleProxy:bornMonserStart()
  if self.battleType == BattleConfig.BATTLE_TYPE_2 then return end
  self.AIBattleField:getSecondTeam():bornAndSynMonsers();
  if self.battleType == BattleConfig.BATTLE_TYPE_4 then 
    --对话开始，第二队暂停
    self.AIBattleField:dialogOtherStart()
    --脚本对话开始的文字和飘雪效果
    self.greenHandBattle:firstStep()
  end
end
-------------初始化完成,AI开始--------------
function BattleProxy:startBattleAI()
  local function battleAIHandler()
      self.AIBattleField:update(BattleUtils:getOSTime())
  end
  self.battleAIHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(battleAIHandler, 0, false)
end

-- function BattleProxy:toBornMonster(positionX)
--     if not self.AIBattleField then return end
--     self.AIBattleField:toBornMonster(positionX)
-- end

function BattleProxy:dialogOtherOver()
    if not self.AIBattleField then return end
    self.AIBattleField:dialogOtherOver()
end

function BattleProxy:isNeedDialogue(bool)
    if not self.AIBattleField then return end
    self.AIBattleField:isNeedDialogue(bool)
end

function BattleProxy:isNeedPlayScript()
    if not self.AIBattleField then return end
    return self.AIBattleField:isNeedPlayScript()
end
--一队所有停止在IDLE
function BattleProxy:stopFirstAllRoleAtIDLE(bool)
  if not self.AIBattleField then return end
  self.AIBattleField:stopFirstAllRoleAtIDLE(bool)
end
--二队所有停止在IDLE
function BattleProxy:stopSecondAllRoleAtIDLE(bool)
  if not self.AIBattleField then return end
  self.AIBattleField:stopSecondAllRoleAtIDLE(bool)
end
--二队除BOSS其它IDLE
function BattleProxy:stopSecondIsNotBossAtIDLE(bool)
  if not self.AIBattleField then return end
  self.AIBattleField:stopSecondIsNotBossAtIDLE(bool)
end

function BattleProxy:forceScriptBossMove(position)
  if not self.AIBattleField then return end
  self.AIBattleField:forceScriptBossMove(position)
end

function BattleProxy:setScriptBossBlood(value)
  if not self.AIBattleField then return end
  self.AIBattleField:setScriptBossBlood(value)
end

function BattleProxy:forceBattleOver()
  if not self.AIBattleField then return end
  self.AIBattleField:forceBattleOver()
end
function BattleProxy:refreshSkillCDTime(battleUnitID)
  if not self.AIBattleField then return end
  self.AIBattleField:refreshSkillCDTime(battleUnitID)
end
function BattleProxy:useSkill(battleUnitId,usekillId)
  if not self.AIBattleField then return end
  self.AIBattleField:useSkill(battleUnitId,usekillId);
end
function BattleProxy:onBigSkill(bool)
  if not self.AIBattleField then return end
  self.AIBattleField:onBigSkill(bool);
end
function BattleProxy:onTiaoGuoTap()
  if not self.AIBattleField then return end
  self.AIBattleField:onTiaoGuoTap();
end
function BattleProxy:getCurWave()
  if not self.AIBattleField then return end
  return self.AIBattleField:getCurWave();
end
function BattleProxy:setSelectSkillTag(tag)
  if not self.AIBattleField then return end
  self.AIBattleField:setSelectSkillTag(tag);
end
function BattleProxy:onSkillContinue(atkUnit)
  if not self.AIBattleField then return end
  self.AIBattleField:onSkillContinue(atkUnit);
end
function BattleProxy:onContinueScript()
  if not self.AIBattleField then return end
  self.AIBattleField:onContinueScript();
end

function BattleProxy:sendBattleStart()
  if not self.AIBattleField then return end
  self.AIBattleField:sendBattleStart();
end

function BattleProxy:toTutorAction()
  if not self.AIBattleField then return end
  self.AIBattleField:toTutorAction();
end

function BattleProxy:addHPByDrop(itemId)
    if not self.AIBattleField then return end
    self.AIBattleField:addHPByDrop(itemId)
end

function BattleProxy:drawWuShuang(userId,skillId)
    if not self.AIBattleField then return end
    self.AIBattleField:drawWuShuang(userId,skillId)
end

function BattleProxy:drawOver(userId,count)
    if not self.AIBattleField then return end
    self.AIBattleField:drawOver(userId,count)
end
function BattleProxy:isPauseBattle()
    if not self.AIBattleField then return end
    return self.AIBattleField:isPauseBattle()
end
--第一队脚本战斗暂停
function BattleProxy:firstTeamActionStart()
    self.AIBattleField:firstTeamActionStart()
end
--第一队脚本战斗暂停
function BattleProxy:firstTeamActionOver()
    self.AIBattleField:firstTeamActionOver()
end

--第二队脚本战斗暂停
function BattleProxy:secondTeamActionStart()
    self.AIBattleField:secondTeamActionStart()
end
--第二队脚本战斗暂停
function BattleProxy:secondTeamActionOver()
    self.AIBattleField:secondTeamActionOver()
end

function BattleProxy:getScriptBornMonster(monsterId)
    return self.AIBattleField:getScriptBornMonster(self.battleFieldId,monsterId)
end

function BattleProxy:pauseGreenBattle()
    if not self.AIBattleField then return end
    self.AIBattleField:dialogOtherStart()
    -- self.AIBattleField:setFirstTeamPause()
end

function BattleProxy:isNeedPauseClientTime()
    return self.isNeedPauseClientTime
end

function BattleProxy:isNeedPauseClientTime()
    
end

function BattleProxy:getXiShuByWuXing(wuXingId)
  if not self.wuxingArray then
    local wuxingTable = analysisTotalTable("Shuxing_Wuxing");
    self.wuxingArray = {}
    for key,value in pairs(wuxingTable) do
      self.wuxingArray[value.ID] = value.xiShu
    end
  end
  return self.wuxingArray[wuXingId]
end

function BattleProxy:playerTarget(userId,battleUnitID)
    if not self.AIBattleField then return end

    -- self:setMyHeroAttackPositions(userId,battleUnitID)
    self.AIBattleField:playerTarget(userId,battleUnitID)
end

function BattleProxy:jumpPosition(userId,battleUnitID)
    if not self.AIBattleField then return end
    self.AIBattleField:jumpPosition(userId,battleUnitID)
end

-------------AI开始,向客户端发消息--------------
function BattleProxy:sendAIMessage(messageData)
  self.handlerData = messageData;
  self.handlerType = "BattlePlaybackCommond";
  recvMessage(1007,messageData.SubType);
end

function BattleProxy:sendCheckMessage()
  local message = {}
  message.BattleId = self.battleId;
  message.CheckBattleUnitArray = self.checkBattleUnitArray
  sendMessage(7,33,message)
end

function BattleProxy:cleanAIBattle()
    self:removeBattleAITimer()
    if self.AIBattleField then
      self.AIBattleField:onExitClean();
      self.AIBattleField:dispose()
      self.AIBattleField = nil;
    end
    self.battleUnitIDArray = {}
    self.hasSendIndexArray = {}
    self.secondTeam = nil
end

function BattleProxy:removeBattleAITimer()
    if self.battleAIHandler then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.battleAIHandler)
        self.battleAIHandler = nil; 
    end
end

function BattleProxy:isClietCalculate()
  return analysis("Zhandoupeizhi_Zhanchangleixing",self.battleType,"qdjs") == 0
end

function BattleProxy:removeBattleAIOverTimer()
    if self.battleAIOverHandler then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.battleAIOverHandler)
        self.battleAIOverHandler = nil; 
    end
end

function BattleProxy:isAutoByType()
  local shoudong = analysis("Zhandoupeizhi_Zhanchangleixing",self.battleType,"shoudong");
  if shoudong == 0 then
    return true;
  end
  return false
end

function BattleProxy:isHandByUser(userProxy)
    if self.autoBattle == 0 and not self:isAutoByType() then
        return true
    else
        return false
    end
end

function BattleProxy:isQuickWuShuang(userProxy,operatonProxy)
    return analysis("Huiyuan_Huiyuantequan",16,"vip"..userProxy:getVipLevel())==1 and not operatonProxy.operationData[5].value;
end
---------------------------前端计算战斗--------------------------------------

function BattleProxy:makeBattleStar(isReset)
  if isReset then 
    self.starLevel = 0;
    return;
  end
  local dieCount = 0;
  for i,v in ipairs(self.battleOverPlayer) do
      local genVo = self.heroHouseProxy:getGeneralDataByConfigID(v);
      if not self:ChackDieGen(v) then 
        dieCount = dieCount+1;
      end
  end
  local strongPointPo = analysis("Juqing_Guanka", self.strongPointId)
  if dieCount <= strongPointPo.star3 then
     self.starLevel = 3;
  elseif dieCount <= strongPointPo.star2 then
    self.starLevel =2;
  elseif dieCount <= strongPointPo.star1 then
    self.starLevel =1;
  else
    self.starLevel =0;
  end
end
function BattleProxy:getBattleStar()
  return self.starLevel; 
end
function BattleProxy:ChackDieGen(generalID)
  for k,v in pairs(self.battleGeneralArray) do
    if v.generalID == generalID and v:getCurrHp()>0 then
      return true;
    end
  end
end

function BattleProxy:onRemove()
    -- self:removePlaybackHandlerTimer()
    self:removeBattleAITimer()
    self:removeBattleAIOverTimer()
    self:cleanAIBattle()
    if self.greenHandBattle then
        self.greenHandBattle:dispose()
        self.greenHandBattle = nil;
    end
end
