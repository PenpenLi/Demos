require "hecore.utils"
require "zoo.data.UserManager"
require "zoo.gameGuide.Guides"
require "zoo.gameGuide.GameGuideRunner"

if PublishActUtil:isGroundPublish() then return end
GameGuide = class{}

local guide = nil
function GameGuide:sharedInstance()
	if not guide then
		guide = GameGuide.new()
		if guide:init() then
			return guide
		end
		return nil
	end
	return guide
end

function GameGuide:ctor()
	self.guides = nil
	self.guideSeed = nil
	self.numMoves = -1
	self.levelId = 0
	self.index = 0
	self.currentGuide = nil
	self.nowActWin = nil
	self.popups = 0
	self.layer = nil
	self.guideIndex = 0
	self.guidedIndex = {}
	self.guideInLevel = {}
	self.skipLevel = false
	self.curSuccessGuide = {}
end

function GameGuide:init()
	self.guides = Guides
	self.guideSeed = GuideSeeds
	self.guideInLevel = {}
	local path = HeResPathUtils:getUserDataPath() .. "/guiderec"
	local hFile, err = io.open(path, "r")
	local text
	if hFile and not err then
		text = hFile:read("*a")
		io.close(hFile)
		local function split(str, char)
    		local res = {}
   			string.gsub(str, "[^"..char.."]+", function(w) table.insert(res, w) end)
    		return res
		end
		local table = split(text, ",")
		for __, v in ipairs(table) do
			self.guidedIndex[tonumber(v)] = true
		end
	end
	return true
end

function GameGuide:dispose()
	self.currentGuide = nil
	self.guideSeed = nil
	self.guides = nil
	self.nowActWin = nil
	if self.layer then
		self.layer:removeChildren(true)
		self.layer = nil
	end
	self.curSuccessGuide = {}
end

function GameGuide:currentGuideType()
	if self.currentGuide then return self.currentGuide.action[self.guideIndex].type end
	return nil
end

-- 进入藤蔓界面
function GameGuide:onEnterWorldMap()
	self.scene = "worldMap"
	self.levelId = 0
	self.numMoves = -1
	self.skipLevel = false
	self.itemType = nil
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 强行停止现有引导
function GameGuide:forceStopGuide()
	self.forceStop = true
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 尝试开始一个新引导
function GameGuide:tryStartGuide()
	self.forceStop = false
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 弹出窗口
function GameGuide:onPopup(panel)
	self.popups = self.popups + 1
	self.nowActWin = panel
	if panel.panelName == "startGamePanel" then
		self.levelId = panel.levelId
	end
	self:tryEndCurrentGuide()
	local res = self:tryRunNewGuide()
	self.nowActWin = nil
	return res
end

-- 窗口消失
function GameGuide:onPopdown(panel)
	self.popups = self.popups - 1
	self.nowActWin = panel
	self:tryEndCurrentGuide()
	local res = self:tryRunNewGuide()
	self.nowActWin = nil
	return res
end

-- 游戏初始化
function GameGuide:onGameInit(level)
	self.scene = "game"
	self.levelId = level
	self.numMoves = -1
	self.skipLevel = false
	self.itemType = nil
	self.guideInLevel = {}
	self.curLevelGuide = self.curLevelGuide or {}
	for k, __ in pairs(self.curLevelGuide) do self.curLevelGuide[k] = nil end
	self:tryEndCurrentGuide()
	self:tryRunNewGuide()
	if self:checkHaveGuide(level) and self.guideSeed[level] then
		return self.guideSeed[level]
	else
		return 0
	end
end

-- 游戏进入后动画播放结束
function GameGuide:onGameAnimOver()
	self.scene = "game"
	self.numMoves = 0
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 进行了一次交换
function GameGuide:onGameSwap(from, to)
	self.scene = "game"
	self.gameStable = false
	self.numMoves = self.numMoves + 1
	self:tryEndCurrentGuide(from, to)
	return self:tryRunNewGuide(from, to)
end

