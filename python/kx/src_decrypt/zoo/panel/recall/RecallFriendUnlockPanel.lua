require "zoo.panel.basePanel.panelAnim.PanelPopRemoveAnim"
require "zoo.panel.component.unlockCloudPanel.FriendItem"
require "zoo.baseUI.BuyAndContinueButton"
require 'zoo.panel.MoreStarPanel'
require "zoo.panel.recall.RecallFriendTipPanel"

RecallFriendUnlockPanel = class(UnlockCloudPanel)
local tipPanelHasPop = false
function RecallFriendUnlockPanel:init(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback, ...)
	assert(type(lockedCloudId) == "number")
	assert(type(totalStar) == "number")
	assert(type(neededStar) == "number")
	assert(type(cloudCanOpenCallback) == "function")
	assert(#{...} == 0)

	UnlockCloudPanel.init(self, lockedCloudId, totalStar, neededStar, cloudCanOpenCallback)
	self.animalFriends = {}
	self:initPanel()
end

function RecallFriendUnlockPanel:initPanel()
	--处理好友头像显示
	for i,v in ipairs(self.friendItems) do
		v:setVisible(false)
		--v:setNameVisible(true)
	end
	self.animalFriend1 = self.ui:getChildByName('littleFog')
	self.animalFriend1:setOpacity(0)
	table.insert(self.animalFriends,self.animalFriend1)
	self.animalFriend2 = self.ui:getChildByName('littleChiken')
	self.animalFriend2:setOpacity(0)
	table.insert(self.animalFriends,self.animalFriend2)
	self.animalFriend3 = self.ui:getChildByName('littleHippo')
	self.animalFriend3:setOpacity(0)
	table.insert(self.animalFriends,self.animalFriend3)
	--处理请求好友按钮点击事件
	self.askFriendBtn:removeAllEventListeners() 
	self.askFriendBtn:setString(Localization:getInstance():getText("unlock.cloud.panel.use.friend.unlock", {}))
	local function onAskFriendBtnTapped()
		if RecallManager.getInstance():getFinalRewardState() ~= RecallRewardType.AREA_LONG then 
		   CommonTip:showTip(Localization:getInstance():getText("区域已解锁！"))
		   self:onCloseBtnTapped()
		   return 
		end
		DcUtil:UserTrack({category = "recall", sub_category = "push_unlock"})
		self:unlockAreaDirectly()
	end
	self.askFriendBtn:addEventListener(DisplayEvents.kTouchTap, onAskFriendBtnTapped)
end

function RecallFriendUnlockPanel:showAnimation()
	self:setButtonTouchEnable(false)
	for i,v in ipairs(self.animalFriends) do
		local sequenceArr = CCArray:create()
		local delayTime = CCDelayTime:create(0.2*(i-1))
		local spwanArr = CCArray:create()
		--CCEaseElasticOut
		spwanArr:addObject(CCEaseBounceOut:create(CCMoveBy:create(0.4, ccp(0, 150))))
		spwanArr:addObject(CCFadeTo:create(0.4,255))
		local function moveOverCallBack()
			local animalName = ""
			if i==1 then 
				animalName = "小青蛙"
			elseif i==2 then 
				animalName = "小黄鸡"
			elseif i==3 then 
				animalName = "小河马"
				if not tipPanelHasPop then 
					tipPanelHasPop = true 
					self:showTipPanel()
				else
					self:showButtonAnimation()
				end
			end
			self.friendItems[i]:setNameVisible(true)
			self.friendItems[i]:setName(animalName)
		end

		sequenceArr:addObject(delayTime)
		sequenceArr:addObject(CCSpawn:create(spwanArr))
		sequenceArr:addObject(CCCallFunc:create(moveOverCallBack))

		v:stopAllActions();
		v:runAction(CCSequence:create(sequenceArr));
	end
end

function RecallFriendUnlockPanel:popout()
	self.allowBackKeyTap = true
	PopoutQueue.sharedInstance():push(self)
end

function RecallFriendUnlockPanel:popoutShowTransition()
	self:setToScreenCenterVertical()
	self:setToScreenCenterHorizontal()
	self:showAnimation()
end

function RecallFriendUnlockPanel:setButtonTouchEnable(isEnabled)
	self.closeBtnRes:setTouchEnabled(isEnabled)
	self.askFriendBtn:setEnabled(isEnabled, true)
	self.useWindmillBtn:setEnabled(isEnabled, true)
	self.moreStarBtn:setEnabled(isEnabled, true)
end

function RecallFriendUnlockPanel:unlockAreaDirectly()
	print("unlockAreaDirectly=============================unlock area directly")
	if self.btnTappedState == self.BTN_TAPPED_STATE_NONE then
		self.btnTappedState = self.BTN_TAPPED_STATE_ASK_FRIEND_BTN_TAPPED
	else
		return
	end

	local function onSendUnlockMsgSuccess(event)
		-- Remove Self 
		print("onSendUnlockMsgSuccess Called !")

		local function onRemoveSelfFinish()
			self.cloudCanOpenCallback()
			print("onRemoveSelfFinish Called !")
		end

		self:remove(onRemoveSelfFinish)
		--解锁成功 重置下推送召回功能的流失状态
		RecallManager.getInstance():resetRecallRewardState()
	end

	local function onSendUnlockMsgFailed(event)
		self.btnTappedState = self.BTN_TAPPED_STATE_NONE
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..event.data), "negative")
	end

	local function onSendUnlockMsgCanceled(event)
		self.btnTappedState = self.BTN_TAPPED_STATE_NONE
	end

	local logic = UnlockLevelAreaLogic:create(self.lockedCloudId)
	logic:setOnSuccessCallback(onSendUnlockMsgSuccess)
	logic:setOnFailCallback(onSendUnlockMsgFailed)
	logic:setOnCancelCallback(onSendUnlockMsgCanceled)
	logic:start(UnlockLevelAreaLogicUnlockType.USE_ANIMAL_FRIEND, {})
