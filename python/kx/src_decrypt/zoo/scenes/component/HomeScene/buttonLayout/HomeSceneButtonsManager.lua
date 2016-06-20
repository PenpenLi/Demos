local RightPositionConfig = {
	[1] = {
		[1] = {c = 1, r = 2},
	},
	[2] = {
		[2] = {c = 1, r = 3},
		[1] = {c = 1, r = 2}, 
	},
	[3] = {
		[3] = {c = 1, r = 4},
		[2] = {c = 1, r = 3},
		[1] = {c = 1, r = 2},  
	},
	[4] = {
		[4] = {c = 2, r = 3}, [2] = {c = 1, r = 3}, 
		[3] = {c = 2, r = 2}, [1] = {c = 1, r = 2}, 
	},
	[5] = {
							  [5] = {c = 1, r = 4},
		[4] = {c = 2, r = 3}, [2] = {c = 1, r = 3}, 
		[3] = {c = 2, r = 2}, [1] = {c = 1, r = 2},
							  
	},
	[6] = {
		[6] = {c = 2, r = 4}, [5] = {c = 1, r = 4},
		[4] = {c = 2, r = 3}, [2] = {c = 1, r = 3}, 
		[3] = {c = 2, r = 2}, [1] = {c = 1, r = 2},
	},
	[7] = {
							  [7] = {c = 1, r = 5},
		[6] = {c = 2, r = 4}, [5] = {c = 1, r = 4},
		[4] = {c = 2, r = 3}, [2] = {c = 1, r = 3}, 
		[3] = {c = 2, r = 2}, [1] = {c = 1, r = 2},
	},
	[8] = {
		[8] = {c = 2, r = 5}, [7] = {c = 1, r = 5},
		[6] = {c = 2, r = 4}, [5] = {c = 1, r = 4},
		[4] = {c = 2, r = 3}, [2] = {c = 1, r = 3}, 
		[3] = {c = 2, r = 2}, [1] = {c = 1, r = 2},
	},
}

local function getPositionByRowColumnIndex(r, c)
	local rowMargin = 5
	local rowHeight = 110
	local colMargin = 0
	local colWidth = 110
	local ox = 15
	local oy = 20
	return ccp(-(ox + colMargin * c + 0.5 * colWidth + (c - 1) * colWidth), (oy + rowMargin * r + 0.5 * rowHeight + (r - 1) * rowHeight))
end



HomeSceneButtonsManager = class()

HomeSceneButtonType = table.const{
	kNull = 0,
	kBag = 1,
	kFriends = 2,
	kTree = 3,
	kMail = 4,
	kStarReward = 5,
	kMark = 6,
    kCdkeyBtn = 7,
	kTest8 = 8,
	kTest9 = 9,
	kTest10 = 10,
	kTest11 = 11,
	kMission = 12,
}

local instance = nil
function HomeSceneButtonsManager.getInstance()
	if not instance then
		instance = HomeSceneButtonsManager.new()
		instance:init()
	end
	return instance
end

function HomeSceneButtonsManager:init()
	self.btnGroupBar = nil
	self.allBtnTypeTable = {}
	self.finalBtnTypeTable = {}
	self.widthDelta = 118
	self.heightDelta = 134
	self.xOriPos = -75
	self.yOriPos = 70
	self.bgSizeWidth = 180
	self.bgSizeHeight = 134

	-------------------test----------------------
	-- self:setButtonShowPosState(HomeSceneButtonType.kBag, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kFriends, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTree, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kMail, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kStarReward, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kMark, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest7, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest8, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest9, true)
 --    self:setButtonShowPosState(HomeSceneButtonType.kTest10, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest11, true)
	-- UserManager:getInstance().requestNum = 10
	---------------------------------------------
	
end

function HomeSceneButtonsManager:getButtonCount()
	return #self.allBtnTypeTable
end

function HomeSceneButtonsManager:getBtnTypeInfoTable()
	return self.finalBtnTypeTable
end

function HomeSceneButtonsManager:getBarBgSize()
	return self.bgSizeWidth, self.bgSizeHeight	