function GameGuide:onHalloweenBossFirstComeout(pos)
	self.halloweenBossFirstComeout = true
	local array = self.guides[180001].action[2].array[1]
	self.guides[180001].appear[6] = nil
	array.r = pos.r + 1
	array.c = pos.c
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:tryFirstQuestionMark(mainLogic)

	self.firstQuestionMark = true
	local row, col = 0, 0
	local found = false
	for r = #mainLogic.gameItemMap, 1, -1  do
		for c = 1, #mainLogic.gameItemMap[r] do 
			local item = mainLogic.gameItemMap[r][c]
			if item.ItemType == GameItemType.kQuestionMark then
				row = r
				col = c
				found = true
				break
			end
		end
		if found == true then break end
	end

	self.guides[190001].action[1].array[1].r = row
	self.guides[190001].action[1].array[1].c = col
	self.guides[190001].action[1].panPosY = row - self.guides[190001].action[1].offsetY
	self:tryEndCurrentGuide()
	local guide = self:tryRunNewGuide()
	self.firstQuestionMark = false
	return guide
end

function GameGuide:onFirstShowFirework(pos)
	self.firstShowFirework = true
	self.guides[190000].action[1].position = pos
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	self.firstShowFirework = false
	return newGuide
end


function GameGuide:tryFirstFullFirework(pos)
	self.firstFullFirework = true
	-- self.guides[190002].action[1].position = pos
	local vs = Director:sharedDirector():getVisibleSize()
	local vo = Director:sharedDirector():getVisibleOrigin()
	self.guides[190002].action[1].position = ccp(vo.x+10, vo.y+10)
	self.guides[190002].action[1].offsetX = 0
	self.guides[190002].action[1].offsetY = 0
	self.guides[190002].action[1].width = vs.width - 20
	self.guides[190002].action[1].height = 165
	self:tryEndCurrentGuide()
	local newGuide = self:tryRunNewGuide()
	self.firstFullFirework = false
	return newGuide
end

-- 游戏中获得了一个道具
function GameGuide:onGetGameItem(itemType)
	self.itemType = itemType
	self.gameStable = true
	self:tryEndCurrentGuide()
	local res = self:tryRunNewGuide()
	if self.itemType then self.itemType = nil end
	return res
end

-- 游戏达到稳定状态
function GameGuide:onGameStable()
	self.scene = "game"
	self.gameStable = true

	self:tryEndCurrentGuide()
	local guide = self:tryRunNewGuide()
	return guide
end

-- 离开游戏
function GameGuide:onExitGame()
	self.scene = ""
	self.numMoves = -1
	self.skipLevel = false
	self.itemType = nil
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

-- 首次显示按钮
function GameGuide:onShowButton(buttonName)
	self.button = self.button or {}
	table.insert(self.button, buttonName)
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onResult(key, value)
	self:tryEndCurrentGuide(key, value)
	local res = self:tryRunNewGuide(from, to)
	return res
end

function GameGuide:onHideButton(buttonName)
	self.button = self.button or {}
	for k, v in ipairs(self.button) do
		if v == buttonName then table.remove(self.button, k) end
	end
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onEnterFruitTree()
	self.scene = "fruitTree"
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onFruitClicked(index)
	self.clickedFruitIndex = index
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onFruitReleased()
	self.clickedFruitIndex = nil
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide()
end

function GameGuide:onFruitButtonClicked(name)
	self.clickFruitButton = name
	self:tryEndCurrentGuide()
	local res = self:tryRunNewGuide()
	self.clickFruitButton = nil
	return res
end

function GameGuide:getFruitClicked()
	return self.clickedFruitIndex
end

function GameGuide:onTurnTableEnabled(panel, disk, enabled)
	self.turnTableEnabled = enabled
	self:tryEndCurrentGuide()
	return self:tryRunNewGuide(panel, disk)
end

-- 尝试进行一个新的引导
function GameGuide:tryRunNewGuide(from, to)
	if self.currentGuide then return end
	self.currentGuide, self.index = self:getFirstGuide(from, to)
	if self.currentGuide then
		self.guideIndex = 1
		self:runGuideActions(from, to, self.index)
		if not self.currentGuide or not self.index then return false end
		self.guideInLevel[self.index] = true
		return self.currentGuide.action[self.guideIndex].type ~= "clickFlower" and
			self.currentGuide.action[self.guideIndex].type ~= "startPanel" and
			self.currentGuide.action[self.guideIndex].type ~= "showHint"
	end
	return false
end

