
require "zoo.panel.basePanel.BasePanel"
require "hecore.ui.PopoutManager"
require "zoo.data.MetaManager"
require "zoo.panelBusLogic.BuyLogic"
require "zoo.net.Http"
require "zoo.baseUI.ButtonWithShadow"
require "zoo.baseUI.BuyAndContinueButton"
require "zoo.panel.RequireNetworkAlert"
require "zoo.panel.basePanel.panelAnim.IconPanelShowHideAnim"
require "zoo.panel.MarkPrisePanel"
require "zoo.panel.MarkEnergyNotiPanel"

MarkPanel = class(BasePanel)

function MarkPanel:create(scaleOriginPosInWorld, ...)
	assert(scaleOriginPosInWorld)
	assert(#{...} == 0)

	local panel = MarkPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_mark)
	if panel:init(scaleOriginPosInWorld) then
		print("return true, panel should been shown")
		return panel
	else
		print("return false, panel's been destroyed")
		panel = nil
		return nil
	end
end

function MarkPanel:dispose()
	self.markCallback = nil
	self:removeListeners()
	BasePanel.dispose(self)
end

function MarkPanel:init(scaleOriginPosInWorld, ...)
	-- 数据初始化
	self.uid = 0
	self.addNum = 0
	self.markNum = 0
	self.markTime = 0
	self.createTime = 0
	self.tipTarget = nil
	self.signDay = 0
	self.canSign = false
	self.resignCount = 0
	self.signedDay = 0

	self.scaleOriginPosInWorld = scaleOriginPosInWorld

	-- 获取数据
	self.markRewards = MetaManager:getInstance().mark
	self.userMark = UserManager:getInstance().mark
	self.fillSign = MetaManager:getInstance().global.fillSign

	-- 建立窗口UI和初始化
	self.ui = self:buildInterfaceGroup("MarkPanel")
	BasePanel.init(self, self.ui)
	self.ui:setTouchEnabled(true, 0, true)

	-- 获取控件
	self.captain = self.ui:getChildByName("captain")
	self.remark = self.ui:getChildByName("remark")
	self.mark = self.ui:getChildByName("mark")
	self.leave = self.ui:getChildByName("leave")
	self.countDown = self.ui:getChildByName("countDown")
	self.clear = self.ui:getChildByName("clear")
	self.backgroud = self.ui:getChildByName("_bg")
	self.notSigned = {}
	self.tnos = self.ui:getChildByName("notSigned")
	for i = 1, 30 do
		local node = self.tnos:getChildByName("node"..#self.notSigned)
		table.insert(self.notSigned, node)
		node.name = #self.notSigned
	end
	self.signed = {}
	self.ts = self.ui:getChildByName("signed")
	for i = 1, 30 do
		local node = self.ts:getChildByName("node"..#self.signed)
		table.insert(self.signed, node)
		node.name = #self.signed
	end
	self.position = {}
	self.pos = self.ui:getChildByName("position")
	for i = 1, 31 do
		local node = self.pos:getChildByName("day"..#self.position)
		table.insert(self.position, node)
		node.name = #self.position
	end
	self.pos:setVisible(false)
	self.nodeOrigin = self.ts:getChildByName("nodeOrigin")
	self.now = self.ui:getChildByName("now")
	self.head = self.now:getChildByName("sprite"):getChildByName("head")
	self.close = self.ui:getChildByName("close")
	self.priseButton = self.ui:getChildByName("priseButton")
	self.priseButtonImg = self.priseButton:getChildByName("img")
	self.priseButtonTimer = self.priseButton:getChildByName("timer")
	self.mark = GroupButtonBase:create(self.mark)
	self.leave = GroupButtonBase:create(self.leave)
	self.remark = ButtonIconNumberBase:create(self.remark)
	self.remark:setIconByFrameName("ui_images/ui_image_coin_icon_small0000", true)
	self.remark:setColorMode(kGroupButtonColorMode.blue)
	self.head:setVisible(false)


	-- 设置文字、占位符（需要更新本地化文件）
	self.remark:setString(Localization:getInstance():getText("mark.panel.remark.btn.text"))
	self.mark:setString(Localization:getInstance():getText("mark.panel.mark.btn.text"))
	self.clear:setString(Localization:getInstance():getText("mark.panel.clear.label"))
	self.mark:setString(Localization:getInstance():getText("mark.panel.mark.btn.text"))
	self.leave:setString(Localization:getInstance():getText("mark.panel.close.btn.text"))
	-- 替换标题
	local charWidth = 65
	local charHeight = 65
	local charInterval = 57
	local fntFile = "fnt/caption.fnt"
	if _G.useTraditionalChineseRes then fntFile = "fnt/zh_tw/caption.fnt" end
	local position = self.captain:getPosition()
	self.newCaptain = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	self.newCaptain:setAnchorPoint(ccp(0,1))
	self.newCaptain:setString(Localization:getInstance():getText("mark.panel.title"))
	self.newCaptain:setPosition(ccp(position.x, position.y))
	self.ui:addChildAt(self.newCaptain, 3)
	self.newCaptain:setToParentCenterHorizontal()
	self.captain:removeFromParentAndCleanup(true)

	-- 设置互动事件监听
	local function onExitTouch()
		self:onCloseBtnTapped()
	end
	local function onMarkTouch()
		self:markNew()
	end
	self.mark:ad(DisplayEvents.kTouchTap, onMarkTouch)
	self.mark:useBubbleAnimation()

	self.leave:ad(DisplayEvents.kTouchTap, onExitTouch)
	self.leave:useBubbleAnimation()

	self.leave:setVisible(false)
	self.close:setTouchEnabled(true)
	self.close:setButtonMode(true)
	self.close:ad(DisplayEvents.kTouchTap, onExitTouch)

	local function onRemarkTouch()
		if self.remarkTip and not self.remarkTip.isDisposed then
			self.remarkTip:clear()
			self.remarkTip = nil
		end
		if self:remarkNew() then
		end
	end
	if self.remark then self.remark:ad(DisplayEvents.kTouchTap, onRemarkTouch) end

	local function getTouchedNode(globalPos)
		local childrenList = self.tnos:getChildrenList()
		for __, v in pairs(childrenList) do
			if v:hitTestPoint(globalPos, true) and v:isVisible() then return v end
		end
	end
	local function onNodeTouch(evt)
		local node = getTouchedNode(evt.globalPosition)
		local posAdd = self.tnos:getPosition()
		if not node then return end
		local rest = tonumber(node.name) - self.signedDay
		local text = Localization:getInstance():getText("mark.panel.tip.title", {mark_number = rest})
		local found = false
		for k, v in ipairs(self.markRewards[node.name].rewards) do
			if v.itemId == 10039 then found = true break end
		end
		local tipPanel
		if found then tipPanel = BoxRewardTipPanel:create(self.markRewards[node.name],
			Localization:getInstance():getText("mark.panel.tip.bottom", {n = '\n'}))
		else tipPanel = BoxRewardTipPanel:create(self.markRewards[node.name]) end
		tipPanel:setTipString(text)
		self:addChild(tipPanel)

		local originSize = node:getContentSize()
		local enlargeRestoreAction = EnlargeRestore:create(node, originSize, 1.25, 0.1, 0.1)
		if node:numberOfRunningActions() == 0 then
			node:runAction(enlargeRestoreAction)
		end

		local tappedBoxPos = node:getPosition()
		local tappedBoxPosInWorldPos = self.ui:convertToWorldSpace(ccp(tappedBoxPos.x, tappedBoxPos.y))

		local tappedBoxSize = node:getGroupBounds().size
		tappedBoxPosInWorldPos.x 	= tappedBoxPosInWorldPos.x + tappedBoxSize.width / 2
		tappedBoxPosInWorldPos.y	= tappedBoxPosInWorldPos.y - tappedBoxSize.height / 2

		tipPanel:setArrowPointPositionInWorldSpace(tappedBoxSize.width/2, tappedBoxPosInWorldPos.x + posAdd.x, tappedBoxPosInWorldPos.y + posAdd.y)
	end
	self.tnos:setTouchEnabled(true)
	self.tnos:ad(DisplayEvents.kTouchTap, onNodeTouch)

	local function onPriseTimer(evt)
		if self.isDisposed then return end
		local time = evt.data
		if type(time) ~= "number" or time <= 0 then
			self.priseButton:setVisible(false)
		else
			self.priseButton:setVisible(true)
			self.priseButtonTimer:setText(string.format("%02d:%02d:%02d", tostring(math.floor(time / 3600)), tostring(math.floor(time % 3600 / 60)), tostring(math.floor(time % 60))))
			local size = self.priseButtonTimer:getContentSize()
			self.priseButtonTimer:setPositionX((self.priseButtonSize.width - size.width) / 2)
		end
	end
	self.priseButtonSize = self.priseButtonImg:getGroupBounds().size
	self.priseButtonSize = {width = self.priseButtonSize.width, height = self.priseButtonSize.height}
	MarkModel:getInstance():addEventListener(kMarkEvents.kPriseTimer, onPriseTimer)
	self.removeListeners = function(self)
		MarkModel:getInstance():removeEventListener(kMarkEvents.kPriseTimer, onPriseTimer)
	end
	local index, time = MarkModel:getInstance():getCurrentIndexAndTime()
	if index ~= 0 then
		self.priseButtonTimer:setText(string.format("%02d:%02d:%02d", tostring(math.floor(time / 3600)), tostring(math.floor(time % 3600 / 60)), tostring(math.floor(time % 60))))
		local size = self.priseButtonTimer:getContentSize()
		self.priseButtonTimer:setPositionX((self.priseButtonSize.width - size.width) / 2)
	else
		self.priseButton:setVisible(false)
	end
	local function onPriseTapped(evt)
		-- close remark tip
		if self.remarkTip and not self.remarkTip.isDisposed then
			self.remarkTip:clear()
			self.remarkTip = nil
		end
		-- show mark prise panel
		local index = MarkModel:getInstance():getCurrentIndexAndTime()
		if index and not index ~= 0 then
			local panel = MarkPrisePanel:create(tonumber(index))
			if panel then
				self.markPriseShown = true
				local function onReleasePrise()
					self.markPriseShown = false
				end
				panel:addEventListener(kPanelEvents.kClose, onReleasePrise)
				panel:popout()
			end
		end
	end
	self.priseButton:setTouchEnabled(true)
	self.priseButton:addEventListener(DisplayEvents.kTouchTap, onPriseTapped)


	-- 刷新数据
	self:updateProfile()
	self:refreshData(true)
	self:playNearestBoxAnimation()

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
	self.showHideAnim = IconPanelShowHideAnim:create(self, self.scaleOriginPosInWorld)

	return true
end

function MarkPanel:onCloseBtnTapped()
	local function onHideAnimFinished()
		--PopoutManager:sharedInstance():remove(self)
		PopoutManager:sharedInstance():removeWithBgFadeOut(self, false, true)
	end
	-- fix
	if GameGuide then
		GameGuide:sharedInstance():onPopdown(self)
	end
	-- end fix
	self.allowBackKeyTap = false
	self.showHideAnim:playHideAnim(onHideAnimFinished)
	if self.remarkTip and not self.remarkTip.isDisposed then
		self.remarkTip:clear()
		self.remarkTip = nil
	end
end

function MarkPanel:updateProfile()
	local profile = UserManager.getInstance().profile
	if profile and profile.headUrl ~= self.headUrl then
		if self.clipping then self.clipping:removeFromParentAndCleanup(true) end
		local framePos = self.head:getPosition()
		local frameSize = self.head:getGroupBounds().size
		local function onImageLoadFinishCallback(clipping)
			if self.isDisposed then return end
			local clippingSize = clipping:getContentSize()
			clipping:setScaleX(frameSize.width / clippingSize.width)
			clipping:setScaleY(frameSize.height / clippingSize.height)
			clipping:setPosition(ccp(framePos.x + frameSize.width / 2 , framePos.y - frameSize.height / 2))
			self.now:getChildByName("sprite"):addChild(clipping)
			self.clipping = clipping
			self.headUrl = profile.headUrl
			-- clipping:setPosition(ccp(6, 23))
			-- clipping:setScale(0.83)
			-- clipping:setAnchorPoint(ccp(-0.5, -0.5))
			-- self.now:addChild(clipping)
			-- self.clipping = clipping
			-- self.headUrl = profile.headUrl
		end
		HeadImageLoader:create(profile.uid, profile.headUrl,onImageLoadFinishCallback)
	end
end

function MarkPanel:refreshData(firstTime)
	self:setSignInfo()
	for i = 1, self.signedDay do
		self.notSigned[i]:setVisible(false)
		self.signed[i]:setVisible(true)
	end
	for i = self.signedDay + 1, #self.signed do
		self.signed[i]:setVisible(false)
		self.notSigned[i]:setVisible(true)
	end
	local target
	target = self.position[self.signedDay + 1]
	local nodePos = target:getPosition()
	local pos = ccp(nodePos.x, nodePos.y)
	local posAdd = self.pos:getPosition()
	pos.x, pos.y = pos.x + posAdd.x, pos.y + posAdd.y
	self.now:setPosition(ccp(pos.x, pos.y))
	self.countDown:setString(31 - self.signDay)
	self.remark:setNumber(self.fillSign[self.addNum + 1])
	if self.resignCount <= 0 then self.remark:setVisible(false) end
	self.mark:setVisible(true)
	self.leave:setVisible(false)

	if self.canSign then
		self.remark:setVisible(false)
	else
		self:btnSignToExit()
	end
end

function MarkPanel:setMarkCallback(callback)
	self.markCallback = callback
end

function MarkPanel:btnSignToExit()
	self.mark:setVisible(false)
	self.leave:setVisible(true)
end

function MarkPanel:markNew()
	if self.markPriseShown then return end
	self:refreshData()
	if not self.canSign then
		CommonTip:showTip(Localization:getInstance():getText("mark.panel.cant.mark"), "negative")
		return
	end
	local function onSuccess(evt)
		self.mark:setEnabled(false)
		self.remark:setEnabled(false)
		self.signedDay = self.signedDay + 1
		if self.resignCount > 0 then
			self.remark:setVisible(true)
		end
		local function onAnimOver()
			self.remark:setEnabled(true)
			self.mark:setEnabled(true)
			self:playNearestBoxAnimation()
		end
		self:updateANewMark(onAnimOver)
		self:btnSignToExit()
		self:checkAndPlayRemarkTip()
		if self.markCallback then
			self.markCallback()
		end
		MarkModel:getInstance():setGetRewardNotification()
	end
	local function onFail(evt)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..evt.data), "negative")
	end

	if RequireNetworkAlert:popout() then
		local http = MarkHttp.new(true)
		http:ad(Events.kComplete, onSuccess)
		http:ad(Events.kError, onFail)
		http:load()
	end
end

function MarkPanel:updateANewMark(finishCallback)
	self:getReward()
	if self.isDisposed then return end
	self:playRewardAnim()
	local nodePos = self.position[self.signedDay + 1]:getPosition()
	local pos = ccp(nodePos.x, nodePos.y)
	local posAdd = self.pos:getPosition()
	pos.x, pos.y = pos.x + posAdd.x, pos.y + posAdd.y
	
	local function onFinish()
		if finishCallback then
			finishCallback()
		end
	end
	self.now:stopAllActions()
	self.now:runAction(CCSequence:createWithTwoActions(
		CCMoveTo:create(0.3, ccp(pos.x, pos.y)),
		CCCallFunc:create(onFinish)))
	if self.markRewards[self.signedDay].type == 2 then
		self:playBoxOpen(self.signedDay)
	else
		self.signed[self.signedDay]:setVisible(true)
		self.notSigned[self.signedDay]:setVisible(false)
	end
end

function MarkPanel:getReward()
	local reward = self.markRewards[self.signedDay].rewards
	local rType = self.markRewards[self.signedDay].type
	local rGoods = self.markRewards[self.signedDay].goodsId
	local manager = UserManager:getInstance()
	local user = manager.user

	local function addCoin(num)
		local money = user:getCoin()
		DcUtil:logCreateCoin("mark", num, money, -1)
		money = money + num
		user:setCoin(money)
		DcUtil:logCreateCoin("mark", num, user:getCoin(), -1)
	end

	local function addGold(num)
		local money = user:getCash()
		money = money + num
		user:setCash(money)
		DcUtil:logCreateCash("mark", num, user:getCash(), -1)
	end

	if rType == 1 then
		addCoin(reward[1].num)
	elseif rType == 2 then
		for __, v in ipairs(reward) do
			if v.itemId == 2 then addCoin(v.num)
			elseif v.itemId == 14 then addGold(v.num)
			elseif v.itemId == 10039 then
				local logic = UseEnergyBottleLogic:create(ItemType.INFINITE_ENERGY_BOTTLE)
				logic:start(true)
			else
				manager:addUserPropNumber(v.itemId, v.num)
				DcUtil:logRewardItem("mark", v.itemId, v.num, -1)
			end
		end
	end

	if type(rGoods) == "number" then MarkModel:getInstance():addIndex(self.signedDay) end
end

function MarkPanel:playRewardAnim()
	local sSize = self.signed[self.signedDay]:getGroupBounds().size
	local home = HomeScene:sharedInstance()
	local reward = self.markRewards[self.signedDay].rewards
	local rType = self.markRewards[self.signedDay].type
	local rGoods = self.markRewards[self.signedDay].goodsId
	local pos = self.signed[self.signedDay]:getPosition()
	pos = self.signed[self.signedDay]:getParent():convertToWorldSpace(ccp(pos.x, pos.y))
	print(pos.x, pos.y)
	local vSize = Director:sharedDirector():getVisibleSize()
	home:checkDataChange()
	local function checkMarkPrise()
		if type(rGoods) == "number" then
			local panel = MarkPrisePanel:create(self.signedDay)
			self.markPriseShown = true
			local function onReleasePrise()
				self.markPriseShown = false
			end
			if panel then
				panel:addEventListener(kPanelEvents.kClose, onReleasePrise)
				panel:popout()
			end
		end
	end
	local callback = false
	if rType == 2 then
		local count = 0
		local width, spare = 60, 30
		local fullWidth = #reward * (width + spare) - spare
		local startPosX = pos.x - fullWidth / 2
		if startPosX < 0 then startPosX = 0
		elseif startPosX + fullWidth >= vSize.width then
			startPosX = pos.x - fullWidth
		end
		print(startPosX, fullWidth, vSize.width, startPosX + fullWidth)
		for __, v in ipairs(reward) do
			if v.itemId == 10039 then
				local x, y = self.position[29]:getPositionX(), self.position[29]:getPositionY()
				local position = self.pos:convertToWorldSpace(ccp(x, y))
				local panel = MarkGetEnergyNotiPanel:create(position, checkMarkPrise)
				callback = true
				panel:popout()
			else
				count = count + 1
				local sprite
				if v.itemId == 2 then sprite = home:createFlyingCoinAnim()
				elseif v.itemId == 14 then sprite = home:createFlyingGoldAnim()
				else sprite = home:createFloatingItemAnim(v.itemId) end
				sprite:setPosition(ccp(startPosX + sSize.width / 2 + (count - 1) * (width + spare),
					pos.y - sSize.height / 2 - 10))
				if not self.coinSize then self.coinSize = sprite:getGroupBounds().size end
				if v.itemId == 2 then
					local lPos = sprite:getPosition()
					sprite:setPosition(ccp(lPos.x - self.coinSize.width / 2, lPos.y + self.coinSize.height / 2))
				end
				sprite:playFlyToAnim(false, false)
			end
		end
	else
		local coins = home:createFlyingCoinAnim()
		if not self.coinSize then self.coinSize = coins:getGroupBounds().size end
		coins:setPosition(ccp(pos.x - self.coinSize.width / 3, pos.y + self.coinSize.height / 2))
		coins:playFlyToAnim(false, false)
	end
	if not callback then checkMarkPrise() end
end

function MarkPanel:playBoxOpen(index)
	local function BoxOpened()
		-- 这一段神奇的会造成坐标偏差，于是暂时把它注释掉了:-(
		-- local pos = self.signed[index]:getPosition()
		-- self.signed[index]:setAnchorPoint(ccp(0.5, -1))
		-- local size = self.signed[index]:getGroupBounds().size
		-- self.signed[index]:setPosition(ccp(pos.x, pos.y - size.height / 2))
		-- self.signed[index]:setSkewX(5)
		-- self.signed[index]:runAction(CCSkewTo:create(0.1, 0, 0))
		self.signed[index]:setVisible(true)
		self.notSigned[index]:setVisible(false)
	end
	local pos = self.notSigned[index]:getPosition()
	self.notSigned[index]:setAnchorPoint(ccp(0.5, -1))
	local size = self.notSigned[index]:getGroupBounds().size
	self.notSigned[index]:setPosition(ccp(pos.x + size.width / 2, pos.y - 2 * size.height))
	self.notSigned[index]:runAction(CCSequence:createWithTwoActions(CCSkewTo:create(0.2, -5, 0), CCCallFunc:create(BoxOpened)))
end

function MarkPanel:remarkNew()
	if self.markPriseShown then return end
	self:refreshData()
	if self.resignCount <= 0 then
		CommonTip:showTip(Localization:getInstance():getText("mark.panel.cant.remark"), "negative")
		return
	end
	local function onSuccess(evt)
		self.remark:setEnabled(false)
		self.signedDay = self.signedDay + 1
		local function onUpdateFinish() 
			self.remark:setEnabled(true) 
			self:playNearestBoxAnimation()
		end
		self:updateANewMark(onUpdateFinish)
		if self.isDisposed then return end
		self.resignCount = self.resignCount - 1
		if self.resignCount > 0 then
			self.addNum = self.addNum + 1
			self.remark:setNumber(self.fillSign[self.addNum + 1])
		else self.remark:setVisible(false) end
		local scene = HomeScene:sharedInstance()
		local button = scene.goldButton
		if button then button:updateView() end
		MarkModel:getInstance():setGetRewardNotification()
	end
	local function onFail(evt)
		self.remark:setEnabled(true)
		if evt.data == 730330 then	-- 没钱
			self:goldNotEnough()
		else
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(evt.data)), "negative")
		end
	end

	if RequireNetworkAlert:popout() then
		local logic = BuyLogic:create(15, 2)
		logic:getPrice()
		logic:start(1, onSuccess, onFail, nil, self.fillSign[self.addNum + 1])
	end