end

local function sortFunc(a, b)
	return a < b
end

function HomeSceneButtonsManager:serializeBtnTypeTable()
	table.sort(self.allBtnTypeTable, sortFunc)
	self.finalBtnTypeTable = {}
	local count = #self.allBtnTypeTable 
	local config = RightPositionConfig[count] -- test
	for k, v in pairs(config) do
		if self.finalBtnTypeTable[v.r] == nil then
			self.finalBtnTypeTable[v.r] = {}
		end
	end

	for i, v in ipairs(self.allBtnTypeTable) do
		local btnConfig = {}
		btnConfig.btnType = v
		local posConfig = getPositionByRowColumnIndex(config[i].r, config[i].c)
		btnConfig.posX, btnConfig.posY = posConfig.x, posConfig.y
		table.insert(self.finalBtnTypeTable[config[i].r], btnConfig)
	end
end

function HomeSceneButtonsManager:setButtonShowPosState(buttonType, showInBar)
	if not buttonType then return end
	if buttonType == HomeSceneButtonType.kStarReward and showInBar then 
		self:setRewardBtnPosLevelId(nil)
	end

	local shouldUpdateLayout = false
	if showInBar then 
		if not table.includes(self.allBtnTypeTable, buttonType) then 
			table.insert(self.allBtnTypeTable, buttonType)
			shouldUpdateLayout = true
		end
	else
		local tempTable = {}
		for i,v in ipairs(self.allBtnTypeTable) do
			if v == buttonType then 
				shouldUpdateLayout = true
			else
				table.insert(tempTable, v)
			end
		end
		self.allBtnTypeTable = tempTable
	end
	if shouldUpdateLayout then 
		self:serializeBtnTypeTable()
	end
end

function HomeSceneButtonsManager:addLayerColorWrapper(ui,anchorPoint)
	local size = ui:getGroupBounds().size
	local pos = ui:getPosition()
	local layer = LayerColor:create()
    layer:setColor(ccc3(255,0,0))
    layer:setOpacity(0)
    layer:setContentSize(CCSizeMake(size.width, size.height))
    layer:setAnchorPoint(anchorPoint)
    layer:setPosition(ccp(pos.x, pos.y-size.height))
    
    local uiParent = ui:getParent()
    local index = uiParent:getChildIndex(ui)
    ui:removeFromParentAndCleanup(false)
    ui:setPosition(ccp(0,size.height))
    layer:addChild(ui)
    uiParent:addChildAt(layer, index)

    return layer
end

-- local starDeltaTable = table.const{
-- 	{star = 24, delta = 3},
-- 	{star = 48, delta = 5},
-- 	{star = 99, delta = 6},
-- 	{star = 150, delta = 8},
-- 	{star = 225, delta = 11},
-- 	{star = 315, delta = 15},
-- 	{star = 400, delta = 20}
-- }

-- 返回值为false则显示在主界面上
function HomeSceneButtonsManager:getStarRewardButtonShowState()
	local rewardLevelToPushMeta = StarRewardModel:getInstance():update().currentPromptReward
	if rewardLevelToPushMeta then
		local curTotalStar = UserManager:getInstance().user:getTotalStar()
		local rewardTotalStar = rewardLevelToPushMeta.starNum
		if curTotalStar >= rewardTotalStar then
			return false
		else
			for i,v in ipairs(MetaManager.getInstance().star_reward) do
				if v.starNum == rewardTotalStar then 
					local starMinus = rewardTotalStar - v.delta 
					if curTotalStar > starMinus then 
						return false
					end
				end
			end
			return true
		end
	else
		return true
	end
end

function HomeSceneButtonsManager:getStarRewardButtonShowPos()
	local nodePos = nil
	local topLevelId = UserManager:getInstance().user:getTopLevelId() 
	if topLevelId then 
		local showRewardBtnLevelId = topLevelId + 1 
		if topLevelId%15 == 0 then 
			showRewardBtnLevelId = topLevelId - 1
		end
		self:setRewardBtnPosLevelId(showRewardBtnLevelId)
		local rewardBtnLevelNode = HomeScene:sharedInstance().worldScene.levelToNode[showRewardBtnLevelId]
		if rewardBtnLevelNode then 
			nodePos = rewardBtnLevelNode:getPosition()
		end
	end
	return nodePos
