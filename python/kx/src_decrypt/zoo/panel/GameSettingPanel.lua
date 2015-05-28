require "zoo.baseUI.ButtonWithShadow"
require "zoo.panel.component.quitPanel.QuitPanelButton"
require "zoo.util.IllegalWordFilterUtil"
require "zoo.panel.CDKeyPanel"

GameSettingPanel = class(BasePanel)
function GameSettingPanel:initAvatar( group )
	if not group then return nil end
	local avatarPlaceholder = group:getChildByName("avatarPlaceholder")
	local frameworkChosen = group:getChildByName("frameworkChosen")
	if frameworkChosen then frameworkChosen:setVisible(false) end

	local hitArea = CocosObject:create()
	hitArea.name = kHitAreaObjectName
	hitArea:setContentSize(CCSizeMake(100,100))
	hitArea:setPosition(ccp(-50,-50))
	group:addChild(hitArea)

	group.chooseIcon = frameworkChosen
	group.select = function ( self, val )
		self.selected = val
		if self.chooseIcon then self.chooseIcon:setVisible(val) end
	end
	group.changeImage = function( self, userId, headUrl )
		local oldImageIndex = nil
		if self.headImage then 
			oldImageIndex = self.headImage.headImageUrl 
			self.headImage:removeFromParentAndCleanup(true) 
		end
		-- local headImage = HeadImageLoader:create(userId, headUrl)
		-- headImage:setPosition(ccp(0, -2))
		-- self:addChildAt(headImage, 1)
		-- self.headImage = headImage

		local framePos = avatarPlaceholder:getPosition()
		local frameSize = avatarPlaceholder:getContentSize()
		local function onImageLoadFinishCallback(clipping)
			if self.isDisposed then return end
			local clippingSize = clipping:getContentSize()
			local scale = frameSize.width/clippingSize.width
			--clipping:setAnchorPoint(ccp(0,0))
			clipping:setScale(scale*0.83)
			-- clipping:setPosition(ccp(framePos.x + frameSize.width/2, framePos.y - frameSize.height/2))
			clipping:setPosition(ccp(frameSize.width/2-2,frameSize.height/2))
			avatarPlaceholder:addChild(clipping)
			self.headImage = clipping	

			-- if self.isDisposed then return end

			-- clipping:setPosition(ccp(0, -2))
			-- self:addChildAt(clipping, 1)
			-- self.headImage = clipping
		end
		HeadImageLoader:create(userId, headUrl, onImageLoadFinishCallback)

		return oldImageIndex
	end
	group.getProfileURL = function( self )
		if self.headImage then return self.headImage.headImageUrl end
		return nil
	end
	return group
end
function GameSettingPanel:initMoreAvatars( group )
	local kDefaultUserIndex = 10
	local profile = UserManager.getInstance().profile
	local kMaxHeadImages = UserManager.getInstance().kMaxHeadImages
	local moreAvatarList = {}
  	local function getAvatarByHeadImage(headUrl)
  		for i=0 , 10 do
  			local v = moreAvatarList[i]
  			if v:getProfileURL() == headUrl then return v end
  		end
  		return nil
  	end
  	local function changeDefaultAvatarImage()
  		local oldHeadAvatar = getAvatarByHeadImage(profile.headUrl)
  		local oldImageIndex = moreAvatarList[kDefaultUserIndex]:changeImage(profile.uid, profile.headUrl)
  		if self.playerAvatar then self.playerAvatar:changeImage(profile.ui, profile.headUrl) end
  		if oldHeadAvatar then oldHeadAvatar:changeImage("exp."..tostring(oldImageIndex), oldImageIndex) end
  	end
	local function onAvatarItemTouch( evt )
		for i=0 , 10 do
			local v = moreAvatarList[i]
			if v:hitTestPoint(evt.globalPosition, true) then
				self:onAvatarTouch() 
				local headUrl = v:getProfileURL()
				if profile.headUrl ~= headUrl then
					profile.headUrl = headUrl
					GameSettingPanel:updateUserProfile()
					changeDefaultAvatarImage()
				end
			end
		end
	end
	for i=0 , 10 do
		local avatar = self:initAvatar(group:getChildByName("p"..(i+1)))
		if avatar then
			avatar.index = i
			moreAvatarList[i] = avatar
			avatar:changeImage("exp."..i, i)
		end
	end
	changeDefaultAvatarImage()
	moreAvatarList[kDefaultUserIndex]:select(true)	
	self.moreAvatarList = moreAvatarList
	group:setTouchEnabled(true, -1, true)
	group:ad(DisplayEvents.kTouchTap, onAvatarItemTouch)
