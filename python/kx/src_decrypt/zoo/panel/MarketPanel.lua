require 'zoo.data.MarketManager'
require 'zoo.panel.component.market.MarketPanelGoodsItem'
require 'zoo.panel.component.pagedView.PagedView'
require 'zoo.panel.component.common.GridLayout'
require 'zoo.panel.component.common.LayoutItem'
require 'zoo.panel.buygold.BuyGoldItem'

----------------- GLOBAL FUNCTIONS ------------------
local panel = nil
function createMarketPanel(defaultIndex,tabConfig)
	if panel and not panel.isDisposed then return panel end

	panel = MarketPanel:create(defaultIndex, tabConfig)

	return panel
end


MarketPanel = class(BasePanel)

function MarketPanel:create(defaultIndex, tabConfig)
	local instance = MarketPanel.new()
	instance:loadRequiredResource(PanelConfigFiles.market_panel)
	instance:init(defaultIndex, tabConfig)

	BuyObserver:sharedInstance():setMarketPanelRef(instance)

	return instance
end

function MarketPanel:dispose()
	PlatformConfig:setCurrentPayType()
	BasePanel.dispose(self)
end

function MarketPanel:init(defaultIndex, tabConfig)

	self.defaultIndex = defaultIndex or 1;
	self.goldPageBuilt = false
	local visibleOrigin = Director:sharedDirector():getVisibleOrigin()
	local visibleSize = Director:sharedDirector():getVisibleSize()

	local ui = self:buildInterfaceGroup('MarketPanel')
	assert(ui)
	self.ui = ui
	BasePanel.init(self, ui)

	local viewBg = ui:getChildByName('viewBg')
	viewBg:setOpacity(255*0.6)
	local bottomBlock = ui:getChildByName('bottomBlock')
	local viewRect = ui:getChildByName('viewRect')

	self.buyGoldButton = bottomBlock:getChildByName('buyGoldBtn')
	self.buyGoldButton:setButtonMode(true)
	self.buyGoldButton:setTouchEnabled(true, 0, true)
	self.buyGoldButton:ad(DisplayEvents.kTouchTap, function() self:onBuyGoldButtonTap() end)

	-- positions
	-- first: bottom alignement
	local bottomBlockPos = ccp(bottomBlock:getPositionX(), -(visibleSize.height - bottomBlock:getGroupBounds().size.height))
	bottomBlock:setPosition(bottomBlockPos)
	bottomBlock:getChildByName('size'):setVisible(false)

	-- second: viewHeight fits to screen
	local viewBgHeight = math.abs(viewBg:getPositionY() - bottomBlock:getPositionY())
	local viewHeight = math.abs(viewRect:getPositionY() - bottomBlock:getPositionY() - 20) -- 20 margin
	self.viewHeight = viewHeight


	local bg = ui:getChildByName('bg')
	local gradient = LayerGradient:create()
	gradient:setStartColor(ccc3(255, 216, 119))
	gradient:setEndColor(ccc3(247, 187, 129))
	gradient:setStartOpacity(255)
	gradient:setEndOpacity(255)
	-- print('visibleSize.width', visibleSize.width, 'visibleSize.height', visibleSize.height)
	gradient:setContentSize(CCSizeMake(visibleSize.width, visibleSize.height))
	gradient:setPosition(ccp(0, -visibleSize.height))
	bg:getParent():addChildAt(gradient, bg:getZOrder())
	bg:removeFromParentAndCleanup(true) -- bg now is useless
	local size = viewBg:getGroupBounds().size
	viewBg:setPreferredSize(CCSizeMake(size.width, viewBgHeight))

	local title = ui:getChildByName('title')
	local myCashStatic = bottomBlock:getChildByName('staticTxt')
	self.cashAmountTxt = bottomBlock:getChildByName('amountTxt')
	title:setText(Localization:getInstance():getText('market.panel.title'))
	-- local rect = {x = title:getPositionX(), y = title:getPositionY(),
	-- 				width = 371.1, height = 65}
	-- InterfaceBuilder:centerInterfaceInbox(title, rect)
	local titleSize = title:getContentSize()
	local titleScale = 65 / titleSize.height
	title:setScale(titleScale)
	title:setPositionX((visibleSize.width - titleSize.width * titleScale) / 2)
	myCashStatic:setString(Localization:getInstance():getText('market.panel.mycash'))
	self.cashAmountTxt:setString(UserManager:getInstance():getUserRef():getCash())

	self.iosPaymentTip = bottomBlock:getChildByName("tipText");
	print("iosPaymentTip: ", self.iosPaymentTip);
	self.iosPaymentTip:setString(Localization:getInstance():getText('buy.gold.panel.tip'));
	self.iosPaymentTip:setVisible(false);

	self.linkBtnHistory = bottomBlock:getChildByName("linkBtnHistory");
	local textLinkHistory = self.linkBtnHistory:getChildByName("txtCheck");
	textLinkHistory:setString(Localization:getInstance():getText('market.panel.checkHistory'));
	self.linkBtnHistory:setButtonMode(true)
	self.linkBtnHistory:ad(DisplayEvents.kTouchTap, function() self:showConsumeHistory() end)

	self.linkBtnHistory:setVisible(false);
	self.linkBtnHistory:setTouchEnabled(true, 0, true)

	-- ensure that close button is at the TOP of all layers
	local closeBtn = ui:getChildByName('btnClose')
	closeBtn:setTouchEnabled(true, 0, true)
	local function __onClose(event)
		self:onCloseBtnTapped(event)
	end
	closeBtn:addEventListener(DisplayEvents.kTouchTap, __onClose)


	----------------------------------------------------------------
	-- Creating PagedView and VerticalScrollable views
	----------------------------------------------------------------
	local tabsPlaceholder = ui:getChildByName('tabRect')
	local tabsRect = tabsPlaceholder:getGroupBounds()
	local tabsZOrder = tabsPlaceholder:getZOrder()

	----------------------------------------
	-- build tabs and pages, insert items
	--
	self.config = MarketManager:sharedInstance():loadConfig(tabConfig)
	-- print(table.tostring(self.config))

	local viewPlaceholder = ui:getChildByName('viewRect')
	local viewRect = viewPlaceholder:getGroupBounds()
	self.viewRect = viewRect
	local function afterGotoPage(index)
		self:gotoTabPage(index);
	end

	local tabs = MarketPanelTab:create(self.config.tabs,nil, afterGotoPage);

	tabs:setPosition(ccp(tabsPlaceholder:getPositionX(), tabsPlaceholder:getPositionY()))
	tabsPlaceholder:getParent():addChildAt(tabs, tabsZOrder)
	self.tabs = tabs

	self.pages = {}

	local viewZOrder = viewPlaceholder:getZOrder()
	local numOfPages = #(self.config.tabs)

	local pagedView = PagedView:create(viewRect.size.width, viewHeight, numOfPages, self.tabs, false, false)
	self.view = pagedView
	pagedView.pageMargin = 35
	pagedView:setIgnoreVerticalMove(false) -- important!
	self.tabs:setView(pagedView)

	for k_tab, v_tab in pairs(self.config.tabs) do 
		local page
		if v_tab.tabId == TabsIdConst.kHappyeCoin then
			page = Layer:create()
			page:setContentSize(CCSizeMake(viewRect.size.width, viewHeight))
			local text = TextField:create(Localization:getInstance():getText("dis.connect.warning.tips"),
				nil, 28, CCSizeMake(viewRect.size.width - 80, 0), kTextAlignment.kCCTextAlignmentCenter)
			local tSize = text:getContentSize()
			text:setColor(ccc3(157, 116, 75))
			text:setPositionXY(viewRect.size.width / 2, -viewHeight / 2)
			text:setVisible(false)
			page:addChild(text)
			self.happycoinsPage = page
			self.happyCoinNetworkTip = text
		else
			page = VerticalScrollable:create(viewRect.size.width, viewHeight, false, false)
			local itemContainer = self:buildPageByTabId(v_tab.tabId)
			page:setContent(itemContainer)
			page:setIgnoreHorizontalMove(false)

		end
		pagedView:addPageAt(page, v_tab.pageIndex)
		table.insert(self.pages, page)
	end
	local simpleClipping = SimpleClippingNode:create()
	simpleClipping:setContentSize(CCSizeMake(viewRect.size.width, viewHeight))
	simpleClipping:addChild(pagedView)
	simpleClipping:setPosition(ccp(viewPlaceholder:getPositionX(), viewPlaceholder:getPositionY() - viewHeight))
	viewPlaceholder:getParent():addChildAt(simpleClipping, viewZOrder)
	self.pagedView = pagedView
	self.tabs:onTabClicked(self.defaultIndex);

	tabsPlaceholder:removeFromParentAndCleanup(true)
	viewPlaceholder:removeFromParentAndCleanup(true)