end

function HomeSceneButtonsManager:getRewardBtnPosLevelId()
	if self.showRewardBtnLevelId then return self.showRewardBtnLevelId end

	local topLevelId = UserManager:getInstance().user:getTopLevelId() 
	if topLevelId then 
		local showRewardBtnLevelId = topLevelId + 1 
		if topLevelId%15 == 0 then 
			showRewardBtnLevelId = topLevelId - 1
		end
		self:setRewardBtnPosLevelId(showRewardBtnLevelId)
		return showRewardBtnLevelId
	end
	return 0
end

function HomeSceneButtonsManager:setRewardBtnPosLevelId(levelId)
	self.showRewardBtnLevelId = levelId	
end

function HomeSceneButtonsManager:getInviteButtonShowPos()
	local nodePos = nil
	local topLevelId = UserManager:getInstance().user:getTopLevelId() 
	if topLevelId then 
		local minLevelId = topLevelId - 3 
		local maxLevelId = topLevelId + 3
		local maxNormalLevelId = MetaManager.getInstance():getMaxNormalLevelByLevelArea()

		if maxLevelId%15 > 0 and maxLevelId%15 <=3 then 
			minLevelId = minLevelId - 3
			maxLevelId = maxLevelId - 3
		end

		if minLevelId < 1 then 
			minLevelId = 1
		end

		if maxLevelId > maxNormalLevelId then 
			maxLevelId = maxNormalLevelId
		end

		local friendNum = 0
		local shouldInit = true
		local inviteBtnLevelId = minLevelId
		for i=minLevelId,maxLevelId do
			if i ~= topLevelId and i ~= self.showRewardBtnLevelId then 
				local friendStack = HomeScene:sharedInstance().worldScene.levelFriendPicStacksByLevelId[i]
				if friendStack then 
					local tempNum = #friendStack.friendPics
					if shouldInit then 
						shouldInit = false
						friendNum = tempNum
						inviteBtnLevelId = i
					else
						if tempNum <= friendNum then
							friendNum = tempNum 
							inviteBtnLevelId = i
						end
					end
				else
					shouldInit = false
					inviteBtnLevelId = i
				end
			end
		end
		self:setInviteBtnPosLevelId(inviteBtnLevelId)
		local inviteBtnLevelNode = HomeScene:sharedInstance().worldScene.levelToNode[inviteBtnLevelId]
		if inviteBtnLevelNode then 
			nodePos = inviteBtnLevelNode:getPosition()
		end
	end
	return nodePos
end

function HomeSceneButtonsManager:getInviteButtonLevelId()
	if self.inviteBtnLevelId then return self.inviteBtnLevelId end

	local topLevelId = UserManager:getInstance().user:getTopLevelId() 
	if topLevelId then 
		local minLevelId = topLevelId - 3 
		local maxLevelId = topLevelId + 3
		local maxNormalLevelId = MetaManager.getInstance():getMaxNormalLevelByLevelArea()

		if maxLevelId%15 > 0 and maxLevelId%15 <=3 then 
			minLevelId = minLevelId - 3
			maxLevelId = maxLevelId - 3
		end

		if minLevelId < 1 then 
			minLevelId = 1
		end

		if maxLevelId > maxNormalLevelId then 
			maxLevelId = maxNormalLevelId
		end

		local friendNum = 0
		local shouldInit = true
		local inviteBtnLevelId = minLevelId
		for i=minLevelId,maxLevelId do
			if i ~= topLevelId and i ~= self.showRewardBtnLevelId then 
				local friendStack = HomeScene:sharedInstance().worldScene.levelFriendPicStacksByLevelId[i]
				if friendStack then 
					local tempNum = #friendStack.friendPics
					if shouldInit then 
						shouldInit = false
						friendNum = tempNum
						inviteBtnLevelId = i
					else
						if tempNum <= friendNum then
							friendNum = tempNum 
							inviteBtnLevelId = i
						end
					end
				else
					shouldInit = false
					inviteBtnLevelId = i
				end
			end
		end
		self:setInviteBtnPosLevelId(inviteBtnLevelId)
		return inviteBtnLevelId
	end
	return 0
