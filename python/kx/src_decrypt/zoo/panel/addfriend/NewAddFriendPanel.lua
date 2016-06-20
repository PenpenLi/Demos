local NewAddFriendPanel = class(BasePanel)
local IconAddFriend = require("zoo.panel.addfriend.IconAddFriend")

function NewAddFriendPanel:create()
	local function onButton1Click()
		local panel = NewAddFriendPanel.new()
		panel:loadRequiredResource("ui/add_friend_panel.json")
		panel:init()
		panel:popout()
	end

	CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,NotRemindFlag.GPS_ALLOW,Localization:getInstance():getText("pre.tips.locate"))
end

local iconInitPos = {}
local allIcons = {"icon_qq", "icon_code", "icon_shake2", "icon_phone2", "icon_qq2", "icon_shake", "icon_phone", "icon_qq3"}

local function getIconPos()
	local iconsPos = {}
	for i,v in ipairs(iconInitPos) do
		table.insert(iconsPos, ccp(v.x, v.y))
	end

	return iconsPos
end

function NewAddFriendPanel:init()
	self.ui = self:buildInterfaceGroup("AddFriendPanel")
    BasePanel.init(self, self.ui)

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(264, 73)
    self.title:setString(localize("add.friend.panel.title"))

    self:initCloseButton()

    self:initTabIcons()
    self:alignAddFriendIcons()

    self:initAddOtherTab()
end

function NewAddFriendPanel:loadFriendsByContact()
	if self.isDisposed or self.isRequestingPhoneFriends then
		return
	end
	local loadFriendsLogic = require("zoo.panel.addfriend.LoadFriendsLogic"):create()

	local function onLoadSuccess(items4Show, remainingUids)
		if #items4Show == 0 then
			CommonTip:showTip(localize("add.friend.panel.add.phone.tip1"), "negative",nil, 2)
		else
			local panel = require("zoo.panel.addfriend.ChoosePhoneUserPanel"):create(items4Show)
			panel:popout()
		end

		self.isRequestingPhoneFriends = false
	end

	local function isNetworkError(errorCode)
		return errorCode == -2 or errorCode == -6 or errorCode == -7
	end

	local function onLoadError(errCode)
		if errCode == 600 then
			CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.add.qq.tip6"), "negative", nil, 3)
		elseif errCode == 200 then
			--require network, nothing to do;
			CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips"))
		elseif errCode == 100 then
			CommonTip:showTip("读取联系人信息失败！", "negative",nil, 2)
		elseif isNetworkError(errCode) then
			CommonTip:showTip(localize("dis.connect.warning.tips"), "negative",nil, 2)
		else
			CommonTip:showTip("无法获取您的手机好友的信息！", "negative",nil, 2)
		end
		self.isRequestingPhoneFriends = false
	end

	local function onloadCancel()
		self.isRequestingPhoneFriends = false
	end

	self.isRequestingPhoneFriends = true
	loadFriendsLogic:loadFriendsInContacts(onLoadSuccess, onLoadError, onloadCancel)
end

