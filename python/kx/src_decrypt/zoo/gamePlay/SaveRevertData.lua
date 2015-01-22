
SaveRevertData = class()

function SaveRevertData:ctor()
	self.gameItemMap = nil
	self.boardMap = nil
	self.totalScore = 0
	self.theCurMoves = 0
end

function SaveRevertData:dispose()
	self.gameItemMap = nil
	self.boardMap = nil
end

function SaveRevertData:create(mainLogic)
	local ret = SaveRevertData.new()

	local cloneGameItemMapForRevert = {}
	local cloneBoardMapForRevert = {}

	for r = 1, #mainLogic.gameItemMap do
		cloneGameItemMapForRevert[r] = {}
		for c = 1, #mainLogic.gameItemMap[r] do
			cloneGameItemMapForRevert[r][c] = mainLogic.gameItemMap[r][c]:copy()
		end
	end

	for r = 1, #mainLogic.boardmap do
		cloneBoardMapForRevert[r] = {}
		for c = 1, #mainLogic.boardmap[r] do
			cloneBoardMapForRevert[r][c] = mainLogic.boardmap[r][c]:copy()
		end
	end

	ret.gameItemMap = cloneGameItemMapForRevert
	ret.boardmap = cloneBoardMapForRevert
	ret.totalScore = mainLogic.totalScore
	ret.theCurMoves = mainLogic.theCurMoves
	
	ret.blockProductRules = {}
	for k, v in pairs(mainLogic.blockProductRules) do
		local tmpRule = {}
		tmpRule.blockProductType  = v.blockProductType
		tmpRule.itemID            = v.itemID
		tmpRule.blockMoveCount    = v.blockMoveCount
		tmpRule.blockMoveTarget   = v.blockMoveTarget
		tmpRule.blockShouldCome   = v.blockShouldCome
		tmpRule.blockSpawnDensity = v.blockSpawnDensity
		tmpRule.blockSpawned      = v.blockSpawned
		tmpRule.itemType          = v.itemType
		tmpRule.maxNum            = v.maxNum
		tmpRule.dropNumLimit      = v.dropNumLimit
		tmpRule.totalDroppedNum   = v.totalDroppedNum
		table.insert( ret.blockProductRules, tmpRule )
	end

	ret.tileBlockCount = mainLogic.tileBlockCount
	ret.pm25count = mainLogic.pm25count
	ret.snailCount = mainLogic.snailCount
	ret.snailMoveCount = mainLogic.snailMoveCount

	mainLogic.gameMode:saveDataForRevert(ret)

	return ret
end