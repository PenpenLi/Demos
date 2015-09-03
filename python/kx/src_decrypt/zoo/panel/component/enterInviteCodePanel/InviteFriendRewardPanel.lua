require "zoo.panel.component.enterInviteCodePanel.InviteBtn"
require "zoo.panel.component.enterInviteCodePanel.InviteRulePanel"
require "zoo.panel.component.enterInviteCodePanel.InvitedFriendItem"
require "zoo.panel.WeChatPanel"
require "zoo.panel.InviteRewardPropPanel"

---------------------------------------------------
-------------- InvitedFriendItemRender
---------------------------------------------------

local kMaxRewardFriend = 10
if __IOS_FB then
	kMaxRewardFriend = 25
end

assert(not InvitedFriendItemRender)
assert(TableViewRenderer)
InvitedFriendItemRender = class(TableViewRenderer)

function InvitedFriendItemRender:init(layerToShowTip)
	self.layerToShowTip = layerToShowTip
	self.items = {}
end
function InvitedFriendItemRender:dispose(  )
	--for k,v in pairs(self.items) do
	--	v:dispose()
	--end
	--self.isDisposed = true
end

function InvitedFriendItemRender:updateInvitedFriendItems(data, isPlayAnim)
	self.data = data
	for index,v in pairs(data) do
		if not self.items[index].isDisposed then
			self.items[index]:update(v, isPlayAnim)
		end
	end
end

function InvitedFriendItemRender:buildCell(cell, index)
	if self.items[index] then
		self.items[index]:removeFromParentAndCleanup(true)
	end

	he_log_warning("can reused ?")
	local invitedFriendItem = InvitedFriendItem:create(self.layerToShowTip)
	self.items[index]	= invitedFriendItem

	cell:addChild(invitedFriendItem)

	if self.data then
		self.items[index]:update(self.data[index], false)
	end
end

function InvitedFriendItemRender:getContentSize(tableView, index)
	local invitedFrienditemSize = CCSizeMake(590, 136)
	return invitedFrienditemSize
end

function InvitedFriendItemRender:setData(refCocosObj, index)
	local index = index + 1
end

function InvitedFriendItemRender:numberOfCells()
	return kMaxRewardFriend
end

function InvitedFriendItemRender:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function InvitedFriendItemRender:create(layerToShowTip)

	local newInvitedFriendItemRender = InvitedFriendItemRender.new()
	newInvitedFriendItemRender:loadRequiredResource(PanelConfigFiles.invite_friend_reward_panel)
	newInvitedFriendItemRender:init(layerToShowTip)
	return newInvitedFriendItemRender
end

---------------------------------------------------
-------------- InviteFriendRewardPanel
---------------------------------------------------

assert(not InviteFriendRewardPanel)
assert(BasePanel)
InviteFriendRewardPanel = class(BasePanel)