end

function MarkPanel:goldNotEnough()
	print("MarkPanel:goldNotEnough")
	local function createGoldPanel()
		print("createGoldPanel")
		local index = MarketManager:sharedInstance():getHappyCoinPageIndex()
		if index ~= 0 then
			local panel = createMarketPanel(index)
			panel:popout()
		end
	end
	local function askForGoldPanel()
		print("ask for gold panel")
		local text = {
			tip = Localization:getInstance():getText("buy.prop.panel.tips.no.enough.cash"),
			yes = Localization:getInstance():getText("buy.prop.panel.yes.buy.btn"),
			no = Localization:getInstance():getText("buy.prop.panel.not.buy.btn"),
		}
		CommonTipWithBtn:setShowFreeFCash(true)
		CommonTipWithBtn:showTip(text, "negative", createGoldPanel)
	end
	askForGoldPanel()
end

function MarkPanel:setSignInfo()
	local markModel = MarkModel:getInstance()
	markModel:calculateSignInfo()
	self.addNum = markModel.addNum
	self.canSign = markModel.canSign
	self.signDay = markModel.signDay
	self.signedDay = markModel.signedDay
	self.resignCount = markModel.resignCount
end

function MarkPanel:popout()
	-- fix
	if GameGuide then
		GameGuide:sharedInstance():onPopup(self)
	end
	-- end fix
	PopoutQueue.sharedInstance():push(self)
