AndroidAuthorize = class()

local apsMgr
local instance
function AndroidAuthorize.getInstance()
	if not instance then
		instance = AndroidAuthorize.new()
		instance:init()
	end
	return instance
end

function AndroidAuthorize:init()
	self.supportedAuthors = {}
	apsMgr = luajava.bindClass("com.happyelements.hellolua.aps.APSManager")
end

function AndroidAuthorize:initAuthorizeConfig(authorConfig)
	print("AndroidAuthorize:initAuthorizeConfig:", authorConfig)
	if not authorConfig then return end

	if type(authorConfig) == "number" then
		self:registerAuthor(authorConfig)
	elseif type(authorConfig) == "table" then
		for _,v in pairs(authorConfig) do
			self:registerAuthor(v)
		end
	end
end

function AndroidAuthorize:registerAuthor(authorType)
	if not self.defaultAuthorType then self.defaultAuthorType = authorType end

	if authorType ~= PlatformAuthEnum.kGuest then
		self.supportedAuthors[authorType] = true
		local success = apsMgr:getInstance():registerAuthor(authorType)
		if not success then
			he_log_error("registerAuthor failed.authorType="..tostring(authorType)..",platform="..PlatformConfig.name)
		end
	end
end

function AndroidAuthorize:getDefaultAuhtorDelegate()
	if not self.defaultAuthorType then return nil end
	return apsMgr:getInstance():getAuthorizeDelegate(self.defaultAuthorType)
end

function AndroidAuthorize:getAuhtorDelegate(authorType)
	if not authorType or type(authorType)~="number" then return nil end
	return apsMgr:getInstance():getAuthorizeDelegate(authorType)
end

local authorCount = nil
function AndroidAuthorize:hasMultiAuthor()
	if not authorCount then
		authorCount = 0
		for _,_ in pairs(self.supportedAuthors) do
			authorCount = authorCount + 1
		end
	end
	return authorCount > 1
end

function AndroidAuthorize:getDefaultAuthorizeType( ... )
	return self.defaultAuthorType or PlatformAuthEnum.kGuest
end
