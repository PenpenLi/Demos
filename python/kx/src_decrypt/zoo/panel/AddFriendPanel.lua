require "zoo.panel.basePanel.BasePanel"
require "zoo.panelBusLogic.AddFriendPanelLogic"
require "hecore.ui.PopoutManager"
require "zoo.panel.component.common.SoftwareKeyboardInput"
require "zoo.net.Http"
require "zoo.panel.CommonTip"
require "zoo.panel.RequireNetworkAlert"
require "zoo.util.ClipBoardUtil"
require "zoo.panel.QRCodePanel"
require "zoo.qr.qrmanager"

AddFriendPanelTab = class(EventDispatcher)

function AddFriendPanelTab:create(ui, text)
	local obj = AddFriendPanelTab.new()
	obj:init(ui, text)
	return obj
end
function AddFriendPanelTab:init(ui, text)
	self.ui = ui
	local txt = self.ui:getChildByName("text")
	txt:setString(text)

	local function onClicked(evt)
		self:dispatchEvent(Event.new(DisplayEvents.kTouchTap, evt, self))
	end
	self.ui:addEventListener(DisplayEvents.kTouchTap, onClicked)
end
function AddFriendPanelTab:setEnabled(enabled)
	self.ui:getChildByName("arr1"):setVisible(not enabled)
	self.ui:getChildByName("arr2"):setVisible(enabled)
	self.ui:getChildByName("light"):setVisible(enabled)
	self.ui:getChildByName("dark"):setVisible(not enabled)
	self.ui:setTouchEnabled(not enabled)
end
function AddFriendPanelTab:setPositionY(value)
	if self.ui then self.ui:setPositionY(value) end
end

AddFriendPanel = class(BasePanel)

function AddFriendPanel:create(scaleOriginPosInWorldPos, popCallback)
	assert(scaleOriginPosInWorldPos)

	local function onButton1Click()
		local panel = AddFriendPanel.new()
		panel:loadRequiredResource(PanelConfigFiles.panel_with_keypad)
		if panel:_init(scaleOriginPosInWorldPos) then 
			if popCallback then 
				popCallback()
			end
			panel:popout()
			return nil
		else
			panel = nil 
			return nil 
		end
	end
	CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,NotRemindFlag.GPS_ALLOW,Localization:getInstance():getText("pre.tips.locate"));
end

function AddFriendPanel:dispose()
	self.addFriendPanelLogic:dispose()
	self.addFriendPanelLogic = nil
	if self.tabSearch.softKeyboard then
		self.tabSearch.softKeyboard:cancel(false, true)
		if not self.tabSearch.softKeyboard.isDisposed then
			self.tabSearch.softKeyboard:dispose()
		end
	end
	self.tabStatus = self.tabStatus + 1
	BasePanel.dispose(self)
end

