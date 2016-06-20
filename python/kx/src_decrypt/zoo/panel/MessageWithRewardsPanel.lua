require "zoo.panel.basePanel.BasePanel"

MessageWithRewardsPanel = class(BasePanel)

function MessageWithRewardsPanel:create(message, btnText, bottomText, rewards, clickCallback)
	local panel = MessageWithRewardsPanel.new()
	panel:init(message or "", btnText or "", bottomText or "", rewards or {}, clickCallback)
	return panel
end

function MessageWithRewardsPanel:init(message, btnText, bottomText, rewards, clickCallback)
	self:loadRequiredJson(PanelConfigFiles.panel_season_weekly_share)

	local ui = self:buildInterfaceGroup("panels/messagewithonerewardpanel")
	BasePanel.init(self, ui)

	local bg = ui:getChildByName("bg")
	local bg2 = ui:getChildByName("bg2")

	local desc = ui:getChildByName("desc")
	local dimension = desc:getDimensions()
    desc:setDimensions(CCSizeMake(dimension.width, 0))
	desc:setString(message)
	local bottom = ui:getChildByName("bottom")
	bottom:setDimensions(CCSizeMake(0, 0))
	bottom:setString(bottomText)
	local size = bottom:getContentSize()
	bottom:setPositionX((bg:getGroupBounds().size.width - size.width) / 2)

	local button = GroupButtonBase:create(ui:getChildByName("btn"))
	button:setString(btnText)
	local function onBtn() self:getReward(clickCallback) end
	button:addEventListener(DisplayEvents.kTouchTap, onBtn)

	local itemArea = ui:getChildByName("area")
	items = {}
	for k, v in ipairs(rewards) do
		print(v.itemId, v.num)
		local item = self:buildItem(v.itemId, v.num)
		table.insert(items, item)
	end
	self.items = items

	local verticalMargin, borderMargin = 30, 40
	local numInRow, margin = 3, 15
	local fullWidth = 0
	local height = -desc:getPositionY()
	height = height + desc:getContentSize().height + verticalMargin
	itemArea:setPositionY(-height)
	if #items > 0 then
		local margin = 15
		local size = items[1]:getGroupBounds().size
		size = {width = size.width, height = size.height}
		local lastRow = math.ceil(#items / numInRow)
		for k, v in ipairs(items) do
			local curRow = math.ceil(k / numInRow)
			local itemPosX, itemPosY = 0, 0
			if curRow < lastRow then
				itemPosX = (size.width + margin) * ((k - 1) % numInRow)
			else -- lastRow: get total width and then position with addPos
				local itemNum = (#items - 1) % 3 + 1
				local totalWidth = itemNum * size.width + (itemNum - 1) * margin
				fullWidth = numInRow * size.width + (numInRow - 1) * margin
				local baseX = (fullWidth - totalWidth) / 2
				itemPosX = (size.width + margin) * ((k - 1) % numInRow) + baseX
			end
			itemPosY = -(size.height + margin) * (curRow - 1)
			v:setPosition(ccp(itemPosX, itemPosY))
		end
		local layer = Layer:create()
		for k, v in ipairs(items) do layer:addChild(v) end
		local size = layer:getGroupBounds().size
		size = {width = size.width, height = size.height}
		local scale = itemArea:getGroupBounds().size.width / fullWidth
		layer:setScale(scale)
		local pos = itemArea:getPosition()
		layer:setPosition(ccp(pos.x, pos.y))
		ui:addChild(layer)
		height = height + size.height * scale + verticalMargin
	end
	itemArea:removeFromParentAndCleanup(true)
	button:setPositionY(-height - borderMargin - verticalMargin)
	height = height + button:getGroupBounds().size.height
	bottom:setPositionY(-height - borderMargin)
	height = height + bottom:getContentSize().height + borderMargin
	local size = bg:getPreferredSize()
	local size2 = bg2:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(size.width, height + 34))
	bg2:setPreferredSize(CCSizeMake(size2.width, height))

	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()
end

function MessageWithRewardsPanel:buildItem(itemId, itemNum)
	local ui = self:buildInterfaceGroup("panels/bubbleRewardItem")
	local bg = ui:getChildByName("bg")
	local rect = ui:getChildByName("rect")
	local num = ui:getChildByName("num")

	rect:setVisible(false)
	local sprite
	if itemId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
	elseif itemId == 14 then
		sprite = ResourceManager:sharedInstance():buildGroup("Prop_14")
	elseif ItemType:isTimeProp(itemId) then
		sprite = ResourceManager:sharedInstance():buildItemGroup(ItemType:getRealIdByTimePropId(itemId))
	else
		sprite = ResourceManager:sharedInstance():buildItemGroup(itemId)
	end
	local rSize = rect:getGroupBounds().size
	local size = sprite:getGroupBounds().size
	size = {width = size.width, height = size.height}
	local scale = math.min(rSize.width / size.width, rSize.height / size.height)
	sprite:setScale(scale)
	sprite:setPositionX(rect:getPositionX() + (rSize.width - size.width * scale) / 2)
	sprite:setPositionY(rect:getPositionY() - (rSize.height - size.height * scale) / 2)
	ui:addChild(sprite)
	
	num:setText('x'..tostring(itemNum))
	num:setScale(1.5)
	num:setPositionX(bg:getPositionX() + bg:getGroupBounds().size.width - num:getContentSize().width * 1.5)

	ui.sprite = sprite
	ui.itemId = itemId
	ui.num = itemNum

	return ui
end

function MessageWithRewardsPanel:getReward(clickCallback)
	for i,v in ipairs(self.items) do
		local anim
		local parent = v.sprite:getParent()
		local position = parent:convertToWorldSpace(v.sprite:getPosition())
		if v.itemId == 2 then
			local config = {updateButton = true}
			anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
		elseif v.itemId == 14 then
			local config = {updateButton = true, number = math.min(v.num, 10)}
			anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
		elseif v.itemId == 18 then
			local scene = HomeScene:sharedInstance()
			local sprite = ResourceManager:sharedInstance():buildItemGroup(18)
			sprite:setAnchorPoint(ccp(0, 1))
			sprite:setPositionXY(position.x, position.y)
			scene:addChild(sprite)
			local destPosition = ccp(70, 890)
			if scene.summerWeeklyButton then
				local position = scene.summerWeeklyButton:getPosition()
				destPosition = scene.summerWeeklyButton:getParent():convertToWorldSpace(position)
			end
			local size = sprite:getGroupBounds().size
			local config = {
				duration = 0.8,
				sprites = {sprite},
				height = 100,
				dstPosition = destPosition,
				dstSize = CCSizeMake(size.width / 2, size.height / 2),
				easeIn = true,
				finishCallback = function()
						sprite:removeFromParentAndCleanup(true)
					end
			}
			JumpFlyToAnimation:create(config)
			anim = {sprites = {}, play = function(self) end}
		elseif ItemType:isTimeProp(v.itemId) then
			local config = {updateButton = true, propId = ItemType:getRealIdByTimePropId(v.itemId),
				number = math.min(v.num, 10)}
			anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
		else
			local config = {updateButton = true, propId = v.itemId, number = math.min(v.num, 10)}
			anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
		end
		local sprites = {}
		if anim.sprites.is and anim.sprites:is(Layer) then
			table.insert(sprites, anim.sprites)
		else
			for i,v in ipairs(anim.sprites) do
				table.insert(sprites, v)
			end
		end
		local scene = Director:sharedDirector():getRunningSceneLua()
		for j,w in ipairs(sprites) do
			w:setScale(v:getScale())
			w:setPositionXY(position.x, position.y)
			scene:addChild(w)
		end
		anim:play()
	end

	if clickCallback then
		clickCallback()
	else
		self:onCloseBtnTapped()
	end
end

function MessageWithRewardsPanel:popout()
	-- PopoutQueue:sharedInstance():push(self)
	PopoutManager:sharedInstance():add(self)
end

-- function MessageWithRewardsPanel:popoutShowTransition()
-- 	self.allowBackKeyTap = true
-- end

function MessageWithRewardsPanel:onCloseBtnTapped()
	-- self.allowBackKeyTap = false
	PopoutManager:sharedInstance():remove(self)
end