end
function GameSettingPanel:initInput(onBeginCallback)
	local user = UserManager.getInstance().user
	local profile = UserManager.getInstance().profile	
	local inputSelect = self.nameLabel:getChildByName("inputBegin")
	local inputSize = inputSelect:getContentSize()
	local inputPos = inputSelect:getPosition()
	inputSelect:setVisible(true)
	inputSelect:removeFromParentAndCleanup(false)

	local function onTextBegin()
		if onBeginCallback then onBeginCallback() end
	end
	
	local function onTextEnd()
		if self.input then
			local profile = UserManager.getInstance().profile
			local text = self.input:getText() or ""
			if text ~= "" then
				-- 敏感词过滤
				if IllegalWordFilterUtil.getInstance():isIllegalWord(text) then
					local oldName = HeDisplayUtil:urlDecode(profile.name or "")
					self.input:setText(oldName)
					CommonTip:showTip(Localization:getInstance():getText("error.tip.illegal.word"), "negative")
				else
					if profile.name ~= text then
						profile:setDisplayName(text)
						GameSettingPanel:updateUserProfile()
					end
				end
			else
				CommonTip:showTip(Localization:getInstance():getText("game.setting.panel.username.empty"), "negative")
			end
		end
	end

	local position = ccp(inputPos.x + inputSize.width/2, inputPos.y - inputSize.height/2)
	local input = TextInput:create(inputSize, Scale9Sprite:createWithSpriteFrameName("ui_empty0000"), inputSelect.refCocosObj)
	input.originalX_ = position.x
	input.originalY_ = position.y
	input:setText(profile:getDisplayName())
	input:setPosition(position)
	input:setFontColor(ccc3(0,0,0))
	input:setMaxLength(15)
	input:ad(kTextInputEvents.kBegan, onTextBegin)
	input:ad(kTextInputEvents.kEnded, onTextEnd)
	self.nameLabel:addChild(input)
	self.input = input
	inputSelect:dispose()
end
local function startAppBar(sub)
	ShareManager:openAppBar( sub )
end

function GameSettingPanel:isNicknameUnmodifiable()
	if __IOS then
		return __IOS_QQ or __IOS_WEIBO
	elseif __ANDROID then
		local authType = SnsProxy:getAuthorizeType()
		return authType == PlatformAuthEnum.kQQ
			or authType == PlatformAuthEnum.kWeibo
			or authType == PlatformAuthEnum.kMI
			or authType == PlatformAuthEnum.kWDJ
			or authType == PlatformAuthEnum.k360
	end

	return false
end

function GameSettingPanel:isAvatarUnmodifiable()
	if __IOS then
		return __IOS_QQ or __IOS_WEIBO
	elseif __ANDROID then
		local authType = SnsProxy:getAuthorizeType()
		return authType == PlatformAuthEnum.kQQ
			or authType == PlatformAuthEnum.kWeibo
			or authType == PlatformAuthEnum.kMI
	end

	return false
end

