require "zoo.panel.basePanel.BasePanel"
require "zoo.ui.ButtonBuilder"
require "zoo.data.UserManager"
require "zoo.net.OnlineGetterHttp"
require "zoo.net.OnlineSetterHttp"
require "zoo.scenes.component.HomeSceneFlyToAnimation"

GiveBackPanel = class(BasePanel)

function GiveBackPanel:create(index)
	if type(index) ~= "number" then return nil end
	local panel = GiveBackPanel.new()
	panel:loadRequiredJson(PanelConfigFiles.panel_give_back) -- TODO: load resource
	if not panel:_init(index) then panel = nil end
	return panel
end

function GiveBackPanel:_init(index)
	-- data
	local descText, btnText = GiveBackPanelModel:getCompenText(index)
	if type(descText) ~= "string" or string.len(descText) <= 0 then return false end
	local compenData = GiveBackPanelModel:getItemData(index)

	-- panel
	self.panel = self:buildInterfaceGroup("GiveBackPanel")
	BasePanel.init(self, self.panel)

	-- control
	local bg = self.panel:getChildByName("bg")
	local bg2 = self.panel:getChildByName("bg2")
	local desc = self.panel:getChildByName("desc")
	local itemArea = self.panel:getChildByName("itemArea")
	local button = self.panel:getChildByName("button")
	local title = self.panel:getChildByName("title")
	local close = self.panel:getChildByName("close")
	button = GroupButtonBase:create(button)
	self.button = button

	-- strings
	local compenTitle = GiveBackPanelModel:getCompenTitle(index)
	if string.len(compenTitle) > 0 then
		title:setString(compenTitle)
	else
		desc:setPositionY(desc:getPositionY() + 40)
	end
	local dimension = desc:getDimensions()
    desc:setDimensions(CCSizeMake(dimension.width, 0))
	desc:setString(descText)
	button:setString(btnText)

	-- create items
	items = {}
	for k, v in ipairs(compenData) do
		local item = self:_buildItem(v.itemId, v.num)
		item.itemId = v.itemId
		item.num = v.num
		table.insert(items, item)
	end
	self.items = items

	-- layout
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
		self.panel:addChild(layer)
		height = height + size.height * scale + verticalMargin
	end
	itemArea:removeFromParentAndCleanup(true)
	button:setPositionY(-height - borderMargin - verticalMargin)
	height = height + button:getGroupBounds().size.height + borderMargin
	local size = bg:getPreferredSize()
	local size2 = bg2:getPreferredSize()
	bg:setPreferredSize(CCSizeMake(size.width, height + 34))
	bg2:setPreferredSize(CCSizeMake(size2.width, height))

	-- positioning
	self:scaleAccordingToResolutionConfig()
	self:setPositionForPopoutManager()

	-- event listeners
	local function onClose() self:onCloseBtnTapped() end
	close:setTouchEnabled(true)
	close:setButtonMode(true)
	close:addEventListener(DisplayEvents.kTouchTap, onClose)
	local function onBtn() self:_getReward(index) end
	button:addEventListener(DisplayEvents.kTouchTap, onBtn)
	local function onEnterHandler(evt) self:_onEnterHandler(evt) end
	self:registerScriptHandler(onEnterHandler)

	return true
end

function GiveBackPanel:_buildItem(itemId, itemNum)
	local ui = self:buildInterfaceGroup("GiveBackPanel_RewardItem")
	local item = ui:getChildByName("item")
	local rect = ui:getChildByName("rect")
	local num = ui:getChildByName("num")

	local charWidth = 45
	local charHeight = 45
	local charInterval = 24
	local fntFile = "fnt/target_amount.fnt"
	local position = num:getPosition()
	local newLabel = LabelBMMonospaceFont:create(charWidth, charHeight, charInterval, fntFile)
	newLabel:setAnchorPoint(ccp(0,1))
	newLabel:setString("x"..tostring(itemNum))
	local size = newLabel:getContentSize()
	local rcSize = rect:getGroupBounds().size
	local rcPositionX = rect:getPositionX()
	newLabel:setPosition(ccp(rcPositionX + rcSize.width - size.width, position.y))
	ui:addChild(newLabel)
	rect:removeFromParentAndCleanup(true)
	num:removeFromParentAndCleanup(true)

	local position = item:getPosition()
	local sprite
	if itemId == 2 then
		sprite = ResourceManager:sharedInstance():buildGroup("stackIcon")
		sprite:setPositionX(sprite:getPositionX() + 25)
		sprite:setPositionY(sprite:getPositionY() - 15)
	elseif itemId == 14 then
		sprite = Sprite:createWithSpriteFrameName("wheel0000")
		sprite:setScale(1.5)
		local size = ui:getGroupBounds().size
		sprite:setPosition(ccp(size.width / 2 + 10, -size.height / 2))
	else
		sprite = ResourceManager:sharedInstance():buildItemGroup(itemId)
		sprite:setScale(1.2)
		sprite:setPosition(ccp(position.x, position.y))
	end
	item:removeFromParentAndCleanup(true)
	ui.item = sprite
	ui:addChildAt(sprite, 1)

	return ui
