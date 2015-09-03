

local FailReason = {success = 0, move = 6, time = 14, score = 19, addStep = 22}
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月22日 16:17:55
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.baseUI.ButtonWithShadow"

---------------------------------------------------
-------------- LevelFailTopPanel
---------------------------------------------------

assert(not LevelFailTopPanel)
assert(BaseUI)
LevelFailTopPanel = class(BaseUI)

function LevelFailTopPanel:init(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason, ...)
	assert(type(parentPanel)	== "table")
	assert(type(levelId)		== "number")
	assert(type(failScore)		== "number")
	assert(type(failStar)		== "number")
	assert(type(isTargetReached)	== "boolean")
	assert(#{...} == 0)
	
	------------------------------------
	---- Get UI Resource
	-------------------------------
	self.resourceManager	= ResourceManager:sharedInstance()

	self.ui	= ResourceManager:sharedInstance():buildGroup("levelFailPanel/levelFailTopPanel")

	-- ----------------
	-- Init Base Class
	-- -------------------
	BaseUI.init(self, self.ui)

	---------------------
	---- Get UI Resource
	----------------------
	self.fadeArea		= self.ui:getChildByName("fadeArea")
	self.clippingAreaAbove	= self.ui:getChildByName("clippingAreaAbove")
	self.clippingAreaBelow	= self.ui:getChildByName("clippingAreaBelow")
	assert(self.fadeArea)
	assert(self.clippingAreaAbove)
	assert(self.clippingAreaBelow)

	he_log_warning("Not Tackle The targetIcon Resource !")
	self.titleLabel		= self.ui:getChildByName("titleLabel")
	self.replayBtnRes	= self.clippingAreaBelow:getChildByName("replayBtn")
	self.failDes		= self.fadeArea:getChildByName("failDes")
	self.questionMark 	= self.ui:getChildByName('questionMark')
	self.questionMark:ad(DisplayEvents.kTouchTap, function () self:onQuestionMarkTapped(failReason) end)
	self.questionMark:setTouchEnabled(true)

	-- Close Btn
	self.bg			= self.ui:getChildByName("bg")
	assert(self.bg)
	self.closeBtnRes	= self.bg:getChildByName("closeBtn")
	assert(self.closeBtnRes)

	assert(self.titleLabel)
	assert(self.replayBtnRes)
	assert(self.failDes)

	--------------------
	-- Create Failed Anim
	-- --------------------
	local failAnim = CommonSkeletonAnimation:createFailAnimation()
	failAnim:setPositionX(20)
	self.clippingAreaAbove:addChild(failAnim)

	if failReason ~= 'refresh' then
		self.questionMark:setVisible(false)
	end
	--------------------------
	---- Data
	-----------------------
	self.levelId	= levelId
	self.levelType 	= levelType

	he_log_warning("already doesn't need these information !")
	self.failScore	= failScore
	self.failStar	= failStar

	local metaModel		= MetaModel:sharedInstance()
	--self.levelModeTypeId	= metaModel:getLevelModeTypeId(self.levelId)
	local levelGameData	= LevelMapManager.getInstance():getMeta(self.levelId).gameData
	local gameModeName	= levelGameData.gameModeName

	self.parentPanel	= parentPanel

	------------------------------------
	-- Variable To Indicate Tapped State
	-- ---------------------------------
	self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED	= 1
	self.BTN_TAPPED_STATE_REPLAY_BTN_TAPPED	= 2
	self.BTN_TAPPED_STATE_NONE		= 3
	self.btnTappedState			= self.BTN_TAPPED_STATE_NONE

	-------------------
	-- Get Data About UI
	-- ------------------
	local titleLabelPos = self.titleLabel:getPosition()

	-------------------------------
	-- Create UI Component
	-- -------------------
	--- Panel Title
	local diguanWidth		= 58
	local diguanHeight		= 58
	local levelNumberWidth		= 205.52
	local levelNumberHeight		= 68.5
	local manualAdjustInterval	= -15

	local panelTitle = self:createPanelTitle(levelType, levelId)
	local contentSize = panelTitle:getContentSize()
	self:addChild(panelTitle)
	panelTitle:ignoreAnchorPointForPosition(false)
	panelTitle:setAnchorPoint(ccp(0,1))
	panelTitle:setPositionY(titleLabelPos.y)
	panelTitle:setToParentCenterHorizontal()

	-- Bubble Close Btn
	self.closeBtn	= BubbleCloseBtn:create(self.closeBtnRes)

	-- Replay Button
	self.replayBtn	= ButtonWithShadow:create(self.replayBtnRes)

	-------------------------
	---- Update View
	-------------------------
	-- Get Panel Title
	local titleTxtKey	= "level.fail.title"
	local titleTxt		= Localization:getInstance():getText(titleTxtKey, {level_id = self.levelId})
	self.titleLabel:setString(titleTxt)
	he_log_warning("only need it's pos info")
	self.titleLabel:setVisible(false)

	-- Get Repaly Button Label Txt
	local replayBtnTxtKey	= "level.fail.replay.button.label.txt"
	local replayBtnTxt
	if PublishActUtil:isGroundPublish() then
		replayBtnTxt	= Localization:getInstance():getText("prop.info.panel.close.txt", {})
	elseif self.levelType == GameLevelType.kDigWeekly
		or self.levelType == GameLevelType.kMayDay
		or self.levelType == GameLevelType.kRabbitWeekly 
		or self.levelType == GameLevelType.kSummerWeekly 
		or self.levelType == GameLevelType.kTaskForRecall then
		replayBtnTxt	= Localization:getInstance():getText('button.ok', {})
	else
		replayBtnTxt	= Localization:getInstance():getText(replayBtnTxtKey, {})
	end
	self.replayBtn:setString(replayBtnTxt)

	local manualAdjustBtnPosX	= 0
	local manualAdjustBtnPosY	= -9
	local label		= self.replayBtn:getLabel()
	local curLabelPos	= label:getPosition()
	label:setPosition(ccp(curLabelPos.x + manualAdjustBtnPosX, curLabelPos.y + manualAdjustBtnPosY)) 

	-- 刷新出错导致的失败，优先级最高
	if failReason == 'refresh' then
		local failDesValue = Localization:getInstance():getText('level.fail.animal.effect.mode', {})
		self.failDes:setString(failDesValue)
	elseif isTargetReached then
		-- Target Reached, 
		-- Score Not Reached

		self.failDes:setString("分数不够")
		local failDesKey
		if gameModeName == "Classic" then failDesKey = "level.fail.time.mode"
		else failDesKey	= "level.fail.score.not.reached" end
		local failDesValue = Localization:getInstance():getText(failDesKey, {})
		self.failDes:setString(failDesValue)

		DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.score)
	else
		-- Target Not Reach
		-- Get Fail Description Txt
		local failDesKey = false

		he_log_warning("Dig Time Not Added !")
		he_log_warning("Dig Move Endless Not Added !")

		if gameModeName == "Classic moves" then
			failDesKey	= "level.fail.step.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "Classic" then
			failDesKey	= "level.fail.time.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.time)
		elseif gameModeName == "Drop down" then
			failDesKey	= "level.fail.drop.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "Mobile Drop down" then 
			failDesKey = "level.fail.drop.key.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "Light up" then
			failDesKey	= "level.fail.ice.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "DigMove" then
			failDesKey	= "level.fail.dig.step.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "Order" or gameModeName == 'seaOrder' then
			local function getOrderType(str) return string.sub(str, 1, string.find(str, '_') - 1) end
			if levelGameData.orderList and #levelGameData.orderList > 0 then
				local orderType, isMatch = tonumber(getOrderType(levelGameData.orderList[1].k)), true
				if orderType == 2 or orderType == 3 then
					for k, v in ipairs(levelGameData.orderList) do
						if tonumber(getOrderType(v.k)) ~= orderType then
							failDesKey = "level.fail.objective.mode"
							isMatch = false
							break
						end
					end
					if isMatch then
						if orderType == 2 then failDesKey = "level.fail.eliminate.effect.mode"
						elseif orderType == 3 then failDesKey = "level.fail.swap.effect.mode" end
					end
				else failDesKey = "level.fail.objective.mode" end
			else failDesKey = "level.fail.objective.mode" end

			-- 由gameMode指定的failReason,属于特殊的失败原因类型
			if failReason == 'venom' then failDesKey = 'level.fail.venom.effect.mode' end

			DcUtil:logStageEnd(levelId, failScore, failStar, 6)
		elseif gameModeName == "DigMoveEndless" then
			failDesKey	= "level.fail.dig.endless.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "RabbitWeekly" then
			failDesKey	= "level.fail.dig.endless.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "MaydayEndless" or gameModeName == "halloween" then
			failDesKey	= "level.fail.mayday.endless.mode"
			DcUtil:logStageEnd(levelId, failScore, failStar, 19)
		else
			print("levelModeTypeId: " .. self.levelModeTypeId)
			he_log_warning("not implemented !")
			assert(false, "not implemented !")
		end

		local failDesValue = Localization:getInstance():getText(failDesKey, {})
		self.failDes:setString(failDesValue)
	end


	-----------------------------
	---- Add Event Listener
	----------------------------
	local function onReplayBtnTapped(event)
		if PublishActUtil:isGroundPublish() then 
			self:onCloseBtnTapped(event)
		elseif self.levelType == GameLevelType.kTaskForRecall then
			self:onCloseBtnTapped(event)
		elseif self.levelType == GameLevelType.kMayDay then
			self.btnTappedState = self.BTN_TAPPED_STATE_NONE
			self:onCloseBtnTapped()
		else
			self:onReplayBtnTapped(event)
		end
	end
	self.replayBtn.ui:addEventListener(DisplayEvents.kTouchTap, onReplayBtnTapped)

	-- Close Button Event Listener
	local function onCloseBtnTapped(event)
		self:onCloseBtnTapped(event)
	end

	self.closeBtn.ui:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
