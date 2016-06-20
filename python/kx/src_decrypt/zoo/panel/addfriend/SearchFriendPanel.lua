local SearchFriendPanel = class(BasePanel)

function SearchFriendPanel:create()
	local panel = SearchFriendPanel.new()
	panel:loadRequiredResource("ui/add_friend_panel.json")
	panel:init()

	return panel
end

function SearchFriendPanel:init()
	self.ui = self:buildInterfaceGroup("SearchFriendPanel")
    BasePanel.init(self, self.ui)

    --PlatformConfig.name = PlatformNameEnum.kWDJ
    self.addFriendPanelLogic = AddFriendPanelLogic:create()

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(282, 64)
    self.title:setString(localize("add.friend.panel.input.placeholder"))

    self:initCloseButton()
    self:initContent()
end

function SearchFriendPanel:initContent()
	self:_tabSearch_init(self.ui:getChildByName("content"))
end

------------------------------------------
-- TabSearch
------------------------------------------
function SearchFriendPanel:_tabSearch_init(ui)
	-- get & create controls
	self.tabSearch = {}
	self.tabSearch.ui = ui
	self.tabSearch.btnAdd = ui:getChildByName("btn_add")
	self.tabSearch.btnAdd = GroupButtonBase:create(self.tabSearch.btnAdd)
	self.tabSearch.bgResultBG = ui:getChildByName("bg_resultArea")
	self.tabSearch.bgResultBG:setTouchEnabled(true, 0, true)
	local bgResultIndex = ui:getChildIndex(self.tabSearch.bgResultBG)

	self.tabSearch.userName = ui:getChildByName("lbl_userName")
	self.tabSearch.userLevel = ui:getChildByName("lbl_userLevel")
	self.tabSearch.userImg = ui:getChildByName("img_userImg")
	self.tabSearch.noUserImg = ui:getChildByName("img_noUser")
	self.tabSearch.noUserText = ui:getChildByName("lbl_noUser")
	-- self.tabSearch.inputText = ui:getChildByName("lbl_input")
	self.tabSearch.input = ui:getChildByName("ipt_input")
	self.tabSearch.input.focused = self.tabSearch.input:getChildByName("focused")
	self.tabSearch.input.text = self.tabSearch.input:getChildByName("text")
	self.tabSearch.input.btnLoad = self.tabSearch.input:getChildByName("btnLoad")
	self.tabSearch.input.btnCancel = self.tabSearch.input:getChildByName("btnCancel")
	self.tabSearch.inviteText = ui:getChildByName("lbl_share")
	self.tabSearch.inviteCode = ui:getChildByName("lbl_code")
	self.tabSearch.inviteCodeUnderline = ui:getChildByName("img_code")
	self.tabSearch.inviteBtn = ui:getChildByName("btn_share")
	self.tabSearch.inviteBtn = ButtonIconsetBase:create(self.tabSearch.inviteBtn)
	self.tabSearch.inviteBtn:setColorMode(kGroupButtonColorMode.blue)
	
	local icon = nil
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		icon = ui:getChildByName("icn_mitalk")
		ui:getChildByName("icn_wechat"):setVisible(false)
	else
		icon = ui:getChildByName("icn_wechat")
		ui:getChildByName("icn_mitalk"):setVisible(false)
	end

	self.tabSearch.wdjBtn = GroupButtonBase:create(self.tabSearch.ui:getChildByName('btn_wdj'))
	local wdjLocator = self.tabSearch.ui:getChildByName('ver.WDJ_WdjBtnLocator')
	local wechatLocator = self.tabSearch.ui:getChildByName('ver.WDJ_WechatBtnLocator')

	-- set strings
  
  local tmpstr = Localization:getInstance():getText("add.friend.panel.input.tip")
  if __WP8 then tmpstr = tmpstr:gsub("•", "●") end
	-- self.tabSearch.inputText:setString(tmpstr)
  
	self.tabSearch.input.text:setString("")
	self.tabSearch.noUserText:setString(Localization:getInstance():getText("add.friend.panel.no.user.text"))
	self.tabSearch.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))
	self.tabSearch.userLevel:setString(Localization:getInstance():getText("add.friend.panel.no.user.level"))
	self.tabSearch.btnAdd:setString(Localization:getInstance():getText("add.friend.panel.btn.add.text"))
  
	tmpstr = Localization:getInstance():getText("add.friend.panel.code.desc")
	if __WP8 then tmpstr = tmpstr:gsub("•", "●") end
	self.tabSearch.inviteText:setString(tmpstr)
  
	self.tabSearch.inviteBtn:setString(Localization:getInstance():getText("invite.friend.panel.invite.button"))
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		self.tabSearch.inviteBtn:setString(localize("invite.friend.panel.button.text.mitalk"))
	end

	-- set status
	local code = tostring(AddFriendPanelModel:getUserInviteCode())
	if code and string.len(code) > 0 and code ~= "nil" then
		self.tabSearch.inviteCode:setPreferredSize(331, 65)
		self.tabSearch.inviteCode:setString(code)
		local tSize = self.tabSearch.inviteCode:getContentSize()
		local lSize = self.tabSearch.inviteCodeUnderline:getContentSize()
		self.tabSearch.inviteCodeUnderline:setScale(tSize.width / lSize.width)
		self.tabSearch.inviteCodeUnderline:setPositionX(self.tabSearch.inviteCode:getPositionX())
		self.tabSearch.inviteCodeUnderline:setPositionY(self.tabSearch.inviteCode:getPositionY() - tSize.height + 10)
		self.tabSearch.copyCodeLayer = LayerColor:create()
		self.tabSearch.copyCodeLayer:changeWidthAndHeight(tSize.width + 40, tSize.height + 40)
		self.tabSearch.copyCodeLayer:setOpacity(0)
		self.tabSearch.copyCodeLayer:setPositionX(self.tabSearch.inviteCode:getPositionX() - 20)
		self.tabSearch.copyCodeLayer:setPositionY(self.tabSearch.inviteCode:getPositionY() - tSize.height - 20)
		self.tabSearch.ui:addChildAt(self.tabSearch.copyCodeLayer, bgResultIndex - 1)
	else
		self.tabSearch.inviteText:setVisible(false)
		self.tabSearch.inviteCode:setVisible(false)
		self.tabSearch.inviteCodeUnderline:setVisible(false)
	end
	self.tabSearch.input.btnCancel:setVisible(false)
	self.tabSearch.input.focused:setVisible(false)
	local pos = self.tabSearch.input.btnLoad:getPosition()
	local size = self.tabSearch.input.btnLoad:getGroupBounds().size
	self.tabSearch.input.btnLoad:setAnchorPoint(ccp(0.5, 0.5))
	self.tabSearch.input.btnLoad:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
	self.tabSearch.input.btnLoad:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
	self.tabSearch.userImg:setVisible(false)
	icon:removeFromParentAndCleanup(false)
	self.tabSearch.inviteBtn:setIcon(icon, false)
	if PlatformConfig:isJJPlatform() then
		self.tabSearch.inviteBtn:setVisible(false) 
		self.tabSearch.wdjBtn:removeFromParentAndCleanup(true)
	elseif PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) or PlatformConfig:isPlatform(PlatformNameEnum.k360) then
		self.tabSearch.wdjBtn:setPosition(ccp(wdjLocator:getPositionX(), wdjLocator:getPositionY()))
		self.tabSearch.inviteBtn:setPosition(ccp(wechatLocator:getPositionX(), wechatLocator:getPositionY()))
	else
	 	self.tabSearch.wdjBtn:removeFromParentAndCleanup(true) 
	end

	if PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) then
		self.tabSearch.wdjBtn:setString(localize("invite.friend.panel.button.text.wdj"))
	end

	if PlatformConfig:isPlatform(PlatformNameEnum.k360) then
		self.tabSearch.wdjBtn:setString(localize("invite.friend.panel.button.text.360"))
	end

	wdjLocator:removeFromParentAndCleanup(true)
	wechatLocator:removeFromParentAndCleanup(true)

	-- create software keyboard
	local function onChangeCallback(content, length)
		if length > 0 then
			self.tabSearch.input.text:setVisible(true)
			-- self.tabSearch.input.btnCancel:setVisible(true)
		end
	end
	local function onEnterCallback(content, length)
		self.tabSearch.input.focused:setVisible(false)
		self.tabSearch.softKeyboard:cancel(false)
		print("onEnterCallback!!!!!!!!!!!!!!!!!!!!!!!!!")
		if length > 0 then
			self.tabSearch.input.btnCancel:setVisible(true)
			if RequireNetworkAlert:popout() then
				print("RequireNetworkAlert:popout!!!!!!!!!!!!!!!!!!!!!!!!!")
				self:_tabSearch_searchFriend(content, length)
			end
		end
	end
	local function onEmptyCallback()
		self.tabSearch.input.text:setVisible(false)
		self.tabSearch.input.btnCancel:setVisible(false)
	end
	local function onOutsideCallback(content, length)
		print("onOutsideCallback!!!!!!!!!!!!!!!!!!!!!!!!!")
		if length > 0 then
			onEnterCallback(content, length)
		else
			self.tabSearch.softKeyboard:cancel()
			self.tabSearch.input.focused:setVisible(false)
		end
	end
	local config = {
		max = 10,
		changeCallback = onChangeCallback,
		enterCallback = onEnterCallback,
		emptyCallback = onEmptyCallback,
		outsideCallback = onOutsideCallback,
	}
	self.tabSearch.softKeyboard = SoftwareKeyboardInput:create(self.tabSearch.input.text, config)

	-- add event listeners
	local function showGameID()
		self.tabSearch.inviteText:setVisible(true)
		self.tabSearch.inviteCode:setVisible(true)
		self.tabSearch.inviteCodeUnderline:setVisible(true)
		self.tabSearch.inviteBtn:setVisible(not PlatformConfig:isJJPlatform())
		if self.tabSearch.copyCodeLayer then self.tabSearch.copyCodeLayer:setVisible(true) end
	end

	local function onInputTapped()
		self.tabSearch.input.focused:setVisible(true)
		self.tabSearch.softKeyboard:start(self, ccp(0, -600))
		self.tabSearch.input.btnCancel:setVisible(false)
		self:_tabSearch_removeSearchResult()
		showGameID()
		print("onInputTapped!!!!!!!!!!!!!!")
	end
	
	self.tabSearch.input:setTouchEnabled(true)
	self.tabSearch.input:addEventListener(DisplayEvents.kTouchTap, onInputTapped)

	local function onInputCancelTapped()
		showGameID()

		self.tabSearch.input.focused:setVisible(false)
		self.tabSearch.softKeyboard:cancel(true)
		self:_tabSearch_removeSearchResult()
		self.tabSearch.input.btnCancel:setVisible(false)
	end

	self.tabSearch.input.btnCancel:setTouchEnabled(true, 0, true)
	self.tabSearch.input.btnCancel:addEventListener(DisplayEvents.kTouchTap, onInputCancelTapped)

	local function onBtnAddTapped()
		if RequireNetworkAlert:popout() then
			self:_tabSearch_addFriend()
		end
	end
	self.tabSearch.btnAdd:addEventListener(DisplayEvents.kTouchTap, onBtnAddTapped)

	local function shareInviteCode()
		local function restoreBtn()
			if self.tabSearch.ui.isDisposed then return end
			if not self.tabSearch.ui:isVisible() then return end
			if self.tabSearch.inviteBtn.isDisposed then return end
			self.tabSearch.inviteBtn:setEnabled(true)
		end

		if __IOS_FB then
			SnsProxy:inviteFriends(nil)
		else
			local ipt = {
				onSuccess = restoreBtn,
				onError = restoreBtn,
				onCancel = restoreBtn,
			}
			self.tabSearch.inviteBtn:setEnabled(false)
			setTimeOut(restoreBtn, 2)
			if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
				SnsUtil.sendInviteMessage( PlatformShareEnum.kMiTalk, ipt )
			else
				SnsUtil.sendInviteMessage( PlatformShareEnum.kWechat, ipt )
			end
		end
	end
	self.tabSearch.inviteBtn:addEventListener(DisplayEvents.kTouchTap, shareInviteCode)

	local function onWdjBtnTapped()
		self:onWdjBtnTapped()
	end
	if self.tabSearch.wdjBtn and not self.tabSearch.wdjBtn.isDisposed then
		self.tabSearch.wdjBtn:addEventListener(DisplayEvents.kTouchTap, onWdjBtnTapped)
	end

	local function onCopyInviteCode()
		ClipBoardUtil.copyText(tostring(code))
		CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.copy.code.tip"), "positive")
	end
	if self.tabSearch.copyCodeLayer then
		self.tabSearch.copyCodeLayer:setTouchEnabled(true, 0, true)
		self.tabSearch.copyCodeLayer:addEventListener(DisplayEvents.kTouchTap, onCopyInviteCode)
	end

	-- clear panel
	self:_tabSearch_removeSearchResult()

	-- block click while not in front
	self.tabSearch.hide = function()
		self.tabSearch.ui:setVisible(false)
		self.tabSearch.input:setTouchEnabled(false)
		self.tabSearch.input.btnCancel:setTouchEnabled(false)
		self.tabSearch.btnAdd:setEnabled(false)
		self.tabSearch.inviteBtn:setEnabled(false)
		self.tabSearch.wdjBtn:setEnabled(false)
		if self.tabSearch.copyCodeLayer then self.tabSearch.copyCodeLayer:setTouchEnabled(false) end
	end
	self.tabSearch.expand = function()
		self.tabSearch.input:setTouchEnabled(true)
		self.tabSearch.input.btnCancel:setTouchEnabled(true, 0, true)
		self.tabSearch.btnAdd:setEnabled(true)
		self.tabSearch.inviteBtn:setEnabled(true)
		self.tabSearch.wdjBtn:setEnabled(true)
		if self.tabSearch.copyCodeLayer then self.tabSearch.copyCodeLayer:setTouchEnabled(true) end
		self.tabSearch.ui:setVisible(true)
	end