end

function GiveBackPanel:popout()
	PopoutQueue.sharedInstance():push(self)
end

local animTime = 0.2
function GiveBackPanel:onCloseBtnTapped()
	if self.isDisposed then return end
	local vOrigin = Director:sharedDirector():getVisibleOrigin()
	local vSize = Director:sharedDirector():getVisibleSize()
	self:stopAllActions()
	self:runAction(CCSpawn:createWithTwoActions(CCMoveTo:create(animTime, ccp(vOrigin.x + vSize.width, vOrigin.y - vSize.height)), CCScaleTo:create(animTime, 0)))
	local function onTimeOut()
		if self.isDisposed or self.exitDisposed then return end
		self.exitDisposed = true
		PopoutManager:sharedInstance():remove(self, true)
	end
	setTimeOut(onTimeOut, animTime)
end

function GiveBackPanel:_onEnterHandler(evt)
	if evt == "enter" then
		local vOrigin = Director:sharedDirector():getVisibleOrigin()
		local vSize = Director:sharedDirector():getVisibleSize()
		local position, scaleX, scaleY = self:getPosition(), self:getScaleX(), self:getScaleY()
		position = {x = position.x, y = position.y}
		self:stopAllActions()
		self:setPosition(ccp(vOrigin.x, vOrigin.y - vSize.height))
		self:setScale(0)
		self:runAction(CCSpawn:createWithTwoActions(CCMoveTo:create(animTime, ccp(position.x, position.y)), CCScaleTo:create(animTime, scaleX, scaleY)))
	elseif evt == "exit" then
		if self.isDisposed or self.exitDisposed then return end
		self.exitDisposed = true
		PopoutManager:sharedInstance():remove(self, true)
	end
end

function GiveBackPanel:_getReward(index)
	local function onSuccess()
		GiveBackPanelModel:resetCompen(index)
		self:_rewardAnim()
		self:onCloseBtnTapped()
	end
	local function onFail(err)
		self.button:setEnabled(true)
		CommonTip:showTip(Localization:getInstance():getText("error.tip."..tostring(err)))
	end
	if RequireNetworkAlert:popout() then
		self.button:setEnabled(false)
		GiveBackPanelModel:getReward(index, onSuccess, onFail)
	end
end

function GiveBackPanel:_rewardAnim()
	local scene = HomeScene:sharedInstance()
	if not scene then return end
	scene:checkDataChange()
	for k, v in ipairs(self.items) do
		if v.itemId == 2 then
			local config = {updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():coinStackAnimation(config)
			local position = v:getPosition()
			local wPosition = v:getParent():convertToWorldSpace(ccp(position.x, position.y))
			anim.sprites:setPosition(ccp(wPosition.x + 100, wPosition.y - 90))
			scene:addChild(anim.sprites)
			anim:play()
		elseif v.itemId == 14 then
			local num = v.num
			if num > 10 then num = 10 end
			local config = {number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():goldFlyToAnimation(config)
			local position = v:getPosition()
			local size = v:getGroupBounds().size
			local wPosition = v:getParent():convertToWorldSpace(ccp(position.x + size.width / 4, position.y - size.height / 4))
			for k, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x, wPosition.y))
				v2:setScaleX(v.item:getScaleX())
				v2:setScaleY(v.item:getScaleY())
				scene:addChild(v2)
			end
			anim:play()
		else
			local num = v.num
			if num > 10 then num = 10 end
			local config = {propId = v.itemId, number = num, updateButton = true,}
			local anim = HomeSceneFlyToAnimation:sharedInstance():jumpToBagAnimation(config)
			local position = v:getPosition()
			local size = v:getGroupBounds().size
			local wPosition = v:getParent():convertToWorldSpace(ccp(position.x + size.width / 8, position.y - size.height / 8))
			for k, v2 in ipairs(anim.sprites) do
				v2:setPosition(ccp(wPosition.x, wPosition.y))
				v2:setScaleX(v.item:getScaleX())
				v2:setScaleY(v.item:getScaleY())
				scene:addChild(v2)
			end
			anim:play()
		end
	end
