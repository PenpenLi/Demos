
HomeSceneButtonsManager = class()

HomeSceneButtonType = table.const{
	kNull = 0,
	kBag = 1,
	kFriends = 2,
	kTree = 3,
	kMail = 4,
	kStarReward = 5,
	kMark = 6,
	kTest7 = 7,
	kTest8 = 8,
	kTest9 = 9,
	kTest10 = 10,
	kTest11 = 11,
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
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest10, true)
	-- self:setButtonShowPosState(HomeSceneButtonType.kTest11, true)
	-- UserManager:getInstance().requestNum = 10
	---------------------------------------------
	
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
	self.finalBtnTypeTable[1] = {}
	self.finalBtnTypeTable[2] = {} 
	self.finalBtnTypeTable[3] = {}

	local btnTypeNum = #self.allBtnTypeTable
	if btnTypeNum > 0 and btnTypeNum < 5 then 
		self.bgSizeWidth = (btnTypeNum + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			btnConfig.posX = self.xOriPos - i * self.widthDelta
			btnConfig.posY = self.yOriPos 
			table.insert(self.finalBtnTypeTable[1], btnConfig)
		end
	elseif btnTypeNum == 5 then
		self.bgSizeWidth = (math.floor(btnTypeNum/2) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 2 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			if i <= 2 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos 
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			else
				btnConfig.posX = self.xOriPos - (i-3) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			end
		end
	elseif btnTypeNum == 6 then 
		self.bgSizeWidth = (math.floor(btnTypeNum/2) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 2 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			if i < 3 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			elseif i == 3 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
				local nullConfig = {}
				nullConfig.btnType = HomeSceneButtonType.kNull
				table.insert(self.finalBtnTypeTable[2], nullConfig)
			else
				btnConfig.posX = self.xOriPos - (i-3) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			end
		end
	elseif btnTypeNum == 7 then
		self.bgSizeWidth = (math.floor(btnTypeNum/2) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 2 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			if i <= 3 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos 
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			else
				btnConfig.posX = self.xOriPos - (i-4) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			end
		end
	elseif btnTypeNum == 8 then 
		self.bgSizeWidth = (math.floor(btnTypeNum/2) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 2 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			if i < 4 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			elseif i == 4 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
				local nullConfig = {}
				nullConfig.btnType = HomeSceneButtonType.kNull
				table.insert(self.finalBtnTypeTable[2], nullConfig)
			else
				btnConfig.posX = self.xOriPos - (i-4) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			end
		end
	elseif btnTypeNum == 9 then 
		self.bgSizeWidth = (math.floor(btnTypeNum/2) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 2 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			btnConfig.btnType = v
			if i <= 4 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			else
				btnConfig.posX = self.xOriPos - (i-5) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			end
		end
	elseif btnTypeNum == 10 then 	
		self.bgSizeWidth = (math.floor(btnTypeNum/3) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 3 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			if i <= 3 then 
				btnConfig.posX = self.xOriPos - i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			elseif i > 3 and i < 7 then 
				btnConfig.posX = self.xOriPos - (i-4) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			elseif i == 7 then 
				btnConfig.posX = self.xOriPos - (i-4) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
				local nullConfig = {}
				nullConfig.btnType = HomeSceneButtonType.kNull
				table.insert(self.finalBtnTypeTable[3], nullConfig)
			else
				btnConfig.posX = self.xOriPos - (i-7) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta * 2
				table.insert(self.finalBtnTypeTable[3], btnConfig)
			end
		end
	elseif btnTypeNum == 11 then 
		self.bgSizeWidth = (math.floor(btnTypeNum/3) + 1) * self.widthDelta - self.xOriPos/2
		self.bgSizeHeight = self.heightDelta * 3 + 5

		for i,v in ipairs(self.allBtnTypeTable) do
			local btnConfig = {}
			if i <= 3 then 
				btnConfig.posX = self.xOriPos- i * self.widthDelta
				btnConfig.posY = self.yOriPos
				table.insert(self.finalBtnTypeTable[1], btnConfig)
			elseif i > 3 and i <= 7 then 
				btnConfig.posX = self.xOriPos- (i-4) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta
				table.insert(self.finalBtnTypeTable[2], btnConfig)
			else
				btnConfig.posX = self.xOriPos - (i-8) * self.widthDelta
				btnConfig.posY = self.yOriPos + self.heightDelta * 2
				table.insert(self.finalBtnTypeTable[3], btnConfig)
			end
		end
	end
end

function HomeSceneButtonsManager:setButtonShowPosState(buttonType, showInBar)
	if not buttonType then return end

	local shouldSerialize = false
	if showInBar then 
		if not table.includes(self.allBtnTypeTable, buttonType) then 
			table.insert(self.allBtnTypeTable, buttonType)
			shouldSerialize = true
		end
	else
		local tempTable = {}
		for i,v in ipairs(self.allBtnTypeTable) do
			if v == buttonType then 
				shouldSerialize = true
			else
				table.insert(tempTable, v)
			end
		end
		self.allBtnTypeTable = tempTable
	end
	if shouldSerialize then 
		self:serializeBtnTypeTable()
	end
end

function HomeSceneButtonsManager:addToLayerColor(ui,anchorPoint)
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

--返回值为false则显示在主界面上
function HomeSceneButtonsManager:getStarRewardButtonShowState()
	local rewardLevelToPushMeta = StarRewardModel:getInstance():update().currentPromptReward
	if rewardLevelToPushMeta then
		local curTotalStar = UserManager:getInstance().user:getTotalStar()
		if curTotalStar >= rewardLevelToPushMeta.starNum then
			return false
		else
			return true
		end
	else
		return true
	end
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
		return true
	end
end

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
	if btnType == HomeSceneButtonType.kMail then 
		newBtnIcon = MessageButton:create()
	elseif btnType == HomeSceneButtonType.kStarReward then
		newBtnIcon = StarRewardButton:create()
	elseif btnType == HomeSceneButtonType.kMark then
		newBtnIcon = MarkButton:create()
	elseif btnType == HomeSceneButtonType.kTree then
		newBtnIcon = FruitTreeButton:create()
	end

	local worldOriPos = btn:convertToWorldSpace(ccp(0, 0)) 
	local scene = HomeScene:sharedInstance()
	scene:addChild(newBtnIcon)
	newBtnIcon:setPosition(worldOriPos)
	newBtnIcon = self:addToLayerColor(newBtnIcon, ccp(0.5, 0.5))
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

        local panel = GameGuideUI:panelSUR(Localization:getInstance():getText("tutorial.inactive.icons.hidden", {n = '\n'}), false, 0)
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