function GameSettingPanel:init()
	local showWeiSheQuBtn = __IOS_QQ and SnsProxy:isLogin()
	if showWeiSheQuBtn then
		self.ui	= self:buildInterfaceGroup("gamesettingPanelWeiSheQu")
	else
		self.ui	= self:buildInterfaceGroup("gamesettingPanel") --ResourceManager:sharedInstance():buildGroup("gamesettingPanel")
	end
	
	BasePanel.init(self, self.ui)
	local user = UserManager.getInstance().user
	local profile = UserManager.getInstance().profile

	-- 是否允许修改头像和昵称
	self.headImageModifiable = true
	self.nickNameModifiable = true
	
	if (__ANDROID or __IOS) and SnsProxy:isLogin() then
		if self:isNicknameUnmodifiable() then
			self.nickNameModifiable = false
		end
		if self:isAvatarUnmodifiable() then
			self.headImageModifiable = false
		end
	end

	if not kUserLogin then
		self.headImageModifiable = false
		self.nickNameModifiable = false
	end

	self.panelTitle		= self.ui:getChildByName("panelTitle")
	self.btn1Res		= self.ui:getChildByName("button1")
	self.btn2Res		= self.ui:getChildByName("button2")
	self.closeBtn		= self.ui:getChildByName("closeBtn")
	self.nameLabel		= self.ui:getChildByName("touch")
	self.moreAvatars	= self.ui:getChildByName("moreAvatars")
	self.avatar 		= self.ui:getChildByName("avatar")
	self.controlpanel	= self.ui:getChildByName("controlpanel")
	self.musicBtn		= self.controlpanel:getChildByName("musicbtn")
	self.soundBtn		= self.controlpanel:getChildByName("soundbtn")
	self.notificationBtn= self.controlpanel:getChildByName("notificationbtn")
	self.musicPauseIcon	= self.controlpanel:getChildByName("musicpause")
	self.soundPauseIcon	= self.controlpanel:getChildByName("soundpause")
	self.notificationPauseIcon	= self.controlpanel:getChildByName("notificationpause")
	self.bg = self.ui:getChildByName("_newBg")

	self.soundBtnTip	= self.controlpanel:getChildByName("soundtip")
	self.musicBtnTip	= self.controlpanel:getChildByName("musictip")
	self.notificationBtnTip	= self.controlpanel:getChildByName("notificationtip")

	self.tips	= {self.soundBtnTip, self.musicBtnTip, self.notificationBtnTip}

	self.btn1	= ButtonIconsetBase:create(self.btn1Res)--QuitPanelButton:create(self.btn1Res)
	self.btn2	= ButtonIconsetBase:create(self.btn2Res)--QuitPanelButton:create(self.btn2Res)

	if showWeiSheQuBtn then
		self.gotoAppBarBtn = self.ui:getChildByName("gotoAppBarBtn")
		self.gotoAppBarBtnText = self.gotoAppBarBtn:getChildByName("text")
		self.cdkeyBtn = self.ui:getChildByName("cdkey")
		self.cdkeyBtnText = self.cdkeyBtn:getChildByName("text")
		self.cdkeySprite = self.cdkeyBtn:getChildByName("icon")
	else
		self.cdkeyBg = self.controlpanel:getChildByName("bg2")
		self.cdkeyBtn = self.controlpanel:getChildByName("cdkey")
		self.cdkeySprite = self.cdkeyBtn
	end

	self.btn1:setColorMode(kGroupButtonColorMode.blue)
	self.btn2:setColorMode(kGroupButtonColorMode.orange)
	self.btn1:useBubbleAnimation()
	self.btn2:useBubbleAnimation()
	--self.btn1.button:changeToColor("blue")
	--self.btn2.button:changeToColor("yellow")
	self.moreAvatars:setVisible(false)

	self.playerAvatar = self:initAvatar(self.avatar:getChildByName("settingavatarframework"))
	self.playerAvatar:changeImage(profile.ui, profile.headUrl)

	self.panelTitle:setText(Localization:getInstance():getText("quit.panel.tittle"))
	local size = self.panelTitle:getContentSize()
	local scale = 65 / size.height
	self.panelTitle:setScale(scale)
	self.panelTitle:setPositionX((self.bg:getGroupBounds().size.width - size.width * scale) / 2)

	if not self.headImageModifiable then 
		local arrow = self.avatar:getChildByName("avatarArrow") 
		if arrow then arrow:setVisible(false) end
	end

	if self.gotoAppBarBtnText then
		self.gotoAppBarBtnText:setString(Localization:getInstance():getText("quit.panel.appbar"))
	end
	if self.cdkeyBtnText then
		self.cdkeyBtnText:setString(Localization:getInstance():getText("quit.panel.cdkey"))
	end

	if showWeiSheQuBtn then
		self.cdkeyBtn:setVisible(MaintenanceManager:getInstance():isEnabled("CDKeyCode"))
		local bg = self.controlpanel:getChildByName("bg")
		local cpSize = bg:getGroupBounds().size
		local bgSize = self.bg:getGroupBounds().size
		self.controlpanel:setPositionX((bgSize.width / self:getScale() - cpSize.width) / 2)
	else
		local sprite = ResourceManager:sharedInstance():buildGroup("exchangeIcon")
		local targetSize = self.cdkeySprite:getGroupBounds().size
		local buttonSize = sprite:getGroupBounds().size
		local scale = targetSize.width / buttonSize.width
		if scale > targetSize.height / buttonSize.height then
			scale = targetSize.height / buttonSize.height
		end
		sprite:setScale(scale)
		sprite:setPositionX(self.cdkeySprite:getPositionX() + (targetSize.width - (buttonSize.width - 20) * scale) / 2)
		sprite:setPositionY(self.cdkeySprite:getPositionY() - (targetSize.height - (buttonSize.height + 6) * scale) / 2)
		local parent = self.cdkeySprite:getParent()
		parent:addChildAt(sprite, 2)
		self.cdkeySprite:removeFromParentAndCleanup(true)
		self.cdkeySprite = sprite
		self.cdkeyBtn = self.cdkeySprite
		if MaintenanceManager:getInstance():isEnabled("CDKeyCode") then
			local bg = self.controlpanel:getChildByName("bg2")
			local cpSize = bg:getGroupBounds().size
			local bgSize = self.bg:getGroupBounds().size
			self.controlpanel:setPositionX((bgSize.width / self:getScale() - bg:getPositionX() - cpSize.width) / 2)
		else
			self.cdkeyBtn:setVisible(false)
			local bg2 = self.controlpanel:getChildByName("bg2")
			bg2:setVisible(false)
			local bg = self.controlpanel:getChildByName("bg")
			local cpSize = bg:getGroupBounds().size
			local bgSize = self.bg:getGroupBounds().size
			self.controlpanel:setPositionX((bgSize.width / self:getScale() - cpSize.width) / 2)
		end
	end

	--local nameSize = self.nameLabel:getGroupBounds().size
	self.nameLabel:getChildByName("touch"):removeFromParentAndCleanup(true)	
	self.nameLabel:getChildByName("label"):setString(profile:getDisplayName())
	self.nameLabel:getChildByName("inputBegin"):setVisible(false)
	self:initMoreAvatars(self.moreAvatars)

	-- 需求：做任何操作都会取消5秒后仅一次的邀请码放大缩小
	local schedule = nil
	local function stopSchedule()
		if schedule then
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(schedule)
			schedule = nil
		end
	end

	--昵称可修改时 TextField隐藏 创建TextInput 否则不创建TextInput
	if self.nickNameModifiable then 
		self.nameLabel:getChildByName("label"):setVisible(false)
		self:initInput(stopSchedule)
	end

	local inviteCode = UserManager.getInstance().inviteCode
	if __IOS_FB then inviteCode = UserManager.getInstance().user.uid end
	if inviteCode and inviteCode ~= "" then
		if __IOS_FB then 
			self.ui:getChildByName("idLabelPrefix"):setString("uid:") 
			self.ui:getChildByName("idLabelNum"):setText(tostring(inviteCode))
		else
			local prefix = self.ui:getChildByName("idLabelPrefix")
			prefix:setString(Localization:getInstance():getText("invite.friend.panel.code.prefix"))
			local text = self.ui:getChildByName("idLabelNum")
			local newTxt = LabelBMMonospaceFont:create(36, 36, 19, "fnt/target_amount.fnt")
			newTxt:setAnchorPoint(ccp(0, 1))
			newTxt:setString(tostring(inviteCode))
			newTxt.name = "idLabelNum"
			if __ANDROID then
				newTxt:setPositionXY(text:getPositionX(), prefix:getPositionY() - 2)
			else
				newTxt:setPositionXY(text:getPositionX(), text:getPositionY())
			end
			newTxt:setAnchorPointCenterWhileStayOrigianlPosition()
			local parent = text:getParent()
			parent:addChildAt(newTxt, parent:getChildIndex(text))
			text:removeFromParentAndCleanup(true)
		end
	else
		self.ui:getChildByName("idLabelPrefix"):setVisible(false)
	end

	if showWeiSheQuBtn then
		self.gotoAppBarBtn = self.ui:getChildByName("gotoAppBarBtn")
		self.gotoAppBarBtn:setVisible(true)
		if not MaintenanceManager:getInstance():isEnabled("CDKeyCode") then
			local bg = self.controlpanel:getChildByName("bg")
			local bgSize = bg:getGroupBounds().size
			local myBg = self.gotoAppBarBtn:getChildByName("bg")
			local myBgSize = myBg:getGroupBounds().size
			local deltaWidth = bgSize.width - myBgSize.width
			myBg:setPreferredSize(CCSizeMake(bgSize.width, myBgSize.height))
			local elem = self.gotoAppBarBtn:getChildByName("icon")
			elem:setPositionX(elem:getPositionX() + deltaWidth / 2)
			elem = self.gotoAppBarBtn:getChildByName("text")
			elem:setPositionX(elem:getPositionX() + deltaWidth / 2)
			self.gotoAppBarBtn:setPositionX(self.controlpanel:getPositionX())
		end
		local function onGotoAppBarBtnTapped()
			if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
				SimpleAudioEngine:sharedEngine():pauseBackgroundMusic()
			end
			-- OpenUrlHandleManager:openUrlWithDefaultBrowser("http://wsq.qq.com/reflow/159718216")
			waxClass{"OnCloseCallback",NSObject,protocols={"WaxCallbackDelegate"}}
			function OnCloseCallback:onResult(ret) 
				if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
					SimpleAudioEngine:sharedEngine():resumeBackgroundMusic()
				end
			end
			OpenUrlHandleManager:openUrlWithWebview_onClose("http://wsq.qq.com/reflow/159718216", OnCloseCallback:init())
		end
		self.gotoAppBarBtn:setTouchEnabled(true)
		self.gotoAppBarBtn:addEventListener(DisplayEvents.kTouchTap, onGotoAppBarBtnTapped)
	end

	if GamePlayMusicPlayer:getInstance().IsMusicOpen then self.soundPauseIcon:setVisible(false) end
	if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then self.musicPauseIcon:setVisible(false) end

	--if ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable then 
	if CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then
		self.notificationPauseIcon:setVisible(false) 
	end

	self.btn1:setString(Localization:getInstance():getText("quit.panel.customer"))
	self.btn1:setIconByFrameName("gamesetting_cs0000")
	--self.btn1.helpIcon:setVisible(true)
	if PrepackageUtil:isPreNoNetWork() then
		self.btn2:setString(Localization:getInstance():getText("quit.panel.connect.network"))
		self.btn2:setIconByFrameName("setIcon_prePackage0000")
	else
		self.btn2:setString(Localization:getInstance():getText("quit.panel.add.friend"))
		self.btn2:setIconByFrameName("gamesetting_addfriends0000")
	end
	-- end

	-------------------
	-- Add Event Listener
	-- ----------------
	if self.headImageModifiable then
		local function onAvatarTouch()
			stopSchedule()
			self:onAvatarTouch()
		end
		self.avatar:setTouchEnabled(true)
		self.avatar:setButtonMode(true)
		self.avatar:addEventListener(DisplayEvents.kTouchTap, onAvatarTouch)
	end

	local function onMusicBtnTapped()
		stopSchedule()
		self:onMusicBtnTapped()
	end
	self.musicBtn:setButtonMode(true)
	self.musicBtn:setTouchEnabled(true)
	self.musicBtn:addEventListener(DisplayEvents.kTouchTap, onMusicBtnTapped)

	local function onSoundBtnTapped()
		stopSchedule()
		self:onSoundBtnTapped()
	end
	self.soundBtn:setButtonMode(true)
	self.soundBtn:setTouchEnabled(true)
	self.soundBtn:addEventListener(DisplayEvents.kTouchTap, onSoundBtnTapped)

	local function onNotificationBtnTapped()
		stopSchedule()
		self:onNotificationBtnTapped()
	end
	self.notificationBtn:setButtonMode(true)
	self.notificationBtn:setTouchEnabled(true)
	self.notificationBtn:addEventListener(DisplayEvents.kTouchTap, onNotificationBtnTapped)

	local function onBtn1Tapped(event) 
		stopSchedule()
		if PrepackageUtil:isPreNoNetWork() then
			PrepackageUtil:showInGameDialog()
		else
			self:onBtn1Tapped(event) 
		end
	end
	self.btn1:addEventListener(DisplayEvents.kTouchTap, onBtn1Tapped)
	--self.btn1.ui:addEventListener(DisplayEvents.kTouchTap, onBtn1Tapped)

	local function onBtn2Tapped(event) 
		stopSchedule()
		if PrepackageUtil:isPreNoNetWork() then 
			PrepackageUtil:showSettingNetWorkDialog()
		else
			self:onBtn2Tapped(event) 
		end
	end
	self.btn2:addEventListener(DisplayEvents.kTouchTap, onBtn2Tapped)
	--self.btn2.ui:addEventListener(DisplayEvents.kTouchTap, onBtn2Tapped)

	local function onCloseBtnTapped(event)
		stopSchedule()
		self:onCloseBtnTapped(event)
	end
	self.closeBtn:setTouchEnabled(true, 0, true)
	self.closeBtn:setButtonMode(true)
	self.closeBtn:addEventListener(DisplayEvents.kTouchTap, onCloseBtnTapped)
  
	local function onCDKeyButton()
		stopSchedule()
		local position = self.cdkeyBtn:getPosition()
		local parent = self.cdkeyBtn:getParent()
		local wPos = parent:convertToWorldSpace(ccp(position.x, position.y))
		local panel = CDKeyPanel:create(wPos)
		if panel then
			PopoutManager:sharedInstance():remove(self, true)
			panel:popout()
		end
	end
	if MaintenanceManager:getInstance():isEnabled("CDKeyCode") then
		self.cdkeyBtn:setTouchEnabled(true, 0, true)
		self.cdkeyBtn:addEventListener(DisplayEvents.kTouchTap, onCDKeyButton)
	end

	local function onTimeOut()
		stopSchedule()
		if self.isDisposed then return end
		local text = self.ui:getChildByName("idLabelNum")
		if not text or text.isDisposed then return end
		local arr = CCArray:create()
		arr:addObject(CCScaleTo:create(0.1, 1.35))
		arr:addObject(CCScaleTo:create(0.1, 0.85))
		arr:addObject(CCScaleTo:create(0.1, 1.1))
		arr:addObject(CCScaleTo:create(0.1, 1))
		text:runAction(CCSequence:create(arr))
	end
	schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeOut, 5, false)

	--[[if __WP8 then
		self.btn1:setVisible(false)
		local x1 = self.btn1:getPosition().x
		local x2 = self.btn2:getPosition().x
		self.btn2:setPositionX((x1 + x2) / 2)
	end--]]
