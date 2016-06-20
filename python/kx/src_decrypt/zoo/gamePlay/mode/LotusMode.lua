LotusMode = class(MoveMode)

function LotusMode:initModeSpecial(config)
	print("RRR    LotusMode:initModeSpecial     111111111111111111111111111111111111111111111111111111111111111111111111")
	self.mainLogic.currLotusNum = self:checkAllLotusCount()
end

function LotusMode:reachEndCondition()
  self.mainLogic.currLotusNum = self:checkAllLotusCount();
  return  MoveMode.reachEndCondition(self) or self.mainLogic.currLotusNum <= 0
end

function LotusMode:reachTarget()
  return self.mainLogic.currLotusNum <= 0
end

----统计所有的冰
function LotusMode:checkAllLotusCount()
  local mainLogic = self.mainLogic
	local countsum = 0
	for r = 1, #mainLogic.gameItemMap do
		for c = 1, #mainLogic.gameItemMap[r] do
			local board1 = mainLogic.boardmap[r][c]
			if board1.isUsed == true and board1.lotusLevel > 0 then
				countsum = countsum + 1
			end
		end
	end
	--print("checkAllIngredientCount", countsum)
	--debug.debug()
	print("RRR    LotusMode:checkAllLotusCount()     " , countsum)
	return countsum;
end

function LotusMode:saveDataForRevert(saveRevertData)
  local mainLogic = self.mainLogic
  saveRevertData.currLotusNum = mainLogic.currLotusNum
  MoveMode.saveDataForRevert(self,saveRevertData)
end

function LotusMode:revertDataFromBackProp()
  local mainLogic = self.mainLogic
  mainLogic.currLotusNum = mainLogic.saveRevertData.currLotusNum
  MoveMode.revertDataFromBackProp(self)
end

function LotusMode:revertUIFromBackProp()
  local mainLogic = self.mainLogic
  if mainLogic.PlayUIDelegate then
    mainLogic.PlayUIDelegate:revertTargetNumber(0, 0, mainLogic.currLotusNum)
  end
  MoveMode.revertUIFromBackProp(self)
end