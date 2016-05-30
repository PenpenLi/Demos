local Processor = class(EventDispatcher)
local kStorageFileName = "levelUpdate.inf"
local kTestDecodeFilename = "testLevelUpdate.inf"
local kLevelUpdateVersionFileName = "levelUpdateVersion"
local mime = require("mime.core")

function Processor:hasStorageConfig()
	local path = HeResPathUtils:getUserDataPath() .. "/" .. kStorageFileName
	local file, err = io.open(path, "r")

	if file and not err then
		local content = file:read("*a")
		io.close(file)
		if content then
			return content
		end
	end
    return nil
end

function Processor:getStorageConfig()
	if self:hasStorageConfig() then
		local path = HeResPathUtils:getUserDataPath() .. "/" .. kStorageFileName
		local decodeContent = HeFileUtils:decodeFile(path)
		if decodeContent and decodeContent ~= "" then
			return decodeContent
		end
	end
    return nil
end

function Processor:writeNewConfigVersion(version)
	version = version or ""

	local filePath = HeResPathUtils:getUserDataPath() .. "/" .. kLevelUpdateVersionFileName
	local file, err = io.open(filePath, "wb")
    if file and not err then
    	local success = file:write(tostring(version))
    	if success then
            file:flush()
            file:close()
            return true
        end
    end

    assert(false, "writeNewLevelUpdateConfigVersion failed:"..tostring(version))

    return false
end

function Processor:readLocalConfigVersion()
	local filePath = HeResPathUtils:getUserDataPath() .. "/" .. kLevelUpdateVersionFileName
	local file = io.open(filePath, "rb")
	if file then
		local version = file:read("*a") 
		file:close()
		return version
	end
	return nil
end

function Processor:writeNewConfigToStorage(config, isTestDecode)
	local fileName = nil
	if isTestDecode then
		fileName = kTestDecodeFilename
	else
		fileName = kStorageFileName .. "." .. os.time()
	end
    local filePath = HeResPathUtils:getUserDataPath() .. "/" .. fileName
    local file, err = io.open(filePath, "wb")

    if file and not err then
        local success = file:write(config)
       
        if success then
            file:flush()
            file:close()
            if not isTestDecode then
	            local realFilePath = HeResPathUtils:getUserDataPath() .. "/" .. kStorageFileName
		        os.remove(realFilePath)
		        os.rename(filePath, realFilePath)
            end
            print("write file success")
            return true
        else
            file:close()
	        os.remove(fileName)
            print("write file failure")
            he_log_error("write file failure " .. filePath)
        end
    else
        he_log_error("persistent file failure " .. fileName .. ", error: " .. err)
    end
    return false
end

function Processor:isConfigBase64Invalid(config)
	local dst = mime.unb64(config)
	-- dst is nil if base64 decode fail
	if dst then
		local testWriteSuccess = self:writeNewConfigToStorage(dst, true)
		if testWriteSuccess then
			local path = HeResPathUtils:getUserDataPath() .. "/" .. kTestDecodeFilename
			local decodeContent = HeFileUtils:decodeFile(path)
			local jsonContent = table.deserialize(decodeContent)
			os.remove(path)
			-- jsonContent is nil if json decode fail
			if jsonContent then
				return true, decodeContent
			end
		end
	end
	return false
end

function Processor:handleConfigFromServer(config, version)
	local storageConfig = self:getStorageConfig()
	local valid, jsonString = self:isConfigBase64Invalid(config)
	local oldVersion = self:readLocalConfigVersion()
	if valid then
		if storageConfig ~= jsonString or oldVersion ~= version then
			local dst = mime.unb64(config)
			local writeSuccess = self:writeNewConfigToStorage(dst)
			if writeSuccess then
				self:writeNewConfigVersion(version)
			end
		end
	end
end

function Processor:start()
	local function onUpdateConfigError( evt )
	    if evt and evt.target then evt.target:removeAllEventListeners() end
	    print("loadLevelConfigDynamicUpdate error")
	end

	local function onUpdateConfigFinish( evt )
	    if evt and evt.target then evt.target:removeAllEventListeners() end
	    print("loadLevelConfigDynamicUpdate finished")
	    if evt.data and evt.data.config then
	        self:handleConfigFromServer(evt.data.config, evt.data.md5)
	    end
	end 

    local osName = nil
    if __ANDROID then 
    	osName = "android"
    elseif __IOS then 
    	osName = "ios"
    elseif __WIN32 then -- for test
	    osName = "android"
    end
    local version = _G.bundleVersion

    local http = LevelConfigUpdateHttp.new()
    http:addEventListener(Events.kComplete, onUpdateConfigFinish)
    http:addEventListener(Events.kError, onUpdateConfigError)
    http:load(osName, version)
end

return Processor
