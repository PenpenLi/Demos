if not __SYSTEM_CONTEXT then __SYSTEM_CONTEXT = true

    local androidToastProxy = nil
    local androidStorageProxy = nil
    local androidInfoProxy = nil
    
    if CommonUtils:getCurrentPlatform() == 2 then
        androidToastProxy = luajava.newInstance("com.happyelements.android.bridging.AndroidContextBridge")
        -- androidStorageProxy = luajava.newInstance("com.happyelements.android.bridging.AndroidStorageBridge")
        androidInfoProxy = luajava.newInstance("com.happyelements.android.bridging.AndroidDeviceInfoBridge")
    end
    
    system = {}
    system.toast = function(message)
        if androidToastProxy and message then androidToastProxy:postToast(message) end
    end
    system.saveString = function(key, value)
        if androidStorageProxy then androidStorageProxy:setString(key, value) end
    end
    system.loadString = function(key, defaultValue)
        if androidStorageProxy then 
            return androidStorageProxy:getString(key, defaultValue) 
        else 
            return defaultValue
        end
    end
    system.saveInteger = function(key, value)
        if androidStorageProxy then androidStorageProxy:setInteger(key, value) end
    end
    system.loadInteger = function(key, defaultValue)
        if androidStorageProxy then 
            return androidStorageProxy:getInteger(key, defaultValue) 
        else
            return defaultValue
        end
    end
   
   -- get device info
   system.getInstallKey = function()
       if androidInfoProxy then return androidInfoProxy:getInstallKey() end
   end
   system.getLocation = function()
       if androidInfoProxy then return androidInfoProxy:getLocation() end
   end
   system.getIpAddress = function()
       if androidInfoProxy then return androidInfoProxy:getIpAddress() end
   end
   system.getMacAddress = function()
       if androidInfoProxy then return androidInfoProxy:getMacAddress() end
   end
   system.isJailbreak = function()
       if androidInfoProxy then return androidInfoProxy:isJailbreak() end
   end
   system.getTimeZone = function()
       if androidInfoProxy then return androidInfoProxy:getTimeZone() end
   end
    system.isNewInstalled = function()
       if androidInfoProxy then return androidInfoProxy:isNewInstalled() end
   end
   system.getOsVersion = function()
       if androidInfoProxy then return androidInfoProxy:getOsVersion() end
   end
   system.getDeviceName = function()
       if androidInfoProxy then return androidInfoProxy:getDeviceName() end
   end
end
