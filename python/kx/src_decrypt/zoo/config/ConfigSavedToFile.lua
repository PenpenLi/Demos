
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2014Äê02ÔÂ 8ÈÕ 14:26:12
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

---------------------------------------------------
-------------- ConfigSavedToFile
---------------------------------------------------

assert(not ConfigSavedToFile)
ConfigSavedToFile = class()

local configTable = false

function loadSavedConfig(table)

	configTable = table
end

function ConfigSavedToFile:init(...)
	assert(#{...} == 0)

	self.configTable = {}

	-- Load The Config From File
	local path = HeResPathUtils:getUserDataPath() .. "/localConfig.lua"

	local hFile, err = io.open(path, "r")
	local text
	if hFile and not err then
		text = hFile:read("*a")
		io.close(hFile)

		local chunk = loadstring(text)

		if chunk then
			chunk()
		end
	end
end

-- This Function Is Called In The COnfig File !
function ConfigSavedToFile:loadConfig(configTable, ...)
	assert(#{...} == 0)

	if type(configTable) == "table" then
		self.configTable = configTable
	else
		self.configTable = {}
	end
end

function ConfigSavedToFile:serialize(...)
	assert(#{...} == 0)

	local stringToSave = ""

	for k,v in pairs(self.configTable) do
		stringToSave = stringToSave .. "\t" .. k .. " = " .. tostring(v) .. ", \n"
	end

	stringToSave = "ConfigSavedToFile:sharedInstance():loadConfig{ \n" .. stringToSave .. " }"

	local path = HeResPathUtils:getUserDataPath() .. "/localConfig.lua"
	Localhost:safeWriteStringToFile(stringToSave, path)
end

local sharedInstance = false

function ConfigSavedToFile:sharedInstance(...)
	assert(#{...} == 0)

	if not sharedInstance then
		sharedInstance = ConfigSavedToFile.new()
		sharedInstance:init()
	end

	return sharedInstance
end
