-----------
--ScreenMove
-----------
ScreenMove = {};

function ScreenMove:dispose()
    self.playerLayer = nil
    self:removeIndexTimer()
end

function ScreenMove:initChildIndex(battleProxy)
    self.playerLayer = sharedBattleLayerManager():getLayer(BattleConfig.Battle_LAYER_PLAYERS);
    self.firstTeam = battleProxy.AIBattleField.firstTeam
    self.secondTeam = battleProxy.AIBattleField.secondTeam
    self:removeIndexTimer()
    local function indexTimer()
        self:refresh_Role_ChildIndex()
    end
    self.indexTimer = Director:sharedDirector():getScheduler():scheduleScriptFunc(indexTimer, 0, false)
end

function ScreenMove:makSortArray(generalSortArray,battleUniMap)
    for key,child in pairs(battleUniMap) do
        if child.battleIcon then
            child.py = child.battleIcon:getPositionY()
            child.px = child.battleIcon:getPositionX()
            if child.py then
                table.insert(generalSortArray, child)
            end
        end
    end
end
--深度排序
local function sortOnIndeY(a, b) 
    if a.py > b.py then
        return true
    else
        if a.py == b.py then
            if a.keyTemp < b.keyTemp then
                return true
            else
                return false
            end
        else
            return false
        end
    end
end
function ScreenMove:refresh_Role_ChildIndex()
    local generalSortArray = {}
    if not self.playerLayer:getChildren() then
        self:removeIndexTimer()
        return
    end
    for key,child in pairs(self.playerLayer:getChildren()) do
        if child:getPositionY() then
            local reduceY = child.name == BattleConfig.Is_Fly_Effect and 100 or 0
            child.py = child:getPositionY() - reduceY
            child.px = child:getPositionX()
            child.keyTemp = key
            table.insert(generalSortArray, child)
        end
    end

    table.sort(generalSortArray,sortOnIndeY)
    for key,child in pairs(generalSortArray) do
        self.playerLayer:setChildIndex(child, key);
        if child.roleShadow then
            child.roleShadow:setPositionXY(child:getPositionX(),child:getPositionY())   
        end
    end
end

function ScreenMove:setBigAttackVisible(bool)
    for key,child in pairs(self.playerLayer:getChildren()) do
        if child:getPositionY() and child.name ~= BattleConfig.Is_Player_Role then
            child:setVisible(bool)
        end
    end
end

function ScreenMove:removeIndexTimer()
    if self.indexTimer then
      Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.indexTimer);
      self.indexTimer = nil;
    end
end