function NewAddFriendPanel:initTabIcons()

	local function openShake()
		local panel = require("zoo.panel.addfriend.NFCFriendPanel"):create()
		panel:popout()
	end

	local function openPhone()
		-- if FriendManager.getInstance():isFriendCountReachedMax() then
		-- 	CommonTip:showTip(localize("add.friend.panel.add.qq.tip1", "positive", nil, 2))
		-- 	return
		-- end
		 
		if UserManager.getInstance().profile:isPhoneBound() then
			print("goto get the phone's contact list!!!!!!!!!!!")
			self:loadFriendsByContact()
		else
			print("goto bind phone number!!!!!!!!!!!!")
			AccountBindingLogic:bindNewPhone(	nil, 
												function() 
													self:loadFriendsByContact() 
												end, 
												AccountBindingSource.ADD_FRIEND
											)
		end
	end

	self.ui:getChildByName("tab_real"):getChildByName("title"):setString(localize("add.friend.panel.tab1"))

	self.iconShake = self.ui:getChildByName("icon_shake")
	self.iconShake2 = self.ui:getChildByName("icon_shake2")
	self.iconShake:getChildByName("text"):setString(localize("add.friend.panel.tag.shake"))
	self.iconShake2:getChildByName("text"):setString(localize("add.friend.panel.tag.shake"))

	self.iconShakeWrapper = IconAddFriend:create(self.iconShake, openShake)
	self.iconShakeWrapper2 = IconAddFriend:create(self.iconShake2, openShake, IconAnimationType.kTypeScale)

	self.iconQRCode = self.ui:getChildByName("icon_code")
	self.iconQRCode:getChildByName("text"):setString(localize("add.friend.panel.add.qrcode"))
	--self.iconQRCode:setTouchEnabled(true, 0, true)

	self.iconQRCodeWrapper = IconAddFriend:create(self.iconQRCode, function()
				local panel = require("zoo.panel.addfriend.QRCodeFriendPanel"):create()
				panel:popout()
		end)

	--QQ syncFriend start--
	local numberOfFriendsBeforeSync = FriendManager.getInstance():getFriendCount()
	print("numberOfFriendsBeforeSync: "..tostring(numberOfFriendsBeforeSync))

	local function onSyncQQFriendSuccess()
		if self.isDisposed then
			return
		end
		
		local newAddedSnsFriends = FriendManager.getInstance():getNewAddedSnsFriendIds()
		if numberOfFriendsBeforeSync >= 200 then
			newAddedSnsFriends = {}
		end
		print("newAddedSnsFriends: "..table.serialize(newAddedSnsFriends))
		DcUtil:UserTrack({ category='add_friend', sub_category="add_qq", friend_id = table.serialize(newAddedSnsFriends)}, true)
		HomeScene:sharedInstance():updateFriends()
		self:alignAddFriendIcons()
		GlobalEventDispatcher:getInstance():removeEventListener(SyncSnsFriendEvents.kSyncSuccess, onSyncQQFriendSuccess)

		local numberOfFriendsAfterSync = FriendManager.getInstance():getFriendCount()
		print("numberOfFriendsAfterSync: "..tostring(numberOfFriendsAfterSync))
		local newSyncFriendsNumber = numberOfFriendsAfterSync - numberOfFriendsBeforeSync

		if numberOfFriendsAfterSync == 0 then
			CommonTip:showTip(localize("add.friend.panel.add.qq.tip4"), "positive", nil, 2)
			return
		end

		if numberOfFriendsBeforeSync >= 200 then
			CommonTip:showTip(localize("add.friend.panel.add.qq.tip1", {num = numberOfFriendsAfterSync}), "positive", nil, 2)
			return
		end

		if numberOfFriendsAfterSync >= 200 then
			CommonTip:showTip(localize("add.friend.panel.add.qq.tip3", {num = numberOfFriendsAfterSync}), "positive", nil, 2)
		else
			CommonTip:showTip(localize("add.friend.panel.add.qq.tip2", {num = numberOfFriendsAfterSync}), "positive", nil, 2)
		end
	end

	local function onSyncQQFriendFailed()
		CommonTip:showTip("同步QQ好友失败！", "negative",nil, 2)
		GlobalEventDispatcher:getInstance():removeEventListener(SyncSnsFriendEvents.kSyncFailed, onSyncQQFriendFailed)
	end

	local function addSyncFriendsListeners()
		if self.isDisposed then
			return
		end
		GlobalEventDispatcher:getInstance():addEventListener(SyncSnsFriendEvents.kSyncSuccess, onSyncQQFriendSuccess)
		GlobalEventDispatcher:getInstance():addEventListener(SyncSnsFriendEvents.kSyncFailed, onSyncQQFriendFailed)
	end

	self.iconQQ = self.ui:getChildByName("icon_qq")
	self.iconQQ2 = self.ui:getChildByName("icon_qq2")
	self.iconQQ3 = self.ui:getChildByName("icon_qq3")

	self.iconQQWrapper = IconAddFriend:create(self.iconQQ , function()
			local function onError()
			end

			local function onCancel()
			end
			
			friends = FriendManager.getInstance().friends
			if UserManager.getInstance().profile:isQQBound() then --goto login with QQ account.
				--AccountBindingLogic:bindNewSns(PlatformAuthEnum.kQQ, bindQQSuccess, nil, nil, AccountBindingSource.ADD_FRIEND)
				local syncFriendLogic = require("zoo.panel.addfriend.SyncQQFriendsLogic")
				syncFriendLogic:syncQQFriends(nil, onError, onCancel)
				addSyncFriendsListeners()
			else --goto bind new QQ account
				AccountBindingLogic:bindNewSns(PlatformAuthEnum.kQQ, addSyncFriendsListeners, onError, onCancel, AccountBindingSource.ADD_FRIEND)
			end

			DcUtil:UserTrack({ category='add_friend', sub_category="add_qq_click"}, true)
		end)

	self.iconQQWrapper2 = IconAddFriend:create(self.iconQQ2, function()
				CommonTip:showTip(localize("add.friend.panel.add.qq.tip5"), "negative",nil, 2)
		end)

	self.iconQQWrapper3 = IconAddFriend:create(self.iconQQ3, function()
				CommonTip:showTip(localize("add.friend.panel.add.qq.tip5"), "negative",nil, 2)
		end)

	self.iconQQ:getChildByName("text"):setString(localize("add.friend.panel.add.qq"))
	self.iconQQ2:getChildByName("text"):setString(localize("add.friend.panel.add.qq.success"))
	self.iconQQ3:getChildByName("text"):setString(localize("add.friend.panel.add.qq.success"))
	--QQ syncFriend end--

	--Phone syncFriend start --
	self.iconPhone = self.ui:getChildByName("icon_phone")
	self.iconPhone2 = self.ui:getChildByName("icon_phone2")
	
	self.iconPhoneWrapper = IconAddFriend:create(self.iconPhone, openPhone)
	self.iconPhoneWrapper2 = IconAddFriend:create(self.iconPhone2, openPhone, IconAnimationType.kTypeScale)

	self.iconPhone:getChildByName("text"):setString(localize("add.friend.panel.add.phone"))
	self.iconPhone2:getChildByName("text"):setString(localize("add.friend.panel.add.phone"))
	--Phone syncFriend end--

	for i = 1,5 do
		local child = self.ui:getChildByName(allIcons[i])
		local pos = ccp(child:getPositionX(), child:getPositionY())
		table.insert(iconInitPos, pos)
	end
