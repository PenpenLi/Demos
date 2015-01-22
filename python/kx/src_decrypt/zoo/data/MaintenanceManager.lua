require "zoo.model.LuaXml"
require "hecore.utils"

MaintenanceFeature = class()
function MaintenanceFeature:ctor()
	self.enable = false
end
function MaintenanceFeature:fromXML( src )
	if not src then return end
	self.enable = tostring(src.enable) == "true"
	self.id = src.id
	self.name = src.name
	self.version = src.version
	self.beginDate = src.beginDate
	self.endDate = src.endDate
	self.platformStr = src.platform
	local platformList = self.platformStr:split(',')
	self.platform = {}
	for k, v in ipairs(platformList) do
		if type(v) == "string" and string.len(v) > 0 then table.insert(self.platform, v) end
	end

	--print("MaintenanceFeature", self.enable, src.enable)
end

local instance = nil
MaintenanceManager = {}

function MaintenanceManager:getInstance()
	if not instance then instance = MaintenanceManager end
	return instance
end

function MaintenanceManager:initialize(onFinish)
	if PrepackageUtil:isPreNoNetWork() then return end
	self:onlineLoad(onFinish)
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
    request:setConnectionTimeoutMs(30 * 1000)
    request:setTimeoutMs(30 * 1000)
   
    local function onRegisterFinished( response )
    	if response.httpCode ~= 200 then 
    		print("get maintenance config error")	
    	else
    		local message = response.body
    		local metaXML = xml.eval(message)
    		local confList = xml.find(metaXML, "maintenance")
    		self:fromXML(confList)

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

function MaintenanceManager:isEnabled(key)
	local keys = {}
	for k, v in ipairs(MaintenanceManager) do
		if v.name == key then table.insert(keys, v) end
	end
	for k, v in ipairs(keys) do
		for i, j in ipairs(v.platform) do
			if StartupConfig:getInstance():getPlatformName() == j and v.version == _G.bundleVersion then return v.enable end
		end
	end
	for k, v in ipairs(keys) do
		for i, j in ipairs(v.platform) do
			if StartupConfig:getInstance():getPlatformName() == j and v.version == "default" then return v.enable end
		end
	end
	for k, v in ipairs(keys) do
		if v.platformStr == "default" and v.version == "default" then return v.enable end
	end
	return false
end