-- 尝试结束一个引导
function GameGuide:tryEndCurrentGuide(from, to)
	if not self.currentGuide or not self.index then return end
	if self:checkDisappear(from, to) then
		local rec, success = self:cleanupGuideActions(from, to)
		if rec then
			if not self.guidedIndex[self.index] then
				self.guidedIndex[self.index] = true
				DcUtil:tutorialStep(self.index)
				local function getListLength(list)
					local count = 0
					for k, v in pairs(list) do count = count + 1 end
					return count
				end
				if getListLength(self.guidedIndex) >= getListLength(self.guides) then
					DcUtil:tutorialFinish()
				end
				self:writeGuideIndex()
			end
			self.curLevelGuide = self.curLevelGuide or {}
			self.curLevelGuide[self.index] = true
		end
		if success then
			self.curSuccessGuide = self.curSuccessGuide or {}
			self.curSuccessGuide[self.index] = true
		end
		self.index = 0
		self.guideIndex = 0
		self.currentGuide = nil
	end
end

-- 检查本关是否有可显示的引导
function GameGuide:checkHaveGuide(level)
	for k, v in pairs(self.guides) do
		local function checkGuideOk(guide, level)
			local found = false
			for __, v in ipairs(guide.appear) do
				if v.type == "scene" then
					found = true
					if v.scene ~= "game" or v.para ~= level then
						return false
					end
				elseif v.type == "topLevel" then
					local topLevelId = UserManager:getInstance().user:getTopLevelId()
					if topLevelId ~= v.para then return false end
				elseif v.type == "onceOnly" and self.guidedIndex[k] then
					return false
				elseif v.type == "curLevelGuided" then
					for __, v1 in ipairs(v.guide) do
						if not self.guides[v1] then return false end
						for __, v2 in pairs(self.guides[v1].appear) do
							if v2.type == "onceOnly" and self.guidedIndex[v1] then return false end
						end
					end
				end
			end
			return found
		end
		if checkGuideOk(v, level) then return true end
	end
	return false
end

-- 获取第一个符合条件的引导，否则返回空，满足所有条件才算通过。
function GameGuide:getFirstGuide(from, to)
	if not self.guides or self.forceStop or self.skipLevel then return nil end
	for k, v in pairs(self.guides) do
		local function checkGuide(guide, index)
			for __, v in ipairs(guide.appear) do
				if v.type == "noPopup" then
					if self.popups > 0 then return false end
				elseif v.type == "scene" then
					if v.scene ~= self.scene or (v.scene == "game" and type(v.para) == 'number' and v.para ~= self.levelId)
					or (v.scene == "game" and type(v.para) == 'table' and not table.exist(v.para, self.levelId)) 
					then
						return false
					end
				elseif v.type == "topLevel" then
					local topLevelId = UserManager:getInstance().user:getTopLevelId()
					if topLevelId ~= v.para then return false end
				elseif v.type == "popup"then
					if self.popups == 0 or not self.nowActWin or v.popup ~= self.nowActWin.panelName or v.para ~= self.levelId then
						return false
					end
				elseif v.type == "numMoves" then
					if self.numMoves ~= v.para then return false end
				elseif v.type == "staticBoard" then
					if not self.gameStable then return false end
				elseif v.type == "onceOnly" then
					if self.guidedIndex[index] then return false end
				elseif v.type == "onceLevel" then
					if self.guideInLevel[index] then return false end
				elseif v.type == "getItem" then
					if v.item ~= self.itemType then return false end
				elseif v.type == "curLevelGuided" then
					for __, v1 in ipairs(v.guide) do
						if not self.curLevelGuide[v1] then return false end
					end
				elseif v.type == "button" then
					self.button = self.button or {}
					local found = false
					for k2, v2 in ipairs(self.button) do
						if v.button == v2 then found = true break end
					end
					if not found then return false end
				elseif v.type == "success" then
					self.curSuccessGuide = self.curSuccessGuide or {}
					for k1, v1 in ipairs(v.guide) do
						if not self.curSuccessGuide[v1] then return false end
					end
				elseif v.type == "notSuccess" then
					self.curSuccessGuide = self.curSuccessGuide or {}
					for k1, v1 in ipairs(v.guide) do
						if self.curSuccessGuide[v1] then return false end
					end
				elseif v.type == "fruitClicked" then
					if not self.clickedFruitIndex then return false end
					if v.index and self.clickedFruitIndex ~= v.index then return false end
				elseif v.type == "fruitNotClicked" then
					if v.index then 
						if self.clickedFruitIndex == v.index then return false end
					elseif self.clickedFruitIndex then return false end
				elseif v.type == "turnTableEnable" then
					if v.value ~= self.turnTableEnabled then return false end
				elseif v.type == "halloweenBoss" then
					if self.halloweenBossFirstComeout ~= true then
						return false
					end
				elseif v.type == 'waitSignal' then -- 等待名叫name的变量值变成value才行
					print('waitSignal', self[v.name], index)
					if self[v.name] ~= v.value then
						return false
					end

				else assert(false, "Unsupported type by GameGuide!"..tostring(k)..v.type) end
			end
			return true
		end
		if checkGuide(v, k) then
			return v, k
		end
	end
	return nil
