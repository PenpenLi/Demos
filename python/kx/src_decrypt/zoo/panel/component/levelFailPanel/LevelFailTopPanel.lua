

local FailReason = {success = 0, move = 6, time = 14, score = 19, addStep = 22}
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月22日 16:17:55
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.common.BubbleCloseBtn"
require "zoo.baseUI.ButtonWithShadow"
require "zoo.panel.jumpLevel.JumpLevelIcon"

---------------------------------------------------
-------------- LevelFailTopPanel
---------------------------------------------------

assert(not LevelFailTopPanel)
assert(BaseUI)
LevelFailTopPanel = class(BaseUI)

function LevelFailTopPanel:init(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason, stageTime, useSpecialActivityUI, ...)
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

	self.useSpecialActivityUI = useSpecialActivityUI
	if self.useSpecialActivityUI then
		self.builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.panel_game_start_activity)
		self.ui = self.builder:buildGroup("Spring2016UI/levelFailTopPanel")
	else
		self.ui	= ResourceManager:sharedInstance():buildGroup("levelFailPanel/levelFailTopPanel")
	end

	-- -------------------
	-- Pattern in activity version
	-- -------------------
	if self.useSpecialActivityUI then
		local pattern = self.ui:getChildByName("pattern")
		pattern:removeFromParentAndCleanup(false)

		local childList = {}
		pattern:getVisibleChildrenList(childList)
		if #childList > 0 then
			local batch = SpriteBatchNode:createWithTexture(childList[1]:getTexture())
			for i,v in ipairs(childList) do
				v:removeFromParentAndCleanup(false)
				batch:addChild(v)
			end
			batch:setPositionXY(pattern:getPositionX(), pattern:getPositionY())
			pattern:dispose()
			pattern = batch
		end
		
		local mask = self.ui:getChildByName("mask")
		local maskPosition = {x = mask:getPositionX(), y = mask:getPositionY()}
		local maskIndex = self.ui:getChildIndex(mask)
		mask:removeFromParentAndCleanup(false)
		local clip = ClippingNode.new(CCClippingNode:create(mask.refCocosObj))
		clip:setAlphaThreshold(0.7)
		self.ui:addChildAt(clip, maskIndex)
		pattern:setPositionXY(pattern:getPositionX() - maskPosition.x, pattern:getPositionY())
		clip:addChild(pattern)
	end

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

	local panelTitle = self:createPanelTitle(levelType, levelId, self.useSpecialActivityUI)
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
		or self.levelType == GameLevelType.kWukong
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

	local function logStageEnd(currentStage, score, star, failReason)
		DcUtil:logStageEnd(currentStage, score, star, failReason, stageTime)
	end

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

		logStageEnd(levelId, failScore, failStar, FailReason.score)
	else
		-- Target Not Reach
		-- Get Fail Description Txt
		local failDesKey = false

		he_log_warning("Dig Time Not Added !")
		he_log_warning("Dig Move Endless Not Added !")

		if gameModeName == "Classic moves" then
			failDesKey	= "level.fail.step.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "Classic" then
			failDesKey	= "level.fail.time.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.time)
		elseif gameModeName == "Drop down" then
			failDesKey	= "level.fail.drop.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "Mobile Drop down" then 
			failDesKey = "level.fail.drop.key.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "Light up" then
			failDesKey	= "level.fail.ice.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.move)
		elseif gameModeName == "DigMove" then
			failDesKey	= "level.fail.dig.step.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.move)
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

			logStageEnd(levelId, failScore, failStar, 6)
		elseif gameModeName == "DigMoveEndless" then
			failDesKey	= "level.fail.dig.endless.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "RabbitWeekly" then
			failDesKey	= "level.fail.dig.endless.mode"
			logStageEnd(levelId, failScore, failStar, FailReason.score)
		elseif gameModeName == "MaydayEndless" or gameModeName == "halloween" 
				or gameModeName == "HedgehogDigEndless" or gameModeName == "MonkeyDigEndless" then
			failDesKey	= "level.fail.mayday.endless.mode"
			logStageEnd(levelId, failScore, failStar, 19)
		elseif gameModeName == GameModeType.LOTUS then
			failDesKey	= "level.fail.meadow.mode"
			logStageEnd(levelId, failScore, failStar, 20)
		else
			print("levelModeTypeId: " .. tostring(self.levelModeTypeId))
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
		elseif self.levelType == GameLevelType.kMayDay or self.levelType == GameLevelType.kWukong then
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

	self:initJumpLevelArea()
end

function LevelFailTopPanel:createPanelTitle(levelType, levelId, useSpecialActivityUI)
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
		elseif levelType == GameLevelType.kWukong then
			levelDisplayName = Localization:getInstance():getText('春节关卡')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)
		else
			levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(levelId)
			panelTitle = PanelTitleLabel:create(levelDisplayName, nil, nil, nil, nil, nil, useSpecialActivityUI)
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
		if self.levelType and self.levelType == GameLevelType.kWukong then 
			CommonTip:showTip(Localization:getInstance():getText("小猴子与同色动物三消\n也能攒能量哦~试着移动\n猴子吧！"), 'positive')
		else
			CommonTip:showTip(Localization:getInstance():getText('level.fail.animal.tips', {n = '\n'}), 'positive')
		end
	else
		assert(false, 'failReason not supported, Check you code!')
	end
end

function LevelFailTopPanel:initJumpLevelArea( ... )
	-- body
	local area = self.ui:getChildByName("jump_level_area")
	local pos = area:getPosition()

	-- isFakeIcon31-39关可见跳关按钮，但并走真正的逻辑
	-- 只是弹出tip提示xx关开启跳关功能
	local isFakeIcon = JumpLevelManager:shouldShowFakeIcon(self.levelId)
	if JumpLevelManager:getInstance():shouldShowJumpLevelIcon(self.levelId) then
		FrameLoader:loadArmature('skeleton/jump_level_btn_animation', 'jump_level_btn_animation')
		local armature = nil
		if not isFakeIcon then
			armature = ArmatureNode:create('skip')
		else
			armature = ArmatureNode:create('skip2')
		end
		armature:playByIndex(0, 1)
		armature:update(0.001)
		armature:stop()
		self.jumpLevelIconArmature = armature
		local layer = Layer:create()
		layer:addChild(armature)
		area:getParent():addChildAt(layer, area:getZOrder())
		layer:setPosition(ccp(pos.x, pos.y))
		self.jumpLevelArea = JumpLevelIcon:create(layer, self.levelId, self.levelType, nil, isFakeIcon)
		area:setVisible(false)
	else
		area:setVisible(false)
	end
end

function LevelFailTopPanel:dispose()
	BasePanel.dispose(self)
	if self.builder then
		self.builder:unloadAsset(PanelConfigFiles.panel_game_start_activity)
	end
end

function LevelFailTopPanel:create(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason, stageTime, useSpecialActivityUI, ...)
	assert(type(parentPanel) 	== "table")
	assert(type(levelId) 		== "number")
	assert(type(levelType) 		== "number")
	assert(type(failScore) 		== "number")
	assert(type(failStar) 		== "number")
	assert(type(isTargetReached)	== "boolean")
	--assert(levelModeTypeId)

	local newLevelFailTopPanel = LevelFailTopPanel.new()
	newLevelFailTopPanel:init(parentPanel, levelId, levelType, failScore, failStar, isTargetReached, failReason, stageTime, useSpecialActivityUI)
	return newLevelFailTopPanel
end

function LevelFailTopPanel:afterPopout()
	if self.jumpLevelIconArmature then
		self.jumpLevelIconArmature:playByIndex(0, 1)
	end
end