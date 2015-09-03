
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013年09月18日 11:47:16
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.common.CommonAction"
require "hecore.display.ParticleSystem"
require "zoo.panel.component.levelSuccessPanel.RewardItem"
require "zoo.data.MetaManager"

require "zoo.panel.component.common.BubbleCloseBtn"

---------------------------------------------------
-------------- LevelSuccessTopPanel
---------------------------------------------------

assert(not LevelSuccessTopPanel)
assert(BaseUI)
LevelSuccessTopPanel = class(BaseUI)
function LevelSuccessTopPanel:dispose()
	BaseUI.dispose(self)
	print("dispose levelSuccessTopPanel")
end

function LevelSuccessTopPanel:init(parentPanel, levelId, levelType, newScore, rewardItemsDataFromServer, extraCoin, ...)
	assert(parentPanel)
	assert(type(levelId) == "number")
	assert(type(newScore) == "number")
	assert(rewardItemsDataFromServer)
	assert(extraCoin)
	assert(#{...} == 0)

	-- ---------------
	-- Get UI Resource
	-- ----------------
	self.ui	= ResourceManager:sharedInstance():buildGroup("levelSuccessPanel/levelSuccessTopPanel")

	-- ----------------
	-- Init Base Class
	-- -------------------
	BaseUI.init(self, self.ui)

	-----------------
	---- Get UI Resource
	---------------------
	self.scoreLabel		= self.ui:getChildByName("scoreLabel")
	self.rewardTxt		= self.ui:getChildByName("rewardTxt")
	self.star1Res		= self.ui:getChildByName("star1")
	self.star2Res		= self.ui:getChildByName("star2")
	self.star3Res		= self.ui:getChildByName("star3")
	self.star4Res 		= self.ui:getChildByName("star4")

	self.starRes		= {self.star1Res, self.star2Res, self.star3Res, self.star4Res}

	self.star1Bg		= self.ui:getChildByName("star1Bg")
	self.star2Bg		= self.ui:getChildByName("star2Bg")
	self.star3Bg		= self.ui:getChildByName("star3Bg")
	self.star4Bg 		= self.ui:getChildByName("star4Bg")
	self.starBgs 		= {self.star1Bg, self.star2Bg, self.star3Bg, self.star4Bg}
	self.star4Bg:setVisible(false) --  hide the forth star


	self.rewardItem1Res	= self.ui:getChildByName("rewardItem1")
	self.rewardItem2Res	= self.ui:getChildByName("rewardItem2")
	self.rewardItem3Res	= self.ui:getChildByName("rewardItem3")
	self.nextLevelBtnRes	= self.ui:getChildByName("nextLevelBtn")
	self.shareToWeiBoBtnRes	= self.ui:getChildByName("shareToWeiBoBtn")
	if self.shareToWeiBoBtnRes then 
		local weiboIcon = self.shareToWeiBoBtnRes:getChildByName("weixinIcon")
		local fbIcon = self.shareToWeiBoBtnRes:getChildByName("facebookIcon")
		local miTalkIcon = self.shareToWeiBoBtnRes:getChildByName("miTalkIcon")
		weiboIcon:setVisible(false)
		fbIcon:setVisible(false)
		miTalkIcon:setVisible(false)
		if __IOS_FB then fbIcon:setVisible(true) 
		elseif PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then miTalkIcon:setVisible(true)
		else weiboIcon:setVisible(true) 
		end
	end

	self.happyAnimalBgLayer	= self.ui:getChildByName("happyAnimalBgLayer")

	self.yellowBg		= self.ui:getChildByName("yellowBg")
	self.bg			= self.ui:getChildByName("bg")
	self.closeBtnRes	= self.bg:getChildByName("closeBtn")

	self.panelTitlePlaceholder	= self.ui:getChildByName("panelTitlePlaceholder")

	assert(self.scoreLabel)
	assert(self.rewardTxt)
	assert(self.star1Res)
	assert(self.star2Res)
	assert(self.star3Res)

	assert(self.star1Bg)
	assert(self.star2Bg)
	assert(self.star3Bg)

	assert(self.rewardItem1Res)
	assert(self.rewardItem2Res)
	assert(self.rewardItem3Res)
	assert(self.nextLevelBtnRes)

	assert(self.shareToWeiBoBtnRes)

	assert(self.happyAnimalBgLayer)

	assert(self.yellowBg)
	assert(self.bg)
	assert(self.closeBtnRes)

	assert(self.panelTitlePlaceholder)

	---------------
	-- Init UI
	-- -------------
	self.star1Res:setAnchorPointCenterWhileStayOrigianlPosition()
	self.star2Res:setAnchorPointCenterWhileStayOrigianlPosition()
	self.star3Res:setAnchorPointCenterWhileStayOrigianlPosition()
	self.star4Res:setAnchorPointCenterWhileStayOrigianlPosition()

	for index = 1, #self.starRes do
		self.starRes[index]:setVisible(false)
	end

	self.panelTitlePlaceholder:setVisible(false)
	self.panelTitlePlaceholderPosY = self.panelTitlePlaceholder:getPositionY()

	-------------------------
	---- Get Data About UI
	-------------------------
	self.starResInitWorldPos = {
	}

	self.starResInitScale = {
		{scaleX = self.star1Res:getScaleX(), scaleY = self.star1Res:getScaleY()},
		{scaleX = self.star2Res:getScaleX(), scaleY = self.star2Res:getScaleY()},
		{scaleX = self.star3Res:getScaleX(), scaleY = self.star3Res:getScaleY()},
		{scaleX = self.star4Res:getScaleX(), scaleY = self.star4Res:getScaleY()}
	}

	self.starResInitPos = {
			ccp(self.star1Res:getPositionX(), self.star1Res:getPositionY()),
			ccp(self.star2Res:getPositionX(), self.star2Res:getPositionY()),
			ccp(self.star3Res:getPositionX(), self.star3Res:getPositionY()),
			ccp(self.star4Res:getPositionX(), self.star4Res:getPositionY())
		}

	self.starResInitZOrder = {
		self.star1Res:getZOrder(),
		self.star2Res:getZOrder(),
		self.star3Res:getZOrder(),
		self.star4Res:getZOrder()
	}

	-------------------------
	---- Create UI Component
	-----------------------
	self.rewardItem1	= RewardItem:create(self.rewardItem1Res, false) 
	self.rewardItem2	= RewardItem:create(self.rewardItem2Res, false)
	self.rewardItem3	= RewardItem:create(self.rewardItem3Res, false)
	self.rewardItems 	= {self.rewardItem1, self.rewardItem2, self.rewardItem3}

	self.closeBtn		= BubbleCloseBtn:create(self.closeBtnRes)
	self.nextLevelBtn	= ButtonWithShadow:create(self.nextLevelBtnRes)
	self.shareToWeiBoBtn	= ButtonWithShadow:create(self.shareToWeiBoBtnRes)

	self.levelId		= levelId
	self.levelType 		= levelType
	self.parentPanel 	= parentPanel
	self.newScore		= newScore
	self.extraCoin		= extraCoin

	-- Create Panel Tilte
	local panelTitle = self:createPanelTitle(levelId, self.levelType)
	-- local contentSize = panelTitle:getContentSize()
	self.ui:addChild(panelTitle)
	panelTitle:ignoreAnchorPointForPosition(false)
	panelTitle:setAnchorPoint(ccp(0,1))
	panelTitle:setPositionY(self.panelTitlePlaceholderPosY)
	panelTitle:setToParentCenterHorizontal()
	---------------------
	----  Data
	--------------------
	self.metaModel			= MetaModel:sharedInstance()
	self.metaManager		= MetaManager.getInstance()

	self.rewardItemsDataFromServer	= rewardItemsDataFromServer
	self.newStarLevel 	= self:getStarLevelByScore(self.newScore)

	if self.newStarLevel == 4 then
		for k, v in pairs(self.starBgs) do
			local offset = (tonumber(k) - 2.5) * 10
			v:setRotation(offset)
			v:setVisible(true)
			v:setAnchorPoint(ccp(0.5, 0.5))
			local pos = self.ui:getChildByName('fourStarLocator'..k):getPosition()
			v:setPosition(ccp(pos.x, pos.y))
			v:setScale(0.9)
		end
	end

	----------------------
	-- Flag To Indicate Btn Tapped State
	-- ----------------------------------
	self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED	= 1
	self.BTN_TAPPED_STATE_NEXT_BTN_TAPPED	= 2
	self.BTN_TAPPED_STATE_NONE		= 3
	self.btnTappedState			= self.BTN_TAPPED_STATE_NONE

	-- Get Cur Level Old Star And Score
	local curLevelScoreRef	= UserManager:getInstance():getUserScore(self.levelId)
	local oldLevelScoreRef	= UserManager:getInstance():getOldUserScore(self.levelId)

	---- When This If First Complete A Level, Ther Is No Old Score
	----assert(curLevelScoreRef)
	
	he_log_warning("this logic should implemented in UserManager !")
	self.oldStarLevel	= false
	self.oldScore		= false

	if oldLevelScoreRef then
		self.oldStarLevel	= oldLevelScoreRef.star
		self.oldScore		= oldLevelScoreRef.score
	else
		self.oldStarLevel	= 0
		self.oldScore		= 0
	end

	print("self.oldStarLevel: " .. self.oldStarLevel)

	------------------------------------
	-- Data About Callback During Action 
	-- -------------------------------
	self.hideStarCallback = false

	-- Cur Level Reward
	self.level_reward = self.metaManager:getLevelRewardByLevelId(self.levelId)
	assert(self.level_reward)

	---------------------------
	-- Update View
	--------------------------
	-- Set Reward Item rewardItemId
	-- he_log_warning("??")
	-- assert(#self.level_reward <= #self.rewardItems)

	-- Get Reward Txt
	local rewardTxtKey	= "level.success.reward.txt"
	local rewardTxtValue	= Localization:getInstance():getText(rewardTxtKey, {})
	self.rewardTxt:setString(rewardTxtValue)

	-- Get Score Txt
	-- And Set Score
	local scoreTxtKey	= "level.success.score.txt"
	local scoreTxtValue	= Localization:getInstance():getText(scoreTxtKey)
	self.scoreLabel:setString(scoreTxtValue .. tostring(self.newScore))

	-- Get Next Level Button Label Txt
	if PublishActUtil:isGroundPublish() then
		self.nextLevelBtn:setString(Localization:getInstance():getText("prop.info.panel.close.txt", {}))
		self.nextLevelBtn:setPositionX(self.nextLevelBtn:getPositionX() + 100)
		self.shareToWeiBoBtn.ui:setTouchEnabled(false)
		self.shareToWeiBoBtn:setVisible(false)
	else
		if self.levelType == GameLevelType.kMainLevel then
			local nextLevelBtnTxtkey	= "level.success.next.level.button.label.txt"
			local nextLevelBtnTxt	= Localization:getInstance():getText(nextLevelBtnTxtkey)
			self.nextLevelBtn:setString(nextLevelBtnTxt)
		else
			local replayBtnTxtKey	= "button.ok"
			local replayBtnTxt	= Localization:getInstance():getText(replayBtnTxtKey, {})
			self.nextLevelBtn:setString(replayBtnTxt)
		end
	end

	local shareToWeiBoBtnTxtKey	= "level.success.share.to.weibo.btn.label"
	local shareToWeiBoBtnTxtValue	= Localization:getInstance():getText(shareToWeiBoBtnTxtKey, {})
	self.shareToWeiBoBtn:setString(shareToWeiBoBtnTxtValue)

	local manualAdjustLabelX	= -3
	local manualAdjustLabelY	= -10
	local label 		= self.nextLevelBtn:getLabel()
	local labelCurPos	= label:getPosition()
	label:setPosition(ccp(labelCurPos.x + manualAdjustLabelX, labelCurPos.y + manualAdjustLabelY))

	-- Set Star Score Label
	local curLevelScoreTarget = self.metaModel:getLevelTargetScores(self.levelId)
	local star1Score	= curLevelScoreTarget[1]
	local star2Score	= curLevelScoreTarget[2]
	local star3Score	= curLevelScoreTarget[3]

	-- ----------------------------------
	-- Set Default Reward Items Number
	-- ----------------------------------

	-- Convert rewardItemsDataFromServer To , Key = ItemId, Value = Number Format
	self.rewardsFromServer	= {}
	for k,v in pairs(self.rewardItemsDataFromServer) do
		local num = self.rewardsFromServer[v.itemId] or 0
		self.rewardsFromServer[v.itemId] = num + v.num
	end

	if not _isQixiLevel then -- qixi
		local allRewardIds = self:getAllRewardIds(self.levelId, self.levelType)
		
		local smallestLevel = math.min(self.oldStarLevel, self.newStarLevel)
		local defaultRewards = self:getDefaultRewards(self.level_reward, smallestLevel)
		local index = 1
		for k,v in pairs(allRewardIds) do
			self.rewardItems[index]:setRewardId(tonumber(v))
			index = index + 1
		end
		-- update default rewards
		for itemId,num in pairs(defaultRewards) do
			local rewardItemComponent = self:getRewardItemComponentFromItemId(itemId)
			assert(rewardItemComponent)
			rewardItemComponent:addNumber(num)
		end
	end

	---------------------------
	--- Add Event Listener
	------------------------
	-- Next Level Button Event Listener
	-- only main level has play next level button
	local function onNextLevelBtnTapped(event)
		if PublishActUtil:isGroundPublish() then
			self:onCloseBtnTapped(event)
		elseif self.levelType == GameLevelType.kMainLevel then
			self:onNextLevelBtnTapped(event)
		else
			self:onCloseBtnTapped(event)
		end
	end
	self.nextLevelBtn.ui:addEventListener(DisplayEvents.kTouchTap, onNextLevelBtnTapped)

	-- Close Button Event Listener
	local function onCloseBtnTapped(event)
		self:onCloseBtnTapped(event)
	end
	self.closeBtn.ui:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)

	-- For Restore Anim
	self.overlayAnims = {}

	-- four star logic
	self.ui:getChildByName('flowers_deco'):setVisible(false)
	for i=1, 4 do
		self.ui:getChildByName('fourStarLocator'..i):setVisible(false)
	end

	if LevelType.isShareEnable(self.levelType) then
		local function onShareToWeiBoBtnTapped()
			if PrepackageUtil:isPreNoNetWork() then
				PrepackageUtil:showInGameDialog()
			else
				self:onShareToWeiBoBtnTapped()
			end
		end
		self.shareToWeiBoBtn.ui:addEventListener(DisplayEvents.kTouchTap, onShareToWeiBoBtnTapped)
	else
		self.shareToWeiBoBtn.ui:setTouchEnabled(false)
		self.shareToWeiBoBtn:setVisible(false)
		self.nextLevelBtn:setPositionX(self.nextLevelBtn:getPositionX() + 100)
	end
end

function LevelSuccessTopPanel:getAllRewardIds( levelId, levelType )
	local allRewardIds = {}
	for k, v in pairs(self.level_reward.oneStarReward) do
		if not allRewardIds[v.itemId] then
			allRewardIds[v.itemId] = v.itemId
		end
	end
	for k, v in pairs(self.level_reward.twoStarReward) do
		if not allRewardIds[v.itemId] then
			allRewardIds[v.itemId] = v.itemId
		end
	end
	for k, v in pairs(self.level_reward.threeStarReward) do
		if not allRewardIds[v.itemId] then
			allRewardIds[v.itemId] = v.itemId
		end
	end
	for k, v in pairs(self.level_reward.fourStarReward) do
		if not allRewardIds[v.itemId] then
			allRewardIds[v.itemId] = v.itemId
		end
	end

	-- 活动道具
	if self.levelType == GameLevelType.kDigWeekly then
		allRewardIds[ItemType.GEM] = ItemType.GEM
	elseif self.levelType == GameLevelType.kMayDay then
		allRewardIds[ItemType.XMAS_BOSS] = ItemType.XMAS_BOSS
		allRewardIds[ItemType.XMAS_BELL] = ItemType.XMAS_BELL
	elseif self.levelType == GameLevelType.kRabbitWeekly then
		allRewardIds[ItemType.WEEKLY_RABBIT] = ItemType.WEEKLY_RABBIT
	elseif self.levelType == GameLevelType.kTaskForUnlockArea then 
		allRewardIds[ItemType.KEY_GOLD] = ItemType.KEY_GOLD
	end
	return allRewardIds
end

function LevelSuccessTopPanel:onNextLevelBtnTapped( event, ... )
	if  self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_NEXT_BTN_TAPPED
	else
		return
	end
	self:callLevelPassedCallback(true)
end

function LevelSuccessTopPanel:getDefaultRewards( levelReward, smallestLevel )
	assert(levelReward)

	local result = {}
	-- 过关默认奖励
	for starLevel = 1, smallestLevel do
		local defaultRewards = false
		if starLevel == 1 then
			defaultRewards = levelReward.oneStarDefaultReward
		elseif starLevel == 2 then
			defaultRewards = levelReward.twoStarDefaultReward
		elseif starLevel == 3 then
			defaultRewards = levelReward.threeStarDefaultReward
		elseif starLevel == 4 then
			defaultRewards = levelReward.fourStarDefaultReward
		end
		assert(defaultRewards)

		for k,rewardItemRef in ipairs(defaultRewards) do
			local num = result[rewardItemRef.itemId] or 0
			result[rewardItemRef.itemId] = num + rewardItemRef.num
		end
	end

	-- 活动道具
	local function getRewardItemNumber(itemId)
		for k, v in ipairs(self.rewardItemsDataFromServer) do
			if v.itemId == itemId then return v.num end
		end
		return 0
	end
	if self.levelType == GameLevelType.kDigWeekly then
		result[ItemType.GEM] = getRewardItemNumber(ItemType.GEM)
	elseif self.levelType == GameLevelType.kMayDay then
		result[ItemType.XMAS_BOSS] = getRewardItemNumber(ItemType.XMAS_BOSS)
		result[ItemType.XMAS_BELL] = getRewardItemNumber(ItemType.XMAS_BELL)
	elseif self.levelType == GameLevelType.kRabbitWeekly then
		result[ItemType.WEEKLY_RABBIT] = getRewardItemNumber(ItemType.WEEKLY_RABBIT)
	elseif self.levelType == GameLevelType.kTaskForUnlockArea then 
		result[ItemType.KEY_GOLD] = 1
	end

	-- Extra Coin
	local coinNum = result[ItemType.COIN] or 0
	local extraCoinRatio = MetaManager.getInstance().global.coin 
	result[ItemType.COIN] = coinNum + self.extraCoin * extraCoinRatio

	return result
end

function LevelSuccessTopPanel:createPanelTitle( levelId, levelType )
	local levelDisplayName
	local panelTitle
	if PublishActUtil:isGroundPublish() then
		panelTitle = BitmapText:create("精彩活动关", "fnt/titles.fnt", -1, kCCTextAlignmentCenter)
	else
		-- compatible with weekly race mode
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
		elseif levelType == GameLevelType.kTaskForRecall or levelType == GameLevelType.kTaskForUnlockArea then
			levelDisplayName = Localization:getInstance():getText('recall_text_5')
			local len = math.ceil(string.len(levelDisplayName) / 3) -- chinese char is 3 times longer
			panelTitle = PanelTitleLabel:createWithString(levelDisplayName, len)		
		else
			print("levelId", levelId)
			levelDisplayName = LevelMapManager.getInstance():getLevelDisplayName(levelId)
			panelTitle = PanelTitleLabel:create(levelDisplayName)
		end
	end
	return panelTitle
end

function LevelSuccessTopPanel:restoreToOriginalPos(...)
	assert(#{...} == 0)

	self:restoreStarToOriginalPos()
end

-- ------------------------------------------------------
-- The Star Which In The Score Progress Bar's Position
-- --------------------------------------------------------

function LevelSuccessTopPanel:setStarInitialPosInWorldSpace(starIndex, worldPos, ...)
	assert(type(starIndex) == "number")
	assert(type(worldPos) == "userdata")
	assert(#{...} == 0)

	self.starResInitWorldPos[starIndex] = ccp(worldPos.x, worldPos.y)
end

function LevelSuccessTopPanel:registerHideScoreProgressBarStarCallback(hideStarCallback, ...)
	assert(type(hideStarCallback) == "function")
	assert(#{...} == 0)

	self.hideStarCallback = hideStarCallback
end

function LevelSuccessTopPanel:getStarPosFromWorldSpace(...)
	assert(#{...} == 0)

	if #self.starResInitWorldPos > 0 then
		for index = 1,#self.starResInitWorldPos do
			local posInWorld = self.starResInitWorldPos[index]
			self.starResInitPos[index] = self.ui:convertToNodeSpace(ccp(posInWorld.x, posInWorld.y))
		end
	else
		assert(false, "should set the world pos first !")
	end
end

function LevelSuccessTopPanel:setStarInitialSize(starIndex, width, height, ...)
	assert(type(starIndex)	== "number")
	assert(type(width)	== "number")
	assert(type(height)	== "number")
	assert(#{...} == 0)

	local star = self:getStarByIndex(starIndex)

	local curSize = star:getGroupBounds().size

	local deltaScaleX = width / curSize.width
	local deltaScaleY = height / curSize.height

	self.starResInitScale[starIndex] = {scaleX = deltaScaleX, scaleY = deltaScaleY}
end

function LevelSuccessTopPanel:restoreStarToOriginalPos(...)
	assert(#{...} == 0)

	for index = 1, 3 do

		local originalPos = self.starResInitPos[index]
		local star = self.starRes[index]

		star:setPosition(ccp(originalPos.x, originalPos.y))
		star:stopAllActions()

		star:removeFromParentAndCleanup(false)
		self.ui:addChildAt(star, self.starResInitZOrder[index])
	end
end

function LevelSuccessTopPanel:restoreStarToInitialScale(...)
	assert(#{...} == 0)

	assert(#self.starResInitScale)

	for index = 1, #self.starResInitScale do

		local star = self.starRes[index]

		star:setScaleX(self.starResInitScale[index].scaleX)
		star:setScaleY(self.starResInitScale[index].scaleY)
	end
end

function LevelSuccessTopPanel:getStarByIndex(index, ...)
	assert(type(index) == "number")
	assert(#{...} == 0)

	local star = self.starRes[index]
	assert(star)
	return star
end

function LevelSuccessTopPanel:getStarBgByIndex(index, ...)
	assert(type(index) == "number")
	assert(#{...} == 0)

	local bg = self.starBgs[index]
	assert(bg)

	return bg
end

function LevelSuccessTopPanel:getStarBgCenterByIndex(index, ...)
	assert(type(index) == "number")
	assert(#{...} == 0)

	if self.newStarLevel < 4 then 
		local bg = self:getStarBgByIndex(index)

		local bgSize	= bg:getGroupBounds(self).size
		local bgPos	= bg:getPosition()

		local centerX = bgPos.x + bgSize.width / 2
		local centerY = bgPos.y - bgSize.height / 2
		return ccp(centerX, centerY)
	else
		local bgPos = self.ui:getChildByName('fourStarLocator'..index):getPosition()
		local centerX = bgPos.x
		local centerY = bgPos.y
		return ccp(centerX, centerY)
	end

end

function LevelSuccessTopPanel:onShareToWeiBoBtnTapped(...)
	assert(#{...} == 0)
	
	if not self.isOnShareToWeiBoBtnTappedCalled then
		self.isOnShareToWeiBoBtnTappedCalled = true

		print("LevelSuccessTopPanel:onShareToWeiBoBtnTapped Called !")

		if __IOS_FB then -- facebook
			if not SnsProxy:isShareAvailable() then
				-- SnsProxy:shareLogin()
				self.isOnShareToWeiBoBtnTappedCalled = false
			else
				local shareTitle = Localization:getInstance():getText("share.feed.title")
				
				local timer = os.time() or 0
				local datetime = tostring(os.date("%y%m%d", timer))
				local txtToShare = nil
				local imageURL = nil
				if self.levelType == GameLevelType.kMainLevel then
					txtToShare = Localization:getInstance():getText("share.feed.text", {level=self.levelId})
					imageURL = string.format("http://statictw.animal.he-games.com/mobanimal/fb/level/fb%04d.jpg?v="..datetime, self.levelId)
				elseif self.levelType == GameLevelType.kHiddenLevel then
					local hidenLevelId = self.levelId - LevelConstans.HIDE_LEVEL_ID_START
					txtToShare = Localization:getInstance():getText("share.feed.text", {level="+"..hidenLevelId})
					imageURL = string.format("http://statictw.animal.he-games.com/mobanimal/fb/level/yc%04d.jpg?v="..datetime, hidenLevelId)
				end

				-- imageURL = "http://c.hiphotos.baidu.com/image/h%3D800%3Bcrop%3D0%2C0%2C1280%2C800/sign=d32e0d42808ba61ec0eec52f710ff478/ca1349540923dd543455ace0d309b3de9c824817.jpg"
				
				local callback = {
					onSuccess = function(result)
						print("result="..table.tostring(result))	
						self.isOnShareToWeiBoBtnTappedCalled = false
						CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips"), "positive")
						DcUtil:shareFeed("next_level",self.levelId,self.newScore)
						DcUtil:logSendNewsFeed("feed",result.id,"feed_pass_level")
					end,
					onError = function(err)
						print("err="..err)
						self.isOnShareToWeiBoBtnTappedCalled = false
						local item = RequireNetworkAlert.new(CCNode:create())
						item:buildUI(Localization:getInstance():getText("share.feed.faild.tips"))
						local scene = Director:sharedDirector():getRunningScene()
						if scene then 
							scene:addChild(item) 
						end
						DcUtil:shareFeed("next_level",self.levelId,self.newScore)
					end
				}
				local image = {{url=imageURL, user_generated="true"}}
				SnsProxy:sendNewFeedsWithParams(FBOGActionType.PASS, FBOGObjectType.LEVEL, shareTitle, txtToShare, image, link, callback)
			end
		else
			local shareCallback = {
				onSuccess = function(result)
					print("result="..table.tostring(result))	
					self.isOnShareToWeiBoBtnTappedCalled = false
					-- CommonTip:showTip(Localization:getInstance():getText("share.feed.success.tips.mitalk"), "positive")
				end,
				onError = function(errCode, msg)
					print("err="..tostring(errCode))
					self.isOnShareToWeiBoBtnTappedCalled = false
				end,
				onCancel = function()
					self.isOnShareToWeiBoBtnTappedCalled = false
				end
			}

			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				SnsUtil.sendLevelMessage( PlatformShareEnum.kMiTalk, self.levelType, self.levelId, shareCallback )
			else
				SnsUtil.sendLevelMessage( PlatformShareEnum.kWechat, self.levelType, self.levelId, nil )
				
				local delay	= CCDelayTime:create(1)
				local function onDelayFinished()
				 	self.isOnShareToWeiBoBtnTappedCalled = false
				end
				local callFuncAction = CCCallFunc:create(onDelayFinished)

				local seq = CCSequence:createWithTwoActions(delay, callFuncAction)
				self:runAction(seq)
			end
			DcUtil:shareFeed("next_level",self.levelId,self.newScore)
		end	
	end
end

function LevelSuccessTopPanel:onCloseBtnTapped(event, ...)
	assert(#{...} == 0)

	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_CLOSE_BTN_TAPPED
	else
		return
	end
	
	self:callLevelPassedCallback(false)
end

function LevelSuccessTopPanel:callLevelPassedCallback(isStartPanelAutoPopout, ...)
	assert(#{...} == 0)

	--------------------
	-- Get Reward Pos
	-- ----------------
	--for k,v in pairs(self.newStarLevelReward) do
	--for itemId,num in pairs(self.rewardItemsDataFromServer) do
	for itemId,num in pairs(self.rewardsFromServer) do
		-- Reward Item
		--local rewardItemRes = self:getRewardItemByRewardId(v.itemId)
		local rewardItemRes = self:getRewardItemByRewardId(itemId)
		assert(rewardItemRes)

		local rewardItemPos		= rewardItemRes:getPosition()
		local rewardItemParent 		= rewardItemRes:getParent()
		local rewardItemPosInWorldspace	= rewardItemParent:convertToWorldSpace(ccp(rewardItemPos.x, rewardItemPos.y))
		
		--v.posInWorld	= ccp(rewardItemPosInWorldspace.x, rewardItemPosInWorldspace.y)
		self.rewardsFromServer[itemId] = { itemId = itemId, posInWorld = ccp(rewardItemPosInWorldspace.x, rewardItemPosInWorldspace.y)}
	end

	PopoutManager:sharedInstance():remove(self.parentPanel, true)

	if self.levelType == GameLevelType.kMainLevel 
			or self.levelType == GameLevelType.kHiddenLevel then	
		HomeScene:sharedInstance():setEnterFromGamePlay(self.levelId)
	end
	
	Director:sharedDirector():popScene()

	-- Return Successed Level Id, And Play Next Level = True
	--self.levelPassedCallback(self.levelId, self.newStarLevelReward, true)

	if self.levelType == GameLevelType.kMayDay then
		GamePlayEvents.dispatchPassLevelEvent({levelType=self.levelType, levelId=self.levelId, rewardsIdAndPos=self.rewardItemsDataFromServer, isPlayNextLevel=false})
	else
		GamePlayEvents.dispatchPassLevelEvent({levelType=self.levelType, levelId=self.levelId, rewardsIdAndPos=self.rewardsFromServer, isPlayNextLevel=isStartPanelAutoPopout})
	end
end

function LevelSuccessTopPanel:getRewardItemComponentFromItemId(itemId, ...)
	assert(itemId)
	assert(type(itemId) == "number")
	assert(#{...} == 0)

	for index = 1,#self.rewardItems do

		local rewardId = self.rewardItems[index]:getRewardId()
		if rewardId == itemId then
			return self.rewardItems[index]
		end
	end

	return nil
end

function LevelSuccessTopPanel:getStarLevelByScore(score, ...)
	assert(score)
	assert(#{...} == 0)

	print("!!!!!!!!!!!!!!! LevelSuccessTopPanel:getStarLevelByScore !!!!!!!!!!!!!!!!!!!")

	-- Get Cur Level Target Scores
	local curLevelScoreTarget = self.metaModel:getLevelTargetScores(self.levelId)

	local star1Score	= curLevelScoreTarget[1]
	local star2Score	= curLevelScoreTarget[2]
	local star3Score	= curLevelScoreTarget[3]
	local star4Score 	= curLevelScoreTarget[4]

	local starLevel = false
	if score < star1Score then
		starLevel = 0
	elseif score >= star1Score and score < star2Score then
		starLevel = 1
	elseif score >= star2Score and score < star3Score then
		starLevel = 2
	elseif score >= star3Score then
		starLevel = 3
		if star4Score ~= nil and score > star4Score then
			starLevel = 4
		end
	else	
		assert(false)
	end

	print("score: " .. score)
	print("star1Score: " .. star1Score)
	print("star2Score: " .. star2Score)
	print("star3Score: " .. star3Score)
	print("starLevel: " .. starLevel)
	print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!")

	return starLevel
end

---------------------------------------------------
-------	Start Animation
----------------------------------------------

function LevelSuccessTopPanel:playAnimation(...)
	assert(#{...} == 0)

	self:getStarPosFromWorldSpace()

	-- Restore happyAnimalsAnim
	if self.happyAnimalsAnim then
		self.happyAnimalsAnim:removeFromParentAndCleanup(true)
		self.happyAnimalsAnim = false
	end
	-- Restore Pop Txt Anim
	if self.passLevelTxtRes then
		self.passLevelTxtRes:removeFromParentAndCleanup(true)
		self.passLevelTxtRes = false
	end
	-- Restore Star Anim
	self:restoreStarToOriginalPos()
	self:restoreStarToInitialScale()

	if self.overlayAnims then
		for k,v in pairs(self.overlayAnims) do
			v:removeFromParentAndCleanup(true)
		end
	end

	local actionArray = CCArray:create()

	-- --------------------
	-- Happy Animals Anim
	-- -------------------
	local happyAnimalsAnim = self:createHappyAnimalsAction()
	actionArray:addObject(happyAnimalsAnim)

	-- -----------------
	-- Pop Out Txt Anim
	-- ------------------
	local passLevelTxtAnim = self:createPopoutPassLevelTxtAnim()
	actionArray:addObject(passLevelTxtAnim)

	-- ---------------------------
	-- Create Parabola Stars Anim
	-- ---------------------------

	if self.newStarLevel > 0 and self.newStarLevel < 4 then

		local parabolaStarActionArray = CCArray:create()
		local delayTimeBetweenStars = 0.2
		for index = 1,self.newStarLevel do

			local delay = CCDelayTime:create((index-1) * delayTimeBetweenStars)

			local parabolaStarAction = self:createParabolaStarAction(index, false)
			local seq = CCSequence:createWithTwoActions(delay, parabolaStarAction)
			parabolaStarActionArray:addObject(seq)
		end
		-- Spawn Parabola Star Action
		local spawn = CCSpawn:create(parabolaStarActionArray)
		actionArray:addObject(spawn)
	elseif self.newStarLevel == 4 then -- four star animation goes Here!
		local parabolaStarActionArray = CCArray:create()
		local delayTimeBetweenStars = 0.2
		for index = 1,self.newStarLevel do

			local delay = CCDelayTime:create((index-1) * delayTimeBetweenStars)

			local parabolaStarAction = self:createFourStarParabolaStarAction(index, false)
			local seq = CCSequence:createWithTwoActions(delay, parabolaStarAction)
			parabolaStarActionArray:addObject(seq)
		end
		-- Spawn Parabola Star Action
		local spawn = CCSpawn:create(parabolaStarActionArray)
		actionArray:addObject(spawn)
	else
		-- newStarLevel == 0 for rabbit weekly levels
	end


	if self.newStarLevel == 4 then  -- four star level, play the flowers blooming animation
		actionArray:addObject(self:createFlowersAnimation())
	end

	------------------------------
	-- Create Parabola New Star Reward Action
	-- -----------------------------
	
	local starRewardActionArray = CCArray:create()

	for index = 1,self.newStarLevel do

		if index > self.oldStarLevel then

			-- -------------------
			-- Star Reward Action
			-- --------------------
			local starRewardAction	= self:createStarRewardAction(index)
			--actionArray:addObject(starRewardAction)
			if starRewardAction ~= nil and type(starRewardAction) == 'userdata' then
				starRewardActionArray:addObject(starRewardAction)
			end
		end
	end

	-- explain: starRewardActionArray could be empty,
	-- so we need to fill it so that CCSpawn:create() could pass.
	local emptyAction = CCDelayTime:create(0)
	starRewardActionArray:addObject(emptyAction)
	
	-- Spawn
	local starRewardAction = CCSpawn:create(starRewardActionArray)
	actionArray:addObject(starRewardAction)

	local seq = CCSequence:create(actionArray)
	self:runAction(seq)
end

function LevelSuccessTopPanel:createPopoutPassLevelTxtAnim(...)
	assert(#{...} == 0)

	local filename = "passLevelSuccess"
	if _G.useTraditionalChineseRes then filename = "passLevelSuccess_zh_tw" end
	if self.newStarLevel == 4 then
		filename = 'passLevelSuccess_fourStar'
	end
	local passLevelTxtRes = ResourceManager:sharedInstance():buildGroup(filename)
	self.passLevelTxtRes = passLevelTxtRes

	local function addTheResourceFunc()
		passLevelTxtRes:setVisible(false)
		-- Add To Screen
		self:addChild(passLevelTxtRes)
		--self.happyAnimalBgLayer:addChild(passLevelTxtRes)
	end
	local addTheResourceAction = CCCallFunc:create(addTheResourceFunc)

	local manualAdjustPosX = -68
	local manualAdjustPosY = -93 


	local animationInfo = {

		secondPerFrame = 1/24,

		object = {
			node = passLevelTxtRes,

			deltaScaleX = 1,
			deltaScaleY = 1,
			originalScaleX = 1,
			originalScaleY = 1,
		},

		keyFrames = {
			{ tweenType = "delay", frameIndex = 1},
			{ tweenType = "normal", frameIndex = 3, x = 265.55 + manualAdjustPosX, y = 17.75 + manualAdjustPosY,	sx = 1, sy = 1},
			{ tweenType = "normal", frameIndex = 5,	x = 265.55 + manualAdjustPosX, y = -76.85 + manualAdjustPosY,	sx = 1, sy = 1},
			{ tweenType = "normal", frameIndex = 7,	x = 265.55 + manualAdjustPosX, y = -61.45 + manualAdjustPosY,	sx = 1, sy = 1},
			{ tweenType = "static", frameIndex = 9,	x = 265.55 + manualAdjustPosX, y = -70.25 + manualAdjustPosY,	sx = 1, sy = 1},
		}
	}

	local action = FlashAnimBuilder:sharedInstance():buildTimeLineAction(animationInfo)

	-- Seq
	local seq = CCSequence:createWithTwoActions(addTheResourceAction, action)
	return seq
end

function LevelSuccessTopPanel:createHappyAnimalsAction(...)
	assert(#{...} == 0)

	local animPopoutTime = 0.2

	--local manualAdjustAnimPosX = -15
	local manualAdjustAnimPosX = 0

	local function createAnimFun()
		local anim = WinAnimation:create()
		self.happyAnimalsAnim = anim
		self.happyAnimalBgLayer:addChild(anim)
		anim:play(animPopoutTime)
	end
	local action = CCCallFunc:create(createAnimFun)

	local delayAction = CCDelayTime:create(animPopoutTime)

	-- Seq
	local seq = CCSequence:createWithTwoActions(action, delayAction)
	return seq
end

--function LevelSuccessTopPanel:playAnimation_old(...)
--	assert(#{...} == 0)
--
--	self:getStarPosFromWorldSpace()
--	self:restoreToOriginalPos()
--	self:restoreStarToInitialScale()
--
--	--local star1FinalVelocityY = false
--	--local star2FinalVelocityY = false
--	--local star3FinalVelocityY = false
--	local starFinalVelocityYs = {false, false, false}
--
--	-- -------------------------------------
--	-- Star Score And Project Star Action
--	-- ------------------------------------
--	local actionArray = CCArray:create()
--
--	-- Play Star1 Score, Project Star1, Play Star2 Score, Project Star2, 
--	-- Play Star3 Score, Proejct Star3
--	for index = 1,self.newStarLevel do
--
--		local targetStarToControl = self:getStarByIndex(index)
--
--		-- ----------------
--		-- Star Score Action
--		-- -----------------
--		local starScoreAction = self:createStarScoreLabelAction(index)
--		actionArray:addObject(starScoreAction)
--		
--		-- ---------------------
--		-- Project Star Action
--		-- ---------------------
--		local function parabolaCallback(newX, newY, vXinitial, vYInitial, vX, vY, duration, actionPercent)
--			starFinalVelocityYs[index] = vY
--		end
--
--		local parabolaStarAction = self:createParabolaStarAction(index, parabolaCallback)
--		actionArray:addObject(parabolaStarAction)
--
--		---------------------------
--		-- Sink And Bounce Action
--		-- ------------------------
--		local function onParabolaEjectStarFinish()
--
--			assert(starFinalVelocityYs[index])
--
--			-- Sink And Bounce Star
--			local sinkAndBounceStarAction	= self:createStarSinkAndBounceAction(index, 0.15, 0, starFinalVelocityYs[index])
--			self:runAction(sinkAndBounceStarAction)
--		end
--		local onParabolaEjectStarFinish = CCCallFunc:create(onParabolaEjectStarFinish)
--		actionArray:addObject(onParabolaEjectStarFinish)
--
--		-- Delay To Wait The sinkAndBounceStarAction 
--		local delayToWaitSinkAndBounce = CCDelayTime:create(0.15 * 3)
--		actionArray:addObject(delayToWaitSinkAndBounce)
--	end
--
--	-------------------------------------------
--	---- New Star Level And Star Reward Action
--	-------------------------------------------
--
--	for index = 1,self.newStarLevel do
--
--		if index > self.oldStarLevel then
--			-----------------------
--			-- Play createNewStarTxtAnim
--			-- ---------------------------
--			local txtAnimRes	= self.newStarTxtAnims[index]
--			local newStarTxtAnim = self:createNewStarTxtAnim(txtAnimRes)
--			actionArray:addObject(newStarTxtAnim)
--			
--			-------------------------
--			-- Hide New Star Txt Anim
--			-- ---------------------
--			--local hideTxtAnim	= self:createNewStarTxtAnim(txtAnimRes)
--			--local hideTxtAnim	= self:createNewStarTxtFadeOutAnim(txtAnimRes)
--			--actionArray:addObject(hideTxtAnim)
--
--			-- -------------------
--			-- Star Reward Action
--			-- --------------------
--			local starRewardAction	= self:createStarRewardAction(index)
--			actionArray:addObject(starRewardAction)
--		end
--	end
--
--	-----------------
--	-- Finish Callback
--	-- ----------------
--	local function animFinished()
--
--		----------------
--		-- Delay And Shake Forever
--		-- ------------
--		for index = 1, self.newStarLevel do
--
--			if index > self.oldStarLevel then
--				local delay			= CCDelayTime:create(3)
--
--				local targetStarToControl	= self:getStarByIndex(index)
--				local starShake 		= self:createStarShakeAction(targetStarToControl)
--				local seq			= CCSequence:createWithTwoActions(delay, starShake)
--				local repeatForever		= CCRepeatForever:create(seq)
--				self:runAction(repeatForever)
--			end
--		end
--	end
--	local animFinishAction = CCCallFunc:create(animFinished)
--	actionArray:addObject(animFinishAction)
--
--	local seq = CCSequence:create(actionArray)
--	self:runAction(seq)
--end

function LevelSuccessTopPanel:createStarSinkAndBounceAction(starIndex, duration, vx, vy, ...)
	assert(type(starIndex)	== "number")
	assert(type(duration)	== "number")
	assert(type(vx)		== "number")
	assert(type(vy)		== "number")
	assert(#{...} == 0)

	local targetToControl = self:getStarByIndex(starIndex)

	local originalX = targetToControl:getPositionX()
	local originalY = targetToControl:getPositionY()

	local deltaX = duration * 0.5 * vx
	local deltaY = duration * 0.5 * vy
	
	-- ---------
	-- Ease Down
	-- ----------
	local moveTo		= CCMoveTo:create(duration, ccp(originalX + deltaX, originalY + deltaY))
	local easeMoveTo	= CCEaseBackOut:create(moveTo)

	-- -------------------
	-- Move To Original
	-- ----------------
	local moveToOriginal = CCMoveTo:create(duration, ccp(originalX, originalY))
	he_log_warning("CCEaseInOut second parameter has no corresponding value in actionScript example ")
	local easeMoveToOriginal = CCEaseInOut:create(moveToOriginal, 1)

	-- Delay
	local delay = CCDelayTime:create(duration)

	--------------
	-- Action Array
	-- -----------
	local actionArray = CCArray:create()
	actionArray:addObject(easeMoveTo)
	actionArray:addObject(easeMoveToOriginal)
	actionArray:addObject(delay)

	-- Seq
	local seq = CCSequence:create(actionArray)
	local targetSeq = CCTargetedAction:create(targetToControl.refCocosObj, seq)

	return targetSeq
end

function LevelSuccessTopPanel:createParabolaStarAction(starIndex, parabolaCallbackFunc, ...)
	assert(type(starIndex) == "number")
	assert(parabolaCallbackFunc == false or type(parabolaCallbackFunc) == "function")
	assert(#{...} == 0)

	local star = false

	if starIndex == 1 then
		star  = self.star1Res
	elseif starIndex == 2 then
		star = self.star2Res
	elseif starIndex == 3 then
		star = self.star3Res
	else
		assert(false)
	end

	local starBgCenter = self:getStarBgCenterByIndex(starIndex)


	local actionArray = CCArray:create()

	-----------------------
	-- Create Shing Score Progress Bar Star
	-- -------------------------------------
	local function createShingStarFunc()
		local scoreStarPos = ccp(self.starResInitPos[starIndex].x, self.starResInitPos[starIndex].y)
		local star = LadybugAnimation:createFinishStarAnimation(scoreStarPos)
		self:addChild(star)
	end
	local createShingStarAction = CCCallFunc:create(createShingStarFunc)
	actionArray:addObject(createShingStarAction)

	-- Delay For Shing Star Finish
	local delayForStarScoreFinish = CCDelayTime:create(0.2)
	actionArray:addObject(delayForStarScoreFinish)


	-- ------------------
	-- Init Anim Action
	-- -------------------
	local function initAnim()
		star:setVisible(true)
		star:removeFromParentAndCleanup(false)
		self:addChild(star)
		star:setPosition(ccp(self.starResInitPos[starIndex].x, self.starResInitPos[starIndex].y))

		-- Call The Hide Star Callback Function
		if self.hideStarCallback then
			self.hideStarCallback(starIndex)
		end
	end
	local initAnimAction = CCCallFunc:create(initAnim)
	actionArray:addObject(initAnimAction)

	-- -------------------
	-- Parabola Move To
	-- -------------------
	local parabolaMoveTo = CCParabolaMoveTo:create(15 * 1/24, starBgCenter.x, starBgCenter.y, -3000)

	local curY			= false
	local alreadyBringToFront	= false

	local function parabolaCallback(newX, newY, vXInitial, vYInitial, vX, vY, duration, actionPercent)

		if parabolaCallbackFunc then
			parabolaCallbackFunc(newX, newY, vXInitial, vYInitial, vX, vY, duration, actionPercent)
		end

		if not curY then
			curY = newY
		else
			if curY < newY then
				curY = newY
			else
				-- Start To Fall 
				if not alreadyBringToFront then
					alreadyBringToFront = true
					star:removeFromParentAndCleanup(false)
					self.ui:addChild(star)
				end
			end
		end
	end

	parabolaMoveTo:registerScriptHandler(parabolaCallback)

	local ease = CCEaseSineOut:create(parabolaMoveTo)
	parabolaMoveTo = ease

	-- Rotate
	local rotate = CCRotateBy:create(30 * 1/60, 360)
	local easeBack = CCEaseBackOut:create(rotate)
	local rotate = easeBack

	local function playStarFlyFinishSoundEffect()
		GamePlayMusicPlayer:playEffect(GameMusicType.kStarOnPanel)
	end
	
	-- Scale
	local scaleTo = CCSequence:createWithTwoActions(CCScaleTo:create(30 * 1/60, 1), CCCallFunc:create(playStarFlyFinishSoundEffect))

	-- Action Array
	local starActionArray = CCArray:create()
	starActionArray:addObject(parabolaMoveTo)
	starActionArray:addObject(rotate)
	starActionArray:addObject(scaleTo)

	-- Spawn
	local moveToAndRotate = CCSpawn:create(starActionArray)
	actionArray:addObject(moveToAndRotate)

	------------------------
	-- Final Explode Action
	-- --------------------
	local function finalExplodeFunc()
		local pos = ccp(starBgCenter.x, starBgCenter.y)
		local explode = LadybugAnimation:createFinsihExplodeStar(pos)
		self:addChild(explode)

		local overlay = LadybugAnimation:createFinsihShineStar(pos)
		self:addChild(overlay)
		table.insert(self.overlayAnims, overlay)
	end
	local finalExplodeAction = CCCallFunc:create(finalExplodeFunc)
	actionArray:addObject(finalExplodeAction)

	-- ------
	-- Seq
	-- -------
	local seq = CCSequence:create(actionArray)
	local targetedSeq = CCTargetedAction:create(star.refCocosObj, seq)

	return targetedSeq
end

function LevelSuccessTopPanel:createFourStarParabolaStarAction(starIndex, parabolaCallbackFunc)
	local star = false

	if starIndex == 1 then
		star  = self.star1Res
	elseif starIndex == 2 then
		star = self.star2Res
	elseif starIndex == 3 then
		star = self.star3Res
	elseif starIndex == 4 then
		star = self.star4Res
	end

	local starCenterPos = self.ui:getChildByName('fourStarLocator'..starIndex):getPosition()


	local actionArray = CCArray:create()

	-----------------------
	-- Create Shing Score Progress Bar Star
	-- -------------------------------------
	local function createShingStarFunc()
		local scoreStarPos = ccp(self.starResInitPos[starIndex].x, self.starResInitPos[starIndex].y)
		local star = LadybugAnimation:createFinishStarAnimation(scoreStarPos)
		self:addChild(star)
	end
	local createShingStarAction = CCCallFunc:create(createShingStarFunc)
	actionArray:addObject(createShingStarAction)

	-- Delay For Shing Star Finish
	local delayForStarScoreFinish = CCDelayTime:create(0.2)
	actionArray:addObject(delayForStarScoreFinish)


	-- ------------------
	-- Init Anim Action
	-- -------------------
	local function initAnim()
		star:setVisible(true)
		star:removeFromParentAndCleanup(false)
		self:addChild(star)
		star:setPosition(ccp(self.starResInitPos[starIndex].x, self.starResInitPos[starIndex].y))

		-- Call The Hide Star Callback Function
		if self.hideStarCallback then
			self.hideStarCallback(starIndex)
		end
	end
	local initAnimAction = CCCallFunc:create(initAnim)
	actionArray:addObject(initAnimAction)

	-- -------------------
	-- Parabola Move To
	-- -------------------
	local parabolaMoveTo = CCParabolaMoveTo:create(15 * 1/24, starCenterPos.x, starCenterPos.y, -3000)

	local curY			= false
	local alreadyBringToFront	= false

	local function parabolaCallback(newX, newY, vXInitial, vYInitial, vX, vY, duration, actionPercent)

		if parabolaCallbackFunc then
			parabolaCallbackFunc(newX, newY, vXInitial, vYInitial, vX, vY, duration, actionPercent)
		end

		if not curY then
			curY = newY
		else
			if curY < newY then
				curY = newY
			else
				-- Start To Fall 
				if not alreadyBringToFront then
					alreadyBringToFront = true
					star:removeFromParentAndCleanup(false)
					self.ui:addChild(star)
				end
			end
		end
	end

	parabolaMoveTo:registerScriptHandler(parabolaCallback)

	local ease = CCEaseSineOut:create(parabolaMoveTo)
	-- local ease = CCEaseBounceOut:create(parabolaMoveTo)
	parabolaMoveTo = ease

	local function playStarFlyFinishSoundEffect()
		GamePlayMusicPlayer:playEffect(GameMusicType.kStarOnPanel)
	end
	
	-- Scale
	local scaleTo = CCSequence:createWithTwoActions(CCScaleTo:create(30 * 1/60, 0.9), CCCallFunc:create(playStarFlyFinishSoundEffect))

	-- rotate
	star:setRotation(0)
	local offset = (starIndex - 2.5) * 10
	local rotate = CCRotateTo:create(30 * 1/60, 720 + offset)


	-- Action Array
	local starActionArray = CCArray:create()
	starActionArray:addObject(parabolaMoveTo)
	starActionArray:addObject(rotate)
	starActionArray:addObject(scaleTo)
	starActionArray:addObject(rotate)

	-- Spawn
	local moveToAndRotate = CCSpawn:create(starActionArray)
	actionArray:addObject(moveToAndRotate)

	------------------------
	-- Final Explode Action
	-- --------------------
	local function finalExplodeFunc()
		local pos = ccp(starCenterPos.x, starCenterPos.y)
		local explode = LadybugAnimation:createFinsihExplodeStar(pos)
		self:addChild(explode)

		local overlay = LadybugAnimation:createFinsihShineStar(pos)
		self:addChild(overlay)
		table.insert(self.overlayAnims, overlay)
	end
	local finalExplodeAction = CCCallFunc:create(finalExplodeFunc)
	actionArray:addObject(finalExplodeAction)

	-- ------
	-- Seq
	-- -------
	local seq = CCSequence:create(actionArray)
	local targetedSeq = CCTargetedAction:create(star.refCocosObj, seq)

	return targetedSeq
end


-------------------------------------------------------
---------	Star Reward Animation
--------------------------------------------------------

function LevelSuccessTopPanel:createStarRewardAction(starIndex, ...)
	assert(starIndex)
	assert(#{...} == 0)

	-- Get Current Star 's Reward
	-- Only If This Star Is First Opened
	-- If Previous Reached This Star Level ,
	-- Then The Default Reward Is Used And Not Play THe Flying Animation

	-- Check If THis Star Level Is First Reached
	print(self.newStarLevel, starIndex, self.oldStarLevel)
	if self.newStarLevel >= starIndex and starIndex > self.oldStarLevel then
		-- This Star Level Is First Reached
		-- Play The Flying Animation

		local moveFromPoint = self:getStarBgCenterByIndex(starIndex)

		-- ----------------------------
		-- Create Flying Reward Resouce
		-- ----------------------------

		--- Get Reward Data
		local curStarReward = false
		if starIndex == 1 then
			curStarReward = self.level_reward.oneStarReward 
		elseif starIndex == 2 then
			curStarReward = self.level_reward.twoStarReward
		elseif starIndex == 3 then
			curStarReward = self.level_reward.threeStarReward
		elseif starIndex == 4 then
			curStarReward = self.level_reward.fourStarReward
		else 
			assert(false)
		end
		assert(curStarReward)

		if _isQixiLevel then -- qixi
			curStarReward = {}
		end
		

		-- --------------------------
		-- Create Each Reward Action
		-- -------------------------
		local rewardActions = {}
		local numberOfRewardAction = 0
		local typeIndex	= 0

		for k,v in pairs(curStarReward) do

			typeIndex = typeIndex + 1
			rewardActions[typeIndex] = {}

			--for index = 1,v.num do
			--	local rewardAction = self:createParabolaRewardAction(v.itemId, 1, moveFromPoint)
			--	numberOfRewardAction = numberOfRewardAction + 1
			--	table.insert(rewardActions[typeIndex], rewardAction)
			--end
			
			local rewardAction = self:createParabolaRewardAction(v.itemId, v.num, moveFromPoint)
			numberOfRewardAction = numberOfRewardAction + 1
			table.insert(rewardActions[typeIndex], rewardAction)
		end

		local totalTypes = typeIndex 

		-- ---------------------------------
		-- Arrange Reward Actions To Queue
		-- ---------------------------------
		local rewardActionQueue = {}
		local typeIndex = false
		local countForModulusLoop = 0

		for index = 1, numberOfRewardAction do

			local repeatCount = 0
			repeat
				typeIndex = countForModulusLoop % totalTypes + 1
				countForModulusLoop = countForModulusLoop + 1

				repeatCount = repeatCount + 1

				if repeatCount > totalTypes then
					assert(false, "When Loop totalTypes Count, Must Find An Action, Some Thing May Wrong !")
				end
			until rewardActions[typeIndex][1]

			table.insert(rewardActionQueue, rewardActions[typeIndex][1])
			table.remove(rewardActions[typeIndex], 1)
		end

		-- Assert
		for typeIndex = 1, totalTypes do
			assert(#rewardActions[typeIndex] == 0)
		end

		--------------------------
		--- Create Actions With First Delay
		-------------------------------

		-- Action Array
		local actionArray	= CCArray:create()
		local delayStep		= 0.1
		local startDelayTime	= 0

		for index = 1, #rewardActionQueue do

			local delay = CCDelayTime:create(startDelayTime)
			startDelayTime = startDelayTime + delayStep

			local firstDelayRewardAction = CCSequence:createWithTwoActions(delay, rewardActionQueue[index])
			actionArray:addObject(firstDelayRewardAction)
		end

		local spawn	= CCSpawn:create(actionArray)

		return spawn

		--local runningScene	= Director:getRunningScene()
		--runningScene:runAction(spawn)
	else
		-- Default Reward 
		-- Already Add When This Panel Is Initiated
	end

	-- Return A Null Action
	local function nothing()
		local tmp = 10
	end
	local noOpAction = CCCallFunc:create(nothing)
	return noOpAction
end

function LevelSuccessTopPanel:getRewardItemByRewardId(rewardId, ...)
	assert(type(rewardId) == "number")
	assert(#{...} == 0)


	for index = 1, #self.rewardItems do

		local id = self.rewardItems[index]:getRewardId()

		print('test ', id)
		if id == rewardId then
			return self.rewardItems[index]
		end
	end

	return nil
end

-- deprecated
function LevelSuccessTopPanel:createSmallStarAction(smallStar, ...)
	assert(smallStar)
	assert(#{...} == 0)

	local starWithGlow	= smallStar:getChildByName("starWithGlow")
	local starWithoutGlow	= smallStar:getChildByName("starWithoutGlow")
	assert(starWithGlow)
	assert(starWithoutGlow)

	local secondPerFrame = 1/24

	-----------------------
	-- Init Animation
	-- --------------------
	local function initAnim()
		starWithGlow:setOpacity(255)
		starWithoutGlow:setOpacity(255)
	end
	local initAnimAction = CCCallFunc:create(initAnim)

	-----------------
	---- Fade Out
	------------------
	local starWithGlowFadeOut 	= CCTargetedAction:create(starWithGlow.refCocosObj, CCFadeOut:create( 6 * secondPerFrame))
	local starWithoutGlowFadeOut	= CCTargetedAction:create(starWithoutGlow.refCocosObj, CCFadeOut:create(13 * secondPerFrame))
	local spawnFadeOut		= CCSpawn:createWithTwoActions(starWithGlowFadeOut, starWithoutGlowFadeOut)

	----------------
	-- Fade In
	-- -------------
	local delay 			= CCDelayTime:create(6 * secondPerFrame)
	local starWithGlowFadeIn	= CCTargetedAction:create(starWithGlow.refCocosObj, CCFadeIn:create( (25 - 13 - 6) * secondPerFrame))
	local starWithGlowDelayFadeIn	= CCSequence:createWithTwoActions(delay, starWithGlowFadeIn)

	local starWithoutGlowFadeIn	= CCTargetedAction:create(starWithoutGlow.refCocosObj, CCFadeIn:create( (25 - 13) * secondPerFrame))
	local spawnFadeIn		= CCSpawn:createWithTwoActions(starWithGlowDelayFadeIn, starWithoutGlowFadeIn)

	-------------
	-- Delay
	-- ------------
	local delay = CCDelayTime:create((33 - 25) * secondPerFrame)

	-----------
	-- Action Array
	-- --------
	local actionArray = CCArray:create()
	actionArray:addObject(spawnFadeOut)
	actionArray:addObject(spawnFadeIn)
	actionArray:addObject(delay)

	-- Seq
	local seq = CCSequence:create(actionArray)

	-- Random Start Point
	local duration = seq:getDuration()

	-- Repeat Forever
	local repeatForever = CCRepeatForever:create(seq)
	return repeatForever, duration
end

-- deprecated
function LevelSuccessTopPanel:createStarShakeAction(star, ...)
	assert(star)
	assert(#{...} == 0)

	local secondPerFrame = 1 / 24
	local rotateAngle	= 5

	----------------
	-- First Delay
	-- --------------
	local firstDelay = CCDelayTime:create((14 - 1) * secondPerFrame)

	-------------------------
	----	Shake One Time
	--------------------------
	local backToOriginal1	= CCRotateTo:create(0, 0)
	local delay1		= CCDelayTime:create( 1*secondPerFrame)
	local rotateRight	= CCRotateTo:create(0, rotateAngle)
	local delay2		= CCDelayTime:create( 1*secondPerFrame)
	local backToOriginal2	= CCRotateTo:create(0, 0)
	local delay3		= CCDelayTime:create( 1*secondPerFrame)
	local rotateLeft	= CCRotateTo:create(0, -rotateAngle)
	local delay4		= CCDelayTime:create( 1*secondPerFrame)
	local backToOriginal3	= CCRotateTo:create(0, 0)

	local actionArray = CCArray:create()
	actionArray:addObject(backToOriginal1)
	actionArray:addObject(delay1)
	actionArray:addObject(rotateRight)
	actionArray:addObject(delay2)
	actionArray:addObject(backToOriginal2)
	actionArray:addObject(delay3)
	actionArray:addObject(rotateLeft)
	actionArray:addObject(delay4)
	actionArray:addObject(backToOriginal3)

	local starShake1Time = CCSequence:create(actionArray)

	-------------------------
	--- Repeat 3 Times
	---------------------
	local repeat3Time = CCRepeat:create(starShake1Time, 3)

	------------------
	--- Last Delay
	-------------
	local lastDelay = CCDelayTime:create((33 - 26) * secondPerFrame)

	-- Seq
	local actionArray	= CCArray:create()
	actionArray:addObject(firstDelay)
	actionArray:addObject(repeat3Time)
	actionArray:addObject(lastDelay)

	local seq		= CCSequence:create(actionArray)
	local targetedSeq	= CCTargetedAction:create(star.refCocosObj,seq)

	return targetedSeq
end

-- deprecated
function LevelSuccessTopPanel:createRoundBeam(numberOfBeam, ...)
	assert(type(numberOfBeam) == "number")
	assert(numberOfBeam >= 1)
	assert(#{...} == 0)

	local beams = Layer:create()

	for index = 1,numberOfBeam do

		local beam = ResourceManager:sharedInstance():buildSprite("beam")
		beam:setAnchorPoint(ccp(0.5, 0))

		local rotateAngle = 360 / numberOfBeam * (index - 1)
		beam:setRotation(rotateAngle)

		beams:addChild(beam)
	end

	return beams
end

-- deprecated
function LevelSuccessTopPanel:createNewStarTxtAnim(newStarTxtAnimRes, ...)
	assert(newStarTxtAnimRes)
	assert(#{...} == 0)

	----------------
	-- Get UI Resource
	-- ---------------
	local ben	= newStarTxtAnimRes:getChildByName("ben")
	local guan	= newStarTxtAnimRes:getChildByName("guan")
	local xin	= newStarTxtAnimRes:getChildByName("xin")
	local huo	= newStarTxtAnimRes:getChildByName("huo")
	local de	= newStarTxtAnimRes:getChildByName("de")

	assert(ben)
	assert(guan)
	assert(xin)
	assert(huo)
	assert(de)

	local secondPerFrame = 1 / 24

	local function createCharAnim(charToControl, delayFrame, scaleFrame, ...)
		assert(charToControl)
		assert(type(delayFrame) == "number")
		assert(type(scaleFrame) == "number")
		assert(#{...} == 0)

		-- Delay
		local delay = CCDelayTime:create(delayFrame * secondPerFrame)

		-- Init
		local function initCharAnim()
			charToControl:setAnchorPointCenterWhileStayOrigianlPosition()
			charToControl:setScale(2)
			charToControl:setVisible(true)
		end
		local initCharAnimAction = CCCallFunc:create(initCharAnim)

		-- Scale To 1
		local scaleToOriginal = CCScaleTo:create(scaleFrame * secondPerFrame, 1)

		-- Seq
		local actionArray = CCArray:create()
		actionArray:addObject(delay)
		actionArray:addObject(initCharAnimAction)
		actionArray:addObject(scaleToOriginal)

		local seq = CCSequence:create(actionArray)
		local targetedSeq = CCTargetedAction:create(charToControl.refCocosObj, seq)
		return targetedSeq
	end

	-- --------------
	-- Char Actions
	-- --------------
	
	local function initAnim()
		newStarTxtAnimRes:setVisible(true)
		newStarTxtAnimRes:setChildrenVisible(false, false)
	end
	local initAnimAction = CCCallFunc:create(initAnim)

	local benAction		= createCharAnim(ben, 0, 4)
	local guanAction	= createCharAnim(guan, 4, 4)
	local xinAction		= createCharAnim(xin, 8, 4)
	local huoAction		= createCharAnim(huo, 12, 4)
	local deAction		= createCharAnim(de, 16, 4)

	local actionArray = CCArray:create()
	actionArray:addObject(initAnimAction)
	actionArray:addObject(benAction)
	actionArray:addObject(guanAction)
	actionArray:addObject(xinAction)
	actionArray:addObject(huoAction)
	actionArray:addObject(deAction)
	local spawn = CCSpawn:create(actionArray)

	local seq = CCSequence:createWithTwoActions(initAnimAction, spawn)
	return seq
end

function LevelSuccessTopPanel:createParabolaRewardAction(rewardId, number, fromPoint, ...)
	assert(type(rewardId)	== "number")
	assert(type(number)	== "number")
	assert(fromPoint)
	assert(#{...} == 0)

	-- Get Item Icon
	local rewardItem	= false
	local toPoint		= false
	local toRewardItem	= false

	-- Get Flying Reward toPoint Based On rewardId
	local toRewardItem = self:getRewardItemByRewardId(rewardId)
	assert(toRewardItem)
	---- Get Center Pos As toPoint
	local center	= toRewardItem:getPlaceHolderCenterInParentSpace()
	toPoint = ccp(center.x, center.y)

	-- Create Flying Reward Resource
	local rewardItem = ResourceManager:sharedInstance():buildItemSprite(rewardId)
	rewardItem:setVisible(false)
	self:addChild(rewardItem)

	-- -----------
	-- Init Anim
	-- ------------
	local function initAnim()
		rewardItem:setAnchorPoint(ccp(0.5, 0.5))
		rewardItem:setScale(0.1, 0.1)
		rewardItem:setPosition(ccp(fromPoint.x, fromPoint.y))
		rewardItem:setVisible(true)
	end
	local initAnimAction = CCCallFunc:create(initAnim)

	-- ---------
	-- Enlarge
	-- ------------
	local scaleTo = CCScaleTo:create(0.25, 1)

	-- --------------------
	-- Parabola Animation
	-- ---------------------
	--local parabolaMoveTo = CCParabolaMoveTo:create(36 * 1/60, toPoint.x, toPoint.y, -1600)
	local parabolaMoveTo = CCParabolaMoveTo:create(36 * 1/60, toPoint.x, toPoint.y, -3200)

	-- -------------------
	-- Enlarge And Fade Out
	-- ----------------------
	local enlargeTo	= CCScaleTo:create(0.2, 4)
	local fadeOut	= CCFadeOut:create(0.2)
	local enlargeAndFadeOut	= CCSpawn:createWithTwoActions(enlargeTo, fadeOut)

	-------------------------
	-- Anim Finish Callback
	-- ------------------------
	-- Add The Number To The Reward Number
	local function onMoveToFinished()
		rewardItem:removeFromParentAndCleanup(true)
		toRewardItem:addNumber(number)
	end
	local moveToFinishAction = CCCallFunc:create(onMoveToFinished)

	-- Action Array
	local actionArray = CCArray:create()
	actionArray:addObject(initAnimAction)
	actionArray:addObject(scaleTo)
	actionArray:addObject(parabolaMoveTo)
	actionArray:addObject(enlargeAndFadeOut)
	actionArray:addObject(moveToFinishAction)

	-- Sequence
	local seq	= CCSequence:create(actionArray)
	local targetedSeq	= CCTargetedAction:create(rewardItem.refCocosObj, seq)
	return targetedSeq
end

function LevelSuccessTopPanel:getStarScoreLabelByIndex(index, ...)
	assert(type(index) == "number")
	assert(#{...} == 0)

	local label = self.starScoreLabels[index]
	assert(label)
	return label
end

function LevelSuccessTopPanel:createStarScoreLabelAction(labelIndex, ...)
	assert(type(labelIndex) == "number")
	assert(#{...} == 0)

	local labelToControl = self:getStarScoreLabelByIndex(labelIndex)

	----------------
	-- Init Anim
	----------------
	local function initAnim()
		labelToControl:setScale(0.1)
		labelToControl:setOpacity(0)
	end
	local initAnimAction = CCCallFunc:create(initAnim)

	----------
	-- Show
	-- -------
	-- Scale To 1
	local scale	= CCScaleTo:create(0.2, 1)
	local easeScale	= CCEaseBackOut:create(scale)
	-- Fade In
	local fadeIn	= CCFadeIn:create(0.2)
	local easeSpawn = CCSpawn:createWithTwoActions(easeScale, fadeIn)

	----------
	-- Delay
	----------
	local delay	= CCDelayTime:create(0.2)

	----------
	-- Hide
	-- -------
	local scale	= CCScaleTo:create(0.2, 0.1)
	local fadeOut	= CCFadeOut:create(0.2)
	local spawn	= CCSpawn:createWithTwoActions(scale, fadeOut)

	---------------
	-- Action Array
	-- -----------
	local actionArray = CCArray:create()
	actionArray:addObject(initAnimAction)
	actionArray:addObject(easeSpawn)
	actionArray:addObject(delay)
	actionArray:addObject(spawn)

	-- Seq
	local seq = CCSequence:create(actionArray)
	local targetedSeq = CCTargetedAction:create(labelToControl.refCocosObj, seq)

	return targetedSeq
end

function LevelSuccessTopPanel:create(parentPanel, levelId, levelType, newScore, rewardItemsDataFromServer, extraCoin, ...)
	assert(parentPanel)
	assert(type(levelId) == "number")
	assert(type(levelType) == "number")
	assert(type(newScore) == "number")
	assert(rewardItemsDataFromServer)
	assert(extraCoin)
	assert(#{...} == 0)

	local newLevelSuccessTopPanel = LevelSuccessTopPanel.new()
	newLevelSuccessTopPanel:init(parentPanel, levelId, levelType, newScore, rewardItemsDataFromServer, extraCoin)
	return newLevelSuccessTopPanel
end

function LevelSuccessTopPanel:createFlowersAnimation(finishCallback)
	local bloomTime = 24/60
	local rotateTime = 20/60
	local reverseRotateTime = 4/60
	local bloomInterval = 4/60
	local rotateAngle = 150
	local reverseRotateAngle = -15
	local numOfFlowers = 13
	local layer = self.ui:getChildByName('flowers_deco')
	layer:setVisible(true)
	local delayTime = 0
	local targetedActions = CCArray:create()
	for i=1, numOfFlowers do 
		local flower = layer:getChildByName('f'..i)
		local endScale = flower:getScale()
		flower:setVisible(true)
		flower:setScale(0)
		flower:setAnchorPoint(ccp(0.5, 0.5))
		local actions = CCArray:create()
		local delay = CCDelayTime:create(delayTime)
		local enlarge = CCScaleTo:create(bloomTime, endScale * 1.2)
		local rotate = CCRotateBy:create(rotateTime, rotateAngle)
		local reverseRotate = CCRotateBy:create(reverseRotateTime, reverseRotateAngle)
		local shrink = CCScaleTo:create(reverseRotateTime, endScale)
		actions:addObject(delay)
		actions:addObject(CCSpawn:createWithTwoActions(rotate, enlarge))
		actions:addObject(CCSpawn:createWithTwoActions(reverseRotate, shrink))
		delayTime = delayTime + 0.05
		-- flower:runAction(CCSequence:create(actions))
		local targetedAction = CCTargetedAction:create(flower.refCocosObj, CCSequence:create(actions))
		targetedActions:addObject(targetedAction)
	end
	return CCSpawn:create(targetedActions)
end