end

function MarkPanel:popoutShowTransition()
	self:setVisible(false)
	local function onAnimOver() self.allowBackKeyTap = true end
	local function onTransFinish()
		if self.signedDay <= 27 then
			local path = HeResPathUtils:getUserDataPath() .. "/marktip"
			local hFile, err = io.open(path, "r")
			if hFile and not err then
				io.close(hFile)
				onAnimOver()
				return
			end
			local x, y = self.position[29]:getPositionX(), self.position[29]:getPositionY()
			local position = self.pos:convertToWorldSpace(ccp(x, y))
			MarkEnergyNotiOncePanel:create(self, onAnimOver, position)
			Localhost:safeWriteStringToFile("", path)
		else onAnimOver() end
	end
	self.showHideAnim:playShowAnim(onTransFinish)
end

function MarkPanel:getHCenterInParentX(...)
	assert(#{...} == 0)

	-- Vertical Center In Screen Y
	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	-- local selfHeight	= self:getGroupBounds().size.height
	local selfWidth = 732 * self:getScale()

	local deltaWidth	= visibleSize.width - selfWidth
	local halfDeltaWidth	= deltaWidth / 2

	local vCenterInScreenX	= visibleOrigin.x + halfDeltaWidth

	-- Vertical Center In Parent Y
	local parent 		= self:getParent()
	local posInParent	= parent:convertToNodeSpace(ccp(vCenterInScreenX, 0))

	return posInParent.x
end

function MarkPanel:getVCenterInScreenY(...)
	assert(#{...} == 0) 

	local visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	local visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()
	local selfHeight	= 900 * self:getScale()

	local deltaHeight	= visibleSize.height - selfHeight
	local halfDeltaHeight	= deltaHeight / 2

	return visibleOrigin.y + halfDeltaHeight + selfHeight
end

function MarkPanel:playNearestBoxAnimation()
	local nearestBox = nil

	local tag = 13579
	-- stop the current
	if self.markRewards[self.signedDay] and self.markRewards[self.signedDay].type == 2 then
		self.notSigned[self.signedDay]:stopActionByTag(tag)
	end

	-- start the nearest
	for i=self.signedDay + 1, #self.signed do 
		if self.markRewards[i].type == 2 then
			nearestBox = self.notSigned[i]
			break
		end		
	end
	if not nearestBox then return end
	if nearestBox:getActionByTag(tag) == nil then
		local originSize = nearestBox:getContentSize()
		local anim = EnlargeRestore:create(nearestBox, originSize, 1.125, 1.5, 1.5)
		local delay = CCDelayTime:create(0.5)
		local action = CCRepeatForever:create(CCSequence:createWithTwoActions(anim, delay))
		action:setTag(tag)
		nearestBox:runAction(action)
	end
end

local needRemarkCount = {[0] = 1, [1] = 2, [2] = 3, [3] = 5}
function MarkPanel:checkAndPlayRemarkTip()
	if self.signDay <= 27 then return end
	local index, remarkCount, reward = 0, 0, 0
	local canSignDay = self.signedDay + 30 - self.signDay
	for i = canSignDay + 1, 30 do
		remarkCount = remarkCount + 1
		if self.markRewards[i].type == 2 then
			index = i
			reward = self.markRewards[i].packagePrice
			if type(reward) ~= "number" then reward = 0 end
			break
		end
	end
	if index == 0 then return end
	if not needRemarkCount[math.floor(index / 9)] then return end
	if remarkCount > needRemarkCount[math.floor(index / 9)] then return end
	local prise = 0
	for i = 1, remarkCount do prise = prise + self.fillSign[self.addNum + i] print("prise", prise) end
	if prise == 0 then return end
	local position = self.remark:getPosition()
	local size = self.remark:getGroupBounds().size
	local gPos = self.ui:convertToWorldSpace(ccp(position.x, position.y - size.height / 2))
	local layer = MarkRemindRemarkAnim:create(gPos, prise, reward)
	self.remarkTip = layer
	layer:popout()
end

MarkModel = class(EventDispatcher)

local instance = nil

function MarkModel:ctor()
	self.signDay = 0
	self.addNum = 0
	self.signedDay = 0
	self.resignCount = 0
	self.canSign = false
end

function MarkModel:getInstance()
	if not instance then
		instance = MarkModel.new()
		instance:init()
	end
	return instance
end

local timeSpan = 3600000
function MarkModel:init()
	self.schedule = nil
	self:readMarkPriseFile()
	if type(self.firstActivePrise) == "number" and self.firstActivePrise ~= 0 then
		local now = Localhost:time()
		local cycle = math.floor((now - self.firstActivePrise) / timeSpan)
		if type(self.priseIndex) == "table" then
			if cycle < 0 or cycle > #self.priseIndex then
				self.firstActivePrise = 0
				self.priseIndex = {}
			else
				self.firstActivePrise = self.firstActivePrise + cycle * timeSpan
				for i = 1, cycle do table.remove(self.priseIndex, 1) end
				local function onTimeout() self:refresh() end
				self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 1, false)
			end
		end
	end
	self.firstActivePrise = self.firstActivePrise or 0
	self.priseIndex = self.priseIndex or {}
	self:writeMarkPriseFile()
end

function MarkModel:calculateSignInfo()
	local userMark = UserManager:getInstance().mark
	local dayTime = 3600 * 24
	local cycleTime = 3600 * 24 * 30
	local createTime = userMark.createTime / 1000
	local nowTime = Localhost:time() / 1000
	local curCycle = math.floor((nowTime - createTime) / cycleTime)
	local curCycleBase = math.floor((nowTime - createTime) / cycleTime) * cycleTime + createTime
	self.signDay = math.ceil((nowTime - curCycleBase) / dayTime)
	local lastSignDay = math.floor((userMark.markTime / 1000 - createTime) / dayTime) * dayTime + createTime
	local lastSignCycle = math.floor((lastSignDay - createTime) / cycleTime)
	if curCycle ~= lastSignCycle then
		userMark.addNum = 0
		userMark.markNum = 0
	end
	self.addNum = userMark.addNum
	self.signedDay = userMark.markNum
	self.resignCount = self.signDay - self.signedDay
	self.canSign = (nowTime - lastSignDay) > dayTime
	if self.canSign then self.resignCount = self.resignCount - 1 end
end

function MarkModel:resetMarkInfo( )
	-- body
	local userMark = UserManager:getInstance().mark
	local dayTime = 1000 * 3600 * 24
	userMark.createTime = math.floor(Localhost:time() /dayTime) * dayTime
	userMark.addNum = 0
	userMark.markNum = 0
end

kMarkEvents = {
	kPriseTimer = "kMarkModelEvents.kPriseTimer",
	kPriseTimeOut = "kMarkModelEvents.kPriseTimeOut",
}

function MarkModel:refresh()
	local time = Localhost:time()
	local elapse = time - self.firstActivePrise
	if elapse > timeSpan then
		self:removeFirstIndex()
	end
	self:dispatchEvent(Event.new(kMarkEvents.kPriseTimer, (timeSpan - elapse) / 1000, self))
end

-- function MarkModel:addIndex(index)
-- 	if self.firstActivePrise == 0 then self.firstActivePrise = Localhost:time() end
-- 	table.insert(self.priseIndex, index)
-- 	self:writeMarkPriseFile()
-- 	if not self.schedule then
-- 		local function onTimeout() self:refresh() end
-- 		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 1, false)
-- 		self:dispatchEvent(Event.new(kMarkEvents.kPriseTimer, timeSpan / 1000, self))
-- 	end
-- end