end

function SearchFriendPanel:hideGameID()
	self.tabSearch.inviteText:setVisible(false)
	self.tabSearch.inviteCode:setVisible(false)
	self.tabSearch.inviteCodeUnderline:setVisible(false)
	if self.tabSearch.copyCodeLayer then self.tabSearch.copyCodeLayer:setVisible(false) end
end

function SearchFriendPanel:_tabSearch_searchFriend(code, length)
	print("_tabSearch_searchFriend called!!!!!!!!!!!!!!")
	self.tabSearch.bgResultBG:setVisible(true)
	self.tabSearch.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))
	self.tabSearch.userLevel:setString(Localization:getInstance():getText("add.friend.panel.no.user.level"))
	self.tabSearch.userImg:setVisible(false)
	self.tabSearch.userName:setVisible(true)
	self.tabSearch.userLevel:setVisible(true)
	self.tabSearch.input.btnCancel:setVisible(false)
	self.tabSearch.input.btnLoad:setVisible(true)
	self.tabSearch.inviteBtn:setVisible(false)
	local noUserTextStr = ""

	local function fakeLoadEnd()
		self:hideGameID()
		self.tabSearch.userName:setVisible(false)
		self.tabSearch.userLevel:setVisible(false)
		self.tabSearch.userImg:setVisible(false)
		if self.tabSearch.userHead then self.tabSearch.userHead:removeFromParentAndCleanup(true) end
		self.tabSearch.noUserImg:setVisible(true)
		self.tabSearch.noUserText:setString(noUserTextStr)
		self.tabSearch.input.btnLoad:setVisible(false)
		self.tabSearch.input.btnCancel:setVisible(true)
		self.tabSearch.inviteBtn:setVisible(not PlatformConfig:isJJPlatform())
	end
	if length < 9 then
		noUserTextStr = Localization:getInstance():getText("add.friend.panel.no.user.text")
		self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(fakeLoadEnd)))
	elseif not UserManager:getInstance():isSameInviteCodePlatform(code) then 
		CommonTip:showTip(Localization:getInstance():getText("error.tip.add.friends"), "negative", nil, 3 )
		noUserTextStr = Localization:getInstance():getText("add.friend.panel.find.other.text")
		self:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(fakeLoadEnd)))
	else
		self:_tabSearch_doSearchFriend(code)
	end