end

function HomeSceneButtonsManager:setInviteBtnPosLevelId(levelId)
	self.inviteBtnLevelId = levelId	
end

function HomeSceneButtonsManager:getMarkButtonShowState()
	local markModel = MarkModel:getInstance()
	markModel:calculateSignInfo()
	if markModel.canSign then
		-- if IconButtonManager:getInstance():getButtonTodayShowById("MarkButton") then 
		-- 	return true
		-- else
		-- 	return false
		-- end
		return false
	else 
		local index, time = MarkModel:getInstance():getCurrentIndexAndTime()
		if index and index ~= 0 then 
			return false
		end
		return true
	end
end

-- --得到除免费礼物信息外的请求信息数量
-- function HomeSceneButtonsManager:getMessageNumByType(msgType)
-- 	local requestInfos = UserManager:getInstance().requestInfos
-- 	local res = 0
-- 	if requestInfos then 	
-- 		for k, v in ipairs(requestInfos) do
-- 			if v.type == msgType then
-- 				res = res + 1
-- 			end
-- 		end
-- 	end
-- 	return res
-- end

-- function HomeSceneButtonsManager:getMessageButtonShowState()
-- 	local count = UserManager:getInstance().requestNum
-- 	if count <= 0 then 
-- 		return true
-- 	else
-- 		local addFriendNum = self:getMessageNumByType(RequestType.kAddFriend)
-- 		local unlockNum = self:getMessageNumByType(RequestType.kUnlockLevelArea)
-- 		local activityNum = self:getMessageNumByType(RequestType.kActivity)
-- 		if addFriendNum and unlockNum and activityNum then 
-- 			if addFriendNum > 0 or unlockNum > 0 or activityNum > 0 then 
-- 				return false
-- 			else
-- 				local canSendMore, leftSendMore = FreegiftManager:sharedInstance():canSendMore()
--     			local canReceiveMore, leftReceiveMore = FreegiftManager:sharedInstance():canReceiveMore()
--     			if not canSendMore and not canReceiveMore then 
--     				return true
--     			end
-- 			end
-- 		end
-- 		return false
-- 	end
-- end

--------------------------------
--false 显示在主界面
--true  显示在按钮组
---------------------------------
function HomeSceneButtonsManager:getFruitTreeButtonShowState( ... )
	-- body
	local show =  FruitTreeButtonModel:getCrowNumber() > 0 
	return not show
end

function HomeSceneButtonsManager:setBtnGroupBar(btnGroupBar)
	self.btnGroupBar = btnGroupBar
end

function HomeSceneButtonsManager:getBtnGroupBar()
	return self.btnGroupBar
end

