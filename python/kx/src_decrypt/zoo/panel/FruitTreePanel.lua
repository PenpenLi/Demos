require "zoo.data.UserManager"
require "zoo.data.MetaManager"
require "zoo.panel.basePanel.BasePanel"
require "zoo.ui.ButtonBuilder"

FruitTreeTitlePanel = class(BasePanel)

function FruitTreeTitlePanel:create()
	local panel = FruitTreeTitlePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_fruit_tree)
	if not panel:_init() then panel = nil end
	return panel
end

function FruitTreeTitlePanel:_init()
	self.panel = self:buildInterfaceGroup("fruitTreeTitlePanel")
	BasePanel.init(self, self.panel)

	self.button = self.panel:getChildByName("button")
	self.buttonSprite = self.button:getChildByName("sprite")
	self.content = self.panel:getChildByName("content")
	self.captain = self.panel:getChildByName("captain")
	self.hitArea = self.panel:getChildByName("hit_area")


	self:scaleAccordingToResolutionConfig()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	self.size = self.hitArea:getGroupBounds().size
	self.size = {width = self.size.width, height = self.size.height}
	self:setPosition(ccp((vSize.width - self.size.width) / 2 + vOrigin.x, vSize.height + vOrigin.y))
	self.hitArea:removeFromParentAndCleanup(true)

	self.buttonSprite:setAnchorPointCenterWhileStayOrigianlPosition()
	self.buttonClicked = false

	self.captain:setText(Localization:getInstance():getText("fruit.tree.panel.title.captain"))
	self.content:setString(Localization:getInstance():getText("fruit.tree.panel.title.content"))
	self.button:getChildByName("text"):setString(Localization:getInstance():getText("fruit.tree.panel.title.rule"))

	-- center title
	local size = self.captain:getContentSize()
	self.captain:setPositionX((self.size.width / self:getScale() - size.width) / 2)

	local function onButton(evt)
		self.buttonClicked = not self.buttonClicked
		if self.buttonClicked then
			self.buttonSprite:stopAllActions()
			self.buttonSprite:runAction(CCRotateTo:create(0.2, 270))
			self.button:setTouchEnabled(false)
			local function onAnimFinish() self.button:setTouchEnabled(true) end
			self.button:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(onAnimFinish)))
		end
		self:dispatchEvent(Event.new(kPanelEvents.kButton, nil, self))
	end
	self.button:setTouchEnabled(true)
	self.button:addEventListener(DisplayEvents.kTouchTap, onButton)

	return true
end

function FruitTreeTitlePanel:onRulePanelRemove()
	self.buttonSprite:stopAllActions()
	self.buttonSprite:runAction(CCRotateTo:create(0.2, 90))
	self.button:setTouchEnabled(false)
	local function onAnimFinish() self.button:setTouchEnabled(true) end
	self.button:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.2), CCCallFunc:create(onAnimFinish)))
end

function FruitTreeTitlePanel:disableClick(disabled, isSkipClose)
	self.button:setTouchEnabled(not disabled)
end

function FruitTreeTitlePanel:getBottomY()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	return vSize.height + vOrigin.y - self.size.height 
end

function FruitTreeTitlePanel:onEnterHandler() end

FruitTreeBottomPanel = class(BasePanel)

function FruitTreeBottomPanel:create()
	local panel = FruitTreeBottomPanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_fruit_tree)
	if not panel:_init() then panel = nil end
	return panel
end

function FruitTreeBottomPanel:_init()
	self.buttonEnabled = true

	self.panel = self:buildInterfaceGroup("fruitTreeBottomPanel")
	BasePanel.init(self, self.panel)

	self.button = self.panel:getChildByName("button")
	local picked = self.panel:getChildByName("picked")
	self.pickText = self.panel:getChildByName("pickTxt")
	self.level = self.panel:getChildByName("level")
	self.extraValue = self.panel:getChildByName("extraValue")
	self.extraText = self.panel:getChildByName("extraTxt")
	self.hitArea = self.panel:getChildByName("hit_area")
	self.panelSize = self.hitArea:getGroupBounds().size
	self.panelSize = {width = self.panelSize.width, height = self.panelSize.height}
	self.picked = {}
	for i = 1, 6 do
		local icon = picked:getChildByName(tostring(i))
		table.insert(self.picked, icon)
	end
	self.button = GroupButtonBase:create(self.button)

	self:scaleAccordingToResolutionConfig()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	self.size = self.hitArea:getGroupBounds().size
	self:setPosition(ccp((vSize.width - self.size.width) / 2 + vOrigin.x, self.size.height + vOrigin.y))
	self.hitArea:removeFromParentAndCleanup(true)

	self.button:setString(Localization:getInstance():getText("fruit.tree.panel.bottom.button"))
	self.pickText:setString(Localization:getInstance():getText("fruit.tree.panel.bottom.pickTxt"))
	self.extraText:setString(Localization:getInstance():getText("fruit.tree.panel.bottom.extraTxt"))

	self:refresh()

	local function onButton(evt)
		self:dispatchEvent(Event.new(kPanelEvents.kButton, nil, self))
	end
	self.button:addEventListener(DisplayEvents.kTouchTap, onButton)

	return true
