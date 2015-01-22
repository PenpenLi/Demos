local Processor = {}

local function isIOSLowDevice()
    -- if string.find(deviceType, "iPhone3") ~= nil then isLowDevice = true end

    local result = false
    local frame = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
    local deviceType = MetaInfo:getInstance():getMachineType() or ""
    local physicalMemory = NSProcessInfo:processInfo():physicalMemory() or 0
    local freeMemory = AppController:getFreeMemory()
    local totalMemory = AppController:getTotalMemory()
    print("freeMemory.."..freeMemory.."/"..totalMemory)
    physicalMemory = physicalMemory / (1024 * 1024)
    if physicalMemory < 600 or frame.width < 400 then result = true end
    local systemVersion = AppController:getSystemVersion() or 7
    print(string.format("physicalMemory:%f systemVersion:%f", physicalMemory, systemVersion))
    if systemVersion < 7.0 then
        if string.find(deviceType, "iPhone4") ~= nil or string.find(deviceType, "iPad2") ~= nil or string.find(deviceType, "iPod5")~= nil then
            result = false
        end
    end

    if result then
        local isUserDefaultSet = CCUserDefault:sharedUserDefault():getStringForKey("game.userdef.texture")
        print("isUserDefaultSet:"..tostring(isUserDefaultSet))
        if isUserDefaultSet ~= "1" then
            --setting is nil
            AppController:registerDefaultsFromSettingsBundle(false) --not use default setting(default is YES)
            local falseVal = NSNumber:numberWithBool(false)
            local userDefault = NSUserDefaults:standardUserDefaults()
            userDefault:setValue_forKey(falseVal, "textures_preference")
            CCUserDefault:sharedUserDefault():setStringForKey("game.userdef.texture", "1")
            CCUserDefault:sharedUserDefault():flush()           
        else
            AppController:registerDefaultsFromSettingsBundle(true) --read user default.
        end 

        local userDefault = NSUserDefaults:standardUserDefaults()
        local userPref = userDefault:objectForKey("textures_preference")
        if userPref == 0 then
            --use low device
            print("NSUserDefaults:"..table.tostring(userPref))
        else
            result = false
        end
    end 
    return result
end

local function isAndroidLowDevice()
    local result = false
    local physicalMemory = luajava.bindClass("com.happyelements.hellolua.share.DisplayUtil"):getSysMemory()
    local frame = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
    physicalMemory = physicalMemory / (1024 * 1024)
    print(string.format("physicalMemory:%f ", physicalMemory))
    if physicalMemory < 600 or frame.width < 400 then result = true end
    if physicalMemory < 0 then result = false end
    return result
end

local function isWP8LowDevice()
    local frameSize = CCDirector:sharedDirector():getOpenGLView():getFrameSize()
    local result = frameSize.width < 500 and Wp8Utils:isLowMemoryDevice()
    _G.kUseSmallResource = result
    _G.__use_small_res = result
    return result
end

local function isLowDevice()
    if __IOS then
        return isIOSLowDevice()
    elseif __ANDROID then
        return isAndroidLowDevice()
    elseif __WP8 then
        return isWP8LowDevice()
    else
        return false
    end   
end

function Processor:start(completeCallback)
    local function safeReadConfig()
        _G.useSmallResConfig = StartupConfig:getInstance():getSmallRes() 
    end
    pcall(safeReadConfig)
    local isLow = false

    isLow = isLowDevice()

    if isLow == true then
        _G.__use_low_effect = true
    end

    if _G.useSmallResConfig == true then isLow = true end
    if kUseSmallResource and isLow then
        CCDirector:sharedDirector():setContentScaleFactor(0.625)
        _G.__use_small_res = true
    end
    completeCallback()
end

return Processor