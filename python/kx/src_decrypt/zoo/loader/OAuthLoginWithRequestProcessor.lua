
local Processor = class(EventDispatcher)

function Processor:start(context)

    local authorType = SnsProxy:getAuthorizeType()

    local function onSNSLoginResult( status, result )
        if status == SnsCallbackEvent.onSuccess then
            _G.sns_token = result
            _G.sns_token.authorType = authorType
            self:dispatchEvent(Event.new(Events.kComplete, nil, self))
        else 
            self:dispatchEvent(Event.new(Events.kError, nil, self))
        end
    end

    if __IOS then
        if ReachabilityUtil:isNetworkReachable() then 
            local logoutCallback = {
                onSuccess = function(result)
                    SnsProxy:login(onSNSLoginResult)
                end,
                onError = function(errCode, msg) 
                    SnsProxy:login(onSNSLoginResult)
                end,
                onCancel = function()
                    SnsProxy:login(onSNSLoginResult)
                end
            }
            SnsProxy:logout(logoutCallback)
        else 
            CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"), "negative",nil, 1)
            self:dispatchEvent(Event.new(Events.kCancel, nil, self))
        end
    else

        local logoutCallback = {
            onSuccess = function(result)
                SnsProxy:login(onSNSLoginResult)
            end,
            onError = function(errCode, msg) 
                SnsProxy:login(onSNSLoginResult)
            end,
            onCancel = function()
                SnsProxy:login(onSNSLoginResult)
            end
        }
        SnsProxy:logout(logoutCallback)


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
