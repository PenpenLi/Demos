
local Processor = class(EventDispatcher)

function Processor:start()
    local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
    local userData = Localhost:getInstance():readUserDataByUserID(savedConfig.uid)
    local token = {openId = userData.openId }
    _G.sns_token = token

    -- 360平台sns cache登录后, 360的好友邀请功能有bug, cache过后登录需要重新sns登录, 离线时SnsLogin走360的离线登录逻辑
    if PlatformConfig:isPlatform(PlatformNameEnum.k360) then
        self:dispatchEvent(Event.new(Events.kError, nil, self))
    else 
        self:dispatchEvent(Event.new(Events.kComplete, nil, self))
    end
end

return Processor
