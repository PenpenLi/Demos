--   "初始化战场命令" 

require "main.model.BattleProxy"
require "main.controller.notification.BattleSceneNotification"
require "main.managers.BattleData"
require "main.managers.GameData";

Handler_7_1 = class(MacroCommand)

function Handler_7_1:execute()
    require "core.utils.MathUtils"
    require "main.controller.command.battleScene.BattleMoveCommand"
    require "main.controller.command.battleScene.BattleSkillCommand"
    require "main.controller.command.battleScene.BattleChangeHPCommand"
    require "main.controller.command.battleScene.BattleDialogMiddleCommand"
    require "main.controller.command.battleScene.BattleEffectCommand"
    require "main.controller.command.battleScene.BattleOverCommand"
    require "main.controller.command.battleScene.BattleUnitDeadCommand"
    require "main.controller.notification.BattleSceneNotification"
    require "main.controller.command.battleScene.battle.battlefield.BattleUtils"
    require "main.controller.command.battleScene.battle.battlefield.unit.impl.BaseBtlUnit"
    require "main.controller.command.battleScene.battle.battlefield.config.BattleConstants"
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local userProxy = self:retrieveProxy(UserProxy.name);
    --log("=========================test====================001")
    local battleId;
    local btlModeId;
    local battleFieldId;
    local userMap;
    local generalMap;
    local battleUnitIDMap;
    local mapId;

    battleId = recvTable["BattleId"]
    battleFieldId = recvTable["BattleFieldId"];
    mapId = recvTable["mapId"];
    btlModeId = recvTable["BattleTemplateId"];
    MathUtils:setSeed(recvTable["RandomSeed"]);
    userMap = recvTable["BattleUserArray"];
    generalMap = recvTable["BattleGeneralArray"];
    UnitIDMap = recvTable["BattleUnitIDArray"];

    battleProxy.battleStatus = BattleConfig.Battle_Status_3;
    battleProxy.needDebug = recvTable["BooleanValue"] == 1;
    battleProxy.itemIdArray = recvTable["ItemIdArray"]

    battleProxy.loadFailed = nil;
    battleProxy.battleId = battleId;
    battleProxy.btlModeId = btlModeId;
    battleProxy.battleFieldId = battleFieldId;
    local battleTabel = analysis("Zhandoupeizhi_Zhanchangpeizhi",battleProxy.battleFieldId);
    battleProxy.battleType = battleTabel.type;--战场类型
    battleProxy.mapId = battleTabel.map;
    -- if battleProxy.battleType == BattleConfig.BATTLE_TYPE_3 then
    --     BattleConstants.Rage_Per_Second = analysis("Xishuhuizong_Xishubiao",1059,"constant");
    -- else
    --     BattleConstants.Rage_Per_Second = analysis("Xishuhuizong_Xishubiao",1021,"constant");
    -- end
    BattleConstants.Rage_Kill_One = analysis("Xishuhuizong_Xishubiao",1022,"constant");--可以放到battleProxy
    BattleConstants.Rage_BeAttack = analysis("Xishuhuizong_Xishubiao",1023,"constant");
    
    local battleUserMap = {};
    for k,v in pairs(userMap) do
        local btlUnit = BaseBtlUnit.new();
        btlUnit.userId = v.UserId;
        btlUnit.standPoint = v.StandPoint;
        btlUnit.userName = v.UserName;
        btlUnit.career = v.Career; 
        btlUnit.standPoint =  v.StandPoint;
        btlUnit.battleUnitID = v.BattleUnitID;
        battleUserMap[btlUnit.battleUnitID] = btlUnit;
    end
    battleProxy.battleUserArray = battleUserMap;
    
    local battleGeneralMap = {};
    battleProxy.myHeroRoleArray = {}
    battleProxy.battleOverPlayer = {};
    for k2,v2 in pairs(generalMap) do
        local btlUnit = BaseBtlUnit.new();
        btlUnit.battleUnitID = v2.BattleUnitID;
		btlUnit.userID = v2.UserId;
        btlUnit.standPoint = v2.StandPoint;
		btlUnit.type = v2.Type;
		btlUnit.generalID = v2.GeneralId;
        btlUnit.career = v2.Career;
		btlUnit.level =  self:getLevel(v2,battleGeneralMap,battleProxy);
        btlUnit.condtion,btlUnit.wave = BattleUtils:getHeroContion(battleProxy,btlUnit.generalID)
        btlUnit.standPosition = v2.Place;
        local skillMap = {};
        local skillHashMap =  v2.SkillArray;
         print("standPosition "..btlUnit.standPosition.."  v2.StandPoint  "..v2.StandPoint)
        for k3,v3 in pairs(skillHashMap) do
            print("battleUnitID ",v2.BattleUnitID,v3.ConfigId,v3.Level)
            local skillPO = analysis("Jineng_Jineng",v3.ConfigId);
            skillPO.level =  v3.Level and v3.Level or 1;
            skillMap[v3.ConfigId] = skillPO;
        end
        btlUnit.skillMap = skillMap;
        btlUnit:initPropertyValues(v2.UnitPropertyArray);
        local kapaikuPO = analysis("Kapai_Kapaiku",btlUnit.generalID);
        btlUnit.headImage = kapaikuPO.touxiang
        btlUnit.suDu = kapaikuPO.suDu;
        btlUnit.attfury = kapaikuPO.attfury;
        btlUnit.deffury = kapaikuPO.deffury;
        btlUnit.killfury = kapaikuPO.killfury;
        btlUnit.maxRage = kapaikuPO.fury;
        if btlUnit.standPoint == BattleConstants.STANDPOINT_P1 then
            if btlUnit.type == BattleConfig.BATTLE_OWER then
                btlUnit.isMyPlayer = true;
                table.insert(battleProxy.battleOverPlayer,v2.GeneralId);
            elseif btlUnit.type == BattleConfig.BATTLE_PET then
                btlUnit.isMyHero = true;
                table.insert(battleProxy.myHeroRoleArray,btlUnit)
                table.insert(battleProxy.battleOverPlayer,v2.GeneralId);
            elseif btlUnit.type == BattleConfig.BATTLE_YONGBING then
                btlUnit.isMyHero = true;
                table.insert(battleProxy.myHeroRoleArray,btlUnit)
            elseif btlUnit.type == BattleConfig.BATTLE_FRIEND then
                btlUnit.isMyFriend = true;
            end
        end
        btlUnit:initData();
        battleGeneralMap[btlUnit.battleUnitID] = btlUnit;
    end
    

    for k4,v4 in pairs(UnitIDMap) do
        local btlUnit = BaseBtlUnit.new();
        btlUnit.battleUnitID = v4.BattleUnitID;
        btlUnit.standPoint = BattleConstants.STANDPOINT_P2;
        btlUnit.type = GameConfig.BATTLE_MONSTER;
        btlUnit.generalID = v4.MonsterId;
        btlUnit.level =  v4.Level;
        btlUnit.wave =  v4.Round;
        btlUnit.standPosition = v4.Place;
        btlUnit.attfury = 0;
        btlUnit.deffury = 0;
        btlUnit.killfury = 0;
        btlUnit.maxRage = 0;
        btlUnit:configMonsterData();
        btlUnit:initData();
        battleGeneralMap[btlUnit.battleUnitID] = btlUnit;
    end
    battleProxy.battleUnitIDArray = UnitIDMap;
    battleProxy.battleGeneralArray = battleGeneralMap;

    --log("=========================test====================003")
    --self:addSubCommand(MainSceneCloseCommand)
    local sceneType = battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_4 and GameConfig.SCENE_TYPE_3 or GameConfig.SCENE_TYPE_2
	local data = {type = sceneType, value = "Handler_7_1"};
    -- log("zhangke---------2")
    self:addSubCommand(BeginLoadingSceneCommand)
    --log("=========================test====================004")
    self:complete(LoadingNotification.new(LoadingNotifications.BEGIN_LOADING_SCENE, data))  
    --log("=========================test====================005")
    if getTextAnimateRewardInstance() then
       local scene = Director.sharedDirector():getRunningScene();
       scene:removeChild(getTextAnimateRewardInstance(), false)
       scene:addChild(getTextAnimateRewardInstance());
    end
    -- log("zhangke---------3")
    uninitializeSmallLoading()
    self:registerBattleCommands()

    -- 打点
    local extensionTable = {}
    extensionTable["type"] = battleProxy.battleType
    extensionTable["battleID"] = battleProxy.battleId;
    extensionTable["zhanchangID"] = battleProxy.battleFieldId;

    if  battleProxy.battleType == BattleConfig.BATTLE_TYPE_1 or battleProxy.battleType == BattleConfig.BATTLE_TYPE_10 then
        local storyLineProxy = self:retrieveProxy(StoryLineProxy.name)
        if storyLineProxy:getStrongPointState(battleProxy.battleFieldId) == 1 then
            GameVar.firstfight = 0;
        else
            GameVar.firstfight = 1;
        end
        extensionTable["firstfight"] = GameVar.firstfight
    end

    hecDC(6, 1, nil, extensionTable)
    self:removeTimeOutHandle()
    local function timeOutHandle()
        self:removeTimeOutHandle()
        --log("====================Battle_Status_3======================02")
        self:init_Battle_AI(battleProxy)
    end
    self.timeOutHandle = Director:sharedDirector():getScheduler():scheduleScriptFunc(timeOutHandle, 0, false)
