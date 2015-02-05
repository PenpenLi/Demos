
SelectSNSAccountLoginPanel = class(BasePanel)

function SelectSNSAccountLoginPanel:create( isCacheLogin )
	local panel = SelectSNSAccountLoginPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	panel:init( isCacheLogin )
	return panel
end

function SelectSNSAccountLoginPanel:init( isCacheLogin )
	self.ui = self:buildInterfaceGroup("selectSNSAccountLoginPanel")
	BasePanel.init(self, self.ui)

	local panelTitle = self.ui:getChildByName("title")
	panelTitle:setText("选择登录方式")
	local size = panelTitle:getContentSize()
	local scale = 65 / size.height
	panelTitle:setScale(scale)
	panelTitle:setPositionX((self.ui:getChildByName("_scale9Bg"):getGroupBounds().size.width - size.width * scale) / 2)

	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:onKeyBackClicked() end)

	local firstBtn = GroupButtonBase:create(self.ui:getChildByName("firstBtn"))
	firstBtn:setString("QQ登录")
	firstBtn:setColorMode(kGroupButtonColorMode.orange)
	firstBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.qqLoginButtonCallback then 
			self.qqLoginButtonCallback()
		end
		self:remove()
	end)

	local secondBtn = GroupButtonBase:create(self.ui:getChildByName("secondBtn"))
	secondBtn:setString("微博登录")
	secondBtn:setColorMode(kGroupButtonColorMode.blue)
	secondBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.weiboLoginButtonCallback then 
			self.weiboLoginButtonCallback()
		end
		self:remove()
	end)

	self.ui:getChildByName("desc"):setString(
		-- "绑定过微博的玩家登录QQ账号后，可直接获取原有的游戏数据导入QQ账号"
		Localization:getInstance():getText("loading.tips.preloading.warnning.5")
	)

	local checkBox = self.ui:getChildByName("checkbox")

	if isCacheLogin then 
		checkBox:setTouchEnabled(true)
		checkBox:addEventListener(DisplayEvents.kTouchTap,function( ... )
			local guo = checkBox:getChildByName("guo")
			guo:setVisible(not guo:isVisible())
		end)
		self.ui:getChildByName("desc2"):setString(
			-- "记住选择，本周内不再提示"
			Localization:getInstance():getText("loading.tips.preloading.warnning.7")
		)
	else
		checkBox:setVisible(false)

		local scale9Bg = self.ui:getChildByName("_scale9Bg")
		local desBg = self.ui:getChildByName("_desBg")

		local scale9BgSize = scale9Bg:getPreferredSize()
		scale9Bg:setPreferredSize(CCSizeMake(scale9BgSize.width,scale9BgSize.height - 40))
		local desBgSize = desBg:getPreferredSize()
		desBg:setPreferredSize(CCSizeMake(desBgSize.width,desBgSize.height - 40))
	end
end

function SelectSNSAccountLoginPanel:popout( ... )
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local bounds = self.ui:getChildByName("_scale9Bg"):getGroupBounds()

	self:setPositionX(visibleSize.width/2 - bounds.size.width/2)
	self:setPositionY(-visibleSize.height/2 + bounds.size.height/2)
end

function SelectSNSAccountLoginPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end

function SelectSNSAccountLoginPanel:onKeyBackClicked()
	self:remove()
	self.allowBackKeyTap = false

	if self.closeButtonCallback then 
		self.closeButtonCallback()
	end
end

function SelectSNSAccountLoginPanel:setQQLoginButtonCallback( func )
	self.qqLoginButtonCallback = func
end

function SelectSNSAccountLoginPanel:setWeiboLoginButtonCallback( func )
	self.weiboLoginButtonCallback = func
end

function SelectSNSAccountLoginPanel:setCloseButtonCallback( func )
	self.closeButtonCallback = func
end

function SelectSNSAccountLoginPanel:isThisWeekNoSelectAccount( ... )
	local checkBox = self.ui:getChildByName("checkbox")
	if checkBox:isVisible() then 
		return checkBox:getChildByName("guo"):isVisible()
	else
		return false
	end
end


NoWeiboDataPanel = class(BasePanel)
function NoWeiboDataPanel:create( ... )
	local panel = NoWeiboDataPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	panel:init()
	return panel