end

function GameSettingPanel:onAvatarTouch()
	if self.moreAvatars:isVisible() then 
		self.moreAvatars:setVisible(false)
		if self.input then self.input:setPosition(ccp(self.input.originalX_, self.input.originalY_)) end
	else 
		self.moreAvatars:setVisible(true)  
		if self.input then self.input:setPosition(ccp(9999,9999)) end
	end
end

if __ANDROID then
require "hecore.gsp.GspProxy"
end

local function getFAQurl()
	local function getKeyValueStr(key,value,isLast)
		local strPair = key.."="..value
		if not isLast then 
			strPair = strPair.."&"
		end
		return strPair
	end
	local preUrl = "http://fansclub.happyelements.com/fans/qa.php?"

	local level = UserManager:getInstance().user:getTopLevelId()
	local platform = StartupConfig:getInstance():getPlatformName()
	local timeStamp = os.time()
	local UID = UserManager.getInstance().uid
	local version = _G.bundleVersion
	local secret = "hxxxl!xxgkl!"

	local lv = getKeyValueStr("level",level)
	local pf = getKeyValueStr("pf",platform)
	local src = getKeyValueStr("src","client")
	local ts = getKeyValueStr("ts",timeStamp)
	local uid = getKeyValueStr("uid",UID) 
	local ver = getKeyValueStr("ver",version)
	local sig = getKeyValueStr("sig",HeMathUtils:md5(level..platform.."client"..timeStamp..UID..version..secret),true)

	local finalUrl = preUrl..lv..pf..src..ts..uid..ver..sig
	print(finalUrl)
	return finalUrl