end

-- 确认是否满足引导的消失条件，满足条件之一即通过
function GameGuide:checkDisappear(from, to)
	if self.forceStop then return true end
	for __, v in ipairs(self.currentGuide.disappear) do
		if v.type == "noPopup" then
			if self.popups == 0 then return true end
		elseif v.type == "scene" then
			if self.scene == v.scene then return true end
		elseif v.type == "popup" then
			if self.popups > 0 then return true end
		elseif v.type == "swap" then
			if not v.from or not v.to then return true end
			if type(from) == "table" and type(from.x) == "number" and type(from.y) == "number" and
				type(to) == "table" and type(to.x) == "number" and type(to.y) == "number" and
				((from.x == v.from.x and from.y == v.from.y and to.x == v.to.x and to.y == v.to.y) or
				(from.x == v.to.x and from.y == v.to.y and to.x == v.from.x and to.y == v.from.y)) then
				return true
			end
		elseif v.type == "numMoves" then
			if self.numMoves == v.para then return true end
		elseif v.type ==  "popdown" then
			if self.nowActWin and self.nowActWin.panelName == v.popdown then return true end
		elseif v.type == "result" then
			if from == v.key and to == v.value then return true end
		elseif v.type == "fruitClicked" then
			if self.clickedFruitIndex then return true end
		elseif v.type == "fruitNotClicked" then
			if not self.clickedFruitIndex then return true end
		elseif v.type == "fruitButtonClick" then
			if v.button == self.clickFruitButton then return true end
		elseif v.type == "turnTableEnable" then
			if v.value == self.turnTableEnabled then return true end
		else
			assert(false, "Unsupported type by GameGuide!"..tostring(self.index)..v.type)
		end
	end
	return false
end

-- 被通知一个引导结束，进入下一个引导
function GameGuide:onGuideComplete(skipLevel)
	if not self.currentGuide then
		self.currentGuide = nil
		self.index = 0
		return
	end
	local rec, success = self:cleanupGuideActions()
	if skipLevel then
		self.currentGuide = nil
		self.skipLevel = true
		return
	end
	self.guideIndex = self.guideIndex + 1
	if #self.currentGuide.action < self.guideIndex then
		if rec then
			if not self.guidedIndex[self.index] then
				self.guidedIndex[self.index] = true
				DcUtil:tutorialStep(self.index)
				local function getListLength(list)
					local count = 0
					for k, v in pairs(list) do count = count + 1 end
					return count
				end
				if getListLength(self.guidedIndex) >= getListLength(self.guides) then
					DcUtil:tutorialFinish()
				end
				self:writeGuideIndex()
			end
			self.curLevelGuide = self.curLevelGuide or {}
			self.curLevelGuide[self.index] = true
		end
		if success then
			self.curSuccessGuide = self.curSuccessGuide or {}
			self.curSuccessGuide[self.index] = true
		end
		self.index = 0
		self.guideIndex = 0
		self.currentGuide = nil
		-- self:tryRunNewGuide()
	else
		self:runGuideActions()
	end
end