function InviteFriendRewardPanel:init(scaleOriginPosInWorldSpace)

	kMaxRewardFriend = MetaManager:getInstance():getInviteFriendCount()
	local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
	if newestCfg and newestCfg.maxInviteRewardCount then
		kMaxRewardFriend = newestCfg.maxInviteRewardCount
	end		

	self.ui	= self:buildInterfaceGroup("inviteFriendRewardPanel")
	BasePanel.init(self, self.ui)

	self.panelCloseBtn	= self.ui:getChildByName("panelCloseBtn")
	self.itemPh		= self.ui:getChildByName("itemPh")
	self.ruleBtn = self.ui:getChildByName("ruleBtn")
	self.ruleBtn:setButtonMode(true)
	self.ruleBtn:setTouchEnabled(true)
	self.weChatBtnTag = self.ui:getChildByName("weChatBtnTag")
	self.topTxt = self.ui:getChildByName('topTxt')
	self.topTxt:setString(localize('invite.friend.panel.text.top.initial', {num = kMaxRewardFriend}))
	self.topTxt:setVisible(false)
	self.itemPh:setVisible(false)

	self.scaleOriginPosInWorldSpace = scaleOriginPosInWorldSpace

	self.itemPhPos	= self.itemPh:getPosition()

	self.inviteCode	= UserManager:getInstance().inviteCode

	self.showHideAnim = IconPanelShowHideAnim:create(self, self.scaleOriginPosInWorldSpace)

	local wSize = Director:sharedDirector():getWinSize()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local size = self.ui:getGroupBounds().size


	-- Layer To Show Tip
	local showTipLayer	= Layer:create()
	showTipLayer:setPosition(ccp(self.itemPhPos.x, self.itemPhPos.y))

	-- Table View To Show invitedFriendItem
	local invitedFriendItemRender		= InvitedFriendItemRender:create(showTipLayer)
	self.invitedFriendItemRender		= invitedFriendItemRender

	local invitedFrienditemSize = {width = 590, height = 136}
	local containerSize = self.itemPh:getGroupBounds().size

	self.invitedFriendsItemTableView	= NewTableView:create(invitedFriendItemRender,
									invitedFrienditemSize.width + 200, -- Extra 200 Width, To Avoid Clipping The Friend Picture When Friend Picture Is In The Right Size Of The Panel
									containerSize.height)
									
	local inviteFriendsInfo = UserManager:getInstance().inviteFriendsInfo
	if inviteFriendsInfo then
		invitedFriendItemRender:updateInvitedFriendItems(inviteFriendsInfo, false)
	end

	local invitedFriendsTableViewPosX	= self.itemPhPos.x
	local invitedFriendsTableViewPosY	= self.itemPhPos.y 
	self.invitedFriendsItemTableView:setPosition(ccp(invitedFriendsTableViewPosX, invitedFriendsTableViewPosY))

	-- Add to self.ui
	self.ui:addChild(self.invitedFriendsItemTableView)
	self.ui:addChild(showTipLayer)

	local panelTitleKey	= "invite.friend.panel.tittle"
	local panelTitleValue	= localize(panelTitleKey, {})
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(panelTitleValue)

	local function onCloseBtnTapped()
		self:onCloseBtnTapped()
	end
	self.panelCloseBtn:setTouchEnabled(true, 0 , true)
	self.panelCloseBtn:setButtonMode(true)
	self.panelCloseBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
	-- Must Bring To Top, Or Will Blocked Input By NewTableView
	self.panelCloseBtn:removeFromParentAndCleanup(false)
	self.ui:addChild(self.panelCloseBtn)

	-- Rule Btn
	local function onRuleBtnTapped(event)
		self:onRuleBtnTapped(event)
	end
	self.ruleBtn:addEventListener(DisplayEvents.kTouchTap, onRuleBtnTapped)
	-- fix: prevent this btn from being on top of the tip layer
	local zorder = self.ruleBtn:getZOrder()
	self.ruleBtn:removeFromParentAndCleanup(false)
	self.ui:addChildAt(self.ruleBtn, zorder)

	-- WeChat Button
	self.weChatBtn = GroupButtonBase:create(self.ui:getChildByName('weChatBtn'))
	self.weChatBtn.groupNode:getChildByName('icon'):setVisible(false)
	self.weChatBtn:setString(localize('invite.friend.panel.button.text.wechat'))
	if __IOS_FB then
		self.weChatBtn:setString(localize('invite.friend.panel.button.text.wdj'))
		local function onInviteButtonTapped(event)
			self:onFBInviteBtnTapped(event)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		self.weChatBtn:setString(localize('invite.friend.panel.button.text.mitalk'))
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.kMiTalk)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.k360) then 
		self.weChatBtn:setString(localize('invite.friend.panel.button.text.360'))
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.k360)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) then
		local function onInviteButtonTapped(event)
			self:onWdjBtnTapped(event)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
		self.weChatBtn:setString(localize('invite.friend.panel.button.text.wdj'))
	else
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.kWechat)
			-- self:showWdjInvitePanel()
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
		self.weChatBtn:setString(localize('invite.friend.panel.button.text.wechat'))
		self.weChatBtn.groupNode:getChildByName('icon'):setVisible(true)
		self.weChatBtn.label:setPositionX(self.weChatBtn.label:getPositionX()+35)
	end

	-- fix: prevent this btn from being on top of the tip layer
	zorder = self.weChatBtn.groupNode:getZOrder()
	self.weChatBtn:removeFromParentAndCleanup(false)
	self.weChatBtn:useBubbleAnimation()
	self.ui:addChildAt(self.weChatBtn.groupNode, zorder)

	self.inviteCodeBtn = GroupButtonBase:create(self.ui:getChildByName('inviteCodeBtn'))
	self.inviteCodeBtn:setColorMode(kGroupButtonColorMode.blue)
	self.inviteCodeBtn:setEnabled(true)
	self.inviteCodeBtn:setString(localize('回馈邀请人'))
	self.inviteCodeBtn:ad(DisplayEvents.kTouchTap, function () self:onInviteCodeBtnTapped() end)
	zorder = self.inviteCodeBtn.groupNode:getZOrder()
	self.inviteCodeBtn:removeFromParentAndCleanup(false)
	self.inviteCodeBtn:useBubbleAnimation()
	self.ui:addChildAt(self.inviteCodeBtn.groupNode, zorder)


	local meta = MetaManager:getInstance().rewards
	local itemId, itemNum = 10012, 20
	if meta[3] then
		local reward = meta[3].rewards
		if type(reward) == "table" then
			itemId, itemNum = reward[1].itemId, reward[1].num
		end
	else self.weChatBtnTag:setVisible(false) end
	local icon = self.weChatBtnTag:getChildByName("icon")
	icon:setVisible(false)
	local number = self.weChatBtnTag:getChildByName("number")
	local sprite
	if itemId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
		sprite:setScale(0.3)
	elseif itemId == 14 then
		sprite = Sprite:createWithSpriteFrameName("wheel0000")
		sprite:setAnchorPoint(ccp(0, 1))
		sprite:setScale(0.75)
	else
		sprite = ResourceManager:sharedInstance():buildItemGroup(itemId)
		sprite:setScale(0.5)
	end
	if type(sprite) ~= "nil" then
		sprite:setPositionXY(icon:getPositionX(), icon:getPositionY())
		local index = self.weChatBtnTag:getChildIndex(icon)
		self.weChatBtnTag:addChildAt(sprite, index)
	end
	number:setText('+'..itemNum)
	
	if not MaintenanceManager:getInstance():isEnabled("ShareCoin") or
		UserManager:getInstance():isUserRewardBitSet(3) then
		self.weChatBtnTag:setVisible(false)
	end

	if not self:shouldShowInviteCodeBtn() then
		self.inviteCodeBtn:setVisible(false)
		self.inviteCodeBtn:setEnabled(false)
		self.weChatBtn:setPositionX(self.weChatBtn:getPositionX() + 114)
		self.weChatBtnTag:setPositionX(self.weChatBtnTag:getPositionX() + 114)
	end

	------------------------------
	-- Move Show Tip Layer To Top
	-- --------------------------
	showTipLayer:removeFromParentAndCleanup(false)
	self.ui:addChild(showTipLayer)

	print('wenkan', PlatformConfig.name)