function HomeSceneButtonsManager:flyToBtnGroupBar(btnType , btn, startCallback, endCallback)
	local newBtnIcon = nil
	local posXDelta = 0
	local posYDelta = 0
	if btnType == HomeSceneButtonType.kMail then 
		newBtnIcon = MessageButton:create()
		local size = newBtnIcon:getGroupBounds().size
		posXDelta = -size.width / 2
		posYDelta = -size.height
	elseif btnType == HomeSceneButtonType.kStarReward then
		newBtnIcon = StarRewardButton:create()
		local size = newBtnIcon:getGroupBounds().size
		posXDelta = -size.width / 2
		posYDelta = size.height
	elseif btnType == HomeSceneButtonType.kMark then
		newBtnIcon = MarkButton:create()
	elseif btnType == HomeSceneButtonType.kTree then
		newBtnIcon = FruitTreeButton:create()
	elseif btnType == HomeSceneButtonType.kMission then
		newBtnIcon = MissionButton:create(true)
	end

	local worldOriPos = btn:convertToWorldSpace(ccp(0, 0)) 
	local scene = HomeScene:sharedInstance()
	scene:addChild(newBtnIcon)
	newBtnIcon:setPosition(ccp(worldOriPos.x + posXDelta, worldOriPos.y + posYDelta))
	newBtnIcon = self:addLayerColorWrapper(newBtnIcon, ccp(0.5, 0.5))
	local worldEndPos = scene.hideAndShowBtn:getPositionInWorldSpace()
	local hideBtnSize = newBtnIcon:getGroupBounds().size
	worldEndPos = ccp(worldEndPos.x - hideBtnSize.width/2, worldEndPos.y - hideBtnSize.height/2)

	local sequence = CCArray:create()
	local spawn = CCArray:create()
	spawn:addObject(CCEaseBackIn:create(CCMoveTo:create(1, worldEndPos)))
	spawn:addObject(CCScaleTo:create(1, 0.7))
	if startCallback then 
		sequence:addObject(CCCallFunc:create(startCallback))
	end
	sequence:addObject(CCSpawn:create(spawn))
	if endCallback then 
		sequence:addObject(CCCallFunc:create(function ()
			newBtnIcon:removeFromParentAndCleanup(true)
			if endCallback then 
				endCallback()
			end
		end))
	end
	newBtnIcon:stopAllActions()
	newBtnIcon:runAction(CCSequence:create(sequence))
end

function HomeSceneButtonsManager:showButtonHideTutor()
	if GameGuide:sharedInstance():getHasCurrentGuide() then 
		return  
	end
    local userDefault = CCUserDefault:sharedUserDefault()
    local hasTutor = userDefault:getBoolForKey("homescene.button.hide.tutor")
    if hasTutor then return end
    userDefault:setBoolForKey("homescene.button.hide.tutor", true)
    userDefault:flush()

    local scene = HomeScene:sharedInstance()
    local layer = scene.guideLayer
    local targetBtn = scene.hideAndShowBtn
    if targetBtn then 

    	local guidePanel = CocosObject:create()
    	guidePanel.popoutShowTransition = function( ... )
	    	local worldPos = targetBtn:getPositionInWorldSpace()
	    	local trueMask = GameGuideUI:mask(180, 1, ccp(worldPos.x, worldPos.y), 1.2, false, false, false, false, true)
	        trueMask.setFadeIn(0.2, 0.3)

	        local touchLayer = LayerColor:create()
	        touchLayer:setColor(ccc3(255,0,0))
	        touchLayer:setOpacity(0)
	        touchLayer:setAnchorPoint(ccp(0.5, 0.5))
	        touchLayer:ignoreAnchorPointForPosition(false)
	        touchLayer:setPosition(ccp(worldPos.x, worldPos.y))
	        touchLayer:changeWidthAndHeight(100, 100)
	        touchLayer:setTouchEnabled(true, 0, true)

	        local function onTrueMaskTap()
	            --点击关闭引导
	            if layer:contains(trueMask) then 
	                layer:removeChild(trueMask)
	            end

	            PopoutManager.sharedInstance():remove(guidePanel)
	        end

	        local function onTouchLayerTap()
	            --关了自己
	            onTrueMaskTap()
	            --展开
	            if scene.showButtonGroup then 
	            	scene:showButtonGroup()
	            end
	        end
	        touchLayer:addEventListener(DisplayEvents.kTouchTap, onTouchLayerTap)
	        trueMask:addChild(touchLayer)

	        trueMask:addEventListener(DisplayEvents.kTouchTap, onTrueMaskTap)

	        local tutorText = "tutorial.inactive.icons.hidden"
	        if PlatformConfig:isQQPlatform() then 
	        	tutorText = "tutorial.inactive.icons.hidden1"
	        end
	        local panel = GameGuideUI:panelSUR(Localization:getInstance():getText(tutorText, {n = '\n'}), false, 0)
	        panel:setScale(0.9)
	        local panelPos = panel:getPosition()
	        panel:setPosition(ccp(panelPos.x + 30, worldPos.y+350))
	        local function addTipPanel()
	            trueMask:addChild(panel)
	        end
	        trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addTipPanel)))

	        local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
	        hand:setScale(0.6)
	        hand:setAnchorPoint(ccp(0, 1))
	        hand:setPosition(ccp(worldPos.x , worldPos.y))
	        hand:setFlipX(true)
	        trueMask:addChild(hand)

	        if layer then
	            layer:addChild(trueMask)
	        end
	    end

		PopoutQueue.sharedInstance():push(guidePanel, false, true)

    end
