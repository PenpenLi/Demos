require "zoo.PersonalCenter.PersonalCenterManager"
local QRCodeFriendPanel = class(BasePanel)

function QRCodeFriendPanel:create()
	local panel = QRCodeFriendPanel.new()
	panel:loadRequiredResource("ui/add_friend_panel.json")
	panel:init()

	return panel
end

function QRCodeFriendPanel:init()
	self.ui = self:buildInterfaceGroup("QRCodeFriendPanel")
    BasePanel.init(self, self.ui)

    self.addFriendPanelLogic = AddFriendPanelLogic:create()

    self.title = self.ui:getChildByName("title")
    self.title:setPreferredSize(239, 63)
    self.title:setString(localize("add.friend.panel.add.qrcode"))

    self:initCloseButton()
    self:initContent()
end

function QRCodeFriendPanel:initContent()
	self:_tabCode_init(self.ui)
end

------------------------------------------
-- TabCode
------------------------------------------
function QRCodeFriendPanel:_tabCode_init(ui)
	self.tabCode = {}
	self.tabCode.ui = ui
	local text1 = self.tabCode.ui:getChildByName("text1")
	text1:setString(Localization:getInstance():getText("add.friend.panel.qrcode.desc.mine"))
	local text2 = self.tabCode.ui:getChildByName("text2")
	text2:setString(Localization:getInstance():getText("add.friend.panel.qrcode.desc.friend"))
	local code = self.tabCode.ui:getChildByName("code")
	code:setVisible(false)
	local size = code:getGroupBounds().size
	local url = PersonalCenterManager:getData(PersonalCenterManager.QR_CODE)
	local sprite = CocosObject.new(QRManager:generatorQRNode(url, size.width, 1, ccc4(74, 175, 23, 255)))
	local sSize = sprite:getContentSize()
	local layer = Layer:create()
	sprite:setScaleX(size.width / sSize.width)
	sprite:setScaleY(-size.height / sSize.height) -- original and correct scaleY of image is smaller than zero.
	sprite:setPositionXY(-sSize.width / 2 * sprite:getScaleX(), -sSize.height / 4 * sprite:getScaleY())
	layer:addChild(sprite)

	local head_rect = ui:getChildByName("user_head")
	local profile = UserManager.getInstance().profile
	print("profile.headUrl: "..tostring(profile.headUrl))
	local userHead = HeadImageLoader:create(profile.uid, profile.headUrl)
	if userHead then
		local position = head_rect:getPosition()
		local head_size = head_rect:getGroupBounds().size
		local img_size = CCSizeMake(100, 100) --userHead:getGroupBounds().size
		local codeSize = layer:getGroupBounds().size
		userHead:setAnchorPoint(ccp(-0.5, 0.5))
		userHead:setScaleX(0.6*head_size.width/img_size.width)
		userHead:setScaleY(0.6*head_size.height/img_size.height)
		local centerx = sprite:getPositionX() + (codeSize.width - head_size.width*0.6)/2
		userHead:setPosition(ccp(centerx , sprite:getPositionY() - (codeSize.height - head_size.height*0.6)/2 ))
		layer:addChild(userHead)
	end
	head_rect:removeFromParentAndCleanup(true)

	layer:setPositionX(code:getPositionX() + size.width / 2)
	layer:setPositionY(code:getPositionY() - size.height / 2 + sSize.height / 4)

	layer.extended = false
	local touchLayer = nil
	local originX, originY = layer:getPositionX(), layer:getPositionY()
	local destX, destY = layer:getPositionX(), layer:getPositionY()+10
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
	ui:addChildAt(layer, ui:getChildIndex(code))
	local btn1 = ButtonIconsetBase:create(self.tabCode.ui:getChildByName("btn1"))
	btn1:setColorMode(kGroupButtonColorMode.blue)

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

		   	local function cb()
	            restoreBtn()
	        end

	        PersonalCenterManager:sendBusinessCard(cb, cb, cb)
			--WeChatSDK.new():sendLinkMessage(title, text, thumb, link, false, shareCallback)
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
		originScale = 1.25
		layer:setScale(originScale)
		originY = originY - 35
		layer:setPositionY(originY)

		local qr_bg = ui:getChildByName("qr_bg")
		qr_bg:setScale(1.503)
		qr_bg:setPositionY(qr_bg:getPositionY() - 8)
		qr_bg:setPositionX(qr_bg:getPositionX() - 39)
	else
		btn1:setString("发名片加好友")--Localization:getInstance():getText("add.friend.panel.qrcode.send.wechat"))
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

function QRCodeFriendPanel:initCloseButton()
	self.closeBtn = self.ui:getChildByName("btnClose")
    self.closeBtn:setTouchEnabled(true, 0, true)
    self.closeBtn:setButtonMode(true)
    self.closeBtn:addEventListener(DisplayEvents.kTouchTap, 
        function() 
            self:onCloseBtnTapped()
        end)
end

function QRCodeFriendPanel:onKeyBackClicked(...)
	BasePanel.onKeyBackClicked(self)
end

function QRCodeFriendPanel:popout()
	self:setPositionForPopoutManager()
	self.allowBackKeyTap = true
	PopoutManager:sharedInstance():add(self, true, false)

end

function QRCodeFriendPanel:popoutShowTransition()
	self.allowBackKeyTap = true
end

function QRCodeFriendPanel:onCloseBtnTapped()
	PopoutManager:sharedInstance():remove(self, true)
end

return QRCodeFriendPanel