end

function MarketPanel:showConsumeHistory()
	ConsumeHistoryPanel:create():popout()
end

function MarketPanel:isHappyCoinsTab(index)
	for i,v in ipairs(self.config.tabs) do
		if v.pageIndex == index then
			return v.tabId == TabsIdConst.kHappyeCoin;
		end
	end

	return false;
end

function MarketPanel:gotoTabPage(index)
	local function buildProductPage()
		if self.isDisposed then return end
		self.happyCoinNetworkTip:setVisible(false)
		if __ANDROID then self:buildAndroidGoldPage()
		else self:buildIOSGoldPage() end
	end

	local isHappyCoinsTab = self:isHappyCoinsTab(index);
	self.iosPaymentTip:setVisible(isHappyCoinsTab and __IOS);
	self.linkBtnHistory:setVisible(isHappyCoinsTab and MaintenanceManager:getInstance():isEnabled("ConsumeDetailPanel"));
	self.buyGoldButton:setVisible(not isHappyCoinsTab);

	PlatformConfig:setCurrentPayType()
	if isHappyCoinsTab then
		if (__IOS and not self.goldPageBuilt) or not MarketManager:sharedInstance().productItems or
			not MarketManager:sharedInstance().gotRemoteList then
			self.happyCoinNetworkTip:setVisible(true)
			MarketManager:sharedInstance():getGoldProductInfo(buildProductPage);
		elseif not self.goldPageBuilt then
			buildProductPage()
		end
	end