end

function Handler_7_1:removeTimeOutHandle()
    if self.timeOutHandle then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timeOutHandle);
        self.timeOutHandle = nil
    end
end
function Handler_7_1:init_Battle_AI(battleProxy)
    
    --log("====================Battle_Status_3======================03")
    local storyLineProxy = self:retrieveProxy(StoryLineProxy.name);
    local userProxy = self:retrieveProxy(UserProxy.name);
    local operatonProxy = self:retrieveProxy(OperationProxy.name);
    local heroHouseProxy = self:retrieveProxy(HeroHouseProxy.name);
    local generalListProxy = self:retrieveProxy(GeneralListProxy.name);
    battleProxy:initBattleAI(storyLineProxy,userProxy,operatonProxy,heroHouseProxy,generalListProxy)
end
--多波玩家时取得名字
function Handler_7_1:getName(battleUnitID,battleUserMap)
    for k,v in pairs(battleUserMap) do
        if v.battleUnitID == battleUnitID then
            return v.userName,v.standPoint;
        end
    end
end

--怪物可能为0的级别,保持与玩家等级一样
function Handler_7_1:getLevel(v2,battleGeneralMap,battleProxy)
    if v2.Level ~= 0 then
        return v2.Level
    else
        if battleGeneralMap[battleProxy.myBattleUnitID] then
            return battleGeneralMap[battleProxy.myBattleUnitID].level;
        else
            return v2.Level
        end
    end
end

function Handler_7_1:registerBattleCommands()
    self:registerCommand(BattleSceneNotifications.Battle_UnitID_Dead,BattleUnitDeadCommand);
    self:registerCommand(BattleSceneNotifications.Battle_UnitID_Hurt,BattleChangeHPCommand);
    self:registerCommand(BattleSceneNotifications.BATTLE_MIDDLE_DIALOG,BattleDialogMiddleCommand);
    require "main.controller.command.battleScene.BattleExitCloseCommand"
    self:registerCommand(BattleSceneNotifications.BATTLE_EXIT,BattleExitCloseCommand);
end

Handler_7_1.new():execute();