end

function RecallFriendUnlockPanel:showTipPanel()
	local function delayPopout()
		local tipPanel = RecallFriendTipPanel:create(self)
		tipPanel:popout()
	end

	local sequenceArr = CCArray:create()
	sequenceArr:addObject(CCDelayTime:create(0.5))
	sequenceArr:addObject(CCCallFunc:create(delayPopout))

	self.ui:stopAllActions();
	self.ui:runAction(CCSequence:create(sequenceArr));
end

function RecallFriendUnlockPanel:showButtonAnimation()
	self:setButtonTouchEnable(true)
	local sequenceArr = CCArray:create()
	local currentScaleX = self.askFriendBtnRes:getScaleX()
	local biggerSize = currentScaleX * 1.1
	local smallerSize = currentScaleX * 0.9
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.1, biggerSize)))
	sequenceArr:addObject(CCEaseSineOut:create(CCScaleTo:create(0.3, currentScaleX)))
	sequenceArr:addObject(CCDelayTime:create(5))
	self.askFriendBtnRes:stopAllActions()
	self.askFriendBtnRes:runAction(CCRepeatForever:create(CCSequence:create(sequenceArr)))
end

function RecallFriendUnlockPanel:create(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback, ...)
	assert(type(lockedCloudId) == "number")
	assert(type(totalStar) == "number")
	assert(type(neededStar) == "number")
	assert(type(cloudCanOpenCallback) == "function")
	assert(#{...} == 0)

	local newUnlockCloudPanel = RecallFriendUnlockPanel.new()
	newUnlockCloudPanel:loadRequiredResource(PanelConfigFiles.unlock_cloud_panel_new)
	newUnlockCloudPanel.ui = newUnlockCloudPanel:buildInterfaceGroup('RecallFriendUnlockPanel')
	newUnlockCloudPanel:init(lockedCloudId, totalStar, neededStar, cloudCanOpenCallback)
	return newUnlockCloudPanel
end