end

function FruitTreeBottomPanel:refresh()
	self.button:setEnabled(FruitTreePanelModel:sharedInstance():canUpgrade() and self.buttonEnabled)
	self.level:setText(Localization:getInstance():getText("fruit.tree.panel.bottom.level", {level = tostring(FruitTreePanelModel:sharedInstance():getTreeLevel())}))
	local size = self.level:getContentSize()
	self.level:setPositionX((self.panelSize.width - size.width) / 2 - 8)
	self.extraValue:setString(Localization:getInstance():getText("fruit.tree.panel.bottom.extraValue", {plus = tostring(FruitTreePanelModel:sharedInstance():getPlus())}))
	local pickCount = FruitTreePanelModel:sharedInstance():getPickCount()
	local pickedCount = FruitTreePanelModel:sharedInstance():getPicked()
	if pickCount < pickedCount then pickedCount = pickCount end
	for i = 1, pickCount - pickedCount do
		self.picked[i]:getChildByName("picked"):setVisible(true)
	end
	for i = pickCount - pickedCount + 1, 6 do
		self.picked[i]:getChildByName("picked"):setVisible(false)
	end
	for i = 1, pickCount do
		self.picked[i]:setVisible(true)
	end
	for i = pickCount + 1, 6 do
		self.picked[i]:setVisible(false)
	end
end

function FruitTreeBottomPanel:disableClick(disabled)
	self.buttonEnabled = not disabled
	self:refresh()
end

function FruitTreeBottomPanel:onEnterHandler() end

FruitTreeRulePanel = class(BasePanel)

function FruitTreeRulePanel:create(bottomY)
	local panel = FruitTreeRulePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_fruit_tree)
	if not panel:_init(bottomY) then panel = nil end
	return panel
end

function FruitTreeRulePanel:_init(bottomY)
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	bottomY = bottomY or vSize.height + vOrigin.y
	self.panel = self:buildInterfaceGroup("fruitTreeRulePanel")
	BasePanel.init(self, self.panel)

	self.button = self.panel:getChildByName("button")
	self.descText = self.panel:getChildByName("descText")
	self.content = self.panel:getChildByName("content")
	self.hitArea = self.panel:getChildByName("hit_area")
	self.level0 = self.panel:getChildByName("level0")
	self.level6 = self.panel:getChildByName("level6")
	self.coin = self.panel:getChildByName("coin")
	self.energy = self.panel:getChildByName("energy")
	self.gold = self.panel:getChildByName("gold")
	self.regen = self.panel:getChildByName("regen")
	self.speed = self.panel:getChildByName("speed")
	self.regenText = self.panel:getChildByName("regenText")
	self.speedText = self.panel:getChildByName("speedText")
	self.button = GroupButtonBase:create(self.button)

	self:scaleAccordingToResolutionConfig()
	self.size = self.hitArea:getGroupBounds().size
	self:setPosition(ccp((vSize.width - self.size.width) / 2 + vOrigin.x, bottomY))
	self.hitArea:removeFromParentAndCleanup(true)
	local function setMethodUI(ctrl, text)
		local name = {"regen", "speed"}
		for k, v in ipairs(name) do
			local icn = ctrl:getChildByName("icn_"..v)
			if icn and v ~= text then icn:removeFromParentAndCleanup(true) end
		end
		local label = ctrl:getChildByName("text")
		if label then label:setText(Localization:getInstance():getText("fruit.tree.scene."..text)) end
	end
	setMethodUI(self.regen, "regen")
	setMethodUI(self.speed, "speed")

	self.button:setString(Localization:getInstance():getText("fruit.tree.panel.rule.button"))
	self.content:setString(Localization:getInstance():getText("fruit.tree.panel.rule.content"))
	self.descText:setString(Localization:getInstance():getText("fruit.tree.panel.rule.descText"))
	self.level0:setText(Localization:getInstance():getText("fruit.tree.scene.level", {level = 0}))
	self.level6:setText(Localization:getInstance():getText("fruit.tree.scene.level", {level = 6}))
	self.coin:setString(tostring(FruitTreePanelModel:sharedInstance():getFruitCoinRewardString()))
	self.energy:setString(tostring(FruitTreePanelModel:sharedInstance():getFruitEnergyRewardString()))
	self.gold:setString(tostring(FruitTreePanelModel:sharedInstance():getFruitGoldRewardString()))
	self.regenText:setString(Localization:getInstance():getText("fruit.tree.panel.rule.regen.text"))
	self.speedText:setString(Localization:getInstance():getText("fruit.tree.panel.rule.speed.text"))

	local function onButton(evt)
		self.button:setEnabled(false)
		self:playSlideOutAnim()
	end
	self.button:addEventListener(DisplayEvents.kTouchTap, onButton)

	return true