end

function GameSettingPanel:onBtn1Tapped(event, ...)
	PopoutManager:sharedInstance():remove(self, true)
	if __IOS and kUserLogin then 
		GspEnvironment:getCustomerSupportAgent():setFAQurl(getFAQurl()) 
		GspEnvironment:getCustomerSupportAgent():ShowJiraMain() 
	elseif __ANDROID then
		if kUserLogin then
			local onButton1Click = function()
				GspProxy:setFAQurl(getFAQurl())
				GspProxy:showCustomerDiaLog()  
			end
			CommonAlertUtil:showPrePkgAlertPanel(onButton1Click,NotRemindFlag.PHOTO_ALLOW,Localization:getInstance():getText("pre.tips.photo"));
		else
			CommonTip:showTip(Localization:getInstance():getText("dis.connect.warning.tips", "negative"))
		end
	elseif __WP8 then
		Wp8Utils:ShowMessageBox("QQ群: 114278702\n联系客服: xiaoxiaole@happyelements.com", "开心消消乐沟通渠道")
	end
end

function GameSettingPanel:onBtn2Tapped(event, ...)
	--PopoutManager:sharedInstance():remove(self, true)
--[[
local size = CCDirector:sharedDirector():getVisibleSize()

local c = YouKuViewController:create()

local version = "1";
local vid = "XNTMyMTExODc2";
local client_id = "3e7ecc095c50c2f0";
local client_secret = "3d22e6f2bd37ac3a4f1227cdc97548d7";

waxClass{"CallbackLink",NSObject,protocols={"CallbackLink"}}
function CallbackLink:linkParam(url)
    print("link:"..url)
    local thumb = CCFileUtils:sharedFileUtils():fullPathForFilename("materials/wechat_icon.png")
    local shareCallback = {
        onSuccess = function(result)
            print("success...")
        end,
        onError = function(errCode, errMsg)
            print("error...")
        end,
        onCancel = function()
            print("error...")
        end,
    }

--SnsUtil.sendLinkMessage(PlatformShareEnum.kWechat, "test_link", "link", thumb, "http://www.baidu.com", true, shareCallback)
end

function CallbackLink:backToGame( ... )
	print("CallbackLink:backToGame....")
end

function CallbackLink:test_b_c( a,b,c )
	print(a)
	print(b)
	print(c)
	print("----------------")
end

c:setCallbackLink(CallbackLink:init())

c:initHtmlURLStr("http://10.130.136.47/player.html")
c:presentYouKu()
do return end
--]]
	if __IOS_FB then
		SnsProxy:inviteFriends(nil)
	else
		local panel = AddFriendPanel:create(ccp(0,0))
		--if panel then panel:popout() end
	end
