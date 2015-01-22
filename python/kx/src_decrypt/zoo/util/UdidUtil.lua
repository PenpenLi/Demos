local kUdidConfig = HeResPathUtils:getUserDataPath().."/lkN90pqEZh.du"

UdidUtil = {}
function UdidUtil:getUdid()
	local result = nil
	if not PlatformConfig:isAuthConfig(PlatformAuthEnum.kGuest) then
		local data = UdidUtil:readFromStorage()
		if data and data.udid ~= nil then result = data.udid end
		print("OAuth user udid:"..tostring(result))
	end
	if result == nil then result = MetaInfo:getInstance():getUdid() end
	print("MetaInfo:getInstance():getUdid() udid:"..tostring(result))
	return result
end

function UdidUtil:readFromStorage()
	local filePath = kUdidConfig
	local file = io.open(filePath, "rb")
	if file then
		local data = file:read("*a") 
		file:close()

		if data then
			local result = nil 
			local function decodeAmf3() result = amf3.decode(data) end
			pcall(decodeAmf3)
			print("udid file found:"..tostring(table.tostring(result)))
			return result
		end
	end
	print("udid file not found"..filePath)
	return nil
end
function UdidUtil:saveUdid(newUdid)
	local data = amf3.encode({udid=newUdid})
	local filePath = kUdidConfig
	
	local tmpName = filePath .. "." .. os.time()
    local file = io.open(tmpName, "wb")

    assert(file, "persistent udid file failure " .. tmpName)
    if not file then return end

    local success = file:write(data)

    if success then
        file:flush()
        file:close()
        os.remove(filePath)
        os.rename(tmpName, filePath)
        print("write udid file success " .. filePath)
    else
        file:close()
        os.remove(tmpName)
        print("write udid file failure " .. tmpName)
    end 
end

function UdidUtil:revertUdid()
	local defaultUDID = MetaInfo:getInstance():getUdid()
	UdidUtil:saveUdid(defaultUDID)
	print("revertUdid")
	return defaultUDID
end