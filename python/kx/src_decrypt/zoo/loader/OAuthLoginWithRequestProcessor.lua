
local Processor = class(EventDispatcher)

function Processor:start(context)
    local function onSNSLoginResult( status, result )
        if status == SnsCallbackEvent.onSuccess then
            _G.sns_token = result
            self:dispatchEvent(Event.new(Events.kComplete, nil, self))
        else 
            self:dispatchEvent(Event.new(Events.kError, nil, self))
        end
    end

    if __IOS then
        if ReachabilityUtil:isNetworkReachable() then 
            SnsProxy:login(onSNSLoginResult)
        else 
            CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"), "negative",nil, 1)
            self:dispatchEvent(Event.new(Events.kCancel, nil, self))
        end
    else
        SnsProxy:login(onSNSLoginResult)
        -- if PlatformConfig:isPlatform(PlatformNameEnum.kMI) then
        --     require "zoo.panel.MiLoginSelectPanel"
        --     local function onSelect(authorType)
        --         if authorType then 
        --             SnsProxy:setAuthorizeType(authorType)
        --             SnsProxy:login(onSNSLoginResult)
        --         else
        --             self:dispatchEvent(Event.new(Events.kCancel, nil, self))
        --         end
        --     end

        --     local function onCancel()
        --         self:dispatchEvent(Event.new(Events.kCancel, nil, self))
        --     end

        --     local selectPanel = MiLoginSelectPanel:create(onSelect, onCancel)
        --     selectPanel:popout()
        -- else
        --     SnsProxy:login(onSNSLoginResult)
        -- end
    end 
end

return Processor
