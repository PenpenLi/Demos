
HomeSceneButtonsBar = class(BaseUI)
local ButtonState = table.const{
	kNoButton = 0,
}
function HomeSceneButtonsBar:ctor()
	
end

function HomeSceneButtonsBar:init()
	self.ui = ResourceManager:sharedInstance():buildGroup("ButtonGroupBar")
	BaseUI.init(self, self.ui)

	self.buttonsInfoTable = {}

	self.visibleSize	= CCDirector:sharedDirector():getVisibleSize()
	self.visibleOrigin	= CCDirector:sharedDirector():getVisibleOrigin()

	self.bg = self.ui:getChildByName("bg")
	self.bg:setTouchEnabled(true)
	self.bg:ad(DisplayEvents.kTouchTap, function ()
		self:onBgTap()
	end)

    self.bg.hitTestPoint = function (worldPosition, useGroupTest)
        return true
    end

    self.animBg = self.bg:getChildByName("bg")
    self.animBg:setAnchorPointWhileStayOriginalPosition(ccp(1,0))

	self.blueBtn = HideAndShowButton:create(self.ui:getChildByName("blueBtn"))
	self.blueBtn:ad(DisplayEvents.kTouchTap, function ()
		self:onBlueBtnTap()
	end)

	HomeSceneButtonsManager.getInstance():setBtnGroupBar(self)
end

function HomeSceneButtonsBar:onBgTap()
	self:hideButtons()
end

function HomeSceneButtonsBar:onBlueBtnTap()
	self:hideButtons()
end

function HomeSceneButtonsBar:showButtons(endCallback)
	--加号按钮动画
	self.bg:setTouchEnabled(false)
	self.blueBtn:setEnable(false)
	self.blueBtn:playAni(function ()
		self.blueBtn:setEnable(true)
		if endCallback then 
			endCallback()
		end
	end)

	--黑背景动画
	local bgWidth, bgHeight = HomeSceneButtonsManager.getInstance():getBarBgSize()
	local seqArr = CCArray:create()
	seqArr:addObject(CCSizeTo:create(2/24, bgWidth * 0.9, bgHeight * 1))
    seqArr:addObject(CCSizeTo:create(2/24, bgWidth * 1.1, bgHeight * 1.1))
    seqArr:addObject(CCSizeTo:create(2/24, bgWidth * 0.95, bgHeight * 1))
    seqArr:addObject(CCSizeTo:create(1/24, bgWidth * 1.05, bgHeight * 1.05))
    seqArr:addObject(CCSizeTo:create(1/24, bgWidth, bgHeight))
    seqArr:addObject(CCCallFunc:create(function ()
    	self.bg:setTouchEnabled(true)
    	for i,v in ipairs(self.buttonsInfoTable) do
    		v.wrapper:setTouchEnabled(true, 0, true)
    	end
    end))

    --加防点击穿透层
    local touchLayer = LayerColor:create()
    touchLayer:setColor(ccc3(255,0,0))
    touchLayer:setOpacity(0)
    touchLayer:setContentSize(CCSizeMake(bgWidth, bgHeight))
    touchLayer:setTouchEnabled(true, 0, true)
    self.animBg:addChild(touchLayer)
	self.animBg:runAction(CCSequence:create(seqArr))

	local buttonTypeTable = HomeSceneButtonsManager.getInstance():getBtnTypeInfoTable()
	for m,n in ipairs(buttonTypeTable) do
		for p,q in ipairs(n) do
			local buttonNode = {}
			buttonNode.btn = self:createButton(q.btnType)
			buttonNode.line = m
			if m == 1 then 
				buttonNode.row = p + 1 
			else
				buttonNode.row = p
			end
			if buttonNode.btn ~= ButtonState.kNoButton then 
				buttonNode.wrapper = buttonNode.btn.wrapper
				buttonNode.wrapper:setTouchEnabled(false)
				self:addChild(buttonNode.btn)
				local btnSize = buttonNode.btn:getGroupBounds().size
				if q.btnType == HomeSceneButtonType.kStarReward or 
					q.btnType == HomeSceneButtonType.kMail or 
					q.btnType == HomeSceneButtonType.kMark then 
					buttonNode.btn = HomeSceneButtonsManager.getInstance():addToLayerColor(buttonNode.btn, ccp(0.5, 0.5))
					buttonNode.btn:setPosition(ccp(q.posX - btnSize.width/2, q.posY - btnSize.height/2))
				else
					buttonNode.btn:setPosition(ccp(q.posX, q.posY))
				end
				buttonNode.btn:setScale(0)
				table.insert(self.buttonsInfoTable, buttonNode)
			end
		end
	end

	for i,v in ipairs(self.buttonsInfoTable) do
		local seqArr1 = CCArray:create()
		seqArr1:addObject(CCDelayTime:create(v.row * 0.05 - 0.05))
		seqArr1:addObject(CCScaleTo:create(3/24, 0.9))
	    seqArr1:addObject(CCScaleTo:create(2/24, 1.1))
	    seqArr1:addObject(CCScaleTo:create(2/24, 0.95))
	    seqArr1:addObject(CCScaleTo:create(1/24, 1.05))
	    seqArr1:addObject(CCScaleTo:create(1/24, 1))
		v.btn:runAction(CCSequence:create(seqArr1))
	end
