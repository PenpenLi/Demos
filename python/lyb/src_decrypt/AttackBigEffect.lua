
AttackBigEffect = class();

function AttackBigEffect:ctor()
    self.class = AttackBigEffect;
    self.standY = 300;
    self.layerPositionX = 0
end

function AttackBigEffect:removeSelf()
    self.class = nil;
end

function AttackBigEffect:dispose()
    self:removeSelf();

end
function AttackBigEffect:playEffectData(generalVO,skillVO,battleProxy)
    self.battleProxy = battleProxy;
    if skillVO.typyP == 3 then
        self:playFirstEffectData(generalVO,skillVO)
        -- print("ppppppppppppppppppppppppppppppppppppppppppppppppppp22222",skillVO.id,CommonUtils:getOSTime())
    elseif skillVO.typyP == 2 then
        self:playDuangEffectData(generalVO,skillVO)
        self.battleProxy:refreshSkillCDTime(generalVO.battleUnitID)
    end
end

function AttackBigEffect:playDuangEffectData(generalVO,skillVO)
    if generalVO.type == GameConfig.BATTLE_MONSTER then
        self.battleProxy:onSkillContinue(generalVO);
        return 
    end
    local function createCartoon(gVO)
        local cartoon
        local function backfun()
            self.battleProxy:onSkillContinue(gVO);
            gVO.battleIcon:removeChild(cartoon)
        end
        cartoon = cartoonPlayer(1191,0,100,1,backfun,2.5,nil,nil)
        gVO.battleIcon:addChild(cartoon)
    end
    createCartoon(generalVO);
    if not skillVO.duangjnzdid or skillVO.duangjnzdid == 0 then 
        return 
    end
    generalVO.battleIcon:bodyRepeat(skillVO.duangjnzdid.."_5")
end

--第一段动画
function AttackBigEffect:playFirstEffectData(generalVO,skillVO)
    self.generalVO = generalVO;
    if generalVO.standPoint == BattleConstants.STANDPOINT_P2 then
        self:toAttackContinue(generalVO,skillVO)
        return 
    end
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):setVisible(false)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS):setVisible(false)
	local daoZhaoVO = analysis("Jineng_Dazhaobiao",skillVO.id)
	local QJeffects
    --黑背景
    self:removeBlackScreen1()
    self.blackScreen = LayerColorBackGround:getBackGround()
    self.blackScreen:setScale(2)
    self.blackScreen:setAlpha(0)
    self.blackScreen:setPositionY(-GameData.uiOffsetY)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(self.blackScreen);
    self.blackScreen:runAction(CCFadeIn:create(0.2));
    --流光
    self.liouguang = cartoonPlayer(daoZhaoVO.LGEffectID,GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2,0,nil,4.45)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(self.liouguang);
    local kapaiPO = analysis("Kapai_Kapaiku",generalVO.generalID)
    --特效1
    local BJeffects
    local function callBack()
        self:addRoleOnAttackLayer(generalVO,skillVO)
    end
    local function callBack2()
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(BJeffects)
    end
    BJeffects = cartoonPlayer(daoZhaoVO.BJeffectsID,GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2.5,1,nil,1,nil,nil)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(BJeffects)
    --头象
    self.headImage = getImageByArtId(kapaiPO.art1)
    self.headImage:setAnchorPoint(CCPointMake(0.5, 0.5));
    self.headImage:setPositionXY(self.headImage:getContentSize().width/2,self.headImage:getContentSize().height/2)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(self.headImage)
    self.headImage:setAlpha(0)
    local array = CCArray:create();
    array:addObject(CCFadeIn:create(0.2))
    array:addObject(CCDelayTime:create(1))
    local array2 = CCArray:create()
    array2:addObject(CCScaleTo:create(0.5,3))
    array2:addObject(CCFadeOut:create(0.5))
    local spawn = CCSpawn:create(array2);
    array:addObject(spawn)
    self.headImage:runAction(CCSequence:create(array))
    local QJeffects
    local function backfun()
        sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(QJeffects)
    end
    QJeffects = cartoonPlayer(daoZhaoVO.QJeffectsID,GameConfig.STAGE_WIDTH/2,GameConfig.STAGE_HEIGHT/2.5,1,backfun,1,nil,nil)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(QJeffects)
    --技能名字
    self.skillImage = getImageByArtId(skillVO.nameart)
    self.skillImage:setAnchorPoint(CCPointMake(0.5, 0.5));
    self.skillImage:setPositionXY(GameConfig.STAGE_WIDTH-self.skillImage:getContentSize().width,self.skillImage:getContentSize().height+50)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):addChild(self.skillImage)
    self.skillImage:setScale(4)
    self.skillImage:setAlpha(0)
    local array = CCArray:create();
    local array1 = CCArray:create()
    array1:addObject(CCScaleTo:create(0.5,2))
    array1:addObject(CCFadeIn:create(0.5))
    local spawn1 = CCSpawn:create(array1);
    array:addObject(spawn1)
    array:addObject(CCDelayTime:create(1))
    local array2 = CCArray:create()
    array2:addObject(CCScaleTo:create(0.3,4))
    array2:addObject(CCFadeOut:create(0.3))
    local spawn2 = CCSpawn:create(array2);
    local upCallBack = CCCallFunc:create(callBack);
    array:addObject(spawn2)
    array:addObject(upCallBack)
    local upCallBack1 = CCCallFunc:create(callBack2);
    array:addObject(upCallBack1)
    self.skillImage:runAction(CCSequence:create(array))
end