end

function LevelFailTopPanel:createPanelTitle(levelType, levelId)
	local panelTitle = nil
	if PublishActUtil:isGroundPublish() then
		panelTitle = BitmapText:create("精彩活动关", "fnt/titles.fnt", -1, kCCTextAlignmentCenter)
	else
		local levelDisplayName = nil
		if levelType == GameLevelType.kQixi then
			levelDisplayName = Localization:getInstance():getText('activity.qixi.fail.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif levelType == GameLevelType.kDigWeekly then
			levelDisplayName = Localization:getInstance():getText('weekly.race.panel.start.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif levelType == GameLevelType.kMayDay then
			levelDisplayName = Localization:getInstance():getText('activity.christmas.start.panel.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif levelType == GameLevelType.kRabbitWeekly then
			levelDisplayName = Localization:getInstance():getText('weekly.race.panel.rabbit.begin.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif levelType == GameLevelType.kSummerWeekly then
			levelDisplayName = Localization:getInstance():getText('weeklyrace.summer.panel.title')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		elseif levelType == GameLevelType.kTaskForRecall or levelType == GameLevelType.kTaskForUnlockArea then
			levelDisplayName = Localization:getInstance():getText("recall_text_5")
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		else
			levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(levelId)
			panelTitle = PanelTitleLabel:create(levelDisplayName)
		end
	end
	return panelTitle
end

function LevelFailTopPanel:onCloseBtnTapped(event, ...)
	assert(#{...} == 0)

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end

	local function onPopAnimFinish()
		self.parentPanel:exitGamePlaySceneUI()
	end
	self.parentPanel:remove(onPopAnimFinish)
end

function LevelFailTopPanel:onReplayBtnTapped(event, ...)
	assert(event)
	assert(#{...} == 0)

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_REPLAY_BTN_TAPPED
	else
		return
	end

	if not self.hasClickedReplay then
		self.hasClickedReplay = true
	else
		return
	end

	self.parentPanel:changeToStartGamePanel(false)
end

function LevelFailTopPanel:onQuestionMarkTapped(failReason)
	if failReason == 'refresh' then
		CommonTip:showTip(Localization:getInstance():getText('level.fail.animal.tips', {n = '\n'}), 'positive')
	else
		assert(false, 'failReason not supported, Check you code!')
	end
end

function LevelFailTopPanel:create(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason, ...)
	assert(type(parentPanel) 	== "table")
	assert(type(levelId) 		== "number")
	assert(type(levelType) 		== "number")
	assert(type(failScore) 		== "number")
	assert(type(failStar) 		== "number")
	assert(type(isTargetReached)	== "boolean")
	--assert(levelModeTypeId)

	local newLevelFailTopPanel = LevelFailTopPanel.new()
	newLevelFailTopPanel:init(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason)
	return newLevelFailTopPanel
end