end

function HomeSceneButtonsBar:hideButtons()
	self.bg:setTouchEnabled(false)
	self.blueBtn:setEnable(false)

	local seqArr = CCArray:create()
	seqArr:addObject(CCScaleTo:create(1/24, 1.05))
    seqArr:addObject(CCScaleTo:create(2/24, 0.4))
    seqArr:addObject(CCHide:create())
	self.animBg:runAction(CCSequence:create(seqArr))

	local buttonTypeTable = HomeSceneButtonsManager.getInstance():getBtnTypeInfoTable()
	local onelineBtnNum = #buttonTypeTable[1]
	for i,v in ipairs(self.buttonsInfoTable) do
		v.wrapper:setTouchEnabled(false)
		local seqArr1 = CCArray:create()
		local time = onelineBtnNum * 0.1 - v.row * 0.1
		seqArr1:addObject(CCDelayTime:create(time))
	    seqArr1:addObject(CCScaleTo:create(2/24, 1.1))
	    seqArr1:addObject(CCScaleTo:create(3/24, 0))
	    v.btn:stopAllActions()
		v.btn:runAction(CCSequence:create(seqArr1))
	end

	self.blueBtn:playAni(function ()
		self.btnBarEvent:dispatchCloseEvent()
		self:removePopout()
	end)
end

function HomeSceneButtonsBar:popout(endCallback)
	local scene = Director:sharedDirector():getRunningScene()
	scene:addChild(self)

	local _x = self.visibleOrigin.x + self.visibleSize.width 
	local _y = self.visibleOrigin.y 
	self:setPosition(ccp(_x, _y))

	self:showButtons(endCallback)
end

function HomeSceneButtonsBar:removePopout()
	HomeSceneButtonsManager.getInstance():setBtnGroupBar(nil)
	self:removeFromParentAndCleanup(true)
end

function HomeSceneButtonsBar:popoutBagPanel()
	local bagButtonPos 				= self.bagButton:getPosition()
	local bagButtonParent			= self.bagButton:getParent()
	local bagButtonPosInWorldSpace	= bagButtonParent:convertToWorldSpace(ccp(bagButtonPos.x, bagButtonPos.y))
	local panel = createBagPanel(bagButtonPosInWorldSpace)
	if panel then 
		panel:popout()
	end
end

function HomeSceneButtonsBar:popoutFriendRankingPanel()
	self.friendButton.wrapper:setTouchEnabled(false)
	local function __reset()
		if self.friendButton then self.friendButton.wrapper:setTouchEnabled(true) end
	end
	self:runAction(CCSequence:createWithTwoActions(
	               CCDelayTime:create(0.2), CCCallFunc:create(__reset)
	               ))
	local panel = createFriendRankingPanel()
	if panel then 
		panel:popout()
	end
end

function HomeSceneButtonsBar:popoutFruitTreePanel()
	local function success()
		if self.isDisposed then return end
		self.fruitTreeButton.wrapper:setTouchEnabled(false)
		self:runAction(CCCallFunc:create(function()
			local scene = FruitTreeScene:create()
			Director:sharedDirector():pushScene(scene)
			self.fruitTreeButton.wrapper:setTouchEnabled(true, 0, true)
			self.fruitTreeButton:hideNewTag()
		end))
	end
	local function fail(err, skipTip)
		if self.isDisposed then return end
		if not skipTip then CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err))) end
	end
	local function updateInfo()
		FruitTreeSceneLogic:sharedInstance():updateInfo(success, fail)
	end
	local function onLoginFail()
		fail(-2, true)
	end
	RequireNetworkAlert:callFuncWithLogged(updateInfo, onLoginFail)
end