function AddFriendPanel:_init(scaleOriginPosInWorldPos, ...)
	-- init ui
	self.ui = self:buildInterfaceGroup("AddFriendPanel")
	BasePanel.init(self, self.ui)

	-- getcontrols
	self.background = self.ui:getChildByName("_bg")
	self.closeBtn = self.ui:getChildByName("closeBtn")
	self.captain = self.ui:getChildByName("captain")
	self.btnSearch = AddFriendPanelTab:create(self.ui:getChildByName("tab_Search"),
		Localization:getInstance():getText("add.friend.panel.tag.search"))
	self.btnCode = AddFriendPanelTab:create(self.ui:getChildByName("tab_Code"),
		Localization:getInstance():getText("add.friend.panel.tag.qrcode"))
	self.btnRecommend = AddFriendPanelTab:create(self.ui:getChildByName("tab_Recommend"),
		Localization:getInstance():getText("add.friend.panel.tag.recommend"))
	self.btnShake = AddFriendPanelTab:create(self.ui:getChildByName("tab_Shake"),
		Localization:getInstance():getText("add.friend.panel.tag.shake"))
	local topPosition = self.ui:getChildByName("tab_Search"):getPositionY()
	local margin = self.ui:getChildByName("tab_Code"):getPositionY() - topPosition
	local tabShake = self.ui:getChildByName("tabShake")
	local bottomPosition = tabShake:getPositionY() - tabShake:getGroupBounds().size.height /
		self:getScaleY()

	local bgSize = self.background:getGroupBounds().size
	self.captain:setText(Localization:getInstance():getText("add.friend.panel.title"))
	local capSize = self.captain:getContentSize()
	local capScale = 65 / capSize.height
	self.captain:setScale(capScale)
	self.captain:setPositionX((bgSize.width / self:getScale() - capSize.width * capScale) / 2)

	-- add event listeners
	local function onCloseTapped()
		self:onCloseBtnTapped()
	end
	self.closeBtn:setTouchEnabled(true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:ad(DisplayEvents.kTouchTap, onCloseTapped)

	local function onBtnSearchTapped()
		self.btnSearch:setEnabled(true)
		self.btnCode:setEnabled(false)
		self.btnCode:setPositionY(bottomPosition - 3 * margin)
		self.btnRecommend:setEnabled(false)
		self.btnRecommend:setPositionY(bottomPosition - 2 * margin)
		self.btnShake:setEnabled(false)
		self.btnShake:setPositionY(bottomPosition - margin)
		self.tabSearch:expand()
		self.tabCode:hide()
		self.tabRecommend:hide()
		self.tabShake:hide()
	end
	self.btnSearch:addEventListener(DisplayEvents.kTouchTap, onBtnSearchTapped)
	local function onBtnCodeTapped()
		if not RequireNetworkAlert:popout() then return end
		self.btnSearch:setEnabled(false)
		self.btnCode:setEnabled(true)
		self.btnCode:setPositionY(topPosition + margin)
		self.btnRecommend:setEnabled(false)
		self.btnRecommend:setPositionY(bottomPosition - 2 * margin)
		self.btnShake:setEnabled(false)
		self.btnShake:setPositionY(bottomPosition - margin)
		self.tabSearch:hide()
		self.tabCode:expand()
		self.tabRecommend:hide()
		self.tabShake:hide()
	end
	self.btnCode:addEventListener(DisplayEvents.kTouchTap, onBtnCodeTapped)
	local function onBtnRecommendTapped()
		if not RequireNetworkAlert:popout() then return end
		self.btnSearch:setEnabled(false)
		self.btnCode:setEnabled(false)
		self.btnCode:setPositionY(topPosition + margin)
		self.btnRecommend:setEnabled(true)
		self.btnRecommend:setPositionY(topPosition + 2 * margin)
		self.btnShake:setEnabled(false)
		self.btnShake:setPositionY(bottomPosition - margin)
		self.tabSearch:hide()
		self.tabCode:hide()
		self.tabRecommend:expand()
		self.tabShake:hide()
	end
	self.btnRecommend:addEventListener(DisplayEvents.kTouchTap, onBtnRecommendTapped)
	local function onBtnShakeTapped()
		if not RequireNetworkAlert:popout() then return end
		self.btnSearch:setEnabled(false)
		self.btnCode:setEnabled(false)
		self.btnCode:setPositionY(topPosition + margin)
		self.btnRecommend:setEnabled(false)
		self.btnRecommend:setPositionY(topPosition + 2 * margin)
		self.btnShake:setEnabled(true)
		self.btnShake:setPositionY(topPosition + 3 * margin)
		self.tabSearch:hide()
		self.tabCode:hide()
		self.tabRecommend:hide()
		self.tabShake:expand()
	end
	self.btnShake:addEventListener(DisplayEvents.kTouchTap, onBtnShakeTapped)

	-- build logic
	self.addFriendPanelLogic = AddFriendPanelLogic:create()

	self:_tabSearch_init(self.ui:getChildByName("tabSearch"))
	self:_tabCode_init(self.ui:getChildByName("tabCode"))
	self:_tabRecommend_init(self.ui:getChildByName("tabRecommend"))
	self:_tabShake_init(self.ui:getChildByName("tabShake"))

	-- set data
	self.tabStatus = 0

	-- init status
	onBtnSearchTapped()

	-- block click
	-- self.background:setTouchEnabled(true, 0, true)

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	if scaleOriginPosInWorldPos then
		self.showHideAnim = IconPanelShowHideAnim:create(self, scaleOriginPosInWorldPos)
	end

	return true
end

function AddFriendPanel:onCloseBtnTapped()
	local function onHideAnimFinished()
		PopoutManager:sharedInstance():remove(self, true)
	end
	self.allowBackKeyTap = false
	self.showHideAnim:playHideAnim(onHideAnimFinished)
end

function AddFriendPanel:popout()
	local function onAnimOver() self.allowBackKeyTap = true end
	PopoutManager:sharedInstance():add(self, true, false)
	self.showHideAnim:playShowAnim(onAnimOver)
end

------------------------------------------
-- TabSearch
------------------------------------------
function AddFriendPanel:_tabSearch_init(ui)
	-- get & create controls
	self.tabSearch = {}
	self.tabSearch.ui = ui
	self.tabSearch.btnAdd = ui:getChildByName("btn_add")
	self.tabSearch.btnAdd = GroupButtonBase:create(self.tabSearch.btnAdd)
	self.tabSearch.bgResultBG = ui:getChildByName("bg_resultArea")
	self.tabSearch.userName = ui:getChildByName("lbl_userName")
	self.tabSearch.userLevel = ui:getChildByName("lbl_userLevel")
	self.tabSearch.userImg = ui:getChildByName("img_userImg")
	self.tabSearch.noUserImg = ui:getChildByName("img_noUser")
	self.tabSearch.noUserText = ui:getChildByName("lbl_noUser")
	self.tabSearch.inputText = ui:getChildByName("lbl_input")
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
	local icon = nil
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		icon = ui:getChildByName("icn_mitalk")
	else
		icon = ui:getChildByName("icn_wechat")
	end

	self.tabSearch.wdjBtn = GroupButtonBase:create(self.tabSearch.ui:getChildByName('btn_wdj'))
	local wdjLocator = self.tabSearch.ui:getChildByName('ver.WDJ_WdjBtnLocator')
	local wechatLocator = self.tabSearch.ui:getChildByName('ver.WDJ_WechatBtnLocator')

	-- set strings
  
  local tmpstr = Localization:getInstance():getText("add.friend.panel.input.tip")
  if __WP8 then tmpstr = tmpstr:gsub("•", "●") end
	self.tabSearch.inputText:setString(tmpstr)
  
	self.tabSearch.input.text:setString("")
	self.tabSearch.noUserText:setString(Localization:getInstance():getText("add.friend.panel.no.user.text"))
	self.tabSearch.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))
	self.tabSearch.userLevel:setString(Localization:getInstance():getText("add.friend.panel.no.user.level"))
	self.tabSearch.btnAdd:setString(Localization:getInstance():getText("add.friend.panel.btn.add.text"))
  
	tmpstr = Localization:getInstance():getText("add.friend.panel.code.desc")
	if __WP8 then tmpstr = tmpstr:gsub("•", "●") end
	self.tabSearch.inviteText:setString(tmpstr)
  
	self.tabSearch.inviteBtn:setString(Localization:getInstance():getText("invite.friend.panel.invite.button"))
	self.tabSearch.wdjBtn:setString(Localization:getInstance():getText('invite.friend.panel.button.text.wdj'))

	-- set status
	local code = tostring(AddFriendPanelModel:getUserInviteCode())
	if code and string.len(code) > 0 and code ~= "nil" then
		self.tabSearch.inviteCode:setDimensions(CCSizeMake(0, 0))
		self.tabSearch.inviteCode:setString(code)
		local tSize = self.tabSearch.inviteCode:getContentSize()
		local lSize = self.tabSearch.inviteCodeUnderline:getContentSize()
		self.tabSearch.inviteCodeUnderline:setScale(tSize.width / lSize.width)
		self.tabSearch.inviteCodeUnderline:setPositionX(self.tabSearch.inviteCode:getPositionX())
		self.tabSearch.inviteCodeUnderline:setPositionY(self.tabSearch.inviteCode:getPositionY() - tSize.height)
		self.tabSearch.copyCodeLayer = LayerColor:create()
		self.tabSearch.copyCodeLayer:changeWidthAndHeight(tSize.width + 40, tSize.height + 40)
		self.tabSearch.copyCodeLayer:setOpacity(0)
		self.tabSearch.copyCodeLayer:setPositionX(self.tabSearch.inviteCode:getPositionX() - 20)
		self.tabSearch.copyCodeLayer:setPositionY(self.tabSearch.inviteCode:getPositionY() - tSize.height - 20)
		self.tabSearch.ui:addChild(self.tabSearch.copyCodeLayer)
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
	else self.tabSearch.wdjBtn:removeFromParentAndCleanup(true) end
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
		if length > 0 then
			self.tabSearch.input.btnCancel:setVisible(true)
			if RequireNetworkAlert:popout() then
				self:_tabSearch_searchFriend(content, length)
			end
		end
	end
	local function onEmptyCallback()
		self.tabSearch.input.text:setVisible(false)
		self.tabSearch.input.btnCancel:setVisible(false)
	end
	local function onOutsideCallback(content, length)
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
	local function onInputTapped()
		self.tabSearch.input.focused:setVisible(true)
		self.tabSearch.softKeyboard:start(self, ccp(0, -600))
		self.tabSearch.input.btnCancel:setVisible(false)
		self:_tabSearch_removeSearchResult()
	end
	self.tabSearch.input:setTouchEnabled(true)
	self.tabSearch.input:addEventListener(DisplayEvents.kTouchTap, onInputTapped)

	local function onInputCancelTapped()
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
		self.tabSearch.copyCodeLayer:setTouchEnabled(true)
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