end

function InviteFriendRewardPanel:getVCenterInParentY()
	-- Vertical Center In Screen Y
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	-- local selfHeight	= self:getGroupBounds().size.height
	local selfHeight = 950

	local deltaHeight	= visibleSize.height - selfHeight
	local halfDeltaHeight	= deltaHeight / 2

	local vCenterInScreenY	= visibleOrigin.y + halfDeltaHeight + selfHeight

	-- Vertical Center In Parent Y
	local parent 		= self:getParent()
	local posInParent	= parent:convertToNodeSpace(ccp(0, vCenterInScreenY))

	return posInParent.y
end

function InviteFriendRewardPanel:shouldShowInviteCodeBtn()
	if __WIN32 then 
		return true -- test
	end
	local userTopLevel = UserManager.getInstance().user:getTopLevelId()

	-- If >= 31, Pop The InviteFriendRewardPanel
	if userTopLevel >= 31 then
		--inviteFriendPanel:popoutWithBgFadeIn()
	else
		-- <= 30 , and Never Entered AN Invite Code Then, Pop The EnterInviteCodePanel 
		local flag = UserManager:getInstance().userExtend.flag or 0
		if flag % 2 == 0  then
			-- Not Sended Invite Code Ever
			if not __IOS_FB and not PlatformConfig:isPlatform(PlatformNameEnum.k360) then 
				return true
			end
		end
	end
	return false