end

function FruitTreeRulePanel:remove()
	self.button:setEnabled(false)
	self:playSlideOutAnim()
end

function FruitTreeRulePanel:playSlideInAnim()
	local layer = LayerColor:create()
	self.layer = layer
	layer:setOpacity(0)
	local wSize = Director:sharedDirector():getWinSize()
	layer:changeWidthAndHeight(wSize.width, wSize.height)
	layer:runAction(CCFadeTo:create(0.5, 150))
	local parent = self:getParent()
	if parent then
		local index = parent:getChildIndex(self)
		print("index", index)
		parent:addChildAt(layer, index)
	else print("no parent") layer:dispose() end
	local list = {}
	self.panel:getVisibleChildrenList(list)
	if type(list) == "table" and #list > 0 then
		for k, v in ipairs(list) do
			v:setOpacity(0)
			v:runAction(CCFadeIn:create(0.2))
		end
	end
	self:setPositionY(self:getPositionY() + 300)
	self:runAction(CCEaseBackOut:create(CCMoveBy:create(0.5, ccp(0, -300))))
end

function FruitTreeRulePanel:playSlideOutAnim()
	local list = {}
	self.panel:getVisibleChildrenList(list)
	if type(list) == "table" and #list > 0 then
		for k, v in ipairs(list) do
			v:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCFadeOut:create(0.2)))
		end
	end
	local array = CCArray:create()
	array:addObject(CCEaseBackIn:create(CCMoveBy:create(0.5, ccp(0, 300))))
	local function dispatchEvent() self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self)) end
	array:addObject(CCCallFunc:create(dispatchEvent))
	self:runAction(CCSequence:create(array))
	if self.layer and not self.layer.isDisposed then
		local function dispose() self.layer:removeFromParentAndCleanup(true) end
		self.layer:runAction(CCSequence:createWithTwoActions(CCFadeTo:create(0.5, 0), CCCallFunc:create(dispose)))
	end
end

function FruitTreeRulePanel:onKeyBackClicked()
	self.button:setEnabled(false)
	self:playSlideOutAnim()
end

function FruitTreeRulePanel:onEnterHandler() end

FruitTreeUpgradePanel = class(BasePanel)

function FruitTreeUpgradePanel:create()
	local panel = FruitTreeUpgradePanel.new()
	panel:loadRequiredResource(PanelConfigFiles.panel_fruit_tree)
	if not panel:_init() then panel = nil end
	return panel
end