end

function MarketPanel:slideToPage(index)
	if self.view then self.view:gotoPage(index) end
end

function MarketPanel:buildPageByTabId(tabId)
	local layout = nil
	local v_tab = nil
	for k, v in pairs(self.config.tabs) do 
		if v.tabId == tabId then
			v_tab = v
			break
		end
	end

	local function getHappyCoinsItem(goodID)
		local productItems = MarketManager:sharedInstance().productItems;
		for i,v in ipairs(productItems) do
			if v.productId == goodID then
				return v;
			end
		end

		return nil;
	end

	local marketGoods = {}
	print("v_tab.goodsIds: ", #v_tab.goodsIds);	

	for k_goods, v_goods in pairs(v_tab.goodsIds) do
		local item = MetaManager:getInstance():getGoodMeta(v_goods)
		if not item then 
			item = getHappyCoinsItem(v_goods)
		end
		--print(table.tostring(item))
		if item and ( (not __IOS_FB) or (__IOS_FB and item.platform ~= 1) ) then -- 非PC独有的商品
			table.insert(marketGoods, item)
		end
	end

	if tabId == TabsIdConst.kHappyeCoin then --this is the tab for buying happycoinsbuildtab
		-- do nothing.
	elseif (not __IOS_FB and tabId == 0) or (__IOS_FB and tabId == 3) then -- special treatment
		layout = VerticalTileLayout:create(self.viewRect.size.width)
		layout:setItemHorizontalMargin(8) -- hard coded margin
		for k, v in pairs(marketGoods) do 
			local item = MarketPackItem:create(v.id)
			item:setParentView(self.view)
			layout:addItem(item)
			-- print('bounds', item:getGroupBounds())
		end

	else -- default 
		layout = GridLayout:create()
		
		layout:setColumn(4)
		layout:setWidth(self.viewRect.size.width)
		layout:setItemSize(CCSizeMake(0, 220))
		layout:setColumnMargin(0)
		layout:setRowMargin(20)

		for k, v in pairs(marketGoods) do 
			local item = MarketPropsItem:create(v.id)
			item:setParentView(self.view)
			layout:addItem(item)
			item:setScale(0.92)
			-- print('bounds', item:getGroupBounds())
		end
	end
	return layout
end

function MarketPanel:buildIOSGoldPage()
	if self.goldPageBuilt then return end
	self.goldPageBuilt = true
	local config = MarketManager:sharedInstance():getCoinsTab()
	local scroll = VerticalScrollable:create(self.viewRect.size.width, self.viewHeight, false, false)
	local layout = VerticalTileLayout:create(self.viewRect.size.width)
	layout:setItemHorizontalMargin(4)

	local d = 0	
	for k, v in ipairs(config) do
		local function updateCashLabel()
			if self.isDisposed then return end
			self.cashAmountTxt:setString(UserManager:getInstance().user:getCash());
		end
		local item = BuyGoldItem:create(v, updateCashLabel)
		item:setParentView(scroll)

		if v.id == 8 then 
			item:setGoldIconVisiable(-1)
			d = d + 1
		elseif v.id == 9 then 
			item:setGoldIconVisiable(0)
			d = d + 1
		else
			item:setGoldIconVisiable(k - d)
		end
		layout:addItem(item)
	end
	scroll:setContent(layout)
	scroll:setIgnoreHorizontalMove(false)
	self.happycoinsPage:addChild(scroll)
end

function MarketPanel:buildAndroidGoldPage()
	if self.goldPageBuilt then return end
	self.goldPageBuilt = true
	local tables = MarketManager:sharedInstance().productItems
	local num = #tables
	for k, v in ipairs(tables) do
		if not v.enabled then num = num - 1 end
	end
	local titles, lists, posIndex = {}, {}, 1
	for k, v in ipairs(tables) do
		print("got list", v.name, v.enabled, #v)
		if v.enabled then
			self.builder = InterfaceBuilder:createWithContentsOfFile(PanelConfigFiles.market_panel)
			local title = self.builder:buildGroup("marketpanel_buygoldpagetitle")
			local titleSize = title:getGroupBounds().size
			local text = title:getChildByName("text")
			text:setString(Localization:getInstance():getText("market.panel.buy.gold.title."..tostring(v.name)))
			local arrr = title:getChildByName("arrr")
			arrr:setVisible(false)
			title.arrr = arrr
			local arrd = title:getChildByName("arrd")
			arrd:setVisible(false)
			title.arrd = arrd
			-- local iconPH = title:getChildByName("icon")
			-- iconPH:setVisible(false)
			-- local newIcon
			-- local iconSrc = self.builder:buildGroup("marketpanel_platformlogos")
			-- local newIcon = iconSrc:getChildByName(v.name)
			-- if newIcon then
			-- 	local phSize, nSize = iconPH:getGroupBounds().size, newIcon:getGroupBounds().size
			-- 	local deltaSize = {width = (phSize.width - nSize.width) / 2, height = (phSize.height / nSize.height) / 2}
			-- 	newIcon:setPositionXY(iconPH:getPositionX() + deltaSize.width, iconPH:getPositionY() + deltaSize.height)
			-- 	local index = iconPH:getParent():getChildIndex(iconPH)
			-- 	newIcon:removeFromParentAndCleanup(false)
			-- 	iconPH:getParent():addChildAt(newIcon, index)
			-- else text:setPositionX(iconPH:getPositionX()) end
			-- iconSrc:dispose()
			title:setPositionX((self.viewRect.size.width - titleSize.width) / 2)
			title.expandY = (posIndex - 1) * (-titleSize.height)
			title:setPositionY(title.expandY)
			title.hideY = (num - posIndex + 1) * titleSize.height - self.viewHeight
			self.happycoinsPage:addChild(title)
			table.insert(titles, title)
			title.name = #titles
			local scroll = VerticalScrollable:create(self.viewRect.size.width, self.viewHeight - num * titleSize.height - 10, true, false)
			local layout = VerticalTileLayout:create(self.viewRect.size.width)
			layout:setItemHorizontalMargin(4)
			local items = {}
			for k, v in ipairs(v) do
				local function updateCashLabel()
					if self.isDisposed then return end
					self.cashAmountTxt:setString(UserManager:getInstance().user:getCash());
				end
				local item = BuyGoldItem:create(v, updateCashLabel)
				item:setParentView(scroll)
				item:setGoldIconVisiable(k)
				layout:addItem(item)
				table.insert(items, item)
			end
			scroll:setContent(layout)
			scroll:setIgnoreHorizontalMove(false)
			scroll:setPositionY(title.expandY - titleSize.height - 5)
			self.happycoinsPage:addChild(scroll)
			scroll.items = items
			table.insert(lists, scroll)
			scroll.name = #lists
			posIndex = posIndex + 1
		end
	end

	local function onTitleTapped(evt)
		local index = tonumber(evt.target.name)
		print("onTitleTapped", index)
		if #lists[index].items <= 0 then
			CommonTip:showTip(Localization:getInstance():getText("market.panel.buy.gold.no.network"))
			return
		end
		for k, v in ipairs(titles) do
			if k == index then
				v:setPositionY(v.expandY)
				v.arrr:setVisible(false)
				v.arrd:setVisible(true)
				v:setTouchEnabled(false)
			elseif k < index then
				v:setPositionY(v.expandY)
				v.arrr:setVisible(true)
				v.arrd:setVisible(false)
				v:setTouchEnabled(true)
			elseif k > index then
				v:setPositionY(v.hideY)
				v.arrr:setVisible(true)
				v.arrd:setVisible(false)
				v:setTouchEnabled(true)
			end
		end
		for k, v in ipairs(lists) do
			if k == index then
				v:setVisible(true)
				for k, v in ipairs(v.items) do v:enableClick() end
			else
				v:setVisible(false)
				for k, v in ipairs(v.items) do v:disableClick() end
			end
		end
	end
	for k, v in ipairs(titles) do
		v:setTouchEnabled(true)
		if not v:hasEventListener(DisplayEvents.kTouchTap, onTileTapped) then
			v:addEventListener(DisplayEvents.kTouchTap, onTitleTapped)
		end
	end
	print("title length", #titles)
	onTitleTapped({target = titles[1]})
end

function MarketPanel:updateCoinLabel()
	self.cashAmountTxt:setString(UserManager:getInstance():getUserRef():getCash())
	self:dispatchEvent(Event.new(kPanelEvents.kUpdate, nil, self))
end

function MarketPanel:onBuyGoldButtonTap()
	self.tabs:onTabClicked(3);
end

function MarketPanel:popout()

	if not self.privateScene then
		self.privateScene = Scene:create()
		self.privateScene.onKeyBackClicked = function ()
			-- print('onKeyBackClicked')
			if not self.isDisposed then
				self:onCloseBtnTapped()
			end
		end
	end
	local drt = Director:sharedDirector()
	drt:pushScene(self.privateScene)

	local vo = drt:getVisibleOrigin()
	local vs = drt:getVisibleSize()
	self:setPosition(ccp(vo.x, vo.y + vs.height))
	self.privateScene:addChild(self)
	self.allowBackKeyTap = true
end

function MarketPanel:onCloseBtnTapped()

	-- print('onCloseBtnTapped')
	if self.privateScene then
		self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self))
		Director:sharedDirector():popScene()
		self.allowBackKeyTap = false
		self.privateScene = nil
	end


	local home = HomeScene:sharedInstance()
	if home then home:updateFriends() end
end


BuyObserver = class()
local _buyObserver = nil

function BuyObserver:sharedInstance()
	if not _buyObserver then
		_buyObserver = BuyObserver:create()
	end
	return _buyObserver
end

function BuyObserver:create()
	local instance = BuyObserver.new()
	return instance
end

function BuyObserver:setMarketPanelRef(ref)
	self.marketPanelRef = ref
end

function BuyObserver:onBuySuccess()
	if self.marketPanelRef and not self.marketPanelRef.isDisposed then
		self.marketPanelRef:updateCoinLabel()
	end
	local scene = HomeScene:sharedInstance()
	local button = scene.goldButton
	button:setGoldNumber(UserManager:getInstance():getUserRef():getCash())
	button:updateView()
end



-------------------------------------------------------------------------
-- Class MarketPanelTab
-------------------------------------------------------------------------

MarketPanelTab = class(BaseUI)

function MarketPanelTab:create(config, beforeGotoPage, afterGotoPage)
	local instance = MarketPanelTab.new()
	instance:loadRequiredResource(PanelConfigFiles.market_panel)
	instance:init(config,beforeGotoPage,afterGotoPage)
	return instance
end

function MarketPanelTab:loadRequiredResource(config)
	self.builder = InterfaceBuilder:create(config)
end

function MarketPanelTab:init(config, beforeGotoPage, afterGotoPage)
	local ui = self.builder:buildGroup('market_tabs')
	-- print(ui)
	BaseUI.init(self, ui)
	-- print(table.tostring(config))
	-- local config = {
	-- 	{tabId = 1, pageIndex = 1, key = '礼包'},
	-- 	{tabId = 1, pageIndex = 1, key = '礼包'},
	-- 	{tabId = 1, pageIndex = 1, key = '礼包'},
	-- }

	self.animDuration = 0.25

	self.beforeGotoPage = beforeGotoPage;
	self.afterGotoPage = afterGotoPage;
	self.config = config
	self.colorConfig = {
		normal = ccc3(157, 116, 75),
		focus = ccc3(243, 93, 99)
	}

	self.curIndex = 1

	self.tabs = {}
	local count = #config

	local function _tapHandler(event)
		local index = tonumber(event.context)
		self:onTabClicked(index)
	end

	for i=1, count do
		local tab = ui:getChildByName('market_tabButton'..i)
		tab.txt = tab:getChildByName('txt')
		tab.locator = tab:getChildByName('arrowLocator')
		tab.locator:setVisible(false)
		tab.rect = tab:getChildByName('rect')
		tab.rect:setVisible(false)
		tab.txt:setString(Localization:getInstance():getText(config[i].key))
		tab:ad(DisplayEvents.kTouchTap, _tapHandler, config[i].pageIndex)
		tab:setTouchEnabled(true, 0, true)
		tab:setButtonMode(false)
		tab.normalPos = ccp(tab.txt:getPositionX(), tab.txt:getPositionY())
		tab.focusPos = ccp(tab.txt:getPositionX() , tab.txt:getPositionY() + 15)
		tab.iconLimit = tab:getChildByName('iconLimit');
		local textLimit = tab.iconLimit:getChildByName("tfLimit"):getChildByName("text");
		textLimit:setString(Localization:getInstance():getText("market.panel.timeLimited"));
		tab.iconLimit:setVisible(config[i].isTimeLimited);
		table.insert(self.tabs, tab)
	end

	-------------------------------------------
	-- center tabs positions
	--
	local length = ui:getGroupBounds().size.width
	for k, v in pairs(self.tabs) do
		v:setPositionX(length * k / (count + 1))
	end

	for i=count+1, 5 do
		local tab = ui:getChildByName('market_tabButton'..i)
		tab:removeFromParentAndCleanup(true)
		-- tab:setVisible(false)
	end

	self.arrow = ui:getChildByName('market_tabArrow')

	--self:goto(1)
end

function MarketPanelTab:setView(view)
	self.view = view
end

function MarketPanelTab:next()
	if self.curIndex == #self.config then return end
	self:goto(self.curIndex + 1)
end

function MarketPanelTab:prev()
	if self.curIndex == 1 then return end
	self:goto(self.curIndex - 1)
end

function MarketPanelTab:goto(index)
	local count = #self.config
	if not index or type(index) ~= 'number' or index > count or index < 1 then
		return 
	end
	local curTab = self.tabs[self.curIndex]
	local nextTab = self.tabs[index]
	if curTab then
		curTab.txt:stopAllActions()
		curTab.txt:runAction(self:_getTabLooseFocusAnim(curTab))
	end
	local function onAnimationFinish()
		if self.afterGotoPage then
			self.afterGotoPage(index);
			--to make sure that the afterGotoPage can only be called once.
			--self.afterGotoPage = nil;
		end
	end

	if nextTab then 
		nextTab.txt:stopAllActions()
		local actions = CCSequence:createWithTwoActions(self:_getTabOnFocusAnim(nextTab), CCCallFunc:create(onAnimationFinish))
		nextTab.txt:runAction(actions);
	end
	if self.arrow then
		self.arrow:stopAllActions()
		self.arrow:runAction(self:_getArrowAnim(index))
	end
	self.curIndex = index
end

function MarketPanelTab:onTabClicked(index)
	if self.beforeGotoPage then
		self.beforeGotoPage(index);
	end
	if self.view then self.view:gotoPage(index) end

	--[[if self.afterGotoPage then
		self.afterGotoPage(index);
	end]]--
end

function MarketPanelTab:_getArrowAnim(index)
	local tab = self.tabs[index]
	if tab then 
		local pos = tab.locator:getPosition()
		local worldPos = tab:convertToWorldSpace(ccp(pos.x, pos.y))
		local realPos = tab:getParent():convertToNodeSpace(ccp(worldPos.x, worldPos.y))
		local move = CCMoveTo:create(self.animDuration, ccp(realPos.x, realPos.y))
		local ease = CCEaseSineOut:create(move)
		return ease
	end
	return nil
end

function MarketPanelTab:_getTabOnFocusAnim(tab)
	if not tab then return nil end
	local tint = CCTintTo:create(self.animDuration, self.colorConfig.focus.r, self.colorConfig.focus.g, self.colorConfig.focus.b)
	local scale = CCScaleTo:create(self.animDuration, 34/28)
	local move = CCMoveTo:create(self.animDuration, tab.focusPos)
	local array = CCArray:create()
	array:addObject(tint)
	array:addObject(scale)
	array:addObject(move)
	local spawn = CCEaseSineOut:create(CCSpawn:create(
	                  array
	                             ))
	return spawn
end

function MarketPanelTab:_getTabLooseFocusAnim(tab)
	if not tab then return nil end
	local tint = CCTintTo:create(self.animDuration, self.colorConfig.normal.r, self.colorConfig.normal.g, self.colorConfig.normal.b)
	local scale = CCScaleTo:create(self.animDuration, 1)
	local move = CCMoveTo:create(self.animDuration, tab.normalPos)
	local array = CCArray:create()
	array:addObject(tint)
	array:addObject(scale)
	array:addObject(move)
	local spawn = CCEaseSineOut:create(CCSpawn:create(
	                  array
	                             ))
	return spawn
end