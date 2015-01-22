require "zoo.panel.component.enterInviteCodePanel.InviteBtn"
require "zoo.panel.component.enterInviteCodePanel.InviteRulePanel"
--require "zoo.panel.component.enterInviteCodePanel.ShareToWeiboPanel"
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

function InvitedFriendItemRender:init(layerToShowTip, ...)
	assert(layerToShowTip)
	assert(#{...} == 0)

	self.layerToShowTip = layerToShowTip
	self.items = {}
end
function InvitedFriendItemRender:dispose(  )
	--for k,v in pairs(self.items) do
	--	v:dispose()
	--end
	--self.isDisposed = true
end

function InvitedFriendItemRender:updateInvitedFriendItems(data, isPlayAnim, ...)
	assert(data)
	assert(type(isPlayAnim) == "boolean")
	assert(#{...} == 0)

	self.data = data

	--print("InvitedFriendItemRender:updateInvitedFriendItems Called !")
	--print(table.tostring(self.data))

	for index,v in pairs(data) do
		if not self.items[index].isDisposed then
			self.items[index]:update(v, isPlayAnim)
		end
	end
end

function InvitedFriendItemRender:buildCell(cell, index, ...)
	assert(cell)
	assert(type(index) == "number")
	assert(#{...} == 0)

	--index = index + 1

	if self.items[index] then
		self.items[index]:removeFromParentAndCleanup(true)
	end

	he_log_warning("can reused ?")
	local invitedFriendItem = InvitedFriendItem:create(self.layerToShowTip)
	self.items[index]	= invitedFriendItem

	cell:addChild(invitedFriendItem)

	--local itemHeight	= invitedFriendItem:getGroupBounds().size.height
	--local itemSize = ResourceManager:sharedInstance():getGroupSize("invitedFriendItem")
	--he_log_warning("manual adjust table view item pos in InvitedFriendItemRender !")
	--invitedFriendItem:setPosition(ccp(0, itemSize.height - 20))
	--cell.refCocosObj:addChild(invitedFriendItem.refCocosObj)

	-- -----------
	-- Update View
	-- ------------

	if self.data then
		self.items[index]:update(self.data[index], false)
	end

	--invitedFriendItem:releaseCocosObj()
end

function InvitedFriendItemRender:getContentSize(tableView, index, ...)
	assert(#{...} == 0)

	-- local size = ResourceManager:sharedInstance():getGroupSize("invitedFriendItem")
	-- return CCSizeMake(size.width, size.height)
	local invitedFrienditemSize = CCSizeMake(590, 136)
	return invitedFrienditemSize
	--local width 	= 600
	--local height	= 135
	--return CCSizeMake(width, height)
end

function InvitedFriendItemRender:setData(refCocosObj, index, ...)
	assert(#{...} == 0)

	local index = index + 1

	--local invitedFriendItem = self.items[index]
	--assert(invitedFriendItem)

	--if self.data then
	--	self.items[index]:update(self.data[index], false)
	--end
end

function InvitedFriendItemRender:numberOfCells(...)
	assert(#{...} == 0)

	-- he_log_warning("Hard Coded: number of friends-can-be-invited = 10")
	return kMaxRewardFriend
end

function InvitedFriendItemRender:loadRequiredResource(panelConfigFile)
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function InvitedFriendItemRender:create(layerToShowTip, ...)
	assert(layerToShowTip)
	assert(#{...} == 0)

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

function InviteFriendRewardPanel:init(scaleOriginPosInWorldSpace, ...)
	assert(scaleOriginPosInWorldSpace)
	assert(#{...} == 0)

	kMaxRewardFriend = MetaManager:getInstance():getInviteFriendCount()
	local newestCfg = Localhost.getInstance():getUpdatedGlobalConfig()
	if newestCfg and newestCfg.maxInviteRewardCount then
		kMaxRewardFriend = newestCfg.maxInviteRewardCount
	end		

	-----------
	-- Get UI
	-- ---------
	-- self.ui	= ResourceManager:sharedInstance():buildGroup("inviteFriendRewardPanel")
	self.ui	= self:buildInterfaceGroup("inviteFriendRewardPanel")

	-------------------
	-- Init Base Class
	-- ---------------
	BasePanel.init(self, self.ui)

	-----------------
	-- Get UI Resource
	-- -----------------
	self.panelCloseBtn	= self.ui:getChildByName("panelCloseBtn")
	self.itemPh		= self.ui:getChildByName("itemPh")
	-- self.inviteCodeLabel	= self.ui:getChildByName("inviteCodeLabel")
	-- self.ruleBtn		= self.ui:getChildByName("ruleBtn")
	self.ruleBtn = GroupButtonBase:create(self.ui:getChildByName("ruleBtn"))
	self.ruleBtn:setColorMode(kGroupButtonColorMode.green)
	self.ruleBtn:useStaticLabel(52)
	self.ruleBtn:setString(Localization:getInstance():getText('invite.friend.panel.rule02'))
	-- self.ruleBtn:setButtonMode(true)
	-- self.ruleBtn:setTouchEnabled(true)
	-- self.inviteBtnRes	= self.ui:getChildByName("inviteBtn")
	-- self.weChatBtn = ButtonIconsetBase:create(self.ui:getChildByName('weChatBtn'))
	-- self.weChatBtn = GroupButtonBase:create(self.ui:getChildByName('weChatBtn'))
	self.weChatBtnTag = self.ui:getChildByName("weChatBtnTag")

	-- if __IOS_FB then
	-- 	self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wdj'))
	-- else
	-- 	self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wechat'))
	-- end
	-- self.weChatBtn:setIconByFrameName('inviteFriend_weChat_Symbol0000')

	-- self.WdjBtn = ButtonIconsetBase:create(self.ui:getChildByName('WdjBtn'))
	self.WdjBtn = GroupButtonBase:create(self.ui:getChildByName('WdjBtn'))
	self.WdjBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wdj'))
	-- self.WdjBtn:setIconByFrameName('inviteFriend_WDJ_Symbol0000')

	self.topTxt = self.ui:getChildByName('topTxt')
	self.topTxt:setString(Localization:getInstance():getText('invite.friend.panel.text.top.initial', {num = kMaxRewardFriend}))
	self.topTxt:setVisible(false)

	assert(self.panelCloseBtn)
	assert(self.itemPh)
	-- assert(self.inviteCodeLabel)
	-- assert(self.ruleBtnRes)
	-- assert(self.inviteBtnRes)

	------------------
	-- Init UI Resource
	-- -------------
	self.itemPh:setVisible(false)

	------------
	-- Data
	-- --------
	self.scaleOriginPosInWorldSpace = scaleOriginPosInWorldSpace

	---------------------------------
	-- Get Data About UI Component
	-- --------------------------
	self.itemPhPos	= self.itemPh:getPosition()

	self.inviteCode	= UserManager:getInstance().inviteCode

	-------------------
	-- Create Show Hide Anim
	-- --------------------
	self.showHideAnim = IconPanelShowHideAnim:create(self, self.scaleOriginPosInWorldSpace)

	--------------------
	-- Create UI Component
	-- -------------------
	-- self.ruleBtn	= ButtonWithShadow:create(self.ruleBtnRes)
	-- self.inviteBtn	= InviteBtn:create(self.inviteBtnRes)
	-- self.ruleBtn	= GroupButtonBase:create(self.ruleBtnRes)
	-- self.ruleBtn:setColorMode(kGroupButtonColorMode.blue)
	-- self.ruleBtn:setVisible(true)
	-- self.ruleBtn:useStaticLabel(40)
	-- self.inviteBtn	= GroupButtonBase:create(self.inviteBtnRes)
	-- self.inviteBtn:setColorMode(kGroupButtonColorMode.green)

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

	-- local invitedFrienditemSize		= ResourceManager:sharedInstance():getGroupSize("invitedFriendItem")
	local invitedFrienditemSize = {width = 590, height = 136}
	--self.invitedFriendsItemTableView	= TableView:create(invitedFriendItemRender,
	--								invitedFrienditemSize.width, 
	--								invitedFrienditemSize.height * 4.5)
	local containerSize = self.itemPh:getGroupBounds().size

	self.invitedFriendsItemTableView	= NewTableView:create(invitedFriendItemRender,
									invitedFrienditemSize.width + 200, -- Extra 200 Width, To Avoid Clipping The Friend Picture When Friend Picture Is In The Right Size Of The Panel
									containerSize.height)
									--invitedFrienditemSize.height * 4.5)
									




	local inviteFriendsInfo = UserManager:getInstance().inviteFriendsInfo
	if inviteFriendsInfo then
		invitedFriendItemRender:updateInvitedFriendItems(inviteFriendsInfo, false)
	end

	local invitedFriendsTableViewPosX	= self.itemPhPos.x
	--local invitedFriendsTableViewPosY	= self.itemPhPos.y - invitedFrienditemSize.height * 4.5
	local invitedFriendsTableViewPosY	= self.itemPhPos.y 
	self.invitedFriendsItemTableView:setPosition(ccp(invitedFriendsTableViewPosX, invitedFriendsTableViewPosY))

	-- Add to self.ui
	self.ui:addChild(self.invitedFriendsItemTableView)
	self.ui:addChild(showTipLayer)

	---------------------
	-- Update View
	-- --------------
	local panelTitleKey	= "invite.friend.panel.tittle"
	local panelTitleValue	= Localization:getInstance():getText(panelTitleKey, {})
	self.panelTitle = TextField:createWithUIAdjustment(self.ui:getChildByName("panelTitleSize"), self.ui:getChildByName("panelTitle"))
	self.ui:addChild(self.panelTitle)
	self.panelTitle:setString(panelTitleValue)

	-- local inviteBtnKey	= "invite.friend.panel.invite.button"
	-- local inviteBtnValue	= Localization:getInstance():getText(inviteBtnKey, {})
	-- self.inviteBtn:setString(inviteBtnValue)

	-- local ruleBtnKey	= "invite.friend.panel.rule02"
	-- local ruleBtnValue	= Localization:getInstance():getText(ruleBtnKey, {})
	-- self.ruleBtn:getChildByName('txt'):setString(ruleBtnValue)

	-- local inviteCodeLabelKey 	= "invite.friend.panel.code.desc"
	-- local inviteCodeLabelValue	= Localization:getInstance():getText(inviteCodeLabelKey, {yaoqingma = self.inviteCode})

	-- print(inviteCodeLabelValue)
	-- --debug.debug()
	-- self.inviteCodeLabel:setString(inviteCodeLabelValue)

	----------------------
	-- Add Event Listener
	-- ------------------

	-- ---------
	-- Close Btn
	-- -------
	local function onCloseBtnTapped()
		self:onCloseBtnTapped()
	end
	self.panelCloseBtn:setTouchEnabled(true, 0 , true)
	self.panelCloseBtn:setButtonMode(true)
	self.panelCloseBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
	-- Must Bring To Top, Or Will Blocked Input By NewTableView
	self.panelCloseBtn:removeFromParentAndCleanup(false)
	self.ui:addChild(self.panelCloseBtn)

	----------
	-- Rule Btn
	-- -----------
	local function onRuleBtnTapped(event)
		self:onRuleBtnTapped(event)
	end
	self.ruleBtn:addEventListener(DisplayEvents.kTouchTap, onRuleBtnTapped)
	-- fix: prevent this btn from being on top of the tip layer
	local zorder = self.ruleBtn.groupNode:getZOrder()
	self.ruleBtn:removeFromParentAndCleanup(false)
	self.ui:addChildAt(self.ruleBtn.groupNode, zorder)


	----------------
	-- Invite Btn
	-- --------------
	-- local function onInviteBtnTapped(event)
	-- 	print 'touched'
	-- 	self:onInviteBtnTapped(event)
	-- end
	-- self.inviteBtn:addEventListener(DisplayEvents.kTouchTap, onInviteBtnTapped)

	-- self.inviteBtn:removeFromParentAndCleanup(false)
	-- -- self.ui:addChild(self.inviteBtn)
	-- self.ui:addChild(self.inviteBtn.groupNode)

	--------------
	-- WeChat Button
	---------------
	self.weChatBtn = GroupButtonBase:create(self.ui:getChildByName('weChatBtn'))
	self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wechat'))
	if __IOS_FB then
		self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wdj'))
		local function onInviteButtonTapped(event)
			self:onFBInviteBtnTapped(event)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.mitalk'))
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.kMiTalk)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.k360) then 
		self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.360'))
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.k360)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	else
		local function onInviteButtonTapped(event)
			self:onInviteButtonTapped(event, PlatformShareEnum.kWechat)
		end
		self.weChatBtn:addEventListener(DisplayEvents.kTouchTap, onInviteButtonTapped)
	end

	-- fix: prevent this btn from being on top of the tip layer
	zorder = self.weChatBtn.groupNode:getZOrder()
	self.weChatBtn:removeFromParentAndCleanup(false)
	self.weChatBtn:useBubbleAnimation()
	self.ui:addChildAt(self.weChatBtn.groupNode, zorder)

	---------------------
	-- WDJ button
	-------------------

	local function onWdjBtnTapped(event)
		self:onWdjBtnTapped(event)
	end
	self.WdjBtn:addEventListener(DisplayEvents.kTouchTap, onWdjBtnTapped)
	-- fix: prevent this btn from being on top of the tip layer
	zorder = self.WdjBtn.groupNode:getZOrder()
	self.WdjBtn:removeFromParentAndCleanup(false)
	self.ui:addChildAt(self.WdjBtn.groupNode, zorder)


	-------------------------------------------------------------
	-- Adjust button positions for WDJ version and other versions
	-------------------------------------------------------------

	local wdjLocator = self.ui:getChildByName('ver.WDJ_WdjBtnLocator')
	local wechatLocator = self.ui:getChildByName('ver.WDJ_WechatBtnLocator')

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

	if PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) then
		-- note: reposition the locators in the flash file to reposition these buttons
		--       change the scale factor to resize the wechat button.
		self.WdjBtn:setPosition(ccp(wdjLocator:getPositionX(), wdjLocator:getPositionY()))
		self.weChatBtn:setPosition(ccp(wechatLocator:getPositionX(), wechatLocator:getPositionY()))
		-- fix: remove bubble animation. set scale and then build animation
		self.weChatBtn.groupNode:stopAllActions()
		self.weChatBtn:setScale(0.5)
		self.weChatBtnTag:setScale(0.5)
		self.weChatBtn:useBubbleAnimation()
		self.weChatBtn:setColorMode(kGroupButtonColorMode.blue)
		self.weChatBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wechat.wdj'))
		local buttonSize = self.weChatBtn:getGroupBounds().size
		local tagSize = self.weChatBtnTag:getGroupBounds().size
		self.weChatBtnTag:setPosition(ccp(wechatLocator:getPositionX() + buttonSize.width / 2 - tagSize.width / 2,
			wechatLocator:getPositionY() + buttonSize.height / 2 + tagSize.width / 2))
	else 
		-- other versions: remove WDJ btn
		self.WdjBtn:removeFromParentAndCleanup(true)
		-- center wechat button
		local btnPos = self.weChatBtn:getPosition()
		local parentSize = self.weChatBtn:getParent():getGroupBounds().size
		self.weChatBtn:setPosition(ccp(parentSize.width / 2, btnPos.y))
		local buttonSize = self.weChatBtn:getGroupBounds().size
		local tagSize = self.weChatBtnTag:getGroupBounds().size
		self.weChatBtnTag:setPosition(ccp(parentSize.width / 2 + buttonSize.width / 2 - tagSize.width / 2,
			btnPos.y + buttonSize.height / 2 + tagSize.height / 2 - 5))
	end
	-- remove the locators
	wdjLocator:setVisible(false)
	wechatLocator:setVisible(false)
	self.ui:addChild(wdjLocator)
	self.ui:addChild(wechatLocator)

	------------------------------
	-- Move Show Tip Layer To Top
	-- --------------------------
	showTipLayer:removeFromParentAndCleanup(false)
	self.ui:addChild(showTipLayer)
end

function InviteFriendRewardPanel:getVCenterInParentY(...)
	assert(#{...} == 0)

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
	assert(parent)
	local posInParent	= parent:convertToNodeSpace(ccp(0, vCenterInScreenY))

	return posInParent.y
end

function InviteFriendRewardPanel:onWdjBtnTapped(event)
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

function InviteFriendRewardPanel:onCloseBtnTapped(event, ...)
	assert(#{...} == 0)
	print("InviteFriendRewardPanel:onCloseBtnTapped")
	self.allowBackKeyTap = false
	self:remove()
end

function InviteFriendRewardPanel:onRuleBtnTapped(event, ...)
	assert(#{...} == 0)

	self:setVisible(false)

	local inviteRulePanel = InviteRulePanel:create()
	inviteRulePanel:popout()
end

function InviteFriendRewardPanel:onFBInviteBtnTapped(event)
	if not SnsProxy:isLogin() then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.facebook.login"), "negative",nil,2)
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

function InviteFriendRewardPanel:onInviteButtonTapped( event, shareType )
	assert(type(shareType) == "number")
	--self:changeToShareToWeiboPanel()
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
	end

	local invited = CCUserDefault:sharedUserDefault():getBoolForKey("game.invite.friend.wechat.tutor")
	if shareType == PlatformShareEnum.kWechat and not invited then
		local function onClose() self.weChatBtn:setEnabled(true) end
		local panel = WeChatPanel:create(doShareInvitation, onClose)
		if panel then panel:popout() end
	else
		doShareInvitation()
	end
end

function InviteFriendRewardPanel:popout(...)
	assert(#{...} == 0)

	local function onPopouted()

		-- Check If User Is <= 30 Level,
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
					local enterInviteCodePanel	= EnterInviteCodePanel:create()
					enterInviteCodePanel:popout()
				end
			end
		end
		self.allowBackKeyTap = true
	end

	PopoutManager:sharedInstance():addWithBgFadeIn(self, true, false, false)
	self.showHideAnim:playShowAnim(onPopouted)
end

function InviteFriendRewardPanel:setToScreenCenterVertical(...)
	assert(#{...} == 0)

	-- Get V Center In Screen Y
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfHeight	= self:getGroupBounds().size.height
	-- local selfHeight	= 985

	local deltaHeight	= visibleSize.height - selfHeight
	local halfDeltaHeight	= deltaHeight / 2

	local vCenterInScreenY	= visibleOrigin.y + halfDeltaHeight + selfHeight

	-- Get Vertical Center In Parent Y
	local parent		= self:getParent()
	assert(parent)
	local posInParent	= parent:convertToNodeSpace(ccp(0, vCenterInScreenY))

	-- Set Position Y
	-- self:setPositionY(posInParent.y)
	self:setPositionForPopoutManager()
end

function InviteFriendRewardPanel:remove(...)
	assert(#{...} == 0)

	local function onPanelHideAnimFinishFunc()
		--PopoutManager:sharedInstance():remove(self, true)
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
	end

	self.showHideAnim:playHideAnim(onPanelHideAnimFinishFunc)
end

function InviteFriendRewardPanel:onEnterHandler(event, ...)
	assert(event)
	assert(#{...} == 0)

	if event == "enter" then
		self:updateEachFriendItem()

	elseif event == "exit" then

	end
end

function InviteFriendRewardPanel:updateEachFriendItem(...)
	assert(#{...} == 0)

	local function onSendGetInviteFriendMsgSuccess(data)

		print("InviteFriendRewardPanel:updateEachFriendItem Called !")
		-- print(table.tostring(data))
		--debug.debug()

		-- -------------------------------
		-- Extrace The Invited Friend Ids
		-- --------------------------------
		local friendIds = {}

		for k,v in pairs(data) do
			if tonumber(v.friendUid) == 0 then

			else
				table.insert(friendIds, tonumber(v.friendUid))
			end
		end

		if #friendIds > 0 and not self.isDisposed then
			if #friendIds < kMaxRewardFriend then
				self.topTxt:setString(Localization:getInstance():getText('invite.friend.panel.text.top.current', 
																{invited = #friendIds, free = kMaxRewardFriend - #friendIds}))
			elseif #friendIds == kMaxRewardFriend then
				self.topTxt:setString('')
			end
		end
		if not self.isDisposed then self.topTxt:setVisible(true) end
		-- print("friend ids: ")
		-- print(table.tostring(friendIds))

		---------------------------------------------
		-- Send Friend Http Use Invited Friends UID
		-- ----------------------------------------

		local function onSendFriendHttpSuccess()

			print("onSendFriendHttpSuccess Called !")

			if not self.updateEachFriendItemIsCalled then
				self.updateEachFriendItemIsCalled = true
				
				local data = UserManager:getInstance().inviteFriendsInfo
				self.invitedFriendItemRender:updateInvitedFriendItems(data, false)
			else
				--self.invitedFriendItemRender:updateInvitedFriendItems(data, true)
				self.invitedFriendItemRender:updateInvitedFriendItems(data, false)
			end
		end

		local function onSendFriendHttpFailed()
			-- Do Nothing
			print("onSendFriendHttpFailed !! ")
		end
		onSendFriendHttpSuccess()
		-- self:sendFriendHttp(friendIds, onSendFriendHttpSuccess, onSendFriendHttpFailed)
	end

	self:sendGetInviteFriendsInfoMsg(onSendGetInviteFriendMsgSuccess)
end

function InviteFriendRewardPanel:sendFriendHttp(friendIds, onSuccessCallback, onFailedCallback, ...)
	assert(friendIds)
	assert(false == onSuccessCallback or type(onSuccessCallback) == "function")
	assert(false == onFailedCallback or type(onFailedCallback) == "function")
	assert(#{...} == 0)

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

	--local http = StartLevelHttp.new()
	local http = FriendHttp.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	
	http:load(true, friendIds)
end

function InviteFriendRewardPanel:sendGetInviteFriendsInfoMsg(onSuccessCallback, ...)
	assert(type(onSuccessCallback) == "function")
	assert(#{...} == 0)

	local function onSuccess(event)
		assert(event)
		assert(event.data)

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
		assert(event)
		assert(event.name == Events.kError)

		local err = event.data

		--local errorMessage = "get invite friend info failed !"
		--errorMessage = "errorMessage:" .. tostring(err)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..err), "negative")
		--assert(false, errorMessage)
	end

	local http = GetInviteFriendsInfo.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFailed)
	http:load()
end

function InviteFriendRewardPanel:reBecomeTopPanel(...)
	assert(#{...} == 0)

	self:setVisible(true)
end

function InviteFriendRewardPanel:create(scaleOriginPosInWorldSpace, ...)
	assert(scaleOriginPosInWorldSpace)
	assert(#{...} == 0)

	local newInviteFriendRewardPanel = InviteFriendRewardPanel.new()
	newInviteFriendRewardPanel:loadRequiredResource(PanelConfigFiles.invite_friend_reward_panel)
	newInviteFriendRewardPanel:init(scaleOriginPosInWorldSpace)
	return newInviteFriendRewardPanel
end

function InviteFriendRewardPanel:dispose()
	self.invitedFriendItemRender:dispose()
	BasePanel.dispose(self)
end

function InviteFriendRewardPanel:getHCenterInParentX(...)
	assert(#{...} == 0)

	-- Vertical Center In Screen Y
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	-- local selfHeight	= self:getGroupBounds().size.height
	local selfWidth = 670

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	local vCenterInScreenX	= visibleOrigin.x + halfDeltaWidth

	-- Vertical Center In Parent Y
	local parent 		= self:getParent()
	local posInParent	= parent:convertToNodeSpace(ccp(vCenterInScreenX, 0))

	return posInParent.x
end