function FruitTreeUpgradePanel:_init()
	self.panel = self:buildInterfaceGroup("fruitTreeUpgradePanel")
	BasePanel.init(self, self.panel)

	self.button = self.panel:getChildByName("button")
	self.close = self.panel:getChildByName("close")
	self.friendBtn = self.panel:getChildByName("friendBtn")
	self.coinBtn = self.panel:getChildByName("coinBtn")
	self.upgradeFriend = self.panel:getChildByName("upgradeFriend")
	self.upgradeFriendText = self.panel:getChildByName("upgradeFriendText")
	self.upgradeCoin = self.panel:getChildByName("upgradeCoin")
	self.coin = self.panel:getChildByName("coin")
	self.condition = {}
	self.condition[0] = self.panel:getChildByName("condition0")
	self.condition[1] = self.panel:getChildByName("condition1")
	self.condition[2] = self.panel:getChildByName("condition2")
	self.condition[3] = self.panel:getChildByName("condition3")
	self.upgradeText = self.panel:getChildByName("upgradeText")
	self.pickArrow = self.panel:getChildByName("pickArrow")
	self.coinArrow = self.panel:getChildByName("coinArrow")
	self.pickBefore = self.panel:getChildByName("pickBefore")
	self.pickAfter = self.panel:getChildByName("pickAfter")
	self.coinBefore = self.panel:getChildByName("coinBefore")
	self.coinAfter = self.panel:getChildByName("coinAfter")
	self.pickText = self.panel:getChildByName("pickText")
	self.coinText = self.panel:getChildByName("coinText")
	self.captain = self.panel:getChildByName("captain")
	self.hitArea = self.panel:getChildByName("hit_area")
	self.lock = self.panel:getChildByName("lock")
	self.lockText = self.panel:getChildByName("lockText")
	self.friendBtn = GroupButtonBase:create(self.friendBtn)
	self.coinBtn = GroupButtonBase:create(self.coinBtn)
	self.button = GroupButtonBase:create(self.button)

	self:scaleAccordingToResolutionConfig()
	local vSize = Director:sharedDirector():getVisibleSize()
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	self.size = self.hitArea:getGroupBounds().size
	self:setPosition(ccp((vSize.width - self.size.width) / 2 + vOrigin.x, self.size.height + vOrigin.y))
	self.hitArea:removeFromParentAndCleanup(true)
	self.friendBtn:setColorMode(kGroupButtonColorMode.orange)
	self.coinBtn:setColorMode(kGroupButtonColorMode.blue)
	self.lock:setVisible(false)
	self.lockText:setVisible(false)

	self.button:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.button"))
	self.friendBtn:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.friendButton"))
	self.coinBtn:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.coinButton"))
	-- self.upgradeFriendText:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.friendText"))
	self.upgradeText:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.upgradeText"))
	self.pickText:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.pickText"))
	self.coinText:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.coinText"))
	self.captain:setText(Localization:getInstance():getText("fruit.tree.panel.upgrade.captain"))
	self.lockText:setString(Localization:getInstance():getText("fruit.tree.upgrade.panel.lock"))

	-- center title
	local size = self.captain:getContentSize()
	self.captain:setPositionX((self.size.width / self:getScale() - size.width) / 2)

	self:refresh()

	local function onClose(evt)
		self.button:setEnabled(false)
		self.close:setTouchEnabled(false)
		self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self))
	end
	self.close:setTouchEnabled(true)
	self.close:setButtonMode(true)
	self.close:addEventListener(DisplayEvents.kTouchTap, onClose)

	local function onPopdown()
		self:refresh()
	end
	local function onFriendBtn(evt)
		local position = self.friendBtn:getPosition()
		local wPosition = self.panel:convertToWorldSpace(ccp(position.x, position.y))
		local panel = InviteFriendRewardPanel:create(wPosition)
		if panel then
			panel:addEventListener(PopoutEvents.kRemoveOnce, onPopdown)
			panel:popout()
			if __WP8 then Wp8Utils:reloadAngle() end
		end
	end
	self.friendBtn:addEventListener(DisplayEvents.kTouchTap, onFriendBtn)
	local function onCoinBtn(evt)
		local id = MarketManager:sharedInstance():getPageIndexByGoodsId(51)
		if id == 0 then id = MarketManager:sharedInstance():getPageIndexByGoodsId(53) end
		if id ~= 0 then
			local panel = createMarketPanel(id)
			panel:addEventListener(kPanelEvents.kClose, onPopdown)
			panel:popout()
		end
	end
	self.coinBtn:addEventListener(DisplayEvents.kTouchTap, onCoinBtn)
	local function onButton(evt)
		local level = FruitTreePanelModel:sharedInstance():getTreeLevel()
		local inviteNeed = FruitTreePanelModel:sharedInstance():getUpgradeCondition(level + 1)
		local coin = FruitTreePanelModel:sharedInstance():getUserCoin()
		local coinNeed = FruitTreePanelModel:sharedInstance():getUpgradeCoin(level + 1)
		local function onSuccess(data)
			if self.isDisposed then return end
			local scene = HomeScene:sharedInstance()
			if scene then scene:checkDataChange() end
			self:refresh()
			self:dispatchEvent(Event.new(kPanelEvents.kButton, nil, self))
		end
		local function onFail(err)
			if self.isDisposed then return end
			self.button:setEnabled(true)
			CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err), "negative"))
		end
		local function onCancel()
			if self.isDisposed then return end
			self.button:setEnabled(true)
		end

		local function startUpgrade()
			self.button:setEnabled(false)
			local logic = FruitTreeUpgradePanelLogic:create(self.invitedFriendCount)
			logic:upgrade(onSuccess, onFail, onCancel)
		end
		RequireNetworkAlert:callFuncWithLogged(startUpgrade)
	end
	self.button:addEventListener(DisplayEvents.kTouchTap, onButton)

	return true