function HomeSceneButtonsBar:popoutStarRewardPanel()
	local starRewardBtnPos = self.starRewardButton:getPosition()
	local starRewardBtnParent = self.starRewardButton:getParent()
	local starRewardBtnPosInWorldSpace = starRewardBtnParent:convertToWorldSpace(ccp(starRewardBtnPos.x, starRewardBtnPos.y))

	local starRewardBtnSize	= self.starRewardButton.wrapper:getGroupBounds().size

	starRewardBtnPosInWorldSpace.x = starRewardBtnPosInWorldSpace.x + starRewardBtnSize.width / 2
	starRewardBtnPosInWorldSpace.y = starRewardBtnPosInWorldSpace.y - starRewardBtnSize.height / 2

	local starRewardPanel = StarRewardPanel:create(starRewardBtnPosInWorldSpace)
	if starRewardPanel then
		-- starRewardPanel:registerCloseCallback(onStarRewardPanelClose)
		starRewardPanel:popout()
	end
end

function HomeSceneButtonsBar:popoutMessageCenter()
	local function callback(result, evt)
		if self.isDisposed then return end
		if result == "success" then
			if self.messageButton then
				self.messageButton:updateView()
			end
			Director:sharedDirector():pushScene(MessageCenterScene:create())
		else
			local message = ''
			local err_code = tonumber(evt.data)
			if err_code then message = Localization:getInstance():getText("error.tip."..err_code) end
			CommonTip:showTip(message, "negative")
		end
	end
	FreegiftManager:sharedInstance():update(true, callback)
end

function HomeSceneButtonsBar:popoutMarkPanel()
	local btnPos 		= self.markButton:getPosition()
	local btnParent		= self.markButton:getParent()
	local btnPosInWorldPos	= btnParent:convertToWorldSpace(ccp(btnPos.x, btnPos.y))

	local btnSize		= self.markButton.wrapper:getGroupBounds().size
	btnPosInWorldPos.x = btnPosInWorldPos.x + btnSize.width / 2
	btnPosInWorldPos.y = btnPosInWorldPos.y - btnSize.height / 2

	local panel = MarkPanel:create(btnPosInWorldPos)
	panel:popout()
end

function HomeSceneButtonsBar:createButton(buttonType)
	local button = ButtonState.kNoButton
	if buttonType == HomeSceneButtonType.kNull then 
	elseif buttonType == HomeSceneButtonType.kBag then
		button = BagButton:create()
		self.bagButton = button
		self.bagButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
			self:hideButtons()
			self:popoutBagPanel()
		end)
	elseif buttonType == HomeSceneButtonType.kFriends then
		button = FriendButton:create()
		self.friendButton = button
		self.friendButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
			self:hideButtons()
			self:popoutFriendRankingPanel()
		end)
	elseif buttonType == HomeSceneButtonType.kTree then
		button = FruitTreeButton:create()
		self.fruitTreeButton = button
		local function onFruitBtnTap()
			if self.isDisposed then return end
			self:hideButtons()
			self:popoutFruitTreePanel()
		end
		self.fruitTreeButton.wrapper:addEventListener(DisplayEvents.kTouchTap, onFruitBtnTap)
		self.fruitTreeButton.onClick = onFruitBtnTap
	elseif buttonType == HomeSceneButtonType.kMail then
		button = MessageButton:create()
		self.messageButton = button
		self.messageButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
			self:hideButtons()
			self:popoutMessageCenter()
		end)
	elseif buttonType == HomeSceneButtonType.kStarReward then
		button = StarRewardButton:create()
		self.starRewardButton = button
		self.starRewardButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
			self:hideButtons()
			self:popoutStarRewardPanel()
		end)
	elseif buttonType == HomeSceneButtonType.kMark then
		button = MarkButton:create()
		self.markButton = button
		self.markButton.wrapper:addEventListener(DisplayEvents.kTouchTap, function ()
			self:hideButtons()
			self:popoutMarkPanel()
		end)
	end

	return button
end

function HomeSceneButtonsBar:getBtnByType(buttonType)
	local targetBtn = nil
	if buttonType == HomeSceneButtonType.kBag then
		targetBtn = self.bagButton
	elseif buttonType == HomeSceneButtonType.kFriends then
		targetBtn = self.friendButton
	elseif buttonType == HomeSceneButtonType.kTree then
		targetBtn = self.fruitTreeButton
	elseif buttonType == HomeSceneButtonType.kMail then
		targetBtn = self.messageButton
	elseif buttonType == HomeSceneButtonType.kStarReward then
		targetBtn = self.starRewardButton
	elseif buttonType == HomeSceneButtonType.kMark then
		targetBtn = self.markButton
	end
	return targetBtn
end

function HomeSceneButtonsBar:create(btnBarEvent)
	local bar = HomeSceneButtonsBar.new()
	bar.btnBarEvent = btnBarEvent
	bar:init()
	return bar
end