end

function InviteFriendRewardPanel:onInviteCodeBtnTapped()
	local enterInviteCodePanel	= EnterInviteCodePanel:create()
	enterInviteCodePanel:popout()
end

function InviteFriendRewardPanel:onWdjBtnTapped(event)
	self:showWdjInvitePanel()
end

function InviteFriendRewardPanel:showWdjInvitePanel()
	if self.wdjPanel then return end
	local panel = self:buildInterfaceGroup('invite_friend_wdj_click')
	local wdjBtn = panel:getChildByName('wdjBtn')
	local wechatBtn = panel:getChildByName('wechatBtn')
	local cancelBtn = panel:getChildByName('cancelBtn')
	wdjBtn:setButtonMode(false)
	wdjBtn:setTouchEnabled(true)
	wdjBtn:ad(DisplayEvents.kTouchTap, 
		function () 
			self:removeWdjInvitePanel() 
			self:doWdjInvite() 
		end)

	wechatBtn:setButtonMode(false)
	wechatBtn:setTouchEnabled(true)
	wechatBtn:ad(DisplayEvents.kTouchTap, 
		function () 
			self:removeWdjInvitePanel() 
			self:onInviteButtonTapped(nil, PlatformShareEnum.kWechat) 
		end)

	cancelBtn:setButtonMode(false)
	cancelBtn:setTouchEnabled(true)
	cancelBtn:ad(DisplayEvents.kTouchTap, 
		function () 
			self:removeWdjInvitePanel() 
		end)

	self.wdjPanel = panel
	PopoutManager:sharedInstance():add(panel, false, true)
	local vo = Director:sharedDirector():getVisibleOrigin()
	local vs = Director:sharedDirector():getVisibleSize()
	panel:setPositionX(vo.x)
	panel:setPositionY(-vs.height)
	panel:runAction(CCEaseExponentialOut:create(CCMoveBy:create(0.5, ccp(0, panel:getGroupBounds().size.height))))
end

function InviteFriendRewardPanel:removeWdjInvitePanel(callback)
	if not self.wdjPanel or self.wdjPanel.isDisposed then 
		callback() 
		return 
	end
	local function remove()
		if not self.wdjPanel or self.wdjPanel.isDisposed then return end
		PopoutManager:sharedInstance():remove(self.wdjPanel, true)
		self.wdjPanel = nil
		if callback then
			callback()
		end
	end
	self.wdjPanel:runAction(CCSequence:createWithTwoActions(
			CCEaseExponentialIn:create(CCMoveBy:create(0.5, ccp(0, -self.wdjPanel:getGroupBounds().size.height))),
			CCCallFunc:create(remove)
		))
end

function InviteFriendRewardPanel:doWdjInvite()
	if not PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) then return end
	local function onSuccess(data)
		if data then print(table.tostring(data)) end
		print('success')
		local dataTable = luaJavaConvert.map2Table(data)
		local count = 0
		if dataTable then 
			count = #dataTable
		end
		DcUtil:wdjInvite(count)
	end
	local function onError(data)
		if data then print(table.tostring(data)) end
		print('error')
	end

	local function onCancel(data)
		if data then print(table.tostring(data)) end
		print('cancel')
	end
	local callback = {onSuccess = onSuccess, onError = onError, onCancel = onCancel}
	SnsProxy:inviteFriends(callback)
	DcUtil:wdjClick()

end

function InviteFriendRewardPanel:onCloseBtnTapped(event)
	print("InviteFriendRewardPanel:onCloseBtnTapped")
	
	local function callback()
		self.allowBackKeyTap = false
		self:remove()
	end
	self:removeGuide()
	self:removeWdjInvitePanel(callback)	
