require "zoo.model.LuaXml"
require "hecore.utils"
require "zoo.util.UpdateCheckUtils"

MaintenanceFeature = class()
function MaintenanceFeature:ctor()
	self.enable = false
end
function MaintenanceFeature:fromXML( src )
	if not src then return end
	self.enable = tostring(src.enable) == "true"
	self.value = src.value
	self.id = src.id
	self.name = src.name
	self.version = src.version
	self.beginDate = src.beginDate
	self.endDate = src.endDate
	self.platformStr = src.platform
	local platformList = string.split(self.platformStr, ',')
	self.platform = {}
	for k, v in ipairs(platformList) do
		if type(v) == "string" and string.len(v) > 0 then table.insert(self.platform, v) end
	end

	--print("MaintenanceFeature", self.enable, src.enable)
end
function MaintenanceFeature:encode()
	local ret = {}
	ret.enable = self.enable
	ret.value = self.value
	ret.id = self.id
	ret.name = self.name
	ret.version = self.version
	ret.beginDate = self.beginDate
	ret.endDate = self.endDate
	ret.platformStr = self.platformStr
	ret.platform = table.clone(self.platform)

	return ret
end
function MaintenanceFeature:fromLua(src)
	if not src then return end
	self.enable = tostring(src.enable) == "true"
	self.value = src.value
	self.id = src.id
	self.name = src.name
	self.version = src.version
	self.beginDate = src.beginDate
	self.endDate = src.endDate
	self.platformStr = src.platformStr
	self.platform = src.platform
end

local instance = nil
MaintenanceManager = {}

function MaintenanceManager:getInstance()
	if not instance then
		instance = MaintenanceManager
		while #instance > 0 do
			table.remove(instance, 1)
		end
		instance:readFromStorage()
	end
	return instance
end

function MaintenanceManager:initialize(onFinish)
	if PrepackageUtil:isPreNoNetWork() then return end
	self:onlineLoad(onFinish)
end

function MaintenanceManager:readFromStorage()
	local data = Localhost:readFromStorage("Maintenance.ds")
	self:fromLua(data)
end

function MaintenanceManager:writeToStorage()
	local data = {}
	for i,v in ipairs(MaintenanceManager) do
		table.insert(data, v:encode())
	end
	Localhost:writeToStorage(data, "Maintenance.ds")
end

function MaintenanceManager:onlineLoad(onFinish)
	local url = NetworkConfig.maintenanceURL
	local uid = UserManager.getInstance().uid or "12345"
	local params = string.format("?name=maintenance&uid=%s&_v=%s", uid, _G.bundleVersion)
	if __IOS_FB then
  		params = string.format("?name=maintenance_mobile&uid=%s&_v=%s", uid, _G.bundleVersion)
  	end
	url = url .. params
  	print("MaintenanceManager:", url)
	local request = HttpRequest:createGet(url)

  	local connection_timeout = 2

	if __WP8 then 
	   	connection_timeout = 5
	end

    request:setConnectionTimeoutMs(connection_timeout * 1000)
    request:setTimeoutMs(30 * 1000)
   
    local function onRegisterFinished( response )
    	if response.httpCode ~= 200 then 
    		print("get maintenance config error")	
    	else
    		local message = response.body
    		local metaXML = xml.eval(message)
    		local confList = xml.find(metaXML, "maintenance")
    		while #self > 0 do
    			table.remove(self, 1)
    		end
    		self:fromXML(confList)
    		self:writeToStorage()
    		UpdateCheckUtils:getInstance():run()
    		GlobalEventDispatcher:getInstance():dispatchEvent(Event.new(kGlobalEvents.kMaintenanceChange))
    	end
    	if onFinish then onFinish() end
    end

    HttpClient:getInstance():sendRequest(onRegisterFinished, request)
end

function MaintenanceManager:fromXML( src )
	print("MaintenanceManager:fromXML")
	if not src then return end
	self.version = src.version
	for k,v in pairs(src) do	
		if type(v) == "table" then
			local feature = MaintenanceFeature.new()
			feature:fromXML(v)
			table.insert(MaintenanceManager, feature)
		end		
	end
end

function MaintenanceManager:fromLua(src)
	print("MaintenanceManager:fromLua")
	if not src then return end
	for k,v in pairs(src) do	
		if type(v) == "table" then
			local feature = MaintenanceFeature.new()
			feature:fromLua(v)
			table.insert(MaintenanceManager, feature)
		end		
	end
end

function MaintenanceManager:getMaintenanceByKey(key)
	local keys = {}
	for k, v in ipairs(MaintenanceManager) do
		if v.name == key then table.insert(keys, v) end
	end
	for k, v in ipairs(keys) do
		for i, j in ipairs(v.platform) do
			if StartupConfig:getInstance():getPlatformName() == j and v.version == _G.bundleVersion then return v end
		end
	end
	for k, v in ipairs(keys) do
		for i, j in ipairs(v.platform) do
			if StartupConfig:getInstance():getPlatformName() == j and v.version == "default" then return v end
		end
	end
	for k, v in ipairs(keys) do
		if v.platformStr == "default" and v.version == "default" then return v end
	end
	return nil
end

function MaintenanceManager:isEnabled(key)
	local maintenance = self:getMaintenanceByKey(key)
	if maintenance then
		return maintenance.enable
	else
		return false
	end
end

function MaintenanceManager:getValue(key)
	local maintenance = self:getMaintenanceByKey(key)
	if maintenance then
		return maintenance.value
	else
		return nil
	end
end

-- since version 1.30, value = [0, 10000]
function MaintenanceManager:isAvailbleForUid(key, uid, threshold)
	local maintenance = self:getMaintenanceByKey(key)
	if maintenance and maintenance.enable then -- 开关已打开
		local uidEndWith = nil
		if maintenance.value ~= nil then 
			uidEndWith = tonumber(maintenance.value)
		end

		if uidEndWith == nil then -- uid无限制
			return true
		else -- 在灰度范围内
			uid = tonumber(uid) or 0
			threshold = tonumber(threshold) or 100
			return (uid % threshold) < uidEndWith
		end
	end
	return false
end