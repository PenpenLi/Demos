--  多拨怪物
Handler_7_19 = class(MacroCommand)

function Handler_7_19:execute()
    local battleProxy = self:retrieveProxy(BattleProxy.name)
    local generalMap;
    local dialogMiddle;
    local isLittleRound;
    if not battleProxy.handlerType then
        generalMap = recvTable["BattleGeneralArray"];
        dialogMiddle = recvTable["BooleanValue"];
        isLittleRound = false;
    elseif battleProxy.handlerType == "BattlePlaybackCommond" then
        local handlerData = battleProxy.handlerData;
        generalMap = handlerData.BattleGeneralArray
        dialogMiddle =handlerData.BooleanValue;
        isLittleRound = handlerData.IsLittleRound;
        battleProxy.handlerData = nil;
        battleProxy.handlerType = nil;
        package.loaded["main.controller.handler.Handler_7_19"] = nil
    end
    --local userProxy = self:retrieveProxy(UserProxy.name);
    
    battleProxy.battleNewGeneralArray = {}
    if not isLittleRound then 
        battleProxy:addWaveNumber();
    end
    --battleProxy:setLittleWaveNumber()
    --local allMonstersTable = analysisByName("Zhandoupeizhi_Guaiwupeizhi","id",battleProxy.battleFieldId)
    battleProxy.dialogMiddle = dialogMiddle;
    battleProxy.isLittleRound = isLittleRound;
    local monsterArray = {}
    for k2,v2 in pairs(generalMap) do
        local battleGeneralVO = {};
        battleGeneralVO.battleUnitID = v2.BattleUnitID;
		--print("Handler_7_19--unitID------------>>>>"..battleGeneralVO.battleUnitID)
		battleGeneralVO.userID = v2.UserId;
        if battleProxy.isNeedChange then
            battleGeneralVO.standPoint =  v2.StandPoint == BattleConfig.Battle_StandPoint_1 and BattleConfig.Battle_StandPoint_2 or BattleConfig.Battle_StandPoint_1;
        else
            battleGeneralVO.standPoint = v2.StandPoint;
        end
		battleGeneralVO.type = v2.Type;
		battleGeneralVO.generalID = v2.GeneralId;
		battleGeneralVO.level =  v2.Level;
		battleGeneralVO.currentHP = v2.CurrentHP;
		battleGeneralVO.maxHP = v2.MaxHP;
		battleGeneralVO.career = v2.Career;
		battleGeneralVO.coordinateX = v2.CoordinateX;
        battleGeneralVO.coordinateY = v2.CoordinateY;
        battleGeneralVO.speed = v2.Speed;
        battleGeneralVO.dropItem = v2.DropItem;
        battleGeneralVO.dropDaoju = v2.DropDaoju;
        battleGeneralVO.isScript = v2.isScript;
        battleGeneralVO.isMyFriend = v2.isMyFriend;
        battleGeneralVO.isMyHero = v2.isMyHero;
        battleGeneralVO.isMyPlayer = v2.isMyPlayer;
        
        if battleProxy.battleType ~= BattleConfig.BATTLE_TYPE_24 then
    		battleGeneralVO.itemIdBody = v2.ItemIdBody;
    		battleGeneralVO.itemIdWeapon = v2.ItemIdWeapon;
        else
            battleGeneralVO.itemIdBody,battleGeneralVO.itemIdWeapon = self:getItemID(v2,battleProxy)
        end
        self:setHeadImageID(battleGeneralVO,monsterArray,battleProxy);
        --BattleUtils:setIsBossMonster(battleGeneralVO,allMonstersTable,monsterArray)
        
        local skillMap = {};
        local skillHashMap =  v2.SkillArray;
        for k3,v3 in pairs(skillHashMap) do
            local id = v3.SkillId;
            local skillPO = analysis("Jineng_Jineng",id);
            skillPO.lv =  v3.Level;
            skillPO.id =  id;
            skillMap[id] = skillPO;
        end
        battleGeneralVO.skillMap = skillMap;
        battleProxy.battleNewGeneralArray[battleGeneralVO.battleUnitID] = battleGeneralVO;
        battleProxy.battleGeneralArray[battleGeneralVO.battleUnitID] = battleGeneralVO;
    end
    --BattleUtils:setMonsterDrop(battleProxy,allMonstersTable,monsterArray,battleProxy.waveNumber)
	battleProxy.rightBattleUnitID = self:getRightBattleUnitID(battleProxy.battleNewGeneralArray)
	local table = {type = "Handler_7_19"};
    
    self:addSubCommand(BattleInitCommand);  
    self:complete(table);
end

function Handler_7_19:getItemID(v2,battleProxy)
    if v2.Type == BattleConfig.BATTLE_OWER then
        local VO = battleProxy.battleUnitViewArray[v2.BattleUnitID];
        return VO.itemIdBody,VO.itemIdWeapon;
    else
        return 0,0;
    end
end

function Handler_7_19:setHeadImageID(generalVO,monsterArray,battleProxy)
    if generalVO.type == BattleConfig.BATTLE_PET and generalVO.type == BattleConfig.BATTLE_YONGBING then return;end;
    if generalVO.type == BattleConfig.BATTLE_MONSTER then
        local guaiwubiao = analysis("Guaiwu_Guaiwubiao",generalVO.generalID) 
        generalVO.headImage = guaiwubiao.headId
        generalVO.name = guaiwubiao.name
        if guaiwubiao.type == 3 then
            generalVO.isBoss = true;
            battleProxy.battleOverBossName = guaiwubiao.name;
            generalVO.bossSkill = guaiwubiao.skill
            generalVO.bossStopSkillTime = guaiwubiao.jnjztime
        elseif guaiwubiao.type == 2 then
            generalVO.isElite = true;
            generalVO.bossSkill = guaiwubiao.skill
            generalVO.bossStopSkillTime = guaiwubiao.jnjztime
        else
            monsterArray[generalVO.battleUnitID] = generalVO
        end
    else
        generalVO.headImage = analysis("Zhujiao_Zhujiaozhiye",generalVO.career,"touxiang") 
    end
end

local function sortOnIndex(a, b) return a.coordinateX < b.coordinateX end
function Handler_7_19:getRightBattleUnitID(generalArray)
    local standPointArr = {}
    for k1,v1 in pairs(generalArray) do
        if v1.standPoint == BattleConfig.Battle_StandPoint_2 then
            if v1.isBoss then
                return k1;
            end
            if v1.type ~= BattleConfig.BATTLE_PET and v1.type ~= BattleConfig.BATTLE_YONGBING then
                table.insert(standPointArr,v1)
            end
        end
    end
    table.sort(standPointArr,sortOnIndex)
    if standPointArr[1] then
        return standPointArr[1].battleUnitID
    end
end

Handler_7_19.new():execute();