-- 运行引导的内容
function GameGuide:runGuideActions(from, to, index)
	if not self.currentGuide.action[self.guideIndex] then return end
	if self.currentGuide.action[self.guideIndex].type == "clickFlower" then
		GameGuideRunner:runClickFlower(self.currentGuide.action[self.guideIndex].para, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "startPanel" then
		GameGuideRunner:runClickStart(self.nowActWin, self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "gameSwap" then
		GameGuideRunner:runSwap(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showObj" then
		GameGuideRunner:runShowObj(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showHint" then
		GameGuideRunner:runHint(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showInfo" then
		GameGuideRunner:runInfo(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showTile" then
		GameGuideRunner:runTile(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "continue" then
		GameGuideRunner:runContinue(self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showPreProp" then
		GameGuideRunner:runPreProp(self.nowActWin, self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "startInfo" then
		GameGuideRunner:runStartInfo(self.nowActWin, self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "tempProp" then
		GameGuideRunner:runTempProp(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "moveCount" then
		GameGuideRunner:runMoveCount(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showEliminate" then
		GameGuideRunner:runEliminate(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "beginnerPanel" then
		GameGuideRunner:runBeginnerPanel()
	elseif self.currentGuide.action[self.guideIndex].type == "showUFO" then
		GameGuideRunner:runShowUFO(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "fruitTreeButton" then
		GameGuideRunner:runFruitTreeButton(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "clickFruit" then
		GameGuideRunner:runClickFruit(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "fruitButton" then
		GameGuideRunner:runFruitButton(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "weeklyRaceButton" then
		GameGuideRunner:runWeeklyRaceButton(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "turnTableSlide" then
		GameGuideRunner:createTurnTableSlide(from, to, self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "giveProp" then
		GameGuideRunner:runGiveProp(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showProp" then
		GameGuideRunner:runShowProp(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "rabbitWeeklyButton" then
		GameGuideRunner:runRabbitWeeklyButton(self, self.currentGuide.action[self.guideIndex])
	elseif self.currentGuide.action[self.guideIndex].type == "showCustomizeArea" then
		GameGuideRunner:runShowCustomizeArea(self, self.currentGuide.action[self.guideIndex])
	end
end

-- 通知调用对象移除引导元素
function GameGuide:cleanupGuideActions(from, to)
	if not self.currentGuide.action[self.guideIndex] then return false end
	if self.currentGuide.action[self.guideIndex].type == "clickFlower" then
		return GameGuideRunner:removeClickFlower()
	elseif self.currentGuide.action[self.guideIndex].type == "startPanel" then
		return GameGuideRunner:removeClickStart(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "gameSwap" then
		return GameGuideRunner:removeSwap(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showObj" then
		return GameGuideRunner:removeShowObj(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showHint" then
		return GameGuideRunner:removeHint(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showInfo" then
		return GameGuideRunner:removeInfo(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showTile" then
		return GameGuideRunner:removeTile(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "continue" then
		return GameGuideRunner:removeContinue()
	elseif self.currentGuide.action[self.guideIndex].type == "showPreProp" then
		return GameGuideRunner:removePreProp(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "startInfo" then
		return GameGuideRunner:removeStartInfo(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "tempProp" then
		return GameGuideRunner:removeTempProp(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "moveCount" then
		return GameGuideRunner:removeMoveCount(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showEliminate" then
		return GameGuideRunner:removeEliminate(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "beginnerPanel" then
		return GameGuideRunner:removeBeginnerPanel()
	elseif self.currentGuide.action[self.guideIndex].type == "showUFO" then
		return GameGuideRunner:removeShowUFO(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "fruitTreeButton" then
		return GameGuideRunner:removeFruitTreeButton(self.layer, from, to)
	elseif self.currentGuide.action[self.guideIndex].type == "clickFruit" then
		return GameGuideRunner:removeClickFruit(self.currentGuide.disappear)
	elseif self.currentGuide.action[self.guideIndex].type == "fruitButton" then
		return GameGuideRunner:removeFruitButton()
	elseif self.currentGuide.action[self.guideIndex].type == "weeklyRaceButton" then
		return GameGuideRunner:removeWeeklyRaceButton(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "turnTableSlide" then
		return GameGuideRunner:removeTurnTableSlide(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "giveProp" then
		return GameGuideRunner:removeGiveProp(self)
	elseif self.currentGuide.action[self.guideIndex].type == "showProp" then
		return GameGuideRunner:removeShowProp(self)
	elseif self.currentGuide.action[self.guideIndex].type == "rabbitWeeklyButton" then
		return GameGuideRunner:removeRabbitWeeklyButton(self.layer)
	elseif self.currentGuide.action[self.guideIndex].type == "showCustomizeArea" then
		return GameGuideRunner:removeShowCustomizeArea(self)
	end
end

function GameGuide:writeGuideIndex()
	local path = HeResPathUtils:getUserDataPath() .. "/guiderec"
	local text = ""
	for k, __ in pairs(self.guidedIndex) do
		text = text..k..","
	end
	text = string.sub(text, 1, -2)
	Localhost:safeWriteStringToFile(text, path)
end