end

function NoWeiboDataPanel:init( ... )
	self.ui = self:buildInterfaceGroup("noWeiboDataPanel")
	BasePanel.init(self, self.ui)


	local closeBtn = self.ui:getChildByName("closeBtn")
	closeBtn:setTouchEnabled(true)
	closeBtn:setButtonMode(true)
	closeBtn:addEventListener(DisplayEvents.kTouchTap, function() self:onKeyBackClicked() end)

	local firstBtn = GroupButtonBase:create(self.ui:getChildByName("firstBtn"))
	firstBtn:setColorMode(kGroupButtonColorMode.blue)
	firstBtn:setString("微博登录")
	firstBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.weiboLoginButtonCallback then 
			self.weiboLoginButtonCallback()
		end
		self:remove()
	end)

	local secondBtn = GroupButtonBase:create(self.ui:getChildByName("secondBtn"))
	secondBtn:setColorMode(kGroupButtonColorMode.orange)
	secondBtn:setString("QQ登录")
	secondBtn:addEventListener(DisplayEvents.kTouchTap,function( ... )
		if self.qqLoginButtonCallback then 
			self.qqLoginButtonCallback()
		end
		self:remove()
	end)

	self.ui:getChildByName("desc"):setString(
		-- "绑定过微博的玩家登录QQ账号后，可直接获取原有的游戏数据导入QQ账号登录，与更多好友一起玩哦！"
		Localization:getInstance():getText("loading.tips.preloading.warnning.6")
	)
end

function NoWeiboDataPanel:popout( ... )
	PopoutManager:sharedInstance():add(self, true, false)
	self.allowBackKeyTap = true

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local bounds = self.ui:getChildByName("_scale9Bg"):getGroupBounds()

	self:setPositionX(visibleSize.width/2 - bounds.size.width/2)
	self:setPositionY(-visibleSize.height/2 + bounds.size.height/2)
end

function NoWeiboDataPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end
function NoWeiboDataPanel:onKeyBackClicked()
	self:remove()
	self.allowBackKeyTap = false

	if self.closeButtonCallback then 
		self.closeButtonCallback()
	end
end


function NoWeiboDataPanel:setWeiboLoginButtonCallback( func )
	self.weiboLoginButtonCallback = func
end
function NoWeiboDataPanel:setQQLoginButtonCallback( func )
	self.qqLoginButtonCallback = func
end
function NoWeiboDataPanel:setCloseButtonCallback( func )
	self.closeButtonCallback = func
end


WeiboMergeToQQSuccessPanel = class(BasePanel)
function WeiboMergeToQQSuccessPanel:create( ... )
	local panel = WeiboMergeToQQSuccessPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	panel:init()
	return panel
end
function WeiboMergeToQQSuccessPanel:init( ... )
	self.ui = self:buildInterfaceGroup("qqloginsuccesspanel")
	BasePanel.init(self, self.ui)

	self.ui:getChildByName("desLabel"):setString(
		-- "游戏账户读取成功！您的原有微博账号数据已成功绑定至QQ账号下~"
		Localization:getInstance():getText("loading.tips.login.success.4")
	)

	local okButton = GroupButtonBase:create(self.ui:getChildByName("confirmBtn"))
	okButton:setString("知道了")
	okButton:addEventListener(DisplayEvents.kTouchTap,function( ... )
		self:remove()

		if self.okButtonCallback then 
			self.okButtonCallback()
		end
	end)
end
function WeiboMergeToQQSuccessPanel:popout( ... )
	PopoutManager:sharedInstance():add(self, true, false)
	-- self.allowBackKeyTap = true

	local visibleSize = Director.sharedDirector():getVisibleSize()
	local bounds = self.ui:getChildByName("_scale9Bg"):getGroupBounds()

	self:setPositionX(visibleSize.width/2 - bounds.size.width/2)
	self:setPositionY(-visibleSize.height/2 + bounds.size.height/2)
end

function WeiboMergeToQQSuccessPanel:remove( ... )
	PopoutManager:sharedInstance():remove(self)
end


function WeiboMergeToQQSuccessPanel:setOkButtonCallback( func )
	self.okButtonCallback = func
end