end


function GameSettingPanel:onMusicBtnTapped(...)	
	if GamePlayMusicPlayer:getInstance().IsBackgroundMusicOPen then
		GamePlayMusicPlayer:getInstance():pauseBackgroundMusic()
		self.musicPauseIcon:setVisible(true)

		self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.close.tip"))
	else
		GamePlayMusicPlayer:getInstance():resumeBackgroundMusic()
		self.musicPauseIcon:setVisible(false)

		self.musicBtnTip:setString(Localization:getInstance():getText("game.setting.panel.music.open.tip"))
	end

	self:playShowHideLabelAnim(self.musicBtnTip)
end

function GameSettingPanel:onSoundBtnTapped(...)
	if GamePlayMusicPlayer:getInstance().IsMusicOpen then
		GamePlayMusicPlayer:getInstance():pauseSoundEffects()
		self.soundPauseIcon:setVisible(true)

		self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.close.tip"))
	else
		GamePlayMusicPlayer:getInstance():resumeSoundEffects()
		self.soundPauseIcon:setVisible(false)

		self.soundBtnTip:setString(Localization:getInstance():getText("game.setting.panel.sound.open.tip"))
	end

	self:playShowHideLabelAnim(self.soundBtnTip)
end

function GameSettingPanel:onNotificationBtnTapped(...)
	--if ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable then
	if not CCUserDefault:sharedUserDefault():getBoolForKey("game.local.notification") then

		--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable = false
		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", true)

		self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.open.tip"))
		self.notificationPauseIcon:setVisible(false)
	else
		--ConfigSavedToFile:sharedInstance().configTable.gameSettingPanel_isNotificationEnable = true
		CCUserDefault:sharedUserDefault():setBoolForKey("game.local.notification", false)
		self.notificationBtnTip:setString(Localization:getInstance():getText("game.setting.panel.notification.close.tip"))
		self.notificationPauseIcon:setVisible(true)
	end

	self:playShowHideLabelAnim(self.notificationBtnTip)
	--ConfigSavedToFile:sharedInstance():serialize()
	CCUserDefault:sharedUserDefault():flush()
