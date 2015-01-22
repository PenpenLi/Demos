ExceptionPanel = class(CocosObject)

function ExceptionPanel:create(onUseLocalFunc, onUseServerFunc)
	local winSize = CCDirector:sharedDirector():getWinSize()
	local ret = ExceptionPanel.new(CCNode:create())
	ret:loadRequiredResource(PanelConfigFiles.panel_game_setting)
	ret:buildUI(onUseLocalFunc, onUseServerFunc)
	return ret
end


function ExceptionPanel:loadRequiredResource( panelConfigFile )
	self.panelConfigFile = panelConfigFile
	self.builder = InterfaceBuilder:create(panelConfigFile)
end

function ExceptionPanel:buildUI(onUseLocalFunc, onUseServerFunc)
	local winSize = CCDirector:sharedDirector():getVisibleSize()
	local origin = CCDirector:sharedDirector():getVisibleOrigin()

	local layer = LayerColor:create()
	layer:changeWidthAndHeight(winSize.width, winSize.height)
	layer:setColor(ccc3(0,0,0))
	layer:setOpacity(255 * 0.4)
	layer:setTouchEnabled(true, 0, true)
	self:addChild(layer)
	self:setPosition(ccp(origin.x, origin.y))

	local ui = self.builder:buildGroup("exceptionpanel")--ResourceManager:sharedInstance():buildGroup("exceptionpanel")
	local contentSize = ui:getGroupBounds().size
	local reportBtn = GroupButtonBase:create(ui:getChildByName("reportBtn"))
	local syncBtn = GroupButtonBase:create(ui:getChildByName("syncBtn"))

	if __WP8 then
		reportBtn:setVisible(false)
		syncBtn:setPositionX(contentSize.width / 2)
	end
	
	ui:setPosition(ccp((winSize.width - contentSize.width)/2, (winSize.height + contentSize.height)/2))
	ui:getChildByName("titleLabel"):setString(Localization:getInstance():getText("exception.panel.tittle"))
	ui:getChildByName("infoLabel"):setString(Localization:getInstance():getText("exception.panel.text"))
	ui:getChildByName("dataInfoLabel"):setString("")

	syncBtn:useStaticLabel(32)
	reportBtn:setColorMode(kGroupButtonColorMode.blue)
	reportBtn:useStaticLabel(34)
	reportBtn:setString(Localization:getInstance():getText("exception.panel.btn.email"))
	syncBtn:setString(Localization:getInstance():getText("exception.panel.btn.commit"))
  
	--reportBtn:getChildByName("label"):setString(Localization:getInstance():getText("exception.panel.btn.email"))
	--syncBtn:getChildByName("label"):setString(Localization:getInstance():getText("exception.panel.btn.commit"))

	local function onReportTouch(evt)
		self:removeFromParentAndCleanup(true)
		if onUseLocalFunc ~= nil then onUseLocalFunc() end
		if __IOS and kUserLogin then GspEnvironment:getCustomerSupportAgent():ShowJiraMain() end
		--ExceptionPanel:alert(Localization:getInstance():getText("exception.panel.email.tips"))
	end
	--reportBtn:setTouchEnabled(true)
	--reportBtn:setButtonMode(true)
	reportBtn:ad(DisplayEvents.kTouchTap, onReportTouch)

	local function onSyncTouch(evt)
		self:removeFromParentAndCleanup(true)
		if onUseServerFunc ~= nil then onUseServerFunc() end
		ExceptionPanel:alert(Localization:getInstance():getText("exception.panel.commit.tips"))
	end
	--syncBtn:setTouchEnabled(true)
	--syncBtn:setButtonMode(true)
	syncBtn:ad(DisplayEvents.kTouchTap, onSyncTouch)

	local function onGetUserFinish( evt )
		evt.target:rma()
		
		if evt.data then
			local user = evt.data.user
			if user and ui and ui.list then
				local topLevelId = user.topLevelId
				local updateTime = tonumber(user.updateTime)
				updateTime = updateTime / 1000
				local dataInfoLabel = {space=" ", num=topLevelId, data=os.date("%x %H:%M", updateTime)}
				ui:getChildByName("dataInfoLabel"):setString(Localization:getInstance():getText("exception.panel.top.level", dataInfoLabel))
			end
		end
	end
	local http = GetUserHttp.new()
	http:addEventListener(Events.kComplete, onGetUserFinish)
	http:load()
	
	self:addChild(ui)
	return true
end

function ExceptionPanel:alert(message)
	local scene = Director:sharedDirector():getRunningScene()
	if scene then
		local item = RequireNetworkAlert.new(CCNode:create())
		item:buildUI(message)
		scene:addChild(item)
	end
end

function ExceptionPanel:popout()
	local scene = Director:sharedDirector():getRunningScene()
	if scene then scene:addChild(self) end
end