end

function InviteFriendRewardPanel:onRuleBtnTapped(event)
	self:setVisible(false)
	local inviteRulePanel = InviteRulePanel:create()
	inviteRulePanel:popout()
end

function InviteFriendRewardPanel:onFBInviteBtnTapped(event)
	if not SnsProxy:isLogin() then 
		CommonTip:showTip(localize("error.tip.facebook.login"), "negative",nil,2)
	else
		local callback = {
			onSuccess = function( result )
				local config = CCUserDefault:sharedUserDefault()
				config:setBoolForKey("game.invite.friend.wechat.tutor", true)
				config:flush()
			end,
			onError = function(err)
			end
		}
		SnsProxy:inviteFriends(callback)
	end
end

function InviteFriendRewardPanel:onInviteButtonTapped( event, shareType)
	local function doShareInvitation()
		local shareCallback = {
			onSuccess=function(result)
				local config = CCUserDefault:sharedUserDefault()
				config:setBoolForKey("game.invite.friend.wechat.tutor", true)
				DcUtil:sendInvitation(self.inviteCode)
				config:flush()
				if MaintenanceManager:getInstance():isEnabled("ShareCoin") and
					not UserManager:getInstance():isUserRewardBitSet(3) then
					self.weChatBtnTag:setVisible(false)
					InviteRewardPropPanel:getReward()
				end
				self.weChatBtn:setEnabled(true)
			end,
			onError=function(errCode, msg) 
				self.weChatBtn:setEnabled(true)
			end,
			onCancel=function()
				self.weChatBtn:setEnabled(true)
			end
		}
		SnsUtil.sendInviteMessage(shareType, shareCallback)
	end

	if shareType ~= PlatformShareEnum.k360 then -- 360分享不用隐藏按钮
		self.weChatBtn:setEnabled(false)
		if shareType ~= PlatformShareEnum.kWechat then
			setTimeOut(function()
				if self.weChatBtn.isDisposed then
					self.weChatBtn:setEnabled(true)
				end
			end, 2)
		end
	end

	local invited = CCUserDefault:sharedUserDefault():getBoolForKey("game.invite.friend.wechat.tutor")
	if shareType == PlatformShareEnum.kWechat and not invited then
		local function onClose() self.weChatBtn:setEnabled(true) end
		local panel = WeChatPanel:create(function()
			setTimeOut(function()
				if not self.weChatBtn.isDisposed then
					self.weChatBtn:setEnabled(true)
				end
			end, 2)
			doShareInvitation()
		end, onClose)
		if panel then panel:popout() end
	else
		doShareInvitation()
	end
end

function InviteFriendRewardPanel:popout(...)
	self:updateEachFriendItem()	
end

function InviteFriendRewardPanel:setToScreenCenterVertical()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfHeight	= self:getGroupBounds().size.height
	local deltaHeight	= visibleSize.height - selfHeight
	local halfDeltaHeight	= deltaHeight / 2
	local vCenterInScreenY	= visibleOrigin.y + halfDeltaHeight + selfHeight
	local parent		= self:getParent()
	local posInParent	= parent:convertToNodeSpace(ccp(0, vCenterInScreenY))

	self:setPositionForPopoutManager()
end

function InviteFriendRewardPanel:remove()
	local function onPanelHideAnimFinishFunc()
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
	end
	self.showHideAnim:playHideAnim(onPanelHideAnimFinishFunc)
end

function InviteFriendRewardPanel:onEnterHandler(event, ...)
	if event == "enter" then
		

	elseif event == "exit" then

	end
end

