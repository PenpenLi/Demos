
local Processor = class(EventDispatcher)

function Processor:start()
    if __IOS and not ReachabilityUtil.getInstance():isNetworkAvailable() then
        print("Network disabled on iOS? just return error for register, need to create a new user or use local data.")
        self:dispatchEvent(Event.new(Events.kError, nil, self))
        return
    end 

    local function onRegisterError( evt )
        if evt then evt.target:removeAllEventListeners() end
        print("register error")
        self:dispatchEvent(Event.new(Events.kError, nil, self))
    end

    local function onRegisterFinish( evt )
        evt.target:removeAllEventListeners()
        if kTransformedUserID ~= nil and kDeviceID ~= nil then
            local userId = kTransformedUserID
            local sessionKey = kDeviceID
            local platform = kDefaultSocialPlatform

            print("register finished", userId, sessionKey, platform)

            local loginInfo = { uid = userId, sk = sessionKey, p = platform }
            self:dispatchEvent(Event.new(Events.kComplete, loginInfo, self))
        else 
            onRegisterError() 
        end
    end 

    print("register new user")

    local http = RegisterHTTP.new()
    http:addEventListener(Events.kComplete, onRegisterFinish)
    http:addEventListener(Events.kError, onRegisterError)
    http:load()
end

return Processor
