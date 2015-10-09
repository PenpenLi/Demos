
FightUIPower=class(Layer);

function FightUIPower:ctor()
	self.class=FightUIPower;
    self.powerUpArray = {}
    self.positionArray = {}
end

function FightUIPower:removeSelf()
    self.class = nil;
end

function FightUIPower:dispose()
    self:removeSelf();
    self.skeleton = nil
    self.fightUI = nil
    self.armature:dispose()
    self:removePowrTimer()
    self.armature = nil
    self.powerUpArray = nil
    self.battleProxy = nil
end

function FightUIPower:initPowerUI(skeleton,battleProxy,fightUI)
	self.skeleton = skeleton;
    self.battleProxy = battleProxy;

    self.powerNum = BattleConfig.Max_Power_Num --怒气槽个
    if self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_4 then
        self.powerStartNum = 7
    elseif self.battleProxy.battleType == BattleConfig.BATTLE_TYPE_3 then
        self.powerStartNum = battleProxy.currentRageTemp/BattleUtils:getPowerSecondNum(self.battleProxy)
        battleProxy.currentRageTemp = nil
    else
        local min = analysis("Zhandoupeizhi_Zhanchangleixing",self.battleProxy.battleType,"min")
        local max = analysis("Zhandoupeizhi_Zhanchangleixing",self.battleProxy.battleType,"max")
        self.powerStartNum = math.random(min,max) -- 起始怒气个数
    end
    self.powerTotalNum = self.powerNum * BattleUtils:getPowerSecondNum(self.battleProxy);--怒气总数量
    local currentPowerNum = self.powerStartNum * BattleUtils:getPowerSecondNum(self.battleProxy) --当前怒气数量
    self.battleProxy:setCurrentPowerNum(currentPowerNum)
    
    self.fightUI = fightUI;
	local armature=self.skeleton:buildArmature("power7_ui");
    armature.animation:gotoAndPlay("f1");
    armature:updateBonesZ();
    armature:update();
    self.armature = armature
    local armature_d=armature.display;
    
    local powerBatchLayer = BatchLayer.new();
    powerBatchLayer:initBatchLayer(skeleton)
    self.barPositionX,self.barPositionY = (GameConfig.STAGE_WIDTH-armature_d:getGroupBounds(false).size.width)/2,5
    powerBatchLayer:setPositionXY(self.barPositionX,self.barPositionY)
    self:addChild(powerBatchLayer)

    local bg = skeleton:getBoneTextureDisplay("power"..self.powerNum.."_bg")
    powerBatchLayer:addChild(bg);

    for i=1,self.powerNum do
        local power_upP = armature_d:getChildByName("power_up"..i):getPosition()
        local power_up = skeleton:getBoneTextureDisplay("power_up")
        power_up:setPositionXY(power_upP.x,power_upP.y-18)
        powerBatchLayer:addChild(power_up);
        table.insert(self.powerUpArray,power_up)
        table.insert(self.positionArray,ccp(power_upP.x,power_upP.y-18))
    end

    self.powerBar = ProgressBarSkeleton.new(skeleton,"power_up")
    self:addChild(self.powerBar);
    self.powerBar:setProgress(1)
    self.powerBar:setVisible(false)
end

function FightUIPower:startAddPowerTimer()
    self:removePowrTimer()
    local function timerLoop()
        if ScreenMove.stopScreenMove then return end
        if self.battleProxy::isPauseBattle() then return end
        if self.battleProxy.lastAttackData_7_6 then 
            self:removePowrTimer()
            return 
        end
        if not self.battleProxy:getCurrentPowerNum() then
            self:removePowrTimer()
            return
        end
        local currentPowerNum = self.battleProxy:getCurrentPowerNum() + 1
        currentPowerNum = currentPowerNum > self.powerTotalNum and self.powerTotalNum or currentPowerNum
        self.battleProxy:setCurrentPowerNum(currentPowerNum)
        self:refreshPowerValue()
        self.fightUI:refreshCDComplete()
    end
    self.timerHandler = Director:sharedDirector():getScheduler():scheduleScriptFunc(timerLoop, 1, false)
end

function FightUIPower:refreshPowerValue()
    if not self.battleProxy:getCurrentPowerNum() then
        return
    end
    local num = self:getPowerNum()
    if num > self.powerNum then return end
    self.powerBar:setVisible(false)
    for key,power_up in pairs(self.powerUpArray) do
        if key <= num then
            power_up:setVisible(true)
        else
            if math.floor(num+1) == key then
                local percent = (self.battleProxy:getCurrentPowerNum()%BattleUtils:getPowerSecondNum(self.battleProxy))/BattleUtils:getPowerSecondNum(self.battleProxy)
                self.powerBar:setProgress(percent)
                self.powerBar:setVisible(true)
                local position = self.positionArray[key]
                self.powerBar:setPositionXY(self.barPositionX+position.x,self.barPositionY+position.y)
            end
            power_up:setVisible(false)
        end
    end
end

function FightUIPower:getPowerActionPositionXY()
    local pNum = math.ceil(self:getPowerNum())
    local number = pNum > self.powerNum and self.powerNum or pNum
    local position = self.positionArray[number]
    return self.barPositionX+position.x,self.barPositionY+position.y
end

function FightUIPower:getPowerNum()
    return self.battleProxy:getCurrentPowerNum()/BattleUtils:getPowerSecondNum(self.battleProxy)
end

function FightUIPower:setPowerCurrentNum(needRage)
    if not self.battleProxy:getCurrentPowerNum() then
        return
    end
    local number = self.battleProxy:getCurrentPowerNum() - needRage*BattleUtils:getPowerSecondNum(self.battleProxy)
    number = number > self.powerTotalNum and self.powerTotalNum or number
    local currentPowerNum = number < 0 and 0 or number
    self.battleProxy:setCurrentPowerNum(currentPowerNum)
end

function FightUIPower:removePowrTimer()
    if self.timerHandler then
        Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.timerHandler);
        self.timerHandler = nil
    end
end