end

function SearchFriendPanel:_tabSearch_doSearchFriend(code)

	local function onSuccess(data, context)
		if self.isDisposed  then return end
		self:hideGameID()
		self.userInviteCode = code
		self:_tabSearch_updateFriendInfo(data)
		self.tabSearch.inviteBtn:setVisible(not PlatformConfig:isJJPlatform())
		print("_tabSearch_doSearchFriend success!!!!!!")
	end
	local function onFail(err, context)
		if self.isDisposed then return end
		self:hideGameID()
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
		self:_tabSearch_updateFriendInfo()
		self.tabSearch.inviteBtn:setVisible(not PlatformConfig:isJJPlatform())
		print("_tabSearch_doSearchFriend failed!!!!!!")
	end
	local function onCancel(context)
		if self.isDisposed then return end
		self:_tabSearch_updateFriendInfo()
		self.tabSearch.inviteBtn:setVisible(not PlatformConfig:isJJPlatform())
	end
	self.addFriendPanelLogic:searchUser(code, onSuccess, onFail, onCancel, self.tabStatus)
end

function SearchFriendPanel:_tabSearch_updateFriendInfo(dataTable)
	if self.tabSearch.isDisposed then return end

	self.tabSearch.input.btnLoad:setVisible(false)
	self.tabSearch.input.btnCancel:setVisible(true)

	if dataTable then
		if #dataTable > 0 then
			local data = dataTable[1]
			if data.userLevel then
				self.tabSearch.userLevel:setString(Localization:getInstance():getText("add.friend.panel.user.info.level", {n = data.userLevel}))
			end
			self.tabSearch.userHead = HeadImageLoader:create(data.uid, data.headUrl)
			if self.tabSearch.userHead then
				local position = self.tabSearch.userImg:getPosition()
				self.tabSearch.userHead:setAnchorPoint(ccp(-0.5, 0.5))
				self.tabSearch.userHead:setPosition(ccp(position.x, position.y))
				self.tabSearch.userImg:getParent():addChild(self.tabSearch.userHead)
				self.tabSearch.userImg:setVisible(false)
			else
				self.tabSearch.userImg:setVisible(false)
			end
			local userName = HeDisplayUtil:urlDecode(data.userName or "")
			if userName and string.len(userName) > 0 then self.tabSearch.userName:setString(userName) end
			
			self.tabSearch.userName:setVisible(true)
			self.tabSearch.userLevel:setVisible(true)
			self.tabSearch.btnAdd:setVisible(true)
		else
			self.tabSearch.userImg:setVisible(false)
			self.tabSearch.userName:setVisible(false)
			self.tabSearch.userLevel:setVisible(false)
			self.tabSearch.noUserImg:setVisible(true)
			self.tabSearch.noUserText:setString(Localization:getInstance():getText("add.friend.panel.no.user.text"))
		end
	else
		self.tabSearch.bgResultBG:setVisible(false)
		self.tabSearch.userImg:setVisible(false)
		self.tabSearch.userName:setVisible(false)
		self.tabSearch.userLevel:setVisible(false)
		self.tabSearch.noUserImg:setVisible(false)
		self.tabSearch.noUserText:setString("")
	end