--第二段放大动画
function AttackBigEffect:addRoleOnAttackLayer(generalVO,skillVO)
    if not self.battleProxy.AIBattleField then self:removeBlackScreen() return end
    local playerLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS)
    playerLayer:setVisible(true)
    ScreenMove:setBigAttackVisible(false)
    self.originalPosition = generalVO.battleIcon:getPosition()
    self.layerPositionX = sharedBattleLayerManager().layer:getPositionX()
    self:setTwoTeamVisible(false)
    generalVO.battleIcon:setVisible(true)
    local function startFun()
        -- print("ppppppppppppppppppppppppppppppppppppppppppppppppppp333333",skillVO.id,CommonUtils:getOSTime())
        self:toAttackContinue(generalVO,skillVO)
        generalVO.battleIcon:setScalingTo(1)
    end
    Tweenlite:delayCallS(0,startFun);
    if generalVO.skillSoundArray and #generalVO.skillSoundArray ~= 0 then
      local len = math.random(#generalVO.skillSoundArray)
      MusicUtils:playEffect(generalVO.skillSoundArray[len],false)
    end
    self:middleAttack(generalVO,skillVO)
end
local function sortOnIndexX(a, b) return a.coordinateX < b.coordinateX end
function AttackBigEffect:middleAttack(generalVO,skillVO)
    print("key========================================================".. skillVO.editorid)
    local screenTable = BattleData.screenSkillArray["key".. skillVO.editorid]
    local standPoint;
    local tArray = {}
    local beNum = #generalVO:getAttackTargets()
    for key,buv in pairs(generalVO:getAttackTargets()) do
        standPoint = buv.standPoint;
        table.insert(tArray,buv)
        if beNum == 1 and skillVO.SkillSDJfanW == 1 then
            if standPoint ~= BattleConfig.Battle_StandPoint_1 then
                buv:onRestPos(850,self.standY)--策划给的坐标
            else
                buv:onRestPos(442-300,self.standY)--策划给的坐标
            end
        end
    end
    table.sort(tArray,sortOnIndexX)
    self.tempLayerMoveX = 0
    if standPoint == BattleConfig.Battle_StandPoint_1 then--友方
        self:layerPosition(300)
        self.tempLayerMoveX = 300
    else
        if screenTable.attackType == 9 then--远程
            self:layerPosition(0)
            generalVO:onRestPos(442,self.standY)--策划给的坐标
            self.tempLayerMoveX = 0
        elseif screenTable.attackType == 11 then--跑到敌方近战
            local moveX = tArray[1].coordinateX-200/2-GameConfig.STAGE_WIDTH/2
            self:layerPosition(-moveX)
            self.tempLayerMoveX = -moveX
        end
    end
end

function AttackBigEffect:layerPosition(layerX)
    sharedBattleLayerManager().layer:setPositionX(layerX)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN):setPositionX(-layerX)
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):setPositionX(-layerX)
    -- if self.liouguang then
    --     self.liouguang:setPositionX(self.liouguang:getPositionX()-layerX)
    --     self.blackScreen:setPositionX(self.blackScreen:getPositionX()-layerX)
    -- end
end

function AttackBigEffect:setTwoTeamVisible(bool)
    if not self.battleProxy.AIBattleField then self:removeBlackScreen() return end
    local firstMap = self.battleProxy.AIBattleField.secondTeam.bornUnitMap
    local secondMap = self.battleProxy.AIBattleField.firstTeam.bornUnitMap
    for key,buv in pairs(firstMap) do
        buv.battleIcon:setVisible(bool)
    end
    for key,buv in pairs(secondMap) do
        buv.battleIcon:setVisible(bool)
    end
end

--第三段攻击开始延时
function AttackBigEffect:toAttackContinue(generalVO,skillVO)
    self.battleProxy:onSkillContinue(generalVO);
    local targets = generalVO:getAttackTargets()
    for key,buv in pairs(targets) do
        buv.battleIcon:setVisible(true)
    end
    local function startFun()
        -- print("ppppppppppppppppppppppppppppppppppppppppppppppppppp444444",skillVO.id,CommonUtils:getOSTime())
        local beNum = #targets
        for key,buv in pairs(targets) do
            buv.actionManager:playDeadBigAttack()
            if beNum == 1 and skillVO.SkillSDJfanW == 1 then
                buv:onRestPos(buv.standPositionCcp.x,buv.standPositionCcp.y)
            end
        end
        self:layerPosition(self.layerPositionX)
        self:setTwoTeamVisible(true)
        self:removeBlackScreen()
        ScreenMove:setBigAttackVisible(true)
        generalVO:onRestPos(generalVO.standPositionCcp.x,generalVO.standPositionCcp.y)
        self.battleProxy:onBigSkill()
    end
    local attackTime = generalVO:getSelectSkill():getActionConfig():getCaskSkillTime(generalVO)
    Tweenlite:delayCall(sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN),(attackTime+200)/1000,startFun);
    local function deadChick()
        for key,buv in pairs(targets) do
            buv.actionManager:playDeadBigAttack()
        end
    end
    Tweenlite:delayCall(sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_SCREEN),(attackTime-400)/1000,deadChick);
end

function AttackBigEffect:removeBlackScreen()
    self:removeBlackScreen1()
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_UI):setVisible(true)
end

function AttackBigEffect:removeBlackScreen1()
    if not sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK) then return end 
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(self.blackScreen);
    self.blackScreen = nil
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(self.liouguang);
    self.liouguang = nil
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(self.headImage)
    self.headImage = nil
    sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_EFFECTS_BACK):removeChild(self.skillImage)
    self.skillImage = nil
end