end

-- GiveBackPanelModel
GiveBackPanelModel = class()

function GiveBackPanelModel:getCompenIndexes()
	print("GiveBackPanelModel:getCompenIndexes")
	local compenList = UserManager:getInstance().compenList
	print("compenList", table.tostring(compenList))
	if type(compenList) ~= "table" or table.maxn(compenList) == 0 then return {} end
	local tmpTable, resTable = {}, {}
	for k, v in pairs(compenList) do
		if type(v.id) == "number" and type(v.compenText) == "string" and string.len(v.compenText) > 0 then
			table.insert(tmpTable, v)
		end
	end
	print("tmpTable", table.tostring(tmpTable))
	UserManager:getInstance().compenList = {}
	for k, v in ipairs(tmpTable) do
		table.insert(resTable, v.id)
		UserManager:getInstance().compenList[v.id] = v
	end
	print("resTable", table.tostring(resTable))
	return resTable
end

function GiveBackPanelModel:getCompenText(index)
	print("GiveBackPanelModel:getCompenText", index)
	local compenList = UserManager:getInstance().compenList
	if type(compenList) ~= "table" or table.maxn(compenList) == 0 then return nil end
	local compen = compenList[index]
	if type(compen) ~= "table" then return nil end
	local compenText = compen.compenText
	if type(compenText) ~= "string" or string.len(compenText) <= 0 then compenText = nil
	else
		local profile = UserManager:getInstance().profile
		local name = Localization:getInstance():getText("give.back.panel.name.default")
		if type(profile) == "table" and type(profile.name) == "string" and string.len(profile.name) > 0 then
			name = HeDisplayUtil:urlDecode(profile.name)
		end
		compenText = string.gsub(compenText, "{name}", tostring(name))
		compenText = string.gsub(compenText, "{n}", '\n')
	end
	local compens = compen.rewards
	if type(compens) ~= "table" or #compens <= 0 then copmens = nil end
	local btnText = Localization:getInstance():getText("give.back.panel.button.notification")
	if compens then btnText = Localization:getInstance():getText("give.back.panel.button.reward") end
	print("compenText", compenText)
	print("btnText", btnText)
	return compenText, btnText
end

function GiveBackPanelModel:getCompenTitle(index)
	local compenList = UserManager:getInstance().compenList
	if type(compenList) ~= "table" or table.maxn(compenList) == 0 then return "" end
	local compen = compenList[index]
	if type(compen) ~= "table" then return "" end
	local compenTitle = compen.compenTitle
	if type(compenTitle) ~= "string" or string.len(compenTitle) <= 0 then compenTitle = "" end
	return compenTitle
end

function GiveBackPanelModel:getItemData(index)
	local compenList = UserManager:getInstance().compenList
	if type(compenList) ~= "table" or table.maxn(compenList) == 0 then return {} end
	local compen = compenList[index]
	if type(compen) ~= "table" then return {} end
	local rewards = compen.rewards
	if type(rewards) ~= "table" or #rewards <= 0 then rewards = {} end
	return rewards
end

function GiveBackPanelModel:resetCompen(index)
	local compenList = UserManager:getInstance().compenList
	if type(compenList) ~= "table" or table.maxn(compenList) == 0 then compenList = {} end
	compenList[index] = nil
	if table.maxn(compenList) == 0 then
		UserManager:getInstance().compenList = nil
	end
end

function GiveBackPanelModel:getReward(index, successCallback, failCallback)
	local function onSuccess(evt)
		if type(UserManager:getInstance().compenList) == "table" then
			local reward = UserManager:getInstance().compenList[index]
			if type(reward) == "table" and type(reward.rewards) == "table" then
				for k, v in ipairs(reward.rewards) do
					if v.itemId == 2 then
						local user = UserManager:getInstance().user
						if type(user) == "table" then
							user:setCoin(user:getCoin() + v.num)
						end
					elseif v.itemId == 14 then
						local user = UserManager:getInstance().user
						if type(user) == "table" then
							user:setCash(user:getCash() + v.num)
						end
					else
						UserManager:getInstance():addUserPropNumber(v.itemId, v.num)
					end
				end
			end
		end
		if type(successCallback) == "function" then successCallback(evt.data) end
	end
	local function onFail(evt)
		if type(failCallback) == "function" then failCallback(evt.data) end
	end
	local http = GetCompenRewardHttp.new(true)
	http:addEventListener(Events.kComplete, onSuccess)
	http:addEventListener(Events.kError, onFail)
	http:load(index)
end