
-- Copyright C2009-2013 www.happyelements.com, all rights reserved.
-- Create Date:	2013Äê12ÔÂ23ÈÕ 10:54:52
-- Author:	ZhangWan(diff)
-- Email:	wanwan.zhang@happyelements.com

require "zoo.common.FlashAnimBuilder"
require "zoo.scenes.component.HomeScene.iconButtons.IconButtonBase"

---------------------------------------------------
-------------- StarRewardButton
---------------------------------------------------

assert(not StarRewardButton)
assert(IconButtonBase)
StarRewardButton = class(IconButtonBase)

function StarRewardButton:ctor( ... )
	self.id = "StarRewardButton"
	self.playTipPriority = 30
end
function StarRewardButton:playHasNotificationAnim(...)
	IconButtonManager:getInstance():addPlayTipIcon(self)
end
function StarRewardButton:stopHasNotificationAnim(...)
	IconButtonManager:getInstance():removePlayTipIcon(self)
end

function StarRewardButton:init(...)
	assert(#{...} == 0)

	-- Get UI Resoruce
	self.ui	= ResourceManager:sharedInstance():buildGroup("starRewardButton")

	--------------
	-- Init Base Class
	-- -------------
	--BaseUI.init(self, self.ui)

	IconButtonBase.init(self, self.ui)

	---------------
	-- Get UI Resource
	-- --------------
	self.numLabel			= self.wrapper:getChildByName("numLabel")
	self.shiningStar		= self.wrapper:getChildByName("shiningStar")
	self.bg				= self.wrapper:getChildByName("bg")
	if _G.useTraditionalChineseRes then self.bg = self.wrapper:getChildByName("bg_tw") end
	self.wrapper:getChildByName("bg"):setVisible(not _G.useTraditionalChineseRes)
	local bg_tw = self.wrapper:getChildByName("bg_tw")
	if bg_tw then bg_tw:setVisible(_G.useTraditionalChineseRes) end

	assert(self.numLabel)
	assert(self.shiningStar)
	assert(self.bg)

	-------------------
	-- Init UI Resource
	-- ---------------
	self.shiningStar:setOpacity(0)

	local starRewardTipKey 		= "lady.bug.icon.rewards.tips"
	local starRewardTipValue	= Localization:getInstance():getText(starRewardTipKey, {})
	self:setTipString(starRewardTipValue)

	-----------------
	-- Data
	-- ----------
	self:update()
end

function StarRewardButton:update(...)
	assert(#{...} == 0)
	if self.isDisposed then return end


	------------------
	-- Update View
	-- --------------
	local rewardLevelToPushMeta = StarRewardModel:getInstance():update().currentPromptReward
	if rewardLevelToPushMeta then
		self.numLabel:setString(rewardLevelToPushMeta.starNum)
		self:positionNumLabelCenter()

		local curTotalStar = UserManager:getInstance().user:getTotalStar()
		if curTotalStar >= rewardLevelToPushMeta.starNum then
			self:playHasNotificationAnim()
		else
			self:stopHasNotificationAnim()
		end
	else
		self:stopHasNotificationAnim()
	end
end

function StarRewardButton:positionNumLabelCenter(...)
	assert(#{...} == 0)

	local numLabelSize = self.numLabel:getGroupBounds().size
	local bgSize		= self.bg:getGroupBounds().size
	local deltaWidth	= bgSize.width - numLabelSize.width
	local bgPosX	= self.bg:getPositionX()
	self.numLabel:setPositionX(bgPosX + deltaWidth/2)
end


function StarRewardButton:playOnlyIconAnim( ... )
	IconButtonBase.playOnlyIconAnim(self)

	local anim = CCArray:create()
	anim:addObject(CCFadeIn:create(0.2))
	anim:addObject(CCFadeOut:create(0.3))
	anim:addObject(CCDelayTime:create(0.3))
	local repeatForever	= CCRepeatForever:create(CCSequence:create(anim))
	self.shiningStar:stopAllActions()
	self.shiningStar:runAction(repeatForever)
end

function StarRewardButton:stopOnlyIconAnim( ... )
	IconButtonBase.stopOnlyIconAnim(self)
	
	self.shiningStar:stopAllActions()
	self.shiningStar:setOpacity(0)
end

function StarRewardButton:createShiningStarAction(...)
	assert(#{...} == 0)

	local secondPerFrame	= 1 / 30

	local function initActionFunc()
		self.shiningStar:setVisible(true)
		self.shiningStar:setOpacity(0)
	end
	local initAction = CCCallFunc:create(initActionFunc)

	local fadeIn	= CCFadeIn:create(secondPerFrame*7) 
	local fadeOut	= CCFadeOut:create(secondPerFrame*8)
	local wait	= CCDelayTime:create(secondPerFrame*10)

	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(fadeIn)
	actionArray:addObject(fadeOut)
	actionArray:addObject(wait)

	-- Seq
	local seq = CCSequence:create(actionArray)
	local target = CCTargetedAction:create(self.shiningStar.refCocosObj, seq)

	return target
end

function StarRewardButton:create(...)
	assert(#{...} == 0)

	local newStarRewardButton = StarRewardButton.new()
	newStarRewardButton:init()
	return newStarRewardButton
end

StarRewardModel = class()
local instance = nil

function StarRewardModel:ctor()
	self.allMissionComplete = false
	self.currentPromptReward = nil
end

function StarRewardModel:getInstance()
	if not instance then 
		instance = StarRewardModel.new() 
	end
	return instance
end

function StarRewardModel:update()
	-- Get Current Star
	local curTotalStar = UserManager:getInstance().user:getTotalStar()
	local userExtend = UserManager:getInstance().userExtend

	--- Get Star Reward Level
	local nearestStarRewardLevelMeta = MetaManager.getInstance():starReward_getRewardLevel(curTotalStar)
	local nextRewardLevelMeta = MetaManager.getInstance():starReward_getNextRewardLevel(curTotalStar)
	local rewardLevelToPushMeta = nil

	if nearestStarRewardLevelMeta then
		rewardLevelToPush = userExtend:getFirstNotReceivedRewardLevel(nearestStarRewardLevelMeta.id)
		if rewardLevelToPush then
			-- Has Reward Level
			rewardLevelToPushMeta = MetaManager.getInstance():starReward_getStarRewardMetaById(rewardLevelToPush)
		else
			-- All Reward Level Has Received
		end
	end

	if not rewardLevelToPushMeta then
		if nextRewardLevelMeta then
			rewardLevelToPushMeta = nextRewardLevelMeta
		else
			self.allMissionComplete = true
		end
	end
	self.currentPromptReward = rewardLevelToPushMeta
	
	return self
end