end

function HomeSceneButtonsManager:showFruitTreeAppearTutor(isInHomeScene)
    local userDefault = CCUserDefault:sharedUserDefault()
    local hasTutor = userDefault:getBoolForKey("homescene.tree.appear.tutor")
    if hasTutor then return end
    userDefault:setBoolForKey("homescene.tree.appear.tutor", true)
    userDefault:flush()

    local scene = HomeScene:sharedInstance()
    local function showTutor()
    	local layer = scene
	    local targetBtn = nil

    	if isInHomeScene then
    		targetBtn = scene.fruitTreeBtn
    	else
	    	local btnGroup = self:getBtnGroupBar()
    		if not scene.buttonGroupBar then
	    		return 
	    	end
	    	if btnGroup then 
		    	targetBtn = btnGroup:getBtnByType(HomeSceneButtonType.kTree)
			end

    	end
	    
	    if targetBtn then 
    		local worldPos = targetBtn:convertToWorldSpace(ccp(0, 0))
	    	local trueMask = GameGuideUI:mask(180, 1, ccp(worldPos.x, worldPos.y), 1.2, false, false, false, false, true)
	        trueMask.setFadeIn(0.2, 0.3)

	        local touchLayer = LayerColor:create()
	        touchLayer:setColor(ccc3(255,0,0))
	        touchLayer:setOpacity(0)
	        touchLayer:setAnchorPoint(ccp(0.5, 0.5))
	        touchLayer:ignoreAnchorPointForPosition(false)
	        touchLayer:setPosition(ccp(worldPos.x, worldPos.y))
	        touchLayer:changeWidthAndHeight(100, 100)
	        touchLayer:setTouchEnabled(true, 0, true)

	        local function onTrueMaskTap()
	            --点击关闭引导
	            if layer:contains(trueMask) then 
	                layer:removeChild(trueMask)
	            end
	        end

	        local function onTouchLayerTap()
	            --关了自己
	            onTrueMaskTap()
	           	--打开果树面板
				if targetBtn.onClick then 
					targetBtn.onClick()
				end
	        end
	        touchLayer:addEventListener(DisplayEvents.kTouchTap, onTouchLayerTap)
	        trueMask:addChild(touchLayer)

	        trueMask:addEventListener(DisplayEvents.kTouchTap, onTrueMaskTap)

	        local panel = GameGuideUI:panelSUR(Localization:getInstance():getText("tutorial.game.text1600", {n = '\n'}), false, 0)
	        panel:setScale(0.9)
	        local panelPos = panel:getPosition()
	        panel:setPosition(ccp(panelPos.x + 30, worldPos.y+350))
	        local function addTipPanel()
	            trueMask:addChild(panel)
	        end
	        trueMask:runAction(CCSequence:createWithTwoActions(CCDelayTime:create(0.3), CCCallFunc:create(addTipPanel)))

	        local hand = GameGuideAnims:handclickAnim(0.5, 0.3)
	        hand:setScale(0.6)
	        hand:setAnchorPoint(ccp(0, 1))
	        hand:setPosition(ccp(worldPos.x , worldPos.y))
	        hand:setFlipX(true)
	        trueMask:addChild(hand)

	        if layer then
	            layer:addChild(trueMask)
	        end
	    end
    end
    if isInHomeScene then
    	showTutor()
    else
    	scene:showButtonGroup(showTutor)
    end
end
