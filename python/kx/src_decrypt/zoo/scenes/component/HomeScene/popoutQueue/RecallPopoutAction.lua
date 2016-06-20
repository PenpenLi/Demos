RecallPopoutAction = class(HomeScenePopoutAction)
function RecallPopoutAction:ctor(recallState, popoutCallback)
    self.popoutCallback = popoutCallback
    self.recallState = recallState
end

function RecallPopoutAction:popout()

    local function closeCallback()
        self:next()
    end
    if self.recallState == RecallRewardType.LEVEL_SHORT then
        TurnTablePanel:tryCreateRecallTurnTable(1, closeCallback)
    elseif self.recallState == RecallRewardType.LEVEL_MIDDLE then
        TurnTablePanel:tryCreateRecallTurnTable(2, closeCallback)
    elseif self.recallState == RecallRewardType.LEVEL_LONG then
        local recallItemPanel = RecallItemPanel:create()
        if recallItemPanel then 
            recallItemPanel:popout(closeCallback) 
        end
    elseif self.recallState == RecallRewardType.AREA_SHORT or 
           self.recallState == RecallRewardType.AREA_MIDDLE or 
           self.recallState == RecallRewardType.AREA_LONG then

        local found = false
        if HomeScene:sharedInstance().worldScene then 
            local lockedCloudsTable = HomeScene:sharedInstance().worldScene.lockedClouds
            if lockedCloudsTable then 
                for i,v in ipairs(lockedCloudsTable) do
                    if v.state == LockedCloudState.WAIT_TO_OPEN then 

                        v:handleWaitToOpen(closeCallback)
                        found = true
                        
                    end
                end
            end
        end
        if not found then -- 保证所有分支都覆盖到
            closeCallback()
        end
    end
    if self.popoutCallback then
        self.popoutCallback()
    end
end

function RecallPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end