end

function FruitTreeUpgradePanel:onKeyBackClicked()
	self.button:setEnabled(false)
	self.close:setTouchEnabled(false)
	self:dispatchEvent(Event.new(kPanelEvents.kClose, nil, self))
end

function FruitTreeUpgradePanel:refresh()
	if self.isDisposed then return end
	local level = FruitTreePanelModel:sharedInstance():getTreeLevel()
	local enabled = FruitTreePanelModel:sharedInstance():canUpgrade()
	local locked = FruitTreePanelModel:sharedInstance():getUpgradeLocked(level + 1)
	if locked then
		-- disable ui
		self.upgradeText:setVisible(false)
		for i = 0, 3 do self.condition[i]:setVisible(false) end
		self.upgradeCoin:setVisible(false)
		self.upgradeFriendText:setVisible(false)
		self.upgradeFriend:setVisible(false)
		self.coinBtn:setVisible(false)
		self.friendBtn:setVisible(false)
		self.lockText:setVisible(true)
		self.lock:setVisible(true)
		enabled = false
	else
		-- enable ui
		self.upgradeText:setVisible(true)
		for i = 0, 3 do self.condition[i]:setVisible(true) end
		self.upgradeCoin:setVisible(true)
		self.upgradeFriendText:setVisible(true)
		self.upgradeFriend:setVisible(true)
		self.coinBtn:setVisible(true)
		self.friendBtn:setVisible(true)
		self.lockText:setVisible(false)
		self.lock:setVisible(false)

		local finish, coin, upgradeCoin = FruitTreePanelModel:sharedInstance():getFinishUpgradeCoin(level + 1)
		if finish then
			self.upgradeCoin:setColor(ccc3(35, 121, 0))
			self.coinBtn:setVisible(false)
		else
			self.upgradeCoin:setColor(ccc3(255, 0, 0))
			self.coinBtn:setVisible(true)
			enabled = false
		end
		self.upgradeCoin:setString(tostring(coin)..'/'..tostring(upgradeCoin))
		local condition, fulfill, value, nextValue = FruitTreePanelModel:sharedInstance():getIsFinishUpgradeCondition(level + 1)
		for i = 1, 3 do self.condition[i]:setVisible(i == condition) end
		self.friendBtn:setVisible(condition == 2)
		self.upgradeFriendText:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.condition"..tostring(condition)))
		if condition == 2 then
			if self.invitedFriendCount then
				fulfill, value = self.invitedFriendCount >= nextValue, self.invitedFriendCount
				if fulfill then
					self.upgradeFriend:setColor(ccc3(35, 121, 0))
					self.friendBtn:setVisible(false)
				else
					self.upgradeFriend:setColor(ccc3(255, 0, 0))
					self.friendBtn:setVisible(true)
					enabled = false
				end
				self.upgradeFriend:setString(tostring(value)..'/'..tostring(nextValue))
			else
				local function onSuccess(data)
					self.invitedFriendCount = data
					self:refresh()
				end
				local function onFail(err)
					self.invitedFriendCount = 0
					self:refresh()
					CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)), "negative")
				end
				enabled = false
				self.upgradeFriend:setColor(ccc3(255, 0, 0))
				self.upgradeFriend:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.loading"))
				local logic = FruitTreeUpgradePanelLogic:create()
				logic:getInvitedFriendCount(onSuccess, onFail)
			end
		else
			if fulfill then self.upgradeFriend:setColor(ccc3(35, 121, 0))
			else
				self.upgradeFriend:setColor(ccc3(255, 0, 0))
				enabled = false
			end
			self.upgradeFriend:setString(tostring(value)..'/'..tostring(nextValue))
		end
	end
	local incPlus, plus, nextPlus = FruitTreePanelModel:sharedInstance():getShowUpgradePlus()
	self.coinBefore:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.plusValue", {plus = tostring(plus)}))
	if incPlus then
		self.coinArrow:setVisible(true)
		self.coinAfter:setVisible(true)
		self.coinAfter:setString(Localization:getInstance():getText("fruit.tree.panel.upgrade.plusValue", {plus = tostring(nextPlus)}))
	else
		self.coinArrow:setVisible(false)
		self.coinAfter:setVisible(false)
	end
	local incPick, pick, nextPick = FruitTreePanelModel:sharedInstance():getShowUpgradePick()
	self.pickBefore:setString(tostring(pick))
	if incPick then
		self.pickArrow:setVisible(true)
		self.pickAfter:setVisible(true)
		self.pickAfter:setString(tostring(nextPick))
	else
		self.pickArrow:setVisible(false)
		self.pickAfter:setVisible(false)
	end
	self.button:setEnabled(enabled)