function InviteFriendRewardPanel:updateEachFriendItem()
	local function onSendGetInviteFriendMsgSuccess(data)
		print("InviteFriendRewardPanel:updateEachFriendItem Called !")
		PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
		local function callback()
			self.allowBackKeyTap = true
			self:tryRunGuide()
			if InviteFriendRewardPanel:shouldForcePopInviteCodePanel() then
				self:onInviteCodeBtnTapped()
				InviteFriendRewardPanel:writeForcePopTime()
			end
		end
		self.showHideAnim:playShowAnim(callback)

		-- Extrace The Invited Friend Ids
		local friendIds = {}

		for k,v in pairs(data) do
			if tonumber(v.friendUid) == 0 then

			else
				table.insert(friendIds, tonumber(v.friendUid))
			end
		end

		if #friendIds > 0 and not self.isDisposed then
			if #friendIds < kMaxRewardFriend then
				self.topTxt:setString(localize('invite.friend.panel.text.top.current', 
																{invited = #friendIds, free = kMaxRewardFriend - #friendIds}))
			elseif #friendIds == kMaxRewardFriend then
				self.topTxt:setString('')
			end
		end
		if not self.isDisposed then self.topTxt:setVisible(true) end

		-- Send Friend Http Use Invited Friends UID
		local function onSendFriendHttpSuccess()

			print("onSendFriendHttpSuccess Called !")

			if not self.updateEachFriendItemIsCalled then
				self.updateEachFriendItemIsCalled = true
				
				local data = UserManager:getInstance().inviteFriendsInfo
				self.invitedFriendItemRender:updateInvitedFriendItems(data, false)
			else
				self.invitedFriendItemRender:updateInvitedFriendItems(data, false)
			end
		end

		local function onSendFriendHttpFailed()
			-- Do Nothing
			print("onSendFriendHttpFailed !! ")
		end
		onSendFriendHttpSuccess()
	end

	self:sendGetInviteFriendsInfoMsg(onSendGetInviteFriendMsgSuccess)
end

function InviteFriendRewardPanel:sendFriendHttp(friendIds, onSuccessCallback, onFailedCallback)

	local function onSuccess()

		if onSuccessCallback then
			onSuccessCallback()
		end
	end

	local function onFailed(event)
		assert(event)
		assert(event.name == Events.kError)

		local err = event.data

		if onFailedCallback then
			onFailedCallback()
		end
	end

	local http = FriendHttp.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	
	http:load(true, friendIds)
end

function InviteFriendRewardPanel:sendGetInviteFriendsInfoMsg(onSuccessCallback)

	local function onSuccess(event)
		print("In Class InviteFriendRewardPanel: invite friend info successed !")
		local data = event.data

		local function invitedFriendsHttpSuccess()
			print('this debug invitedFriendsHttpSuccess')
			onSuccessCallback(data)
		end
		local invitedFriendsHttp = GetInvitedFriendsUserInfo.new()
		invitedFriendsHttp:addEventListener(Events.kComplete, invitedFriendsHttpSuccess)
		invitedFriendsHttp:load(data)
	end

	local function onFailed(event)

		local err = event.data
		CommonTip:showTip(localize("error.tip."..err), "negative")
		self:dispose()
	end

	local http = GetInviteFriendsInfo.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:load()
end

function InviteFriendRewardPanel:reBecomeTopPanel()
	self:setVisible(true)
end

function InviteFriendRewardPanel:create(scaleOriginPosInWorldSpace)
	local newInviteFriendRewardPanel = InviteFriendRewardPanel.new()
	newInviteFriendRewardPanel:loadRequiredResource(PanelConfigFiles.invite_friend_reward_panel)
	newInviteFriendRewardPanel:init(scaleOriginPosInWorldSpace)
	return newInviteFriendRewardPanel
end

function InviteFriendRewardPanel:dispose()
	self.invitedFriendItemRender:dispose()
	BasePanel.dispose(self)
end

function InviteFriendRewardPanel:getHCenterInParentX()
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth = 670
	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2
	local vCenterInScreenX	= visibleOrigin.x + halfDeltaWidth
	local parent 		= self:getParent()
	local posInParent	= parent:convertToNodeSpace(ccp(vCenterInScreenX, 0))
	return posInParent.x
end

function InviteFriendRewardPanel:hasRunGuide() -- static
	local value = CCUserDefault:sharedUserDefault():getIntegerForKey('game.invite.friend.run.guide.time', nil)
	if value ~= nil and value ~= 0 then
		return true, value
	else
		return false
	end
end

function InviteFriendRewardPanel:setHasRunGuide()
	CCUserDefault:sharedUserDefault():setIntegerForKey("game.invite.friend.run.guide.time", Localhost:time() / 1000)
end

function InviteFriendRewardPanel:removeGuide()
	if not self.isGuideOnScreen then return end
	if self.mask and not self.mask.isDisposed then
        self.mask:removeFromParentAndCleanup(true)
    end
    if self.guidePanel and not self.guidePanel.isDisposed then
        self.guidePanel:removeFromParentAndCleanup(true)
    end
    InviteFriendRewardPanel:setHasRunGuide()
    self.isGuideOnScreen = false
end

function InviteFriendRewardPanel:tryRunGuide()
	if InviteFriendRewardPanel:hasRunGuide() then
		return false
	end
	if not self:shouldShowInviteCodeBtn() then
		return false
	end
    if self.isGuideOnScreen then return false end
    self.isGuideOnScreen = true

    local pos = self.inviteCodeBtn.groupNode:getParent():convertToWorldSpace(self.inviteCodeBtn.groupNode:getPosition())
    local action = 
    {
        opacity = 0xCC, 
        text = "tutorial.game.invite.1",
        panType = "down", panAlign = "viewY", panPosY = pos.y + 400, panFlip = true,
        maskDelay = 0.3,maskFade = 0.4 ,panDelay = 0.5, touchDelay = 1
    }
    local panel = GameGuideUI:panelS(nil, action, false)
    local mask = GameGuideUI:mask(
        action.opacity, 
        action.touchDelay, 
        ccp(pos.x, pos.y),
        2, 
        false, 
        nil, 
        nil, 
        false,
        true)
    mask.setFadeIn(action.maskDelay, action.maskFade)

    local function newOnTouch(evt)
        self:removeGuide()
    	if self.isDisposed then return end

        if self.inviteCodeBtn.groupNode:hitTestPoint(evt.globalPosition, true) then       
            local event = {name = DisplayEvents.kTouchTap}
            self.inviteCodeBtn.groupNode:dispatchEvent(event)
        end
    end
    mask:removeEventListenerByName(DisplayEvents.kTouchTap)
    mask:ad(DisplayEvents.kTouchTap, newOnTouch)
    local scene = Director:sharedDirector():getRunningScene()
    if scene then
        scene:addChild(mask)
        scene:addChild(panel)
    end
    self.mask = mask
    self.guidePanel = panel

    return true
end

local function getDayStartTimeByTS(ts)
	local utc8TimeOffset = 57600 -- (24 - 8) * 3600
	local oneDaySeconds = 86400 -- 24 * 3600
	return ts - ((ts - utc8TimeOffset) % oneDaySeconds)
end

function InviteFriendRewardPanel:shouldForcePopInviteCodePanel() -- static
	if UserManager.getInstance().user:getTopLevelId() >= 31 then
		return false
	end
	local flag = UserManager:getInstance().userExtend.flag or 0
	if flag % 2 ~= 0 then 
		return false
	end
	if __IOS_FB or PlatformConfig:isPlatform(PlatformNameEnum.k360) then
		return false
	end
	-- 播放引导后才能强弹
	local hasRunGuide, value = InviteFriendRewardPanel:hasRunGuide()
	if not hasRunGuide then return false end
	local runTime = tonumber(value) or 0
	local curTime = Localhost:time() / 1000
	if curTime - runTime > 3*24*60*60 then -- 仅头3天强弹
		return false
	end
	local lastPopTime = CCUserDefault:sharedUserDefault():getIntegerForKey('game.invite.friend.last.pop.time', 0)
	if curTime - lastPopTime < 24*3600 then -- 一天之内只弹一次
		return false
	end

	return true
end

function InviteFriendRewardPanel:writeForcePopTime()
	--记录的是一天开始的时间
	local time = getDayStartTimeByTS(Localhost:time()/1000)
	CCUserDefault:sharedUserDefault():setIntegerForKey('game.invite.friend.last.pop.time', time)
end