-- modified, only one mark prise exist instead of a list
function MarkModel:addIndex(index)
	self.firstActivePrise = Localhost:time()
	self.priseIndex[1] = index
	self:writeMarkPriseFile()
	if not self.schedule then
		local function onTimeout() self:refresh() end
		self.schedule = Director:sharedDirector():getScheduler():scheduleScriptFunc(onTimeout, 1, false)
		self:dispatchEvent(Event.new(kMarkEvents.kPriseTimer, timeSpan / 1000, self))
	end
end

function MarkModel:getCurrentIndexAndTime()
	if self.firstActivePrise == 0 then return 0
	else
		local time = Localhost:time()
		return self.priseIndex[1], (timeSpan - time + self.firstActivePrise) / 1000
	end
end

function MarkModel:removeFirstIndex()
	self.firstActivePrise = Localhost:time()
	table.remove(self.priseIndex, 1)
	if #self.priseIndex <= 0 then
		self.firstActivePrise = 0
		if self.schedule then
			self:dispatchEvent(Event.new(kMarkEvents.kPriseTimer, 0, self))
			Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
			self.schedule = nil
		end
	end
	self:writeMarkPriseFile()
	self:dispatchEvent(Event.new(kMarkEvents.kPriseTimeOut), nil, self)
end

function MarkModel:removeIndex(index)
	for k, v in ipairs(self.priseIndex) do
		if tonumber(v) == tonumber(index) then
			if k == 1 then
				self:removeFirstIndex()
			else
				self.firstActivePrise = Localhost:time()
				table.remove(self.priseIndex, k)
				if #self.priseIndex <= 0 then
					self.firstActivePrise = 0
					if self.schedule then
						self:dispatchEvent(Event.new(kMarkEvents.kPriseTimer, 0, self))
						Director:sharedDirector():getScheduler():unscheduleScriptEntry(self.schedule)
						self.schedule = nil
					end
				end
				self:writeMarkPriseFile()
				self:dispatchEvent(Event.new(kMarkEvents.kPriseTimeOut), nil, self)
			end
			break
		end
	end