end

function NewAddFriendPanel:alignAddFriendIcons()
	print("isQQLogin: "..tostring(SnsProxy:isQQLogin()))
	print("isQQFriendsSynced: "..tostring(FriendManager.getInstance():isQQFriendsSynced()))

	local showIcons = {}
	if PlatformConfig:hasAuthConfig(PlatformAuthEnum.kQQ) and
		not (SnsProxy:isQQLogin() or FriendManager.getInstance():isQQFriendsSynced()) then
		table.insert(showIcons, "icon_qq")
	end

	if not PlatformConfig:isJJPlatform() then
		table.insert(showIcons, "icon_code")
	end

	if #showIcons<2 then
		table.insert(showIcons, "icon_shake")
	else
		table.insert(showIcons, "icon_shake2")
	end
	--print("hasAuthConfig: ", PlatformConfig:hasAuthConfig(PlatformAuthEnum.kPhone),
	--	table.tostring(PlatformConfig:getAuthConfigs()))
	if PlatformConfig:hasAuthConfig(PlatformAuthEnum.kPhone) then
		if #showIcons<2 then
			table.insert(showIcons, "icon_phone")
		else
			table.insert(showIcons, "icon_phone2")
		end
	end

	if  PlatformConfig:hasAuthConfig(PlatformAuthEnum.kQQ) and
		(SnsProxy:isQQLogin() or FriendManager.getInstance():isQQFriendsSynced()) then
		
		if #showIcons == 1 then
			if not table.exist(showIcons, "icon_qq") then
				table.insert(showIcons, "icon_qq3")
			end
		else
			table.insert(showIcons, "icon_qq2")
		end
	end

	assert(#showIcons>=2 and #showIcons<5, "invalid add friend method!!!!!!!!!")

	print("showIcons: ", table.tostring(showIcons))
	for _,v in ipairs(allIcons) do
		self.ui:getChildByName(v):setVisible(table.exist(showIcons, v))
	end

	local iconPos = getIconPos()
	if #showIcons == 2 then
		iconPos[1].y = iconPos[1].y - 90
		iconPos[2].y = iconPos[2].y - 90
	end

	if #showIcons == 3 then
		iconPos[3] = iconPos[5]
	end

	for i,v in ipairs(showIcons) do
		self.ui:getChildByName(v):setPosition(iconPos[i])
	end
end

function NewAddFriendPanel:initAddOtherTab()

	local function extend()
		self.panel_other:setVisible(true)
		self.tab_other:getChildByName("bg1"):setVisible(false)
		self.tab_other:getChildByName("bg2"):setVisible(true)
		self.arrow_down:setVisible(true)
		self.arrow_up:setVisible(false)

		self.icon_add_game:setVisible(true)
		self.icon_add_search:setVisible(true)
	end

	local function fold()
		self.panel_other:setVisible(false)
		self.tab_other:getChildByName("bg1"):setVisible(true)
		self.tab_other:getChildByName("bg2"):setVisible(false)
		self.arrow_down:setVisible(false)
		self.arrow_up:setVisible(true)

		self.icon_add_game:setVisible(false)
		self.icon_add_search:setVisible(false)
	end

	self.tab_other = self.ui:getChildByName("tab_other")
	self.tab_other:getChildByName("title"):setString(localize("add.friend.panel.tab2")) --"其他方式添加")
	self.tab_other:setTouchEnabled(true, 0, true)
	self.tab_other:addEventListener(DisplayEvents.kTouchTap, 
        function()
        	if self.panel_other:isVisible() then
        		fold()
        	else
        		extend()
        	end
        end)

	self.arrow_up = self.tab_other:getChildByName("arrow_up")
	self.arrow_down = self.tab_other:getChildByName("arrow_down")
	self.panel_other = self.ui:getChildByName("other_panel")

	local function addFriendByGame()
		print("addFriendByGame!!!!!!!!!!!!!!!!!!!!!!!")
		local panel = require("zoo.panel.addfriend.SearchFriendPanel"):create()
		panel:popout()
	end

	local function addFriendBySearch()
		print("addFriendBySearch!!!!!!!!!!!!!!!!!!!!!!!")
		local panel = require("zoo.panel.addfriend.AroundFriendPanel"):create()
		panel:popout()
	end

	self.icon_add_game = self.panel_other:getChildByName("icon_game_id")
	self.icon_add_search = self.panel_other:getChildByName("icon_search_player")
	self.icon_add_game:getChildByName("text"):setString(localize("add.friend.panel.input.placeholder"))
	self.icon_add_search:getChildByName("text"):setString(localize("add.friend.panel.tag.recommend"))

	self.icon_add_game:setTouchEnabled(true, 0, true)
	self.icon_add_search:setTouchEnabled(true, 0, true)

	self.iconSearchWrapper = IconAddFriend:create(self.icon_add_search, 
			function()
				addFriendBySearch()
			end, 
			IconAnimationType.kTypeScale
	)

	self.iconGameWrapper = IconAddFriend:create(self.icon_add_game, 
			function()
				addFriendByGame()
			end,
			IconAnimationType.kTypeScale
	)

	fold()
end

function NewAddFriendPanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
end

function NewAddFriendPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function NewAddFriendPanel:popout()
	self:setScale(0.97)
	self:setPositionForPopoutManager()

	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)
end

function NewAddFriendPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function NewAddFriendPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

return NewAddFriendPanel