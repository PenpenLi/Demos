require "zoo.data.MetaManager"
require "zoo.net.UserLocalLogic"

AnimalStageInfo = class()
function AnimalStageInfo:ctor( uid, levelId )
	self.uid = uid
	self.levelId = levelId
	self.propIds = {}
	self.buyMove = 0
end
function AnimalStageInfo:isEmpty()
	if not self.propIds then return true end
	if #self.propIds > 0 then return false end
	return true
end
function AnimalStageInfo:addProp( itemID )
	table.insert(self.propIds, itemID)
end
function AnimalStageInfo:removeProp( itemID )
	table.removeValue(self.propIds, itemID)
end
function AnimalStageInfo:incrBuyMove( buyMove )
	self.buyMove = self.buyMove + buyMove
end

local stageInfoMap = {}

StageInfoLocalLogic = class()

function StageInfoLocalLogic:getStageInfoKey( uid )
	return tostring(uid)
end
function StageInfoLocalLogic:getStageInfo( uid )
	local key = StageInfoLocalLogic:getStageInfoKey( uid )
	return stageInfoMap[key]
end
function StageInfoLocalLogic:initStageInfo(uid, levelId, propIds)
	local stageInfo = AnimalStageInfo.new(uid, levelId)
	local key = StageInfoLocalLogic:getStageInfoKey( uid )
	stageInfo.propIds = propIds
	stageInfoMap[key] = stageInfo
	--todo: save stage info to local file.
end

function StageInfoLocalLogic:clearStageInfo( uid )
	local key = StageInfoLocalLogic:getStageInfoKey( uid )
	local result = stageInfoMap[key]
	--?should we remove data?
	stageInfoMap[key] = nil
	return result
end

function StageInfoLocalLogic:addTempProps( uid, propId )
	local stageInfo = StageInfoLocalLogic:getStageInfo( uid )
	if stageInfo then stageInfo:addProp(propId) end
end
function StageInfoLocalLogic:subTempProps( uid, propIds )
	local stageInfo = StageInfoLocalLogic:getStageInfo( uid )
	if stageInfo and not stageInfo:isEmpty() then
		for i,item in ipairs(propIds) do
			stageInfo:removeProp(item)
		end
	end
end

function StageInfoLocalLogic:addBuyMove( uid, val )
	local stageInfo = StageInfoLocalLogic:getStageInfo( uid )
	if stageInfo then stageInfo:incrBuyMove(val) end
	return true
end

function StageInfoLocalLogic:openGiftBlocker( uid, levelId, propIds )
	local stageInfo = StageInfoLocalLogic:getStageInfo( uid )
	if stageInfo then
		for i,v in ipairs(propIds) do stageInfo:addProp(v) end
	end
end