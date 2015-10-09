-----------
--particleSystem
-----------

SceneShift = {};

function SceneShift:shiftEffectRun(loadingMediator)
        local viewComponent = loadingMediator:getViewComponent()
        local eType = self:effectType();
        local eTypeBack = eType:reverse();
        local function backFun()
                local parent = loadingMediator:getViewComponent().parent;
                parent:removeChild(loadingMediator:getViewComponent(), false);
        end
    
        local array = CCArray:create();
        local callBack = CCCallFunc:create(backFun);
        array:addObject(eType);
        array:addObject(callBack);
        array:addObject(eTypeBack);
        viewComponent:runAction(CCSequence:create(array));
end

function SceneShift:effectType()
    local time = 0.8
    local typeId = math.random(6);
    --local typeId = 6;
    local eType;
    -- CCDirector:sharedDirector():setDepthTest(false)
    if typeId == 1 then
      eType = CCFadeOutTRTiles:create(ccg(16,12), time);
    elseif typeId == 2 then
      eType = CCFadeOutUpTiles:create(ccg(16,12), time);
    elseif typeId == 3 then
      eType = CCTurnOffTiles:create(25, ccg(48, 32), time);
    elseif typeId == 4 then
      eType = CCSplitRows:create(12, time);
    elseif typeId == 5 then
      eType = CCSplitCols:create(18, time);
    elseif typeId == 6 then
      -- CCDirector:sharedDirector():setDepthTest(true)
      eType = CCPageTurn3D:create(ccg(15,10), time);
    end
    return eType;
end

