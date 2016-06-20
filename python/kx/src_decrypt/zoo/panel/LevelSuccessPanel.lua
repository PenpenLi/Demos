
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月17日 18:21:04
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.panel.component.levelSuccessPanel.LevelSuccessTopPanel"

---------------------------------------------------
-------------- LevelSuccessPanel
---------------------------------------------------

assert(not LevelSuccessPanel)
assert(PanelWithRankList)
LevelSuccessPanel = class(PanelWithRankList)

function LevelSuccessPanel:init(levelId, levelType, newScore, rewardItems, extraCoin, activityForceShareData, ...)
	assert(type(levelId) == "number")
	assert(type(newScore) == "number")
	assert(type(rewardItems) == "table")
	assert(type(extraCoin) == "number")
	assert(#{...} == 0)

	self.hiddenRankList = false

	-- 确认是否使用特殊活动UI，为了搜索方便使用完全相同的变量名
	local useSpecialActivityUI = WorldSceneShowManager:getInstance():isInAcitivtyTime() 
		and (levelType == GameLevelType.kMainLevel or levelType == GameLevelType.kHiddenLevel or levelType == GameLevelType.kWukong)

	-- 活动关不显示排行
	local showRankList = LevelType.isShowRankList(levelType)
	if not showRankList then
		self.hiddenRankList = true
	end
	-----------------
	--- Create UI Component
	-----------------------
	self.levelSuccessTopPanel	= LevelSuccessTopPanel:create(self, levelId, levelType, newScore, rewardItems, extraCoin, activityForceShareData, useSpecialActivityUI)

	-- ---------------
	-- Init Base Class
	-- ---------------
	PanelWithRankList.init(self, levelId, levelType, self.levelSuccessTopPanel, "levelSuccessPanel", useSpecialActivityUI)

	--------------------
	-- Data Control Position
	-- --------------------
	local topPanel		= self:getTopPanel()
	local rankList		= self:getRankList()
	self.popRemoveAnim	= PanelWithRankPopRemoveAnim:create(self, topPanel, rankList)
	-- self.popRemoveAnim = PanelWithRankExchangeAnim:create(self, topPanel, rankList)

	local topPanelHeight	= topPanel:getGroupBounds().size.height
	local rankListHeight	= rankList:getGroupBounds().size.height

	-------------------------------------------------
	--- Set Top Panel And Rank List Initial Position
	-------------------------------------------------
	
	-- Get Config From PanelConfig.lua
	local config = StartGamePanelConfig:create(self)

	------------------------------------
	-- Config Show / Hide Animation
	-- ------------------------------

	local topPanelInitX = config:topPanelInitX()
	local topPanelInitY = config:topPanelInitY()
	self:setTopPanelInitPos(topPanelInitX, topPanelInitY)			-- This Control Drag Rank List Panel

	local topPanelExpanX	= config:topPanelExpanX()
	local topPanelExpanY	= config:topPanelExpanY()
	self:setTopPanelExpanPos(topPanelExpanX, topPanelExpanY)

	local rankListInitX	= config:rankListInitX()
	local rankListInitY	= config:rankListInitY()
	self:setRankListInitPos(rankListInitX, rankListInitY)

	local rankListExpanX	= config:rankListExpanX()
	local rankListExpanY	= config:rankListExpanY()
	self:setRankListExpanPos(rankListExpanX, rankListExpanY)

	-------------------------------------
	-- Config Show / Hide Animation
	-- ------------------------------
	self.popRemoveAnim:setTopPanelShowPos(topPanelInitX, topPanelInitY)
	self.popRemoveAnim:setTopPanelHidePos(topPanelInitX, topPanelHeight)

	self.popRemoveAnim:setRankListPopShowPos(rankListInitX, rankListInitY)
	self.popRemoveAnim:setRankListPopHidePos(rankListInitX, topPanelInitY - topPanelHeight + rankListHeight + 100)

	---------------------------------------
	--  Scale According To Screen Resolution
	--  -------------------------------------
	self:scaleAccordingToResolutionConfig()
end

function LevelSuccessPanel:popout(...)
	assert(#{...} == 0)

	local function popoutFinishCallback()
		self:setRankListPanelTouchEnable()
		self.allowBackKeyTap	= true
		self.levelSuccessTopPanel:playAnimation()

		if self.useSpecialActivityUI then
			local size = self.rankListPanelClipping:getContentSize()
			self.rankListPanelClipping:setContentSize(CCSizeMake(size.width, size.height + 300))
		end
	end

	self.popRemoveAnim:popout(popoutFinishCallback)
end

function LevelSuccessPanel:onCloseBtnTapped(...)
	assert(#{...} == 0)

	GamePlayMusicPlayer:playEffect(GameMusicType.kPanelVerticalPopout)
	self.levelSuccessTopPanel:onCloseBtnTapped()
end

function LevelSuccessPanel:remove(animFinishCallback)
	self:removeRankListPanelSceneListener()
	self.popRemoveAnim:remove(animFinishCallback)
end

function LevelSuccessPanel:create(levelId, levelType, newScore, rewardItems, extraCoin, activityForceShareData, ...)
	assert(type(levelId) == "number")
	assert(type(levelType) == "number")
	assert(type(newScore) == "number")
	assert(type(rewardItems) == "table")
	assert(type(extraCoin) == "number")

	assert(#{...} == 0)

	local newLevelSuccessPanel = LevelSuccessPanel.new()
	newLevelSuccessPanel:init(levelId, levelType, newScore, rewardItems, extraCoin, activityForceShareData)
	return newLevelSuccessPanel
end

function LevelSuccessPanel:setStarInitialPosInWorldSpace(starIndex, worldPos, ...)
	assert(type(starIndex) == "number")
	assert(type(worldPos) == "userdata")
	assert(#{...} == 0)

	self.levelSuccessTopPanel:setStarInitialPosInWorldSpace(starIndex, worldPos)
end

function LevelSuccessPanel:setStarInitialSize(starIndex, width, height, ...)
	assert(type(starIndex)	== "number")
	assert(type(width)	== "number")
	assert(type(height)	== "number")
	assert(#{...} == 0)

	self.levelSuccessTopPanel:setStarInitialSize(starIndex, width, height)
end

function LevelSuccessPanel:registerHideScoreProgressBarStarCallback(hideStarCallback, ...)
	assert(type(hideStarCallback) == "function")
	assert(#{...} == 0)

	self.levelSuccessTopPanel:registerHideScoreProgressBarStarCallback(hideStarCallback)
end