end

function MarkModel:readMarkPriseFile()
	local path = HeResPathUtils:getUserDataPath() .. "/markprise"
	local hFile, err = io.open(path, "r")
	local text
	if hFile and not err then
		text = hFile:read("*a")
		io.close(hFile)
		local function split(str, char)
    		local res = {}
   			string.gsub(str, "[^"..char.."]+", function(w) table.insert(res, w) end)
    		return res
		end
		local res = split(text, ",")
		if res[1] then self.firstActivePrise = tonumber(res[1]) end
		self.priseIndex = self.priseIndex or {}
		for k, v in ipairs(res) do
			if k ~= 1 then table.insert(self.priseIndex, v) end
		end
	end
end

function MarkModel:writeMarkPriseFile()
	local path = HeResPathUtils:getUserDataPath() .. "/markprise"
	local text = ""
	if self.firstActivePrise ~= 0 then
		text = text..tostring(self.firstActivePrise)..','
		for k, v in ipairs(self.priseIndex) do text = text..tostring(v)..','end
		text = string.sub(text, 1, -2)
	end
	Localhost:safeWriteStringToFile(text, path)
end

function MarkModel:setGetRewardNotification()
	if self.signedDay >= 26 and self.signedDay < 28 then
		local leftMarkTimesInThisPeriod = 30 - self.signDay -- 当前周期剩余的可以免费签到的次数
		local timesToGetFinalReward = 28 - self.signedDay -- 距离28天宝箱还需要签到的次数
		if leftMarkTimesInThisPeriod >= timesToGetFinalReward then
	        LocalNotificationManager.getInstance():setMarkRewardNotification(timesToGetFinalReward)
		end
	end

	if self.signedDay >= 27 and self.signedDay <= 28 then
		LocalNotificationManager.getInstance():cancelMarkNotificationToday()
	end
end

-- fix 
function MarkModel:onEnterHandler(event)
end
-- end fix