end

function FruitTreeUpgradePanel:onEnterHandler() end

FruitTreeUpgradePanelLogic = class()

function FruitTreeUpgradePanelLogic:create(invitedFriendCount)
	local logic = FruitTreeUpgradePanelLogic.new()
	logic.invitedFriendCount = invitedFriendCount
	return logic
end

function FruitTreeUpgradePanelLogic:getInvitedFriendCount(successCallback, failCallback)
	local function onSuccess(evt)
		if not evt.data then
			if failCallback then failCallback(evt.data) end
			return
		end
		local length = 0
		for k, v in ipairs(evt.data) do
			if v.friendUid and tonumber(v.friendUid) ~= 0 then length = length + 1 end
		end
		if successCallback then successCallback(length) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt.data) end
	end
	local http = GetInviteFriendsInfo.new()
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:load()
end

function FruitTreeUpgradePanelLogic:upgrade(successCallback, failCallback, cancelCallback)
	local treeLevel = FruitTreePanelModel:getTreeLevel()
	local function onSuccess(evt)
		local extend = UserManager:getInstance():getUserExtendRef()
		if extend then extend:setFruitTreeLevel(extend:getFruitTreeLevel() + 1) end
		local user = UserManager:getInstance():getUserRef()
		if user then user:setCoin(user:getCoin() - FruitTreePanelModel:sharedInstance():getUpgradeCoin()) end
		DcUtil:fruitTreeUpgrade(treeLevel)
		if successCallback then successCallback(evt.data) end
	end
	local function onFail(evt)
		if failCallback then failCallback(evt.data) end
	end
	local function onCancel()
		if cancelCallback then cancelCallback() end
	end
	local level = FruitTreePanelModel:sharedInstance():getTreeLevel()
	local upgrade, errCode = true, nil
	if not FruitTreePanelModel:sharedInstance():getFinishUpgradeCoin(level + 1) then upgrade, errCode = false, 730321 end -- not enough coin
	local uType, fulfill, _, nextValue = FruitTreePanelModel:sharedInstance():getIsFinishUpgradeCondition(level + 1)
	if uType ~= 2 then upgrade = upgrade and fulfill
	else upgrade = upgrade and (type(self.invitedFriendCount) == "number" and self.invitedFriendCount >= nextValue) end
	if upgrade then
			local http = UpgradeFruitTreeHttp.new(true)
			http:addEventListener(Events.kComplete, onSuccess)
			http:addEventListener(Events.kError, onFail)
			http:addEventListener(Events.kCancel, onCancel)
			http:load()
	else
		errCode = errCode or 730232 -- coindition fail
		if failCallback then failCallback(errCode) end
	end
end

FruitTreePanelModel = class()

local instance = nil
function FruitTreePanelModel:sharedInstance()
	if not instance then
		instance = FruitTreePanelModel.new()
		instance:_init()
	end
	return instance
end

function FruitTreePanelModel:_init()
	local meta = MetaManager:getInstance().fruits_upgrade
	self.upgrade = {}
	for k, v in ipairs(meta) do self.upgrade[v.level] = v end
	meta = MetaManager:getInstance().fruits
	self.fruits = {}
	for k, v in ipairs(meta) do
		local rec = {id = v.id, level = v.level, upgrade = v.upgrade}
		for _, v2 in ipairs(v.reward) do
			if v2.itemId == 2 then rec.coin = v2.num
			elseif v2.itemId == 4 then rec.energy = v2.num
			elseif v2.itemId == 14 then rec.gold = v2.num end
		end
		table.insert(self.fruits, rec)
	end
