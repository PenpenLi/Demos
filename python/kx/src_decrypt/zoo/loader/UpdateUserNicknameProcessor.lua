
require "zoo.panel.NickNamePanel"

local Processor = class(EventDispatcher)

local function updateUserName( userInput )
    local profile = UserManager.getInstance().profile
    if SnsProxy.profile.headUrl then
        profile.headUrl = SnsProxy.profile.headUrl
    end
    if SnsProxy.profile.nick then
        profile.name = SnsProxy.profile.nick
    end

    if kUserLogin and profile then                          
        local http = UpdateProfileHttp.new()
        profile:setDisplayName(userInput)

        local snsPlatform = nil
        local snsName = nil
        local authorizeType = SnsProxy:getAuthorizeType()
        if _G.sns_token then
            snsPlatform = PlatformConfig:getPlatformAuthName(authorizeType)
            if authorizeType ~= PlatformAuthEnum.kPhone then
                snsName = profile:getDisplayName()
            else
                snsName = Localhost:getLastLoginPhoneNumber()
            end

            profile:setSnsInfo(authorizeType,snsName,profile:getDisplayName(),profile.headUrl)
        end

        http:load(profile.name, profile.headUrl,snsPlatform,HeDisplayUtil:urlEncode(snsName))
        print("updateUserName:" .. profile.name .. " " .. tostring(profile.headUrl))
    end

end

local function updateUserDisplayNameBySNS()
    local nickname = SnsProxy.profile.nick or "";
    if nickname and nickname ~= "" then
        updateUserName(nickname)
        CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", nickname)
        CCUserDefault:sharedUserDefault():flush()
    end
end

local isShow = false
local requestUserNameTimes = 0
local function requestUserDisplayName()
    requestUserNameTimes = requestUserNameTimes + 1
    local profile = UserManager.getInstance().profile
    if __IOS then
        local nickname = SnsProxy.profile.nick or "";
        print("requestUserDisplayName nickname:" .. nickname)
        if nickname and nickname ~= "" then
            updateUserDisplayNameBySNS()
        else
            if profile and not profile:haveName() then
                local function onUIAlertViewCallback( alertView, buttonIndex )
                    if buttonIndex == 1 then
                        if alertView then
                            local textfield = alertView:textFieldAtIndex(0)
                            if textfield then 
                                local userInput = textfield:text()
                                if userInput and userInput ~= "" then
                                    updateUserName(userInput)

                                    CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", userInput)
                                    CCUserDefault:sharedUserDefault():flush()                           
                                -- else
                                --  if requestUserNameTimes < 3 then requestUserDisplayName() end
                                end
                            end
                        end
                    else
                        if kUserLogin then updateUserName("User"..tostring(profile.uid)) end
                    end             
                end
                
                local title = Localization:getInstance():getText("game.setting.panel.use.device.name.notice")
                local okLabel = Localization:getInstance():getText("button.cancel")
                local UIAlertViewClass = require "zoo.util.UIAlertViewDelegateImpl"
                local alert = UIAlertViewClass:buildUI(title, "", okLabel, onUIAlertViewCallback)
                alert:addButtonWithTitle(Localization:getInstance():getText("button.ok"))
                alert:setAlertViewStyle(2)

                local username = GameCenterSDK:getInstance():getLocalUserName()
                local textfield = alert:textFieldAtIndex(0)
                if textfield then textfield:setText(username) end
                alert:show()
            end
        end
    end

    if __ANDROID or __WIN32 then
        local nickname = SnsProxy.profile.nick or "";
        if nickname and nickname ~= "" then
            updateUserDisplayNameBySNS()
        elseif not isShow then
            if kUserLogin then 
                isShow = true
                local function onCallback(userInput)
                    if not userInput or userInput == "" then
                        userInput = Localization:getInstance():getText("game.setting.panel.use.device.name.default")
                    end
                    updateUserName(userInput)
                    CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", userInput)
                    CCUserDefault:sharedUserDefault():flush()
                end
                if profile and not (profile:haveName() or PrepackageUtil:isPreNoNetWork()) then
                    local panel = NickNamePanel:create(onCallback)
                    if panel then
                        local function onEnter()
                            panel:popout()
                        end
                        HomeScene:sharedInstance():runAction(CCCallFunc:create(onEnter))
                    end
                end
            end
        end
    end
    
    if __WP8 then
        local profile = UserManager.getInstance().profile
        if profile and profile:haveName() then
            return
        end
        local uname = CCUserDefault:sharedUserDefault():getStringForKey("game.devicename.userinput")
        if uname and uname ~= "" then
            return
        end
        local function inputCallback(result, userInput)
            if result then
                if not userInput or userInput == "" then
                    userInput = Localization:getInstance():getText("game.setting.panel.use.device.name.default")
                end

                if userInput and userInput~="" then
                    updateUserName(userInput)
                    CCUserDefault:sharedUserDefault():setStringForKey("game.devicename.userinput", userInput)
                    CCUserDefault:sharedUserDefault():flush()                           
                -- else
                --  if requestUserNameTimes < 3 then requestUserDisplayName() end
                end
            else
                print("Info - Keypad Callback: user input cancel")
                if kUserLogin and UserManager:getInstance():isPlayerRegistered() and UserManager:getInstance().uid then
                    updateUserName("User"..tostring(UserManager:getInstance().uid))
                end
            end
        end
        Wp8Utils:OpenEditBox(Localization:getInstance():getText("game.setting.panel.use.device.name.notice"), "", -1, 0, -1, inputCallback) 
    end
    
end

function Processor:start()
    if _G.kUserSNSLogin and SnsProxy:getAuthorizeType() ~= PlatformAuthEnum.kPhone then
        updateUserDisplayNameBySNS()
    else
        requestUserDisplayName()
    end
end

return Processor
