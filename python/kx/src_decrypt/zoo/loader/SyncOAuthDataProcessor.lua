require "zoo.panel.QQSyncPanel"
require "zoo.panel.QQLoginSuccessPanel"
require "zoo.net.QzoneSyncLogic" 

local Processor = class(EventDispatcher)
Processor.events = {
    kSyncSuccess = "syncSuccess",
    kSyncCancel = "syncCancel",
    kSyncCancelLogout = "syncCancelLogout",
}

function Processor:start(openId, accessToken)
    local function onSyncFinish()
        print("sync qzone done. get user profile")
        _G.kUserSNSLogin = true -- 平台账号登录
        Localhost.getInstance():setCurrentUserOpenId(openId)

        local function onSuccessCallback(result)
            self:dispatchEvent(Event.new(self.events.kSyncSuccess, nil, self))
        end

        local function onErrorCallback(err,msg)
            self:dispatchEvent(Event.new(self.events.kSyncSuccess, nil, self))
        end

        local function onCancelCallback()
            self:dispatchEvent(Event.new(self.events.kSyncSuccess, nil, self))
        end
        SnsProxy:getUserProfile(onSuccessCallback,onErrorCallback,onCancelCallback)

        -- if PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) 
        --     or PlatformConfig:isPlatform(PlatformNameEnum.k360) 
        --     or PlatformConfig:isPlatform(PlatformNameEnum.kMI) 
        --     or __IOS_FB 
        --     or __IOS_QQ 
        --     then
        --     SnsProxy:syncSnsFriend()
        -- end
    end

    local function onSyncCancel()
        local logoutCallback = {
            onSuccess = function(result)
                self:dispatchEvent(Event.new(self.events.kSyncCancelLogout, nil, self))
            end,
            onError = function(errCode, msg) 
                self:dispatchEvent(Event.new(self.events.kSyncCancel, nil, self))
            end,
            onCancel = function()
                self:dispatchEvent(Event.new(self.events.kSyncCancel, nil, self))
            end
        }
        SnsProxy:logout(logoutCallback) 
    end

    local function onSyncError()
        local savedConfig = Localhost.getInstance():getLastLoginUserConfig()
        if savedConfig then
            local lastUser = Localhost.getInstance():readUserDataByUserID(savedConfig.uid)
            if openId and lastUser and openId == lastUser.openId then -- 本地已登录过的账号
                -- 同步数据异常
                local msg = Localization:getInstance():getText("loading.tips.register.failure."..kLoginErrorType.syncData)
                CommonTip:showTip(msg, "negative")

                onSyncFinish()
                return
            end
        end
        local msg = Localization:getInstance():getText("loading.tips.register.failure."..kLoginErrorType.changeUser)
        CommonTip:showTip(msg, "negative")
        onSyncCancel()
    end

    if __ANDROID and NetworkConfig.mockQzoneSk ~= nil then
        local function onUserInputSK( input )
            NetworkConfig.mockQzoneSk = input
            local logic = QzoneSyncLogic.new(openId, accessToken)
            logic:sync(onSyncFinish, onSyncCancel, onSyncError)
        end
        AlertDialogImpl:input( "Test SK", "Session key:", NetworkConfig.mockQzoneSk, "OK", "Cancel", onUserInputSK, nil)
    else
        local logic = QzoneSyncLogic.new(openId, accessToken)
        logic:sync(onSyncFinish, onSyncCancel, onSyncError)
    end
end

return Processor