end

function FruitTreePanelModel:getTreeLevel()
	local extend = UserManager:getInstance():getUserExtendRef()
	if extend then return extend:getFruitTreeLevel()
	else return 1 end
end

function FruitTreePanelModel:incTreeLevel()
	local extend = UserManager:getInstance():getUserExtendRef()
	if extend then
		extend:setFruitTreeLevel(extend:getFruitTreeLevel() + 1)
	end
end

function FruitTreePanelModel:canUpgrade()
	local level = self:getTreeLevel()
	if level >= 5 then return false end
	return true
end

function FruitTreePanelModel:getPlus(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or not self.upgrade[level].plus then return 0 end
	return self.upgrade[level].plus
end

function FruitTreePanelModel:getShowUpgradePlus(level)
	level = level or self:getTreeLevel()
	local plus, nextPlus = self:getPlus(), self:getPlus(level + 1)
	return plus < nextPlus, plus, nextPlus
end

function FruitTreePanelModel:getPickCount(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or not self.upgrade[level].pickCount then return 0 end
	return self.upgrade[level].pickCount
end

function FruitTreePanelModel:getPicked()
	local dailyData = UserManager:getInstance():getDailyData()
	if not dailyData then return 0 end
	return dailyData.pickFruitCount
end

function FruitTreePanelModel:getShowUpgradePick(level)
	level = level or self:getTreeLevel()
	local picked, nextPicked = self:getPickCount(), self:getPickCount(level + 1)
	return picked < nextPicked, picked, nextPicked
end

function FruitTreePanelModel:getUpgradeLocked(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or self.upgrade[level].lock == nil then return true end
	return self.upgrade[level].lock
end

function FruitTreePanelModel:getUpgradeCondition(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or not self.upgrade[level].upgradeCondition then return nil end
	local condition = self.upgrade[level].upgradeCondition[1]
	return condition.itemId, condition.num
end

function FruitTreePanelModel:getIsFinishUpgradeCondition(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or not self.upgrade[level].upgradeCondition then return 0, false, 0, 0 end
	local condition = self.upgrade[level].upgradeCondition[1]
	if type(condition) ~= "table" then return 0, false, 0, 0 end
	if condition.itemId == 1 then
		local star = UserManager:getInstance():getUserRef():getStar()
		local finish = (star >= condition.num)
		return condition.itemId, finish, star, condition.num
	elseif condition.itemId == 3 then
		local level = 0
		for k, v in ipairs(UserManager:getInstance():getScoreRef()) do
			if v.star > 0 and v.levelId < 10000 and level < v.levelId then level = v.levelId end
		end
		return condition.itemId, level >= condition.num, level, condition.num
	else
		return condition.itemId, false, 0, condition.num
	end
end

function FruitTreePanelModel:getFruitCoinRewardString()
	for k, v in ipairs(self.fruits) do
		if v.level == 6 then return v.coin end
	end
end

function FruitTreePanelModel:getFruitEnergyRewardString()
	for k, v in ipairs(self.fruits) do
		if v.level == 6 then return v.energy end
	end
end

function FruitTreePanelModel:getFruitGoldRewardString()
	for k, v in ipairs(self.fruits) do
		if v.level == 6 then return v.gold end
	end
end

function FruitTreePanelModel:getUpgradeCoin(level)
	level = level or self:getTreeLevel()
	if not self.upgrade[level] or not self.upgrade[level].coin then return 0 end
	return self.upgrade[level].coin
end

function FruitTreePanelModel:getUserCoin()
	local user = UserManager:getInstance():getUserRef()
	if not user then return 0 end
	return user:getCoin()
end

function FruitTreePanelModel:getFinishUpgradeCoin(level)
	level = level or self:getTreeLevel()
	local finish, upgradeCoin = true, 99999999
	if not self.upgrade[level] or not self.upgrade[level].coin then finish = false end
	upgradeCoin = self:getUpgradeCoin(level)
	local user = UserManager:getInstance():getUserRef()
	if not user then return finish, 0, upgradeCoin end
	local coin = user:getCoin()
	if coin < upgradeCoin then finish = false end
	return finish, coin, upgradeCoin
end