end

function GameSettingPanel:onCloseBtnTapped(event, ...)
	self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self, true)
end

function GameSettingPanel:onEnterAnimationFinished()
	if self.nickNameModifiable then
		if self.nameLabel and not self.nameLabel.isDisposed then
			local label = self.nameLabel:getChildByName("label")
			if label and not label.isDisposed then
				label:removeFromParentAndCleanup(true)
			end
		end
	end
	if self.input then self.input:setPosition(ccp(self.input.originalX_, self.input.originalY_)) end
end
function GameSettingPanel:onEnterHandler(event, ...)
	if event == "enter" then
		self.allowBackKeyTap = true
		self:runAction(self:createShowAnim())
	end
end

function GameSettingPanel:createShowAnim()
	local centerPosX 	= self:getHCenterInParentX()
	local centerPosY	= self:getVCenterInParentY()

	local function initActionFunc()
		local initPosX	= centerPosX
		local initPosY	= centerPosY + 100
		self:setPosition(ccp(initPosX, initPosY))
	end
	local initAction = CCCallFunc:create(initActionFunc)
	local moveToCenter		= CCMoveTo:create(0.5, ccp(centerPosX, centerPosY))
	local backOut 			= CCEaseQuarticBackOut:create(moveToCenter, 33, -106, 126, -67, 15)
	local targetedMoveToCenter	= CCTargetedAction:create(self.refCocosObj, backOut)

	local function onEnterAnimationFinished( )self:onEnterAnimationFinished() end
	local actionArray = CCArray:create()
	actionArray:addObject(initAction)
	actionArray:addObject(targetedMoveToCenter)
	actionArray:addObject(CCCallFunc:create(onEnterAnimationFinished))
	return CCSequence:create(actionArray)
end

function GameSettingPanel:playShowHideLabelAnim(labelToControl, ...)

	local delayTime	= 3

	labelToControl:stopAllActions()

	local function showFunc()
		-- Hide All Tip
		for k,v in pairs(self.tips) do
			v:setVisible(false)
		end

		labelToControl:setVisible(true)
	end
	local showAction = CCCallFunc:create(showFunc)


	local delay	= CCDelayTime:create(delayTime)


	local function hideFunc()
		labelToControl:setVisible(false)
	end
	local hideAction = CCCallFunc:create(hideFunc)

	local actionArray = CCArray:create()
	actionArray:addObject(showAction)
	actionArray:addObject(delay)
	actionArray:addObject(hideAction)

	local seq = CCSequence:create(actionArray)
	--return seq
	
	labelToControl:runAction(seq)
end

function GameSettingPanel:updateUserProfile()
	local profile = UserManager.getInstance().profile
	local http = UpdateProfileHttp.new()
	http:load(profile.name, profile.headUrl)
end
function GameSettingPanel:create()
	local newQuitPanel = GameSettingPanel.new()
	newQuitPanel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	newQuitPanel:init()
	return newQuitPanel
end
