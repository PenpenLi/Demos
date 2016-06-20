GivebackPopoutAction = class(HomeScenePopoutAction)
function GivebackPopoutAction:ctor()

end

function GivebackPopoutAction:popout()

    local indexes = GiveBackPanelModel:getCompenIndexes()
    local count = 0
    local total = #indexes

    if total == 0 then
        self:placeholder()
        self:next()
        return
    end

    local function panelCloseCallback() 
        count = count + 1
        if count >= total then
            self:next()
        end
    end

    for k, v in ipairs(indexes) do
        local panel = GiveBackPanel:create(v)
        if panel then panel:popout(panelCloseCallback) end
    end
end

function GivebackPopoutAction:getConditions( ... )
    return {"enter","enterForground"}
end