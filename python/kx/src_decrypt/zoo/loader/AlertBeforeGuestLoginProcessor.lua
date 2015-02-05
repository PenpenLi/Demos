require "zoo.panel.QueryDialogPanel"

local Processor = class(EventDispatcher)

function Processor:start(platform)
    local function onConfirm()
        self:dispatchEvent(Event.new(Events.kComplete, nil, self))
    end

    local function onCancel()
        self:dispatchEvent(Event.new(Events.kCancel, nil, self))
    end

    _G.kPlayAsGuest = true
    if PlatformConfig:isQQPlatform() then 
        local panel = QueryDialogPanel:create(
            Localization:getInstance():getText("loading.tips.start.btn.guest", {platform=platform}),
            Localization:getInstance():getText("loading.tips.guest.mode.warnning", {platform=platform}),
            onConfirm, 
            onCancel
        )
        panel:popout()
    else 
        onConfirm()
    end
end

return Processor