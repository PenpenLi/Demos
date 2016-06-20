

GameGuideData = class()

local instance
function GameGuideData:sharedInstance()
	if not instance then instance = GameGuideData.new() end
	return instance
end

local function createProperty(instance, name, typeStr, defaultValue)
	local funcName = string.upper(string.sub(name, 1, 1))..string.sub(name, 2)
	if typeStr == "table" then
		instance["addTo"..funcName] = function(instance, value)
			(instance[name])[value] = true
		end
		instance["containIn"..funcName] = function(instance, value)
			return (instance[name])[value]
		end
		instance["removeFrom"..funcName] = function(instance, value)
			(instance[name])[value] = nil
		end
	end
	instance["set"..funcName] = function(instance, value)
		if type(value) == typeStr or value == defaultValue then
			instance[name] = value
		end
	end
	instance["get"..funcName] = function(instance)
		if type(instance[name]) == typeStr then return instance[name]
		else
			if type(defaultValue) == "table" then
				return table.clone(defaultValue)
			else return defaultValue end
		end
	end
	instance["reset"..funcName] = function(instance)
		if typeStr == "table" then
			if type(defaultValue) == "table" then
				instance[name] = table.clone(defaultValue)
			else instance[name] = defaultValue end
		else instance[name] = defaultValue end
	end

	instance["reset"..funcName](instance)
end

function GameGuideData:ctor()
	createProperty(self, "guides", "table", {})
	createProperty(self, "guideSeed", "table", {})
	createProperty(self, "numMoves", "number", -1)
	createProperty(self, "levelId", "number", 0)
	createProperty(self, "guideIndex", "number", nil)
	createProperty(self, "popups", "number", 0)
	createProperty(self, "layer", "table", nil)
	createProperty(self, "actionIndex", "number", 0)
	createProperty(self, "guidedIndex", "table", {})
	createProperty(self, "guideInLevel", "table", {})
	createProperty(self, "skipLevel", "boolean", false)
	createProperty(self, "curLevelGuide", "table", {})
	createProperty(self, "curSuccessGuide", "table", {})
	createProperty(self, "gameFlags", "table", {})
	createProperty(self, "scene", "string", "")
	createProperty(self, "forceStop", "boolean", false)
	createProperty(self, "gameStable", "boolean", true)
end

function GameGuideData:setRunningGuide(index)
	self:setGuideIndex(index)
end

function GameGuideData:getRunningGuide()
	if not self:getGuideIndex() then return nil end
	return self:getGuides()[self:getGuideIndex()]
end

function GameGuideData:resetRunningGuide()
	self:resetGuideIndex()
end

function GameGuideData:incRunningAction()
	if not self:getGuideIndex() then return nil end
	local guide = self:getGuides()[self:getGuideIndex()]
	if not guide then return nil end
	self:setActionIndex(self:getActionIndex() + 1)
	return guide.action[self:getActionIndex()]
end

function GameGuideData:getRunningAction()
	if not self:getGuideIndex() then return nil end
	local guide = self:getGuides()[self:getGuideIndex()]
	if not guide then return nil end
	return guide.action[self:getActionIndex()]
end

function GameGuideData:resetRunningAction()
	self:resetActionIndex()
end

function GameGuideData:getGuideById(guideId)
	return self:getGuides()[guideId]
end

function GameGuideData:getGuideActionById(guideId, actionId)
	local guide = self:getGuideById(guideId)
	if not guide then return nil end
	return guide.action[actionId]
end

function GameGuideData:getGuideSeedByLevelId(level)
	return (self:getGuideSeed())[level] or 0
end

function GameGuideData:readFromFile()
	local path = HeResPathUtils:getUserDataPath() .. "/guiderec"
	local hFile, err = io.open(path, "r")
	local text
	if hFile and not err then
		text = hFile:read("*a")
		io.close(hFile)
		local table = string.split(text, ',')
		for k, v in ipairs(table) do self:addToGuidedIndex(tonumber(v)) end
	end
end

function GameGuideData:writeToFile()
	local path = HeResPathUtils:getUserDataPath() .. "/guiderec"
	local text = ""
	for k, v in pairs(self:getGuidedIndex()) do text = text..k.."," end
	text = string.sub(text, 1, -2)
	Localhost:safeWriteStringToFile(text, path)
end