end

function SearchFriendPanel:_tabSearch_removeSearchResult()
	self.tabSearch.input.btnLoad:setVisible(false)
	self.tabSearch.noUserImg:setVisible(false)
	self.tabSearch.noUserText:setString("")
	self.tabSearch.userImg:setVisible(false)
	if self.tabSearch.userHead then self.tabSearch.userHead:removeFromParentAndCleanup(true) end
	self.tabSearch.userName:setVisible(false)
	self.tabSearch.userLevel:setVisible(false)
	self.tabSearch.bgResultBG:setVisible(false)
	self.tabSearch.btnAdd:setVisible(false)
end

function SearchFriendPanel:_tabSearch_addFriend()
	local function onSuccess(data, context)
		if self.isDisposed then return end
		DcUtil:sendInviteRequest(self.userInviteCode)
		CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.add.success"), "positive")
		self.tabSearch.softKeyboard:cleanText()
		self.tabSearch.btnAdd:setVisible(false)
	end
	local function onFail(err, context)
		if self.isDisposed then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	self.addFriendPanelLogic:sendAddMessage(nil, onSuccess, onFail, nil, self.tabStatus)
end

function SearchFriendPanel:onWdjBtnTapped(event)
	if PlatformConfig:isPlatform(PlatformNameEnum.kWDJ) then
		print('wdj===AddFriendPanel:onWdjBtnTapped')
	elseif PlatformConfig:isPlatform(PlatformNameEnum.k360) then
		print('360===AddFriendPanel:onWdjBtnTapped')
		if not SnsProxy:isLogin() then 
			CommonTip:showTip(Localization:getInstance():getText("该功能需要360账号联网登录"), "positive")
			return 
		end
	else
		return
	end

	local function onSuccess(data)
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

function SearchFriendPanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
end

function SearchFriendPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function SearchFriendPanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

end

function SearchFriendPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function SearchFriendPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

return SearchFriendPanel