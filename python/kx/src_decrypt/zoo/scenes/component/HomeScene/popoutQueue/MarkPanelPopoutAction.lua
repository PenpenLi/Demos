
MarkPanelPopoutAction = class(HomeScenePopoutAction)

function MarkPanelPopoutAction:ctor()
    print('MarkPanelPopoutAction')
end

function MarkPanelPopoutAction:popout( ... )
    local function closeCallback()
        self:next()
    end
    local panel = HomeScene:sharedInstance():tryPopoutMarkPanel(false, closeCallback)
    if not panel then
        self:placeholder()
        self:next()
    end
end


function MarkPanelPopoutAction:getConditions( ... )
    return {"enter","enterForground","preActionNext"}
end