function AddFriendPanel:_tabSearch_searchFriend(code, length)
	self.tabSearch.bgResultBG:setVisible(true)
	self.tabSearch.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))
	self.tabSearch.userLevel:setString(Localization:getInstance():getText("add.friend.panel.no.user.level"))
	self.tabSearch.userImg:setVisible(false)
	self.tabSearch.userName:setVisible(true)
	self.tabSearch.userLevel:setVisible(true)
	self.tabSearch.input.btnCancel:setVisible(false)
	self.tabSearch.input.btnLoad:setVisible(true)
	local noUserTextStr = ""
	local function fakeLoadEnd()
		self.tabSearch.userName:setVisible(false)
		self.tabSearch.userLevel:setVisible(false)
		self.tabSearch.userImg:setVisible(false)
		if self.tabSearch.userHead then self.tabSearch.userHead:removeFromParentAndCleanup(true) end
		self.tabSearch.noUserImg:setVisible(true)
		self.tabSearch.noUserText:setString(noUserTextStr)
		self.tabSearch.input.btnLoad:setVisible(false)
		self.tabSearch.input.btnCancel:setVisible(true)
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

function AddFriendPanel:_tabSearch_doSearchFriend(code)
	local function onSuccess(data, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		self.userInviteCode = code
		self:_tabSearch_updateFriendInfo(data)
	end
	local function onFail(err, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
		self:_tabSearch_updateFriendInfo()
	end
	local function onCancel(context)
		if self.isDisposed or self.tabStatus ~= context then return end
		self:_tabSearch_updateFriendInfo()
	end
	self.tabStatus = self.tabStatus + 1
	self.addFriendPanelLogic:searchUser(code, onSuccess, onFail, onCancel, self.tabStatus)
end

function AddFriendPanel:_tabSearch_updateFriendInfo(dataTable)
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

function AddFriendPanel:_tabSearch_removeSearchResult()
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

function AddFriendPanel:_tabSearch_addFriend()
	local function onSuccess(data, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		DcUtil:sendInviteRequest(self.userInviteCode)
		CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.add.success"), "positive")
		self.tabSearch.softKeyboard:cleanText()
		self.tabSearch.btnAdd:setVisible(false)
	end
	local function onFail(err, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	self.tabStatus = self.tabStatus + 1
	self.addFriendPanelLogic:sendAddMessage(nil, onSuccess, onFail, nil, self.tabStatus)
end

------------------------------------------
-- TabCode
------------------------------------------
function AddFriendPanel:_tabCode_init(ui)
	self.tabCode = {}
	self.tabCode.ui = ui
	local text1 = self.tabCode.ui:getChildByName("text1")
	text1:setString(Localization:getInstance():getText("add.friend.panel.qrcode.desc.mine"))
	local text2 = self.tabCode.ui:getChildByName("text2")
	text2:setString(Localization:getInstance():getText("add.friend.panel.qrcode.desc.friend"))
	local code = self.tabCode.ui:getChildByName("code")
	code:setVisible(false)
	local size = code:getGroupBounds().size
	local sprite = CocosObject.new(QRManager:generatorQRNode(QRCodePostPanel:getQRCodeURL(), size.width))
	local sSize = sprite:getContentSize()
	local layer = Layer:create()
	sprite:setScaleX(size.width / sSize.width)
	sprite:setScaleY(-size.height / sSize.height) -- original and correct scaleY of image is smaller than zero.
	sprite:setPositionXY(-sSize.width / 2 * sprite:getScaleX(), -sSize.height / 4 * sprite:getScaleY())
	layer:setPositionX(code:getPositionX() + size.width / 2)
	layer:setPositionY(code:getPositionY() - size.height / 2 + sSize.height / 4)
	layer:addChild(sprite)
	layer.extended = false
	local touchLayer = nil
	local originX, originY = layer:getPositionX(), layer:getPositionY()
	local destX, destY = layer:getPositionX(), layer:getPositionY()
	local originScale, destScale = 1, 2.1
	local function resizeQRCode()
		extended = not extended
		if extended then
			layer:setScale(destScale)
			layer:setPositionXY(destX, destY)
			if not touchLayer then
				touchLayer = Layer:create()
				local size = Director:sharedDirector():getWinSize()
				touchLayer:setContentSize(CCSizeMake(size.width / self:getScale(), size.height / self:getScale()))
				touchLayer:setAnchorPoint(ccp(0, 1))
				touchLayer:ignoreAnchorPointForPosition(false)
				touchLayer:setPositionXY(-self:getPositionX(), -self:getPositionY())
				touchLayer:setTouchEnabled(true, 0, true)
				touchLayer:addEventListener(DisplayEvents.kTouchTap, resizeQRCode)
				self.ui:addChild(touchLayer)
			end
		else
			layer:setScale(originScale)
			layer:setPositionXY(originX, originY)
			if touchLayer then
				touchLayer:removeFromParentAndCleanup(true)
				touchLayer = nil
			end
		end
	end
	layer:addEventListener(DisplayEvents.kTouchTap, resizeQRCode)
	ui:addChild(layer)
	local btn1 = ButtonIconsetBase:create(self.tabCode.ui:getChildByName("btn1"))
	local function onBtn1()
		local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
		local title = Localization:getInstance():getText("invite.friend.panel.share.title")
		local text = Localization:getInstance():getText("add.friend.panel.qrcode.share.desc")
		local uid = UserManager:getInstance().uid
		local inviteCode = UserManager:getInstance().inviteCode
		local platformName = StartupConfig:getInstance():getPlatformName()
		local link = QRCodePostPanel:getQRCodeURL()
		local function restoreBtn()
			if self.tabCode.ui.isDisposed then return end
			if not self.tabCode.ui:isVisible() then return end
			if btn1.isDisposed then return end
			btn1:setEnabled(true)
		end
		local shareCallback = {
	        onSuccess=function(result)
	        	CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.success.tips"), "positive")
	        	restoreBtn()
	        	DcUtil:qrCodeSendToWechatTapped()
	        end,
	        onError=function(errCode, msg)
	        	CommonTip:showTip(Localization:getInstance():getText("share.feed.invite.code.faild.tips"), "positive")
	        	restoreBtn()
	        end,
	        onCancel=function()
	        	CommonTip:showTip(Localization:getInstance():getText("share.feed.cancel.tips"), "positive")
	        	restoreBtn()
	    	end
	    }
	    btn1:setEnabled(false)
	    setTimeOut(restoreBtn, 2)
	    if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
	    	SnsProxy:shareLink(PlatformShareEnum.kMiTalk, title, text, link, thumb, shareCallback)
	    else
			WeChatSDK.new():sendLinkMessage(title, text, thumb, link, false, shareCallback)
		end
	end
	local icon
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		icon = SpriteColorAdjust:createWithSpriteFrameName("miTalkIconaaa0000")
	else
		icon = SpriteColorAdjust:createWithSpriteFrameName("wechaticondsfa0000")
	end
	icon:setAnchorPoint(ccp(0, 1))
	btn1:setIcon(icon)
	if PlatformConfig:isPlatform(PlatformNameEnum.kMiTalk) then
		btn1:setVisible(false)
		originScale = 1.3
		layer:setScale(originScale)
		originY = originY - 35
		layer:setPositionY(originY)
	else
		btn1:setString(Localization:getInstance():getText("add.friend.panel.qrcode.send.wechat"))
		btn1:addEventListener(DisplayEvents.kTouchTap, onBtn1)
	end
	
	local btn2 = GroupButtonBase:create(self.tabCode.ui:getChildByName("btn2"))
	btn2:setString(Localization:getInstance():getText("add.friend.panel.qrcode.scan.button"))
	local function onBtn2()
		local function onButton1Click()
			local function onSuccess(panel)
				local function onClose()
					btn2:setEnabled(true)
				end
				panel:addEventListener(kPanelEvents.kClose, onClose)
				panel:popout()
			end
			local function onFail()
				btn2:setEnabled(true)
			end
			btn2:setEnabled(false)
			DcUtil:qrCodeClickScan()
			local panel = QRCodeReceivePanel:create(self.addFriendPanelLogic, onSuccess, onFail)
		end
		CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,NotRemindFlag.CAMERA_ALLOW,Localization:getInstance():getText("pre.tips.camera"));
	end
	btn2:addEventListener(DisplayEvents.kTouchTap, onBtn2)

	if PlatformConfig:isJJPlatform( ) then
		btn1:setVisible(false)
		local btn_1_pos = btn1:getPosition()
		local btn_2_pos = btn2:getPosition()
		local distance_y = (btn_2_pos.y - btn_1_pos.y)/2
		btn2:setPosition(ccp(btn_2_pos.x, btn_2_pos.y - distance_y))

		local text_2_pos = text2:getPosition()
		text2:setPosition(ccp(text_2_pos.x, text_2_pos.y - distance_y))
	end

	layer:setTouchEnabled(true, 0, true)

	self.tabCode.hide = function()
		self.tabCode.ui:setVisible(false)
		btn1:setEnabled(false)
		btn2:setEnabled(false)
		layer:setTouchEnabled(false)
	end
	self.tabCode.expand = function()
		layer:setTouchEnabled(true, 0, true)
		btn1:setEnabled(true)
		btn2:setEnabled(true)
		self.tabCode.ui:setVisible(true)
	end
end

------------------------------------------
-- TabRecommend
------------------------------------------
function AddFriendPanel:_tabRecommend_init(ui)
	-- get & create controls
	self.tabRecommend = {}
	self.tabRecommend.ui = ui
	self.tabRecommend.load = ui:getChildByName("img_load")
	local pos = self.tabRecommend.load:getPosition()
	local size = self.tabRecommend.load:getGroupBounds().size
	self.tabRecommend.load:setAnchorPoint(ccp(0.48, 0.52))
	self.tabRecommend.load:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
	self.tabRecommend.load:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
	self.tabRecommend.noUser = ui:getChildByName("lbl_noUser")
	self.tabRecommend.noUser:setString(Localization:getInstance():getText("add.friend.panel.recommend.no.user"))
	self.tabRecommend.noUser:setVisible(false)
	self.tabRecommend.refresh = ui:getChildByName("btn_refresh")
	self.tabRecommend.refresh:setVisible(false)
	self.tabRecommend.refresh.text = self.tabRecommend.refresh:getChildByName("lbl_text")
	local fullWidth = ui:getChildByName("_bg"):getGroupBounds().size.width / self:getScale()
	size = self.tabRecommend.refresh:getGroupBounds().size
	size = {width = size.width / self:getScale(), height = size.height / self:getScale()}
	self.tabRecommend.listBasePos = {x = (fullWidth - size.width * 2) / 3, y = self.tabRecommend.refresh:getPosition().y}
	self.tabRecommend.listIndexPos = {x = self.tabRecommend.listBasePos.x + size.width, y = size.height + 5}
	self.tabRecommend.listContent = {}

	-- set strings
	self.tabRecommend.refresh.text:setString(Localization:getInstance():getText("add.friend.panel.recommend.refresh"))

	-- add event listeners
	local function onRefreshTapped()
		if RequireNetworkAlert:popout() then
			self.tabRecommend.load:setVisible(true)
			for i = 1, #self.tabRecommend.listContent do
				self.tabRecommend.listContent[1]:removeFromParentAndCleanup(true)
				table.remove(self.tabRecommend.listContent, 1)
			end
			self.tabRecommend.refresh:setVisible(false)
			self.tabRecommend.noUser:setVisible(false)
			self.tabStatus = self.tabStatus + 1
			self:_tabRecommend_loadList()
		end
	end
	self.tabRecommend.refresh:setTouchEnabled(true)
	self.tabRecommend.refresh:addEventListener(DisplayEvents.kTouchTap, onRefreshTapped)

	self.tabRecommend.hide = function()
		self.tabRecommend.ui:setVisible(false)
		for i = 1, #self.tabRecommend.listContent do
			self.tabRecommend.listContent[1]:removeFromParentAndCleanup(true)
			table.remove(self.tabRecommend.listContent, 1)
		end
		self.tabRecommend.refresh:setVisible(false)
	end
	self.tabRecommend.expand = function()
		self:_tabRecommend_loadList()
		self.tabRecommend.ui:setVisible(true)
	end
end

function AddFriendPanel:_tabRecommend_loadList()
	local function onSuccess(data, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		if data.num == 0 then
			self.tabRecommend.noUser:setVisible(true)
		else self:_tabRecommend_showList(data.data, data.num) end
		self.tabRecommend.load:setVisible(false)

		--
		DcUtil:addFriendSearch(data.num)
	end
	local function onFail(err, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
		self.tabRecommend.load:setVisible(false)
		if __WP8 and err == 1016 then
			LocationManager:GetInstance():GotoSettingIfNecessary()
		end
	end
	self.tabRecommend.noUser:setVisible(false)
	self.tabRecommend.load:setVisible(true)
	self.tabStatus = self.tabStatus + 1
	self.addFriendPanelLogic:getRecommendFriend(onSuccess, onFail, self.tabStatus)
end

function AddFriendPanel:_tabRecommend_showList(data, num)
	local count = 1
	while data[count] do
		local elem = self:_tabRecommend_createFriend(data[count])
		elem:setPosition(ccp(self.tabRecommend.listBasePos.x, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * (count - 1) / 2))
		self.tabRecommend.ui:addChild(elem)
		table.insert(self.tabRecommend.listContent, elem)
		if data[count + 1] then
			local elem = self:_tabRecommend_createFriend(data[count + 1])
			elem:setPosition(ccp(self.tabRecommend.listBasePos.x + self.tabRecommend.listIndexPos.x, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * (count - 1) / 2))
			self.tabRecommend.ui:addChild(elem)
			table.insert(self.tabRecommend.listContent, elem)
		else
			count = count - 1
		end
		count = count + 2
	end
	if num > 10 then
		local posX = 0
		if count / 2 ~= math.floor(count / 2) then posX = self.tabRecommend.listBasePos.x
		else posX = self.tabRecommend.listBasePos.x + self.tabRecommend.listIndexPos.x end
		self.tabRecommend.refresh:setPosition(ccp(posX, self.tabRecommend.listBasePos.y - self.tabRecommend.listIndexPos.y * math.floor((count - 1) / 2)))
		self.tabRecommend.refresh:setVisible(true)
	end
end

function AddFriendPanel:_tabRecommend_addFriend(uid, target)
	local function onSuccess(data, context)
		local status = context.status
		DcUtil:addFiendNear()
		if self.isDisposed or self.tabStatus ~= status then return end
		local target = context.target
		if not target or target.isDisposed then return end
		target.imgLoad:setVisible(false)
		target.labelSent:setVisible(true)
		target.bgSent:setVisible(true)
		target.bgNormal:setVisible(false)
	end
	local function onFail(err, context)
		local status = context.status
		if self.isDisposed or self.tabStatus ~= status then return end
		local target = context.target
		if target and not target.isDisposed then
			target:setTouchEnabled(true)
			target.iconAdd:setVisible(true)
			target.imgLoad:setVisible(false)
		end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	target:setTouchEnabled(false)
	self.addFriendPanelLogic:sendRecommendFriendMessage(uid, onSuccess, onFail, {target = target, status = self.tabStatus})
end

function AddFriendPanel:_tabRecommend_createFriend(data)
	local elem = self:buildInterfaceGroup("AddFriendPanelRecommendItem")
	elem.bgNormal = elem:getChildByName("bg_normal")
	elem.bgSent = elem:getChildByName("bg_sent")
	elem.bgSent:setVisible(false)
	elem.labelSent = elem:getChildByName("lbl_sent")
	elem.labelSent:setString(Localization:getInstance():getText("add.friend.panel.message.sent"))
	elem.labelSent:setVisible(false)
	elem.iconAdd = elem:getChildByName("icn_add")
	elem.userLevel = elem:getChildByName("lbl_userLevel")
	elem.userName = elem:getChildByName("lbl_userName")
	elem.userHead = elem:getChildByName("img_userImg")
	elem.imgLoad = elem:getChildByName("img_load")
	local pos = elem.imgLoad:getPosition()
	local size = elem.imgLoad:getGroupBounds().size
	elem.imgLoad:setAnchorPoint(ccp(0.5, 0.5))
	elem.imgLoad:setPosition(ccp(pos.x + size.width / 2, pos.y - size.height / 2))
	elem.imgLoad:runAction(CCRepeatForever:create(CCRotateBy:create(1, 360)))
	elem.imgLoad:setVisible(false)

	local name = HeDisplayUtil:urlDecode(data.userName)
	if name and string.len(name) > 0 then elem.userName:setString(name)
	else elem.userName:setString(Localization:getInstance():getText("add.friend.panel.no.user.name"))end
	if data.userLevel then
		elem.userLevel:setString(Localization:getInstance():getText("add.friend.panel.user.info.level", {n = data.userLevel}))
	end
	local userHead = HeadImageLoader:create(data.uid, data.headUrl)
	if userHead then
		local position = elem.userHead:getPosition()
		userHead:setAnchorPoint(ccp(-0.5, 0.5))
		userHead:setScale(0.65)
		userHead:setPosition(ccp(position.x, position.y))
		elem.userHead:getParent():addChild(userHead)
		elem.userHead:removeFromParentAndCleanup(true)
	end

	elem:setTouchEnabled(true)
	local function onTouched()
		if RequireNetworkAlert:popout() then
			elem.imgLoad:setVisible(true)
			elem.iconAdd:setVisible(false)
			self:_tabRecommend_addFriend(data.uid, elem)
		end
	end
	elem:addEventListener(DisplayEvents.kTouchTap, onTouched)

	return elem
end

------------------------------------------
-- TabShake
------------------------------------------
function AddFriendPanel:_tabShake_init(ui)
	-- get & create controls
	self.tabShake = {}
	self.tabShake.ui = ui
	self.tabShake.phUnit = ui:getChildByName("ph_unit")
	self.tabShake.retry = ui:getChildByName("btn_retry")
	self.tabShake.desc = ui:getChildByName("lbl_desc")
	self.tabShake.loadLabel = ui:getChildByName("lbl_loading")
	self.tabShake.desc:setVisible(true)
	self.tabShake.tip = ui:getChildByName("lbl_tip")
	self.tabShake.tip:setVisible(true)
	self.tabShake.animLeft = ui:getChildByName("img_left")
	self.tabShake.animLeft:setAnchorPointWhileStayOriginalPosition(ccp(0.2, -0.8))
	self.tabShake.animLeft:setRotation(-15.4)
	self.tabShake.animRight = ui:getChildByName("img_right")
	self.tabShake.animRight:setAnchorPointWhileStayOriginalPosition(ccp(0.8, -0.8))
	self.tabShake.animRight:setRotation(15.4)
	self.tabShake.signal1 = ui:getChildByName("img_signal1")
	self.tabShake.signal2 = ui:getChildByName("img_signal2")
	self.tabShake.signal3 = ui:getChildByName("img_signal3")
	self.tabShake.retry = GroupButtonBase:create(self.tabShake.retry)

	-- set strings
	self.tabShake.retry:setString(Localization:getInstance():getText("add.friend.panel.shake.retry"))
	self.tabShake.desc:setString(Localization:getInstance():getText("add.friend.panel.shake.desc", {n = '\n'}))
	self.tabShake.loadLabel:setString(Localization:getInstance():getText("add.friend.panel.shake.load"))
	self.tabShake.tip:setString(Localization:getInstance():getText("add.friend.panel.shake.tip"))

	-- save info
	local pos = self.tabShake.phUnit:getPosition()
	self.tabShake.phPosition = {x = pos.x, y = pos.y}
	local size = self.tabShake.phUnit:getGroupBounds().size
	self.tabShake.phSize = {width = size.width / self:getScaleX(), height = size.height / self:getScaleY() + 15}
	self.tabShake.phUnit:removeFromParentAndCleanup(true)

	-- add event listeners
	local function onRetryTapped()
		self.addFriendPanelLogic:resetWaitingState()
		self.tabShake.contentList = self.tabShake.contentList or {}
		for k, v in ipairs(self.tabShake.contentList) do
			v:removeFromParentAndCleanup(true)
		end
		self.tabShake.friendSearchComplete = nil
		self:_tabShake_waitForShake()

		--
		DcUtil:addFriendShakeCancel()
	end
	self.tabShake.retry:addEventListener(DisplayEvents.kTouchTap, onRetryTapped)
	self.tabShake.hide = function()
		self.tabShake.ui:setVisible(false)
		self.tabShake.retry:setEnabled(false)
		if not self.tabShake.friendSearchComplete then
			self.tabShake.contentList = self.tabShake.contentList or {}
			for k, v in ipairs(self.tabShake.contentList) do v:removeFromParentAndCleanup(true) end
			for i = 1, #self.tabShake.contentList do table.remove(self.tabShake.contentList, 1) end
		end
		self.addFriendPanelLogic:stopWaitForShake()
	end
	self.tabShake.expand = function()
		if not self.tabShake.friendSearchComplete then
			if not self.addFriendPanelLogic:isWaitingState() then
				self.addFriendPanelLogic:resetWaitingState()
				self:_tabShake_waitForShake()
			end
		end
		self.tabShake.retry:setEnabled(true)
		self.tabShake.ui:setVisible(true)
	end
end

function AddFriendPanel:_tabShake_waitForShake()
	self.tabShake.retry:setVisible(false)
	self.tabShake.desc:setVisible(true)
	self.tabShake.loadLabel:setVisible(false)
	self.tabShake.tip:setVisible(true)
	self:_tabShake_playTipAnim()
	local function onCallback(data, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		self:_tabShake_playLoadAnim()
		self:_tabShake_searchFriend(context)
	end
	self.tabStatus = self.tabStatus + 1
	self.addFriendPanelLogic:waitForShake(onCallback, self.tabStatus)
end

function AddFriendPanel:_tabShake_searchFriend(tabStatus)
	local function reShake()
		if self.isDisposed then return end
		self.addFriendPanelLogic:resetWaitingState()
		self:_tabShake_waitForShake()
	end
	local function onSuccess(data, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		if data and #data > 0 then
			self.tabShake.friendSearchComplete = true
			self:_tabShake_updateFriendInfo(data)
		else
			CommonTip:showTip(Localization:getInstance():getText("add.friend.panel.shake.no.user"), "negative", reShake)
		end
	end
	local function onFail(err, context)
		if self.isDisposed or self.tabStatus ~= context then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative", reShake)
		if __WP8 and err == 1016 then
			LocationManager:GetInstance():GotoSettingIfNecessary()
		end
	end
	self.tabShake.desc:setVisible(false)
	self.tabShake.loadLabel:setVisible(true)
	self.tabShake.tip:setVisible(false)
	self.addFriendPanelLogic:sendPositionMessage(onSuccess, onFail, tabStatus)
end

function AddFriendPanel:_tabShake_updateFriendInfo(data)
	self.tabShake.animLeft:stopAllActions()
	self.tabShake.animLeft:setVisible(false)
	self.tabShake.animRight:stopAllActions()
	self.tabShake.animRight:setVisible(false)
	self.tabShake.ui:stopAllActions()
	self.tabShake.signal1:setVisible(false)
	self.tabShake.signal2:setVisible(false)
	self.tabShake.signal3:setVisible(false)
	self.tabShake.desc:setVisible(false)
	self.tabShake.loadLabel:setVisible(false)
	self.tabShake.tip:setVisible(false)
	self.tabShake.retry:setVisible(true)

	self.tabShake.contentList = self.tabShake.contentList or {}
	for k, v in ipairs(data) do
		local elem = self:_tabShake_createResultUnit(v)
		if elem then
			elem:setPosition(ccp(self.tabShake.phPosition.x, self.tabShake.phPosition.y - self.tabShake.phSize.height * (k - 1)))
			self.tabShake.ui:addChild(elem)
			table.insert(self.tabShake.contentList, elem)
		end
	end

	DcUtil:addFriendShake(#data)
end

function AddFriendPanel:_tabShake_createResultUnit(data)
	-- init and create control
	local elem = self:buildInterfaceGroup("ShakeResultItem")
	elem.backGround = elem:getChildByName("_bg")
	elem.userHead = elem:getChildByName("img_userImage")
	elem.userName = elem:getChildByName("lbl_userName")
	elem.userLevel = elem:getChildByName("lbl_userLevel")
	elem.status = elem:getChildByName("lbl_status")
	elem.lblWaiting = elem:getChildByName("lbl_waiting")
	elem.imgAdd = elem:getChildByName("img_add")
	elem.imgComplete = elem:getChildByName("img_complete")

	-- define methods
	elem.add = function()
		elem:stopAllActions()
		elem.status:setString(Localization:getInstance():getText("add.friend.panel.shake.add"))
		elem.lblWaiting:setVisible(false)
		elem.imgAdd:setVisible(true)
		elem.imgComplete:setVisible(false)
	end
	elem.waiting = function()
		elem:stopAllActions()
		elem.status:setString(Localization:getInstance():getText("add.friend.panel.shake.waiting"))
		elem.lblWaiting:setVisible(true)
		elem.imgAdd:setVisible(false)
		elem.imgComplete:setVisible(false)
		local function setString()
			local len = string.len(elem.lblWaiting:getString()) + 1
			if len > 3 then len = 0 end
			local str = ""
			for i = 1, len do str = str..'.' end
			elem.lblWaiting:setString(str)
		end
		elem:runAction(CCRepeatForever:create(CCSequence:createWithTwoActions(CCCallFunc:create(setString), CCDelayTime:create(0.5))))
	end
	elem.complete = function()
		elem:stopAllActions()
		elem.status:setString(Localization:getInstance():getText("add.friend.panel.shake.complete"))
		elem.lblWaiting:setVisible(false)
		elem.imgAdd:setVisible(false)
		elem.imgComplete:setVisible(true)
		elem:setAnchorPoint(ccp(0.5, 0.5))
		
	end
	elem.bounce = function()
		elem.imgComplete:setAnchorPointWhileStayOriginalPosition(ccp(0.5, 0.5))
		elem.imgComplete:setScale(0.01)
		elem.imgComplete:runAction(CCEaseBackOut:create(CCScaleTo:create(0.1, 1)))
		local function scaleDown() if elem and not elem.isDisposed then elem:setScale(1.02) end end
		local function scaleUp() if elem and not elem.isDisposed then elem:setScale(1) end end
		local arr = CCArray:create()
		arr:addObject(CCDelayTime:create(0.1))
		arr:addObject(CCCallFunc:create(scaleDown))
		arr:addObject(CCDelayTime:create(0.1))
		arr:addObject(CCCallFunc:create(scaleUp))
		arr:addObject(CCDelayTime:create(0.1))
		arr:addObject(CCCallFunc:create(scaleDown))
		arr:addObject(CCDelayTime:create(0.1))
		arr:addObject(CCCallFunc:create(scaleUp))
		elem:runAction(CCSequence:create(arr))
	end

	-- set control
	local name = HeDisplayUtil:urlDecode(data.userName)
	if name and string.len(name) > 0 then elem.userName:setString(name) end
	if data.userLevel then
		elem.userLevel:setString(Localization:getInstance():getText("add.friend.panel.user.info.level", {n = data.userLevel}))
	end
	local userHead = HeadImageLoader:create(data.uid, data.headUrl)
	if userHead then
		local position = elem.userHead:getPosition()
		userHead:setAnchorPoint(ccp(-0.5, 0.5))
		userHead:setPosition(ccp(position.x, position.y))
		userHead:setScale(0.8)
		elem.userHead:getParent():addChild(userHead)
		elem.userHead:removeFromParentAndCleanup(true)
	end
	if data.isFriend then elem.complete()
	else elem.add()
		if not elem or elem.isDisposed then return end
		-- add event listener
		local function onTouched()
			if RequireNetworkAlert:popout() then
				elem:setTouchEnabled(false)
				elem.waiting()
				self:_tabShake_sendAddMessage(data.uid, elem)
			end
		end
		elem:setTouchEnabled(true)
		elem:addEventListener(DisplayEvents.kTouchTap, onTouched)
	end
	
	return elem
end

function AddFriendPanel:_tabShake_sendAddMessage(uid, target)
	local function onSuccess(data, context)
		DcUtil:addFriendShakeNear()
		if self.isDisposed then return end
		self:_tabShake_requestConfirm(uid, context)
	end
	local function onFail(err, context)
		if self.isDisposed then return end
		if context.target and not context.target.isDisposed then
			context.target.add()
			context.target:setTouchEnabled(true)
		end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	self.addFriendPanelLogic:sendShakeAddMessage(uid, onSuccess, onFail, {target = target, status = self.tabStatus})
end

function AddFriendPanel:_tabShake_requestConfirm(uid, iptPara)
	local function onSuccess(data, context)
		DcUtil:addFriendShakeConfirm()
		if self.isDisposed or context.target.isDisposed then return end
		context.target.bounce()
		context.target.complete()
	end
	local function onFail(err, context)
		if self.isDisposed then return end
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
	end
	-- self.addFriendPanelLogic:askForShakeAddResult(uid, onSuccess, onFail, iptPara)
	self.addFriendPanelLogic:askForShakeAddResult(uid, onSuccess, nil, iptPara)
end

function AddFriendPanel:_tabShake_playTipAnim()
	local arr1 = CCArray:create()
	arr1:addObject(CCRotateTo:create(0.25, -15.4))
	arr1:addObject(CCRotateTo:create(0.1, 0))
	arr1:addObject(CCDelayTime:create(2))
	self.tabShake.animLeft:stopAllActions()
	self.tabShake.animLeft:setRotation(-15.4)
	self.tabShake.animLeft:setVisible(true)
	self.tabShake.animLeft:runAction(CCRepeatForever:create(CCSequence:create(arr1)))
	local arr2 = CCArray:create()
	arr2:addObject(CCRotateTo:create(0.25, 15.4))
	arr2:addObject(CCRotateTo:create(0.1, 0))
	arr2:addObject(CCDelayTime:create(2))
	self.tabShake.animRight:stopAllActions()
	self.tabShake.animRight:setRotation(15.4)
	self.tabShake.animRight:setVisible(true)
	self.tabShake.animRight:runAction(CCRepeatForever:create(CCSequence:create(arr2)))
	local arr3 = CCArray:create()
	arr3:addObject(CCDelayTime:create(0.35))
	local function onFadeIn()
		self.tabShake.signal1:setVisible(true)
		self.tabShake.signal2:setVisible(true)
		self.tabShake.signal3:setVisible(true)
	end
	arr3:addObject(CCCallFunc:create(onFadeIn))
	arr3:addObject(CCDelayTime:create(2))
	local function onFadeOut()
		self.tabShake.signal1:setVisible(false)
		self.tabShake.signal2:setVisible(false)
		self.tabShake.signal3:setVisible(false)
	end
	arr3:addObject(CCCallFunc:create(onFadeOut))
	self.tabShake.signal1:setOpacity(83)
	self.tabShake.signal1:setVisible(false)
	self.tabShake.signal2:setOpacity(83)
	self.tabShake.signal2:setVisible(false)
	self.tabShake.signal3:setOpacity(83)
	self.tabShake.signal3:setVisible(false)
	self.tabShake.ui:stopAllActions()
	self.tabShake.ui:runAction(CCRepeatForever:create(CCSequence:create(arr3)))
end

function AddFriendPanel:_tabShake_playLoadAnim()
	self.tabShake.animLeft:stopAllActions()
	self.tabShake.animRight:stopAllActions()
	self.tabShake.animLeft:runAction(CCRotateTo:create(0.1, -15))
	self.tabShake.animRight:runAction(CCRotateTo:create(0.1, 15))
	local function playConnectAnim()
		local arr = CCArray:create()
		local function signal1()
			self.tabShake.signal1:setOpacity(255)
			self.tabShake.signal2:setOpacity(83)
			self.tabShake.signal3:setOpacity(83)
		end
		arr:addObject(CCCallFunc:create(signal1))
		arr:addObject(CCDelayTime:create(0.5))
		local function signal2()
			self.tabShake.signal1:setOpacity(83)
			self.tabShake.signal2:setOpacity(255)
			self.tabShake.signal3:setOpacity(83)
		end
		arr:addObject(CCCallFunc:create(signal2))
		arr:addObject(CCDelayTime:create(0.5))
		local function signal3()
			self.tabShake.signal1:setOpacity(83)
			self.tabShake.signal2:setOpacity(83)
			self.tabShake.signal3:setOpacity(255)
		end
		arr:addObject(CCCallFunc:create(signal3))
		arr:addObject(CCDelayTime:create(0.5))
		self.tabShake.signal1:setVisible(true)
		self.tabShake.signal2:setVisible(true)
		self.tabShake.signal3:setVisible(true)
		self.tabShake.ui:stopAllActions()
		self.tabShake.ui:runAction(CCRepeatForever:create(CCSequence:create(arr)))
	end
	self.tabShake.ui:stopAllActions()
	self.tabShake.ui:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.1), CCCallFunc:create(playConnectAnim)))
end

function AddFriendPanel:getHCenterInScreenX(...)
	assert(#{...} == 0)

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfWidth		= 685 * self:getScale()

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	return visibleOrigin.x + halfDeltaWidth
end

function AddFriendPanel:onWdjBtnTapped(event)
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